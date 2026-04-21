package com.example.demo;

import com.erp.sdk.facade.ErpDatabaseFacade;
import com.erp.sdk.subsystem.SubsystemName;
import java.util.*;

public class ManufacturingDemo {
    public static void main(String[] args) {
        try (ErpDatabaseFacade facade = new ErpDatabaseFacade(SubsystemName.MANUFACTURING)) {
            String user = "production.manager@company.com";

            Map<String, Object> order = new HashMap<>();
            order.put("order_quantity", 10);
            order.put("order_status", "Draft");

            long id = facade.create("production_orders", order, user);
            System.out.println("Created production order id=" + id);

            Map<String, Object> loaded = facade.readById("production_orders", "order_id", id, user);
            System.out.println("Loaded production order status: " + loaded.get("order_status"));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
