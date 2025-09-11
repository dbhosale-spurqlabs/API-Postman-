Feature: DataRoom Create Folder and Activity API Validation

  @api

  Scenario Outline: Validate POST DataRoom Create Folder API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName   | method | url                                                      | headers        | queryFile | bodyFile                           | statusCode | schemaFile                        | contentType | fields         |
      | Valid creation | POST   | /api/v2/dataroom/{dataRoomId}/folders/{dataRoomFolderId} | NA             | NA        | DataRoom_Create_Folder_Request_200 | 200        | DataRoom_Create_Folder_Schema_200 | json        | type, success  |
#      | Bad Request    | POST   | /api/v2/dataroom/{dataRoomId}/folders/{dataRoomFolderId} | NA             | NA        | DataRoom_Create_Folder_Request_200 | 400        |  | json        | type,error                                |
      | Unauthorized   | POST   | /api/v2/dataroom/{dataRoomId}/folders/{dataRoomFolderId} | InvalidHeaders | NA        | DataRoom_Create_Folder_Request_200 | 401        | NA                                | text        | Jwt is expired |
#      | Forbidden      | POST   | /api/v2/dataroom/{dataRoomId}/folders/{dataRoomFolderId} | InvestorToken  | NA        | DataRoom_Create_Folder_Request_200 | 403        |  | json        | error,User not allowed to access dataroom |
#      | Duplicate resource | POST   | /api/v2/dataroom/{dataRoomId}/folders/{dataRoomFolderId} | NA             | NA        | DataRoom_Create_Folder_Request_200 | 409        |                        |             |                                           |
#      | Validation failed  | POST   | /api/v2/dataroom/{dataRoomId}/folders/{dataRoomFolderId} | NA             | NA        | DataRoom_Create_Folder_Request_200 | 422        |                        |             |                                           |

  @api
  Scenario Outline: Validate POST Create Folder Activity API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName   | method | url                                    | headers        | queryFile      | bodyFile                           | statusCode | schemaFile                        | contentType | fields         |
      | Valid creation | POST   | /api/v2/dataroom/{dataRoomId}/activity | NA             | Activity_Query | Create_Folder_Activity_Request_200 | 200        | Create_Folder_Activity_Schema_200 | json        | type, success  |
#      | Bad Request    | POST   | /api/v2/dataroom/{dataRoomId}/activity | NA             | Activity_Query | Create_Folder_Activity_Request_200 | 400        | Create_Folder_Activity_Schema_400 | json        | type,error                                |
      | Unauthorized   | POST   | /api/v2/dataroom/{dataRoomId}/activity | InvalidHeaders | Activity_Query | Create_Folder_Activity_Request_200 | 401        | NA                                | text        | Jwt is expired |
#      | Forbidden      | POST   | /api/v2/dataroom/{dataRoomId}/activity | InvestorToken  | Activity_Query | Create_Folder_Activity_Request_200 | 403        | Create_Folder_Activity_Schema_403 | json        | error,User not allowed to access dataroom |
#      | Duplicate resource | POST   | /api/v2/dataroom/{dataRoomId}/activity | NA             | Activity_Query | Create_Folder_Activity_Request_200     | 409        |                     |             |                              |
#      | Validation failed  | POST   | /api/v2/dataroom/{dataRoomId}/activity | NA             | Activity_Query | Create_Folder_Activity_Request_200     | 422        |                     |             |                              |

  @api
  Scenario Outline: Validate GET File and Folder Structure API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName | method | url                                   | headers        | queryFile | bodyFile | statusCode | schemaFile                           | contentType | fields         |
      | Valid        | GET    | /api/v2/dataroom/{dataRoomId}/folders | NA             | NA        | NA       | 200        | File_and_Folder_Structure_Schema_200 | json        | type, success  |
#      | Invalid ID format | GET    | /api/v2/dataroom/{dataRoomId}_/folders | NA             | NA        | NA       | 400        |                             |             |                                           |
      | Unauthorized | GET    | /api/v2/dataroom/{dataRoomId}/folders | InvalidHeaders | NA        | NA       | 401        | NA                                   | text        | Jwt is expired |
#      | Forbidden    | GET    | /api/v2/dataroom/{dataRoomId}/folders | InvestorToken  | NA        | NA       | 403        | File_and_Folder_Structure_Schema_403 | json        | error,User not allowed to access dataroom |
#      | Not Found         | GET    | /api/v2/dataroom/{dataRoomId}2/folders | NA             | NA        | NA       | 404        |                             |             |                                           |

