Feature: View Sell Offer

  @api  @extractSellOfferId
  Scenario Outline: Validate GET View Sell Offer API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName    | method | url                          | headers        | queryFile | bodyFile | statusCode | schemaFile                  | contentType | fields         |
      | Valid request   | GET    | /api/v2/sell-offers/{id}   | NA            | NA        | NA       | 200       | View_Sell_Offer_Schema_200  | json        | status, 200            |
      | Unauthorized    | GET    | /api/v2/sell-offers/{id}   | InvalidHeaders | NA        | NA       | 401        | NA                         | text        | Jwt is expired |
