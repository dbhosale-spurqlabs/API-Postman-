Feature: Pin Note API Validation


  Scenario Outline: Validate PUT Pin Note API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName  | method | url                                                                                                                                                           | headers        | queryFile | bodyFile | statusCode | schemaFile          | contentType | fields                    |
#      | Valid update  | PUT    | /api/v1/loan-syndications/479acfb7-f239-4ec0-a418-3ba638b0d832/investors/4e209b4d-d605-4116-bcfa-2e7bbc8f9fe9/notes/1799d0c0-f09f-43c3-b806-c9084ab14dcf/pin  | NA             | NA        | NA       | 200        | NA                  | NA          |                           |
#      | Invalid input | PUT    | /api/v1/loan-syndications/479acfb7-f239-4ec0-a418-3ba638b0d832_/investors/4e209b4d-d605-4116-bcfa-2e7bbc8f9fe9/notes/1799d0c0-f09f-43c3-b806-c9084ab14dcf/pin | NA             | NA        | NA       | 400        | Pin_Note_Schema_400 | json        | error, Illegal Argument   |
#      | Unauthorized  | PUT    | /api/v1/loan-syndications/479acfb7-f239-4ec0-a418-3ba638b0d832/investors/4e209b4d-d605-4116-bcfa-2e7bbc8f9fe9/notes/1799d0c0-f09f-43c3-b806-c9084ab14dcf/pin  | InvalidHeaders | NA        | NA       | 401        | NA                  | text        | Jwt is expired            |
#      | Forbidden     | PUT    | /api/v1/loan-syndications/479acfb7-f239-4ec0-a418-3ba638b0d832/investors/4e209b4d-d605-4116-bcfa-2e7bbc8f9fe9/notes/1799d0c0-f09f-43c3-b806-c9084ab14dcf/pin  | InvestorToken  | NA        | NA       | 403        | Pin_Note_Schema_403 | json        | error,Unauthorized action |
#      | Not Found     | PUT    | /api/v1/loan-syndications/479acfb7-f239-4ec0-a418-3ba638b0d8322/investors/4e209b4d-d605-4116-bcfa-2e7bbc8f9fe9/notes/1799d0c0-f09f-43c3-b806-c9084ab14dcf/pin | NA             | NA        | NA       | 404        | Pin_Note_Schema_404 | json        | error,Not Found           |