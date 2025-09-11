Feature: Distribution Participant List API Validation

  @api
  Scenario Outline: Validate GET Distribution Participant List API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName      | method | url                        | headers        | queryFile | bodyFile | statusCode | schemaFile                               | contentType | fields         |
      | Valid             | GET    | /api/v1/participants/my/dl | NA             | NA        | NA       | 200        | Distribution_Participant_List_Schema_200 | json        | type,success   |
#      | Invalid ID format | GET    | /api/v1/participants/my/dl | NA             | NA        | NA       | 400        |                                          |             |                |
      | Unauthorized      | GET    | /api/v1/participants/my/dl | InvalidHeaders | NA        | NA       | 401        | NA                                       | text        | Jwt is expired |
#      | Forbidden         | GET    | /api/v1/participants/my/dl | InvestorToken  | NA        | NA       | 403        |                                          | json        |                |
#      | Not Found         | GET    | /api/v1/participants/my/dl | NA             | NA        | NA       | 404        |                                          |             |                |