Feature: Sell Offer Recap API Validation

  @api
  Scenario Outline: Validate GET Sell Offer Recap API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName    | method | url                              | headers        | queryFile                      | bodyFile | statusCode | schemaFile                      | contentType | fields                                                                           |
      | Valid request   | GET    | /api/v2/sell-offers/{id}/recap  | NA            | NA    | NA      | 200        | Sell_Offer_Recap_Schema_200     | json        | id,offerStatus,borrowerName,sellOfferSize,currency,marketSegment,createdAt       |
      | Unauthorized    | GET    | /api/v2/sell-offers/{id}/recap  | NA            | NA    | NA      | 401        | NA                             | text        | Jwt is expired                                                                  |
