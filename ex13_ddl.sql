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
		- PK에 포함된 성질
		- 해당 컬럼이 반드시 값을 가져야 한다.
		- 해당 컬럼에 값이 없으면 에러 발생
		- 필수값
	
	2. PRIMARY KEY, PK
		- 기본키
		- 테이블의 행을 구분하기 위한 제약사항
		- 행을 식별하는 수많은 키(후보키)들 중 대표로 선정된 키
		- 모든 테이블은 반드시 1개의 기본키가 존재해야 한다.(**********)
		- 중복값을 가질 수 없다. > unique
		- 값을 반드시 가진다. > not null
		
	3. FOREIGN KEY, FK
		- 외래키 제약
		- 다음에
	
	4. UNIQUE
		- PK에 포함된 성질
		- 유일하다 > 레코드간의 중복값을 가질 수 없다.
		- null을 가질 수 있다. > 식별자가 될 수 없다.
		ex) 초등학교 교실
			- 학생(번호(PK), 이름(NN), 직책(UQ))
				1,홍길동,반장
				2,아무개,null
				3,하하하,부반장
				4,테스트,null
	
	5. CHECK
		- 사용자 정의형
		- where절의 조건 > 컬럼의 제약 사항으로 적용
	
	6. DEFAULT
		- 기본값 설정
		- insert/update 작업시 > 컬럼에 값을 안넣으면 null 대신 미리 설정한 값을 대입
	
*/

