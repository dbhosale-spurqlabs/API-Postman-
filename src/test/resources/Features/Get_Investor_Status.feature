Feature: Get Investor Status API Validation

  @api
  Scenario Outline: Validate GET Get Investor Status API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName      | method | url                                                     | headers        | queryFile                   | bodyFile | statusCode | schemaFile                       | contentType | fields                    |
      | Valid             | GET    | /api/v1/loan-syndications/{dealId}/reports/daily-level  | NA             | Get_Invitation_Status_Query | NA       | 200        | Get_Invitation_Status_Schema_200 | json        | invited, 1                |
#      | Invalid ID format | GET    | /api/v1/loan-syndications/{dealId}_/reports/daily-level | NA             | Get_Invitation_Status_Query | NA       | 400        | Get_Invitation_Status_Schema_400 | json        | error,Illegal Argument    |
      | Unauthorized      | GET    | /api/v1/loan-syndications/{dealId}/reports/daily-level  | InvalidHeaders | Get_Invitation_Status_Query | NA       | 401        | NA                               | text        | Jwt is expired            |
#      | Forbidden         | GET    | /api/v1/loan-syndications/{dealId}/reports/daily-level  | InvestorToken  | Get_Invitation_Status_Query | NA       | 403        | Get_Invitation_Status_Schema_403 | json        | error,Unauthorized action |
#      | Not Found         | GET    | /api/v1/loan-syndications/{dealId}2/reports/daily-level | NA             | Get_Invitation_Status_Query | NA       | 404        | Get_Invitation_Status_Schema_404 | json        | error,Not Found           |