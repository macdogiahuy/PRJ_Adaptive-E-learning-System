# 🔧 STEP-BY-STEP: Fix "Only 1 Course Shows" Issue

## 📋 CURRENT STATUS
User buys 2 courses but only sees 1 in "My Courses" page.

## 🎯 ROOT CAUSE POSSIBILITIES

### Scenario A: Database has 2, Java shows 1
**Cause**: Java code fails to process one row (exception during row processing)
**Symptom**: Query returns 2 courses, but exception occurs, course is skipped
**Fix**: Enhanced NULL handling + detailed logging

### Scenario B: Database has 1, should have 2
**Cause**: Enrollment not created (Stored Procedure issue)
**Symptom**: Only 1 enrollment exists in database
**Fix**: Check why SP skipped the course (duplicate check)

## 🚀 STEP-BY-STEP FIX PROCESS

### STEP 1: Diagnose (Find Root Cause)

Run master diagnostic:
```cmd
run_master_diagnostic.bat
```

This will:
1. Query database to see what SHOULD appear
2. Check your specific enrollments
3. Guide you to check server logs

**Key Questions**:
- How many courses does database query return?
- How many courses does page show?
- Are they equal?

### STEP 2: Apply NULL Safety Fix

```cmd
rebuild-null-safe.bat
```

This applies comprehensive NULL handling:
- Default values for ALL fields
- Try-catch for each conversion
- Detailed error logging

### STEP 3: Test

#### 3A: Restart Server
```cmd
# Stop current server (Ctrl+C)
run-tomcat10.bat
```

#### 3B: Access My Courses
1. Login as `chauvuonghoang50`
2. Go to `/my-courses`
3. Count how many courses appear

#### 3C: Check Logs
Look for these patterns in Tomcat logs:

```
=== MY COURSES SERVLET START ===
User ID: EB2B2B9B-C74D-4FEE-AFA2-1E5DCBAD943B
Query returned 2 rows              ← Should match enrollment count
Total enrollments in DB: 2

=== Processing row ===
Row data: ID=..., Title=Java Course
✓ Successfully added course: Java Course

=== Processing row ===
Row data: ID=..., Title=How to be Successful...
✓ Successfully added course: How to be Successful...

Successfully processed 2 enrollments  ← Should match query result
```

### STEP 4: If Still Fails

If you see error like:
```
❌ ERROR processing row - THIS COURSE WILL BE SKIPPED!
Row details: Title=Java Course
Full row data: [ID, Title, null, null, null, ...]
<exception stack trace>
```

**This tells us**:
- Which course failed (Java Course)
- Which fields are NULL
- Exact exception

## 🐛 TROUBLESHOOTING SCENARIOS

### Scenario 1: "Query returned 1 rows" but should be 2

**Diagnosis**:
```cmd
run_test_mycourses_query.bat
```

Look at Section 2: "Count enrollments"
- If shows 2 → Query issue (WHERE clause problem)
- If shows 1 → Database issue (enrollment missing)

**Fix**:
If enrollment missing:
```cmd
run_analyze_skip.bat
```
This shows why course was skipped during purchase.

### Scenario 2: "Query returned 2 rows" but page shows 1

**Diagnosis**:
Check logs for "ERROR processing row"

**Common Causes**:
1. **NULL field**: Price, Level, etc. is NULL
   - Already fixed with NULL handling
2. **Type mismatch**: Field type unexpected
   - Try-catch should handle
3. **Setter exception**: Course.setXXX() throws error
   - Check Course model

### Scenario 3: No error in logs, still 1 course

**Diagnosis**:
Log might not be enabled or visible.

**Fix**:
Add console output to verify:
```java
System.out.println("=== MY COURSES DEBUG ===");
System.out.println("Found " + result.size() + " courses");
```

## 📊 EXPECTED VS ACTUAL

### Database (run_test_mycourses_query.bat)
```
Should see:
1. Java Course - ID: 00EF965C-D74E-487B-AB36-55619D89EF37
2. How to be Successful - ID: 670896F5-B0A1-413F-9C77-07E103A131C6
```

### Server Logs
```
Should see:
✓ Successfully added course: Java Course
✓ Successfully added course: How to be Successful
Successfully processed 2 enrollments
```

### My Courses Page
```
Should display:
- Card 1: Java Course
- Card 2: How to be Successful
```

## 🎯 FINAL CHECKLIST

Before declaring "fixed":
- [ ] Database query returns correct count
- [ ] Server logs show "Successfully added" for EACH course
- [ ] No "ERROR processing row" in logs
- [ ] My Courses page displays ALL courses
- [ ] Course cards are clickable and functional

## 📞 STILL BROKEN?

If after all fixes, issue persists:

1. **Capture Evidence**:
   - Screenshot of My Courses page (showing 1 course)
   - Output of `run_test_mycourses_query.bat` (showing database has 2)
   - Server logs excerpt (showing processing attempts)

2. **Check These**:
   ```cmd
   # What does database have?
   run_test_mycourses_query.bat
   
   # What does Java servlet see?
   # Check logs after visiting /my-courses
   
   # Are they consistent?
   ```

3. **Last Resort Debug**:
   Add to MyCoursesServlet, line after `result.add(info);`:
   ```java
   System.out.println("ADDED TO RESULT: " + course.getTitle() + " | Size now: " + result.size());
   ```
   This prints to console EXACTLY when course is added.

---

**Remember**: The fix is already applied. If it still fails, we need to see:
1. Exact database query result (test_mycourses_output.txt)
2. Exact server log excerpt
3. Screenshot of page

This will pinpoint the EXACT failure point.
