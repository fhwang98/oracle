--ex19_subquery.sql

/*
	***중요***

	SQL
	1. Main Query, 일반쿼리
		- 하나의 문장 안에 하나의 select(insert, update, delete)로 되어있는 쿼리
	
	2. Sub Query, 서브쿼리
		- 하나의 문장(select, insert, update, delete)안에 또다른 문장(select)이 들어있는 쿼리 
		- 하나의 select안에 또다른 select문이 들어있는 쿼리(빈도가 가장 많다)
		- 삽입 위치 > select절, from절, where절, group by절, having절, order by절
		- 컬럼(값)을 넣을 수 있는 장소면 서브쿼리가 들어갈 수 있다.

*/


--tblcountry 인구수가 가장 많은 나라의 이름? > 중국
SELECT
	max(population) -- 120660
FROM tblcountry;

--12660 직접 입력
SELECT
	name
FROM tblcountry
	WHERE population = 120660;


COMMIT;

ROLLBACK;


UPDATE tblcountry SET population = population + 100 WHERE name = '중국';

-- update > 인구가 100명 늘었다? > 찾을 수 없음
SELECT
	name
FROM tblcountry
	WHERE population = 120660;
	

-- 오류! where에 집계함수를 사용할 수 없다
SELECT
	name
FROM tblcountry
	WHERE population = max(population);

--sub query > 소괄호 필수
SELECT
	name
FROM tblcountry
	WHERE population = (SELECT max(population) FROM tblcountry);



-- tblcomedian 몸무가게 가장 많이 나가는 사람의 이름?
SELECT
	max(weight) -- 129
FROM tblcomedian;

--129 직접 입력
SELECT
	*
FROM tblcomedian
	WHERE weight = 129;


SELECT
	*
FROM tblcomedian
	WHERE weight = (SELECT max(weight) FROM tblcomedian);



-- tblinsa 평균 급여보다 많이 받는 직원들?

SELECT
	*
FROM tblinsa WHERE basicpay >= (SELECT avg(basicpay) FROM tblinsa);

--남자(키 166)의 여자친구의 키
SELECT * FROM tblmen;
SELECT * FROM tblwomen;

SELECT * FROM tblwomen WHERE couple = (SELECT name FROM tblmen WHERE height = 166);





/*

	서브쿼리 삽입 위치
	1. 조건절 > 비교값으로 사용
		a. 반환값이 1행 1열 > 단일값 반환 > 상수 취급 > 값 1개
		b. 반환값이 N행 1열 > 다중값 반환 > 열거형 비교 > in 사용
		c. 반환값이 1행 N열 > 다중값 반환 > 그룹 비교 > N컬럼 : N컬럼
		d. 반환값이 N행 N열 > 다중값 반환 > b.와 c. 합침 > in + 그룹비교

*/


-- b.
--급여가 260만원 이상 받는 직원이 근무하는 부서의 직원 명단을 가져오시오.
SELECT
	 *
FROM tblinsa
	WHERE buseo = (급여가 260만원 이상 받는 직원이 근무하는 부서);

--ORA-01427: single-row subquery returns more than one row
-- 하나의 값에 여러개의 결과를 대입할 수 없음
SELECT
	*
FROM tblinsa
	WHERE buseo = (SELECT buseo FROM tblinsa WHERE basicpay >= 2600000);


SELECT buseo FROM tblinsa WHERE basicpay >= 2600000; -- 총무부, 기획부

SELECT * FROM tblinsa WHERE buseo = '총무부' OR buseo = '기획부';
SELECT * FROM tblinsa WHERE buseo IN ('총무부','기획부');

-- in을 사용하면 해결!
SELECT
	*
FROM tblinsa
	WHERE buseo IN (SELECT buseo FROM tblinsa WHERE basicpay >= 2600000);


-- c.
-- '홍길동'과 같은 지역, 같은 부서인 직원 명단을 가져오시오. (서울, 기획부)
SELECT * FROM tblinsa
	WHERE city = '서울' AND buseo = '기획부';

SELECT * FROM tblinsa
	WHERE city = (길동이의 지역) AND buseo = (길동이의 부서);

SELECT * FROM tblinsa
	WHERE city = (SELECT city FROM tblinsa WHERE name = '홍길동')
		AND buseo = (SELECT buseo FROM tblinsa WHERE name = '홍길동');
-- where 1:1 and 1:1
	
	
-- '한석봉'과 같은 지역, 같은 부서인 직원 명단을 가져오시오. (서울, 기획부)
-- 위의 쿼리를 수정
SELECT * FROM tblinsa
	WHERE city = (SELECT city FROM tblinsa WHERE name = '한석봉')
		AND buseo = (SELECT buseo FROM tblinsa WHERE name = '홍길동'); --사람이다보니 실수할 수 있음

-- ORA-00913: too many values
-- 대입할 값은 하나, 결과는 두개
-- 결과의 성질이 두개 다름 in으로도 해결할 수 없음
SELECT * FROM tblinsa
	WHERE city = (SELECT city, buseo FROM tblinsa WHERE name = '홍길동');

-- 대입할 값에도 소괄호 필수
-- 순서와 개수 중요
SELECT * FROM tblinsa
	WHERE (city, buseo) = (SELECT city, buseo FROM tblinsa WHERE name = '홍길동');
