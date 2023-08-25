-- ex01
-- 단일라인 주석
/*
    다중라인 주석


    localhost + system
    
    localhost > 현재 컴퓨터
    
    localhost == 127.0.0.1 (IP adredd, 루프백, this)
    
    system 작업 안함 > 권한이 너무 커서;;; > 실수, 보안
    
    일반 계정 작업 > 특정 업무에 대한 권한만 있는 계정 > 수업도 일반계정으로만!
    
    학습용 계정 제공(=일반 계정) > + 샘플 데이터 > hr
    
    관리자 > 특정 계정의 비밀번호 바꾸기
    -alter user 계정명 identified by 비밀번호;
    sql 실행방법 블럭잡고 Ctrl + enter

    특정 계정의 활성화/비활성화
    -alter user 계정명 account unlock;
    -alter user 계정명 account lock;
*/

alter user hr identified by java1234;
alter user hr account unlock;

/*
    Oracle Database 11g Enterprise Edition(기업용)
    Oracle Database 11g Express Edition(무료, 교육용)
    
    SQL, Structured Query Language 
    - 구조화된 질의 언어
    - 개발자(SQL Developer) <-> SQL <-> 오라클
    - DBMS 조작하기 위한 언어
    
    오라클 + SQL
    1. 데이터베이스 관리자, DBA
        - 모든 것
        
    2. 데이터베이스 개발자, DB 개발자
        - 모든 것
    
    3. 응용 프로그램 개발자(자바 개발자)
        - 모든 것 or 일부 사용
    
    
    
    관계형 DBMS
    1. Oracle
    2. MS-SQL(Microsoft) 기업용
    3. MySQL > 무료(개인, 기업)
    4. MariaDB > 무료(개인, 기업)
    5. PostreSQL > 무료(개인, 기업)
    6. DB2 > IBM
    7. SQLite > Mobile
    
    
    SQL
    1. DBMS 제작사와 독립적이다.
        - 모든 관계형 데이터베이스에서 공통적으로 사용하기 위해 만들어진 언어
        - DBMS 제작사에서 SQL라는 언어를 자신의 제품에 적용
    
    2. 표준 SQL, ANSI-SQL
        - 모든 DBMS에 적용 가능한 SQL
    
    3. 제조자별 SQL
        - 특정 DBMA에 적용 가능한 SQL
        - Oracle > PL/SQL
        - MS-SQL > T-SQL
        - 나머지는 따로 부르는 표현은 없음
    
    
    오라클 수업 = ANSI_SQL(5~60%) + PL/SQL(2~30%) + 설계, 기타등등..(10%)
    오라클 수업에서 뭐배우셨어요? > 전반적인 ANSI_SQL과 PL/SQL 그리고 데이터베이스 설계에 대해 배웟습니다 . 
    
    관계형 데이터베이스 RDBMS
    - 데이터를 표 형식으로 저장/관리한다.
    - SQL을 사용한다. (SQL == 관계형 데이터베이스를 관리하기 위한 전용 언어)
    
    
    AnSI-SQL
    1. DDL
        - Data Definition Language
        - 데이터 정의어
        - 테이블, 뷰, 사용자, 인덱스 등의 데이터베이스 오브젝트를
            생성/수정/삭제하는 명령어
        - 구조를 생성/관리하는 명령어
        a. CREATE : 생성
        b. DROP : 삭제
        c. ALTER : 수정
        - 데이터베이스 관리자
        - 데이터베이스 담당자
        - 프로그래머(일부)
        
    2. DML
        - Data Manipulation Language
        - 데이터 조작어
        - 데이터 추가/수정/삭제/조회하는 명령어
        - CRUD
        - 사용빈도가 가장 높음
        a. SELECT : 조회(읽기) > R
        b. INSERT : 추가(생성) > C
        c. UPDATE : 수정 > U
        d. DELETE : 삭제 > D
        - 데이터베이스 관리자
        - 데이터베이스 담당자
        - 프로그래머(************************)
        
    3. DCL
        - Data Control Language
        - 데이터 제어어
        - 계정 관리, 보안 관리, 트랜잭션 관리 등 .. 
        a. COMMIT
        b. ROLLBACK
        c. GRANT
        d. REVOKE
        - 데이터베이스 관리자
        - 데이터베이스 담당자
        - 프로그래머(일부)
        
    4. DQL
        - Data Query Language 
        - DML 중에서 SELECT문을 따로 부르는 표현
        
    5. TCL
        - Transaction Control Language
        - DCL 중에서 COMMIT, ROLLBACK문을 따로 부르는 표현
        
        
    오라클 인코딩
    - 1.0 ~ 8i : EUC-KR
    - 9i ~  현재 : UFT-8
                   
*/

-- SQL > 대소문자를 구분하지 않는다.
-- 파란색 > 키워드
-- 검은색 > 식별자
select * from tabs; --semicolon 필수는아님. . .
SELECT * FROM tabs;

-- 'JOBS' > 문자 상수 > 데이터는 대소문자를 구분한다. (*******)
select * from tabs where table_name  = 'JOBS'; -- 결과 O
select * from tabs where table_name  = 'jobs'; -- 결과 x

-- 1. 키워드 > 대문자
-- 2. 식별자 > 소문자
SELECT * FROM tabs;  -- alt + '

-- 수업용 대문자 치기 귀찮으니까...
-- 1. 키워드 > 소문자
-- 2. 식별자 > 캐멀
select * from tableStudent;

-- DB Object 식별자 주의점 > 최대 30바이트까지(30자)
create table aaa (
    num number
);

create table aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa (
    num number
);

-- ORA-00972: identifier is too long
create table aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa (
    num number
);

