Feature: Update Circling Date API Validation

  @api
  Scenario Outline: Validate PUT Update Circling Date API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName    | method | url                                    | headers        | queryFile                          | bodyFile                          | statusCode | schemaFile                          | contentType | fields                                    |
      | Valid request   | PUT    | /api/v2/sell-offers/{id}/circling-date| NA            | Update_Circling_Date_Query_200     | Update_Circling_Date_Body_200     | 200        | Update_Circling_Date_Schema_200     | json        | id,circlingDate,updatedAt,updatedBy       |
      | Unauthorized    | PUT    | /api/v2/sell-offers/{id}/circling-date| InvalidHeaders| Update_Circling_Date_Query_401     | Update_Circling_Date_Body_401     | 401        | NA                                 | text        | Jwt is expired                           |
