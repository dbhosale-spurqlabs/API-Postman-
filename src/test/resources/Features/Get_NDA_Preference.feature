Feature: Get NDA Preference API Validation

  @api
  Scenario Outline: Validate GET Get NDA Preference API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName | method | url                          | headers        | queryFile | bodyFile | statusCode | schemaFile                    | contentType | fields         |
      | Valid        | GET    | /api/v1/deal-preferences/nda | NA             | NA        | NA       | 200        | Get_NDA_Preference_Schema_200 | json        | ndaType,null   |
#      | Invalid ID format | POST   | /api/v1/deal-preferences/nda | NA             | NA        | NA       | 400        | NA                            | NA          |                |
      | Unauthorized | GET    | /api/v1/deal-preferences/nda | InvalidHeaders | NA        | NA       | 401        | NA                            | text        | Jwt is expired |
#      | Forbidden         | GET    | /api/v1/deal-preferences/nda | InvestorToken  | NA        | NA       | 403        |                               |             |                |
#      | Not Found         | GET    | /api/v1/deal-preferences/nda | NA             | NA        | NA       | 404        |                               |             |                |