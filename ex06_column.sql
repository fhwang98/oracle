--ex06_column.sql

-- 컬럼리스트에서 할 수 있는 행동
-- select 컬럼 리스트

-- 컬럼 명시
SELECT * FROM TBLINSA ;
SELECT NAME , SSN FROM TBLINSA ;

-- 연산
SELECT NAME || '님', BASICPAY * 2 FROM TBLINSA ;

-- 상수
SELECT 100 FROM TBLINSA ;

/*
	Java Stream > list.stream().distinct().foreach()
	
	distinct
	- 컬럼 리스트
	- 중복값 제거
	- distinct 특정 컬럼명(X) > 컬럼리스트(O)

*/

SELECT DISTINCT CONTINENT FROM TBLCOUNTRY ;

--tblinsa > 수많은 부서 > 어떤 부서가 있습니까? > 중복값 제거
SELECT BUSEO FROM TBLINSA ;
SELECT DISTINCT BUSEO FROM TBLINSA ;

SELECT DISTINCT JIKWI FROM TBLINSA ;

SELECT DISTINCT NAME FROM TBLINSA ;

-- 결과 60개
SELECT
	DISTINCT BUSEO, NAME
FROM TBLINSA ;

-- 결과 23개
SELECT
	DISTINCT BUSEO, JIKWI 
FROM TBLINSA ;

/*
	case
	- 대부분의 절에서 사용 가능
	- 조건문 역할
	- 조건을 만족하지 못하면 null을 반환한다.(************************)

*/

-- m 은 남자, f는 여자로 표시하고싶음
SELECT 
	LAST || FIRST AS name,
	GENDER
FROM TBLCOMEDIAN ;

SELECT 
	LAST || FIRST AS name,
	CASE 
		-- WHEN 조건 THEN 값
		WHEN GENDER = 'm' THEN '남자'
		WHEN GENDER = 'f' THEN '여자'
	END AS GENDER
FROM TBLCOMEDIAN ;


SELECT
	NAME ,
	CASE 
		WHEN CONTINENT = 'AS' THEN '아시아'
		WHEN CONTINENT = 'EU' THEN '유럽'
		WHEN CONTINENT = 'AF' THEN '아프리카'
		-- ELSE '기타'
		-- ELSE CONTINENT 
		-- ORA-00909: invalid number of arguments
		-- ELSE 100 --> (X) 문자열 컬럼에 숫자를 넣을 수 없음 타입이 일치해야함
		-- ELSE CAPITAL -- 하나의 컬럼에 성질이 다른 데이터를 넣지 않기
	END AS CONTINENT
FROM TBLCOUNTRY ;

SELECT
	LAST || FIRST,
	WEIGHT ,
	CASE 
		WHEN WEIGHT > 90 THEN '과체중'
		WHEN WEIGHT > 50 THEN '정상체중'
		ELSE '저체중'
	END AS state
FROM TBLCOMEDIAN ;

SELECT
	LAST || FIRST,
	WEIGHT ,
	CASE 
		WHEN WEIGHT >= 50 AND WEIGHT <= 90 THEN '정상체중'
		ELSE '주의체중'
	END AS state
FROM TBLCOMEDIAN ;

SELECT
	LAST || FIRST,
	WEIGHT ,
	CASE 
		WHEN WEIGHT BETWEEN 50 AND 90 THEN '정상체중'
		ELSE '주의체중'
	END AS state
FROM TBLCOMEDIAN ;

SELECT 
	NAME , JIKWI,
	CASE
		WHEN JIKWI = '과장' OR JIKWI = '부장' THEN '관리직'
		ELSE '생산직'
	END
FROM TBLINSA ;

SELECT 
	NAME , JIKWI,
	CASE
		WHEN JIKWI IN ('과장','부장') THEN '관리직'
		ELSE '생산직'
	END
FROM TBLINSA ;

SELECT 
	NAME , SUDANG ,
	CASE 
		WHEN NAME LIKE '홍%' THEN 50000
		ELSE 0
	END + SUDANG
FROM TBLINSA ;

SELECT 
	TITLE , 
	CASE 
		WHEN COMPLETEDATE IS NULL THEN '미완료'
		WHEN COMPLETEDATE IS NOT NULL THEN '완료'
	END AS state
FROM TBLTODO;