# SQL
Базы данных GB

Команды:
```sql
sqlite3            -- запуск sqlite3
.open teachers.db  -- создаем БД
.tables            -- проверяем есть ли таблица
.schema streams    -- посмотреть схему
SELECT * FROM teachers;

.headers on        -- включить заголовки в таблицах
.mode column       -- вид отображения колонки
```
## Практическое задание №1:

№1 Приведите данные по преподавателям к третьей нормальной форме. В качестве отчёта сдайте таблицы с соответствующим содержимым в формате PDF. Рекомендуется выполнить это задание в программе, предназначенной для работы с таблицами — Microsoft Excel, OpenOffice Calc или другой, зависит от вашей рабочей системы. Затем выполните экспорт результата в файл формата PDF. Если такой программы у вас нет, создайте таблицы через сервис Google Docs или в любом текстовом редакторе.
Дополнительные пояснения к данным:
нумерация потоков сквозная;
поток определяет прохождение определенного курса некоторой группой учеников;
следующий курс для группы пойдёт уже другим потоком;
один ученик может закончить несколько курсов (потоков);
один преподаватель может вести разные курсы;
успеваемость учеников — оценка, выставленная преподавателем группе в целом по итогам выполнения проекта, также отражает вовлеченность группы в учебный процесс.
Пример таблички см. страница 15 в методичке.

Создаём ```EXCEL FILE```

№2 Установите программу sqlite3, запустите её, выполните команду .help (точка плюс help). В качестве отчёта сдайте скриншот результата выполнения.
```bash
sudo apt install sqlite3
sqlite3
.help
```

## Практическое задание №2:

№1 Создайте в SQLite базу данных преподавателей и назовите её teachers.db. В этой базе данных сформируйте таблицы преподавателей (teachers), курсов (courses), потоков (streams) и успеваемости (grades) на основе структур, которые представлены ниже. Обратите внимание, что данные вводить пока не надо. Сдайте отчет в виде файла базы данных teachers.db.
```sql
CREATE TABLE teachers (
id INTEGER PRIMARY KEY AUTOINCREMENT,
suname TEXT NOT NULL,
name TEXT NOT NULL,
email TEXT NOT NULL
);

CREATE TABLE courses (
id INTEGER PRIMARY KEY AUTOINCREMENT,
name TEXT NOT NULL UNIQUE
);

CREATE TABLE streams (
id INTEGER PRIMARY KEY AUTOINCREMENT,
course_id INTEGER NOT NULL,
number INTEGER NOT NULL,
start_date TEXT NOT NULL,
students_amount INTEGER NOT NULL,
FOREIGN KEY (course_id) REFERENCES courses(id)
);

CREATE TABLE grades (
stream_id INTEGER NOT NULL,
teacher_id INTEGER NOT NULL,
grade REAL NOT NULL,
PRIMARY KEY(teacher_id, stream_id),
FOREIGN KEY (teacher_id) REFERENCES teachers(id),
FOREIGN KEY (stream_id) REFERENCES streams(id)
);
```

## Практическое задание №3:

№1 В таблице streams переименуйте столбец даты начала обучения в started_at.
```sql
ALTER TABLE streams RENAME COLUMN start_date TO started_at;
```

№2 В таблице streams добавьте столбец даты завершения обучения finished_at.
```sql
ALTER TABLE streams ADD COLUMN finished_at TEXT;
```

№3 Приведите базу данных в полное соответствие с данными в таблицах из методички
```sql
INSERT INTO teachers (name, suname, email) VALUES ("Николай", "Савельев", "saveliev.n@mail.ru");
INSERT INTO teachers (name, suname, email) VALUES ("Наталья", "Петрова", "petrova.n@yandex.ru");
INSERT INTO teachers (name, suname, email) VALUES ("Елена", "Малышева", "malisheva.e@google.com");

INSERT INTO courses (name) VALUES ("Базы данных");
INSERT INTO courses (name) VALUES ("Основы Python");
INSERT INTO courses (name) VALUES ("Linux. Рабочая станция");

INSERT INTO streams (course_id, number, started_at, students_amount) VALUES (3, 165, "18.08.2020", 34);
INSERT INTO streams (course_id, number, started_at, students_amount) VALUES (2, 178, "02.10.2020", 37);
INSERT INTO streams (course_id, number, started_at, students_amount) VALUES (1, 203, "12.11.2020", 35);
INSERT INTO streams (course_id, number, started_at, students_amount) VALUES (1, 210, "03.12.2020", 41);

INSERT INTO grades (stream_id, teacher_id, grade) VALUES (1, 3, 4.7);
INSERT INTO grades (stream_id, teacher_id, grade) VALUES (2, 2, 4.9);
INSERT INTO grades (stream_id, teacher_id, grade) VALUES (3, 1, 4.8);
INSERT INTO grades (stream_id, teacher_id, grade) VALUES (4, 1, 4.9);
```

## Практическое задание №4:
```sql
-- Доп команды:
.headers on   -- включить заголовки в таблицах
.mode column  -- вид отображения колонки
```
№1 Преобразовать дату начала потока в таблице потоков к виду год-месяц-день. Используйте команду UPDATE.
```sql
UPDATE streams SET started_at SUBSTR(started_at, 7, 4) || '-' || SUBSTR(started_at, 4, 2) || '-' || SUBSTR(started_at, 1, 2);
```

№2 Получите идентификатор и номер потока, запланированного на самую позднюю дату.
```sql
SELECT * FROM streams ORDER BY started_at DESC LIMIT 1;
```

