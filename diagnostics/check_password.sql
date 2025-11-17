-- Diagnostics SQL: compare stored hash with SHA-256 of candidate password
-- Replace 'candidatePassword' below with the plain password to test.

-- 1) Show stored password hash for the user
SELECT Id, UserName, Email, Password
FROM Users
WHERE UserName = 'HuynhGiang59' OR Email = 'HuynhGiang59';

-- 2) Compute SHA-256 hex of a candidate password (SQL Server)
SELECT LOWER(CONVERT(varchar(64), HASHBYTES('SHA2_256', 'candidatePassword'), 2)) AS computedHash;

-- 3) Compare candidate password against stored hash in one query
SELECT Id, UserName,
       Password AS storedHash,
       LOWER(CONVERT(varchar(64), HASHBYTES('SHA2_256', 'candidatePassword'), 2)) AS computedHash,
       CASE WHEN LOWER(CONVERT(varchar(64), HASHBYTES('SHA2_256', 'candidatePassword'), 2)) = LOWER(Password)
            THEN 'MATCH' ELSE 'NO MATCH' END AS matchResult
FROM Users
WHERE UserName = 'HuynhGiang59' OR Email = 'HuynhGiang59';

-- How to run:
-- Use SQL Server Management Studio or sqlcmd connected to the same database used by the app.
-- If your DB is different (MySQL/Postgres), let me know and I will provide equivalent queries.