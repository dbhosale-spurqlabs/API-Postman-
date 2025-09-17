Feature: DataRoom Activity API Validation



        @api @setupDataRoom
        Scenario Outline: Validate POST DataRoom Activity API Response for "<scenarioName>" Scenario
             When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
             Then User verifies the response status code is <statusCode>
              And User verifies the response body matches JSON schema "<schemaFile>"
             Then User verifies fields in response: "<contentType>" with content type "<fields>"
        Examples:
                  | scenarioName  | method | url                                         | headers        | queryFile                   | bodyFile                   | statusCode | schemaFile                   | contentType | fields         |
                  | Valid request | POST   | /api/v2/dataroom/{secondoryroomid}/activity | NA             | DataRoom_Activity_Query_200 | DataRoom_Activity_Body_200 | 200        | DataRoom_Activity_Schema_200 | json        | status, 200    |
                  | Unauthorized  | POST   | /api/v2/dataroom/{secondoryroomid}/activity | InvalidHeaders | DataRoom_Activity_Query_401 | DataRoom_Activity_Body_200 | 401        | NA                           | text        | Jwt is expired |

        