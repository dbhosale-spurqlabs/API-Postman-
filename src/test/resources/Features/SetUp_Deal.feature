Feature: SetUp Deal API Validation

  @api @setUpDeal
  Scenario Outline: Validate POST SetUp Deal API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName   | method | url                                                | headers        | queryFile | bodyFile           | statusCode | schemaFile            | contentType | fields                    |
      | Valid creation | POST   | /api/v1/loan-syndications/draft/{locationId}/setup | NA             | NA        | SetUp_Deal_Request | 200        | NA                    | NA          |                           |
#      | Bad Request    | POST   | /api/v1/loan-syndications/draft/{dealId}/setup     | NA             | NA        | SetUp_Deal_Request | 400        | SetUp_Deal_Schema_400 | json        | status, 400               |
      | Unauthorized   | POST   | /api/v1/loan-syndications/draft/{dealId}/setup     | InvalidHeaders | NA        | SetUp_Deal_Request | 401        | NA                    | text        | Jwt is expired            |
#      | Forbidden      | POST   | /api/v1/loan-syndications/draft/{dealId}/setup     | InvestorToken  | NA        | SetUp_Deal_Request | 403        | SetUp_Deal_Schema_403 | json        | error,Unauthorized action |
#      | Duplicate resource | POST   | /api/v1/loan-syndications/draft/{dealId}/setup   | InvestorToken  | NA        | SetUp_Deal_Request | 409        |                         |             |                           |
#      | Validation failed  | POST   | /api/v1/loan-syndications/draft/{dealId}/setup   | InvestorToken  | NA        | SetUp_Deal_Request | 422        |                         |             |                           |
