Feature: Add Investor API Validation

  @api
  Scenario Outline: Validate POST Add Investor API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName   | method | url                                               | headers        | queryFile | bodyFile             | statusCode | schemaFile | contentType | fields         |
      | Valid creation | POST   | /api/v1/loan-syndications/{dealId}/link-investors | NA             | NA        | Add_Investor_Request | 200        | NA         | NA          | NA             |
#      | Bad Request    | POST   | /api/v1/loan-syndications/{dealId}_/link-investors | NA             | NA        | Add_Investor_Request | 400        | Add_Investor_Schema_400 | json        | error,Illegal Argument    |
      | Unauthorized   | POST   | /api/v1/loan-syndications/{dealId}/link-investors | InvalidHeaders | NA        | Add_Investor_Request | 401        | NA         | text        | Jwt is expired |
#      | Forbidden      | POST   | /api/v1/loan-syndications/{dealId}/link-investors  | InvestorToken  | NA        | Add_Investor_Request | 403        | Add_Investor_Schema_403 | json        | error,Unauthorized action |
#      | Duplicate resource | POST   | /api/v1/loan-syndications/{dealId}/link-investors  | InvestorToken  | NA        | Add_Investor_Request | 409        |                         |             |                           |
#      | Validation failed  | POST   | /api/v1/loan-syndications/{dealId}/link-investors  | InvestorToken  | NA        | Add_Investor_Request | 422        |                         |             |                           |

  @api @removeInvestor
  Scenario Outline: Validate DELETE Investor API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName | method | url                                                  | headers        | queryFile | bodyFile                | statusCode | schemaFile | contentType | fields         |
#      | Invalid input | DELETE | /api/v1/loan-syndications/{dealId}_/lenders/remove-mp | NA             | NA        | Remove_Investor_Request | 400        | Remove_Investor_Schema_400 | json        | error, Illegal Argument |
      | Unauthorized | DELETE | /api/v1/loan-syndications/{dealId}/lenders/remove-mp | InvalidHeaders | NA        | Remove_Investor_Request | 401        | NA         | text        | Jwt is expired |
#      | Not Found     | DELETE | /api/v1/loan-syndications/{dealId}2/lenders/remove-mp | NA             | NA        | Remove_Investor_Request | 404        | Remove_Investor_Schema_404 | json        | error,Not Found         |
      | Valid delete | DELETE | /api/v1/loan-syndications/{dealId}/lenders/remove-mp | NA             | NA        | Remove_Investor_Request | 200        | NA         | NA          |                |
