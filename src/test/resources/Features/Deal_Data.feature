Feature: Deal Data API Validation

  @api
  Scenario Outline: Validate GET Deal Data API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName      | method | url                                                             | headers        | queryFile | bodyFile | statusCode | schemaFile           | contentType | fields                    |
      | Valid             | GET    | /api/v1/loan-syndications/{dealId}/reports/deal-data/download   | NA             | NA        | NA       | 200        | NA                   | text        | Tranche-1 - INR           |
#      | Invalid ID format | GET    | /api/v1/loan-syndications/{dealId}_/reports/deal-data/download  | NA             | NA        | NA       | 400        | Deal_Data_Schema_400 | json        | error,Illegal Argument    |
      | Unauthorized      | GET    | /api/v1/loan-syndications/{dealId}/reports/deal-data/download   | InvalidHeaders | NA        | NA       | 401        | NA                   | text        | Jwt is expired            |
#      | Forbidden         | GET    | /api/v1/loan-syndications/{dealId}/reports/deal-data/download   | InvestorToken  | NA        | NA       | 403        | Deal_Data_Schema_403 | json        | error,Unauthorized action |
#      | Not Found         | GET    | //api/v1/loan-syndications/{dealId}2/reports/deal-data/download | NA             | NA        | NA       | 404        | Deal_Data_Schema_404 | json        | error,Not Found           |