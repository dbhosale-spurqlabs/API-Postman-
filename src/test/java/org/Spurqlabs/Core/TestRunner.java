package org.Spurqlabs.Core;
import io.cucumber.testng.AbstractTestNGCucumberTests;
import io.cucumber.testng.CucumberOptions;
import org.testng.annotations.AfterSuite;
import org.testng.annotations.BeforeSuite;
import org.testng.annotations.DataProvider;
import org.Spurqlabs.Utils.CustomHtmlReport;
import org.Spurqlabs.Utils.ScenarioResultCollector;

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

    @Override
    @DataProvider(parallel = false)
    public Object[][] scenarios() {
        return super.scenarios();
    }
    @BeforeSuite
    public void BeforeSuite() {
    }
    @AfterSuite
    public void AfterSuite() {
        // Generate custom HTML report after all tests
        String reportPath = "test-output/api-custom-report.html";
        CustomHtmlReport.generateHtmlReport(ScenarioResultCollector.getResults(), reportPath);
    }
}
