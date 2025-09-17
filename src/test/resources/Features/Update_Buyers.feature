Feature: Update Buyers API Validation

        @api @setupDataRoom
        Scenario Outline: Validate PUT Update Buyers API Response for "<scenarioName>" Scenario
            Given user has a valid sell offer id
             When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
             Then User verifies the response status code is <statusCode>
              And User verifies the response body matches JSON schema "<schemaFile>"
             Then User verifies fields in response: "<contentType>" with content type "<fields>"
        Examples:
                  | scenarioName  | method | url                                               | headers        | queryFile               | bodyFile               | statusCode | schemaFile | contentType | fields         |
                  | Valid request | PUT    | /api/v2/sell-offers/{publishsellid}/update-buyers | NA             | Update_Buyers_Query_200 | Update_Buyers_Body_200 | 200        | NA         | NA          | NA             |
                  | Unauthorized  | PUT    | /api/v2/sell-offers/{publishsellid}/update-buyers | InvalidHeaders | Update_Buyers_Query_401 | Update_Buyers_Body_401 | 401        | NA         | text        | Jwt is expired |
