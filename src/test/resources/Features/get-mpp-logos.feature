Feature: get-mpp-logos API Validation

  @api
  Scenario Outline: Validate POST get-mpp-logos API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName   | method | url                   | headers        | queryFile | bodyFile | statusCode | schemaFile               | contentType | fields         |
      | Valid creation | POST   | /api/v1/get-mpp-logos | NA             | NA        | NA       | 200        | get-mpp-logos_Schema_200 | json        | type,success   |
#      | Bad request        | POST   | /api/v1/get-mpp-logos | NA             | NA        | NA       | 400        |                          |             |                |
      | Unauthorized   | POST   | /api/v1/get-mpp-logos | InvalidHeaders | NA        | NA       | 401        | NA                       | text        | Jwt is expired |
#      | Forbidden          | POST   | /api/v1/get-mpp-logos | InvestorToken  | NA        | NA       | 403        |                          |             |                |
#      | Duplicate resource | POST   | /api/v1/get-mpp-logos | NA             | NA        | NA       | 409        |                          |             |                |
#      | Validation failed  | POST   | /api/v1/get-mpp-logos | NA             | NA        | NA       | 422        |                          |             |                |
