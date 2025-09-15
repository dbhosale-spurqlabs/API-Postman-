Feature: Publish Sell Offer
  @api @extractSellOfferId
  Scenario Outline: Validate POST Publish Sell Offer API Response for "Valid request" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | method | url                                    | headers        | queryFile | bodyFile                     | statusCode | schemaFile                     | contentType | fields         |
      | POST   | /api/v2/sell-offers/draft/{id}/publish | NA             | NA        | Publish_Sell_Offer_Body_200  | 200       | NA | NA        | NA             |

  @api @extractSellOfferId
  
  Scenario Outline: Validate POST Publish Sell Offer API Response for "Unauthorized" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | method | url                                    | headers        | queryFile | bodyFile                     | statusCode | schemaFile                     | contentType | fields         |
      | POST   | /api/v2/sell-offers/draft/{id}/publish  | InvalidHeaders | NA        | Publish_Sell_Offer_Body_401  | 401        | NA                             | text        | Jwt is expired |
