Feature: Tranche Overview1 , Trade Recap and Update Draft Allocation API Validation

  @api
  Scenario Outline: Validate GET Tranche Overview1 API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName | method | url                                                  | headers        | queryFile | bodyFile | statusCode | schemaFile                   | contentType | fields                                |
      | Valid        | GET    | /api/v1/loan-syndications/{dealId}/tranches-overview | NA             | NA        | NA       | 200        | Tranche_Overview1_Schema_200 | json        | trancheList[0].trancheName, Tranche-1 |
#      | Invalid ID format | GET    | /api/v1/loan-syndications/{dealId}_/tranches-overview | NA             | NA        | NA       | 400        | Tranche_Overview1_Schema_400 | json        | error,Illegal Argument                           |
      | Unauthorized | GET    | /api/v1/loan-syndications/{dealId}/tranches-overview | InvalidHeaders | NA        | NA       | 401        | NA                           | text        | Jwt is expired                        |
#      | Forbidden         | GET    | /api/v1/loan-syndications/{dealId}/tranches-overview  | InvestorToken  | NA        | NA       | 403        | Tranche_Overview1_Schema_403 | json        | error,Unauthorized action                        |
#      | Not Found         | GET    | /api/v1/loan-syndications/{dealId}2/tranches-overview | NA             | NA        | NA       | 404        | Tranche_Overview1_Schema_404 | json        | error,Not Found                                  |

  #  Trade Recap
  @api
  Scenario Outline: Validate GET Trade Recap API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName | method | url                                                             | headers        | queryFile | bodyFile | statusCode | schemaFile | contentType | fields         |
      | Unauthorized | GET    | /api/v1/loan-tranche-responses/{investorInterestID}/trade-recap | InvalidHeaders | NA        | NA       | 401        | NA         | text        | Jwt is expired |
      | Valid        | GET    | /api/v1/loan-tranche-responses/{investorInterestID}/trade-recap | NA             | NA        | NA       | 200        | NA         | NA          |                |
##      | Invalid ID format | GET    | /api/v1/loan-tranche-responses/{investorInterestID}_/trade-recap | NA             | NA        | NA       | 400        | Trade_Recap_Schema_400 | json        | error,Illegal Argument    |
##      | Forbidden         | GET    | /api/v1/loan-tranche-responses/{investorInterestID}/trade-recap  | InvestorToken  | NA        | NA       | 403        | Trade_Recap_Schema_403 | json        | error,Unauthorized action |
##      | Not Found         | GET    | /api/v1/loan-tranche-responses/{investorInterestID}2/trade-recap | NA             | NA        | NA       | 404        | Trade_Recap_Schema_404 | json        | error,Not Found           |


    #  Update Draft Allocation
  @api
  Scenario Outline: Validate PUT Update Draft Allocation API Response for "<scenarioName>" Scenario
    When User sends "<method>" request to "<url>" with headers "<headers>" and query file "<queryFile>" and body file "<bodyFile>"
    Then User verifies the response status code is <statusCode>
    And User verifies the response body matches JSON schema "<schemaFile>"
    Then User verifies fields in response: "<contentType>" with content type "<fields>"
    Examples:
      | scenarioName | method | url                                                                    | headers        | queryFile | bodyFile                        | statusCode | schemaFile | contentType | fields         |
      | Valid update | PUT    | /api/v1/loan-tranche-responses/{investorInterestID}/update-by-arranger | NA             | NA        | Update_Draft_Allocation_Request | 200        | NA         | NA          |                |
#      | Invalid input | PUT    | /api/v1/loan-tranche-responses/{InvestorInterestID}_/update-by-arranger | NA             | NA        | Update_Draft_Allocation_Request | 400        | Update_Draft_Allocation_Schema_400 | json        | error, Illegal Argument   |
      | Unauthorized | PUT    | /api/v1/loan-tranche-responses/{investorInterestID}/update-by-arranger | InvalidHeaders | NA        | Update_Draft_Allocation_Request | 401        | NA         | text        | Jwt is expired |
#      | Forbidden     | PUT    | /api/v1/loan-tranche-responses/{InvestorInterestID}/update-by-arranger  | InvestorToken  | NA        | Update_Draft_Allocation_Request | 403        | Update_Draft_Allocation_Schema_403 | json        | error,Unauthorized action |
#      | Not Found     | PUT    | /api/v1/loan-tranche-responses/{InvestorInterestID}2/update-by-arranger | NA             | NA        | Update_Draft_Allocation_Request | 404        | Update_Draft_Allocation_Schema_404 | json        | error,Not Found           |

