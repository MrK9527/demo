package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@SpringBootApplication
public class DemoAppApplication {
    public static void main(String[] args) {
        SpringApplication.run(DemoAppApplication.class, args);
    }
}

@RestController
@RequestMapping("/")
class HelloController {
    @GetMapping
    public String hello() {
        return "Hello, World from Spring Boot!";
    }
}

@Controller
class PageController {
    @GetMapping("/home")
    public String home() {
        return "index"; // templates/index.htmlを表示
    }
}
