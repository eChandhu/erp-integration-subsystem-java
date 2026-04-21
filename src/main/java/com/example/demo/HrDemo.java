package com.example.demo;

import com.erp.sdk.facade.ErpDatabaseFacade;
import com.erp.sdk.subsystem.SubsystemName;
import java.util.*;

public class HrDemo {
    public static void main(String[] args) {
        try (ErpDatabaseFacade facade = new ErpDatabaseFacade(SubsystemName.HR)) {
            String user = "hr.manager@company.com";

            Map<String, Object> emp = new HashMap<>();
            emp.put("first_name", "Jane");
            emp.put("last_name", "Doe");
            emp.put("email", "jane.doe@example.com");

            long id = facade.create("employees", emp, user);
            System.out.println("Created employee id=" + id);

            Map<String, Object> loaded = facade.readById("employees", "employee_id", id, user);
            System.out.println("Loaded employee: " + loaded.get("first_name") + " " + loaded.get("last_name"));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
