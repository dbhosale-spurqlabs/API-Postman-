Feature: Final Doc API Validation

  @api
  Scenario Outline: Validate GET Final Doc API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName      | method | url                                                | headers        | queryFile | bodyFile | statusCode | schemaFile           | contentType | fields                    |
      | Valid             | GET    | /api/v2/loan-syndications/{dealId}/txn-docs/final  | NA             | NA        | NA       | 200        | NA                   | NA          | NA                        |
#      | Invalid ID format | GET    | /api/v2/loan-syndications/{dealId}_/txn-docs/final | NA             | NA        | NA       | 400        | Final_Doc_Schema_400 | json        | error, Illegal Argument   |
      | Unauthorized      | GET    | /api/v2/loan-syndications/{dealId}/txn-docs/final  | InvalidHeaders | NA        | NA       | 401        | NA                   | text        | Jwt is expired            |
#      | Forbidden         | GET    | /api/v2/loan-syndications/{dealId}/txn-docs/final  | InvestorToken  | NA        | NA       | 403        | Final_Doc_Schema_403 | json        | error,Unauthorized action |
#      | Not found         | GET    | /api/v2/loan-syndications/{dealId}2/txn-docs/final | NA             | NA        | NA       | 404        | Final_Doc_Schema_404 | json        | error, Not Found          |