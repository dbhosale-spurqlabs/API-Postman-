Feature: Trade Recap API Validation

  Scenario Outline: Validate GET Trade Recap API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName | method | url                                                            | headers        | queryFile | bodyFile | statusCode | schemaFile | contentType | fields         |
      | Valid        | GET    | /api/v1/loan-tranche-responses/{trancheResponseId}/trade-recap | NA             | NA        | NA       | 200        | NA         | NA          |                |
#      | Invalid ID format | GET    | /api/v1/loan-tranche-responses/{trancheResponseId}_/trade-recap | NA             | NA        | NA       | 400        | Trade_Recap_Schema_400 | json        | error,Illegal Argument    |
      | Unauthorized | GET    | /api/v1/loan-tranche-responses/{trancheResponseId}/trade-recap | InvalidHeaders | NA        | NA       | 401        | NA         | text        | Jwt is expired |
#      | Forbidden         | GET    | /api/v1/loan-tranche-responses/{trancheResponseId}/trade-recap  | InvestorToken  | NA        | NA       | 403        | Trade_Recap_Schema_403 | json        | error,Unauthorized action |
#      | Not Found         | GET    | /api/v1/loan-tranche-responses/{trancheResponseId}2/trade-recap | NA             | NA        | NA       | 404        | Trade_Recap_Schema_404 | json        | error,Not Found           |