Feature: Invite Status API Validation

  @api
  Scenario Outline: Validate POST Invite Status API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName   | method | url                                                  | headers        | queryFile | bodyFile              | statusCode | schemaFile              | contentType | fields                    |
      | Valid creation | POST   | /api/v1/loan-syndications/{dealId}/investors/invite  | NA             | NA        | Invite_Status_Request | 200        | NA                      | NA          |                           |
#      | Bad Request    | POST   | /api/v1/loan-syndications/{dealId}_/investors/invite | NA             | NA        | Invite_Status_Request | 400        | Add_Investor_Schema_400 | NA          | error,Illegal Argument    |
      | Unauthorized   | POST   | /api/v1/loan-syndications/{dealId}/investors/invite  | InvalidHeaders | NA        | Invite_Status_Request | 401        | NA                      | text        | Jwt is expired            |
#      | Forbidden      | POST   | /api/v1/loan-syndications/{dealId}/investors/invite  | InvestorToken  | NA        | Invite_Status_Request | 403        | Add_Investor_Schema_403 | json        | error,Unauthorized action |
#      | Duplicate resource | POST   | /api/v1/loan-syndications/{dealId}/investors/invite  | NA  | NA        | Invite_Status_Request | 409        |                         |             |                           |
#      | Validation failed  | POST   | /api/v1/loan-syndications/{dealId}/investors/invite  | NA  | NA        | Invite_Status_Request | 422        |                         |             |                           |
