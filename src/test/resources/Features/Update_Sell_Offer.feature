Feature: Update Sell Offer API Validation

         @api @extractSellOfferId
        Scenario Outline: Validate GET View Sell Offer API Response for "<scenarioName>" Scenario
             When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
             Then User verifies the response status code is <statusCode>
              And User verifies the response body matches JSON schema "<schemaFile>"
             Then User verifies fields in response: "<contentType>" with content type "<fields>"
        Examples:
                  | scenarioName  | method | url                      | headers        | queryFile | bodyFile | statusCode | schemaFile                 | contentType | fields         |
                  | Valid request | GET    | /api/v2/sell-offers/{secondaryDealId} | NA             | NA        | NA       | 200        | View_Sell_Offer_Schema_200 | json        | status, 200    |



        @api @extractSellOfferId
        Scenario Outline: Validate PUT Update Sell Offer API Response for "<scenarioName>" Scenario
            Given user has a valid sell offer id
             When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
             Then User verifies the response status code is <statusCode>
              And User verifies the response body matches JSON schema "<schemaFile>"
             Then User verifies fields in response: "<contentType>" with content type "<fields>"
        Examples:
                  | scenarioName  | method | url                                         | headers        | queryFile | bodyFile                   | statusCode | schemaFile | contentType | fields         |
                  | Valid request | PUT    | /api/v2/sell-offers/draft/{secondaryDealId} | NA             | NA        | Update_Sell_Offer_Body_200 | 200        | NA         | NA          | NA             |
                  | Unauthorized  | PUT    | /api/v2/sell-offers/draft/{secondaryDealId} | InvalidHeaders | NA        | Update_Sell_Offer_Body_401 | 401        | NA         | text        | Jwt is expired |
