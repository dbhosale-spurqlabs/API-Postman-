Feature: Loan Syndication API Validation

  @api
  Scenario Outline: Validate GET Loan Syndication API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName | method | url                       | headers        | queryFile                  | bodyFile | statusCode | schemaFile                  | contentType | fields         |
      | Valid        | GET    | /api/v1/loan-syndications | NA             | Loan_Syndication_Query_200 | NA       | 200        | Loan_Syndication_Schema_200 | json        | status,200     |
#      | Invalid ID format | GET    | /api/v1/loan-syndications | NA             | Loan_Syndication_Query_400 | NA       | 400        | Loan_Syndication_Schema_400 | json        | error,Illegal Argument |
      | Unauthorized | GET    | /api/v1/loan-syndications | InvalidHeaders | Loan_Syndication_Query_200 | NA       | 401        | NA                          | text        | Jwt is expired |
#      | Forbidden         | GET    | /api/v1/loan-syndications | InvestorToken  | Loan_Syndication_Query_200 | NA       | 403        |                             |             |                                  |
#      | Not found         | GET    | /api/v1/loan-syndications | NA             | Loan_Syndication_Query_200 | NA       | 404        |                             |             |                                  |