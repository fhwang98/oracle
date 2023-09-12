/*
	함수 return
	
	1. 단일값O
	2. 단일값 X > cursor
	
	프로시저 out parameter
	1. 단일값(단일 레코드)
		a. number
		b. varchar2
		c. date
		
	2. 다중값(다중 레코드)
		a. cursor

*/
CREATE OR REPLACE PROCEDURE procbuseo (
	pbuseo varchar2
)
IS
	CURSOR vcursor -- cursor : 커서를 선언하는 키워드, 자료형이 아님
	IS 
	SELECT * FROM tblinsa WHERE buseo = pbuseo;
	
	vrow tblinsa%rowtype;
BEGIN
	OPEN vcursor;
	LOOP
		FETCH vcursor INTO vrow; -- SELECT INTO의 반복버전
		EXIT WHEN vcursor%notfound; 
		
		dbms_output.put_line(vrow.name || ',' || vrow.buseo);
	END LOOP;
	CLOSE vcursor;
END procbuseo;


BEGIN
	procbuseo('영업부');
END;


-- 커서를 반환하는 프로시저 구문
CREATE OR REPLACE PROCEDURE procbuseo (
	pbuseo IN varchar2,
	pcursor OUT sys_refcursor -- 커서의 자료형
)
IS
	-- cursor vcursor is select ... 내부에서 소비할때만..
BEGIN
	
	OPEN pcursor
	FOR
	SELECT * FROM tblinsa WHERE buseo = pbuseo;
	
END procbuseo;


DECLARE
	vcursor sys_refcursor; -- 커서 참조 변수
	vrow tblinsa%rowtype;
BEGIN
	procbuseo('영업부', vcursor);
	LOOP
		FETCH vcursor INTO vrow;
		EXIT WHEN vcursor%notfound;
		dbms_output.put_line(vrow.name);
	END LOOP;
END;


-- 프로시저 총정리 > CRUD

-- 1. 추가 작업(C)
CREATE OR REPLACE PROCEDURE 추가작업 (
	추가할 데이터 -> IN 매개변수,
	추가할 데이터 -> IN 매개변수,
	추가할 데이터 -> IN 매개변수, -- 원하는 만큼
	성공 유무 반환 -> OUT 매개변수 -- 피드백(성공1, 실패0)
)
IS
	내부 변수 선언
BEGIN
	작업(INSERT + (SELECT, UPDATE, DELETE))
EXCEPTION
	WHEN OTHERS THEN
		예외처리
END;

SELECT * FROM tbltodo; --24
CREATE SEQUENCE seqtodo START WITH 25;
DROP SEQUENCE seqtodo;
-- 할일 추가하기(C) 프로시저
CREATE OR REPLACE PROCEDURE procaddtodo (
	ptitle IN varchar2,
	presult OUT NUMBER -- 1 OR 0
)
IS
BEGIN
	
	INSERT INTO tbltodo (seq, title, adddate, completedate) VALUES (seqtodo.nextval, ptitle, sysdate, null);
	
	presult := 1; -- 성공
	
EXCEPTION
	WHEN OTHERS THEN
		presult := 0; -- 실패
END procaddtodo;



DECLARE
	vresult NUMBER;
BEGIN
	procaddtodo('새로운 할일입니다.',vresult);
	dbms_output.put_line(vresult);
END;


--2. 수정 작업(U)
CREATE OR REPLACE PROCEDURE 수정작업 (
	수정할 데이터 -> IN 매개변수,
	수정할 데이터 -> IN 매개변수,
	수정할 데이터 -> IN 매개변수, -- 원하는 개수
	수정할 데이터의 식별자 -> IN 매개변수, -- where절에 사용할 PK OR 데이터
	성공 유무 반환 -> OUT 매개변수 -- 피드백(성공1, 실패0)
)
IS
	내부 변수 선언
BEGIN
	작업(UPDATE + (INSERT, UPDATE, DELETE, SELECT...))
EXCEPTION
	WHEN OTHERS THEN
		예외처리
	
END;


-- 할일 수정하기(U) > complete > 채우기 > 할일 완료 처리하기
CREATE OR REPLACE PROCEDURE proccompletetodo (
	--pcompletedate DATE > 수정할 날짜 > 지금 > sysdate처리
	pseq IN NUMBER, -- 수정할 할일 번호
	presult OUT number
)
IS
BEGIN
	UPDATE tbltodo SET completedate = sysdate WHERE seq = pseq;
	presult := 1;
EXCEPTION
	WHEN OTHERS THEN
		presult := 0;
END proccompletetodo;

DECLARE
	vresult NUMBER;
BEGIN
	proccompletetodo(25, vresult);
	dbms_output.put_line(vresult);
END;




-- 3. 삭제작업(D)
CREATE OR REPLACE PROCEDURE 삭제작업 (
	식별자 -> IN 매개변수,
	성공 유무 반환 -> OUT 매개변수 -- 피드백(성공1, 실패0)
)
IS
	내부 변수 선언
BEGIN
	작업(DELETE + (INSERT, UPDATE, DELETE, SELECT))
