Feature: DataRoom Org List API Validation

  @api

  Scenario Outline: Validate GET DataRoom Org List API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName | method | url                                         | headers        | queryFile | bodyFile | statusCode | schemaFile                   | contentType | fields         |
      | Valid        | GET    | /api/v2/dataroom/{dataRoomId}/organisations | NA             | NA        | NA       | 200        | DataRoom_Org_List_Schema_200 | json        | type,success   |
#      | Invalid ID format | GET    | /api/v2/dataroom/{dataRoomId}_/organisations | NA             | NA        | NA       | 400        |                             |             |                                           |
      | Unauthorized | GET    | /api/v2/dataroom/{dataRoomId}/organisations | InvalidHeaders | NA        | NA       | 401        | NA                           | text        | Jwt is expired |
#      | Forbidden    | GET    | /api/v2/dataroom/{dataRoomId}/organisations | InvestorToken  | NA        | NA       | 403        | Folder_Structure_Schema_403 | json        | error,User not allowed to access dataroom |
#      | Not Found         | GET    | /api/v2/dataroom/{dataRoomId}2/organisations | NA             | NA        | NA       | 404        |                             |             |                                           |