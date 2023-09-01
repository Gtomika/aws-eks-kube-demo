package com.gaspar.kubedemo;

import org.hamcrest.CoreMatchers;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;

import static org.hamcrest.Matchers.matchesPattern;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.util.regex.Pattern;

@SpringBootTest
@AutoConfigureMockMvc
class KubeDemoApplicationTests {

	private static final Pattern UUID_PATTERN = Pattern.compile("[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}");

	@Autowired
	private MockMvc mockMvc;

	@Test
	public void shouldReturnSomeApplicationId() throws Exception {
		mockMvc.perform(get("/api/app-id"))
				.andExpect(status().isOk())
				.andExpect(jsonPath("$.appId").value(matchesPattern(UUID_PATTERN)));
	}

}
