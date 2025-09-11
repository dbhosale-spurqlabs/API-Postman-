Feature: DataRoom Set and Get Org Permission API Validation

  @api
  Scenario Outline: Validate GET DataRoom Get Org Permission API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName   | method | url                                                                     | headers        | queryFile | bodyFile | statusCode | schemaFile                             | contentType | fields         |
      | Valid creation | GET    | /api/v2/dataroom/{dataRoomId}/permissions/organisations/{dataRoomOrgId} | NA             | NA        | NA       | 200        | DataRoom_Get_Org_Permission_Schema_200 | json        | type, success  |
      | Unauthorized   | GET    | /api/v2/dataroom/{dataRoomId}/permissions/organisations/{dataRoomOrgId} | InvalidHeaders | NA        | NA       | 401        | NA                                     | text        | Jwt is expired |

  @api
  Scenario Outline: Validate POST DataRoom Set Org Permission API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName   | method | url                                                                     | headers        | queryFile | bodyFile                                | statusCode | schemaFile                             | contentType | fields         |
      | Valid creation | POST   | /api/v2/dataroom/{dataRoomId}/permissions/organisations/{dataRoomOrgId} | NA             | NA        | DataRoom_Set_Org_Permission_Request_200 | 200        | DataRoom_Set_Org_Permission_Schema_200 | json        | type, success  |
      | Unauthorized   | POST   | /api/v2/dataroom/{dataRoomId}/permissions/organisations/{dataRoomOrgId} | InvalidHeaders | NA        | DataRoom_Set_Org_Permission_Request_200 | 401        | NA                                     | text        | Jwt is expired |

