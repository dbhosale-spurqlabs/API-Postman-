Feature: DataRoom File Activity API Validation
#
#  @api
#  Scenario Outline: Validate POST DataRoom File Move API Response for "<scenarioName>" Scenario
#    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
#    Then User verifies the response status code is <statusCode>
#    And User verifies the response body matches JSON schema "<schemaFile>"
#    Then User verifies fields in response: "<contentType>" with content type "<fields>"
#    Examples:
#      | scenarioName   | method | url                                | headers        | queryFile | bodyFile                       | statusCode | schemaFile                    | contentType | fields         |
#      | Valid creation | POST   | /api/v2/dataroom/{dataRoomId}/move | NA             | NA        | DataRoom_File_Move_Request_200 | 200        | DataRoom_File_Move_Schema_200 | json        | type, success  |
#      | Unauthorized   | POST   | /api/v2/dataroom/{dataRoomId}/move | InvalidHeaders | NA        | DataRoom_File_Move_Request_200 | 401        | NA                            | text        | Jwt is expired |
#
#  @api
#  Scenario Outline: Validate POST DataRoom File Copy API Response for "<scenarioName>" Scenario
#    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
#    Then User verifies the response status code is <statusCode>
#    And User verifies the response body matches JSON schema "<schemaFile>"
#    Then User verifies fields in response: "<contentType>" with content type "<fields>"
#    Examples:
#      | scenarioName   | method | url                                | headers        | queryFile | bodyFile                       | statusCode | schemaFile                    | contentType | fields         |
#      | Valid creation | POST   | /api/v2/dataroom/{dataRoomId}/copy | NA             | NA        | DataRoom_File_Copy_Request_200 | 200        | DataRoom_File_Copy_Schema_200 | json        | type, success  |
#      | Unauthorized   | POST   | /api/v2/dataroom/{dataRoomId}/copy | InvalidHeaders | NA        | DataRoom_File_Copy_Request_200 | 401        | NA                            | text        | Jwt is expired |
