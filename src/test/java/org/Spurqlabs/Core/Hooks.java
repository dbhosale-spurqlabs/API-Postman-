package org.Spurqlabs.Core;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;

import org.Spurqlabs.Utils.APIUtility;
import org.Spurqlabs.Utils.DealDetailsManager;
import org.Spurqlabs.Utils.FrameworkConfigReader;
import static org.Spurqlabs.Utils.FrameworkConfigReader.getFrameworkConfig;
import org.Spurqlabs.Utils.JsonFileReader;
import org.Spurqlabs.Utils.ScenarioResultCollector;
import org.Spurqlabs.Utils.TestContextLogger;
import org.Spurqlabs.Utils.TokenManager;
import org.json.JSONObject;

import io.cucumber.java.After;
import io.cucumber.java.Before;
import io.cucumber.java.BeforeAll;
import io.cucumber.java.Scenario;
import io.restassured.response.Response;

public class Hooks extends TestContext {
    
    private static final Map<String, String> headers = new HashMap<>();
    protected Scenario scenarioLogger;
    protected String scenarioName;
    private static String configBaseUrl;
    private static String draftEndpoint;
    private static String publishEndpoint;
    private static String viewEndpoint;
    private static String configDraftMethod;

    static {
        configBaseUrl = getFrameworkConfig("BaseUrl");
        draftEndpoint = getFrameworkConfig("DraftSellOfferEndpoint");
        publishEndpoint = getFrameworkConfig("PublishSellOfferEndpoint");
        viewEndpoint = getFrameworkConfig("ViewSellOfferEndpoint");
        configDraftMethod = getFrameworkConfig("DraftSellOfferMethod");
        
        if (configBaseUrl == null || draftEndpoint == null || publishEndpoint == null || 
            viewEndpoint == null || configDraftMethod == null) {
            throw new IllegalStateException("Missing required configuration in Hooks initialization");
        }
    }
    
    public void extractDraftSellOfferId(Response response) {
        String locationHeader = response.getHeader("Location");
        if (locationHeader != null && locationHeader.contains("/sell-offers/")) {
            String sellOfferId = locationHeader.substring(locationHeader.lastIndexOf("/") + 1);
            DealDetailsManager.put("sellOfferId", sellOfferId);
        }
    }

    public void extractPublishedSellOfferId(Response response) {
        if (response.getStatusCode() == 200) {
            // For publish endpoint, we use the same ID that was passed in the URL
            String sellOfferId = String.valueOf(DealDetailsManager.get("id"));
            if (sellOfferId != null && !sellOfferId.equals("null") && !sellOfferId.trim().isEmpty()) {
                DealDetailsManager.put("publishedSellOfferId", sellOfferId);
                TestContextLogger.scenarioLog("API", "Saved publishedSellOfferId: " + sellOfferId);
            }
        }
    }

