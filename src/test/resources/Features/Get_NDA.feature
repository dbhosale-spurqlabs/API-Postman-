Feature: Get NDA API Validation

  @api
  Scenario Outline: Validate GET Get NDA API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName | method | url                                            | headers        | queryFile | bodyFile | statusCode | schemaFile         | contentType | fields                     |
      | Valid        | GET    | /api/v1/documents/{documentId}/versions/latest | NA             | NA        | NA       | 200        | Get_NDA_Schema_200 | json        | data.type, application/pdf |
#      | Invalid ID format | GET    | /api/v1/documents/{documentId}/versions/latest | NA             | NA        | NA       | 400        |                    |             |                           |
      | Unauthorized | GET    | /api/v1/documents/{documentId}/versions/latest | InvalidHeaders | NA        | NA       | 401        | NA                 | text        | Jwt is expired             |
#      | Forbidden    | GET    | /api/v1/documents/{documentId}/versions/latest | InvestorToken  | NA        | NA       | 403        | Get_NDA_Schema_403 | json        | detail,User not permitted to perform this action |
#      | Not Found         | GET    | /api/v1/documents/{documentId}/versions/latest | NA             | NA        | NA       | 404        |                    |             |                           |