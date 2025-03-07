#!/bin/bash

PGUSER="tremend"
DUMP_FILE="dump.sql"
LOG_FILE="db_query_results.log"
NEW_ADMIN_USER="ps_cee"
NEW_ADMIN_PASSWORD="ps_cee_password"
TARGET_DB="company_db"

echo "Creating database '$TARGET_DB'..."
psql -U "$PGUSER"-d postgres -c "DROP DATABASE IF EXISTS $TARGET_DB; CREATE DATABASE $TARGET_DB;"

echo "Creating admin role '$NEW_ADMIN_USER'..."
psql -U "$PGUSER" -d postgres -c "DROP ROLE IF EXISTS $NEW_ADMIN_USER; CREATE ROLE $NEW_ADMIN_USER WITH LOGIN SUPERUSER PASSWORD '$NEW_ADMIN_PASSWORD';"

echo "Importing dataset from '$DUMP_FILE' into '$TARGET_DB'..."
psql -U "$PGUSER" -d "$TARGET_DB" -f "$DUMP_FILE"

read -p "Enter department name for Query 2: " dept

echo "Query 1: Total number of employees:" >> "$LOG_FILE"
psql -U "$PGUSER" -d "$TARGET_DB" -c "SELECT COUNT(*) FROM employees;" >> "$LOG_FILE"

echo "Query 2: Employees in department '$dept':" >> "$LOG_FILE"
psql -U "$PGUSER" -d "$TARGET_DB" -c "SELECT first_name, last_name FROM employees e WHERE e.department_id = (SELECT department_id FROM departments WHERE department_name = :'dept');" >> "$LOG_FILE"

echo "Query 3: Highest and lowest salaries per department:" >> "$LOG_FILE"
psql -U "$PGUSER" -d "$TARGET_DB" -c "SELECT d.department_name, MAX(s.salary), MIN(s.salary) FROM departments d JOIN employees e ON d.department_id = e.department_id JOIN salaries s ON e.employee_id = s.employee_id GROUP BY d.department_name;" >> "$LOG_FILE"

echo "All operations completed. Query results are stored in $LOG_FILE"
