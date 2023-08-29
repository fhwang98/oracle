-- 문제05.sql


-- 정렬


-- employees
-- 1. 전체 이름(first_name + last_name)이 가장 긴 -> 짧은 사람 순으로 정렬해서 가져오기
--    > 컬럼 리스트 > fullname(first_name + last_name), length(fullname)
SELECT
	first_name || ' ' || last_name AS fullname,
	length(first_name || ' ' || last_name) AS length
FROM employees
	ORDER BY length(fullname) DESC ; 


-- 2. 전체 이름(first_name + last_name)이 가장 긴 사람은 몇글자? 가장 짧은 사람은 몇글자? 평균 몇글자?
--    > 컬럼 리스트 > 숫자 3개 컬럼
SELECT
	max(LENGTH(first_name || last_name)),
	min(LENGTH(first_name || last_name)),
	avg(LENGTH(first_name || last_name))
FROM employees;


-- 3. last_name이 4자인 사람들의 first_name을 가져오기
--    > 컬럼 리스트 > first_name, last_name
--    > 정렬(first_name, 오름차순)
SELECT
	first_name
FROM employees
	WHERE LENGTH(last_name) = 4
	ORDER BY first_name;

-- decode

-- 4. tblInsa. 부장 몇명? 과장 몇명? 대리 몇명? 사원 몇명?
SELECT
	count(decode(jikwi, '부장', 1)) AS 부장,
	count(decode(jikwi, '과장', 1)) AS 과장,
	count(decode(jikwi, '대리', 1)) AS 대리,
	count(decode(jikwi, '사원', 1)) AS 사원
FROM tblinsa;

-- 5. tblInsa. 간부(부장, 과장) 몇명? 사원(대리, 사원) 몇명?
SELECT
	count(decode(jikwi, '부장', 1, '과장', 1)) AS "부장+과장"
	count(decode(jikwi, '대리', 1, '사원', 1)) AS "대리+사원"
FROM tblinsa;


-- 6. tblInsa. 기획부, 영업부, 총무부, 개발부의 각각 평균 급여?
SELECT
	round(avg(decode(buseo, '기획부', basicpay))) AS 기획부,
	round(avg(decode(buseo, '영업부', basicpay))) AS 영업부,
	round(avg(decode(buseo, '총무부', basicpay))) AS 총무부,
	round(avg(decode(buseo, '개발부', basicpay))) AS 개발부
FROM tblinsa;


-- 7. tblInsa. 남자 직원 가장 나이가 많은 사람이 몇년도 태생? 여자 직원 가장 나이가 어린 사람이 몇년도 태생?
SELECT
	substr(max(CASE
		WHEN ssn LIKE '%-1%' THEN ssn
	END), 1, 2) AS 최고령남자생년,
	substr(min(CASE
		WHEN ssn LIKE '%-2%' THEN ssn
	END), 1, 2) AS 최연소여자생년
FROM tblinsa
	ORDER BY ssn;














