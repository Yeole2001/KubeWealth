package com.kubewealth;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController // This makes the class handle HTTP requests
public class IdentityApplication {

    public static void main(String[] args) {
        SpringApplication.run(IdentityApplication.class, args);
    }

    @GetMapping("/auth")
    public String authenticate() {
        System.out.println("Authenticating user request...");
        return "User Authenticated (Java 17 Service)";
    }
}