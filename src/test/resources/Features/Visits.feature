Feature: Visits API Validation

  @api

  Scenario Outline: Validate POST Visits API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName       | method | url                                 | headers        | queryFile | bodyFile | statusCode | schemaFile        | contentType | fields                                     |
#      | Valid creation     | POST   | /api/v2/dataroom/{dataRoomId}/visit | NA             | NA        | NA       | 200        | Visits_Schema_200 | json        | type,success                               |
#      | Bad Request        | POST   | /api/v2/dataroom/{dataRoomId}/visit | NA             | NA        | NA       | 400        |                   |             |                                            |
#      | Unauthorized       | POST   | /api/v2/dataroom/{dataRoomId}/visit | InvalidHeaders | NA        | NA       | 401        | NA                | text        | Jwt is expired                             |
#      | Forbidden          | POST   | /api/v2/dataroom/{dataRoomId}/visit | InvestorToken  | NA        | NA       | 403        | Visits_Schema_403 | json        | error, User not allowed to access dataroom |
#      | Duplicate resource | POST   | /api/v2/dataroom/{dataRoomId}/visit | NA             | NA        | NA       | 409        |                   |             |                                            |
#      | Validation failed  | POST   | /api/v2/dataroom/{dataRoomId}/visit | NA             | NA        | NA       | 422        |                   |             |                                            |
