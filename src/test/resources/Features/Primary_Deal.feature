Feature: Primary Deal API Validation

  @api
  Scenario Outline: Validate GET Primary Deal API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName      | method | url                                 | headers        | queryFile | bodyFile | statusCode | schemaFile              | contentType | fields                           |
      | Valid             | GET    | /api/v1/loan-syndications/{dealId}  | NA             | NA        | NA       | 200        | Primary_Deal_Schema_200 | json        | userName,Arranger1 DemoSpurqlabs |
#      | Invalid ID format | GET    | /api/v1/loan-syndications/{dealId}_ | NA             | NA        | NA       | 400        | Primary_Deal_Schema_400 | json        | error,Illegal Argument           |
      | Unauthorized      | GET    | /api/v1/loan-syndications/{dealId}  | InvalidHeaders | NA        | NA       | 401        | NA                      | text        | Jwt is expired                   |
#      | Forbidden         | GET    | /api/v1/loan-syndications/{dealId}  | InvestorToken  | NA        | NA       | 403        | Primary_Deal_Schema_403 | json        | error,Unauthorized action        |
#      | Not found         | GET    | /api/v1/loan-syndications/{dealId}2 | NA             | NA        | NA       | 404        | Primary_Deal_Schema_404 | json        | error,Not Found                  |