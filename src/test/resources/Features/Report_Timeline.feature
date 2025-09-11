Feature: Report Timeline API Validation

  @api
  Scenario Outline: Validate POST Report Timeline API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName   | method | url                                                   | headers        | queryFile | bodyFile                | statusCode | schemaFile                 | contentType | fields                    |
      | Valid creation | POST   | /api/v1/loan-syndications/{dealId}/reports/timelines  | NA             | NA        | Report_Timeline_Request | 200        | Report_Timeline_Schema_200 | json        | commitmentDatesDates      |
#      | Bad Request    | POST   | /api/v1/loan-syndications/{dealId}_/reports/timelines | NA             | NA        | Report_Timeline_Request | 400        | Report_Timeline_Schema_400 | json        | error,Illegal Argument    |
      | Unauthorized   | POST   | /api/v1/loan-syndications/{dealId}/reports/timelines  | InvalidHeaders | NA        | Report_Timeline_Request | 401        | NA                         | text        | Jwt is expired            |
#      | Forbidden      | POST   | /api/v1/loan-syndications/{dealId}/reports/timelines  | InvestorToken  | NA        | Report_Timeline_Request | 403        | Report_Timeline_Schema_403 | json        | error,Unauthorized action |
#      | Duplicate resource | POST   | /api/v1/loan-syndications/{dealId}/reports/timelines  | InvestorToken  | NA        | Report_Timeline_Request | 409        |                         |             |                           |
#      | Validation failed  | POST   | /api/v1/loan-syndications/{dealId}/reports/timelines  | InvestorToken  | NA        | Report_Timeline_Request | 422        |                         |             |                           |
