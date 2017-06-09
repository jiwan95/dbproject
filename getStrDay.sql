CREATE OR REPLACE FUNCTION getStrDay (
	course_day VARCHAR
)
RETURN VARCHAR
IS
	modified_course_day VARCHAR(10);	
BEGIN
	SELECT REPLACE(course_day, '0', '일')
	INTO modified_course_day
	FROM DUAL;

	SELECT REPLACE(modified_course_day, '1', '월')
	INTO modified_course_day
	FROM DUAL;

	SELECT REPLACE(modified_course_day, '2', '화')
	INTO modified_course_day
	FROM DUAL;

	SELECT REPLACE(modified_course_day, '3', '수')
	INTO modified_course_day
	FROM DUAL;

	SELECT REPLACE(modified_course_day, '4', '목')
	INTO modified_course_day
	FROM DUAL;

	SELECT REPLACE(modified_course_day, '5', '금')
	INTO modified_course_day
	FROM DUAL;

	SELECT REPLACE(modified_course_day, '6', '토')
	INTO modified_course_day
	FROM DUAL;
	COMMIT;
RETURN modified_course_day;
END;
/