Feature: All Notes API Validation

        @api

        Scenario Outline: Validate POST Create Notes API Response for "<scenarioName>" Scenario
             When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
             Then User verifies the response status code is <statusCode>
              And User verifies the response body matches JSON schema "<schemaFile>"
             Then User verifies fields in response: "<contentType>" with content type "<fields>"
        Examples:
                  | scenarioName       | method | url                                                             | headers | queryFile | bodyFile             | statusCode | schemaFile | contentType | fields |
                  | Valid create Notes | POST   | /api/v1/loan-syndications/{dealId}/investors/{investorId}/notes | NA      | NA        | Create_Notes_Request | 200        | NA         | NA          | NA     |
#      | Bad Request       | POST   | /api/v1/loan-syndications/{dealId}_/investors/{investorId}/notes                       | NA             | NA        | Create_Notes_Request | 400        | Create_Notes_Schema_400 | json        | error,Illegal Argument    |
                  | Unauthorized | POST | /api/v1/loan-syndications/{dealId}/investors/{investorId}/notes | InvalidHeaders | NA | Create_Notes_Request | 401 | NA | text | Jwt is expired |
#      | Forbidden         | POST   | /api/v1/loan-syndications/{dealId}/investors/{investorId}/notes                        | InvestorToken  | NA        | Create_Notes_Request | 403        | Create_Notes_Schema_403 | json        | error,Unauthorized action |
#      | Duplicate resource | POST   | /api/v1/loan-syndications/{dealId}/investors/{investorId}/notes                        | NA             | NA        | Create_Notes_Request | 409        |                         |             |                           |
#      | Validation failed  | POST   | /api/v1/loan-syndications/{dealId}/investors/{investorId}/notes                        | NA             | NA        | Create_Notes_Request | 422        |                         |             |                           |

        @api

        Scenario Outline: Validate GET Notes API Response for "<scenarioName>" Scenario
             When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
             Then User verifies the response status code is <statusCode>
              And User verifies the response body matches JSON schema "<schemaFile>"
             Then User verifies fields in response: "<contentType>" with content type "<fields>"
        Examples:
                  | scenarioName    | method | url                                                             | headers | queryFile | bodyFile | statusCode | schemaFile       | contentType | fields              |
                  | Valid Get Notes | GET    | /api/v1/loan-syndications/{dealId}/investors/{investorId}/notes | NA      | NA        | NA       | 200        | Notes_Schema_200 | json        | note=This is Note 1 |
#      | Invalid ID format | GET    | /api/v1/loan-syndications/{dealId}_/investors/{investorId}/notes                       | NA             | NA        | NA                   | 400        | Notes_Schema_400        | json        | error,Illegal Argument    |
                  | Unauthorized | GET | /api/v1/loan-syndications/{dealId}/investors/{investorId}/notes | InvalidHeaders | NA | NA | 401 | NA | text | Jwt is expired |
#      | Forbidden         | GET    | /api/v1/loan-syndications/{dealId}/investors/{investorId}/notes                        | InvestorToken  | NA        | NA                   | 403        | Notes_Schema_403        | json        | error,Unauthorized action |
#      | Not Found          | GET    | /api/v1/loan-syndications/{dealId}2/investors/{investorId}/notes                       | NA             | NA        | NA                   | 404        | Notes_Schema_404        | json        | error,Not Found           |

        @api

        Scenario Outline: Validate PUT Notes API Response for "<scenarioName>" Scenario
             When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
             Then User verifies the response status code is <statusCode>
              And User verifies the response body matches JSON schema "<schemaFile>"
             Then User verifies fields in response: "<contentType>" with content type "<fields>"
        Examples:
                  | scenarioName       | method | url                                                                                   | headers | queryFile | bodyFile             | statusCode | schemaFile | contentType | fields |
                  | Valid update Notes | PUT    | /api/v1/loan-syndications/{dealId}/investors/{investorId}/notes/{noteId}/update-notes | NA      | NA        | Update_Notes_Request | 200        | NA         | NA          | NA     |
#      | Invalid input     | PUT    | /api/v1/loan-syndications/{dealId}_/investors/{investorId}/notes/{noteId}/update-notes | NA             | NA        | Update_Notes_Request | 400        | Update_Notes_Schema_400 | json        | error, Illegal Argument   |
                  | Unauthorized | PUT | /api/v1/loan-syndications/{dealId}/investors/{investorId}/notes/{noteId}/update-notes | InvalidHeaders | NA | Update_Notes_Request | 401 | NA | text | Jwt is expired |
