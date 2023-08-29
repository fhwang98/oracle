--ex13_ddl.sql

/*
	ex01 ~ ex12: DML 기본(기초)
	
	DDL
	- 데이터 정의어
	- 데이터베이스 객체를 생성/수정/삭제
	- 데이터베이스 객체 > 테이블, 뷰, 인덱스, 프로시저, 트리거, 제약사항, 시노닙 등..
	- CREATE, ALTER, DROP
	
	테이블 생성하기 > 스키마 정의하기 > 컬럼 정의하기 > 컬럼의 이름, 자료형, 제약을 정의
	
	create table 테이블명
	(
		컬럼 정의,
		컬럼 정의,
		컬럼 정의,
		컬럼명 자료형(길이),
		컬럼명 자료형(길이) NULL 제약사항
	);
	

	제약사항, Constraint
	- 해당 컬럼에 들어갈 데이터(값)에 대한 조건
		1. 조건을 만족하면 > 대입
		2. 조건을 불만족하면 > 에러 발생
	- (자바로 치면)유효성 검사 도구
	- 데이터 무결성을 보장하기 위한 도구(***)
	
	1. NOT NULL
		- 해당 컬럼이 반드시 값을 가져야 한다.
		- 해당 컬럼에 값이 없으면 에러 발생
		- 필수값
	
	2. PRIMARY KEY, PK
	
	3. FOREIGN KEY, FK
	
	4. UNIQUE
	
	5. CHECK
	
	6. DEFAULT
	
	
*/

-- 메모 테이블
CREATE TABLE tblMemo
(
	-- 컬럼명 자료형(길이) NULL 제약사항
	-- NULL > 널을 허용한다
	seq number(3) NULL,			--메모번호
	name varchar2(30) NULL,		--작성자
	memo varchar2(1000) NULL,	--메모
	regdate DATE NULL			--작성날짜
);


SELECT * FROM tblmemo;

INSERT INTO tblmemo (seq, name, memo, regdate)
			VALUES (1, '홍길동', '메모입니다.', sysdate);

INSERT INTO tblmemo (seq, name, memo, regdate)
			VALUES (2, '아무개', NULL, sysdate);

INSERT INTO tblmemo (seq, name, memo, regdate)
			VALUES (3, NULL, NULL, NULL);

INSERT INTO tblmemo (seq, name, memo, regdate)
			VALUES (NULL, NULL, NULL, NULL);


		
		











