Feature: Assign New Group Permission Folder API Validation


  Scenario Outline: Validate POST Assign New Group Permission Folder API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName   | method | url                                                            | headers        | queryFile | bodyFile                                   | statusCode | schemaFile                                    | contentType | fields         |
#      | Valid creation | POST   | /api/v2/dataroom/{dataRoomId}/folders/{dataRoomFolderId}/GROUP | NA             | NA        | Assign_New_Group_Permission_Folder_Request | 200        | Assign_New_Group_Permission_Folder_Schema_200 | json        | type, success  |
#      | Bad Request    | POST   | /api/v2/dataroom/{dataRoomId}/folders/{dataRoomFolderId}/GROUP | NA             | NA        | Assign_New_Group_Permission_Folder_Request | 400        | Assign_New_Group_Permission_Folder_Schema_400 | json        | error,Illegal Argument    |
#      | Unauthorized   | POST   | /api/v2/dataroom/{dataRoomId}/folders/{dataRoomFolderId}/GROUP | InvalidHeaders | NA        | Assign_New_Group_Permission_Folder_Request | 401        | NA                                            | text        | Jwt is expired |
#      | Forbidden      | POST   | /api/v2/dataroom/{dataRoomId}/folders/{dataRoomFolderId}/GROUP  | InvestorToken  | NA        | Assign_New_Group_Permission_Folder_Request | 403        | Assign_New_Group_Permission_Folder_Schema_403 | json        | error,Unauthorized action |
#      | Duplicate resource | POST   | /api/v2/dataroom/{dataRoomId}/folders/{dataRoomFolderId}/GROUP  | NA  | NA        | Assign_New_Group_Permission_Folder_Request | 409        |                         |             |                           |
#      | Validation failed  | POST   | /api/v2/dataroom/{dataRoomId}/folders/{dataRoomFolderId}/GROUP  | NA  | NA        | Assign_New_Group_Permission_Folder_Request | 422        |                         |             |                           |