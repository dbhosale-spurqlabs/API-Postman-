Feature: Active Sell Offer Offer Size API Validation

  @api
  Scenario Outline: Validate GET Active Sell Offer Offer Size API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName    | method | url                | headers        | queryFile                               | bodyFile | statusCode | schemaFile                               | contentType | fields                                    |
      | Valid request   | GET    | /api/v2/sell-offers| NA            | Active_Sell_Offer_Offer_Size_Query_200  | NA      | 200        | Active_Sell_Offer_Offer_Size_Schema_200  | json        | id,minAmount,maxAmount,currency,createdAt |
      | Unauthorized    | GET    | /api/v2/sell-offers| InvalidHeaders| Active_Sell_Offer_Offer_Size_Query_401  | NA      | 401        | NA                                      | text        | Jwt is expired                           |
