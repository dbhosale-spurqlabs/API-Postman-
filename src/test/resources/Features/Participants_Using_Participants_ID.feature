Feature: Participants Using Participants ID API Validation

  @api
  Scenario Outline: Validate GET Participants Using Participants ID API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName      | method | url                  | headers        | queryFile                                | bodyFile | statusCode | schemaFile                                    | contentType | fields         |
      | Valid             | GET    | /api/v1/participants | NA             | Participants_Using_Participants_ID_Query | NA       | 200        | Participants_Using_Participants_ID_Schema_200 | json        | type,success   |
#      | Invalid ID format | GET    | /api/v1/participants | NA             | Participants_Using_Participants_ID_Query | NA       | 400        |                                               |             |                |
      | Unauthorized      | GET    | /api/v1/participants | InvalidHeaders | Participants_Using_Participants_ID_Query | NA       | 401        | NA                                            | text        | Jwt is expired |
#      | Forbidden         | GET    | /api/v1/participants | InvestorToken  | Participants_Using_Participants_ID_Query | NA       | 403        |                                               |             |                |
#      | Not Found         | GET    | /api/v1/participants | NA             | Participants_Using_Participants_ID_Query | NA       | 404        |                                               |             |                |