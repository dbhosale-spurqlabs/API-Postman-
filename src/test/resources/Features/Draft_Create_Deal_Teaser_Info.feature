Feature: Draft Create Deal Teaser API Validation

  @api
  Scenario Outline: Validate POST Draft Create Deal Teaser API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName   | method | url                             | headers        | queryFile | bodyFile                                  | statusCode | schemaFile | contentType | fields         |
      | Valid creation | POST   | /api/v1/loan-syndications/draft | NA             | NA        | Draft_Create_Deal_Teaser_Info_Request_200 | 201        | NA         | NA          |                |
#      | Bad Request    | POST   | /api/v1/loan-syndications/draft | NA             | NA        | Draft_Create_Deal_Teaser_Info_Request_400 | 400        | NA         | NA          |                |
      | Unauthorized   | POST   | /api/v1/loan-syndications/draft | InvalidHeaders | NA        | Draft_Create_Deal_Teaser_Info_Request_200 | 401        | NA         | text        | Jwt is expired |
#      | Forbidden      | POST   | /api/v1/loan-syndications/draft | InvestorToken  | NA        | Draft_Create_Deal_Teaser_Info_Request     | 403        |            |             |                |
#      | Duplicate resource | POST   | /api/v1/loan-syndications/draft | InvestorToken  | NA        | Draft_Create_Deal_Teaser_Info_Request | 409        |                                          |             |                           |
#      | Validation failed  | POST   | /api/v1/loan-syndications/draft | InvestorToken  | NA        | Draft_Create_Deal_Teaser_Info_Request | 422        |                                          |             |                           |