EXCEPTION
	WHEN OTHERS THEN
		예외처리
END;

-- 할일 삭제하기
CREATE OR REPLACE PROCEDURE procdeletetodo (
	pseq IN NUMBER,
	presult OUT NUMBER
)
IS
BEGIN
	DELETE FROM tbltodo WHERE seq = pseq;
	presult := 1;
EXCEPTION
	WHEN OTHERS THEN
		presult := 0;
END procdeletetodo;

DECLARE
	vresult NUMBER;
BEGIN
	procdeletetodo(25, vresult);
	dbms_output.put_line(vresult);
END;


ROLLBACK;
SELECT * FROM tbltodo;

-- 4. 읽기 작업(R)
-- 조건 유/무
-- 반환 단일행/다중행, 단일컬럼/다중컬럼

CREATE OR REPLACE PROCEDURE 읽기작업 (
	조건 데이터 -> IN 매개변수,
	단일 반환값 -> OUT 매개변수,
	다중 반환값 -> OUT 매개변수(커서)
)
IS
	내부 변수 선언;
BEGIN
	작업(SELECT + (INSERT, UPDATE, DELETE, SELECT))
EXCEPTION
	WHEN OTHERS THEN
		예외처리;
END;


-- 한일 몇개? 안한일 몇개? 총 몇개?
CREATE OR REPLACE PROCEDURE proccounttodo (
	pcount1 OUT NUMBER, --한일
	pcount2 OUT NUMBER, --안한일
	pcount3 OUT NUMBER --모든일
)
IS
BEGIN
	SELECT count(*) INTO pcount1 FROM tbltodo WHERE completedate IS NOT NULL;
	SELECT count(*) INTO pcount2 FROM tbltodo WHERE completedate IS NULL;
	SELECT count(*) INTO pcount3 FROM tbltodo;
EXCEPTION
	WHEN OTHERS THEN
		dbms_output.put_line('예외처리');
END proccounttodo;


DECLARE
	vcount1 NUMBER;
	vcount2 NUMBER;
	vcount3 NUMBER;
BEGIN
	proccounttodo(vcount1, vcount2, vcount3);
	dbms_output.put_line(vcount1);
	dbms_output.put_line(vcount2);
	dbms_output.put_line(vcount3);
END;


CREATE OR REPLACE PROCEDURE proccounttodo (
	psel IN NUMBER, -- 선택 : 1(한일), 2(안한일), 3(모든일)
	pcount OUT NUMBER
)
IS
BEGIN
	IF psel = 1 THEN
		SELECT count(*) INTO pcount FROM tbltodo WHERE completedate IS NOT NULL;
	ELSIF psel = 2 THEN
		SELECT count(*) INTO pcount FROM tbltodo WHERE completedate IS NULL;
	ELSIF psel = 3 THEN
		SELECT count(*) INTO pcount FROM tbltodo;
	END IF;
EXCEPTION
	WHEN OTHERS THEN
		dbms_output.put_line('예외처리');
END proccounttodo;


DECLARE
	vcount NUMBER;
BEGIN
	proccounttodo(3, vcount);
	dbms_output.put_line(vcount);
END;

-- 번호 > 할일 1개 반환
CREATE OR REPLACE PROCEDURE procgettodo (
	pseq IN NUMBER,
	prow OUT tbltodo%rowtype
)
IS
BEGIN
	SELECT * INTO prow FROM tbltodo WHERE seq = pseq;
EXCEPTION
	WHEN OTHERS THEN
		dbms_output.put_line('예외처리');
END procgettodo;

DECLARE
	vrow tbltodo%rowtype;
BEGIN
	procgettodo(1,vrow);
	dbms_output.put_line(vrow.title);
END;





-- 다중 레코드 반환
-- 1. 한일 목록 반환
-- 2. 안한일 목록 반환
-- 3. 모든일 목록 반환
CREATE OR REPLACE PROCEDURE proclisttodo (
	psel IN NUMBER,
	pcursor OUT sys_refcursor
)
IS
BEGIN
	-- 조건부 반환시 반환하는 컬럼 구조가 동일해야한다.
	IF psel = 1 THEN
		OPEN pcursor
		FOR
		SELECT * FROM tbltodo WHERE completedate IS NOT NULL;
	ELSIF psel = 2 THEN
		OPEN pcursor
		FOR
		SELECT * FROM tbltodo WHERE completedate IS NULL;
	ELSIF psel = 3 THEN
		OPEN pcursor
		FOR
		SELECT * FROM tbltodo;
	END IF;
EXCEPTION
	WHEN OTHERS THEN
		dbms_output.put_line('예외처리');
END proclisttodo;



DECLARE
	vcursor sys_refcursor;
	vrow tbltodo%rowtype;
BEGIN
	proclisttodo(3, vcursor);
	LOOP
		FETCH vcursor INTO vrow;
		EXIT WHEN vcursor%notfound;
	
		dbms_output.put_line(vrow.title ||','|| vrow.completedate);
	END LOOP;
END;








