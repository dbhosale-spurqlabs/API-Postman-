Feature: Get Sell Offer Deal Document Participants API Validation

  @api @extractSellOfferId
  Scenario Outline: Validate GET Sell Offer Deal Document Participants API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
  | scenarioName    | method | url                        | headers        | queryFile                                  | bodyFile | statusCode | schemaFile                                  | contentType | fields                                                                     |
  | Valid request   | GET    | /api/v1/participants       | NA             | Get_Sell_Offer_Deal_Document_Participants_200| NA      | 200        | Get_Sell_Offer_Deal_Document_Participants_Schema_200| json    | participants.id,participants.firstName,participants.lastName,participants.email |
  | Unauthorized    | GET    | /api/v1/participants       | InvalidHeaders | Get_Sell_Offer_Deal_Document_Participants_401| NA      | 401        | NA| text        | Jwt is expired                                                             |