№3 Покажите уникальные значения года по датам начала потоков обучения.
```sql
SELECT DISTINCT(SUBSTR(started_at 1, 4)) FROM streams;
```

№4 Найдите количество преподавателей в базе данных. Выведите искомое значение в столбец с именем total_teachers.
```sql
SELECT id, MAX(id) AS 'total_teachers' FROM teachers ORDER BY id DESC;
```

№5 Покажите даты начала двух последних по времени потоков.
```sql
SELECT * FROM streams ORDER BY started_at DESC LIMIT 2;
```

№6 Найдите среднюю успеваемости учеников по потокам преподавателя с идентификатором равным 1.
```sql
SELECT AVG(grade) FROM grades WHERE teacher_id = 1;
```


## Практическое задание №5:

№1 Найдите потоки, количество учеников в которых больше или равно 40. В отчет выведите номер потока, название курса и количество учеников.
```sql
SELECT 'course_name', 'number', 'students_amount' FROM streams;
SELECT 
number,
(SELECT name FROM courses WHERE id = course_id) AS course_name,
students_amount
FROM streams WHERE students_amount >= 40;
```

№2 Найдите два потока с самыми низкими значениями успеваемости. В отчет выведите номер потока, название курса, фамилию и имя преподавателя (одним столбцом), оценку успеваемости.
```sql
SELECT
(SELECT number FROM streams WHERE course_id = stream_id) AS stream,
(SELECT name FROM courses WHERE id = stream_id) AS course,
(SELECT name || surname FROM teachers WHERE id = teacher_id) AS teacher,
performance FROM grades order by performance ASC limit 2;
```

№3 Найдите среднюю успеваемость всех потоков преподавателя Николая Савельева. В отчёт выведите идентификатор преподавателя и среднюю оценку по потокам.
```sql
SELECT 
(SELECT id FROM teachers WHERE surname = 'Савельев' AND name = 'Николай') AS teacher_id,
AVG(performance)
FROM grades
WHERE grades.teacher_id = (SELECT id FROM teachers WHERE surname = 'Савельев' AND name = 'Николай');
```

№4 Найдите потоки преподавателя Натальи Петровой, а также потоки, по которым успеваемость ниже 4.8. В отчёт выведите идентификатор потока, фамилию и имя преподавателя.
```sql
SELECT
stream_id,
(SELECT name FROM teachers WHERE id = teacher_id) AS teacher_name,
(SELECT surname FROM teachers WHERE id = teacher_id) AS teacher_surname
FROM grades WHERE teacher_id = (SELECT id FROM teachers WHERE name = 'Наталья' AND surname = 'Петрова')
UNION all
SELECT
stream_id,
(SELECT name FROM teachers WHERE id = teacher_id) AS teacher_name,
(SELECT surname FROM teachers WHERE id = teacher_id)AS teacher_surname
FROM grades WHERE performance < 4.8;
```

## Практическое задание №6:

№1 Покажите информацию по потокам. В отчет выведите номер потока, название курса и дату начала занятий.
```sql
SELECT * FROM streams;
SELECT * FROM courses;
SELECT stream_number, name, start_date
FROM strams JOIN courses
ON course.id = courses_id;
```

№2 Найдите общее количество учеников для каждого курса. В отчёт выведите название курса и количество учеников по всем потокам курса.
```sql
SELECT * FROM courses;
SELECT * FROM streams;
SELECT name, SUM(students_amount)
FROM courses JOIN streams
ON courses.id = courses_id
GROUP BY name;
```

№3 Для всех учителей найдите среднюю оценку по всем проведённым потокам. В отчёт выведите идентификатор, фамилию и имя учителя, среднюю оценку по всем проведенным потокам. Важно чтобы учителя, у которых не было потоков, также попали в выборку.
```sql
SELECT
teachers.id,
teachers.name,
teachers.surname,
AVG(grades.grade)
FROM grades
LEFT JOIN teachers
ON teachers.id = grades.teacher_id
GROUP BY teacher_id;
```

## Практическое задание №7:

№1 Создайте представление, которое для каждого курса выводит название, номер последнего потока, дату начала обучения последнего потока и среднюю успеваемость курса по всем потокам.
```sql
CREATE VIEW courses_info AS
SELECT
	courses.name
	MAX(streams.stream_number),
	streams.start_date,
	AVG(grades.grade)
FROM courses
	LEFT JOIN streams
		ON courses.id = streams.course_id
	LEFT JOIN grades
		ON streams.id = grades.stream_id
GROUP BY name;

SELECT * FROM courses_info;
```

№2 Удалите из базы данных всю информацию, которая относится к преподавателю с идентификатором, равным 3. Используйте транзакцию.
```sql
SELECT * FROM teachers;
BEGIN TRANSACTION;
	DELETE FROM grades WHERE teacher_id = 3;
	DELETE FROM teachers WHERE id = 3;
COMMIT;

SELECT * FROM teachers;
```

№3 Создайте триггер для таблицы успеваемости, который проверяет значение успеваемости на соответствие диапазону чисел от 0 до 5 включительно.
```sql
CREATE TRIGGER check_grade_format BEFORE INSERT
ON grades
BEGIN
	SELECT CASE
	WHEN
	  (NEW.grade NOT BETWEEN 1 AND 5)
	THEN
	  RAISE(ABORT, 'Grade should be between 1 and 5')
	END;
END;

INSERT INTO grades (stream_id, teacher_id, grade) VALUES (5, 1, 2);
SELECT * FROM grades;
```
