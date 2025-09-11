Feature: Assets Search API Validation

  @api
  Scenario Outline: Validate POST Assets Search API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName   | method | url                            | headers        | queryFile | bodyFile                  | statusCode | schemaFile               | contentType | fields                   |
      | Valid creation | POST   | /api/v1/platform-assets/search | NA             | NA        | Assets_Search_Request_200 | 200        | Assets_Search_Schema_200 | json        | actionType, AssetsSearch |
#      | Bad Request    | POST   | /api/v1/platform-assets/search | NA             | NA        | Assets_Search_Request_400 | 400        | Assets_Search_Schema_400 | json        | error,Illegal Argument   |
      | Unauthorized   | POST   | /api/v1/platform-assets/search | InvalidHeaders | NA        | Assets_Search_Request_200 | 401        | NA                       | text        | Jwt is expired           |
#      | Forbidden          | POST   | /api/v1/platform-assets/search | InvestorToken  | NA        |                           |            |                          |             |                              |
#      | Duplicate resource | POST   | /api/v1/platform-assets/search | NA             | NA        |                           | 409        |                          |             |                              |
#      | Validation failed  | POST   | /api/v1/platform-assets/search | NA             | NA        |                           | 422        |                          |             |                              |
