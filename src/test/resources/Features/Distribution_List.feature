Feature: Distribution List

  @api
  Scenario Outline: Validate GET Distribution List API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName    | method | url                           | headers        | queryFile | bodyFile | statusCode | schemaFile                     | contentType | fields         |
      | Valid request   | GET    | /api/v1/participants/my/dl   | NA            | NA        | NA       | 200        | Distribution_List_Schema_200   | NA          | NA             |
      | Unauthorized    | GET    | /api/v1/participants/my/dl   | InvalidHeaders | NA        | NA       | 401        | NA                            | text        | Jwt is expired |
