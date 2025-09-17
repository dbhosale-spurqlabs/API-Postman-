package org.Spurqlabs.Steps;

import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.restassured.response.Response;
import org.Spurqlabs.Core.TestContext;
import org.Spurqlabs.Utils.*;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;

import static io.restassured.module.jsv.JsonSchemaValidator.matchesJsonSchemaInClasspath;
import static org.Spurqlabs.Utils.DealDetailsManager.replacePlaceholders;
import static org.hamcrest.Matchers.equalTo;


public class CommonSteps extends TestContext {
    private Response response;

    @io.cucumber.java.en.Given("user has a valid sell offer id")
    public void user_has_a_valid_sell_offer_id() {
        // Try to get a valid sell offer id from DealDetailsManager or set a dummy for test
        Object sellOfferId = org.Spurqlabs.Utils.DealDetailsManager.get("sellOfferId");
        if (sellOfferId == null || String.valueOf(sellOfferId).isEmpty()) {
            // Fallback: set a dummy or fetch from API if needed
            sellOfferId = "DUMMY_SELL_OFFER_ID";
        }
        org.Spurqlabs.Utils.DealDetailsManager.put("id", sellOfferId);
    }

    @io.cucumber.java.en.Given("user has a valid deal id")
    public void user_has_a_valid_deal_id() {
        // Try to get a valid deal id from DealDetailsManager or set a dummy for test
        Object dealId = org.Spurqlabs.Utils.DealDetailsManager.get("dealId");
        if (dealId == null || String.valueOf(dealId).isEmpty()) {
            // Fallback: set a dummy or fetch from API if needed
            dealId = "DUMMY_DEAL_ID";
        }
        org.Spurqlabs.Utils.DealDetailsManager.put("dealId", dealId);
    }

