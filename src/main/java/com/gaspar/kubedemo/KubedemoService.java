package com.gaspar.kubedemo;

import jakarta.annotation.PostConstruct;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
public class KubedemoService {

    private UUID applicationId;

    @PostConstruct
    private void init() {
        applicationId = UUID.randomUUID();
    }

    public UUID provideApplicationId() {
        return applicationId;
    }

}
