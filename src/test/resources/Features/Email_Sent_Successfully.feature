Feature: Email Sent Successfully API Validation

  @api
  Scenario Outline: Validate POST Email Sent Successfully API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName   | method | url                       | headers        | queryFile | bodyFile                            | statusCode | schemaFile                         | contentType | fields                 |
      | Valid creation | POST   | /api/v1/notification/send | NA             | NA        | Email_Sent_Successfully_Request_200 | 200        | Email_Sent_Successfully_Schema_200 | json        | type, success          |
#      | Bad Request    | POST   | /api/v1/notification/send | NA             | NA        | Email_Sent_Successfully_Request_400 | 400        | Email_Sent_Successfully_Schema_400 | NA          | error,Illegal Argument |
      | Unauthorized   | POST   | /api/v1/notification/send | InvalidHeaders | NA        | Email_Sent_Successfully_Request_200 | 401        | NA                                 | text        | Jwt is expired         |
#      | Forbidden      | POST   | /api/v1/notification/send | InvestorToken  | NA        | Email_Sent_Successfully_Request_200 | 403        |                                    |             |                        |
#      | Duplicate resource | POST   | /api/v1/notification/send  | InvestorToken  | NA        | Email_Sent_Successfully_Request | 409        |                         |             |                           |
#      | Validation failed  | POST   | /api/v1/notification/send  | InvestorToken  | NA        | Email_Sent_Successfully_Request | 422        |                         |             |                           |
