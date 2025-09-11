Feature: Currency Pref API Validation

  @api
  Scenario Outline: Validate GET Currency Pref API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName      | method | url                                                       | headers        | queryFile | bodyFile | statusCode | schemaFile               | contentType | fields                    |
      | Valid             | GET    | /api/v1/loan-syndications/{dealId}/reports/currency-pref  | NA             | NA        | NA       | 200        | Currency_Pref_Schema_200 | json        | prefCurrency,null         |
#      | Invalid ID format | GET    | /api/v1/loan-syndications/{dealId}_/reports/currency-pref | NA             | NA        | NA       | 400        | Currency_Pref_Schema_400 | json        | error,Illegal Argument    |
      | Unauthorized      | GET    | /api/v1/loan-syndications/{dealId}/reports/currency-pref  | InvalidHeaders | NA        | NA       | 401        | NA                       | text        | Jwt is expired            |
#      | Forbidden         | GET    | /api/v1/loan-syndications/{dealId}/reports/currency-pref  | InvestorToken  | NA        | NA       | 403        | Currency_Pref_Schema_403 | json        | error,Unauthorized action |
#      | Not Found         | GET    | /api/v1/loan-syndications/{dealId}2/reports/currency-pref | NA             | NA        | NA       | 404        | Currency_Pref_Schema_404 | json        | error,Not Found           |