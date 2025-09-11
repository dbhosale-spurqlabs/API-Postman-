Feature: DataRoom User Activity Reports API Validation

  @api
  Scenario Outline: Validate GET DataRoom User Activity Reports API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName   | method | url                                    | headers        | queryFile                            | bodyFile | statusCode | schemaFile                                | contentType | fields         |
      | Valid creation | GET    | /api/v2/dataroom/{dataRoomId}/activity | NA             | DataRoom_User_Activity_Reports_Query | NA       | 200        | DataRoom_User_Activity_Reports_Schema_200 | json        | type, success  |
      | Unauthorized   | GET    | /api/v2/dataroom/{dataRoomId}/activity | InvalidHeaders | DataRoom_User_Activity_Reports_Query | NA       | 401        | NA                                        | text        | Jwt is expired |