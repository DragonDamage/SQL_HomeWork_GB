SELECT * FROM teachers;
BEGIN TRANSACTION;
	DELETE FROM grades WHERE teacher_id = 3;
	DELETE FROM teachers WHERE id = 3;
COMMIT;

SELECT * FROM teachers;
