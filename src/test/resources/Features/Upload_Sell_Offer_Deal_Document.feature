Feature: Upload Sell Offer Deal Document API Validation

  @api
  Scenario Outline: Validate POST Upload Sell Offer Deal Document API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName    | method | url                                      | headers        | queryFile | bodyFile                           | statusCode | schemaFile                           | contentType | fields                                                           |
      | Valid request   | POST   | /api/v2/sell-offers/{id}/deal-document  | NA            | NA        | Upload_Sell_Offer_Deal_Document_200| 200        | Upload_Sell_Offer_Deal_Document_Schema_200| json     | id,name,type,size,uploadedAt,uploadedBy,lastModifiedAt           |
      | Unauthorized    | POST   | /api/v2/sell-offers/{id}/deal-document  | InvalidHeaders | NA        | Upload_Sell_Offer_Deal_Document_401| 401        | NA                                  | text        | Jwt is expired                                                  |
