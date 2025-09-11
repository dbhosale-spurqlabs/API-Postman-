Feature: Get Sell Offer Notes API Validation

  @api
  Scenario Outline: Validate GET Sell Offer Notes API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName    | method | url                             | headers        | queryFile                  | bodyFile | statusCode | schemaFile                  | contentType | fields                                                   |
      | Valid request   | GET    | /api/v2/sell-offers/{id}/notes  | NA            | Get_Sell_Offer_Notes_200   | NA      | 200        | Get_Sell_Offer_Notes_Schema_200 | json    | id,content,isPinned,createdAt,createdBy,updatedAt        |
      | Unauthorized    | GET    | /api/v2/sell-offers/{id}/notes  | InvalidHeaders | Get_Sell_Offer_Notes_401   | NA      | 401        | NA                         | text        | Jwt is expired                                          |
