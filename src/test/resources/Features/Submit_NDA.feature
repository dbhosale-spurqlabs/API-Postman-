Feature: Submit NDA

  @api
  Scenario Outline: Validate PUT Submit NDA API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName    | method | url                                                                                              | headers        | queryFile | bodyFile          | statusCode | schemaFile              | contentType | fields         |
      | Valid request   | PUT    | /api/v2/sell-offers/cacc8b95-0726-443e-b2c1-c7cf57637633/nda-doc                             | NA            | NA        | Submit_NDA_Body_200| 200        | Submit_NDA_Schema_200   | NA          | NA             |
      | Unauthorized    | PUT    | /api/v2/sell-offers/cacc8b95-0726-443e-b2c1-c7cf57637633/nda-doc                             | InvalidHeaders | NA        | Submit_NDA_Body_401| 401        | NA                      | text        | Jwt is expired |