    public void extractDataRoomId(Response response) {
        if (response.getStatusCode() == 200) {
            JSONObject jsonResponse = new JSONObject(response.getBody().asString());
            String dataRoomId = jsonResponse.optString("dataRoomId");
            String id = jsonResponse.optString("id");
            
            if (!dataRoomId.isEmpty()) {
                // Store in memory
                DealDetailsManager.put("secondoryroomid", dataRoomId); // Store with the key used in feature file
                TestContextLogger.scenarioLog("API", "Extracted dataRoomId: " + dataRoomId);
                
                try {
                    // Read existing DealDetails.json
                    String dealDetailsPath = FrameworkConfigReader.getFrameworkConfig("DealDetails");
                    String jsonContent = new String(Files.readAllBytes(Paths.get(dealDetailsPath)));
                    JSONObject dealDetails = new JSONObject(jsonContent);
                    
                    // Update the JSON with new dataRoomId and publishsellid
                    dealDetails.put("secondoryroomid", dataRoomId);
                    if (!id.isEmpty()) {
                        DealDetailsManager.put("publishsellid", id);
                        dealDetails.put("publishsellid", id);
                        TestContextLogger.scenarioLog("API", "Stored ID as publishsellid: " + id);
                    }
                    
                    // Write back to file
                    Files.write(Paths.get(dealDetailsPath), dealDetails.toString(2).getBytes());
                    TestContextLogger.scenarioLog("API", "Updated DealDetails.json with dataRoomId and publishsellid");
                } catch (Exception e) {
                    TestContextLogger.scenarioLog("ERROR", "Failed to update DealDetails.json: " + e.getMessage());
                    throw new RuntimeException("Failed to update DealDetails.json", e);
                }
            }
        }
    }



 
  
 
    @BeforeAll
    public static void executeSetupProcess() throws IOException {
        try {
            TestContextLogger.scenarioLog("API", "Starting test setup process");

            // Get authentication token
            String token = TokenManager.getToken();
            if (token == null || token.trim().isEmpty()) {
                throw new IllegalStateException("Failed to get valid authentication token");
            }
            TestContextLogger.scenarioLog("API", "Successfully retrieved authentication token");

            headers.clear();
            headers.put("cookie", token);
            headers.put("Accept", "application/json");
            headers.put("Content-Type", "application/json");

            // Step 1: Create Draft
            String draftMethod = getFrameworkConfig("DraftMethod");
            String draftUrlPath = getFrameworkConfig("DraftUrl");
            
            if (configDraftMethod == null || configBaseUrl == null || draftUrlPath == null) {
                throw new IllegalStateException("Missing required configuration: DraftMethod, BaseUrl, or DraftUrl");
            }

            String draftUrl = configBaseUrl + draftUrlPath;
            TestContextLogger.scenarioLog("API", "Creating draft at: " + draftUrl);
            String requestBodyPath = getFrameworkConfig("Request_Bodies") + getFrameworkConfig("DraftRequestBody");
            Object draftRequestBody = JsonFileReader.getJsonAsString(requestBodyPath);
            
            if (draftRequestBody == null) {
                throw new IllegalStateException("Failed to read draft request body from: " + requestBodyPath);
            }

            Response draftResponse = APIUtility.sendRequest(draftMethod, draftUrl, headers, null, draftRequestBody);
            if (draftResponse == null) {
                throw new IllegalStateException("No response received from draft creation request");
            }

            if (draftResponse.getStatusCode() != 200 && draftResponse.getStatusCode() != 201) {
                throw new IllegalStateException("Draft creation failed with status code: " + draftResponse.getStatusCode() + 
                    ", Response: " + draftResponse.getBody().asString());
            }

            String locationId = draftResponse.getHeader("Location");
            if (locationId == null || locationId.trim().isEmpty()) {
                throw new IllegalStateException("No Location header in draft response. Status code: " + draftResponse.getStatusCode() + 
                    ", Response: " + draftResponse.getBody().asString());
            }

            TestContextLogger.scenarioLog("API", "Successfully created draft with Location: " + locationId);

            // Step 2: Primary Setup
            String primarySetupMethod = getFrameworkConfig("PrimarySetupMethod");
            if (primarySetupMethod == null) {
                throw new IllegalStateException("PrimarySetupMethod not found in FrameworkConfig");
            }

            String primarySetupUrlTemplate = getFrameworkConfig("PrimarySetupUrl");
            if (primarySetupUrlTemplate == null) {
                throw new IllegalStateException("PrimarySetupUrl not found in FrameworkConfig");
            }

            String primarySetupUrl = configBaseUrl + primarySetupUrlTemplate.replace("{locationId}", locationId);
            TestContextLogger.scenarioLog("API", "Setting up primary configuration at: " + primarySetupUrl);

            String primarySetupBodyPath = getFrameworkConfig("Request_Bodies") + getFrameworkConfig("PrimarySetupRequestBody");
            String primarySetupRequestBodyStr = JsonFileReader.getJsonAsString(primarySetupBodyPath);
            
            if (primarySetupRequestBodyStr == null) {
                throw new IllegalStateException("Failed to read primary setup request body from: " + primarySetupBodyPath);
            }

            JSONObject primarySetupRequestBodyJson = new JSONObject(primarySetupRequestBodyStr);
            String newBorrowerName = "NewBorrower_" + System.currentTimeMillis();
            primarySetupRequestBodyJson.put("borrowerName", newBorrowerName);

            Response primarySetupResponse = APIUtility.sendRequest(primarySetupMethod, primarySetupUrl, headers, null, primarySetupRequestBodyJson.toString());
            
            if (primarySetupResponse == null) {
                throw new IllegalStateException("No response received from primary setup request");
            }

            if (primarySetupResponse.getStatusCode() != 200) {
                throw new IllegalStateException("Primary setup failed with status code: " + primarySetupResponse.getStatusCode() + 
                    ", Response: " + primarySetupResponse.getBody().asString());
            }

            TestContextLogger.scenarioLog("API", "Successfully completed primary setup");

            // Step 3: Get Deals
            String getDealsMethod = getFrameworkConfig("GetDealsMethod");
            String getDealsUrlPath = getFrameworkConfig("GetDealsUrl");
            
            if (getDealsMethod == null || getDealsUrlPath == null) {
                throw new IllegalStateException("GetDealsMethod or GetDealsUrl not found in FrameworkConfig");
            }

            String getDealsUrl = configBaseUrl + getDealsUrlPath + newBorrowerName;
            TestContextLogger.scenarioLog("API", "Retrieving deals from: " + getDealsUrl);
            Response getDealsResponse = APIUtility.sendRequest(getDealsMethod, getDealsUrl, headers, null, null);
            
            if (getDealsResponse == null) {
                throw new IllegalStateException("No response received from get deals request");
            }

            if (getDealsResponse.getStatusCode() != 200) {
                throw new IllegalStateException("Get deals failed with status code: " + getDealsResponse.getStatusCode() + 
                    ", Response: " + getDealsResponse.getBody().asString());
            }

            // Extract and validate deal details
            String dealId = getDealsResponse.path("result[0].id");
            String borrowerName = getDealsResponse.path("result[0].borrowerName");
            String trancheId = getDealsResponse.path("result[0].tranches[0].id");
            String investorId = getDealsResponse.path("result[0].tranches[0].trancheResponses[0].investorId");
            String arrangerEmail = getDealsResponse.path("result[0].arrangers[0].arrangerEmailId");
            String lenderMpid = getDealsResponse.path("result[0].lenders[0].lenderMp.id");
            String dataRoomId = getDealsResponse.path("result[0].dataRoomId");
            String trancheResponseId = getDealsResponse.path("result[0].tranches[0].trancheResponses[0].id");

            // Validate required fields
            if (dealId == null || borrowerName == null || dataRoomId == null) {
                throw new RuntimeException("Missing required deal details in response");
            }

            // Store deal details
            DealDetailsManager.put("dealId", dealId);
            DealDetailsManager.put("borrowerName", borrowerName);
            DealDetailsManager.put("trancheId", trancheId);
            DealDetailsManager.put("investorId", investorId);
            DealDetailsManager.put("arrangerEmail", arrangerEmail);
            DealDetailsManager.put("lenderMpid", lenderMpid);
            DealDetailsManager.put("dataRoomId", dataRoomId);
            DealDetailsManager.put("trancheResponseId", trancheResponseId);

            TestContextLogger.scenarioLog("API", "Successfully retrieved and stored deal details");
            // Store additional deal details
            DealDetailsManager.put("ndaDocId", getDealsResponse.path("result[0].ndaDocId"));
            DealDetailsManager.put("dealCreatorMpId", getDealsResponse.path("result[0].mpId"));
            DealDetailsManager.put("dealCreatorUserId", getDealsResponse.path("result[0].userId"));
            
            // Validate and store investor related details
            Object lenders = getDealsResponse.path("result[0].lenders");
            if (lenders != null) {
                Object investor2 = getDealsResponse.path("result[0].lenders[1]");
                if (investor2 != null) {
                    DealDetailsManager.put("investor2Id", getDealsResponse.path("result[0].lenders[1].id"));
                }
                
                Object investor1 = getDealsResponse.path("result[0].lenders[0]");
                if (investor1 != null) {
                    DealDetailsManager.put("investor1MpId", getDealsResponse.path("result[0].lenders[0].lenderMpId"));
                    DealDetailsManager.put("investor1LendersId", getDealsResponse.path("result[0].lenders[0].id"));
                }
            }
            
            TestContextLogger.scenarioLog("API", "Successfully stored additional deal details");
            
            // Check if secondary setup is enabled
            String secondarySetupEnabled = getFrameworkConfig("SecondarySetupEnabled");
            if (secondarySetupEnabled != null && secondarySetupEnabled.equalsIgnoreCase("true")) {
                try {
                    TestContextLogger.scenarioLog("API", "Starting secondary seller setup process");
                    
                    // Step 1: Create Draft Sell Offer
                    String draftSellOfferMethod = getFrameworkConfig("DraftSellOfferMethod");
                    if (draftSellOfferMethod == null) {
                        throw new RuntimeException("DraftSellOfferMethod not found in FrameworkConfig");
                    }

                    String draftSellOfferUrl = getFrameworkConfig("DraftSellOfferUrl");
                    if (draftSellOfferUrl == null) {
                        throw new RuntimeException("DraftSellOfferUrl not found in FrameworkConfig");
                    }

                    String draftSellOfferBodyPath = getFrameworkConfig("Request_Bodies") + getFrameworkConfig("DraftSellOfferRequestBody");
                    String draftSellOfferRequestBodyStr = JsonFileReader.getJsonAsString(draftSellOfferBodyPath);
                    
                    if (draftSellOfferRequestBodyStr == null) {
                        throw new RuntimeException("Failed to read draft sell offer request body from: " + draftSellOfferBodyPath);
                    }

                    // Modify request body with unique identifiers
                    JSONObject requestJson = new JSONObject(draftSellOfferRequestBodyStr);
                    String uniqueBorrowerName = "SecBorrower_" + System.currentTimeMillis();
                    requestJson.put("borrowerName", uniqueBorrowerName);
                    
                    // Send Draft Sell Offer request
                    Response draftSellOfferResponse = APIUtility.sendRequest(
                        draftSellOfferMethod, 
                        configBaseUrl + draftSellOfferUrl, 
                        headers, 
                        null, 
                        requestJson.toString()
                    );

                    if (draftSellOfferResponse == null) {
                        throw new RuntimeException("No response received from draft sell offer request");
                    }

                    if (draftSellOfferResponse.getStatusCode() != 201 && draftSellOfferResponse.getStatusCode() != 200) {
                        throw new RuntimeException("Draft sell offer creation failed with status code: " + draftSellOfferResponse.getStatusCode() + 
                                ", Response: " + draftSellOfferResponse.getBody().asString());
                    }

                    // Log the full draft sell offer response body for debugging
                    TestContextLogger.scenarioLog("API", "Draft sell offer response: " + draftSellOfferResponse.getBody().asString());

                    // Extract id from Location header
                    String sellOfferLocation = draftSellOfferResponse.getHeader("Location");
                    if (sellOfferLocation == null || sellOfferLocation.trim().isEmpty()) {
                        throw new RuntimeException("No Location header in draft sell offer response");
                    }

                    // Extract the id from the Location header (assume last path segment)
                    String[] parts = sellOfferLocation.split("/");
                    String secondaryDraftId = parts[parts.length - 1];
                    
                    // Store secondary details with the same pattern as primary deal details
                    DealDetailsManager.put("secondaryDealId", secondaryDraftId);
                    DealDetailsManager.put("secondaryBorrowerName", uniqueBorrowerName);
                    // Also save as secondorydrftid as originally requested (for backward compatibility)
                    DealDetailsManager.put("secondorydrftid", secondaryDraftId);
                    TestContextLogger.scenarioLog("API", "Successfully created secondary draft with ID: " + secondaryDraftId);

                    // Step 1.5: Publish the Sell Offer
                    String publishSellOfferMethod = getFrameworkConfig("PublishSellOfferMethod");
                    String publishSellOfferUrlTemplate = getFrameworkConfig("PublishSellOfferUrl");
                    String publishSellOfferUrl = configBaseUrl + publishSellOfferUrlTemplate.replace("{id}", secondaryDraftId);
                    TestContextLogger.scenarioLog("API", "Publishing secondary sell offer. Draft ID: " + secondaryDraftId);
                    TestContextLogger.scenarioLog("API", "Publish URL: " + publishSellOfferUrl);
                    // Always send null body for publish request
                    Response publishResponse = APIUtility.sendRequest(
                        publishSellOfferMethod,
                        publishSellOfferUrl,
                        headers,
                        null,
                        null
                    );
                    if (publishResponse == null || (publishResponse.getStatusCode() != 200 && publishResponse.getStatusCode() != 201)) {
                        throw new RuntimeException("Publish Sell Offer failed with status code: " + (publishResponse == null ? "null" : publishResponse.getStatusCode()) +
                                ", Response: " + (publishResponse == null ? "null" : publishResponse.getBody().asString()));
                    }
                    TestContextLogger.scenarioLog("API", "Successfully published secondary Sell Offer with ID: " + secondaryDraftId);
                    
                    // Step 2: Get Sell Offer Details
                    String getSellOfferMethod = "GET";
                    String getSellOfferUrl = configBaseUrl + "/api/v2/sell-offers/" + secondaryDraftId;
                    
                    Response getSellOfferResponse = APIUtility.sendRequest(getSellOfferMethod, getSellOfferUrl, headers, null, null);
                    
                    if (getSellOfferResponse == null) {
                        throw new RuntimeException("No response received from get sell offer request");
                    }

                    if (getSellOfferResponse.getStatusCode() != 200) {
                        throw new RuntimeException("Get sell offer details failed with status code: " + getSellOfferResponse.getStatusCode() + 
                                ", Response: " + getSellOfferResponse.getBody().asString());
                    }

                    // Print response structure for debugging
                    TestContextLogger.scenarioLog("API", "Secondary sell offer response: " + getSellOfferResponse.getBody().asString());

                    // Extract and validate secondary deal details in a consistent way with primary setup
                    // First, check if response has a result array structure and is non-empty
                    Object resultArray = getSellOfferResponse.path("result");
                    String secondaryDealId, secondaryDataRoomId, secondaryBorrowerName, secondaryUserId, secondaryUserName;
                    String secondaryUserEmail, secondaryUserMpId, secondaryUserMpName, secondaryBorrowerCountry;
                    String secondarySellOfferSize, secondaryCurrency, secondarySellOfferType, secondaryState;
                    String secondaryPublishDate, secondaryIndustry, secondaryTrancheType;
                    if (resultArray instanceof java.util.List && !((java.util.List<?>) resultArray).isEmpty()) {
                        System.out.println("Detected result array in secondary response, using array structure");
                        secondaryDealId = String.valueOf(getSellOfferResponse.path("result[0].id"));
                        secondaryDataRoomId = String.valueOf(getSellOfferResponse.path("result[0].dataRoomId"));
                        secondaryBorrowerName = String.valueOf(getSellOfferResponse.path("result[0].borrowerName"));
                        secondaryUserId = String.valueOf(getSellOfferResponse.path("result[0].userId"));
                        secondaryUserName = String.valueOf(getSellOfferResponse.path("result[0].userName"));
                        secondaryUserEmail = String.valueOf(getSellOfferResponse.path("result[0].userEmail"));
                        secondaryUserMpId = String.valueOf(getSellOfferResponse.path("result[0].userMpId"));
                        secondaryUserMpName = String.valueOf(getSellOfferResponse.path("result[0].userMpName"));
                        secondaryBorrowerCountry = String.valueOf(getSellOfferResponse.path("result[0].borrowerCountry"));
                        secondarySellOfferSize = String.valueOf(getSellOfferResponse.path("result[0].sellOfferSize"));
                        secondaryCurrency = String.valueOf(getSellOfferResponse.path("result[0].currency"));
                        secondarySellOfferType = String.valueOf(getSellOfferResponse.path("result[0].sellOfferType"));
                        secondaryState = String.valueOf(getSellOfferResponse.path("result[0].state"));
                        secondaryPublishDate = String.valueOf(getSellOfferResponse.path("result[0].publishedDate"));
                        secondaryIndustry = String.valueOf(getSellOfferResponse.path("result[0].industry"));
                        secondaryTrancheType = String.valueOf(getSellOfferResponse.path("result[0].trancheType"));
                    } else {
                        // If no result array or it's empty/null, extract directly from response
                        System.out.println("No result array or result array is empty/null, extracting directly from response root");
                        secondaryDealId = String.valueOf(getSellOfferResponse.path("id"));
                        secondaryDataRoomId = String.valueOf(getSellOfferResponse.path("dataRoomId"));
                        secondaryBorrowerName = String.valueOf(getSellOfferResponse.path("borrowerName"));
                        secondaryUserId = String.valueOf(getSellOfferResponse.path("userId"));
                        secondaryUserName = String.valueOf(getSellOfferResponse.path("userName"));
                        secondaryUserEmail = String.valueOf(getSellOfferResponse.path("userEmail"));
                        secondaryUserMpId = String.valueOf(getSellOfferResponse.path("userMpId"));
                        secondaryUserMpName = String.valueOf(getSellOfferResponse.path("userMpName"));
                        secondaryBorrowerCountry = String.valueOf(getSellOfferResponse.path("borrowerCountry"));
                        secondarySellOfferSize = String.valueOf(getSellOfferResponse.path("sellOfferSize"));
                        secondaryCurrency = String.valueOf(getSellOfferResponse.path("currency"));
                        secondarySellOfferType = String.valueOf(getSellOfferResponse.path("sellOfferType"));
                        secondaryState = String.valueOf(getSellOfferResponse.path("state"));
                        secondaryPublishDate = String.valueOf(getSellOfferResponse.path("publishedDate"));
                        secondaryIndustry = String.valueOf(getSellOfferResponse.path("industry"));
                        secondaryTrancheType = String.valueOf(getSellOfferResponse.path("trancheType"));
                    }
                    // Validate required fields
                    // Save all secondary details regardless of nulls, and print debug info
                    String[][] secondaryDetails = {
                        {"secondaryDealId", secondaryDealId},
                        {"secondaryDataRoomId", secondaryDataRoomId},
                        {"secondaryBorrowerName", secondaryBorrowerName},
                        {"secondaryUserId", secondaryUserId},
                        {"secondaryUserName", secondaryUserName},
                        {"secondaryUserEmail", secondaryUserEmail},
                        {"secondaryUserMpId", secondaryUserMpId},
                        {"secondaryUserMpName", secondaryUserMpName},
                        {"secondaryBorrowerCountry", secondaryBorrowerCountry},
                        {"secondarySellOfferSize", secondarySellOfferSize},
                        {"secondaryCurrency", secondaryCurrency},
                        {"secondarySellOfferType", secondarySellOfferType},
                        {"secondaryState", secondaryState},
                        {"secondaryPublishDate", secondaryPublishDate},
                        {"secondaryIndustry", secondaryIndustry},
                        {"secondaryTrancheType", secondaryTrancheType},
                        // Backward-compatible keys
                        {"secondorydataRoomid", secondaryDataRoomId},
                        {"secBorrowerName", secondaryBorrowerName},
                        {"secBorrowerCountry", secondaryBorrowerCountry},
                        {"secSellOfferSize", secondarySellOfferSize},
                        {"secCurrency", secondaryCurrency},
                        {"secSellOfferType", secondarySellOfferType},
                        {"secState", secondaryState}
                    };
                    System.out.println("Saving secondary deal details to DealDetailsManager:");
                    for (String[] entry : secondaryDetails) {
                        DealDetailsManager.put(entry[0], entry[1]);
                        System.out.println(" - " + entry[0] + ": " + entry[1]);
                    }
                    TestContextLogger.scenarioLog("API", "Secondary seller setup completed successfully");
                } catch (Exception e) {
                    TestContextLogger.scenarioLog("ERROR", "Error in secondary seller setup: " + e.getMessage());
                    TestContextLogger.scenarioLog("WARNING", "Continuing with test execution despite secondary setup failure");
                    // Not throwing exception to allow tests to continue even if secondary setup fails
                }
            }
        } catch (Exception e) {
            System.err.println("Error in test setup process: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Test setup failed", e);
        }



    }

