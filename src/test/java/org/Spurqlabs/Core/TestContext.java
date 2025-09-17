package org.Spurqlabs.Core;

import io.cucumber.java.Scenario;
import io.restassured.response.Response;

import java.util.Dictionary;
import java.util.Hashtable;

public class TestContext {
    public static Scenario scenarioLogger;
    public static String scenarioName;
    public static Dictionary<String, String> stringContext = new Hashtable<>();
    
    // Add a field to store the API response
    private static Response apiResponse;
    
    // Method to set the response
    public static void setResponse(Response response) {
        apiResponse = response;
    }
    
    // Method to get the response
    public static Response getResponse() {
        if (apiResponse == null) {
            throw new RuntimeException("API response is null. Make sure an API request was made before trying to access the response.");
        }
        return apiResponse;
    }
}