#      | Forbidden         | PUT    | /api/v1/loan-syndications/{dealId}/investors/{investorId}/notes/{noteId}/update-notes  | InvestorToken  | NA        | Update_Notes_Request | 403        | Update_Notes_Schema_403 | json        | error,Unauthorized action |
#      | Not Found          | PUT    | /api/v1/loan-syndications/{dealId}2/investors/{investorId}/notes/{noteId}/update-notes | NA             | NA        | Update_Notes_Request | 404        | Update_Notes_Schema_404 | json        | error,Not Found           |
#      | Duplicate resource | PUT    | /api/v1/loan-syndications/{dealId}/investors/{investorId}/notes/{noteId}/update-notes | NA             | NA        | Update_Notes_Request | 409        |                         |             |                           |

        @api
        Scenario Outline: Validate PUT Pin Note API Response for "<scenarioName>" Scenario
             When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
             Then User verifies the response status code is <statusCode>
              And User verifies the response body matches JSON schema "<schemaFile>"
             Then User verifies fields in response: "<contentType>" with content type "<fields>"
        Examples:
                  | scenarioName | method | url                                                                          | headers | queryFile | bodyFile | statusCode | schemaFile | contentType | fields |
                  | Valid update | PUT    | /api/v1/loan-syndications/{dealId}/investors/{investorId}/notes/{noteId}/pin | NA      | NA        | NA       | 200        | NA         | NA          | NA     |
#      | Invalid input     | PUT    | /api/v1/loan-syndications/{dealId}_/investors/{investorId}/notes/{noteId}/pin          | NA             | NA        | NA                   | 400        | Pin_Notes_Schema_400    | json        | error, Illegal Argument   |
                  | Unauthorized | PUT | /api/v1/loan-syndications/{dealId}/investors/{investorId}/notes/{noteId}/pin | InvalidHeaders | NA | NA | 401 | NA | text | Jwt is expired |
#      | Forbidden         | PUT    | /api/v1/loan-syndications/{dealId}/investors/{investorId}/notes/{noteId}/pin           | InvestorToken  | NA        | NA                   | 403        | Pin_Notes_Schema_403    | json        | error,Unauthorized action |
#      | Not Found          | PUT    | /api/v1/loan-syndications/{dealId}2/investors/{investorId}/notes/{noteId}/pin          | NA             | NA        | NA                   | 404        | Pin_Notes_Schema_404    | json        | error,Not Found           |
#      | Duplicate resource | PUT    | /api/v1/loan-syndications/{dealId}/investors/{investorId}/notes/{noteId}/pin          | NA             | NA        | NA                   | 409        |                         |             |                           |

        @api
        Scenario Outline: Validate PUT Unpin Note API Response for "<scenarioName>" Scenario
             When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
             Then User verifies the response status code is <statusCode>
              And User verifies the response body matches JSON schema "<schemaFile>"
             Then User verifies fields in response: "<contentType>" with content type "<fields>"
        Examples:
                  | scenarioName | method | url                                                                            | headers | queryFile | bodyFile | statusCode | schemaFile | contentType | fields |
                  | Valid update | PUT    | /api/v1/loan-syndications/{dealId}/investors/{investorId}/notes/{noteId}/unpin | NA      | NA        | NA       | 200        | NA         | NA          | NA     |
#      | Invalid input     | PUT    | /api/v1/loan-syndications/{dealId}_/investors/{investorId}/notes/{noteId}/unpin        | NA             | NA        | NA                   | 400        | UnPin_Notes_Schema_400  | json        | error, Illegal Argument   |
                  | Unauthorized | PUT | /api/v1/loan-syndications/{dealId}/investors/{investorId}/notes/{noteId}/unpin | InvalidHeaders | NA | NA | 401 | NA | text | Jwt is expired |
#      | Forbidden         | PUT    | /api/v1/loan-syndications/{dealId}/investors/{investorId}/notes/{noteId}/unpin         | InvestorToken  | NA        | NA                   | 403        | UnPin_Notes_Schema_403  | json        | error,Unauthorized action |
#      | Not Found          | PUT    | /api/v1/loan-syndications/{dealId}2/investors/{investorId}/notes/{noteId}/unpin        | NA             | NA        | NA                   | 404        | UnPin_Notes_Schema_404  | json        | error,Not Found           |
#      | Duplicate resource | PUT    | /api/v1/loan-syndications/{dealId}/investors/{investorId}/notes/{noteId}/unpin        | NA             | NA        | NA                   | 409        |                         |             |                           |

        @api
        Scenario Outline: Validate DELETE Create Notes API Response for "<scenarioName>" Scenario
             When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
             Then User verifies the response status code is <statusCode>
              And User verifies the response body matches JSON schema "<schemaFile>"
             Then User verifies fields in response: "<contentType>" with content type "<fields>"
        Examples:
                  | scenarioName | method | url                                                                      | headers | queryFile | bodyFile | statusCode | schemaFile | contentType | fields |
                  | Valid delete | DELETE | /api/v1/loan-syndications/{dealId}/investors/{investorId}/notes/{noteId} | NA      | NA        | NA       | 200        | NA         | NA          | NA     |
#      | Invalid input     | DELETE | /api/v1/loan-syndications/{dealId}_/investors/{investorId}/notes/{noteId}              | NA             | NA        | NA                   | 400        | Delete_Notes_Schema_400 | json        | error, Illegal Argument   |
                  | Unauthorized | DELETE | /api/v1/loan-syndications/{dealId}/investors/{investorId}/notes/{noteId} | InvalidHeaders | NA | NA | 401 | NA | text | Jwt is expired |
#      | Not Found          | DELETE | /api/v1/loan-syndications/{dealId}2/investors/{investorId}/notes/{noteId}              | NA             | NA        | NA                   | 404        | Delete_Notes_Schema_404 | json        | error,Not Found           |