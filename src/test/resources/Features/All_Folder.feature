Feature: All Folder API Validation

  @api

  Scenario Outline: Validate GET Folder Structure API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName | method | url                                   | headers        | queryFile | bodyFile | statusCode | schemaFile                  | contentType | fields                          |
      | Valid        | GET    | /api/v2/dataroom/{dataRoomId}/folders | NA             | NA        | NA       | 200        | Folder_Structure_Schema_200 | json        | data.folder_name,{borrowerName} |
#      | Invalid ID format | GET    | /api/v2/dataroom/{dataRoomId}_/folders | NA             | NA        | NA       | 400        |                             |             |                                           |
      | Unauthorized | GET    | /api/v2/dataroom/{dataRoomId}/folders | InvalidHeaders | NA        | NA       | 401        | NA                          | text        | Jwt is expired                  |
#      | Forbidden    | GET    | /api/v2/dataroom/{dataRoomId}/folders | InvestorToken  | NA        | NA       | 403        | Folder_Structure_Schema_403 | json        | error,User not allowed to access dataroom |
#      | Not Found         | GET    | /api/v2/dataroom/{dataRoomId}2/folders | NA             | NA        | NA       | 404        |                             |             |                                           |

  @api
  Scenario Outline: Validate GET Permission of Folder API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName | method | url                                       | headers        | queryFile | bodyFile | statusCode | schemaFile                      | contentType | fields                        |
      | Valid        | GET    | /api/v2/dataroom/{dataRoomId}/permissions | NA             | NA        | NA       | 200        | Permission_of_Folder_Schema_200 | json        | data.dataroom_id,{dataRoomId} |
#      | Invalid ID format | GET    | /api/v2/dataroom/{dataRoomId}_/permissions | NA             | NA        | NA       | 400        |                                 |             |                                           |
      | Unauthorized | GET    | /api/v2/dataroom/{dataRoomId}/permissions | InvalidHeaders | NA        | NA       | 401        | NA                              | text        | Jwt is expired                |
#      | Forbidden    | GET    | /api/v2/dataroom/{dataRoomId}/permissions | InvestorToken  | NA        | NA       | 403        | Permission_of_Folder_Schema_403 | json        | error,User not allowed to access dataroom |
#      | Not Found         | GET    | /api/v2/dataroom/{dataRoomId}2/permissions | NA             | NA        | NA       | 404        |                                 |             |                                           |

  @api
  Scenario Outline: Validate POST Visits API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName   | method | url                                 | headers        | queryFile | bodyFile | statusCode | schemaFile        | contentType | fields         |
      | Valid creation | POST   | /api/v2/dataroom/{dataRoomId}/visit | NA             | NA        | NA       | 200        | Visits_Schema_200 | json        | type,success   |
#      | Bad Request        | POST   | /api/v2/dataroom/{dataRoomId}/visit | NA             | NA        | NA       | 400        |                   |             |                                            |
      | Unauthorized   | POST   | /api/v2/dataroom/{dataRoomId}/visit | InvalidHeaders | NA        | NA       | 401        | NA                | text        | Jwt is expired |
#      | Forbidden          | POST   | /api/v2/dataroom/{dataRoomId}/visit | InvestorToken  | NA        | NA       | 403        | Visits_Schema_403 | json        | error, User not allowed to access dataroom |
#      | Duplicate resource | POST   | /api/v2/dataroom/{dataRoomId}/visit | NA             | NA        | NA       | 409        |                   |             |                                            |
#      | Validation failed  | POST   | /api/v2/dataroom/{dataRoomId}/visit | NA             | NA        | NA       | 422        |                   |             |                                            |

  @api
  Scenario Outline: Validate POST Root Folder Name API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName   | method | url                                                          | headers        | queryFile | bodyFile                | statusCode | schemaFile             | contentType | fields         |
      | Valid creation | POST   | /api/v2/dataroom/{dataRoomId}/folders/{dataRoomRootFolderID} | NA             | NA        | Upload_File_Request_200 | 200        | Upload_File_Schema_200 | json        | type, success  |
#      | Bad Request    | POST   | /api/v2/dataroom/{dataRoomId}/folders/{dataRoomRootFolderID} | NA             | NA        | Upload_File_Request_400 | 400        | Upload_File_Schema_400 | json        | type,error                                |
      | Unauthorized   | POST   | /api/v2/dataroom/{dataRoomId}/folders/{dataRoomRootFolderID} | InvalidHeaders | NA        | Upload_File_Request_200 | 401        | NA                     | text        | Jwt is expired |
