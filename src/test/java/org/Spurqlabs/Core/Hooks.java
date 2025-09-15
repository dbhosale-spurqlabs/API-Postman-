  

package org.Spurqlabs.Core;

import io.cucumber.java.After;
import io.cucumber.java.Before;
import io.cucumber.java.BeforeAll;
import io.cucumber.java.Scenario;
import io.restassured.response.Response;
import org.Spurqlabs.Utils.*;
import org.json.JSONObject;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;

import static org.Spurqlabs.Utils.FrameworkConfigReader.getFrameworkConfig;

public class Hooks extends TestContext {

    static Map<String, String> headers = new HashMap<>();

    @BeforeAll
    public static void executeSetupProcess() throws IOException {
        try {
            System.out.println("Starting test setup process...");

            // Get authentication token
            String token = TokenManager.getToken();
            if (token == null || token.trim().isEmpty()) {
                throw new RuntimeException("Failed to get valid authentication token");
            }
            System.out.println("Successfully retrieved authentication token");

            headers.clear();
            headers.put("cookie", token);
            headers.put("Accept", "application/json");
            headers.put("Content-Type", "application/json");

            // Step 1: Create Draft
            String draftMethod = getFrameworkConfig("DraftMethod");
            String baseUrl = getFrameworkConfig("BaseUrl");
            String draftUrlPath = getFrameworkConfig("DraftUrl");
            
            if (draftMethod == null || baseUrl == null || draftUrlPath == null) {
                throw new RuntimeException("Missing required configuration: DraftMethod, BaseUrl, or DraftUrl");
            }

            String draftUrl = baseUrl + draftUrlPath;
            System.out.println("Draft URL: " + draftUrl);
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
                throw new RuntimeException("No Location header in draft response. Status code: " + draftResponse.getStatusCode() + 
                    ", Response: " + draftResponse.getBody().asString());
            }

            System.out.println("Successfully created draft with Location: " + locationId);

            // Step 2: Primary Setup
            String primarySetupMethod = getFrameworkConfig("PrimarySetupMethod");
            if (primarySetupMethod == null) {
                throw new RuntimeException("PrimarySetupMethod not found in FrameworkConfig");
            }

            String primarySetupUrlTemplate = getFrameworkConfig("PrimarySetupUrl");
            if (primarySetupUrlTemplate == null) {
                throw new RuntimeException("PrimarySetupUrl not found in FrameworkConfig");
            }

            String primarySetupUrl = baseUrl + primarySetupUrlTemplate.replace("{locationId}", locationId);

            String primarySetupBodyPath = getFrameworkConfig("Request_Bodies") + getFrameworkConfig("PrimarySetupRequestBody");
            String primarySetupRequestBodyStr = JsonFileReader.getJsonAsString(primarySetupBodyPath);
            
            if (primarySetupRequestBodyStr == null) {
                throw new RuntimeException("Failed to read primary setup request body from: " + primarySetupBodyPath);
            }

            JSONObject primarySetupRequestBodyJson = new JSONObject(primarySetupRequestBodyStr);
            String newBorrowerName = "NewBorrower_" + System.currentTimeMillis();
            primarySetupRequestBodyJson.put("borrowerName", newBorrowerName);

            Response primarySetupResponse = APIUtility.sendRequest(primarySetupMethod, primarySetupUrl, headers, null, primarySetupRequestBodyJson.toString());
            
            if (primarySetupResponse == null) {
                throw new RuntimeException("No response received from primary setup request");
            }

            if (primarySetupResponse.getStatusCode() != 200) {
                throw new RuntimeException("Primary setup failed with status code: " + primarySetupResponse.getStatusCode() + 
                    ", Response: " + primarySetupResponse.getBody().asString());
            }

            System.out.println("Successfully completed primary setup");

            // Step 3: Get Deals
            String getDealsMethod = getFrameworkConfig("GetDealsMethod");
            String getDealsUrlPath = getFrameworkConfig("GetDealsUrl");
            
            if (getDealsMethod == null || getDealsUrlPath == null) {
                throw new RuntimeException("GetDealsMethod or GetDealsUrl not found in FrameworkConfig");
            }

            String getDealsUrl = baseUrl + getDealsUrlPath + newBorrowerName;
            Response getDealsResponse = APIUtility.sendRequest(getDealsMethod, getDealsUrl, headers, null, null);
            
            if (getDealsResponse == null) {
                throw new RuntimeException("No response received from get deals request");
            }

            if (getDealsResponse.getStatusCode() != 200) {
                throw new RuntimeException("Get deals failed with status code: " + getDealsResponse.getStatusCode() + 
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

            System.out.println("Successfully retrieved and stored deal details");
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
            
            System.out.println("Successfully stored additional deal details");
            
            // Check if secondary setup is enabled
            String secondarySetupEnabled = getFrameworkConfig("SecondarySetupEnabled");
            if (secondarySetupEnabled != null && secondarySetupEnabled.equalsIgnoreCase("true")) {
                try {
                    System.out.println("Starting secondary seller setup process...");
                    
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
                            baseUrl + draftSellOfferUrl, 
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
                    System.out.println("Successfully created secondary draft with ID: " + secondaryDraftId);
                    
                    // Step 2: Get Sell Offer Details
                    String getSellOfferMethod = "GET";
                    String getSellOfferUrl = baseUrl + "/api/v2/sell-offers/" + secondaryDraftId;
                    
                    Response getSellOfferResponse = APIUtility.sendRequest(getSellOfferMethod, getSellOfferUrl, headers, null, null);
                    
                    if (getSellOfferResponse == null) {
                        throw new RuntimeException("No response received from get sell offer request");
                    }

                    if (getSellOfferResponse.getStatusCode() != 200) {
                        throw new RuntimeException("Get sell offer details failed with status code: " + getSellOfferResponse.getStatusCode() + 
                                ", Response: " + getSellOfferResponse.getBody().asString());
                    }

                    // Print response structure for debugging
                    System.out.println("Secondary sell offer response structure: " + getSellOfferResponse.getBody().asString());

                    // Extract and validate secondary deal details
                    // Note: The response structure is different from primary setup
                    // Primary setup extracts from result[0].id, but secondary extracts directly
                    // Use String.valueOf() to handle cases where the API returns numbers instead of strings
                    String secondaryDataRoomId = String.valueOf(getSellOfferResponse.path("dataRoomId"));
                    String secondaryBorrowerCountry = String.valueOf(getSellOfferResponse.path("borrowerCountry"));
                    String secondarySellOfferSize = String.valueOf(getSellOfferResponse.path("sellOfferSize"));
                    String secondaryCurrency = String.valueOf(getSellOfferResponse.path("currency"));
                    String secondarySellOfferType = String.valueOf(getSellOfferResponse.path("sellOfferType"));
                    String secondaryState = String.valueOf(getSellOfferResponse.path("state"));
                    
                    // Check if response has a result array structure similar to primary setup
                    Object resultArray = getSellOfferResponse.path("result");
                    if (resultArray != null) {
                        // If response has a result array, extract from it like primary setup
                        System.out.println("Detected result array in secondary response, using array structure");
                        secondaryDataRoomId = String.valueOf(getSellOfferResponse.path("result[0].dataRoomId"));
                        secondaryBorrowerCountry = String.valueOf(getSellOfferResponse.path("result[0].borrowerCountry"));
                        secondarySellOfferSize = String.valueOf(getSellOfferResponse.path("result[0].sellOfferSize"));
                        secondaryCurrency = String.valueOf(getSellOfferResponse.path("result[0].currency"));
                        secondarySellOfferType = String.valueOf(getSellOfferResponse.path("result[0].sellOfferType"));
                        secondaryState = String.valueOf(getSellOfferResponse.path("result[0].state"));
                    }
                    
                    // Validate required fields
                    if (secondaryDataRoomId == null || secondaryDataRoomId.equals("null") ||
                        secondaryDraftId == null || secondaryDraftId.equals("null") || 
                        uniqueBorrowerName == null || uniqueBorrowerName.equals("null")) {
                        throw new RuntimeException("Missing required secondary deal details in response");
                    }
                    
                    // Store secondary data room ID in a consistent way with primary details
                    DealDetailsManager.put("secondaryDataRoomId", secondaryDataRoomId);
                    // Also store as secondorydataRoomid as originally requested
                    DealDetailsManager.put("secondorydataRoomid", secondaryDataRoomId);
                    
                    // Store additional details from the response in a consistent naming pattern
                    DealDetailsManager.put("secondaryBorrowerCountry", secondaryBorrowerCountry);
                    DealDetailsManager.put("secondarySellOfferSize", secondarySellOfferSize);
                    DealDetailsManager.put("secondaryCurrency", secondaryCurrency);
                    DealDetailsManager.put("secondarySellOfferType", secondarySellOfferType);
                    DealDetailsManager.put("secondaryState", secondaryState);
                    
                    // Also store with sec prefix as originally implemented (for backward compatibility)
                    DealDetailsManager.put("secBorrowerName", uniqueBorrowerName);
                    DealDetailsManager.put("secBorrowerCountry", secondaryBorrowerCountry);
                    DealDetailsManager.put("secSellOfferSize", secondarySellOfferSize);
                    DealDetailsManager.put("secCurrency", secondaryCurrency);
                    DealDetailsManager.put("secSellOfferType", secondarySellOfferType);
                    DealDetailsManager.put("secState", secondaryState);
                    
                    // Print details of stored secondary details for debugging
                    System.out.println("Successfully retrieved and stored secondary deal details");
                    System.out.println("Stored secondary deal details:");
                    System.out.println(" - secondaryDealId: " + DealDetailsManager.get("secondaryDealId"));
                    System.out.println(" - secondaryDataRoomId: " + DealDetailsManager.get("secondaryDataRoomId"));
                    System.out.println(" - secondaryBorrowerName: " + DealDetailsManager.get("secondaryBorrowerName"));
                    
                    System.out.println("Secondary seller setup completed successfully");
                } catch (Exception e) {
                    System.err.println("Error in secondary seller setup: " + e.getMessage());
                    e.printStackTrace();
                    System.err.println("Continuing with test execution despite secondary setup failure");
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
            System.out.println("Successfully created draft with Location: " + locationId);
        } catch (Exception e) {
            System.err.println("Error in @setUpDeal: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Deal setup failed", e);
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
            System.out.println("Successfully uploaded document with ID: " + documentId);

        } catch (Exception e) {
            System.err.println("Error in @uploadDoc: " + e.getMessage());
            e.printStackTrace();
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
            System.out.println("Requesting folder permissions from: " + mainUrl);

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
            System.out.println("Successfully retrieved folder permission with resource ID: " + resourceId);

        } catch (Exception e) {
            System.err.println("Error in @GetFolderPermission: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to get folder permission", e);
        }
    }


    @After
    public void afterScenario(io.cucumber.java.Scenario scenario) {
        boolean passed = !scenario.isFailed();
        ScenarioResultCollector.addResult(scenario.getName(), passed);
    }
    /**
     * Extracts the Sell Offer ID from the Location header after Draft Sell Offer creation,
     * saves it to DealDetails.json, and makes it available for subsequent scenarios.
     */
    @Before("@extractSellOfferId")
    public void beforeScenarioExtractSellOfferId() throws IOException {
        try {
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
            System.out.println("Successfully extracted and stored Sell Offer ID: " + sellOfferId);
        } catch (Exception e) {
            System.err.println("Error in @extractSellOfferId: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Sell Offer ID extraction failed", e);
        }
    }
      /**
     * Publishes the Sell Offer before running Delete Sell Offer scenarios.
     * Tag Delete_Sell_Offer.feature scenario with @publishSellOffer to use this hook.
     */
    @Before("@publishSellOffer")
    public void beforeScenarioPublishSellOffer() throws IOException {
        try {
            String publishMethod = getFrameworkConfig("PublishSellOfferMethod");
            String baseUrl = getFrameworkConfig("BaseUrl");
            String publishUrlTemplate = getFrameworkConfig("PublishSellOfferUrl");
            String requestBodyPath = getFrameworkConfig("Request_Bodies") + "Publish_Sell_Offer_Body_200.json";
            String requestBodyStr = JsonFileReader.getJsonAsString(requestBodyPath);
            if (requestBodyStr == null) {
                throw new RuntimeException("Failed to read publish sell offer request body from: " + requestBodyPath);
            }
            // Replace {{id}} with the current id from DealDetailsManager
            String sellOfferId = String.valueOf(DealDetailsManager.get("id"));
            if (sellOfferId == null || sellOfferId.trim().isEmpty()) {
                throw new RuntimeException("No Sell Offer ID found in DealDetailsManager");
            }
            requestBodyStr = requestBodyStr.replace("{{id}}", sellOfferId);
            String publishUrl = baseUrl + publishUrlTemplate.replace("{id}", sellOfferId);
            Response publishResponse = APIUtility.sendRequest(publishMethod, publishUrl, headers, null, requestBodyStr);
            if (publishResponse == null) {
                throw new RuntimeException("No response received from publish sell offer request");
            }
            if (publishResponse.getStatusCode() != 200 && publishResponse.getStatusCode() != 201) {
                throw new RuntimeException("Publish Sell Offer failed with status code: " + publishResponse.getStatusCode() +
                        ", Response: " + publishResponse.getBody().asString());
            }
            System.out.println("Successfully published Sell Offer with ID: " + sellOfferId);
        } catch (Exception e) {
            System.err.println("Error in @publishSellOffer: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Publish Sell Offer failed", e);
        }
    }
    @Before("@draftSellOfferId")
public void beforeScenarioDraftSellOfferId() throws IOException {
    try {
        String draftSellOfferMethod = getFrameworkConfig("DraftSellOfferMethod");
        String baseUrl = getFrameworkConfig("BaseUrl");
        String draftSellOfferUrl = getFrameworkConfig("DraftSellOfferUrl");
        String draftSellOfferBodyPath = getFrameworkConfig("Request_Bodies") + getFrameworkConfig("DraftSellOfferRequestBody");
        Object draftSellOfferRequestBody = JsonFileReader.getJsonAsString(draftSellOfferBodyPath);
        if (draftSellOfferRequestBody == null) {
            throw new RuntimeException("Failed to read Draft Sell Offer request body from: " + draftSellOfferBodyPath);
        }
        // Send Draft Sell Offer request
        Response draftSellOfferResponse = APIUtility.sendRequest(
            draftSellOfferMethod,
            baseUrl + draftSellOfferUrl,
            headers,
            null,
            draftSellOfferRequestBody
        );
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
        DealDetailsManager.put("sellOfferId", sellOfferId);
        System.out.println("Successfully extracted and stored Sell Offer ID: " + sellOfferId);
    } catch (Exception e) {
        System.err.println("Error in @draftSellOfferId: " + e.getMessage());
        e.printStackTrace();
        throw new RuntimeException("Draft Sell Offer ID extraction failed", e);
    }
}
}
