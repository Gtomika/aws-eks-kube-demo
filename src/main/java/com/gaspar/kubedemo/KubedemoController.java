package com.gaspar.kubedemo;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class KubedemoController {

    private final KubedemoService kubedemoService;

    @GetMapping("/app-id")
    public AppIdResponse getAppId() {
        return new AppIdResponse(kubedemoService.provideApplicationId().toString());
    }

}