#      | Forbidden      | POST   | /api/v2/dataroom/{dataRoomId}/folders/{dataRoomRootFolderID} | InvestorToken  | NA        | Upload_File_Request_200 | 403        | Upload_File_Schema_403 | json        | error,User not allowed to access dataroom |
#      | Duplicate resource | POST   | /api/v2/dataroom/{dataRoomId}/folders/{dataRoomRootFolderID} | NA             | NA        | Upload_File_Request_200 | 409        |                        |             |                                           |
#      | Validation failed  | POST   | /api/v2/dataroom/{dataRoomId}/folders/{dataRoomRootFolderID} | NA             | NA        | Upload_File_Request_200 | 422        |                        |             |                                           |

  @api
  Scenario Outline: Validate GET Existing Folder Permission API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName | method | url                                                          | headers        | queryFile | bodyFile | statusCode | schemaFile                            | contentType | fields         |
      | Valid        | GET    | /api/v2/dataroom/{dataRoomId}/folders/{dataRoomRootFolderID} | NA             | NA        | NA       | 200        | Existing_Folder_Permission_Schema_200 | json        | type, success  |
#      | Invalid ID format | GET    | /api/v2/dataroom/{dataRoomId}/folders/{dataRoomFolderId} | NA             | NA        | NA       | 400        |                             |             |                                           |
      | Unauthorized | GET    | /api/v2/dataroom/{dataRoomId}/folders/{dataRoomRootFolderID} | InvalidHeaders | NA        | NA       | 401        | NA                                    | text        | Jwt is expired |
#      | Forbidden    | GET    | /api/v2/dataroom/{dataRoomId}/folders/{dataRoomFolderId} | InvestorToken  | NA        | NA       | 403        | Existing_Folder_Permission_Schema_403 | json        | error,User not allowed to access dataroom |
#      | Not Found         | GET    | /api/v2/dataroom/{dataRoomId}/folders/{dataRoomFolderId} | NA             | NA        | NA       | 404        |                             |             |                                           |

  @api
  Scenario Outline: Validate POST Upload Data Room Document for "<scenarioName>" scenario
    When User uploads file using "<method>" request to "<url>" with headers "<headers>" and file "<filePath>" and fileName "<fileName>"
    Then User verifies the response status code is <statusCode>
    And User verifies fields in response: "<contentType>" with content type "<fields>"

    Examples:
      | scenarioName        | method | url               | headers        | filePath              | fileName              | statusCode | contentType | fields               |
      | Valid PDF Upload    | POST   | /api/v1/documents | NA             | Invitation_Letter.pdf | Invitation_Letter.pdf | 200        | json        | type,application/pdf |
#      | Invalid File Type   | POST   | /api/v1/documents | NA             | Invitation_Letter.txt | Invitation_Letter.txt | 400        | json        | type, error          |
      | Unauthorized Access | POST   | /api/v1/documents | InvalidHeaders | Invitation_Letter.pdf | Invitation_Letter.pdf | 401        | text        | Jwt is expired       |
#      | Forbidden Access    | POST   | /api/v1/documents | InvestorToken  | Invitation_Letter.pdf | Invitation_Letter.pdf | 403        | json        | error,Forbidden |

  @api
  Scenario Outline: Validate GET Existing Folder Permission API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName | method | url                                                          | headers        | queryFile | bodyFile | statusCode | schemaFile                            | contentType | fields         |
      | Valid        | GET    | /api/v2/dataroom/{dataRoomId}/folders/{dataRoomRootFolderID} | NA             | NA        | NA       | 200        | Existing_Folder_Permission_Schema_200 | json        | type, success  |
#      | Invalid ID format | GET    | /api/v2/dataroom/{dataRoomId}/folders/{dataRoomFolderId} | NA             | NA        | NA       | 400        |                             |             |                                           |
      | Unauthorized | GET    | /api/v2/dataroom/{dataRoomId}/folders/{dataRoomRootFolderID} | InvalidHeaders | NA        | NA       | 401        | NA                                    | text        | Jwt is expired |
#      | Forbidden    | GET    | /api/v2/dataroom/{dataRoomId}/folders/{dataRoomFolderId} | InvestorToken  | NA        | NA       | 403        | Existing_Folder_Permission_Schema_403 | json        | error,User not allowed to access dataroom |
#      | Not Found         | GET    | /api/v2/dataroom/{dataRoomId}/folders/{dataRoomFolderId} | NA             | NA        | NA       | 404        |                             |             |                                           |

  @api
  Scenario Outline: Validate GET Group Permission File API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName | method | url                                                                            | headers        | queryFile | bodyFile | statusCode | schemaFile                  | contentType | fields         |
      | Valid        | GET    | /api/v2/dataroom/{dataRoomId}/permissions/files/{dataRoomFileResourceID}/GROUP | NA             | NA        | NA       | 200        | Group_Permission_Schema_200 | json        | type,success   |
