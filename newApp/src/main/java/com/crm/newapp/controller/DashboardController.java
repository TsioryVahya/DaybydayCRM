package com.crm.newapp.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/")
@CrossOrigin(origins = "*")
public class DashboardController {

    @GetMapping("/dashboard")
    public String dashboardView(Model model) {
        // Populate model attributes expected by the Thymeleaf view
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
        Map<String, Object> response = new HashMap<>();
        
        // Mock totals
        Map<String, Object> totals = new HashMap<>();
        totals.put("clients", 124);
        totals.put("projects", 45);
        totals.put("tasks", 87);
        totals.put("offers", 12);
        totals.put("invoices", 15);
        totals.put("payments", 5);
        totals.put("payment_amount", 12450.00);
        response.put("totals", totals);

        // Mock graphs
        Map<String, Object> graphs = new HashMap<>();
        
        // Monthly Invoices
        List<Map<String, Object>> monthlyInvoices = new ArrayList<>();
        monthlyInvoices.add(createMap("month", "January", "count", 5));
        monthlyInvoices.add(createMap("month", "February", "count", 8));
        monthlyInvoices.add(createMap("month", "March", "count", 12));
        graphs.put("monthly_invoices", monthlyInvoices);

        // Task Status
        List<Map<String, Object>> taskStatus = new ArrayList<>();
        taskStatus.add(createMap("label", "Open", "value", 20));
        taskStatus.add(createMap("label", "In Progress", "value", 35));
        taskStatus.add(createMap("label", "Completed", "value", 45));
        graphs.put("task_status", taskStatus);

        // Payment Sources
        List<Map<String, Object>> paymentSources = new ArrayList<>();
        paymentSources.add(createMap("label", "PayPal", "value", 10));
        paymentSources.add(createMap("label", "Bank Transfer", "value", 25));
        paymentSources.add(createMap("label", "Stripe", "value", 15));
        graphs.put("payment_sources", paymentSources);

        response.put("graphs", graphs);
        return response;
    }

    @GetMapping("/api/details/{type}")
    @ResponseBody
    public List<Map<String, Object>> getDetails(@PathVariable String type) {
        List<Map<String, Object>> details = new ArrayList<>();
        LocalDateTime now = LocalDateTime.now();
        
        for (int i = 1; i <= 5; i++) {
            Map<String, Object> item = new HashMap<>();
            item.put("title", "Recent " + type + " #" + i);
            item.put("subtitle", "Sample subtitle for " + type);
            item.put("created_at", now.minusDays(i).toString());
            details.add(item);
        }
        
        return details;
    }

    private Map<String, Object> createMap(Object... keysValues) {
        Map<String, Object> map = new HashMap<>();
        for (int i = 0; i < keysValues.length; i += 2) {
            map.put(keysValues[i].toString(), keysValues[i + 1]);
        }
        return map;
    }
}
