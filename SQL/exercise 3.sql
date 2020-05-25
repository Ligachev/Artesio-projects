CREATE DATABASE IF NOT EXISTS Employee_Information_System;
USE Employee_Information_System;
CREATE TABLE IF NOT EXISTS employees (
employee_id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
first_name VARCHAR(30) NOT NULL,
last_name VARCHAR(30) NOT NULL
)
ENGINE=InnoDB;

INSERT INTO employees ( first_name, last_name) 
VALUES 
( 'Ivan', 'Akimov'),
( 'Dmitriy', 'Kamenev'),
( 'Anastasiy', 'Sitnikova'),
( 'Veronika', 'Skvortsova'),
( 'Nadezhda', 'Smirnova'),
( 'Nikolay', 'Nakhimov'),
( 'Petr', 'Gudkov');

create table subordinates (
	position_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	parent_id INT NULL,
	`position` varchar(30),
	wage DECIMAL(7,2),
INDEX fk_sub_sub (parent_id),
CONSTRAINT fk_sub_sub FOREIGN KEY (parent_id)
	REFERENCES subordinates (position_id) ON UPDATE CASCADE ON DELETE CASCADE
)
ENGINE=InnoDB;

INSERT INTO subordinates ( position_id, parent_id, position, wage) 
VALUES 
( 1, NULL, 'director', 82562.55),
( 2, 1, 'accountant', 36536.66),
( 3, 2, 'secretary', 24689.51),
( 4, 1, 'engineer', 45488.56),
( 5, 4, 'electrician', 26515.52);

CREATE TABLE `connection` (
    connection_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    employeeID INT UNSIGNED NOT NULL,
    positionID INT NOT NULL,
INDEX employeeID (employeeID),
INDEX positionID (positionID),
CONSTRAINT FK_employee FOREIGN KEY (employeeID)
	REFERENCES employees (employee_id) ON DELETE CASCADE,    
CONSTRAINT FK_position FOREIGN KEY (positionID) 
	REFERENCES subordinates (position_id) ON DELETE CASCADE,
 UNIQUE KEY `relation_row_unique` (employeeID, positionID)
)
ENGINE=InnoDB; 

INSERT INTO `connection` ( employeeID, positionID)
VALUES
(1, 5),
(2, 5),
(3, 2),
(4, 3),
(5, 3),
(6, 4),
(7, 1);

-- Отбор подчиненных сотрудников через соотношение трех запросов. 
-- 1 запрос, Поиск работника по фамилии, прм. Gudkov.
SELECT subordinates.position, last_name as name FROM subordinates 
LEFT JOIN `connection` ON subordinates.position_id = `connection`.positionID 
LEFT JOIN employees ON employees.employee_id = `connection`.employeeID
WHERE `connection`.employeeID = (SELECT employee_id FROM employees WHERE last_name= 'Gudkov');

-- 2 запрос, Выборка всех сотрудников по должностям.
SELECT subordinates.position, wage, 
     GROUP_CONCAT(employees.last_name SEPARATOR ', ') as employee_names FROM subordinates 
LEFT JOIN `connection` ON subordinates.position_id = `connection`.positionID 
LEFT JOIN employees ON employees.employee_id = `connection`.employeeID
GROUP BY subordinates.position_id;

-- 3 запрос, иерархия должностей.
SELECT t1.position AS lvl1, t2.position as lvl2, t3.position as lvl3
FROM subordinates AS t1
LEFT JOIN subordinates AS t2 ON t2.parent_id = t1.position_id
LEFT JOIN subordinates AS t3 ON t3.parent_id = t2.position_id
LEFT JOIN subordinates AS t4 ON t4.parent_id = t3.position_id
WHERE t1.position_id = 1;

-- Отбор подчиненных сотрудников, как первых потомков.
SELECT subordinates.position, 
	GROUP_CONCAT(employees.last_name SEPARATOR ', ') as employee_names FROM subordinates 
LEFT JOIN `connection` ON subordinates.position_id = `connection`.positionID 
LEFT JOIN employees ON employees.employee_id = `connection`.employeeID
WHERE parent_id=1
	GROUP BY subordinates.position_id;
    
-- отбор подчиненных сотрудников, по имени начальника прим. Nakhimov (через костыль)
SELECT subordinates.position, 
	GROUP_CONCAT(employees.last_name SEPARATOR ', ') as employee_names FROM subordinates 
LEFT JOIN `connection` ON subordinates.position_id= `connection`.positionID 
LEFT JOIN employees ON employees.employee_id= `connection`.employeeID
WHERE parent_id= (SELECT parent_id FROM subordinates WHERE position_id=
(SELECT positionID FROM `connection` WHERE employeeID=
(SELECT employee_id FROM employees WHERE last_name='Nakhimov')))+3
group by subordinates.position_id;

DROP DATABASE Employee_Information_System;