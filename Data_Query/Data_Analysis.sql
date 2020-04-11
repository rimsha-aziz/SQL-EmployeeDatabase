-- PART 1: DATA ENGINEERING 
--Drop any existing tables 
DROP TABLE Employees;
DROP TABLE Departments;
DROP TABLE Department_employees;
DROP TABLE Department_manager;
DROP TABLE Salaries;
DROP TABLE  Titles;

-- Create tables 
CREATE TABLE Employees (
    emp_no INT PRIMARY KEY NOT NULL,
    birth_date DATE   NOT NULL,
    first_name VARCHAR   NOT NULL,
    last_name VARCHAR   NOT NULL,
    gender VARCHAR   NOT NULL,
    hire_date DATE   NOT NULL);
SELECT * FROM Employees;

CREATE TABLE Departments (
    dept_no VARCHAR PRIMARY KEY NOT NULL,
    dept_name VARCHAR   NOT NULL);
SELECT * FROM Departments; 

CREATE TABLE Department_employees (
    emp_no INT   NOT NULL,
	dept_no VARCHAR  NOT NULL,
    from_date DATE   NOT NULL,
    to_date DATE   NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES Employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES Departments(dept_no));
SELECT * FROM Department_employees;

CREATE TABLE Department_manager (
    dept_no VARCHAR   NOT NULL,
    emp_no INT   NOT NULL,
    from_date DATE  NOT NULL,
    to_date DATE   NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES Employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES Departments(dept_no));
SELECT * FROM Department_manager;

CREATE TABLE Salaries (
    emp_no INT   NOT NULL,
	salary INT  NOT NULL,
    from_date DATE   NOT NULL,
    to_date DATE   NOT NULL,    
	FOREIGN KEY (emp_no) REFERENCES Employees(emp_no));
SELECT * FROM Salaries;

CREATE TABLE Titles (
	emp_no INT   NOT NULL,
    title VARCHAR   NOT NULL,
    from_date DATE   NOT NULL,
    to_date DATE   NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES Employees(emp_no));
SELECT * FROM Titles;

--PART 2: DATA ANALYSIS
-- 1. List the following details of each employee: employee number, last name, first name, gender, and salary.
SELECT e.emp_no AS "Employee Number", e.last_name AS "Last Name",e.first_name AS "First Name",e.gender AS "Gender",s.salary AS "Salary"
FROM Employees e
LEFT JOIN Salaries s ON e.emp_no = s.emp_no
ORDER BY e.emp_no;

-- 2. List employees who were hired in 1986.
SELECT * FROM employees
WHERE hire_date BETWEEN '1986-01-01' AND '1986-12-31'
ORDER BY hire_date;

--3. List the manager of each department with the following information: department number, 
--department name,the manager's employee number, last name, first name, and start and end employment dates.

SELECT dm.dept_no AS "Department Number", d.dept_name AS "Department Name", dm.emp_no AS "Manager Employee Number",
e.last_name AS "Last Name", e.first_name AS "First Name",dm.from_date AS "Start Date", dm.to_date AS "End Date"
FROM Department_manager dm
LEFT JOIN Departments d ON dm.dept_no = d.dept_no
LEFT JOIN Employees e ON dm.emp_no = e.emp_no;
		
--4. List the department of each employee with the following information: employee number, last name, first name, and department name.
SELECT e.emp_no AS "Employee Number", e.last_name AS "Last Name", 
e.first_name AS "First Name",d.dept_name AS "Department Name"
FROM Employees e
INNER JOIN Department_manager dm ON e.emp_no = dm.emp_no
INNER JOIN Departments d ON dm.dept_no = d.dept_no
ORDER BY e.emp_no;

-- 5. List all employees whose first name is "Hercules" and last names begin with "B."
SELECT * FROM employees
WHERE first_name = 'Hercules' AND last_name like 'B%';

--6. List all employees in the Sales department, including their employee number, last name, first name, and department name.
SELECT de.emp_no AS "Employee Number",e.last_name AS "Last Name",e.first_name AS "First Name",d.dept_name AS "Department Name"
FROM Department_employees de 
INNER JOIN Employees e ON de.emp_no=e.emp_no 
INNER JOIN Departments d ON de.dept_no=d.dept_no 
AND d.dept_name='Sales'
ORDER BY de.emp_no;

--7. List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT de.emp_no AS "Employee Number",e.last_name AS "Last Name",e.first_name AS "First Name",d.dept_name AS "Department Name"
FROM Department_employees de 
INNER JOIN employees e ON de.emp_no=e.emp_no 
INNER JOIN departments d ON de.dept_no=d.dept_no 
WHERE dept_name = 'Sales' OR dept_name = 'Development'
ORDER BY de.emp_no;

-- 8. In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
SELECT last_name AS "Employee Last Name", count(last_name) AS "Count"
FROM Employees e
GROUP BY last_name
ORDER BY "Count" DESC;