    @Before
    public void beforeScenario(Scenario scenario) {
        scenarioLogger = scenario;
        scenarioName = scenario.getName();
    }

    @Before("@removeInvestor")
    public void beforeScenarioRemoveInvestor() throws IOException {

        String getDealsMethod = getFrameworkConfig("GetDealsMethod");
        String jsonString = Files.readString(Paths.get(FrameworkConfigReader.getFrameworkConfig("DealDetails")), StandardCharsets.UTF_8);
        JSONObject storedValues = new JSONObject(jsonString);

        String getDealsUrl = getFrameworkConfig("BaseUrl") + getFrameworkConfig("GetDealsUrl") + storedValues.getString("borrowerName");

        Response getDealsResponse = APIUtility.sendRequest(getDealsMethod, getDealsUrl, headers, null, null);
        DealDetailsManager.put("newAddedLenderMpId", getDealsResponse.path("result[0].lenders[2].lenderMp.id"));

    }

    @Before("@setUpDeal")
    public void beforeScenarioSetUpDeal() throws IOException {
        try {
            // Step 1: Create Draft
            String draftMethod = getFrameworkConfig("DraftMethod");
            if (draftMethod == null) {
                throw new RuntimeException("DraftMethod not found in FrameworkConfig");
            }

            String baseUrl = getFrameworkConfig("BaseUrl");
            String draftUrlPath = getFrameworkConfig("DraftUrl");
            if (baseUrl == null || draftUrlPath == null) {
                throw new RuntimeException("BaseUrl or DraftUrl not found in FrameworkConfig");
            }

            String draftUrl = baseUrl + draftUrlPath;
            String requestBodyPath = getFrameworkConfig("Request_Bodies") + getFrameworkConfig("DraftRequestBody");
            Object draftRequestBody = JsonFileReader.getJsonAsString(requestBodyPath);
            
            if (draftRequestBody == null) {
                throw new RuntimeException("Failed to read draft request body from: " + requestBodyPath);
            }

            Response draftResponse = APIUtility.sendRequest(draftMethod, draftUrl, headers, null, draftRequestBody);
            if (draftResponse == null) {
                throw new RuntimeException("No response received from draft creation request");
            }

            if (draftResponse.getStatusCode() != 200 && draftResponse.getStatusCode() != 201) {
                throw new RuntimeException("Draft creation failed with status code: " + draftResponse.getStatusCode() + 
                    ", Response: " + draftResponse.getBody().asString());
            }

            String locationId = draftResponse.getHeader("Location");
            if (locationId == null || locationId.trim().isEmpty()) {
                throw new RuntimeException("No Location header in draft response");
            }

            DealDetailsManager.put("locationId", locationId);
            TestContextLogger.scenarioLog("API", "Successfully created draft with Location: " + locationId);
        } catch (Exception e) {
            TestContextLogger.scenarioLog("ERROR", "Error in @setUpDeal: " + e.getMessage());
            throw new RuntimeException("Deal setup failed", e);
        }
    }

