Feature: Create Sell Offer Note API Validation

  @api
  Scenario Outline: Validate POST Create Sell Offer Note API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName    | method | url                             | headers        | queryFile | bodyFile                      | statusCode | schemaFile                      | contentType | fields                                                   |
      | Valid request   | POST   | /api/v2/sell-offers/{id}/notes  | NA            | NA        | Create_Sell_Offer_Note_200    | 200        | Create_Sell_Offer_Note_Schema_200| json        | id,content,isPinned,createdAt,createdBy,updatedAt        |
      | Unauthorized    | POST   | /api/v2/sell-offers/{id}/notes  | InvalidHeaders | NA        | Create_Sell_Offer_Note_401    | 401        | NA                             | text        | Jwt is expired                                          |
