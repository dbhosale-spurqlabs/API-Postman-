Feature: Upload Invitation Letter API Validation

  @api
  Scenario Outline: Validate POST Upload Invitation Letter for "<scenarioName>" scenario
    When User uploads file using "<method>" request to "<url>" with headers "<headers>" and file "<filePath>" and fileName "<fileName>"
    Then User verifies the response status code is <statusCode>
    And User verifies fields in response: "<contentType>" with content type "<fields>"

    Examples:
      | scenarioName        | method | url               | headers        | filePath              | fileName              | statusCode | contentType | fields               |
      | Valid PDF Upload    | POST   | /api/v1/documents | NA             | Invitation_Letter.pdf | Invitation_Letter.pdf | 200        | json        | type,application/pdf |
#      | Invalid File Type   | POST   | /api/v1/documents | NA             | Invitation_Letter.txt | Invitation_Letter.txt | 400        | json        | type, error          |
      | Unauthorized Access | POST   | /api/v1/documents | InvalidHeaders | Invitation_Letter.pdf | Invitation_Letter.pdf | 401        | text        | Jwt is expired       |
#      | Forbidden Access    | POST   | /api/v1/documents | InvestorToken  | Invitation_Letter.pdf | Invitation_Letter.pdf | 403        | json        | error,Forbidden |