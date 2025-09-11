Feature: Add By Email Investor API Validation

  @api
  Scenario Outline: Validate POST Add By Email Investor API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName   | method | url                                                   | headers        | queryFile | bodyFile                          | statusCode | schemaFile                       | contentType | fields         |
      | Valid creation | POST   | /api/v1/loan-syndications/email-organizations-mapping | NA             | NA        | Add_By_Email_Investor_Request_200 | 200        | Add_By_Email_Investor_Schema_200 | NA          | NA             |
#      | Bad Request    | POST   | /api/v1/loan-syndications/email-organizations-mapping | NA             | NA        | Add_By_Email_Investor_Request_400 | 400        | NA                               | NA          |                |
      | Unauthorized   | POST   | /api/v1/loan-syndications/email-organizations-mapping | InvalidHeaders | NA        | Add_By_Email_Investor_Request_200 | 401        | NA                               | text        | Jwt is expired |
#      | Forbidden      | POST   | /api/v1/loan-syndications/email-organizations-mapping | InvestorToken  | NA        | Add_By_Email_Investor_Request_200 | 403        |                                  |             |                |
#      | Duplicate resource | POST   | /api/v1/loan-syndications/email-organizations-mapping | InvestorToken  | NA        | Add_By_Email_Investor_Request_200 | 409        |                         |             |                           |
#      | Validation failed  | POST   | /api/v1/loan-syndications/email-organizations-mapping  | InvestorToken  | NA        | Add_By_Email_Investor_Request_200 | 422        |                         |             |                           |
