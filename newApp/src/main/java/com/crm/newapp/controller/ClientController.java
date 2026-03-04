package com.crm.newapp.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/clients")
@CrossOrigin(origins = "*")
public class ClientController {

    @Value("${daybydaycrm.api.base-url}")
    private String apiBaseUrl;

    private final RestTemplate restTemplate = new RestTemplate();

    /**
     * Afficher la liste de tous les clients
     */
    @GetMapping
    public String listClients(Model model) {
        String url = joinUrl(apiBaseUrl, "/api/dashboard/details/clients");
        try {
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> clients = restTemplate.getForObject(url, List.class);
            model.addAttribute("clients", clients != null ? clients : List.of());
            model.addAttribute("totalClients", clients != null ? clients.size() : 0);
        } catch (Exception ex) {
            System.err.println("Erreur API: " + ex.getMessage());
            model.addAttribute("clients", List.of());
            model.addAttribute("totalClients", 0);
        }
        return "clients/list";
    }

    /**
     * Afficher le formulaire de création d'un client
     */
    @GetMapping("/create")
    public String createForm(Model model) {
        model.addAttribute("client", new HashMap<>());
        return "clients/form";
    }

    /**
     * Afficher le formulaire d'édition d'un client
     */
    @GetMapping("/{clientId}/edit")
    public String editForm(@PathVariable String clientId, Model model) {
        String url = joinUrl(apiBaseUrl, "/api/clients/" + clientId);
        try {
            @SuppressWarnings("unchecked")
            Map<String, Object> client = restTemplate.getForObject(url, Map.class);
            model.addAttribute("client", client);
            model.addAttribute("isEdit", true);
            return "clients/form";
        } catch (Exception ex) {
            System.err.println("Erreur au chargement du client: " + ex.getMessage());
            return "redirect:/clients";
        }
    }

    /**
     * Sauvegarder un client (création ou modification)
     */
    @PostMapping
    public String saveClient(
            @RequestParam(required = false) String external_id,
            @RequestParam String name,
            @RequestParam String email,
            @RequestParam String company,
            @RequestParam String phone,
            RedirectAttributes redirectAttributes) {
        
        String url = joinUrl(apiBaseUrl, "/clients");
        if (external_id != null && !external_id.isEmpty()) {
            url = joinUrl(apiBaseUrl, "/clients/" + external_id);
        }

        try {
            Map<String, Object> clientData = new HashMap<>();
            clientData.put("name", name);
            clientData.put("email", email);
            clientData.put("company_name", company);
            clientData.put("phone", phone);

            if (external_id != null && !external_id.isEmpty()) {
                // Update via PATCH
                restTemplate.patchForObject(url, clientData, Map.class);
                redirectAttributes.addFlashAttribute("success", "Client modifié avec succès");
            } else {
                // Create via POST
                restTemplate.postForObject(url, clientData, Map.class);
                redirectAttributes.addFlashAttribute("success", "Client créé avec succès");
            }
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de la sauvegarde");
            System.err.println("Erreur: " + ex.getMessage());
        }

        return "redirect:/clients";
    }

    /**
     * Supprimer un client
     */
    @DeleteMapping("/{clientId}")
    public String deleteClient(@PathVariable String clientId, RedirectAttributes redirectAttributes) {
        String url = joinUrl(apiBaseUrl, "/clients/" + clientId);
        try {
            restTemplate.delete(url);
            redirectAttributes.addFlashAttribute("success", "Client supprimé avec succès");
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de la suppression");
            System.err.println("Erreur suppression: " + ex.getMessage());
        }
        return "redirect:/clients";
    }

    /**
     * Afficher les détails d'un client
     */
    @GetMapping("/{clientId}")
    public String viewClient(@PathVariable String clientId, Model model) {
        String url = joinUrl(apiBaseUrl, "/api/clients/" + clientId);
        try {
            @SuppressWarnings("unchecked")
            Map<String, Object> client = restTemplate.getForObject(url, Map.class);
            model.addAttribute("client", client);
            return "clients/detail";
        } catch (Exception ex) {
            System.err.println("Erreur au chargement du client: " + ex.getMessage());
            return "redirect:/clients";
        }
    }

    private String joinUrl(String baseUrl, String path) {
        if (baseUrl == null || baseUrl.isBlank()) {
            return path;
        }
        String normalizedBase = baseUrl.endsWith("/") ? baseUrl.substring(0, baseUrl.length() - 1) : baseUrl;
        String normalizedPath = path.startsWith("/") ? path : ("/" + path);
        return normalizedBase + normalizedPath;
    }
}