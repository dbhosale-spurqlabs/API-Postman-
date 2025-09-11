Feature: DataRoom Multiple File Permission Set MP API Validation

  @api
  Scenario Outline: Validate POST DataRoom Multiple File Permission Set API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName   | method | url                                                            | headers        | queryFile | bodyFile                                            | statusCode | schemaFile                                         | contentType | fields         |
      | Valid creation | POST   | /api/v2/dataroom/{dataRoomId}/permissions/multiple/files/GROUP | NA             | NA        | DataRoom_Multiple_File_Group_Permission_Request_200 | 200        | DataRoom_Multiple_File_Group_Permission_Schema_200 | json        | type, success  |
      | Unauthorized   | POST   | /api/v2/dataroom/{dataRoomId}/permissions/multiple/files/GROUP | InvalidHeaders | NA        | DataRoom_Multiple_File_Group_Permission_Request_200 | 401        | NA                                                 | text        | Jwt is expired |