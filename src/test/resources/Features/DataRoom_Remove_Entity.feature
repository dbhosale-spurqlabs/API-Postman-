Feature: DataRoom Admin Level Activity API Validation

  @api
  Scenario Outline: Validate DELETE  DataRoom Entity API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName   | method | url                                                  | headers        | queryFile | bodyFile                           | statusCode | schemaFile                        | contentType | fields         |
#      | Valid creation | DELETE | /api/v2/private/dataroom/{dataRoomId}/entity/removal | NA             | NA        | DataRoom_Remove_Entity_Request_200 | 200        | DataRoom_Remove_Entity_Schema_200 | json        | type, success  |
      | Unauthorized   | DELETE | /api/v2/private/dataroom/{dataRoomId}/entity/removal | InvalidHeaders | NA        | DataRoom_Remove_Entity_Request_200 | 401        | NA                                | text        | Jwt is expired |
