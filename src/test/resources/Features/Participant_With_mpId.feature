Feature: Participant With mpID API Validation

  @api
  Scenario Outline: Validate GET Participant With mpID API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName      | method | url                      | headers        | queryFile                       | bodyFile | statusCode | schemaFile                       | contentType | fields         |
      | Valid             | GET    | /api/v1/participants/ids | NA             | Participant_With_mpId_Query_200 | NA       | 200        | Participant_With_mpId_Schema_200 | json        | type,success   |
#      | Invalid ID format | GET    | /api/v1/participants/ids | NA             | Participant_With_mpId_Query_400 | NA       | 400        | Participant_With_mpId_Schema_400 | json        | type,error     |
      | Unauthorized      | GET    | /api/v1/participants/ids | InvalidHeaders | Participant_With_mpId_Query_200 | NA       | 401        | NA                               | text        | Jwt is expired |
#      | Forbidden         | GET    | /api/v1/participants/ids | InvestorToken  | Participant_With_mpId_Query_200 | NA       | 403        |                             |             |                                  |
#      | Not found         | GET    | /api/v1/participants/ids | NA             | Participant_With_mpId_Query_200 | NA       | 404        |                             |             |                                  |