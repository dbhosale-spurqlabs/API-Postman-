Feature: DataRoom Folder Update API Validation

  @api
  Scenario Outline: Validate PUT Folder Update  API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName | method | url                                                          | headers        | queryFile | bodyFile                       | statusCode | schemaFile                    | contentType | fields         |
      | Valid update | PUT    | /api/v2/dataroom/{dataRoomId}/folders/{dataRoomRootFolderID} | NA             | NA        | DataRoom_Folder_Update_Request | 200        | DataRoom_Folder_Update_Schema | json        | type, success  |
#      | Invalid input | PUT    | /api/v2/dataroom/{dataRoomId}/folders/{dataRoomRootFolderID} | NA             | NA        | NA       | 400        |  | json        | error, Illegal Argument   |
      | Unauthorized | PUT    | /api/v2/dataroom/{dataRoomId}/folders/{dataRoomRootFolderID} | InvalidHeaders | NA        | NA                             | 401        | NA                            | text        | Jwt is expired |
#      | Forbidden     | PUT    | /api/v2/dataroom/{dataRoomId}/folders/{dataRoomRootFolderID}    | InvestorToken  | NA        | NA       | 403        |  | json        | error,Unauthorized action |
#      | Not Found     | PUT    | /api/v2/dataroom/{dataRoomId}/folders/{dataRoomRootFolderID}    | NA             | NA        | NA       | 404        |  | json        | error,Not Found           |

