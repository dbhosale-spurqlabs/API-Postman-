Feature: All Deal Closing Document API Validation

  @api

  Scenario Outline: Validate POST Upload Invitation Letter API Response for "<scenarioName>" scenario
    When User uploads file using "<method>" request to "<url>" with headers "<headers>" and file "<filePath>" and fileName "<fileName>"
    Then User verifies the response status code is <statusCode>
    And User verifies fields in response: "<contentType>" with content type "<fields>"

    Examples:
      | scenarioName        | method | url               | headers        | filePath            | fileName            | statusCode | contentType | fields                                 |
      | Valid PDF Upload    | POST   | /api/v1/documents | NA             | Transaction_Doc.pdf | Transaction_Doc.pdf | 200        | json        | type=success;data.type=application/pdf |
#      | Invalid File Type   | POST   | /api/v1/documents | NA             | Invitation_Letter.txt | Invitation_Letter.txt | 400        | json        | type, error          |
      | Unauthorized Access | POST   | /api/v1/documents | InvalidHeaders | Transaction_Doc.pdf | Transaction_Doc.pdf | 401        | text        | Jwt is expired                         |
#      | Forbidden Access    | POST   | /api/v1/documents | InvestorToken  | Transaction_Doc.pdf | Transaction_Doc.pdf | 403        | json        | error,Forbidden |


  @api @uploadDoc

  Scenario Outline: Validate POST and GET Draft Transaction Document API Response for "<scenarioName>" scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"

    Examples:
      | scenarioName   | method | url                                               | headers | queryFile | bodyFile          | statusCode | schemaFile               | contentType | fields                    |
  | Valid creation | POST   | /api/v2/loan-syndications/{dealId}/txn-docs/draft | NA      | NA        | Draft_Doc_Request | 200        | Draft_Doc_Schema_200     | json        | notificationEnabled, true |
      | Valid Get      | GET    | /api/v2/loan-syndications/{dealId}/txn-docs/draft | NA      | NA        | NA                | 200        | Get_Draft_DOc_Schema_200 | json        | mpId,{dealCreatorMpId}    |

  @api
  Scenario Outline: Validate POST Deal Closing API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName   | method | url                                            | headers        | queryFile | bodyFile                 | statusCode | schemaFile              | contentType | fields         |
      | Valid creation | POST   | /api/v1/symphony/dealrooms/primary/dealclosing | NA             | NA        | Deal_Closing_Request_200 | 200        | Deal_Closing_Schema_200 | json        | type, success  |
#      | Bad Request    | POST   | /api/v1/symphony/dealrooms/primary/dealclosing | NA             | NA        | Deal_Closing_Request_400 | 400        | Deal_Closing_Schema_400 | json        | type, error    |
      | Unauthorized   | POST   | /api/v1/symphony/dealrooms/primary/dealclosing | InvalidHeaders | NA        | Deal_Closing_Request_200 | 401        | NA                      | text        | Jwt is expired |

  @api
  Scenario Outline: Validate POST Doc Export API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName   | method | url                           | headers        | queryFile | bodyFile               | statusCode | schemaFile            | contentType | fields         |
      | Valid creation | POST   | /api/v1/bulk/documents/export | NA             | NA        | Doc_Export_Request_200 | 200        | Doc_Export_Schema_200 | NA          | type, success  |
#      | Bad Request    | POST   | /api/v1/bulk/documents/export | NA             | NA        | Doc_Export_Request_200 | 400        |                       |             |                           |
      | Unauthorized   | POST   | /api/v1/bulk/documents/export | InvalidHeaders | NA        | Doc_Export_Request_200 | 401        | NA                    | text        | Jwt is expired |
#      | Forbidden      | POST   | /api/v1/bulk/documents/export | InvestorToken  | NA        | Doc_Export_Request_200 | 403        | Doc_Export_Schema_403 | json        | detail,User not permitted to perform this action |


