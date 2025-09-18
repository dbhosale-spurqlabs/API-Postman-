Feature: Draft Sell Offer API Validation

        @api
        Scenario Outline: Validate POST Draft Sell Offer API Response for "<scenarioName>" Scenario
             When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
             Then User verifies the response status code is <statusCode>
              And User verifies the response body matches JSON schema "<schemaFile>"
             Then User verifies fields in response: "<contentType>" with content type "<fields>"
        Examples:
                  | scenarioName  | method | url                       | headers        | queryFile | bodyFile                  | statusCode | schemaFile | contentType | fields         |
                  | Valid request | POST   | /api/v2/sell-offers/draft | NA             | NA        | Draft_Sell_Offer_Body_201 | 201        | NA         | NA          | NA             |
                  | Unauthorized  | POST   | /api/v2/sell-offers/draft | InvalidHeaders | NA        | Draft_Sell_Offer_Body_401 | 401        | NA         | text        | Jwt is expired |
