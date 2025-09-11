Feature: Email Send for Upload Document API Validation

  @api
  Scenario Outline: Validate POST Email Send for Upload Document API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName   | method | url                                                                             | headers        | queryFile | bodyFile                                   | statusCode | schemaFile                                | contentType | fields         |
      | Valid creation | POST   | /api/v1/loan-syndications/{dealId}/notification-templates/upload-txn-docs/send  | NA             | NA        | Email_Send_for_Upload_Document_Request_200 | 200        | NA                                        | NA          |                |
#      | Bad Request    | POST   | /api/v1/loan-syndications/{dealId}_/notification-templates/upload-txn-docs/send | NA             | NA        | Email_Send_for_Upload_Document_Request_200 | 400        | Email_Send_for_Upload_Document_Schema_400 | NA          | status, 400    |
      | Unauthorized   | POST   | /api/v1/loan-syndications/{dealId}/notification-templates/upload-txn-docs/send  | InvalidHeaders | NA        | Email_Send_for_Upload_Document_Request_200 | 401        | NA                                        | text        | Jwt is expired |
#      | Forbidden          | POST   | /api/v1/loan-syndications/{dealId}/notification-templates/upload-txn-docs/send | InvestorToken  | NA        | Email_Send_for_Upload_Document_Request_200 | 403        |                                  |             |                |
#      | Duplicate resource | POST   | /api/v1/loan-syndications/{dealId}/notification-templates/upload-txn-docs/send | NA             | NA        | Email_Send_for_Upload_Document_Request_200 | 409        |                                  |             |                |
#      | Validation failed  | POST   | /api/v1/loan-syndications/{dealId}/notification-templates/upload-txn-docs/send | NA             | NA        | Email_Send_for_Upload_Document_Request_200 | 422        |                                  |             |                |
