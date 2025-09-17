Feature: Sell Offer Partnership Status API Validation

        @api  @setupDataRoom
        Scenario Outline: Validate PUT Sell Offer Partnership Status API Response for "<scenarioName>" Scenario
             When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
             Then User verifies the response status code is <statusCode>
              And User verifies the response body matches JSON schema "<schemaFile>"
             Then User verifies fields in response: "<contentType>" with content type "<fields>"
        Examples:
                  | scenarioName  | method | url                                                        | headers        | queryFile                               | bodyFile | statusCode | schemaFile                               | contentType | fields         |
                  | Valid request | PUT    | /api/v2/sell-offer-bids/{publishsellid}/seller-partnership | NA             | Sell_Offer_Partnership_Status_Query_200 | NA       | 200        | Sell_Offer_Partnership_Status_Schema_200 | NA          | NA             |
                  | Unauthorized  | PUT    | /api/v2/sell-offer-bids/{publishsellid}/seller-partnership | InvalidHeaders | Sell_Offer_Partnership_Status_Query_401 | NA       | 401        | NA                                       | text        | Jwt is expired |
