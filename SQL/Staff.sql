CREATE DATABASE IF NOT EXISTS staff;
USE staff;
CREATE TABLE IF NOT EXISTS employees (
employee_id INT NOT NULL AUTO_INCREMENT primary key,
first_name VARCHAR(30) NOT NULL,
last_name VARCHAR(30) NOT NULL
);
INSERT INTO employees (first_name, last_name)
VALUES 
('Artem', 'Martynov'),
('Maksim', 'Funtikov'),
('Oksana', 'Mamaeva'),
('Anastasiya', 'Kozlova'),
('Irina', 'Smolina'),
('Nadezhda', 'Vasileva'),
('Petr', 'Baranov');

CREATE TABLE IF NOT EXISTS positions (
position_id INT NOT NULL primary key,
parent_id INT,
position VARCHAR(30) NOT NULL,
payment INT NOT NULL
);

INSERT INTO positions (position_id, position, parent_id, payment)
VALUES 
(1, 'SeniorManager', 0, 80000),
(2, 'ProjectManager', 1, 60000),
(3, 'TeamLead', 1, 50000),
(4, 'Tester', 3, 25000),
(5, 'Programmer', 3, 29000);

ALTER TABLE employees ADD position_id INTEGER NOT NULL;
UPDATE employees SET position_id=1 WHERE employee_id IN(1);
UPDATE employees SET position_id=2 WHERE employee_id IN(2);
UPDATE employees SET position_id=3 WHERE employee_id IN(3);
UPDATE employees SET position_id=4 WHERE employee_id IN(4,5);
UPDATE employees SET position_id=5 WHERE employee_id IN(6,7);

/* Выбираем всех сотрудников с зарплатой < 30000 */
SELECT employee.first_name, employee.last_name, position.position, position.payment
FROM employees employee
INNER JOIN positions position ON employee.position_id=position.position_id
WHERE position.payment < 30000;

/* Выбираем программистов с зарплатой < 30000 */
SELECT employee.first_name, employee.last_name, position.position, position.payment
FROM employees employee
INNER JOIN positions position ON employee.position_id=position.position_id
WHERE position.payment < 30000 AND position.position='Programmer';

CREATE TABLE IF NOT EXISTS link (
link_id INT NOT NULL AUTO_INCREMENT primary key,
employee_id INT NOT NULL,
position_id INT NOT NULL,
FOREIGN KEY (employee_id) REFERENCES employees (employee_id) 
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (position_id) REFERENCES positions (position_id) 
ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO link (employee_id, position_id)
VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 4),
(6, 5),
(7, 5);

/* Выводим все должности и сотрудников, которые им соответствуют */
SELECT positions.position, payment,
group_concat(employees.last_name separator ',') as employees_names
from positions
left join link on positions.position_id=link.position_id
left join employees on employees.employee_id=link.employee_id
group by positions.position_id;

/* Выбираем подчиненных первого уровня по родительскому ID */ 
SELECT positions.position, group_concat(employees.last_name separator ',') as employees_names
FROM positions  
left join link on positions.position_id=link.position_id
left join employees on employees.employee_id=link.employee_id
WHERE parent_id=1
group by positions.position_id;

/* Выбираем подчиненных первого уровня по фамилии директора Martynov */ 
SELECT positions.position, group_concat(employees.last_name separator ',') as employees_names
FROM positions  
left join link on positions.position_id=link.position_id
left join employees on employees.employee_id=link.employee_id
WHERE parent_id=(SELECT parent_id FROM positions WHERE position_id=(SELECT position_id FROM link WHERE employee_id=(SELECT employee_id FROM employees WHERE last_name='Martynov')))+1
group by positions.position_id;

/* Выбираем подчиненных первого уровня по фамилии Тимлида Mamaeva */ 
SELECT positions.position, group_concat(employees.last_name separator ',') as employees_names
FROM positions  
left join link on positions.position_id=link.position_id
left join employees on employees.employee_id=link.employee_id
WHERE parent_id=(SELECT parent_id FROM positions WHERE position_id=(SELECT position_id FROM link WHERE employee_id=(SELECT employee_id FROM employees WHERE last_name='Mamaeva')))+2
group by positions.position_id;



