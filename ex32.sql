-- ex32.sql

-- 근태 상황(출석)
CREATE TABLE tbldate(
	seq NUMBER PRIMARY KEY,
	state varchar2(30) NOT NULL,
	regdate DATE NOT NULL
);

insert into tblDate (seq, state, regdate) values (1, '정상', '2023-09-01');
-- 09-02 : 토요일
-- 09-03 : 일요일

insert into tblDate (seq, state, regdate) values (2, '정상', '2023-09-04');
insert into tblDate (seq, state, regdate) values (3, '지각', '2023-09-05');
-- 09-06 : 결석
insert into tblDate (seq, state, regdate) values (4, '정상', '2023-09-07');
insert into tblDate (seq, state, regdate) values (5, '정상', '2023-09-08');

-- 09-09 : 토요일
-- 09-10 : 일요일
insert into tblDate (seq, state, regdate) values (6, '조퇴', '2023-09-11');
insert into tblDate (seq, state, regdate) values (7, '정상', '2023-09-12');
insert into tblDate (seq, state, regdate) values (8, '정상', '2023-09-13');
insert into tblDate (seq, state, regdate) values (9, '지각', '2023-09-14');
insert into tblDate (seq, state, regdate) values (10, '정상', '2023-09-15');

-- 09-16 : 토요일
-- 09-17 : 일요일
insert into tblDate (seq, state, regdate) values (11, '정상', '2023-09-18');
insert into tblDate (seq, state, regdate) values (12, '정상', '2023-09-19');
insert into tblDate (seq, state, regdate) values (13, '지각', '2023-09-20');
-- 09-21 : 결석
insert into tblDate (seq, state, regdate) values (14, '조퇴', '2023-09-22');

-- 09-23 : 토요일
-- 09-24 : 일요일
insert into tblDate (seq, state, regdate) values (15, '정상', '2023-09-25');
insert into tblDate (seq, state, regdate) values (16, '정상', '2023-09-26');
insert into tblDate (seq, state, regdate) values (17, '정상', '2023-09-27');
-- 09-28 : 추석
-- 09-29 : 추석
-- 09-30 : 토요일

SELECT * FROM tbldate;
-- 근태 조회 > 9월 근태 기록 열람 > 결석한 날짜도 포함 + 공휴일 포함 > 빠진 날짜 메꾸기
-- 1. ANSI-SQL > 수업
-- 2. PL/SQL
-- 3. JAVA

-- pl/sql
DECLARE
	vdate DATE;
	vstate varchar2(30);
	vcnt NUMBER;
BEGIN
	
	vdate := to_date('2023-09-01', 'yyyy-mm-dd');
	FOR i IN 1..30 LOOP
		dbms_output.put_line(vdate);
	
		SELECT count(*) INTO vcnt FROM tbldate WHERE to_char(regdate, 'yyyy-mm-dd') = to_char(vdate, 'yyyy-mm-dd');
		
		IF vcnt > 0 THEN
			SELECT state INTO vstate FROM tbldate WHERE to_char(regdate, 'yyyy-mm-dd') = to_char(vdate, 'yyyy-mm-dd');
			dbms_output.put_line(vstate);			
		END IF;
		
		vdate := vdate + 1; -- 하루씩 증가
	END LOOP;
END;


-- ANSI-SQL
-- 계층형 쿼리 사용
SELECT * FROM tblcomputer;

SELECT
	lpad(' ', LEVEL * 10) || name
FROM tblcomputer
	START WITH seq = 1
		CONNECT BY pseq = PRIOR seq;


-- 계층형 쿼리 = for문 효과 > 일련번호 생성
SELECT LEVEL FROM dual
	CONNECT BY LEVEL <= 5;

SELECT sysdate + LEVEL FROM dual
	CONNECT BY LEVEL <= 5;


--9월 1일 ~ 9월 30일
--*********** > date 자료형으로 원하는 기간의 데이터 생성하는 방법
CREATE OR REPLACE VIEW vwdate
AS
SELECT 
	to_date('20230901','yyyymmdd') + LEVEL - 1 AS regdate
FROM dual 
	CONNECT BY LEVEL <= (to_date('20230930', 'yyyymmdd') - to_date('20230901','yyyymmdd') + 1);


SELECT * FROM vwdate; -- 9월 한달 날짜
SELECT * FROM tbldate; -- 9월 근태 기록

SELECT *
FROM vwdate v
	INNER JOIN tbldate t
		ON v.regdate = t.regdate;


SELECT *
FROM vwdate v
	LEFT OUTER JOIN tbldate t
		ON v.regdate = t.regdate
			ORDER BY v.regdate;

--휴일 처리(토, 일)
SELECT
	v.regdate,
	CASE
		WHEN to_char(v.regdate, 'd') IN ('1') THEN '일요일'
		WHEN to_char(v.regdate, 'd') IN ('7') THEN '토요일'
		ELSE t.state
	END AS state
FROM vwdate v
	LEFT OUTER JOIN tbldate t
		ON v.regdate = t.regdate
			ORDER BY v.regdate;


-- 공휴일 처리 > 규칙이 없음
CREATE TABLE tblholiday (
	seq NUMBER PRIMARY KEY,
	regdate DATE NOT NULL,
	name varchar2(30) NOT NULL
);

INSERT INTO tblholiday VALUES (1, '2023-09-28', '추석');
INSERT INTO tblholiday VALUES (2, '2023-09-29', '추석');

SELECT * FROM tblholiday;

-- 평일 + 휴일처리 + 공휴일 + 결석

SELECT
	v.regdate,
	CASE
		WHEN to_char(v.regdate, 'd') IN ('1') THEN '일요일'
		WHEN to_char(v.regdate, 'd') IN ('7') THEN '토요일'
		WHEN t.state IS NULL AND h.name IS NOT NULL THEN h.name
		WHEN t.state IS NULL AND h.name IS NULL THEN '결석'
		ELSE t.state
	END AS state
FROM vwdate v
	LEFT OUTER JOIN tbldate t
		ON v.regdate = t.regdate
			LEFT OUTER JOIN tblholiday h
				ON v.regdate = h.regdate
			ORDER BY v.regdate;


