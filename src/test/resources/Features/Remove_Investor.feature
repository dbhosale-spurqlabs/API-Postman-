#Feature: Remove Investor API Validation
#
#  @api
#  Scenario Outline: Validate DELETE Remove Investor API Response for "<scenarioName>" Scenario
#    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
#    Then User verifies the response status code is <statusCode>
#    And User verifies the response body matches JSON schema "<schemaFile>"
#    Then User verifies fields in response: "<contentType>" with content type "<fields>"
#    Examples:
#      | scenarioName   | method | url                                                                              | headers | queryFile | bodyFile                | statusCode | schemaFile | contentType | fields |
#      | Valid deletion | DELETE | /api/v1/loan-syndications/988fb03a-f43c-4e12-a729-561c7ddad152/lenders/remove-mp | NA      | NA        | Remove_Investor_Request | 200        | NA         | NA          |        |
#      | Invalid ID     | DELETE | /api/v1/loan-syndications/988fb03a-f43c-4e12-a729-561c7ddad152/lenders/remove-mp  | NA             | NA        | Remove_Investor_Request | 400        | Remove_Investor_Schema_400 | json        | error,Illegal Argument |
#      | Unauthorized   | DELETE | /api/v1/loan-syndications/b83b5cb2-a43b-47d8-8f81-318c57529386/lenders/remove-mp  | InvalidHeaders | NA        | Remove_Investor_Request | 401        | NA                         | text        | Jwt is expired         |
#      | Not found      | DELETE | /api/v1/loan-syndications/988fb03a-f43c-4e12-a729-561c7ddad1522/lenders/remove-mp | NA             | NA        | Remove_Investor_Request | 404        | Remove_Investor_Schema_404 | json        | error,Not Found        |
