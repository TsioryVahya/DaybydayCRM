<?php

namespace App\Api\v1\Controllers;

use App\Models\Client;
use App\Models\Contact;
use App\Models\Industry;
use App\Models\User;
use App\Services\ClientNumber\ClientNumberService;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;
use Ramsey\Uuid\Uuid;

class ClientController extends ApiController
{
    public function index()
    {
        $clients = Client::with(['primaryContact'])
            ->orderByDesc('created_at')
            ->take(100)
            ->get();

        $data = $clients->map(function (Client $client) {
            return [
                'id' => $client->id,
                'external_id' => $client->external_id,
                'company_name' => $client->company_name,
                'address' => $client->address,
                'zipcode' => $client->zipcode,
                'city' => $client->city,
                'vat' => $client->vat,
                'company_type' => $client->company_type,
                'client_number' => $client->client_number,
                'user_id' => $client->user_id,
                'industry_id' => $client->industry_id,
                'deleted_at' => $client->deleted_at,
                'created_at' => $client->created_at,
                'updated_at' => $client->updated_at,
            ];
        })->values();

        return $this->respond($data);
    }

    public function show($external_id)
    {
        $client = Client::with(['primaryContact'])->where('external_id', $external_id)->firstOrFail();
        return $this->respond([
            'id' => $client->id,
            'external_id' => $client->external_id,
            'company_name' => $client->company_name,
            'address' => $client->address,
            'zipcode' => $client->zipcode,
            'city' => $client->city,
            'vat' => $client->vat,
            'company_type' => $client->company_type,
            'client_number' => $client->client_number,
            'user_id' => $client->user_id,
            'industry_id' => $client->industry_id,
            'deleted_at' => $client->deleted_at,
            'created_at' => $client->created_at,
            'updated_at' => $client->updated_at,
        ]);
    }

    public function store(Request $request)
    {
        $userId = $request->input('user_id') ?: optional(auth()->user())->id ?: User::query()->value('id');
        $industryId = $request->input('industry_id') ?: Industry::query()->value('id');

        if (!$userId) {
            return $this->respondError('Missing user_id and no default user found', 422);
        }
        if (!$industryId) {
            return $this->respondError('Missing industry_id and no default industry found', 422);
        }

        $companyName = $request->input('company_name') ?: $request->input('company');
        $name = $request->input('name');
        $email = $request->input('email');
        $phone = $request->input('primary_number') ?: $request->input('phone');

        if (!$companyName || !$name || !$email) {
            return $this->respondError('Missing required fields: company_name/company, name, email', 422);
        }

        try {
            $client = DB::transaction(function () use ($companyName, $userId, $industryId, $name, $email, $phone) {
                $client = Client::create([
                    'external_id' => Uuid::uuid4()->toString(),
                    'company_name' => $companyName,
                    'address' => request()->input('address'),
                    'zipcode' => request()->input('zipcode'),
                    'city' => request()->input('city'),
                    'vat' => request()->input('vat'),
                    'company_type' => request()->input('company_type'),
                    'user_id' => $userId,
                    'industry_id' => $industryId,
                    'client_number' => app(ClientNumberService::class)->setNextClientNumber(),
                ]);

                Contact::create([
                    'external_id' => Uuid::uuid4()->toString(),
                    'name' => $name,
                    'email' => $email,
                    'primary_number' => $phone,
                    'secondary_number' => null,
                    'client_id' => $client->id,
                    'is_primary' => true,
                ]);

                return $client;
            });

            return $this->show($client->external_id);
        } catch (\Exception $e) {
            return $this->respondError('Failed to create client', 500);
        }
    }

    public function update($external_id, Request $request)
    {
        $client = Client::with(['primaryContact'])->where('external_id', $external_id)->firstOrFail();

        $companyName = $request->input('company_name') ?: $request->input('company');
        $name = $request->input('name');
        $email = $request->input('email');
        $phone = $request->input('primary_number') ?: $request->input('phone');

        try {
            DB::transaction(function () use ($client, $companyName, $name, $email, $phone) {
                if ($companyName !== null) {
                    $client->company_name = $companyName;
                }

                if (request()->has('address')) {
                    $client->address = request()->input('address');
                }
                if (request()->has('zipcode')) {
                    $client->zipcode = request()->input('zipcode');
                }
                if (request()->has('city')) {
                    $client->city = request()->input('city');
                }
                if (request()->has('vat')) {
                    $client->vat = request()->input('vat');
                }
                if (request()->has('company_type')) {
                    $client->company_type = request()->input('company_type');
                }

                $client->save();

                $contact = $client->primaryContact;
                if (!$contact) {
                    Contact::create([
                        'external_id' => Uuid::uuid4()->toString(),
                        'name' => $name ?: '',
                        'email' => $email ?: '',
                        'primary_number' => $phone,
                        'secondary_number' => null,
                        'client_id' => $client->id,
                        'is_primary' => true,
                    ]);
                } else {
                    if ($name !== null) {
                        $contact->name = $name;
                    }
                    if ($email !== null) {
                        $contact->email = $email;
                    }
                    if ($phone !== null) {
                        $contact->primary_number = $phone;
                    }
                    $contact->save();
                }
            });

            return $this->show($external_id);
        } catch (\Exception $e) {
            return $this->respondError('Failed to update client', 500);
        }
    }

    public function destroy($external_id)
    {
        try {
            $client = Client::where('external_id', $external_id)->firstOrFail();
            $client->delete();
            return $this->respondNoContent();
        } catch (\Exception $e) {
            return $this->respondError('Failed to delete client', 500);
        }
    }
}
