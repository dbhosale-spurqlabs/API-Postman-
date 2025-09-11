Feature: Tranche Overview Download API Validation

  @api
  Scenario Outline: Validate GET Tranche Overview Download API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName      | method | url                                                            | headers        | queryFile | bodyFile | statusCode | schemaFile                           | contentType | fields                     |
      | Valid             | GET    | /api/v1/loan-syndications/{dealId}/tranches-overview/download  | NA             | NA        | NA       | 200        | NA                                   | text        | Investor Org Name,Investor |
#      | Invalid ID format | GET    | /api/v1/loan-syndications/{dealId}_/tranches-overview/download | NA             | NA        | NA       | 400        | Tranche_Overview_Download_Schema_400 | json        | error,Illegal Argument     |
      | Unauthorized      | GET    | /api/v1/loan-syndications/{dealId}/tranches-overview/download  | InvalidHeaders | NA        | NA       | 401        | NA                                   | text        | Jwt is expired             |
#      | Forbidden         | GET    | /api/v1/loan-syndications/{dealId}/tranches-overview/download  | InvestorToken  | NA        | NA       | 403        | Tranche_Overview_Download_Schema_403 | json        | error,Unauthorized action  |
#      | Not Found         | GET    | /api/v1/loan-syndications/{dealId}2/tranches-overview/download | NA             | NA        | NA       | 404        | Tranche_Overview_Download_Schema_404 | json        | error,Not Found            |