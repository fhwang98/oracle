--ex18_groupby.sql

/*

	[WITH <Sub Query>]
    SELECT column_list
    FROM table_name
    [WHERE search_condition]
    [GROUP BY group_by_expression]
    [HAVING search_condition]
    [ORDER BY order_expression [ASC|DESC]]
    
    select 컬럼리스트	4. 컬럼 지정 (보고싶은 열만 가져오기) > Projection
    from 테이블		1. 테이블 지정
    where 조건		2. 조건 지정 (보고싶은 행만 가져오기) > Selection
    group by 기준		3. (레코드끼리) 그룹을 나눈다. 
    order by 정렬기준	5. 순서대로 


*/

-- tblinsa 부서별 평균 급여?
SELECT * FROM tblinsa;

SELECT round(avg(basicpay)) FROM tblinsa; -- 155만원, 전체 60명

SELECT DISTINCT buseo FROM tblinsa; -- 7개

SELECT round(avg(basicpay)) FROM tblinsa WHERE buseo = '총무부'; -- 171만원
SELECT round(avg(basicpay)) FROM tblinsa WHERE buseo = '개발부'; -- 138만원
SELECT round(avg(basicpay)) FROM tblinsa WHERE buseo = '영업부'; -- 160만원
SELECT round(avg(basicpay)) FROM tblinsa WHERE buseo = '기획부'; -- 185만원
SELECT round(avg(basicpay)) FROM tblinsa WHERE buseo = '인사부'; -- 153만원
SELECT round(avg(basicpay)) FROM tblinsa WHERE buseo = '자재부'; -- 141만원
SELECT round(avg(basicpay)) FROM tblinsa WHERE buseo = '홍보부'; -- 145만원


-- ***** group by 목적 > 그룹별 통계값을 구하기 위해서!! > 집계함수 사용
SELECT
	buseo,
	count(*) AS "부서별 인원수",
	round(avg(basicpay)) AS "부서별 평균급여",
	sum(basicpay) AS "부서별 지급액",
	max(basicpay) AS "부서내 최고 급여", 
	min(basicpay) AS "부서내 최저 급여"
FROM tblinsa
	GROUP BY /*그룹을 짓기 위한 기준 컬럼*/buseo;
	

SELECT
	count(decode(gender, 'm', 1)) AS 남자수,
	count(decode(gender, 'f', 1)) AS 여자수
FROM tblcomedian;


SELECT
	gender,
	count(*) AS 인원수
FROM tblcomedian
	GROUP BY gender;



-- tblinsa 부장, 과장, 대리 사원 각각 몇명?
SELECT
	jikwi,
	count(*)
FROM tblinsa
	GROUP BY jikwi;


SELECT
	gender,
	max(height),
	min(height),
	max(weight),
	min(weight),
	avg(weight),
	avg(height)
FROM tblcomedian
	GROUP BY gender;




-- ORA-00979: not a GROUP BY expression
-- group by 사용시 > select 컬럼리스트 > 일반 커럼 명시 불가능 > 집계함수 + 그룹 컬럼
SELECT
	count(*),	-- 집계함수 : 집합에 대한 데이터
	buseo		-- GROUP BY의 기준이 되는 컬럼
	-- *		-- 일반 컬럼 : 개개인에 관련한 데이터
	-- name		-- 일반 컬럼 : 개개인에 관련한 데이터
FROM tblinsa
	GROUP BY buseo;



-- 다중 그룹
SELECT
	buseo,
	jikwi,
	count(*)
FROM tblinsa
	GROUP BY buseo, jikwi
		ORDER BY buseo, jikwi;

-- 급여별 그룹
-- 100만원 이하
-- 100만원 ~ 200만원
-- 200만원 이상
SELECT
	basicpay,
	count(*)
FROM tblinsa
	GROUP BY basicpay;
	
SELECT
	basicpay,
	floor(basicpay / 1000000)
FROM tblinsa;

SELECT
	(floor(basicpay / 1000000) + 1) * 100 || '만원 이하' AS money,
	count(*)
FROM tblinsa
	GROUP BY floor(basicpay / 1000000); -- 가공된 값도 그룹의 대상이 될 수 있다


-- tblinsa 남자/여자 직원수?
SELECT
	substr(ssn, 8, 1),
	count(*)
FROM tblinsa
	GROUP BY substr(ssn, 8, 1);


-- null , not null로 그룹화
SELECT
	count(CASE
		WHEN completedate IS NOT NULL THEN 1
	END) AS 완료,
	count(CASE
		WHEN completedate IS NULL THEN 1
	END)AS 미완료
FROM tbltodo;

SELECT
	CASE
		WHEN completedate IS NOT NULL THEN 1
		ELSE 2
	END,
	count(*)
FROM tbltodo
	GROUP BY CASE
		WHEN completedate IS NOT NULL THEN 1
		ELSE 2
	END;




