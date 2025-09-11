Feature: Deal Closing API Validation

  @api
  Scenario Outline: Validate POST Deal Closing API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName   | method | url                                            | headers        | queryFile | bodyFile                 | statusCode | schemaFile              | contentType | fields         |
      | Valid creation | POST   | /api/v1/symphony/dealrooms/primary/dealclosing | NA             | NA        | Deal_Closing_Request_200 | 200        | Deal_Closing_Schema_200 | NA          | type, success  |
#      | Bad Request    | POST   | /api/v1/symphony/dealrooms/primary/dealclosing | NA             | NA        | Deal_Closing_Request_400 | 400        | Deal_Closing_Schema_400 |             | type, error    |
      | Unauthorized   | POST   | /api/v1/symphony/dealrooms/primary/dealclosing | InvalidHeaders | NA        | Deal_Closing_Request_200 | 401        | NA                      | text        | Jwt is expired |
#      | Forbidden      | POST   | /api/v1/symphony/dealrooms/primary/dealclosing | InvestorToken  | NA        |  | 403        |                         |             |                |
#      | Duplicate resource | POST   | /api/v1/symphony/dealrooms/primary/dealclosing  | InvestorToken  | NA        |  | 409        |                         |             |                           |
#      | Validation failed  | POST   | /api/v1/symphony/dealrooms/primary/dealclosing  | InvestorToken  | NA        |  | 422        |                         |             |                           |
