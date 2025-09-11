Feature: Update Draft API Validation

  @api
  Scenario Outline: Validate PUT Update Draft API Response for "<scenarioName>" Scenario
    Given user has a valid deal id
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName | method | url                                      | headers        | queryFile | bodyFile             | statusCode | schemaFile | contentType | fields         |
      | Valid update | PUT    | /api/v1/loan-syndications/draft/{dealId} | NA             | NA        | Update_Draft_Request | 200        | NA         | NA          |                |
#      | Invalid input | PUT    | /api/v1/loan-syndications/draft/{dealId}_ | NA             | NA        | Update_Draft_Request | 400        | Update_Draft_Schema_400 | json        | error, Illegal Argument   |
      | Unauthorized | PUT    | /api/v1/loan-syndications/draft/{dealId} | InvalidHeaders | NA        | Update_Draft_Request | 401        | NA         | text        | Jwt is expired |
#      | Forbidden     | PUT    | /api/v1/loan-syndications/draft/{dealId}  | InvestorToken  | NA        | Update_Draft_Request | 403        | Update_Draft_Schema_403 | json        | error,Unauthorized action |
#      | Not Found     | PUT    | /api/v1/loan-syndications/{dealId}2       | NA             | NA        | Update_Draft_Request | 404        | Update_Draft_Schema_404 | json        | error,Not Found           |