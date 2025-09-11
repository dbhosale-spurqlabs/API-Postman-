Feature: DataRoom Create Group and Rename and All Activity API Validation

  @api

  Scenario Outline: Validate POST DataRoom Create Group API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName   | method | url                                  | headers        | queryFile | bodyFile                      | statusCode | schemaFile                       | contentType | fields         |
      | Valid creation | POST   | /api/v2/dataroom/{dataRoomId}/groups | NA             | NA        | DataRoom_Create_Group_Request | 200        | DataRoom_Create_Group_Schema_200 | json        | type, success  |
#      | Bad Request    | POST   | /api/v2/dataroom/{dataRoomId}/groups | NA             | NA        | DataRoom_Create_Group_Request | 400        |  | json        | error,Illegal Argument    |
      | Unauthorized   | POST   | /api/v2/dataroom/{dataRoomId}/groups | InvalidHeaders | NA        | DataRoom_Create_Group_Request | 401        | NA                               | text        | Jwt is expired |
#      | Forbidden      | POST   | /api/v2/dataroom/{dataRoomId}/groups  | InvestorToken  | NA        | DataRoom_Create_Group_Request | 403        |  | json        | error,Unauthorized action |
#      | Duplicate resource | POST   | /api/v2/dataroom/{dataRoomId}/groups  | NA  | NA        | DataRoom_Create_Group_Request | 409        |                         |             |                           |
#      | Validation failed  | POST   | /api/v2/dataroom/{dataRoomId}/groups  | NA  | NA        | DataRoom_Create_Group_Request | 422        |                         |             |                           |

  @api
  Scenario Outline: Validate PUT DataRoom Rename Group API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName   | method | url                                  | headers        | queryFile | bodyFile                      | statusCode | schemaFile                       | contentType | fields         |
      | Valid creation | POST   | /api/v2/dataroom/{dataRoomId}/groups | NA             | NA        | DataRoom_Rename_Group_Request | 200        | DataRoom_Rename_Group_Schema_200 | json        | type, success  |
#      | Bad Request    | POST   | /api/v2/dataroom/{dataRoomId}/groups | NA             | NA        | DataRoom_Rename_Group_Request | 400        |  | json        | error,Illegal Argument    |
      | Unauthorized   | POST   | /api/v2/dataroom/{dataRoomId}/groups | InvalidHeaders | NA        | DataRoom_Rename_Group_Request | 401        | NA                               | text        | Jwt is expired |
#      | Forbidden      | POST   | /api/v2/dataroom/{dataRoomId}/groups  | InvestorToken  | NA        | DataRoom_Rename_Group_Request | 403        |  | json        | error,Unauthorized action |
#      | Duplicate resource | POST   | /api/v2/dataroom/{dataRoomId}/groups  | NA  | NA        | DataRoom_Rename_Group_Request | 409        |                         |             |                           |
#      | Validation failed  | POST   | /api/v2/dataroom/{dataRoomId}/groups  | NA  | NA        | DataRoom_Rename_Group_Request | 422        |                         |             |                           |

  @api
  Scenario Outline: Validate GET Group List API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName | method | url                                  | headers        | queryFile | bodyFile | statusCode | schemaFile            | contentType | fields         |
      | Valid        | GET    | /api/v2/dataroom/{dataRoomId}/groups | NA             | NA        | NA       | 200        | Group_List_Schema_200 | json        | type, success  |
#      | Invalid ID format | GET    | /api/v2/dataroom/{dataRoomId}/groups | NA             | NA        | NA       | 400        |                             |             |                                           |
      | Unauthorized | GET    | /api/v2/dataroom/{dataRoomId}/groups | InvalidHeaders | NA        | NA       | 401        | NA                    | text        | Jwt is expired |
#      | Forbidden    | GET    | /api/v2/dataroom/{dataRoomId}/groups | InvestorToken  | NA        | NA       | 403        |  | json        | error,User not allowed to access dataroom |
#      | Not Found         | GET    | /api/v2/dataroom/{dataRoomId}/groups | NA             | NA        | NA       | 404        |                             |             |                                           |

  @api
  Scenario Outline: Validate GET Group Details API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName | method | url                                  | headers        | queryFile           | bodyFile | statusCode | schemaFile            | contentType | fields         |
      | Valid        | GET    | /api/v2/dataroom/{dataRoomId}/groups | NA             | Group_Details_Query | NA       | 200        | Group_Details_Schema_200 | json        | type, success  |
#      | Invalid ID format | GET    | /api/v2/dataroom/{dataRoomId}/groups | NA             | NA        | NA       | 400        |                             |             |                                           |
      | Unauthorized | GET    | /api/v2/dataroom/{dataRoomId}/groups | InvalidHeaders | NA                  | NA       | 401        | NA                    | text        | Jwt is expired |
#      | Forbidden    | GET    | /api/v2/dataroom/{dataRoomId}/groups | InvestorToken  | NA        | NA       | 403        |  | json        | error,User not allowed to access dataroom |
#      | Not Found         | GET    | /api/v2/dataroom/{dataRoomId}/groups | NA             | NA        | NA       | 404        |                             |             |                                           |