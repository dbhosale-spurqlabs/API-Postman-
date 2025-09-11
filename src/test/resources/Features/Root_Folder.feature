Feature: Root Folder

  @api
  Scenario Outline: Validate GET Root Folder API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName    | method | url                                                                                        | headers        | queryFile | bodyFile | statusCode | schemaFile               | contentType | fields         |
      | Valid request   | GET    | /api/v2/dataroom/8b7ce343-5a0a-48c3-ab0b-ce6a0ec138de/folders/aee739dc-7f27-4cd2-8775-3abe1196d969 | NA            | NA        | NA       | 200        | Root_Folder_Schema_200   | NA          | NA             |
      | Unauthorized    | GET    | /api/v2/dataroom/8b7ce343-5a0a-48c3-ab0b-ce6a0ec138de/folders/aee739dc-7f27-4cd2-8775-3abe1196d969 | InvalidHeaders | NA        | NA       | 401        | NA                      | text        | Jwt is expired |
