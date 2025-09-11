Feature: Activity API Validation

  @api

  Scenario Outline: Validate POST Activity API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName   | method | url                                    | headers        | queryFile      | bodyFile             | statusCode | schemaFile          | contentType | fields                                    |
      | Valid creation | POST   | /api/v2/dataroom/{dataRoomId}/activity | NA             | Activity_Query | Activity_Request_200 | 200        | Activity_Schema_200 | json        | data.data_room, {dataRoomId}              |
#      | Bad Request    | POST   | /api/v2/dataroom/{dataRoomId}/activity | NA             | Activity_Query | Activity_Request_400 | 400        | Activity_Schema_400 | json        | type,error                                |
      | Unauthorized   | POST   | /api/v2/dataroom/{dataRoomId}/activity | InvalidHeaders | Activity_Query | Activity_Request_200 | 401        | NA                  | text        | Jwt is expired                            |
#      | Forbidden      | POST   | /api/v2/dataroom/{dataRoomId}/activity | InvestorToken  | Activity_Query | Activity_Request_200 | 403        | Activity_Schema_403 | json        | error,User not allowed to access dataroom |
#      | Duplicate resource | POST   | /api/v2/dataroom/{dataRoomId}/activity | NA             | Activity_Query | Activity_Request     | 409        |                     |             |                              |
#      | Validation failed  | POST   | /api/v2/dataroom/{dataRoomId}/activity | NA             | Activity_Query | Activity_Request     | 422        |                     |             |                              |