package org.Spurqlabs.Core;

import io.cucumber.java.Scenario;

import java.util.Dictionary;
import java.util.Hashtable;

public class TestContext {
    public static Scenario scenarioLogger;
    public static String scenarioName;
    public static Dictionary<String, String> stringContext = new Hashtable<>();
}
