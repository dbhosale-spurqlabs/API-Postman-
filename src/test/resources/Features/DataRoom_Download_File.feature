Feature: DataRoom Download File API Validation

  @api

  Scenario Outline: Validate POST DataRoom Download File API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName   | method | url                                 | headers        | queryFile | bodyFile                           | statusCode | schemaFile                        | contentType | fields         |
      | Valid creation | POST   | /api/v2/dataroom/{dataRoomId}/files | NA             | NA        | DataRoom_Download_File_Request_200 | 200        | DataRoom_Download_File_Schema_200 | json        | type, success  |
#      | Bad Request    | POST   | /api/v2/dataroom/{dataRoomId}/files | NA             | NA        | DataRoom_Download_File_Request_200 | 400        |  | NA          | error,Illegal Argument |
      | Unauthorized   | POST   | /api/v2/dataroom/{dataRoomId}/files | InvalidHeaders | NA        | DataRoom_Download_File_Request_200 | 401        | NA                                | text        | Jwt is expired |
#      | Forbidden      | POST   | /api/v2/dataroom/{dataRoomId}/files | InvestorToken  | NA        | DataRoom_Download_File_Request_200 | 403        |                                    |             |                        |
#      | Duplicate resource | POST   | /api/v2/dataroom/{dataRoomId}/files  | InvestorToken  | NA        | DataRoom_Download_File_Request_200 | 409        |                         |             |                           |
#      | Validation failed  | POST   | /api/v2/dataroom/{dataRoomId}/files  | InvestorToken  | NA        | DataRoom_Download_File_Request_200 | 422        |                         |             |                           |