    @Before("@setupDataRoom")
    public void beforeScenarioDataRoom() {
        try {
            // Step 1: Create draft sell offer by calling existing method
            beforeScenarioExtractSellOfferId();
            TestContextLogger.scenarioLog("API", "Successfully created draft sell offer using existing method");
            
            // Get the created sell offer ID
            String sellOfferId = String.valueOf(DealDetailsManager.get("id"));
            
            if (sellOfferId == null || sellOfferId.equals("null") || sellOfferId.trim().isEmpty()) {
                throw new RuntimeException("No valid sellOfferId found after draft creation");
            }
            
            // Also save it as secondorysellid for backward compatibility
            DealDetailsManager.put("secondorysellid", sellOfferId);
            TestContextLogger.scenarioLog("API", "Saved secondorysellid: " + sellOfferId);
            
            // Step 2: Publish sell offer
            if (sellOfferId == null || sellOfferId.equals("null") || sellOfferId.trim().isEmpty()) {
                throw new RuntimeException("No valid sellOfferId found after draft creation");
            }
            
            String publishUrl = configBaseUrl + "/api/v2/sell-offers/draft/" + sellOfferId + "/publish";
            String publishMethod = "POST";
            
            // Get the publish request body from file
            String publishBodyPath = getFrameworkConfig("Request_Bodies") + "Publish_Sell_Offer_Body_200.json";
            String publishRequestBody = JsonFileReader.getJsonAsString(publishBodyPath);
            
            if (publishRequestBody == null) {
                throw new RuntimeException("Failed to read publish request body from: " + publishBodyPath);
            }
            
            // Update the ID in the request body
            JSONObject publishBody = new JSONObject(publishRequestBody);
            publishBody.put("id", sellOfferId);
            
            TestContextLogger.scenarioLog("API", "Publishing sell offer at URL: " + publishUrl);
            TestContextLogger.scenarioLog("API", "Using sell offer ID: " + sellOfferId);
            TestContextLogger.scenarioLog("API", "Publish request body: " + publishBody.toString());
            
            Response publishResponse = APIUtility.sendRequest(publishMethod, publishUrl, headers, null, publishBody.toString());
            if (publishResponse == null) {
                throw new RuntimeException("No response received from publish request");
            }
            if (publishResponse.getStatusCode() != 200) {
                throw new RuntimeException("Publish sell offer failed with status code: " + publishResponse.getStatusCode() + 
                    ", Response: " + publishResponse.getBody().asString());
            }
            // Store published ID on successful 200 response
            DealDetailsManager.put("publishedSellOfferId", sellOfferId);
            // Also save as publishedsellid for backward compatibility
            DealDetailsManager.put("publishedsellid", sellOfferId);
            TestContextLogger.scenarioLog("API", "Successfully published sell offer with ID: " + sellOfferId);

            // Step 3: Get sell offer details to extract dataRoomId
            String viewUrl = configBaseUrl + "/api/v2/sell-offers/" + sellOfferId;
            TestContextLogger.scenarioLog("API", "Fetching sell offer details from URL: " + viewUrl);
            
            Response viewResponse = APIUtility.sendRequest("GET", viewUrl, headers, null, null);
            if (viewResponse == null) {
                throw new RuntimeException("No response received from view sell offer request");
            }
            if (viewResponse.getStatusCode() != 200) {
                throw new RuntimeException("Get sell offer details failed with status code: " + viewResponse.getStatusCode() + 
                    ", Response: " + viewResponse.getBody().asString());
            }
            extractDataRoomId(viewResponse);

            // Verify we have the required dataRoomId
            String dataRoomId = String.valueOf(DealDetailsManager.get("dataRoomId"));
            if (dataRoomId == null || dataRoomId.equals("null") || dataRoomId.trim().isEmpty()) {
                throw new RuntimeException("Failed to extract dataRoomId from response");
            }

            TestContextLogger.scenarioLog("API", "Successfully setup DataRoom with ID: " + dataRoomId);
            
        } catch (Exception e) {
            TestContextLogger.scenarioLog("ERROR", "Failed to setup DataRoom: " + e.getMessage());
            throw new RuntimeException("DataRoom setup failed", e);
        }
    }

