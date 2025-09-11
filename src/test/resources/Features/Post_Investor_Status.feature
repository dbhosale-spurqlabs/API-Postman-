Feature: Post Investor Status API Validation

  @api
  Scenario Outline: Validate POST Post Investor Status API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName   | method | url                                                         | headers        | queryFile | bodyFile                     | statusCode | schemaFile                      | contentType | fields                    |
      | Valid creation | POST   | /api/v1/loan-syndications/{dealId}/reports/investor-status  | NA             | NA        | Post_Investor_Status_Request | 200        | Post_Investor_Status_Schema_200 | json        | investors, 3              |
#      | Bad Request    | POST   | /api/v1/loan-syndications/{dealId}_/reports/investor-status | NA             | NA        | Post_Investor_Status_Request | 400        | Post_Investor_Status_Schema_400 | json        | error,Illegal Argument    |
      | Unauthorized   | POST   | /api/v1/loan-syndications/{dealId}/reports/investor-status  | InvalidHeaders | NA        | Post_Investor_Status_Request | 401        | NA                              | text        | Jwt is expired            |
#      | Forbidden      | POST   | /api/v1/loan-syndications/{dealId}/reports/investor-status  | InvestorToken  | NA        | Post_Investor_Status_Request | 403        | Post_Investor_Status_Schema_403 | json        | error,Unauthorized action |
#      | Duplicate resource | POST   | /api/v1/loan-syndications/{dealId}/reports/investor-status  | NA  | NA        | Post_Investor_Status_Request | 409        |                         |             |                           |
#      | Validation failed  | POST   | /api/v1/loan-syndications/{dealId}/reports/investor-status  | NA  | NA        | Post_Investor_Status_Request | 422        |                         |             |                           |
