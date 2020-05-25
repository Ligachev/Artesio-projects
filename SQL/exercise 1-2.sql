CREATE DATABASE IF NOT EXISTS employees_information;
USE employees_information;

CREATE TABLE IF NOT EXISTS employees (
employee_id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
first_name VARCHAR(30) NOT NULL,
last_name VARCHAR(30) NOT NULL, 
wage DECIMAL(7,2)
);

INSERT INTO employees ( employee_id, first_name, last_name, wage) VALUES ( null, 'Ivan', 'Akimov', 25699.45);
INSERT INTO employees ( employee_id, first_name, last_name, wage) VALUES ( null, 'Dmitriy', 'Kamenev', 26515.52);
INSERT INTO employees ( employee_id, first_name, last_name, wage) VALUES ( null, 'Anastasiy', 'Sitnikova', 36536.66);
INSERT INTO employees ( employee_id, first_name, last_name, wage) VALUES ( null, 'Nadezhda', 'Smirnova', 24689.51);
INSERT INTO employees ( employee_id, first_name, last_name, wage) VALUES ( null, 'Nikolay', 'Nakhimov', 45488.56);
INSERT INTO employees ( employee_id, first_name, last_name, wage) VALUES ( null, 'Petr', 'Gudkov', 82562.55);

create table subordinates (
position_id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
position varchar(30)
);

INSERT INTO subordinates ( position_id, position) VALUES ( null, 'electrician');
INSERT INTO subordinates ( position_id, position) VALUES ( null, 'accountant');
INSERT INTO subordinates ( position_id, position) VALUES ( null, 'secretary');
INSERT INTO subordinates ( position_id, position) VALUES ( null, 'engineer');
INSERT INTO subordinates ( position_id, position) VALUES ( null, 'director');

ALTER TABLE employees ADD vacancy_id INTEGER NOT NULL;
UPDATE employees SET vacancy_id=1 WHERE employee_id IN (1,2);
UPDATE employees SET vacancy_id=2 WHERE employee_id=3;
UPDATE employees SET vacancy_id=3 WHERE employee_id=4;
UPDATE employees SET vacancy_id=4 WHERE employee_id=5;
UPDATE employees SET vacancy_id=5 WHERE employee_id=6;

SELECT first_name, last_name, wage FROM employees WHERE wage < 30000;

SELECT worker.first_name, worker.last_name, post.position, worker.wage 
FROM employees worker INNER JOIN subordinates post ON worker.vacancy_id=position_id 
WHERE wage < 30000 and position='electrician';

DROP DATABASE employees_information;