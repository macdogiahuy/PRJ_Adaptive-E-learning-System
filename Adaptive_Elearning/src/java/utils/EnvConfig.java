package utils;

import java.io.InputStream;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

public class EnvConfig {
    private static final Logger LOGGER = Logger.getLogger(EnvConfig.class.getName());
    private static final Properties props = new Properties();

    static {
        try (InputStream input = EnvConfig.class.getClassLoader().getResourceAsStream("env.properties")) {
            if (input != null) {
                props.load(input);
                LOGGER.info("✅ Environment configuration loaded successfully");
            } else {
                LOGGER.severe(
                        "❌ env.properties not found in classpath. Please create src/conf/env.properties from env.properties.example");
                throw new RuntimeException(
                        "env.properties not found. Copy env.properties.example to env.properties and configure your database settings.");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "❌ Failed to load environment configuration", e);
            throw new RuntimeException("Failed to load environment configuration", e);
        }
    }

    public static String get(String key) {
        String value = props.getProperty(key);
        if (value == null) {
            LOGGER.warning("⚠️ Environment variable not found: " + key);
        }
        return value;
    }

    public static String get(String key, String defaultValue) {
        String value = props.getProperty(key, defaultValue);
        if (props.getProperty(key) == null) {
            LOGGER.info("🔧 Using default value for: " + key);
        }
        return value;
    }
}
