Feature: Guest Response API Validation

  @api
  Scenario Outline: Validate POST Guest Response API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName   | method | url                                                 | headers        | queryFile | bodyFile               | statusCode | schemaFile                | contentType | fields                    |
      | Valid creation | POST   | /api/v1/loan-syndications/{dealId}/guest-responses  | NA             | NA        | Guest_Response_Request | 200        | NA                        | NA          |                           |
#      | Bad Request    | POST   | /api/v1/loan-syndications/{dealId}_/guest-responses | NA             | NA        | Guest_Response_Request | 400        | Guest_Response_Schema_400 | NA          | error,Illegal Argument    |
      | Unauthorized   | POST   | /api/v1/loan-syndications/{dealId}/guest-responses  | InvalidHeaders | NA        | Guest_Response_Request | 401        | NA                        | text        | Jwt is expired            |
#      | Forbidden      | POST   | /api/v1/loan-syndications/{dealId}/guest-responses  | InvestorToken  | NA        | Guest_Response_Request | 403        | Guest_Response_Schema_403 | json        | error,Unauthorized action |
#      | Duplicate resource | POST   | /api/v1/loan-syndications/{dealId}/guest-responses |                | NA        | Guest_Response_Request | 409        |                         |             |                           |
#      | Validation failed  | POST   | /api/v1/loan-syndications/{dealId}/guest-responses |                | NA        | Guest_Response_Request | 422        |                         |             |                           |