    @When("User sends {string} request to {string} with headers {string} and query file {string} and body file {string}")
    public void user_sends_request_to_with_query_file_and_body_file(String method, String url, String headers, String queryFile, String bodyFile) throws IOException {
        // Set scenario name from current scenario
        if (scenarioLogger != null) {
            scenarioName = scenarioLogger.getName();
        } else {
            scenarioName = "Valid Request"; // Default fallback
        }
        String jsonString = Files.readString(Paths.get(FrameworkConfigReader.getFrameworkConfig("DealDetails")), StandardCharsets.UTF_8);
        JSONObject storedValues = new JSONObject(jsonString);
        
        // Store current scenario info for response handling
        boolean isViewSellOffer = url.contains("/api/v2/sell-offers/") && method.equals("GET");
        
        // Debug stored values
        System.out.println("DEBUG - Stored Values in DealDetailsManager:");
        for (String key : storedValues.keySet()) {
            System.out.println("  " + key + ": " + storedValues.get(key));
        }

        // Special debug for Update Sell Offer endpoint
        if (url.contains("/api/v2/sell-offers") && method.equals("PUT")) {
            System.out.println("DEBUG: Processing Update Sell Offer request");
            System.out.println("DEBUG: Original URL: " + url);
            System.out.println("DEBUG: Available IDs in DealDetailsManager:");
            System.out.println("  - id: " + storedValues.opt("id"));
            System.out.println("  - sellOfferId: " + storedValues.opt("sellOfferId"));
            System.out.println("  - secondaryDealId: " + storedValues.opt("secondaryDealId"));
        }

        // Replace URL placeholders
        String processedUrl = url;
        for (String key : storedValues.keySet()) {
            String placeholder = "{" + key + "}";
            if (processedUrl.contains(placeholder)) {
                processedUrl = processedUrl.replace(placeholder, storedValues.getString(key));
                TestContextLogger.scenarioLog("DEBUG", "Replaced " + placeholder + " with " + storedValues.getString(key));
            }
        }
        
        String fullUrl = FrameworkConfigReader.getFrameworkConfig("BaseUrl") + processedUrl;
        TestContextLogger.scenarioLog("DEBUG", "Final URL: " + fullUrl);

        // Special debug for Update Sell Offer endpoint
        if (url.contains("/api/v2/sell-offers") && method.equals("PUT")) {
            System.out.println("DEBUG: Final URL after replacement: " + fullUrl);
        }

        Map<String, String> header = new HashMap<>();
        if (!"NA".equalsIgnoreCase(headers)) {
            header = JsonFileReader.getHeadersFromJson(FrameworkConfigReader.getFrameworkConfig("headers") + headers + ".json");
        } else {
            header.put("cookie", TokenManager.getToken());
            // Add Content-Type header for PUT requests
            if (method.equals("PUT")) {
                header.put("Content-Type", "application/json");
                header.put("Accept", "application/json");
            }
        }

        Map<String, String> queryParams = new HashMap<>();
        try {
            // Only process query parameters if queryFile is provided and not "NA"
            if (queryFile != null && !"NA".equalsIgnoreCase(queryFile.trim())) {
                String queryPath = FrameworkConfigReader.getFrameworkConfig("Query_Parameters") + queryFile;
                
                // Handle both with and without extension
                if (!queryPath.contains(".")) {
                    queryPath += ".json";
                }
                
                Map<String, String> loadedParams = JsonFileReader.getQueryParamsFromJson(queryPath);
                if (loadedParams != null && !loadedParams.isEmpty()) {
                    // Replace any placeholders in the values
                    for (Map.Entry<String, String> entry : loadedParams.entrySet()) {
                        String value = entry.getValue();
                        for (String storedKey : storedValues.keySet()) {
                            value = value.replace("{" + storedKey + "}", storedValues.getString(storedKey));
                        }
                        queryParams.put(entry.getKey(), value);
                    }
                    TestContextLogger.scenarioLog("DEBUG", "Loaded query parameters: " + queryParams);
                }
            }
        } catch (Exception e) {
            TestContextLogger.scenarioLog("WARNING", "Error processing query parameters: " + e.getMessage());
        }

        Object requestBody = null;
        if (!"NA".equalsIgnoreCase(bodyFile)) {
            String bodyTemplate = JsonFileReader.getJsonAsString(
                    FrameworkConfigReader.getFrameworkConfig("Request_Bodies") + bodyFile + ".json");

            // Special debug for Update Sell Offer request body
            if (url.contains("/api/v2/sell-offers") && method.equals("PUT")) {
                System.out.println("DEBUG: Original request body template:");
                System.out.println(bodyTemplate);
                System.out.println("DEBUG: Looking for placeholders to replace...");
            }

            for (String key : storedValues.keySet()) {
                String placeholder = "{" + key + "}";
                if (bodyTemplate.contains(placeholder)) {
                    if (url.contains("/api/v2/sell-offers") && method.equals("PUT")) {
                        System.out.println("DEBUG: Replacing placeholder " + placeholder + " with value: " + storedValues.getString(key));
                    }
                    bodyTemplate = bodyTemplate.replace(placeholder, storedValues.getString(key));
                }
            }

            requestBody = bodyTemplate;
            // Print the request body for debugging
            if (url.contains("/api/v2/sell-offers") && method.equals("PUT")) {
                System.out.println("DEBUG: Final request body after placeholder replacement:");
                System.out.println(requestBody);
            }
        }

        // Print URL and headers for debugging
        System.out.println("Full Request URL: " + fullUrl);
        System.out.println("Headers: " + header);
        // Debug for query parameters
        System.out.println("Query Parameters: " + queryParams);
        if (queryFile != null && !queryFile.equalsIgnoreCase("NA")) {
            System.out.println("Query File Used: " + FrameworkConfigReader.getFrameworkConfig("Query_Parameters") + queryFile + ".json");
        }
        
        // Special debugging for DataRoom Activity
        if (url.contains("dataroom") && url.contains("activity")) {
            System.out.println("DEBUG - DataRoom Activity Request:");
            System.out.println("  - URL: " + fullUrl);
            System.out.println("  - Headers: " + header);
            System.out.println("  - Query Params: " + queryParams);
            System.out.println("  - Request Body: " + requestBody);
            System.out.println("  - SecondarydataRoomId from DealDetails: " + DealDetailsManager.get("SecondarydataRoomId"));
            System.out.println("  - user_id from request body: " + (requestBody != null && requestBody.toString().contains("user_id") ? 
                               requestBody.toString().replaceAll(".*\"user_id\"\\s*:\\s*\"([^\"]*)\".*", "$1") : "Not found"));
        }

        response = APIUtility.sendRequest(method, fullUrl, header, queryParams, requestBody);
        response.prettyPrint();
        TestContextLogger.scenarioLog("API", "Request sent: " + method + " " + fullUrl);
        
        // Store the response in TestContext for other step definitions to access
        TestContext.setResponse(response);
        
        // Additional debugging
        System.out.println("Response Status Code: " + response.getStatusCode());
        System.out.println("Response Headers: " + response.getHeaders());
        
        // Special debugging for DataRoom Activity responses
        if (url.contains("dataroom") && url.contains("activity")) {
            System.out.println("DEBUG - DataRoom Activity Response:");
            System.out.println("  - Status Code: " + response.getStatusCode());
            System.out.println("  - Status Line: " + response.getStatusLine());
            System.out.println("  - Content Type: " + response.getContentType());
            System.out.println("  - Response Body: " + response.getBody().asString());
            if (response.getStatusCode() == 403) {
                System.out.println("  - PERMISSION DENIED (403). Check if:");
                System.out.println("    1. Authentication token is valid");
                System.out.println("    2. User has permission to access this dataroom");
                System.out.println("    3. User ID in request body matches an authorized user");
                System.out.println("    4. The dataroom ID is valid and exists");
            }
        }

        // Handle View Sell Offer response to extract dataRoomId
        if (isViewSellOffer && response.getStatusCode() == 200) {
            try {
                // Extract dataRoomId from response body
                String responseBody = response.getBody().asString();
                JSONObject jsonResponse = new JSONObject(responseBody);
                String dataRoomId = jsonResponse.optString("dataRoomId");
                
                if (dataRoomId != null && !dataRoomId.isEmpty()) {
                    // Store with both cases to ensure compatibility
                    DealDetailsManager.dealDetails.put("secondoryroomid", dataRoomId);
                    DealDetailsManager.dealDetails.put("secondaryRoomId", dataRoomId);
                    // Write to file
                    Files.writeString(Paths.get(FrameworkConfigReader.getFrameworkConfig("DealDetails")), 
                        DealDetailsManager.dealDetails.toString(), StandardCharsets.UTF_8);
                    TestContextLogger.scenarioLog("API", "Successfully stored dataRoomId: " + dataRoomId);
                    
                    // Additional debug logging
                    System.out.println("DEBUG - Extracted and stored dataRoomId:");
                    System.out.println("  - dataRoomId from response: " + dataRoomId);
                    System.out.println("  - Stored under keys: secondoryroomid, secondaryRoomId");
                } else {
                    TestContextLogger.scenarioLog("WARNING", "dataRoomId not found in response");
                }
            } catch (Exception e) {
                TestContextLogger.scenarioLog("WARNING", "Failed to extract dataRoomId: " + e.getMessage());
            }
        }

        // Handle other scenario responses
        if (scenarioName.contains("GET Notes") && response.getStatusCode() == 200) {
            DealDetailsManager.put("noteId", response.path("[0].id"));
        }
        if (scenarioName.contains("Tranche Overview1") && response.getStatusCode() == 200) {
            DealDetailsManager.put("investorInterestID", response.path("trancheList[0].investorsInterests[0].id"));
        }
        if (scenarioName.contains("Permission of Folder") && response.getStatusCode() == 200) {
            DealDetailsManager.put("dataRoomRootFolderID", response.path("data.root_folder_id"));
        }
        if (scenarioName.contains("Folder Structure") && response.getStatusCode() == 200) {
            DealDetailsManager.put("dataRoomFolderId", response.path("data.folder_id"));
        }
        if (scenarioName.contains("Folder Structure") && response.getStatusCode() == 200) {
            DealDetailsManager.put("dataRoomFileId", response.path("data.resources[0].id"));
        }
        if (scenarioName.contains("Existing Folder Permission") && response.getStatusCode() == 200) {
            DealDetailsManager.put("dataRoomFileResourceID", response.path("data.resources[0].id"));
        }
        if (scenarioName.contains("Group Permission File") && response.getStatusCode() == 200) {
            DealDetailsManager.put("dataRoomDealTeamId", response.path("data.permissions[0].id"));
        }
        if (scenarioName.contains("Group Permission File") && response.getStatusCode() == 200) {
            DealDetailsManager.put("dataRoomAllInviteesId", response.path("data.permissions[1].id"));
        }
        if (scenarioName.contains("Data Room Document") && response.getStatusCode() == 200) {
            DealDetailsManager.put("dataRoomDocID", response.path("data.documentId"));
        }
        if (scenarioName.contains("DataRoom Create Group") && response.getStatusCode() == 200) {
            DealDetailsManager.put("dataRoomNewGroupId", response.path("data.id"));
        }
        if (scenarioName.contains("DataRoom Org List") && response.getStatusCode() == 200) {
            DealDetailsManager.put("dataRoomOrgId", response.path("data[0].id"));
        }
        if (scenarioName.contains("DataRoom Get Org Permission") && response.getStatusCode() == 200) {
            DealDetailsManager.put("dataRoomChildFolderID", response.path("data.children[1].id"));
        }
        if (scenarioName.contains("DataRoom Admin User Permission") && response.getStatusCode() == 200) {
            DealDetailsManager.put("dataRoomAdminId", response.path("data[0].id"));
        }
        if (scenarioName.contains("DataRoom Org List") && response.getStatusCode() == 200) {
            DealDetailsManager.put("dataRoomUserId", response.path("data[1].users[0].id"));
        }
        if (scenarioName.contains("DataRoom Folder Permission MP Get") && response.getStatusCode() == 200) {
            DealDetailsManager.put("dataRoomfolderMPID1", response.path("data.permissions[0].id"));
        }
        if (scenarioName.contains("DataRoom Folder Permission MP Get") && response.getStatusCode() == 200) {
            DealDetailsManager.put("dataRoomfolderMPID2", response.path("data.permissions[1].id"));
        }
        if (scenarioName.contains("DataRoom Get Org Permission") && response.getStatusCode() == 200) {
            DealDetailsManager.put("dataRoomChildFileID", response.path("data.children[0].id"));
        }
        if (scenarioName.contains("Group Permission File") && response.getStatusCode() == 200) {
            DealDetailsManager.put("dataRoomFileGroupID1", response.path("data.permissions[0].id"));
        }
        if (scenarioName.contains("Group Permission File") && response.getStatusCode() == 200) {
            DealDetailsManager.put("dataRoomFileGroupID2", response.path("data.permissions[1].id"));
        }
        if (scenarioName.contains("DataRoom Create Group") && response.getStatusCode() == 200) {
            DealDetailsManager.put("dealCreatorGroupID", response.path("data.id"));
        }
          if (scenarioName.contains("View Sell Offer") && response.getStatusCode() == 200) {
            // Store the publish ID
            DealDetailsManager.put("secondoryPublishid", response.path("data.id"));
            
            // Extract and store dataRoomId from response
            String dataRoomId = response.path("dataRoomId");
            System.out.println("DEBUG - Response body: " + response.getBody().asString());
            System.out.println("DEBUG - Attempting to extract dataRoomId");
            
            if (dataRoomId == null || dataRoomId.isEmpty()) {
                // Try alternative path if first attempt returns null
                dataRoomId = response.path("data.dataRoomId");
            }
            
            if (dataRoomId != null && !dataRoomId.isEmpty()) {
                // Store the dataRoomId in DealDetails
                DealDetailsManager.dealDetails.put("secondoryroomid", dataRoomId);
                // Also store with alternative key for compatibility
                DealDetailsManager.dealDetails.put("secondaryRoomId", dataRoomId);
                
                // Write updates to file immediately
                try {
                    Files.writeString(Paths.get(FrameworkConfigReader.getFrameworkConfig("DealDetails")), 
                        DealDetailsManager.dealDetails.toString(), StandardCharsets.UTF_8);
                    System.out.println("DEBUG - Successfully stored dataRoomId: " + dataRoomId);
                    System.out.println("DEBUG - DealDetails content: " + DealDetailsManager.dealDetails.toString());
                } catch (IOException e) {
                    System.out.println("ERROR - Failed to write to DealDetails file: " + e.getMessage());
                }
            } else {
                System.out.println("ERROR - Could not find dataRoomId in response");
                System.out.println("DEBUG - Available paths in response: ");
                response.prettyPeek();
            }
        }
      
    }
 
