Feature: Get Sell Offer Status API Validation

  @api
  Scenario Outline: Validate GET Sell Offer Status API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName    | method | url                               | headers        | queryFile                     | bodyFile | statusCode | schemaFile                     | contentType | fields                                                |
      | Valid request   | GET    | /api/v2/sell-offers/{id}/status  | NA            | Get_Sell_Offer_Status_200     | NA      | 200        | Get_Sell_Offer_Status_Schema_200| json       | id,status,updatedAt,updatedBy                        |
      | Unauthorized    | GET    | /api/v2/sell-offers/{id}/status  | InvalidHeaders | Get_Sell_Offer_Status_401     | NA      | 401        | NA                            | text        | Jwt is expired                                       |
