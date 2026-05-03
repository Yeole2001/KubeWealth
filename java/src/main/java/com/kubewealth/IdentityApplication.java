package com.kubewealth;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.*;
import java.security.Key;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@SpringBootApplication
@RestController
@RequestMapping("/auth")
public class IdentityApplication {

    // In production, this key should come from Kubernetes Secrets!
    private final Key key = Keys.secretKeyFor(SignatureAlgorithm.HS256);

    public static void main(String[] args) {
        SpringApplication.run(IdentityApplication.class, args);
    }

    // A simple DTO class for receiving login data
    public static class LoginRequest {
        public String username;
        public String password;
    }

    @PostMapping("/login")
    public Map<String, String> login(@RequestBody LoginRequest request) {
        Map<String, String> response = new HashMap<>();
        
        // Hardcoded check for our MVP
        if ("atharv".equals(request.username) && "password123".equals(request.password)) {
            
            // Generate the JWT
            String jwt = Jwts.builder()
                    .setSubject(request.username)
                    .setIssuedAt(new Date())
                    .setExpiration(new Date(System.currentTimeMillis() + 3600000)) // 1 Hour Expiration
                    .signWith(key)
                    .compact();

            response.put("token", jwt);
            response.put("status", "success");
        } else {
            response.put("status", "error");
            response.put("message", "Invalid credentials");
        }
        return response;
    }
    
    // A secure endpoint to test if the token works (we will implement the filter later)
    @GetMapping("/verify")
    public String verify() {
        return "Identity Service is running. (JWT validation will be handled at the Ingress/API Gateway level in K8s)";
    }
}