Feature: Enter Expected Amount and User Information Invitation Status API Validation

  @api
  Scenario Outline: Validate POST Enter Expected Amount API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName   | method | url                                                                       | headers        | queryFile | bodyFile                      | statusCode | schemaFile | contentType | fields         |
      | Valid creation | POST   | /api/v1/loan-syndications/{dealId}/investors/{investorId}/update-estimate | NA             | NA        | Enter_Expected_Amount_Request | 200        | NA         | NA          |                |
#      | Bad Request    | POST   | /api/v1/loan-syndications/{dealId}_/investors/{investorId}/update-estimate | NA             | NA        | Enter_Expected_Amount_Request | 400        | Add_Investor_Schema_400 | NA          | error,Illegal Argument    |
      | Unauthorized   | POST   | /api/v1/loan-syndications/{dealId}/investors/{investorId}/update-estimate | InvalidHeaders | NA        | Enter_Expected_Amount_Request | 401        | NA         | text        | Jwt is expired |
#      | Forbidden      | POST   | /api/v1/loan-syndications/{dealId}/investors/{investorId}/update-estimate  | InvestorToken  | NA        | Enter_Expected_Amount_Request | 403        | Add_Investor_Schema_403 | json        | error,Unauthorized action |
#      | Duplicate resource | POST   | /api/v1/loan-syndications/{dealId}/investors/{investorId}/update-estimate  | InvestorToken  | NA        | Enter_Expected_Amount_Request | 409        | Add_Investor_Schema_403 | json        | error,Unauthorized action |
#      | Validation failed  | POST   | /api/v1/loan-syndications/{dealId}/investors/{investorId}/update-estimate  | InvestorToken  | NA        | Enter_Expected_Amount_Request | 422        | Add_Investor_Schema_403 | json        | error,Unauthorized action |

# User Information Invitation Status

  @api
  Scenario Outline: Validate POST Enter Expected Amount API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName | method | url                                                             | headers        | queryFile | bodyFile | statusCode | schemaFile                                    | contentType | fields                       |
      | Valid        | GET    | /api/v1/loan-syndications/{dealId}/investors/{investorId}/users | NA             | NA        | NA       | 200        | User_Information_Invitation_Status_Schema_200 | json        | [0].invitationStatus,INVITED |
#      | Invalid ID format | GET    | /api/v1/loan-syndications/{dealId}_/investors/{investorId}/users | NA             | NA        | NA       | 400        | User_Information_Invitation_Status_Schema_400 | json        | error,Illegal Argument       |
      | Unauthorized | GET    | /api/v1/loan-syndications/{dealId}/investors/{investorId}/users | InvalidHeaders | NA        | NA       | 401        | NA                                            | text        | Jwt is expired               |
#      | Forbidden         | GET    | /api/v1/loan-syndications/{dealId}/investors/{investorId}/users  | InvestorToken  | NA        | NA       | 403        | User_Information_Invitation_Status_Schema_403 | json        | error,Unauthorized action    |
#      | Not Found         | GET    | /api/v1/loan-syndications/{dealId}2/investors/{investorId}/users | NA             | NA        | NA       | 404        | User_Information_Invitation_Status_Schema_404 | json        | error,Not Found              |