    @Before("@uploadDoc")
    public void beforeScenarioUploadDoc() {
        try {
            // Get configuration values
            String baseUrl = FrameworkConfigReader.getFrameworkConfig("BaseUrl");
            String uploadDocUrlPath = FrameworkConfigReader.getFrameworkConfig("UploadDocUrl");
            String filesPath = FrameworkConfigReader.getFrameworkConfig("Files_Path");
            String uploadFileName = FrameworkConfigReader.getFrameworkConfig("UploadFileName");

            if (baseUrl == null || uploadDocUrlPath == null || filesPath == null || uploadFileName == null) {
                throw new RuntimeException("Missing required configuration for file upload");
            }

            // Build URLs and paths
            String uploadDocUrl = baseUrl + uploadDocUrlPath;
            String filePath = filesPath + uploadFileName;

            // Validate file exists
            File uploadFile = new File(filePath);
            if (!uploadFile.exists() || !uploadFile.isFile()) {
                throw new RuntimeException("Upload file not found: " + filePath);
            }

            // Setup multipart request
            Map<String, Object> multipartParams = new HashMap<>();
            multipartParams.put("fileBody", uploadFile);
            multipartParams.put("fileName", uploadFileName);

            // Send request
            Response uploadDocResponse = APIUtility.sendMultipartRequest(uploadDocUrl, headers, multipartParams);
            
            if (uploadDocResponse == null) {
                throw new RuntimeException("No response received from upload request");
            }

            if (uploadDocResponse.getStatusCode() != 200) {
                throw new RuntimeException("Document upload failed with status code: " + uploadDocResponse.getStatusCode() + 
                    ", Response: " + uploadDocResponse.getBody().asString());
            }

            // Extract and validate document ID
            String documentId = uploadDocResponse.path("data.documentId");
            if (documentId == null || documentId.trim().isEmpty()) {
                throw new RuntimeException("No document ID in upload response");
            }

            DealDetailsManager.put("documentId", documentId);
            TestContextLogger.scenarioLog("API", "Successfully uploaded document with ID: " + documentId);

        } catch (Exception e) {
            TestContextLogger.scenarioLog("ERROR", "Error in @uploadDoc: " + e.getMessage());
            throw new RuntimeException("Document upload failed", e);
        }
    }

