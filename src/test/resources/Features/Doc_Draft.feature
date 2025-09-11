Feature: Doc Draft API Validation

  @api
  Scenario Outline: Validate GET Doc Draft API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName | method | url                                               | headers        | queryFile | bodyFile | statusCode | schemaFile | contentType | fields         |
      | Valid        | GET    | /api/v2/loan-syndications/{dealId}/txn-docs/draft | NA             | NA        | NA       | 200        | NA         | NA          |                |
#      | Invalid ID format | GET    | /api/v2/loan-syndications/{dealId}_/txn-docs/draft | NA             | NA        | NA       | 400        | Doc_Draft_Schema_400 | json        | error, Illegal Argument |
      | Unauthorized | GET    | /api/v2/loan-syndications/{dealId}/txn-docs/draft | InvalidHeaders | NA        | NA       | 401        | NA         | text        | Jwt is expired |
#      | Forbidden         | GET    | /api/v2/loan-syndications/{dealId}/txn-docs/draft  | InvestorToken  | NA        | NA       | 403        | Doc_Draft_Schema_403 | json        | status, 403             |
#      | Not found         | GET    | /api/v2/loan-syndications/{dealId}2/txn-docs/draft | NA             | NA        | NA       | 404        | Doc_Draft_Schema_404 | json        | error, Not Found        |