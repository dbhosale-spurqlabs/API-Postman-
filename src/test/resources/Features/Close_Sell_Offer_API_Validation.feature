Feature: Close Sell Offer API Validation

  @api
  Scenario Outline: Validate GET Close Sell Offer API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName    | method | url                | headers        | queryFile                    | bodyFile | statusCode | schemaFile                    | contentType | fields                                                                |
      |  Valid creation  | GET    | /api/v2/sell-offers| NA            | Close_Sell_Offer_Query_200   | NA      | 200        | Close_Sell_Offer_Schema_200   | json        | id,state,borrowerName,borrowerCountry,sellOfferSize,currency         |
      | Unauthorized    | GET    | /api/v2/sell-offers| InvalidHeaders| Close_Sell_Offer_Query_401   | NA      | 401        | NA                           | text        | Jwt is expired                                                       |