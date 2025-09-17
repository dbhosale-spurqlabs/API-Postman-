Feature: DataRoom Email Notification API Validation

        @api

        Scenario Outline: Validate GET Email Notification API Response for "<scenarioName>" Scenario
             When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
             Then User verifies the response status code is <statusCode>
              And User verifies the response body matches JSON schema "<schemaFile>"
             Then User verifies fields in response: "<contentType>" with content type "<fields>"
        Examples:
                  | scenarioName | method | url                                        | headers | queryFile | bodyFile | statusCode | schemaFile                    | contentType | fields       |
                  | Valid        | GET    | /api/v2/dataroom/{dataRoomId}/notification | NA      | NA        | NA       | 200        | Email_Notification_Schema_200 | json        | type,success |
#      | Invalid ID format | GET    | /api/v2/dataroom/{dataRoomId}/notification | NA             | NA        | NA       | 400        |                       |             |                |
                  | Unauthorized | GET | /api/v2/dataroom/{dataRoomId}/notification | InvalidHeaders | NA | NA | 401 | NA | text | Jwt is expired |
#      | Forbidden    | GET    | /api/v2/dataroom/{dataRoomId}/notification | NA      | NA        | NA | 403        | NA                   |         |       |
#      | Not Found         | GET    | /api/v2/dataroom/{dataRoomId}/notification | NA             | NA | NA       | 404        |                       |             |                        |

        @api
        Scenario Outline: Validate POST Email Notification API Response for "<scenarioName>" Scenario
             When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
             Then User verifies the response status code is <statusCode>
              And User verifies the response body matches JSON schema "<schemaFile>"
             Then User verifies fields in response: "<contentType>" with content type "<fields>"
        Examples:
                  | scenarioName   | method | url                                        | headers | queryFile | bodyFile                                | statusCode | schemaFile                             | contentType | fields        |
                  | Valid creation | POST   | /api/v2/dataroom/{dataRoomId}/notification | NA      | NA        | DataRoom_Email_Notification_Request_200 | 200        | DataRoom_Email_Notification_Schema_200 | json        | type, success |
#      | Bad Request    | POST   | /api/v2/dataroom/{dataRoomId}/notification | NA             | NA        | DataRoom_Email_Notification_Request_200 | 400        |  | NA          | error,Illegal Argument |
                  | Unauthorized | POST | /api/v2/dataroom/{dataRoomId}/notification | InvalidHeaders | NA | DataRoom_Email_Notification_Request_200 | 401 | NA | text | Jwt is expired |
#      | Forbidden      | POST   | /api/v2/dataroom/{dataRoomId}/notification | InvestorToken  | NA        | DataRoom_Email_Notification_Request_200 | 403        |                                    |             |                        |
#      | Duplicate resource | POST   | /api/v2/dataroom/{dataRoomId}/notification  | InvestorToken  | NA        | DataRoom_Email_Notification_Request_200 | 409        |                         |             |                           |
#      | Validation failed  | POST   | /api/v2/dataroom/{dataRoomId}/notification  | InvestorToken  | NA        | DataRoom_Email_Notification_Request_200 | 422        |                         |             |                           |