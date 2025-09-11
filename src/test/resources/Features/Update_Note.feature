Feature: Update Note API Validation


  Scenario Outline: Validate PUT Update Note API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName  | method | url                                                                                                                                                                    | headers        | queryFile | bodyFile                | statusCode | schemaFile             | contentType | fields                    |
#      | Valid update  | PUT    | /api/v1/loan-syndications/479acfb7-f239-4ec0-a418-3ba638b0d832/investors/4e209b4d-d605-4116-bcfa-2e7bbc8f9fe9/notes/5254d7fb-d82a-4b8b-9044-b5e91defb855/update-notes  | NA             | NA        | Update_Note_Request_200 | 200        | NA                     | NA          |                           |
#      | Invalid input | PUT    | /api/v1/loan-syndications/479acfb7-f239-4ec0-a418-3ba638b0d832_/investors/4e209b4d-d605-4116-bcfa-2e7bbc8f9fe9/notes/5254d7fb-d82a-4b8b-9044-b5e91defb855/update-notes | NA             | NA        | Update_Note_Request_200 | 400        | Update_Note_Schema_400 | json        | error, Illegal Argument   |
#      | Unauthorized  | PUT    | /api/v1/loan-syndications/479acfb7-f239-4ec0-a418-3ba638b0d832/investors/4e209b4d-d605-4116-bcfa-2e7bbc8f9fe9/notes/5254d7fb-d82a-4b8b-9044-b5e91defb855/update-notes  | InvalidHeaders | NA        | Update_Note_Request_200 | 401        | NA                     | text        | Jwt is expired            |
#      | Forbidden     | PUT    | /api/v1/loan-syndications/479acfb7-f239-4ec0-a418-3ba638b0d832/investors/4e209b4d-d605-4116-bcfa-2e7bbc8f9fe9/notes/5254d7fb-d82a-4b8b-9044-b5e91defb855/update-notes  | InvestorToken  | NA        | Update_Note_Request_200 | 403        | Update_Note_Schema_403 | json        | error,Unauthorized action |
#      | Not Found     | PUT    | /api/v1/loan-syndications/479acfb7-f239-4ec0-a418-3ba638b0d8322/investors/4e209b4d-d605-4116-bcfa-2e7bbc8f9fe9/notes/5254d7fb-d82a-4b8b-9044-b5e91defb855/update-notes | NA             | NA        | Update_Note_Request_200 | 404        | Update_Note_Schema_404 | json        | error,Not Found           |