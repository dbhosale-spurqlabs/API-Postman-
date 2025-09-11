Feature: Delete Sell Offer Note API Validation

  @api
  Scenario Outline: Validate DELETE Sell Offer Note API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName    | method | url                                     | headers        | queryFile | bodyFile | statusCode | schemaFile                    | contentType | fields                                    |
      | Valid request   | DELETE | /api/v2/sell-offers/{id}/notes/{noteId}| NA            | NA        | NA       | 200        | Delete_Sell_Offer_Note_Schema_200| json      | id,status,deletedAt,deletedBy             |
      | Unauthorized    | DELETE | /api/v2/sell-offers/{id}/notes/{noteId}| InvalidHeaders | NA        | NA       | 401        | NA                           | text        | Jwt is expired                           |
