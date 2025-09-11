Feature: Folder Structure Data Room API Validation

  @api
  Scenario Outline: Validate GET Folder Structure Data Room API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName    | method | url                                    | headers        | queryFile                          | bodyFile | statusCode | schemaFile                          | contentType | fields                                                        |
      | Valid request   | GET    | /api/v2/dataroom/{id}/folders         | NA            | Folder_Structure_DataRoom_200      | NA      | 200        | Folder_Structure_DataRoom_Schema_200 | json       | folders.id,folders.name,folders.parentId,folders.createdAt     |
      | Unauthorized    | GET    | /api/v2/dataroom/{id}/folders         | InvalidHeaders | Folder_Structure_DataRoom_401      | NA      | 401        | NA                                 | text        | Jwt is expired                                               |
