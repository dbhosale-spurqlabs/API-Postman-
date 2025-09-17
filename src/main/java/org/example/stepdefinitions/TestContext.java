package org.example.stepdefinitions;

import io.restassured.response.Response;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class TestContext {
    private Response response;
    private String scenarioId;
    private String scenarioName;
    
    public void setScenarioInfo(String id, String name) {
        this.scenarioId = id;
        this.scenarioName = name;
    }
    
    public void setResponse(Response response) {
        this.response = response;
    }
}