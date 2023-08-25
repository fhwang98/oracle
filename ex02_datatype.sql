--ex02_datatype.sql

/*

    관계형 데이터베이스
    - 변수(X) > SQL은 프로그래밍 언어가 아니다.
    - SQL > 대화형 언어 > DB와 대화를 목적으로 하는 언어
    - 자료형 > 데이터 저장하는 규칙 > 테이블 정의할 때 사용 > 컬럼의 자료형


    ANSI-SQL 자료형
    - Oracle 자료형
    
    1. 숫자형
        - 정수, 실수
        a. number
            - (유효자리)38자리 이하의 숫자를 표현하는 자료형
            - 12345678901234567890123456789012345678
            - 5~22byte (가변적)
            - 1x10^-130 ~ 9,9999x10^125
            
            - number : 정수 & 실수
            - number(precision) : 전체 자릿수 -> 정수
            - number(precision, scale) : 전체 자릿수, 소수이하 자릿수 -> 실수
            
    2. 문자형
        - 문자, 문자열
        - char vs nchar > n의 의미?
        - char vs nchar > var의 의미?
        a. char
            - 고정 자릿수 문자열 > 공간(컬럼)의 크기가 불변
            - char(n) : 최대 n자리 문자열, n(바이트)
            - char( n char) : n (글자수)
            - 최소 크기 : 1바이트
            - 최대 크기 : 2000바이트
        
        b. nchar
            - n : national > 오라클 인코딩과 상관없이 해당 컬럼을 UTF-16 동작하게
            - char(n) : 최대 n자리 문자열, n(글자수)
            - 최소 크기 : 1글자
            - 최대 크기 : 1000글자 (2000바이트)
            
            
        c. varchar2 > variable char > 바캐릭터, 바차
            - 가변 자릿수 문자열 > 공간(컬럼)의 크기가 가변
            - varchar2(n) : 최대 n자리 문자열, n(바이트)
            - varchar2(n char) : n(글자수)
            - 최소 자릿수 : 1 바이트
            - 최대 자릿수 : 4000 바이트
        
        d. nvarchar2
            - n : national > 오라클 인코딩과 상관없이 해당 컬럼을 UTF-16 동작하게
            - 가변 자릿수 문자열 > 공간(컬럼)의 크기가 가변
            - varchar2(n) : 최대 n자리 문자열, n(문자수)
            - varchar2(n char) : n(글자수)
            - 최소 자릿수 : 1 글자
            - 최대 자릿수 : 2000 글자
        
        e. clob, nclob
            - 대용량 텍스트
            - character large object
            - 최대 128TB
            - 참조형
        
        예전에는    
        - 고정 자릿수 문자열 > 주민등록번호, 전화번호 > char
        - 가변 자릿수 문자열 > 주소, 자기소개 > varchar2
        
        지금은
        - 고정/가변 > varchar2
        
    3. 날짜/시간형
        a. date
            - 년월일시분초
            - 7byte
            - 기원전 4712년 1월 1일 ~ 9999년 12월 31일
        
        b. timestamp
            - 년월일시분초 + 밀리초 + 나노초
        
        c. interval
            - 시간
            - 틱값
        
        
    4. 이진 데이터형
        - 비 텍스트 데이터
        - 이미지, 영상, 음악, 실행파일, 압축 파일 등..
        - 잘 사용 안함.
        ex) 게시판(첨부파일), 회원가입(사진) > 파일명만 저장
        a. blob
            - binary large object
            - 최대 128TB


    결론
    1. 숫자 > number
    2. 문자 > varchar2 + char
    3. 날짜 > date
    
    자바
    1. 숫자 > int, long, double, boolean
    2. 문자열 > String
    3. 날짜 > Calendar

*/

-- 테이블 선언(생성)
/*
    create table 테이블명 (
        컬럼 선언,
        컬럼 선언, 
        컬럼 선언
        컬럼명 자료형
    );

*/

-- 수업용
-- 식별자 > 타입 접두어 > 헝가리안 표기법

create table tblType (
    --num number
    --num number(3) -- -999 ~ 999 + 정수
    --num number(4,2) -- -99.99 ~ 99.99

    --txt char(10) -- 최대 10바이트까지의 문자열
    --txt char(10 char) -- 최대 10글자까지의 문자열
    
    --txt varchar2(10)
    
    --txt1 char(10),
    --txt2 varchar2(10)
    
    regdate date
    
    
);

-- 테이블 삭제
drop table tblType;

-- 데이터 추가
-- insert into 테이블 (컬럼) values (값);
insert into tblType (num) values (100); -- 정수 리터럴
insert into tblType (num) values (3.14); -- 실수 리터럴
insert into tblType (num) values (3.99); -- 반올림 O
insert into tblType (num) values (1234); -- ORA-01438: value larger than specified precision allowed for this column
insert into tblType (num) values (999);
insert into tblType (num) values (-999);
insert into tblType (num) values (99.99);
insert into tblType (num) values (-99.99);

insert into tblType (num) values (1234567890);
insert into tblType (num) values (12345678901234567890);
insert into tblType (num) values (123456789012345678901234567890);
insert into tblType (num) values (1234567890123456789012345678901234567890);
insert into tblType (num) values (12345678901234567890123456789012345678901234567890); -- 지수부 손실 생김
-- 12345678901234567890123456789012345678900000000000 유효자리 넘어가면 손실분이 생긴다

-- Java : Strong Type Language > 문법 엄격
-- SQL : Weak Type Language > 


-- *** SQL 암시적인 형변환이 자주 일어난다.
insert into tblType (txt) values (100); -- 100(number) > '100'(char)
insert into tblType (txt) values ("홍길동"); -- "" 안됨
insert into tblType (txt) values ('홍길동'); -- 문자 리터럴

-- 오라클 인코딩 > UTF-8 > 영어(1) 한글(3)
insert into tblType (txt) values ('abcdabcdab'); -- 10바이트
-- ORA-12899: value too large for column "HR"."TBLTYPE"."TXT" (actual: 11, maximum: 10)
insert into tblType (txt) values ('abcdabcdabc'); --11바이트
insert into tblType (txt) values ('홍길동입니다.'); --(actual: 19, maximum: 10)

insert into tblType (txt) values ('홍길동님');

insert into tblType (txt1, txt2) values ('abc', 'abc');
-- char 데이터가 지정된 크기보다 작아도 남은 공간 확보 > 공백으로 채워짐
-- varchar2 데이터가 지정된 크기보다 작으면 남은 공간 버림


insert into tblType (regdate) values ('2023-08-25'); -- 날짜시간 상수
-- 23/08/25


-- 데이터 가져오기 > 결과 테이블, 결과셋(ResultSet)
select * from tblType;

commit;

-- 오라클은 모든 식별자를 대문자로 저장한다.
/*
    DB Client Tools
    1. SQL Developer > 오라클 제공. 무료. 그럭저럭
    2. SQL*Plus > 오라클 제공. 무료. 오라클 설치될 때 같이 설치 CLI
    3. SQLGate
    4. Orange
    5. DBeaver
    6. ..
    7. Toad
    8. DataGrip(jetbrains) > 학교계정(이메일) > 1년 단위(갱신)
    
    수업은 SQL Developer
    개인작업용 DBeaver, DataGrip도 추천

*/
