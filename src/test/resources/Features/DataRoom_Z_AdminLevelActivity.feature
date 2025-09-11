Feature: DataRoom Admin Level Activity API Validation

  @api
  Scenario Outline: Validate POST DataRoom Create API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName   | method | url              | headers        | queryFile | bodyFile                    | statusCode | schemaFile                 | contentType | fields         |
      | Valid creation | POST   | /api/v2/dataroom | NA             | NA        | DataRoom_Create_Request_200 | 200        | DataRoom_Create_Schema_200 | json        | type, success  |
      | Unauthorized   | POST   | /api/v2/dataroom | InvalidHeaders | NA        | DataRoom_Create_Request_200 | 401        | NA                         | text        | Jwt is expired |

  @api
  Scenario Outline: Validate POST Organisation Create API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName   | method | url                                         | headers        | queryFile | bodyFile                        | statusCode | schemaFile                     | contentType | fields         |
      | Valid creation | POST   | /api/v2/dataroom/{dataRoomId}/organisations | NA             | NA        | Organisation_Create_Request_200 | 200        | Organisation_Create_Schema_200 | json        | type, success  |
      | Unauthorized   | POST   | /api/v2/dataroom/{dataRoomId}/organisations | InvalidHeaders | NA        | Organisation_Create_Request_200 | 401        | NA                             | text        | Jwt is expired |

  @api
  Scenario Outline: Validate PUT Assign Organisation Group API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName   | method | url                                         | headers        | queryFile | bodyFile                               | statusCode | schemaFile                            | contentType | fields         |
      | Valid creation | PUT    | /api/v2/dataroom/{dataRoomId}/organisations | NA             | NA        | Assign_Organisation_Create_Request_200 | 200        | Assign_Organisation_Create_Schema_200 | json        | type, success  |
      | Unauthorized   | PUT    | /api/v2/dataroom/{dataRoomId}/organisations | InvalidHeaders | NA        | Assign_Organisation_Create_Request_200 | 401        | NA                                    | text        | Jwt is expired |

  @api
  Scenario Outline: Validate POST Delete DataRoom User API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName   | method | url                                         | headers        | queryFile | bodyFile                         | statusCode | schemaFile                      | contentType | fields         |
      | Valid creation | DELETE | /api/v2/dataroom/{dataRoomId}/organisations | NA             | NA        | Delete_DataRoom_User_Request_200 | 200        | Delete_DataRoom_User_Schema_200 | json        | type, success  |
      | Unauthorized   | DELETE | /api/v2/dataroom/{dataRoomId}/organisations | InvalidHeaders | NA        | Delete_DataRoom_User_Request_200 | 401        | NA                              | text        | Jwt is expired |
