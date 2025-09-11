Feature: Investor Interest API Validation


  Scenario Outline: Validate GET Investor Interest API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName      | method | url                                                   | headers        | queryFile | bodyFile | statusCode | schemaFile                   | contentType | fields                 |
      | Valid             | GET    | /api/v1/loan-syndications/{dealId}/investor-interest  | NA             | NA        | NA       | 200        | Investor_Interest_Schema_200 | json        | mpName,Spurqlabs       |
#      | Invalid ID format | GET    | /api/v1/loan-syndications/{dealId}_/investor-interest | NA             | NA        | NA       | 400        | Investor_Interest_Schema_400 | json        | error,Illegal Argument |
      | Unauthorized      | GET    | /api/v1/loan-syndications/{dealId}/investor-interest  | InvalidHeaders | NA        | NA       | 401        | NA                           | text        | Jwt is expired         |
#      | Forbidden         | GET    | /api/v1/loan-syndications/{dealId}/investor-interest  | InvestorToken  | NA        | NA       | 403        |                              |             |                        |
#      | Not Found         | GET    | /api/v1/loan-syndications/{dealId}2/investor-interest | NA             | NA        | NA       | 404        | Investor_Interest_Schema_404 | json        | error,Not Found        |