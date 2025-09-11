Feature: Sell Offer API Validation

  @api
  Scenario Outline: Validate GET Sell Offer API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName | method | url                 | headers        | queryFile            | bodyFile | statusCode | schemaFile            | contentType | fields         |
      | Valid        | GET    | /api/v2/sell-offers | NA             | Sell_Offer_Query_200 | NA       | 200        | Sell_Offer_Schema_200 | json        | status , 200   |
#      | Invalid ID format | GET    | /api/v2/sell-offers | NA             | Sell_Offer_Query_400 | NA       | 400        | Sell_Offer_Schema_400 | json        | error,Illegal Argument                 |
      | Unauthorized | GET    | /api/v2/sell-offers | InvalidHeaders | Sell_Offer_Query_200 | NA       | 401        | NA                    | text        | Jwt is expired |
#      | Forbidden         | GET    | /api/v2/sell-offers | InvestorToken  | Sell_Offer_Query_200 | NA       | 403        |                       |             |                        |
#      | Not Found         | GET    | /api/v2/sell-offers | NA             | Sell_Offer_Query_200 | NA       | 404        |                       |             |                        |