Feature: Participant With ID API Validation

  @api
  Scenario Outline: Validate GET Participant With ID API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName      | method | url                  | headers        | queryFile                     | bodyFile | statusCode | schemaFile                     | contentType | fields         |
      | Valid             | GET    | /api/v1/participants | NA             | Participant_With_Id_Query_200 | NA       | 200        | Participant_With_Id_Schema_200 | json        | type,success   |
#      | Invalid ID format | GET    | /api/v1/participants | NA             | Participant_With_Id_Query_200 | NA       | 400        |                                |             |                |
      | Unauthorized      | GET    | /api/v1/participants | InvalidHeaders | Participant_With_Id_Query_200 | NA       | 401        | NA                             | text        | Jwt is expired |
#      | Forbidden         | GET    | /api/v1/participants | InvestorToken  | Participant_With_Id_Query_200 | NA       | 403        |                             |             |                                  |
#      | Not found         | GET    | /api/v1/participants | NA             | Participant_With_Id_Query_200 | NA       | 404        |                             |             |                                  |