    @Then("User verifies the response status code is {int}")
    public void userVerifiesTheResponseStatusCodeIsStatusCode(int statusCode) {
        response.then().statusCode(statusCode);
        TestContextLogger.scenarioLog("API", "Response status code: " + statusCode);
    }

    @Then("User verifies the response body matches JSON schema {string}")
    public void userVerifiesTheResponseBodyMatchesJSONSchema(String schemaFile) {
        if (!"NA".equalsIgnoreCase(schemaFile)) {
            String schemaPath = "Schema/" + schemaFile + ".json";
            response.then().assertThat().body(matchesJsonSchemaInClasspath(schemaPath));
            TestContextLogger.scenarioLog("API", "Response body matches schema");
        } else {
            TestContextLogger.scenarioLog("API", "Response body does not have schema to validate");
        }
    }

    @Then("User verifies field {string} has value {string}")
    public void userVerifiesFieldHasValue(String jsonPath, String expectedValue) {
        response.then().body(jsonPath, equalTo(expectedValue));
        TestContextLogger.scenarioLog("API", "Field " + jsonPath + " has value: " + expectedValue);
    }

    @Then("User verifies fields in response: {string} with content type {string}")
    public void userVerifiesFieldsInResponseWithContentType(String contentType, String fields) throws IOException {
        // If NA, skip verification
        if ("NA".equalsIgnoreCase(contentType) || "NA".equalsIgnoreCase(fields)) {
            return;
        }
        
        // Debug - print the response for troubleshooting
        System.out.println("DEBUG - Response body for verification:");
        System.out.println(response.getBody().asPrettyString());
        
        String responseStr = response.getBody().asString().trim();

        try {
            if ("text".equalsIgnoreCase(contentType)) {
                // For text, verify each expected value is present in response
                for (String expected : fields.split(";")) {
                    expected = replacePlaceholders(expected.trim());
                    if (!responseStr.contains(expected)) {
                        throw new AssertionError("Expected text not found: " + expected);
                    }
                    TestContextLogger.scenarioLog("API", "Text found: " + expected);
                }
            } else if ("json".equalsIgnoreCase(contentType)) {
                // For json, verify key=value pairs
                JSONObject jsonResponse;
                if (responseStr.startsWith("[")) {
                    JSONArray arr = new JSONArray(responseStr);
                    jsonResponse = !arr.isEmpty() ? arr.getJSONObject(0) : new JSONObject();
                } else {
                    jsonResponse = new JSONObject(responseStr);
                }
                for (String pair : fields.split(";")) {
                    if (pair.trim().isEmpty()) continue;
                    String[] kv = pair.split("=", 2);
                    if (kv.length < 2) continue;
                    String keyPath = kv[0].trim();
                    String expected = replacePlaceholders(kv[1].trim());
                    Object actual = JsonFileReader.getJsonValueByPath(jsonResponse, keyPath);
                    if (actual == null) {
                        throw new AssertionError("Key not found in JSON: " + keyPath);
                    }
                    if (!String.valueOf(actual).equals(String.valueOf(expected))) {
                        throw new AssertionError("Mismatch for " + keyPath + ": expected '" + expected + "', got '" + actual + "'");
                    }
                    TestContextLogger.scenarioLog("API", "Validated: " + keyPath + " = " + expected);
                }
            } else {
                throw new AssertionError("Unsupported content type: " + contentType);
            }
        } catch (AssertionError | Exception e) {
            TestContextLogger.scenarioLog("API", "Validation failed: " + e.getMessage());
            throw e;
        }
    }

    @When("User uploads file using {string} request to {string} with headers {string} and file {string} and fileName {string}")
    public void userUploadsFile(String method, String url, String headers, String filePath, String fileName) throws IOException {
        String fullUrl = FrameworkConfigReader.getFrameworkConfig("BaseUrl") + url;

        Map<String, String> header = new HashMap<>();
        if (!"NA".equalsIgnoreCase(headers)) {
            header = JsonFileReader.getHeadersFromJson(FrameworkConfigReader.getFrameworkConfig("headers") + headers + ".json");
        } else {
            header.put("cookie", TokenManager.getToken());
        }

        File fileToUpload = null;
        if (!"NA".equalsIgnoreCase(filePath)) {
            fileToUpload = new File(FrameworkConfigReader.getFrameworkConfig("Files_Path") + filePath);
        }

        Map<String, Object> multipartParams = new HashMap<>();
        if (fileToUpload != null) {
            multipartParams.put("fileBody", fileToUpload);
        }
        multipartParams.put("fileName", fileName);

        response = APIUtility.sendMultipartRequest(fullUrl, header, multipartParams);
        response.prettyPrint();
        TestContextLogger.scenarioLog("API", "Request sent: " + method + " " + fullUrl);
    }
}
