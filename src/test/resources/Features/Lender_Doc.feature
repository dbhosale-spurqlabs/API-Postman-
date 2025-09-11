Feature: Lender Doc API Validation

  @api
  Scenario Outline: Validate GET Lender Doc API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName      | method | url                                                   | headers        | queryFile | bodyFile | statusCode | schemaFile            | contentType | fields                  |
      | Valid             | GET    | /api/v2/loan-syndications/{dealId}/other-lender-docs  | NA             | NA        | NA       | 200        | NA                    | NA          | NA                      |
#      | Invalid ID format | GET    | /api/v2/loan-syndications/{dealId}_/other-lender-docs | NA             | NA        | NA       | 400        | Lender_Doc_Schema_400 | json        | error, Illegal Argument |
      | Unauthorized      | GET    | /api/v2/loan-syndications/{dealId}/other-lender-docs  | InvalidHeaders | NA        | NA       | 401        | NA                    | text        | Jwt is expired          |
#      | Forbidden         | GET    | /api/v2/loan-syndications/{dealId}/other-lender-docs  | InvestorToken  | NA        | NA       | 403        |                       |             |                         |
#      | Not found         | GET    | /api/v2/loan-syndications/{dealId}2/other-lender-docs | NA             | NA        | NA       | 404        | Lender_Doc_Schema_404 | json        | error, Not Found        |