    @Before("@GetFolderPermission")
    public void beforeScenarioGetFolderPermission() throws IOException {
        try {
            // Get configuration
            String method = getFrameworkConfig("GetFolderPermissionMethod");
            String urlTemplate = getFrameworkConfig("GetFolderPermissionUrl");
            String baseUrl = getFrameworkConfig("BaseUrl");
            String dealDetailsPath = FrameworkConfigReader.getFrameworkConfig("DealDetails");

            if (method == null || urlTemplate == null || baseUrl == null || dealDetailsPath == null) {
                throw new RuntimeException("Missing required configuration for folder permission");
            }

            // Read stored deal details
            if (!Files.exists(Paths.get(dealDetailsPath))) {
                throw new RuntimeException("Deal details file not found: " + dealDetailsPath);
            }

            String dealDetailsJson = Files.readString(Paths.get(dealDetailsPath), StandardCharsets.UTF_8);
            if (dealDetailsJson == null || dealDetailsJson.trim().isEmpty()) {
                throw new RuntimeException("Deal details file is empty");
            }

            JSONObject stored = new JSONObject(dealDetailsJson);

            // Replace placeholders in URL
            String url = urlTemplate;
            for (String key : stored.keySet()) {
                String value = stored.getString(key);
                if (value != null && !value.trim().isEmpty()) {
                    url = url.replace("{" + key + "}", value);
                }
            }

            // Validate all placeholders are replaced
            if (url.contains("{") || url.contains("}")) {
                throw new RuntimeException("Not all placeholders were replaced in URL: " + url);
            }

            String mainUrl = baseUrl + url;
            TestContextLogger.scenarioLog("API", "Requesting folder permissions from: " + mainUrl);

            // Send request
            Response res = APIUtility.sendRequest(method, mainUrl, headers, null, null);
            
            if (res == null) {
                throw new RuntimeException("No response received from folder permission request");
            }

            if (res.getStatusCode() != 200) {
                throw new RuntimeException("Folder permission request failed with status code: " + res.getStatusCode() + 
                    ", Response: " + res.getBody().asString());
            }

            // Extract and validate resource ID
            String resourceId = res.path("data.resources[0].id");
            if (resourceId == null || resourceId.trim().isEmpty()) {
                throw new RuntimeException("No resource ID in response");
            }

            DealDetailsManager.put("dataRoomFileResourceID", resourceId);
            TestContextLogger.scenarioLog("API", "Successfully retrieved folder permission with resource ID: " + resourceId);

        } catch (Exception e) {
            TestContextLogger.scenarioLog("ERROR", "Error in @GetFolderPermission: " + e.getMessage());
            throw new RuntimeException("Failed to get folder permission", e);
        }
    }