-- 메모 테이블
CREATE TABLE tblMemo
(
	-- 컬럼명 자료형(길이) NULL 제약사항
	-- NULL > 널을 허용한다, 기본값
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


		
		
		
		
-- NOT NULL
-- 메모 테이블
DROP TABLE tblmemo;
		
CREATE TABLE tblMemo
(
	-- NOT NULL > 널을 허용하지 않는다
	seq number(3) NOT NULL,			--메모번호(NN)
	name varchar2(30) NULL,			--작성자
	memo varchar2(1000) NOT NULL,	--메모(NN)
	regdate DATE NULL				--작성날짜
);


SELECT * FROM tblmemo;

INSERT INTO tblmemo (seq, name, memo, regdate)
			VALUES (1, '홍길동', '메모입니다.', sysdate);

-- ORA-01400: cannot insert NULL into ("HR"."TBLMEMO"."MEMO")
INSERT INTO tblmemo (seq, name, memo, regdate)
			VALUES (2, '홍길동', NULL, sysdate);

-- null을 넣는 다른 방법
-- ORA-01400: cannot insert NULL into ("HR"."TBLMEMO"."MEMO")
INSERT INTO tblmemo (seq, name, regdate)
			VALUES (2, '홍길동', sysdate); -- 생략된 컬럼에는 null이 들어간다.

-- ORA-01400: cannot insert NULL into ("HR"."TBLMEMO"."MEMO")
INSERT INTO tblmemo (seq, name, memo, regdate)
			VALUES (2, '홍길동', '', sysdate); -- 빈문자('')도 null로 취급한다.



			
			
			
			
-- Primary Key
-- 메모 테이블
DROP TABLE tblmemo;
		
CREATE TABLE tblMemo
(
	-- Primary Key > 중복값을 가지지 않으면서(unique) 반드시 값을 가진다(not null)
	seq number(3) PRIMARY KEY,		--메모번호(PK)
	name varchar2(30) NULL,			--작성자
	memo varchar2(1000) NOT NULL,	--메모(NN)
	regdate DATE NULL				--작성날짜
);


SELECT * FROM tblmemo;

-- 재실행
-- ORA-00001: unique constraint (HR.SYS_C007087) violated
INSERT INTO tblmemo (seq, name, memo, regdate)
			VALUES (1, '홍길동', '메모입니다.', sysdate);

INSERT INTO tblmemo (seq, name, memo, regdate)
			VALUES (2, '홍길동', '메모입니다.', sysdate);

-- ORA-01400: cannot insert NULL into ("HR"."TBLMEMO"."SEQ")
INSERT INTO tblmemo (seq, name, memo, regdate)
			VALUES (NULL, '홍길동', '메모입니다.', sysdate);

	

-- 테이블 내에 PK가 반드시 존재해야 하냐?
-- pk를 적용하지 않은 테이블
INSERT INTO tblmemo (seq, name, memo, regdate)
			VALUES (1, '홍길동', '메모입니다.', sysdate);
INSERT INTO tblmemo (seq, name, memo, regdate)
			VALUES (2, '아무개', '메모입니다.', sysdate);
INSERT INTO tblmemo (seq, name, memo, regdate)
			VALUES (3, '테스트', '메모입니다.', sysdate);

-- 1번 홍길동 ~ 레코드를 한번 더 추가
		
SELECT * FROM tblmemo;

SELECT * FROM tblmemo WHERE name = '아무개';
SELECT * FROM tblmemo WHERE seq = 2;

-- 같은 레코드가 두 개 이상 들어갔을 때 PK가 없으면 식별할 수 없다
-- 마지막에 들어간 글을 찾고싶은데 첫번째, 마지막 둘다 검색됨
SELECT * FROM tblmemo WHERE name = '홍길동';
SELECT * FROM tblmemo WHERE seq = 1;

DELETE FROM tblmemo WHERE seq = 2;

-- 두 레코드가 한번에 삭제됨
DELETE FROM tblmemo WHERE seq = 1;


-- PK를 적용한 테이블
INSERT INTO tblmemo (seq, name, memo, regdate)
			VALUES (1, '홍길동', '메모입니다.', sysdate);
INSERT INTO tblmemo (seq, name, memo, regdate)
			VALUES (2, '아무개', '메모입니다.', sysdate);
INSERT INTO tblmemo (seq, name, memo, regdate)
			VALUES (3, '테스트', '메모입니다.', sysdate);
INSERT INTO tblmemo (seq, name, memo, regdate)
			VALUES (4, '홍길동', '메모입니다.', sysdate);
	
		
SELECT * FROM tblmemo;

SELECT * FROM tblmemo WHERE name = '아무개';
SELECT * FROM tblmemo WHERE seq = 2; -- 검색 > 주로 PK로 검색

SELECT * FROM tblmemo WHERE name = '홍길동';
SELECT * FROM tblmemo WHERE seq = 4; -- 첫번째 홍길동이 작성한 글과 구분됨

DELETE FROM tblmemo WHERE seq = 4; -- 원하는 레코드를 구분지어 삭제할 수 있음








--Unique
-- 메모 테이블
DROP TABLE tblmemo;
		
CREATE TABLE tblMemo
(
	seq number(3) PRIMARY KEY,		--메모번호(PK)
	name varchar2(30) UNIQUE,		--작성자(UQ)
	memo varchar2(1000) NOT NULL,	--메모(NN)
	regdate DATE					--작성날짜
);


SELECT * FROM tblmemo;

INSERT INTO tblmemo (seq, name, memo, regdate)
			VALUES (1, '홍길동', '메모입니다.', sysdate);

-- ORA-00001: unique constraint (HR.SYS_C007096) violated
INSERT INTO tblmemo (seq, name, memo, regdate)
			VALUES (2, '홍길동', '메모입니다.', sysdate);
		
INSERT INTO tblmemo (seq, name, memo, regdate)
			VALUES (2, '아무개', '메모입니다.', sysdate);

INSERT INTO tblmemo (seq, name, memo, regdate)
			VALUES (3, NULL, '메모입니다.', sysdate);

-- null은 중복이 아님
INSERT INTO tblmemo (seq, name, memo, regdate)
			VALUES (4, NULL, '메모입니다.', sysdate);




		
		
		
		
-- Check
-- 메모 테이블
DROP TABLE tblmemo;
		
CREATE TABLE tblMemo
(
	seq number(3) PRIMARY KEY,		--메모번호(PK)
	name varchar2(30),				--작성자
	memo varchar2(1000),			--메모
	regdate DATE,					--작성날짜
	--컬럼 추가
	--중요도(1(중요),2(보통),3(안중요))
	--priority NUMBER(1) CHECK (priority >= 1 AND priority <= 3),
	priority NUMBER(1) CHECK (priority BETWEEN 1 AND 3),
	-- 카테고리(할일, 공부, 약속, 가족, 개인 ..)
	category varchar2(30) CHECK (category IN ('할일', '공부', '약속'))
);


SELECT * FROM tblmemo;

INSERT INTO tblmemo (seq, name, memo, regdate, priority, category)
			VALUES (1, '홍길동', '메모입니다.', sysdate, 1, '할일');	

-- ORA-02290: check constraint (HR.SYS_C007098) violated 중요도의 제약에 걸림
INSERT INTO tblmemo (seq, name, memo, regdate, priority, category)
			VALUES (2, '홍길동', '메모입니다.', sysdate, 5, '할일');	

-- ORA-02290: check constraint (HR.SYS_C007099) violated 카테고리의 제약에 걸림
INSERT INTO tblmemo (seq, name, memo, regdate, priority, category)
			VALUES (3, '홍길동', '메모입니다.', sysdate, 1, '개인');	
		
		


		
		

		
--default
--메모 테이블
DROP TABLE tblmemo;
		
CREATE TABLE tblMemo
(
	seq number(3) PRIMARY KEY,		--메모번호(PK)
	name varchar2(30) DEFAULT '익명',	--작성자
	memo varchar2(1000),			--메모
	regdate DATE DEFAULT sysdate	--작성날짜
);


SELECT * FROM tblmemo;

INSERT INTO tblmemo (seq, name, memo, regdate)
			VALUES (1, '홍길동', '메모입니다.', sysdate);
		
-- null을 명시 > null이 들어감
INSERT INTO tblmemo (seq, name, memo, regdate)
			VALUES (2, null, '메모입니다.', null); 

-- 컬럼을 생략 > 디폴트 값이 들어감
INSERT INTO tblmemo (seq, memo)
			VALUES (3, '메모입니다.'); -- 암시적 

--default 상수 > dafault값을 넣어주세요
INSERT INTO tblmemo (seq, name, memo, regdate)
			VALUES (4, default, '메모입니다.', default); 

		
		
		
		
		
-----------------------------------------------------------------------

/*
	제약 사항을 만드는 방법
	1. 컬럼 수준에서 만드는 방법
		- 위에서 수업한 방법
		- 컬럼을 선언할 때 제약 사항도 같이 선언하는 방법
	
	2. 테이블 수준에서 만드는 방법
		
	
	3. 외부에서 만드는 방법
		

*/
	

-- 2. 테이블 수준에서 제약사항을 만드는 방법		
CREATE TABLE tblMemo
(
	seq number(3),
	name varchar2(30),
	memo varchar2(1000),
	regdate DATE,
	
	-- 테이블 수준에서 제약사항 정의 > 가독성
	-- PK(기본키), UQ(유니크), CK(체크), FK(외래키)
	CONSTRAINT tblmemo_seq_pk PRIMARY KEY(seq),
	CONSTRAINT tblmemo_name_uq UNIQUE(name),
	CONSTRAINT tblmemo_memo_ck CHECK(LENGTH(memo) >= 10)
	
	-- not null과 default는 반드시 컬럼 단위로만 제약사항 정의할 수 있다
);






