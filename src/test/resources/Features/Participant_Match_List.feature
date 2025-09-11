Feature: Participant Match List API Validation


  Scenario Outline: Validate GET Participant Match List API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName | method | url                                               | headers        | queryFile | bodyFile | statusCode | schemaFile                        | contentType | fields                               |
      | Valid        | GET    | /api/v1/credit-preferences/top-participants-match | NA             | NA        | NA       | 200        | Participant_Match_List_Schema_200 | json        | 6790e0eb-6d1a-471d-92be-c448589d7420 |
#      | Invalid ID format | GET    | /api/v1/credit-preferences/top-participants-match  | NA             | NA        | NA       | 400        | Participant_Match_List_Schema_400 | json        | error,Illegal Argument                                                     |
      | Unauthorized | GET    | /api/v1/credit-preferences/top-participants-match | InvalidHeaders | NA        | NA       | 401        | NA                                | text        | Jwt is expired                       |
#      | Forbidden         | GET    | /api/v1/credit-preferences/top-participants-match  | InvestorToken  | NA        | NA       | 403        | Participant_Match_List_Schema_403 | json        | error,Unauthorized action                                                  |
#      | Not Found    | GET    | /api/v1/credit-preferences_/top-participants-match | NA             | NA        | NA       | 404        | Participant_Match_List_Schema_404 | json        | error,Not Found                                                            |