    @After
    public void afterScenario(io.cucumber.java.Scenario scenario) {
        boolean passed = !scenario.isFailed();
        ScenarioResultCollector.addResult(scenario.getName(), passed);
    }

 

    @Before("@extractSellOfferId")
    public void beforeScenarioExtractSellOfferId() throws IOException {
        try {
            // Refresh token to prevent 401 errors
            String token = TokenManager.getToken();
            if (token == null || token.trim().isEmpty()) {
                throw new RuntimeException("Failed to get valid authentication token");
            }
            TestContextLogger.scenarioLog("API", "Successfully refreshed authentication token for sell offer operations");
            
            headers.clear();
            headers.put("cookie", token);
            headers.put("Accept", "application/json");
            headers.put("Content-Type", "application/json");
            
            // Prepare request for Draft Sell Offer
            String draftSellOfferMethod = getFrameworkConfig("DraftSellOfferMethod");
            String baseUrl = getFrameworkConfig("BaseUrl");
            String draftSellOfferUrl = getFrameworkConfig("DraftSellOfferUrl");
            String draftSellOfferBodyPath = getFrameworkConfig("Request_Bodies") + getFrameworkConfig("DraftSellOfferRequestBody");
            Object draftSellOfferRequestBody = JsonFileReader.getJsonAsString(draftSellOfferBodyPath);
            if (draftSellOfferRequestBody == null) {
                throw new RuntimeException("Failed to read Draft Sell Offer request body from: " + draftSellOfferBodyPath);
            }
            // Send Draft Sell Offer request
            Response draftSellOfferResponse = APIUtility.sendRequest(draftSellOfferMethod, baseUrl + draftSellOfferUrl, headers, null, draftSellOfferRequestBody);
            if (draftSellOfferResponse == null) {
                throw new RuntimeException("No response received from Draft Sell Offer request");
            }
            if (draftSellOfferResponse.getStatusCode() != 201 && draftSellOfferResponse.getStatusCode() != 200) {
                throw new RuntimeException("Draft Sell Offer creation failed with status code: " + draftSellOfferResponse.getStatusCode() +
                        ", Response: " + draftSellOfferResponse.getBody().asString());
            }
            // Extract id from Location header
            String sellOfferLocation = draftSellOfferResponse.getHeader("Location");
            if (sellOfferLocation == null || sellOfferLocation.trim().isEmpty()) {
                throw new RuntimeException("No Location header in Draft Sell Offer response");
            }
            // Extract the id from the Location header (assume last path segment)
            String[] parts = sellOfferLocation.split("/");
            String sellOfferId = parts[parts.length - 1];
            DealDetailsManager.put("id", sellOfferId);
            TestContextLogger.scenarioLog("API", "Successfully extracted and stored Sell Offer ID: " + sellOfferId);
        } catch (Exception e) {
            System.err.println("Error in @extractSellOfferId: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Sell Offer ID extraction failed", e);
        }
    }

