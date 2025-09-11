Feature: Doc Export API Validation

  @api
  Scenario Outline: Validate POST Doc Export API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName   | method | url                           | headers        | queryFile | bodyFile               | statusCode | schemaFile            | contentType | fields                                           |
      | Valid creation | POST   | /api/v1/bulk/documents/export | NA             | NA        | Doc_Export_Request_200 | 200        | Doc_Export_Schema_200 | NA          | type, success                                    |
#      | Bad Request    | POST   | /api/v1/bulk/documents/export | NA             | NA        | Doc_Export_Request_200 | 400        |                       |             |                           |
      | Unauthorized   | POST   | /api/v1/bulk/documents/export | InvalidHeaders | NA        | Doc_Export_Request_200 | 401        | NA                    | text        | Jwt is expired                                   |
#      | Forbidden      | POST   | /api/v1/bulk/documents/export | InvestorToken  | NA        | Doc_Export_Request_403 | 403        | Doc_Export_Schema_403 | json        | detail,User not permitted to perform this action |
#      | Duplicate resource | POST   | /api/v1/bulk/documents/export  | InvestorToken  | NA        |  | 409        |                         |             |                           |
#      | Validation failed  | POST   | /api/v1/bulk/documents/export  | InvestorToken  | NA        |  | 422        |                         |             |                           |
