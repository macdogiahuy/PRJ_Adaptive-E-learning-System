package utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

/**
 * Simple thread-safe properties manager for site-wide settings.
 * Stores values in conf/env.properties by default. Can be overridden with
 * system property 'app.config.path'.
 */
public class SettingsManager {
    private static final String DEFAULT_PATH = "conf/env.properties";
    private final File file;
    private final Properties props = new Properties();

    public SettingsManager() {
        this(getDefaultPath());
    }

    public SettingsManager(String path) {
        this.file = new File(path);
        load();
    }

    public static String getDefaultPath() {
        String p = System.getProperty("app.config.path");
        return p != null && !p.trim().isEmpty() ? p : DEFAULT_PATH;
    }

    public synchronized void load() {
        props.clear();
        if (file.exists() && file.isFile()) {
            try (FileInputStream in = new FileInputStream(file)) {
                props.load(in);
            } catch (IOException e) {
                // fail quietly; callers can handle missing values
            }
        }
    }

    public synchronized Map<String, String> getAll() {
        Map<String, String> m = new LinkedHashMap<>();
        for (String name : props.stringPropertyNames()) {
            m.put(name, props.getProperty(name));
        }
        return m;
    }

    public synchronized String get(String key, String def) {
        return props.getProperty(key, def);
    }

    public synchronized void set(String key, String value) {
        if (value == null) props.remove(key);
        else props.setProperty(key, value);
    }

    public synchronized void putAll(Map<String, String> m) {
        if (m == null) return;
        for (Map.Entry<String, String> e : m.entrySet()) {
            if (e.getValue() == null) props.remove(e.getKey());
            else props.setProperty(e.getKey(), e.getValue());
        }
    }

    public synchronized void save() throws IOException {
        if (!file.getParentFile().exists()) {
            file.getParentFile().mkdirs();
        }
        try (FileOutputStream out = new FileOutputStream(file)) {
            props.store(out, "Site settings updated by SettingsManager");
        }
    }

    /**
     * Basic validation for a few known keys used by the UI. Returns a list of errors.
     */
    public static List<String> validate(Map<String, String> values) {
        List<String> errors = new ArrayList<>();
        if (values == null) return errors;

        String ipp = values.get("itemsPerPage");
        if (ipp != null && !ipp.trim().isEmpty()) {
            try {
                int v = Integer.parseInt(ipp.trim());
                if (v <= 0) errors.add("Items per page must be a positive number.");
            } catch (NumberFormatException ex) {
                errors.add("Items per page must be a number.");
            }
        }

        String allow = values.get("allowRegistration");
        if (allow != null && !("true".equalsIgnoreCase(allow) || "false".equalsIgnoreCase(allow))) {
            errors.add("Allow registration must be true or false.");
        }

        String mm = values.get("maintenanceMode");
        if (mm != null && !("true".equalsIgnoreCase(mm) || "false".equalsIgnoreCase(mm))) {
            errors.add("Maintenance mode must be true or false.");
        }

        return errors;
    }
}
