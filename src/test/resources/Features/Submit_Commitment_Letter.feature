Feature: Submit Commitment Letter API Validation

  Scenario Outline: Validate PUT Submit Commitment Letter API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName | method | url                                                | headers        | queryFile                      | bodyFile | statusCode | schemaFile | contentType | fields         |
      | Valid update | PUT    | /api/v2/loan-syndications/{dealId}/txn-docs/viewed | NA             | Sumbit_Commitment_Letter_Query | NA       | 200        | NA         | NA          |                |
#      | Invalid input | PUT    | /api/v2/loan-syndications/{dealId}sfs/txn-docs/viewed | NA             | Sumbit_Commitment_Letter_Query | NA       | 400        | Update_Draft_Schema_400 | json        | error, Illegal Argument   |
      | Unauthorized | PUT    | /api/v2/loan-syndications/{dealId}/txn-docs/viewed | InvalidHeaders | Sumbit_Commitment_Letter_Query | NA       | 401        | NA         | text        | Jwt is expired |
#      | Forbidden     | PUT    | /api/v2/loan-syndications/{dealId}/txn-docs/viewed    | InvestorToken  | Sumbit_Commitment_Letter_Query | NA       | 403        | Update_Draft_Schema_403 | json        | error,Unauthorized action |
#      | Not Found     | PUT    | /api/v2/loan-syndications/{dealId}/txn-docs/viewed    | NA             | Sumbit_Commitment_Letter_Query | NA       | 404        | Update_Draft_Schema_404 | json        | error,Not Found           |