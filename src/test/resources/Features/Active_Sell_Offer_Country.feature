Feature:  Active Sell Offer Country API Response Validation

  @api
  Scenario Outline: Validate GET Active Sell Offer Country API Response for "<scenarioName>" Scenario
    Given user has a valid sell offer id
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
  | scenarioName    | method | url                                   | headers        | queryFile                           | bodyFile | statusCode | schemaFile                           | contentType | fields         |
  | Valid request   | GET    | /api/v2/sell-offers/{id}/country      | NA            | Active_Sell_Offer_Country_Query_200 | NA      | 200        | Active_Sell_Offer_Country_Schema_200 | NA          | NA             |
  | Unauthorized    | GET    | /api/v2/sell-offers/{id}/country      | InvalidHeaders| Active_Sell_Offer_Country_Query_401 | NA      | 401        | NA                                  | text        | Jwt is expired |
