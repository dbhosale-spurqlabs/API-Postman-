Feature: Invited Status API Validation

  @api
  Scenario Outline: Validate GET Invited Status API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName      | method | url                                                              | headers        | queryFile | bodyFile | statusCode | schemaFile                | contentType | fields                       |
      | Valid             | GET    | /api/v1/loan-syndications/{dealId}/investors/{investorId}/users  | NA             | NA        | NA       | 200        | Invited_Status_Schema_200 | json        | [0].invitationStatus,INVITED |
#      | Invalid ID format | GET    | /api/v1/loan-syndications/{dealId}_/investors/{investorId}/users | NA             | NA        | NA       | 400        | Invited_Status_Schema_400 | json        | error,Illegal Argument       |
      | Unauthorized      | GET    | /api/v1/loan-syndications/{dealId}/investors/{investorId}/users  | InvalidHeaders | NA        | NA       | 401        | NA                        | text        | Jwt is expired               |
#      | Forbidden         | GET    | /api/v1/loan-syndications/{dealId}/investors/{investorId}/users  | InvestorToken  | NA        | NA       | 403        | Invited_Status_Schema_403 | json        | error,Unauthorized action    |
#      | Not Found         | GET    | /api/v1/loan-syndications/{dealId}b/investors/{investorId}/users | NA             | NA        | NA       | 404        | Invited_Status_Schema_404 | json        | error,Not Found              |