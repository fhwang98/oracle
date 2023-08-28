-- ex04_operator

/*
    연산자, Operator
    
    1. 산술연산자
    - +, -, *, /
    - %(없음) > 함수로 제공 mod()
    
    2. 문자열 연산자(concat)
    - +(X) > ||(O) 

	3. 비교 연산자
	- >, >=, <, <=
	- =(같다), <>(같지 않다)
	- 논리값 반환 > SQL에는 boolean이 없다 > 명시적으로 표현 불가능 > 조건이 필요한 상황에서 내부적으로 사용
	- 컬럼 리스트에서 사용 불가
	- 조건절에서 사용

	4. 논리 연산자
	- and(&&), or(||), not(!)
	- 논리값 반환
	- 컬럼 리스트에서 사용 불가
	- 조건절에서 사용
	
	5. 대입 연산자
	- =
	- 컬럼 = 값
	- update문
	
	6. 3항 연산자
	- 없음
	- 제어문 없음
	
	 7. 증감 연산자
	 - 없음
	 
	 8. SQL 연산자
	 - 자바 연산자 instanceof, typeof 등..
	 - in, between, like, is 등..(OO절, OO구 ..)
*/

select
    population,
    area,
    population + area,
    population - area,
    population * area,
    population / area
from tblCountry;

-- ORA-01722: invalid number
-- SELECT NAME, COUPLE, NAME + COUPLE FROM TBLMEN ;
 
SELECT NAME, COUPLE, NAME || COUPLE FROM TBLMEN ; 

-- ORA-00923: FROM keyword not found where expected
--SELECT HEIGHT ,WEIGHT , HEIGHT >WEIGHT  FROM TBLMEN ; 논리형을 명시적으로 화면에 보이게 할 수는 없다 

SELECT HEIGHT ,WEIGHT  FROM TBLMEN WHERE HEIGHT >WEIGHT ;

SELECT NAME ,AGE FROM TBLMEN ; --이전나이(한국식)

-- 컬럼의 별칭(Alias)
-- 되도록 가공된 컬럼에 적용
-- 함수 결과에 적용
-- *** 컬럼명이 식별자로 적합하지 않을 때 사용 > 적합한 식별자로 수정
-- 식별자로 사용 불가능 상황 > 억지로 적용할 때
SELECT 
	NAME AS 이름 ,
	AGE, 
	AGE -1 AS 나이, 
	LENGTH(NAME) AS 길이,
	COUPLE AS "여자 친구",
	--NAME AS SELECT --예약어(키워드) 는 식별자로 만들 수 없다.ORA-00923: FROM keyword not found where expected
	NAME "select"
FROM TBLMEN ; --컬럼명(***)

--테이블 별징(Alias)
-- 용도 : 편하게 .. + 가독성 향상

--ORA-00933: SQL command not properly ended
--SELECT * FROM TBLMEN AS t;
SELECT * FROM TBLMEN t;


SELECT name, age, height, weight, couple FROM TBLMEN ;
SELECT hr.tblmen.name, hr.tblmen.age, hr.tblmen.height, hr.tblmen.weight, hr.tblmen.couple FROM hr.TBLMEN;

-- 각 절의 실행 순서
-- 2. select 절
-- 1. from 절

SELECT
	m.NAME, m.AGE, m.WEIGHT , m.HEIGHT , m.COUPLE  
FROM TBLMEN m;
