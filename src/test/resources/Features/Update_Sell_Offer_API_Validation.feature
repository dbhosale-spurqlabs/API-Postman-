Feature: Update Sell Offer API Validation

  @api
  Scenario Outline: Validate PUT Update Sell Offer API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName    | method | url                                                                     | headers        | queryFile | bodyFile                    | statusCode | schemaFile                    | contentType | fields         |
      | Valid request   | PUT    | /api/v2/sell-offers/draft/cacc8b95-0726-443e-b2c1-c7cf57637633       | NA            | NA        | Update_Sell_Offer_Body_200  | 401        | Update_Sell_Offer_Schema_200  | NA          | NA             |
      | Unauthorized    | PUT    | /api/v2/sell-offers/draft/cacc8b95-0726-443e-b2c1-c7cf57637633       | InvalidHeaders | NA        | Update_Sell_Offer_Body_401  | 401        | NA                           | text        | Jwt is expired |
