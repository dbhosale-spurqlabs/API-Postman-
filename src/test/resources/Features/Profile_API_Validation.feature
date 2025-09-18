Feature: Profile API Validation

        @api10
        Scenario Outline: Validate GET Profile API Response for "<scenarioName>" Scenario
             When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
             Then User verifies the response status code is <statusCode>
              And User verifies the response body matches JSON schema "<schemaFile>"
             Then User verifies fields in response: "<contentType>" with content type "<fields>"
        Examples:
                  | scenarioName  | method | url                 | headers        | queryFile         | bodyFile | statusCode | schemaFile         | contentType | fields             |
                  | Valid request | GET    | /api/v1/profiles/my | NA             | Profile_Query_200 | NA       | 200        | Profile_Schema_200 | json        | id,name,email,role |
                  | Unauthorized  | GET    | /api/v1/profiles/my | InvalidHeaders | Profile_Query_401 | NA       | 401        | NA                 | text        | Jwt is expired     |
