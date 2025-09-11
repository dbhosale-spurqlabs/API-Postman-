Feature: Sell Offer Partnership Status API Validation

  @api
  Scenario Outline: Validate GET Sell Offer Partnership Status API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName    | method | url                                      | headers        | queryFile                                | bodyFile | statusCode | schemaFile                                | contentType | fields                                    |
      | Valid request   | GET    | /api/v2/sell-offers/{id}/partnership    | NA            | Sell_Offer_Partnership_Status_Query_200  | NA      | 200        | Sell_Offer_Partnership_Status_Schema_200  | json        | id,status,lastUpdatedAt,lastUpdatedBy     |
      | Unauthorized    | GET    | /api/v2/sell-offers/{id}/partnership    | InvalidHeaders| Sell_Offer_Partnership_Status_Query_401  | NA      | 401        | NA                                       | text        | Jwt is expired                           |
