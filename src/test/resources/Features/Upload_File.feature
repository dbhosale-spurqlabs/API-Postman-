#Feature: Root Folder Name API Validation
#
#
#  Scenario Outline: Validate POST Root Folder Name API Response for "<scenarioName>" Scenario
#    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
#    Then User verifies the response status code is <statusCode>
#    And User verifies the response body matches JSON schema "<schemaFile>"
#    Then User verifies fields in response: "<contentType>" with content type "<fields>"
#    Examples:
#      | scenarioName       | method | url                                                      | headers        | queryFile | bodyFile                | statusCode | schemaFile             | contentType | fields                                    |
#      | Valid creation     | POST   | /api/v2/dataroom/{dataRoomId}/folders/{dataRoomFolderID} | NA             | NA        | Upload_File_Request_200 | 200        | Upload_File_Schema_200 | json        | type, success                             |
#      | Bad Request        | POST   | /api/v2/dataroom/{dataRoomId}/folders/{dataRoomFolderID} | NA             | NA        | Upload_File_Request_200 | 400        | Upload_File_Schema_400 | json        | type,error                                |
#      | Unauthorized       | POST   | /api/v2/dataroom/{dataRoomId}/folders/{dataRoomFolderID} | InvalidHeaders | NA        | Upload_File_Request_200 | 401        | NA                     | text        | Jwt is expired                            |
#      | Forbidden          | POST   | /api/v2/dataroom/{dataRoomId}/folders/{dataRoomFolderID} | InvestorToken  | NA        | Upload_File_Request_200 | 403        | Upload_File_Schema_403 | json        | error,User not allowed to access dataroom |
#      | Duplicate resource | POST   | /api/v2/dataroom/{dataRoomId}/folders/{dataRoomFolderID} | NA             | NA        | Upload_File_Request_200 | 409        |                        |             |                                           |
#      | Validation failed  | POST   | /api/v2/dataroom/{dataRoomId}/folders/{dataRoomFolderID} | NA             | NA        | Upload_File_Request_200 | 422        |                        |             |                                           |