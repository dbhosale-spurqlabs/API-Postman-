Feature: DataRoom Folder Permission MP API Validation

  @api
  Scenario Outline: Validate GET DataRoom Folder Permission MP Get API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName   | method | url                                                                                     | headers        | queryFile | bodyFile | statusCode | schemaFile                                   | contentType | fields         |
      | Valid creation | GET    | /api/v2/dataroom/{dataRoomId}/permissions/folders/{dataRoomFolderId}/MARKET_PARTICIPANT | NA             | NA        | NA       | 200        | DataRoom_Folder_Permission_MP_Get_Schema_200 | json        | type, success  |
      | Unauthorized   | GET    | /api/v2/dataroom/{dataRoomId}/permissions/folders/{dataRoomFolderId}/MARKET_PARTICIPANT | InvalidHeaders | NA        | NA       | 401        | NA                                           | text        | Jwt is expired |

  @api
  Scenario Outline: Validate POST DataRoom Folder Permission MP Set API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName   | method | url                                                                                     | headers        | queryFile | bodyFile                                      | statusCode | schemaFile                                   | contentType | fields         |
      | Valid creation | POST   | /api/v2/dataroom/{dataRoomId}/permissions/folders/{dataRoomFolderId}/MARKET_PARTICIPANT | NA             | NA        | DataRoom_Folder_Permission_MP_Set_Request_200 | 200        | DataRoom_Folder_Permission_MP_Set_Schema_200 | json        | type, success  |
      | Unauthorized   | POST   | /api/v2/dataroom/{dataRoomId}/permissions/folders/{dataRoomFolderId}/MARKET_PARTICIPANT | InvalidHeaders | NA        | DataRoom_Folder_Permission_MP_Set_Request_200 | 401        | NA                                           | text        | Jwt is expired |

