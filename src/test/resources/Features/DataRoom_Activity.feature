Feature: DataRoom Activity

  @api
  Scenario Outline: Validate POST DataRoom Activity API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName    | method | url                                                              | headers        | queryFile | bodyFile                     | statusCode | schemaFile                     | contentType | fields                                    |
      | Valid request   | POST   | /api/v2/dataroom/8b7ce343-5a0a-48c3-ab0b-ce6a0ec138de/activity | NA            | NA        | DataRoom_Activity_Body_200   | 200        | DataRoom_Activity_Schema_200   | json        | id,activityType,description,performedAt    |
      | Unauthorized    | POST   | /api/v2/dataroom/8b7ce343-5a0a-48c3-ab0b-ce6a0ec138de/activity | InvalidHeaders | NA        | DataRoom_Activity_Body_401   | 401        | NA                            | text        | Jwt is expired                           |
