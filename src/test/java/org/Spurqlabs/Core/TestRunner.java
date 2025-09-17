package org.Spurqlabs.Core;
import io.cucumber.testng.AbstractTestNGCucumberTests;
import io.cucumber.testng.CucumberOptions;
import io.cucumber.java.Before;
import io.cucumber.java.Scenario;
import org.testng.annotations.AfterSuite;
import org.testng.annotations.BeforeSuite;
import org.testng.annotations.DataProvider;
import org.Spurqlabs.Utils.CustomHtmlReport;
import org.Spurqlabs.Utils.ScenarioResultCollector;
import org.Spurqlabs.Utils.TestContextLogger;

@CucumberOptions(
        features = {"src/test/resources/Features"},
        glue = {"org.Spurqlabs.Steps", "org.Spurqlabs.Core"},
        tags = "@api10",
        plugin = {
            "pretty",
            "json:test-output/Cucumber.json",
            "html:test-output/Cucumber.html",
            "rerun:target/failed_scenarios.txt",
            "com.aventstack.extentreports.cucumber.adapter.ExtentCucumberAdapter:"
        },
        monochrome = true,
        dryRun = false
)

public class TestRunner extends AbstractTestNGCucumberTests {
    
    @BeforeSuite
    public void setup() {
        System.out.println("==========================");
        System.out.println("Test Suite Setup Starting");
        System.out.println("==========================");
    }
    
    @Before(order = 0) // This ensures this runs before other @Before hooks
    public void beforeScenario(Scenario scenario) {
        TestContextLogger.scenarioLogger = scenario;
        System.out.println("Initializing scenario: " + scenario.getName());
    }

    @Override
    @DataProvider(parallel = false)
    public Object[][] scenarios() {
        return super.scenarios();
    }

    @AfterSuite
    public void afterSuite() {
        // Generate custom HTML report after all tests
        System.out.println("==========================");
        System.out.println("Generating Test Reports");
        System.out.println("==========================");
        String reportPath = "test-output/api-custom-report.html";
        CustomHtmlReport.generateHtmlReport(ScenarioResultCollector.getResults(), reportPath);
    }
}
