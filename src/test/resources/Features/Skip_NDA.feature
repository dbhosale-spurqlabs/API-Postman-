Feature: Skip NDA API Validation

  @api
  Scenario Outline: Validate PUT Skip NDA API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName | method | url                                                                | headers        | queryFile | bodyFile | statusCode | schemaFile | contentType | fields         |
      | Valid update | PUT    | /api/v1/loan-syndications/{dealId}/investors/{lenderMpid}/skip-nda | NA             | NA        | NA       | 200        | NA         | NA          |                |
#      | Invalid input | PUT    | /api/v1/loan-syndications/{dealId}sd3/investors/{lenderMpid}/skip-nda | NA             | NA        | NA       | 400        | Skip_NDA_Schema_400 | json        | error, Illegal Argument   |
      | Unauthorized | PUT    | /api/v1/loan-syndications/{dealId}/investors/{lenderMpid}/skip-nda | InvalidHeaders | NA        | NA       | 401        | NA         | text        | Jwt is expired |
#      | Forbidden     | PUT    | /api/v1/loan-syndications/{dealId}/investors/{lenderMpid}/skip-nda    | InvestorToken  | NA        | NA       | 403        | Skip_NDA_Schema_403 | json        | error,Unauthorized action |
#      | Not Found     | PUT    | /api/v1/loan-syndications/{dealId}/investors/{lenderMpid}/skip-nda    | NA             | NA        | NA       | 404        | Skip_NDA_Schema_404 | json        | error,Not Found           |