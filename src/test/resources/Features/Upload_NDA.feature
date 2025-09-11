Feature: Upload NDA

  @api
  Scenario Outline: Validate POST Upload NDA API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName    | method | url                | headers        | queryFile | bodyFile            | statusCode | schemaFile            | contentType | fields         |
      | Valid request   | POST   | /api/v1/documents  | NA            | NA        | Upload_NDA_Body_200 | 200        | Upload_NDA_Schema_200 | NA          | NA             |
      | Unauthorized    | POST   | /api/v1/documents  | InvalidHeaders | NA        | Upload_NDA_Body_401 | 401        | NA                   | text        | Jwt is expired |
