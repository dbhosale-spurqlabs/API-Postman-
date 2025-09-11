Feature: Permission API Validation

  @api
  Scenario Outline: Validate GET Permission API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName | method | url                                       | headers        | queryFile | bodyFile | statusCode | schemaFile            | contentType | fields                    |
      | Valid        | GET    | /api/v2/dataroom/{dataRoomId}/permissions | NA             | NA        | NA       | 200        | Permission_Schema_200 | json        | type,success              |
#      | Invalid ID format | GET    | /api/v2/dataroom/{dataRoomId}_/permissions | NA             | NA        | NA       | 400        |                       |             |                |
      | Unauthorized | GET    | /api/v2/dataroom/{dataRoomId}/permissions | InvalidHeaders | NA        | NA       | 401        | NA                    | text        | Jwt is expired            |
#      | Forbidden    | GET    | /api/v2/dataroom/{dataRoomId}/permissions | InvestorToken  | NA        | NA       | 403        | Permission_Schema_403 |             | error,Unauthorized action |
#      | Not Found         | GET    | /api/v2/dataroom/{dataRoomId}2/permissions | NA             | NA        | NA       | 404        |                       |             |                |