#      | Invalid ID format | GET    | /api/v2/dataroom/{dataRoomId}/permissions/files/{dataRoomFileResourceID}/GROUP | NA             | NA        | NA       | 400        |                             |             |                                           |
      | Unauthorized | GET    | /api/v2/dataroom/{dataRoomId}/permissions/files/{dataRoomFileResourceID}/GROUP | InvalidHeaders | NA        | NA       | 401        | NA                          | text        | Jwt is expired |
#      | Forbidden    | GET    | /api/v2/dataroom/{dataRoomId}/permissions/files/{dataRoomFileResourceID}/GROUP | InvestorToken  | NA        | NA       | 403        | Group_Permission_Schema_403 | json        | error,User not allowed to access dataroom |
#      | Not Found         | GET    | /api/v2/dataroom/{dataRoomId}/permissions/files/{dataRoomFileResourceID}/GROUP | NA             | NA        | NA       | 404        |                             |             |                                           |

  @api
  Scenario Outline: Validate GET Group Permission folder API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName | method | url                                                                            | headers        | queryFile | bodyFile | statusCode | schemaFile                         | contentType | fields         |
      | Valid        | GET    | /api/v2/dataroom/{dataRoomId}/permissions/folders/{dataRoomRootFolderID}/GROUP | NA             | NA        | NA       | 200        | Group_Permission_Folder_Schema_200 | json        | type,success   |
#      | Invalid ID format | GET    | /api/v2/dataroom/{dataRoomId}/permissions/folders/{dataRoomRootFolderID}/GROUP | NA             | NA        | NA       | 400        |                             |             |                                           |
      | Unauthorized | GET    | /api/v2/dataroom/{dataRoomId}/permissions/folders/{dataRoomRootFolderID}/GROUP | InvalidHeaders | NA        | NA       | 401        | NA                                 | text        | Jwt is expired |
#      | Forbidden    | GET    | /api/v2/dataroom/{dataRoomId}/permissions/folders/{dataRoomRootFolderID}/GROUP | InvestorToken  | NA        | NA       | 403        | Group_Permission_Folder_Schema_403 | json        | error,User not allowed to access dataroom |
#      | Not Found         | GET    | /api/v2/dataroom/{dataRoomId}/permissions/folders/{dataRoomRootFolderID}/GROUP | NA             | NA        | NA       | 404        |                             |             |                                           |

  @api
  Scenario Outline: Validate POST Assign New Group Permission Folder API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName   | method | url                                                                        | headers        | queryFile | bodyFile                                   | statusCode | schemaFile                                    | contentType | fields         |
      | Valid creation | POST   | /api/v2/dataroom/{dataRoomId}/permissions/folders/{dataRoomFolderId}/GROUP | NA             | NA        | Assign_New_Group_Permission_Folder_Request | 200        | Assign_New_Group_Permission_Folder_Schema_200 | json        | type, success  |
#      | Bad Request    | POST   | /api/v2/dataroom/{dataRoomId}/folders/{dataRoomFolderId}/GROUP | NA             | NA        | Assign_New_Group_Permission_Folder_Request | 400        | Assign_New_Group_Permission_Folder_Schema_400 | json        | error,Illegal Argument    |
      | Unauthorized   | POST   | /api/v2/dataroom/{dataRoomId}/permissions/folders/{dataRoomFolderId}/GROUP | InvalidHeaders | NA        | Assign_New_Group_Permission_Folder_Request | 401        | NA                                            | text        | Jwt is expired |
#      | Forbidden      | POST   | /api/v2/dataroom/{dataRoomId}/folders/{dataRoomFolderId}/GROUP  | InvestorToken  | NA        | Assign_New_Group_Permission_Folder_Request | 403        | Assign_New_Group_Permission_Folder_Schema_403 | json        | error,Unauthorized action |
#      | Duplicate resource | POST   | /api/v2/dataroom/{dataRoomId}/folders/{dataRoomFolderId}/GROUP  | NA  | NA        | Assign_New_Group_Permission_Folder_Request | 409        |                         |             |                           |
#      | Validation failed  | POST   | /api/v2/dataroom/{dataRoomId}/folders/{dataRoomFolderId}/GROUP  | NA  | NA        | Assign_New_Group_Permission_Folder_Request | 422        |                         |             |                           |