/*

	[WITH <Sub Query>]
    SELECT column_list
    FROM table_name
    [WHERE search_condition]
    [GROUP BY group_by_expression]
    [HAVING search_condition]
    [ORDER BY order_expression [ASC|DESC]]
    
    select 컬럼리스트	5. 컬럼 지정
    from 테이블		1. 테이블 지정
    where 조건		2. 조건 지정 (레코드에 대한 조건 - 개인 조건 > 컬럼)
    group by 기준		3. (레코드끼리) 그룹을 나눈다.
    having 조건		4. 조건 지정 (그룹에 대한 조건 - 그룹 조건 > 집계 함수)
    order by 정렬기준	6. 순서대로 


*/

/*
SELECT
	count(*)
FROM tblinsa
	WHERE basicpay >= 1500000;
*/


-- 
SELECT							--4. 각 그룹별 > 집계 함수
	buseo,
	round(avg(basicpay))
FROM tblinsa					--1. 60명의 데이터를 가져온다.
	WHERE basicpay >= 1500000	--2. 60명을 대상으로 조건을 검사한다. 
		GROUP BY buseo;			--3. 2번을 통과한 사람들(27명) 대상으로 그룹을 짓는다.


SELECT									--4 남은 그룹들 > 집계함수
	buseo,
	round(avg(basicpay))
FROM tblinsa							--1. 
	GROUP BY buseo						--2.
		HAVING avg(basicpay) >= 1500000;--3. 그룹에 대한 조건 (조건을 만족하지 못한 그룹은 탈락)


-- 부서의 인원수가 10명이 넘는 결과

SELECT
	buseo,
	count(*)
FROM tblinsa
	GROUP BY buseo
		HAVING count(*) >= 10;


-- 부서의 과장/부장(where) 인원수가 3명이 넘는(having) 결과
SELECT
	buseo,
	count(*)
FROM tblinsa
	WHERE jikwi IN ('과장', '부장')
	GROUP BY buseo
		HAVING count(*) >= 3; 
	

	-- job_id 그룹 > 통계
SELECT
	job_id,
	count(*) AS 인원수,
	round(avg(salary)) AS 평균급여
FROM employees
	GROUP BY job_id;
	

-- 시, 도별 인원수?
 SELECT * FROM tbladdressbook;

SELECT
 	-- substr(컬럼, 시작위치, 문자개수)
 	substr(address, 1, instr(address, ' ') - 1)
 FROM tbladdressbook;

 SELECT
 	substr(address, 1, instr(address, ' ') - 1) AS 시도,
 	count(*) AS 인원수
 FROM tbladdressbook
	GROUP BY substr(address, 1, instr(address, ' ') - 1)
		ORDER BY 인원수 desc;

-- 부서별 / 직급별 인원수를 가져오시오.
/*
	[부서명] [총인원] [부장] [과장] [대리] [사원]
	기획부	7		2	  0		3	 2
 */
--1.
SELECT
	buseo AS 부서명,
	count(*) AS 총인원,
	count(decode(jikwi,'부장',1)) AS 부장,
	count(decode(jikwi,'과장',1)) AS 과장,
	count(decode(jikwi,'대리',1)) AS 대리,
	count(decode(jikwi,'사원',1)) AS 사원
FROM tblinsa
	GROUP BY buseo;
	
--2.
SELECT
	buseo,
	jikwi,
	count(*)
FROM tblinsa
	GROUP BY buseo, jikwi
	ORDER BY buseo, jikwi;
	
	


/*	
	rollup()
	- group by를 쓸때만 사용할 수 있는 함수
	- group by의 집계 결과를 좀 더 자세하게 반환
	- 그룹별 중간 통계

*/

	
SELECT
	buseo,
	count(*),
	sum(basicpay),
	round(avg(basicpay)),
	max(basicpay),
	min(basicpay)
FROM tblinsa
	GROUP BY ROLLUP(buseo);
	
	
	
SELECT
	buseo,
	jikwi,
	count(*),
	sum(basicpay),
	round(avg(basicpay)),
	max(basicpay),
	min(basicpay)
FROM tblinsa
	GROUP BY ROLLUP(buseo, jikwi);
	



/*	
	cube()
	- group by를 쓸때만 사용할 수 있는 함수
	- group by의 집계 결과를 좀 더 자세하게 반환
	- 그룹별 중간 통계

*/



SELECT
	buseo,
	count(*),
	sum(basicpay),
	round(avg(basicpay)),
	max(basicpay),
	min(basicpay)
FROM tblinsa
	GROUP BY CUBE(buseo);
	
	
	
SELECT
	buseo,
	jikwi,
	count(*),
	sum(basicpay),
	round(avg(basicpay)),
	max(basicpay),
	min(basicpay)
FROM tblinsa
	GROUP BY CUBE(buseo, jikwi);
		

-- rollup > 다중 그룹 컬럼 > 수직관계 (전체인원 총계, 부서별 총계)
-- cube > 다중 그룹 컬럼 > 수평관계 (전체인원 총계, 부서별 총계, 직위별 총계)





