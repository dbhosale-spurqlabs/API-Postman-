Feature: View Sell Offer

        @api @setupDataRoom
        Scenario Outline: Validate GET View Sell Offer API Response for "<scenarioName>" Scenario
             When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
             Then User verifies the response status code is <statusCode>
              And User verifies the response body matches JSON schema "<schemaFile>"
             Then User verifies fields in response: "<contentType>" with content type "<fields>"
        Examples:
                  | scenarioName    | method | url                                   | headers        | queryFile | bodyFile | statusCode | schemaFile                 | contentType | fields         |
                  | View Sell Offer | GET    | /api/v2/sell-offers/{secondaryDealId} | NA             | NA        | NA       | 200        | View_Sell_Offer_Schema_200 | json        | state          |
                  | Unauthorized    | GET    | /api/v2/sell-offers/{secondaryDealId} | InvalidHeaders | NA        | NA       | 401        | NA                         | text        | Jwt is expired |