-- where 2:2


--d.
-- 급여가 260만원 이상 받은 직원과 같은 부서, 같은지역 > 지역 명단을 가져오시오.

SELECT
	*
FROM tblinsa
	WHERE (buseo, city) IN (SELECT buseo, city FROM tblinsa WHERE basicpay >= 2600000);






/*

	서브쿼리 삽입 위치
	1. 조건절 > 비교값으로 사용
		a. 반환값이 1행 1열 > 단일값 반환 > 상수 취급 > 값 1개
		b. 반환값이 N행 1열 > 다중값 반환 > 열거형 비교 > in 사용
		c. 반환값이 1행 N열 > 다중값 반환 > 그룹 비교 > N컬럼 : N컬럼
		d. 반환값이 N행 N열 > 다중값 반환 > b.와 c. 합침 > in + 그룹비교
		
	2. 컬럼리스트 > 출력값으로 사용
		- 반드시 결과값이 1행 1열이어야 한다. > 스칼라 쿼리 > 원자값(단일값)을 반환하는 쿼리
		a. 정적 쿼리 > 모든 행에 동일한 값을 반환
		b. 상관 서브 쿼리(*****매우중요*****) > 서브쿼리의 값과 바깥쪽 메인쿼리의 값을 서로 연결지어 질의하는 형태

*/

SELECT
	name, buseo, basicpay,
	(SELECT * FROM dual)
FROM tblinsa;

--a. 정적 쿼리
-- 되긴 되지만 60명 전원 같은 데이터 의미가 ..? 보통은 쓸모업다
SELECT
	name, buseo, basicpay,
	(SELECT round(avg(basicpay)) FROM tblinsa) AS 회사평균급여
FROM tblinsa;


-- ORA-01427: single-row subquery returns more than one row
SELECT
	name, buseo, basicpay,
	(SELECT jikwi FROM tblinsa)
FROM tblinsa;

-- 홍길동의 직위만
SELECT
	name, buseo, basicpay,
	(SELECT jikwi FROM tblinsa WHERE num = 1001)
FROM tblinsa;

-- ORA-00913: too many values
SELECT
	name, buseo, basicpay,
	(SELECT jikwi, sudang FROM tblinsa WHERE num = 1001)
FROM tblinsa;



-- b. 상관 서브 쿼리
-- 개인별로 다른 값
SELECT
	name, buseo, basicpay,
	(SELECT round(avg(basicpay)) FROM tblinsa WHERE buseo = a.buseo) AS 부서평균급여
FROM tblinsa a;


SELECT * FROM tblmen;
SELECT * FROM tblwomen;

--남자(이름, 키, 몸무게) + 여자(이름, 키, 몸무게)
SELECT
	name AS 남자이름,
	height AS 남자키,
	weight AS 남자몸무게,
	couple AS 여자이름,
	(SELECT height FROM tblwomen WHERE name = tblmen.couple) AS 여자키,
	(SELECT weight FROM tblwomen WHERE name = tblmen.couple) AS 여자몸무게
FROM tblmen;




/*

	서브쿼리 삽입 위치
	1. 조건절 > 비교값으로 사용
		a. 반환값이 1행 1열 > 단일값 반환 > 상수 취급 > 값 1개
		b. 반환값이 N행 1열 > 다중값 반환 > 열거형 비교 > in 사용
		c. 반환값이 1행 N열 > 다중값 반환 > 그룹 비교 > N컬럼 : N컬럼
		d. 반환값이 N행 N열 > 다중값 반환 > b.와 c. 합침 > in + 그룹비교
		
	2. 컬럼리스트 > 출력값으로 사용
		- 반드시 결과값이 1행 1열이어야 한다. > 스칼라 쿼리 > 원자값(단일값)을 반환하는 쿼리
		a. 정적 쿼리 > 모든 행에 동일한 값을 반환
		b. 상관 서브 쿼리(*****매우중요*****) > 서브쿼리의 값과 바깥쪽 메인쿼리의 값을 서로 연결지어 질의하는 형태

	3. FROM절에서 사용
		-서브쿼리의 결과테이블을 하나의 테이블이라고 생각하고 메인 쿼리를 실행
		- 인라인 뷰(Inline View)
		
		
		
*/


SELECT						--4.
	*
FROM						--1. 
	(
		SELECT name, buseo	--3.
		FROM tblinsa		--2.
	);

-- ORA-00904: "SSN": invalid identifier
SELECT name, substr(ssn, 1, 8) FROM (SELECT name, substr(ssn, 1, 8) FROM tblinsa);

-- 인라인뷰의 컬럼 별칭 > 바깥쪽 메인 쿼리에서 그대로 전달 + 사용
SELECT name, gender
FROM (SELECT name, substr(ssn, 1, 8) AS gender FROM tblinsa);

-- ORA-00960: ambiguous column naming in select list
-- 별칭 > 컬럼 이름이 중복됨
SELECT
	name, height, couple,
	(SELECT height FROM tblwomen WHERE name = tblmen.couple) AS height
FROM tblmen
	ORDER BY height;

-- 컬럼 이름을 다르게 만들어야한다.
SELECT
	name, height, couple,
	(SELECT height FROM tblwomen WHERE name = tblmen.couple) AS height2
FROM tblmen
	ORDER BY height2;
	