      @Before("@publishselloffer")
    public void beforeScenarioExtractSellOfferIdpublishing() throws IOException {
        try {
            // Refresh token to prevent 401 errors
            String token = TokenManager.getToken();
            if (token == null || token.trim().isEmpty()) {
                throw new RuntimeException("Failed to get valid authentication token");
            }
            TestContextLogger.scenarioLog("API", "Successfully refreshed authentication token for sell offer operations");
            
            headers.clear();
            headers.put("cookie", token);
            headers.put("Accept", "application/json");
            headers.put("Content-Type", "application/json");
            
            // Prepare request for Draft Sell Offer
            String draftSellOfferMethod = getFrameworkConfig("DraftSellOfferMethod");
            String baseUrl = getFrameworkConfig("BaseUrl");
            String draftSellOfferUrl = getFrameworkConfig("DraftSellOfferUrl");
            String draftSellOfferBodyPath = getFrameworkConfig("Request_Bodies") + getFrameworkConfig("DraftSellOfferRequestBody");
            Object draftSellOfferRequestBody = JsonFileReader.getJsonAsString(draftSellOfferBodyPath);
            if (draftSellOfferRequestBody == null) {
                throw new RuntimeException("Failed to read Draft Sell Offer request body from: " + draftSellOfferBodyPath);
            }
            // Send Draft Sell Offer request
            Response draftSellOfferResponse = APIUtility.sendRequest(draftSellOfferMethod, baseUrl + draftSellOfferUrl, headers, null, draftSellOfferRequestBody);
            if (draftSellOfferResponse == null) {
                throw new RuntimeException("No response received from Draft Sell Offer request");
            }
            if (draftSellOfferResponse.getStatusCode() != 201 && draftSellOfferResponse.getStatusCode() != 200) {
                throw new RuntimeException("Draft Sell Offer creation failed with status code: " + draftSellOfferResponse.getStatusCode() +
                        ", Response: " + draftSellOfferResponse.getBody().asString());
            }
            // Extract id from Location header
            String sellOfferLocation = draftSellOfferResponse.getHeader("Location");
            if (sellOfferLocation == null || sellOfferLocation.trim().isEmpty()) {
                throw new RuntimeException("No Location header in Draft Sell Offer response");
            }
            // Extract the id from the Location header (assume last path segment)
            String[] parts = sellOfferLocation.split("/");
            String sellOfferId = parts[parts.length - 1];
            DealDetailsManager.put("publishing_id", sellOfferId);
            TestContextLogger.scenarioLog("API", "Successfully extracted and stored Sell Offer ID: " + sellOfferId);
        } catch (Exception e) {
            System.err.println("Error in @extractSellOfferId: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Sell Offer ID extraction failed", e);
        }
    }
}
