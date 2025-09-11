# SpurQLabs API Test Automation Framework

A robust, scalable, and maintainable test automation framework for API testing using Java, Playwright, Cucumber, TestNG, and Rest-Assured.

## Features
- **UI Automation:** Powered by Playwright for fast and reliable browser automation.
- **API Testing:** Uses Rest-Assured for comprehensive API validation.
- **BDD Support:** Cucumber for writing human-readable feature files.
- **TestNG Integration:** Flexible test execution and reporting.
- **Token Management:** Automated browser-based authentication and token handling.
- **Configurable:** Centralized configuration via `FrameworkConfig.json`.
- **Logging & Reporting:** Built-in logging and HTML/JSON Cucumber reports.

## Project Structure
```
LB_API/
├── FrameworkConfig.json          # Central configuration file
├── pom.xml                       # Maven project file
├── README.md                     # Project documentation
├── src/
│   └── test/
│       ├── java/
│       │   └── org/Spurqlabs/
│       │       ├── Core/         # Test runner and hooks
│       │       ├── Steps/        # Step definitions for Cucumber
│       │       └── Utils/        # Utilities (API, config, token, logging)
│       └── resources/
│           ├── Features/         # Cucumber feature files
│           ├── Query_Parameters/ # API query parameter JSONs
│           ├── Request_Bodies/   # API request body JSONs
│           └── Schema/           # JSON schema files for validation
└── test-output/                  # Test reports (generated)
```

## Getting Started

### Prerequisites
- Java 11+
- Maven 3.6+
- Chrome/Chromium browser (for Playwright)

### Setup
1. **Clone the repository:**
   ```sh
   git clone https://sumitkunjir@bitbucket.org/loan-trading-platfrom/loanbook-api-automation.git
   cd LB_API_Automation_Suite
   ```
2. **Install dependencies:**
   ```sh
   mvn clean install
   ```
3. **Configure environment:**
   - Update `FrameworkConfig.json` with your environment, credentials, and endpoints.

### Running Tests
- **All tests:**
  ```sh
  mvn test
  ```
- **Specific feature/scenario:**
  Use tags or specify features in the runner or via Maven command line.

### Reports
- After execution, reports are available in `test-output/` as HTML and JSON (Cucumber format).

## Key Files
- `pom.xml` - Maven dependencies and plugins
- `FrameworkConfig.json` - Centralized config (URLs, credentials, etc.)
- `TestRunner.java` - Main entry point for running tests
- `TokenManager.java` - Handles authentication and token management
- `APIUtility.java` - Utility for API requests
- `Features/` - Cucumber feature files

## Best Practices
- Keep credentials and sensitive data secure (consider using environment variables or encryption).
- Organize step definitions and utilities for reusability.
- Use tags in feature files for selective test execution.
- Review and update dependencies regularly.

## Contributing
1. Fork the repository
2. Create your feature branch (`git checkout -b feature/YourFeature`)
3. Commit your changes
4. Push to the branch
5. Open a pull request

## License
This project is for internal use at SpurQLabs. Contact the maintainer for licensing details.

