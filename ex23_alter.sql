--ex23_alter.sql

/*
	
	DDL > 객체 조작
	- 객체 생성 : CREATE
	- 객체 수정 : ALTER
	- 객체 삭제 : DROP
	
	DML > 데이터 조작
	- 데이터 생성 : CREATE
	- 데이터 수정 : INSERT
	- 데이터 삭제 : DELETE
	
	테이블 수정하기
	- 테이블 정의 수정 > 스키마 수정 > 컬럼 수정 > 컬럼명 or 자료형(길이) or 제약사항 등
	- 되도록 테이블을 수정하는 상황을 발생시켜서는 안된다!!
	
	
	테이블 수정해야하는 상황 발생!!!
	1. 테이블 삭제(DROP) > 테이블 DDL(CREATE) 수정 > 수정된 DDL로 새롭게 테이블 생성
		a. 기존 테이블에 데이터가 없었을 경우 > 아무 문제 없음
		b. 기존 테이블에 데이터가 있었을 경우 > 미리 데이터를 백업 > 테이블 삭제 > 수정된 테이블 생성 > 데이터 복구
			- 개발 중에 사용 가능
			- 공부할 때 사용 가능
			- 서비스 운영 중에는 거의 불가능한 방법
			
	2. ALTER 명령어 사용 > 기존 테이블의 구조 변경
		a. 기존 테이블에 데이터가 없었을 경우 > 아무 문제 없음
		b. 기존 테이블에 데이터가 있었을 경우 > 경우에 따라 비용 차이
			- 개발 중에 사용 가능
			- 공부할 때 사용 가능
			- 서비스 운영 중에는 경우에 따라 가능 
			
*/


DROP TABLE tbledit;

CREATE TABLE tbledit (
	seq NUMBER PRIMARY KEY,
	DATA varchar2(20) NOT null
);

INSERT INTO tbledit VALUES (1, '마우스');
INSERT INTO tbledit VALUES (2, '키보드');
INSERT INTO tbledit VALUES (3, '모니터');

SELECT * FROM tbledit;

-- Case 1. 새로운 컬럼을 추가하기

ALTER TABLE tbledit
	ADD (price NUMBER);

-- ORA-01758: table must be empty to add mandatory (NOT NULL) columns
ALTER TABLE tbledit
	ADD (qty NUMBER NOT NULL);

DELETE FROM tbledit;


INSERT INTO tbledit VALUES (1, '마우스', 1000, 1);
INSERT INTO tbledit VALUES (2, '키보드', 2000, 1);
INSERT INTO tbledit VALUES (3, '모니터', 3000, 2);


ALTER TABLE tbledit
	ADD (color varchar2(30) DEFAULT 'white' NOT NULL);



-- Case 2. 컬럼 삭제하기
ALTER TABLE tbledit
	DROP COLUMN color;

ALTER TABLE tbledit
	DROP COLUMN seq; -- pk 삭제 > 절대 금지!!!!

SELECT * FROM tbledit;   


-- Case 3. 컬럼 수정하기
INSERT INTO tbledit values(4, '애플 M2 맥북 프로 2023');

-- Case 3.1 컬럼 길이 수정하기(확장/축소)
ALTER TABLE tbledit
	MODIFY (DATA varchar2(100));

-- ORA-01441: cannot decrease column length because some value is too big
ALTER TABLE tbledit
	MODIFY (DATA varchar2(20));

-- Case 3.2 컬럼의 제약사항 수정하기
ALTER TABLE tbledit
	MODIFY (DATA varchar2(100) NULL);

INSERT INTO tbledit values(5, NULL);

ALTER TABLE tbledit
	MODIFY (DATA varchar2(100) NOT NULL);


-- Case 3.3 컬럼의 자료형 수정하기 > 테이블을 비우고 작업
ALTER TABLE tbledit
	MODIFY (DATA NUMBER);

DELETE FROM tbledit;
SELECT * FROM tbledit;

--DESC tbledit; -- SQL*PLUS > SQL Developer 전용 명령어





