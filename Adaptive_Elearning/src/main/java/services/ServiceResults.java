package services;

import java.util.ArrayList;
import java.util.List;

/**
 * Combined service result classes for admin operations
 */
public class ServiceResults {

    /**
     * Result object for admin creation operations
     */
    public static class AdminCreationResult {
        private boolean success;
        private String message;
        private String errorCode;
        private String adminId;
        
        public AdminCreationResult(boolean success, String message) {
            this.success = success;
            this.message = message;
        }
        
        public AdminCreationResult(boolean success, String message, String errorCode) {
            this.success = success;
            this.message = message;
            this.errorCode = errorCode;
            this.adminId = null;
        }
        
        // Constructor for success with adminId  
        public static AdminCreationResult withAdminId(boolean success, String message, String adminId) {
            AdminCreationResult result = new AdminCreationResult(success, message);
            result.adminId = adminId;
            return result;
        }
        
        // Getters and Setters
        public boolean isSuccess() {
            return success;
        }
        
        public void setSuccess(boolean success) {
            this.success = success;
        }
        
        public String getMessage() {
            return message;
        }
        
        public void setMessage(String message) {
            this.message = message;
        }
        
        public String getErrorCode() {
            return errorCode;
        }
        
        public void setErrorCode(String errorCode) {
            this.errorCode = errorCode;
        }
        
        public String getAdminId() {
            return adminId;
        }
        
        public void setAdminId(String adminId) {
            this.adminId = adminId;
        }
        
        // Static factory methods for common results
        public static AdminCreationResult success(String message, String adminId) {
            return AdminCreationResult.withAdminId(true, message, adminId);
        }
        
        public static AdminCreationResult failure(String message, String errorCode) {
            return new AdminCreationResult(false, message, errorCode);
        }
        
        public static AdminCreationResult userExists() {
            return new AdminCreationResult(false, "Username or email already exists", "USER_EXISTS");
        }
        
        public static AdminCreationResult validationError(String message) {
            return new AdminCreationResult(false, message, "VALIDATION_ERROR");
        }
    }

    /**
     * Result object for validation operations
     */
    public static class ValidationResult {
        private boolean valid;
        private List<String> errors;
        private List<String> warnings;
        
        public ValidationResult() {
            this.valid = true;
            this.errors = new ArrayList<>();
            this.warnings = new ArrayList<>();
        }
        
        public ValidationResult(boolean valid) {
            this();
            this.valid = valid;
        }
        
        // Getters and Setters
        public boolean isValid() {
            return valid && errors.isEmpty();
        }
        
        public void setValid(boolean valid) {
            this.valid = valid;
        }
        
        public List<String> getErrors() {
            return errors;
        }
        
        public void setErrors(List<String> errors) {
            this.errors = errors;
        }
        
        public List<String> getWarnings() {
            return warnings;
        }
        
        public void setWarnings(List<String> warnings) {
            this.warnings = warnings;
        }
        
        // Utility methods
        public void addError(String error) {
            this.errors.add(error);
            this.valid = false;
        }
        
        public void addWarning(String warning) {
            this.warnings.add(warning);
        }
        
        public boolean hasErrors() {
            return !errors.isEmpty();
        }
        
        public boolean hasWarnings() {
            return !warnings.isEmpty();
        }
        
        public String getErrorsAsString() {
            return String.join("; ", errors);
        }
        
        public String getWarningsAsString() {
            return String.join("; ", warnings);
        }
        
        // Static factory methods  
        public static ValidationResult valid() {
            return new ValidationResult(true);
        }
        
        public static ValidationResult invalid(String error) {
            ValidationResult result = new ValidationResult(false);
            result.addError(error);
            return result;
        }
    }
    
    /**
     * Generic result object for service operations
     */
    public static class OperationResult<T> {
        private boolean success;
        private String message;
        private T data;
        private String errorCode;
        
        public OperationResult(boolean success, String message, T data) {
            this.success = success;
            this.message = message;
            this.data = data;
        }
        
        public OperationResult(boolean success, String message, T data, String errorCode) {
            this.success = success;
            this.message = message;
            this.data = data;
            this.errorCode = errorCode;
        }
        
        // Getters
        public boolean isSuccess() {
            return success;
        }
        
        public String getMessage() {
            return message;
        }
        
        public T getData() {
            return data;
        }
        
        public String getErrorCode() {
            return errorCode;
        }
        
        // Static factory methods
        public static <T> OperationResult<T> success(String message, T data) {
            return new OperationResult<>(true, message, data);
        }
        
        public static <T> OperationResult<T> failure(String message) {
            return new OperationResult<>(false, message, null);
        }
        
        public static <T> OperationResult<T> failure(String message, String errorCode) {
            return new OperationResult<>(false, message, null, errorCode);
        }
    }
    
    // Convenience methods at class level
    public static <T> OperationResult<T> success(String message, T data) {
        return OperationResult.success(message, data);
    }
    
    public static <T> OperationResult<T> failure(String message) {
        return OperationResult.failure(message);
    }
}