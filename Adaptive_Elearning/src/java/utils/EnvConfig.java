package utils;

import java.io.InputStream;
import java.util.Properties;

public class EnvConfig {
    private static final Properties props = new Properties();

    static {
        try (InputStream input = EnvConfig.class.getClassLoader().getResourceAsStream("env.properties")) {
            if (input != null) {
                props.load(input);
            } else {
                throw new RuntimeException("env.properties not found");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static String get(String key) {
        return props.getProperty(key);
    }
}
