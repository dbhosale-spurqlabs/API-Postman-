package org.Spurqlabs.Utils;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Map;

public class JsonFileReader {

    public static Map<String, String> getHeadersFromJson(String filePath) throws IOException {
        String jsonContent = new String(Files.readAllBytes(Paths.get(filePath)));
        return new Gson().fromJson(jsonContent, new TypeToken<Map<String, String>>() {
        }.getType());
    }

    public static String getJsonAsString(String filePath) throws IOException {
        return new String(Files.readAllBytes(Paths.get(filePath)));
    }

    public static Map<String, String> getQueryParamsFromJson(String filePath) throws IOException {
        if (filePath == null || filePath.trim().isEmpty()) {
            return null;
        }

        // Read the content of the file
        String content = new String(Files.readAllBytes(Paths.get(filePath))).trim();
        Map<String, String> params = new java.util.HashMap<>();

        try {
            // First try to parse as JSON
            if (content.startsWith("{")) {
                return new Gson().fromJson(content, new TypeToken<Map<String, String>>() {}.getType());
            }
        } catch (Exception e) {
            // If JSON parsing fails, continue to try as query string
        }

        // Parse as query string (key=value pairs)
        if (!content.isEmpty()) {
            for (String pair : content.split("&")) {
                String[] keyValue = pair.split("=", 2);
                if (keyValue.length == 2) {
                    params.put(keyValue[0].trim(), keyValue[1].trim());
                }
            }
        }

        return params;
    }

    // Helper to get value from nested JSON using dot/bracket notation
    public static Object getJsonValueByPath(JSONObject json, String path) {
        String[] parts = path.split("\\.");
        Object current = json;
        for (String part : parts) {
            if (current == null) return null;
            if (part.contains("[")) {
                String key = part.substring(0, part.indexOf("["));
                int idx = Integer.parseInt(part.substring(part.indexOf("[") + 1, part.indexOf("]")));
                if (current instanceof JSONObject) {
                    Object arrObj = ((JSONObject) current).opt(key);
                    if (arrObj instanceof JSONArray) {
                        current = ((JSONArray) arrObj).opt(idx);
                    } else {
                        return null;
                    }
                } else {
                    return null;
                }
            } else {
                if (current instanceof JSONObject) {
                    current = ((JSONObject) current).opt(part);
                } else {
                    return null;
                }
            }
        }
        return current;
    }
}
