Feature: Add Probability API Validation

  @api
  Scenario Outline: Validate PUT Add Probability API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName | method | url                                                                            | headers        | queryFile             | bodyFile | statusCode | schemaFile | contentType | fields         |
      | Valid update | PUT    | /api/v1/loan-syndications/{dealId}/investors/{lenderMpid}/investor-probability | NA             | Add_Probability_Query | NA       | 200        | NA         | NA          | NA             |
#      | Invalid input | PUT    | /api/v1/loan-syndications/{dealId}_/investors/{lenderMpid}/investor-probability | NA             | Add_Probability_Query | NA       | 400        | Add_Probability_Schema_400 | json        | error, Illegal Argument   |
      | Unauthorized | PUT    | /api/v1/loan-syndications/{dealId}/investors/{lenderMpid}/investor-probability | InvalidHeaders | Add_Probability_Query | NA       | 401        | NA         | text        | Jwt is expired |
#      | Forbidden     | PUT    | /api/v1/loan-syndications/{dealId}/investors/{lenderMpid}/investor-probability  | InvestorToken  | Add_Probability_Query | NA       | 403        | Add_Probability_Schema_403 | json        | error,Unauthorized action |
#      | Not Found     | PUT    | /api/v1/loan-syndications/{dealId}/investors/{lenderMpid}/investor-probability | NA             | Add_Probability_Query | NA       | 404        | Add_Probability_Schema_404 | json        | error,Not Found           |