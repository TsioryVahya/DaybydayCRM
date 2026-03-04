package com.crm.newapp.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/")
@CrossOrigin(origins = "*")
public class DashboardController {

    @Value("${daybydaycrm.api.base-url}")
    private String apiBaseUrl;

    private final RestTemplate restTemplate = new RestTemplate();

    @GetMapping("/dashboard")
    public String dashboardView(Model model) {
        
        Map<String, Object> response = getStats();
        @SuppressWarnings("unchecked")
        Map<String, Object> totals = (Map<String, Object>) response.get("totals");

        Map<String, Object> stats = new HashMap<>();
        stats.put("totalClients", totals.get("clients"));
        stats.put("activeProjects", totals.get("projects"));
        stats.put("pendingTasks", totals.get("tasks"));
        stats.put("openOffers", totals.get("offers"));
        stats.put("unpaidInvoices", totals.get("invoices"));
        stats.put("totalPaymentsMonth", totals.get("payments"));

        model.addAttribute("stats", stats);
        model.addAttribute("recentProjects", getDetails("projects"));
        model.addAttribute("recentInvoices", getDetails("invoices"));

        return "dashboard";
    }

    @GetMapping("/api/stats")
    @ResponseBody
    public Map<String, Object> getStats() {
        String url = joinUrl(apiBaseUrl, "/api/dashboard/stats");
        try {
            @SuppressWarnings("unchecked")
            Map<String, Object> response = restTemplate.getForObject(url, Map.class);
            return response != null ? response : emptyStatsResponse();
        } catch (Exception ex) {
            return emptyStatsResponse();
        }
    }

    @GetMapping("/api/details/{type}")
    @ResponseBody
    public List<Map<String, Object>> getDetails(@PathVariable String type) {
        String url = joinUrl(apiBaseUrl, "/api/dashboard/details/" + type);
        try {
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> response = restTemplate.getForObject(url, List.class);
            return response != null ? response : List.of();
        } catch (Exception ex) {
            return List.of();
        }
    }

    private Map<String, Object> emptyStatsResponse() {
        Map<String, Object> response = new HashMap<>();

        Map<String, Object> totals = new HashMap<>();
        totals.put("clients", 0);
        totals.put("projects", 0);
        totals.put("tasks", 0);
        totals.put("offers", 0);
        totals.put("invoices", 0);
        totals.put("payments", 0);
        totals.put("payment_amount", 0);
        response.put("totals", totals);

        Map<String, Object> graphs = new HashMap<>();
        graphs.put("monthly_invoices", List.of());
        graphs.put("task_status", List.of());
        graphs.put("payment_sources", List.of());
        response.put("graphs", graphs);

        return response;
    }

    private String joinUrl(String baseUrl, String path) {
        if (baseUrl == null || baseUrl.isBlank()) {
            return path;
        }
        String normalizedBase = baseUrl.endsWith("/") ? baseUrl.substring(0, baseUrl.length() - 1) : baseUrl;
        String normalizedPath = path.startsWith("/") ? path : ("/" + path);
        return normalizedBase + normalizedPath;
    }

    private Map<String, Object> createMap(Object... keysValues) {
        Map<String, Object> map = new HashMap<>();
        for (int i = 0; i < keysValues.length; i += 2) {
            map.put(keysValues[i].toString(), keysValues[i + 1]);
        }
        return map;
    }
}
