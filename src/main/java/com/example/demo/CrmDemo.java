package com.example.demo;

import com.erp.sdk.facade.ErpDatabaseFacade;
import com.erp.sdk.subsystem.SubsystemName;
import java.util.*;

public class CrmDemo {
    public static void main(String[] args) {
        try (ErpDatabaseFacade facade = new ErpDatabaseFacade(SubsystemName.CRM)) {
            String user = "sales.manager@company.com";

            Map<String, Object> customer = new HashMap<>();
            customer.put("name", "Demo Corp");
            customer.put("email", "demo@corp.com");

            long id = facade.create("customers", customer, user);
            System.out.println("Created customer id=" + id);

            Map<String, Object> loaded = facade.readById("customers", "customer_id", id, user);
            System.out.println("Loaded customer: " + loaded.get("name"));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
