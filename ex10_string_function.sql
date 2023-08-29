--ex10_string_function.sql

/*
	문자열 함수
	
	대소문자 변환
	-upper(), lower(), initcap()
	- varchar2 upper(컬럼)
	- varchar2 lower(컬럼)
	- varchar2 initcap(컬럼)

*/

SELECT
	first_name,
	upper(first_name),
	lower(first_name)
FROM employees;

SELECT
	'abc',
	initcap('abc'), -- 첫문자를 대문자로
	initcap('aBC') -- 나머지 문자는 소문자로
FROM dual;

--이름(first_name)에 'an' 포함된 작원 > 대소문자 구분없이
SELECT
	first_name
FROM employees
	WHERE first_name LIKE '%an%'  --Anthony
	OR first_name LIKE '%AN%'
	OR first_name LIKE '%An%'
	OR first_name LIKE '%aN%';
	
SELECT
	first_name
FROM employees
	WHERE lower(first_name) LIKE '%an%';
	
/*
	문자열 추출 함수
	- substr() > java substring()
	- varchar2 substr(컬럼, 시작위치, 가져올 문자 개수)
	- varchar2 substr(컬럼, 시작위치) > 끝까지

*/

SELECT
	address,
	substr(address, 3, 5),
	substr(address, 3)
FROM tbladdressbook;


SELECT
	name,
	ssn,
	substr(ssn, 1, 2) AS 생년,
	substr(ssn, 3, 2) AS 생월,
	substr(ssn, 5, 2) AS 생일,
	substr(ssn, 8, 1) AS 성별
FROM tblinsa;

-- tblinsa > 김, 이, 박, 최, 정 > 각각 몇명?
SELECT count(*) FROM tblinsa WHERE substr(name, 1, 1) = '김';

SELECT
	count(CASE
		WHEN substr(name, 1, 1) = '김' THEN 1
	END) AS 김,
	count(CASE
		WHEN substr(name, 1, 1) = '이' THEN 1
	END) AS 이,
	count(CASE
		WHEN substr(name, 1, 1) = '박' THEN 1
	END) AS 박,
	count(CASE
		WHEN substr(name, 1, 1) = '최' THEN 1
	END) AS 최,
	count(CASE
		WHEN substr(name, 1, 1) = '정' THEN 1
	END) AS 정,
	count(CASE
		WHEN substr(name, 1, 1) NOT IN ('김', '이', '박', '최', '정') THEN 1
	END) AS 나머지
FROM tblinsa;



/*
	문자열 길이
	- length()
	- number length(칼럼)

*/

-- 컬럼 리스트에서 사용
SELECT name, length(name) FROM tblcountry;

-- 조건절에서 사용
SELECT name, length(name) FROM tblcountry WHERE length(name) > 3;

-- SELECT name, length(name) AS leng FROM tblcountry WHERE leng > 3; 오류, 실행 순서 
SELECT name, length(name) AS leng FROM tblcountry ORDER BY leng ASC;

-- 정렬에서 사용
SELECT name, length(name) FROM tblcountry ORDER BY length(name) DESC;


/*
	문자열 검색(indexOf)
	- instr()
	- 검색어의 위치 반환
	- number instr(컬럼, 검색어)
	- number instr(컬럼, 검색어, 시작위치)
	- number instr(컬럼, 검색어, 시작위치, -1) --lastIndexOf
	- 못찾으면 0 반환

*/

SELECT 
	'안녕하세요. 홍길동님.',
	instr('안녕하세요. 홍길동님.', '홍길동') AS r1,
	instr('안녕하세요. 홍길동님.', '아무개') AS r2,
	instr('안녕하세요. 홍길동님. 홍길동님', '홍길동') AS r3,
	instr('안녕하세요. 홍길동님. 홍길동님', '홍길동', 11) AS r4,
	instr('안녕하세요. 홍길동님. 홍길동님', '홍길동'
					, instr('안녕하세요. 홍길동님. 홍길동님', '홍길동')
							+ 	LENGTH('홍길동')) AS r5, 
	instr('안녕하세요. 홍길동님. 홍길동님', '홍길동', -1) AS r6
FROM dual;


/*
	패딩
	- lpad(), rpad()
	- left padding, right padding
	- varchar2 lpad(컬럼, 개수, 문자)
	- varchar2 rpad(컬럼, 개수, 문자)
	
*/

SELECT
	lpad('a', 5), -- '    a' (%5s)
	lpad('a', 5, 'b'), -- 'bbbba'
	lpad('aa', 5, 'b'),
	lpad('aaa', 5, 'b'),
	lpad('aaaa', 5, 'b'),
	lpad('aaaaa', 5, 'b'),
	lpad('1', 3, '0'),
	rpad('1', 3, '0')
FROM dual;



/*
	공백 제거
	- trim(), ltrim(), rtrim()
	- varchar2 trim(컬럼)
	- varchar2 ltrim(컬럼)
	- varchar2 rtrim(컬럼)
*/
SELECT
	'     하나     둘     셋     ',
	trim('     하나     둘     셋     '), --'하나     둘     셋'
	ltrim('     하나     둘     셋     '), --'하나     둘     셋     '
	rtrim('     하나     둘     셋     ') -- '     하나     둘     셋'
FROM dual;



/*
	문자열 치환
	- replace()
	- varchar2 replace(컬럼, 찾을 문자열, 바꿀 문자열)
	
	- regexp_replace()

*/

SELECT
	replace('홍길동', '홍', '김'),
	replace('홍길동', '이', '김'),
	replace('홍길홍', '홍', '김')
FROM dual;

SELECT
	name,
	regexp_replace(name, '김.{2}', '김OO'),
	tel,
	regexp_replace(tel, '(\d{3})-(\d{4})-\d{4}', '\1-\2-XXXX')
FROM tblinsa;



/*
	문자열 치환
	- decode()
	- replace()와 유사
	- varchar2 decode(컬럼, 찾을 문자열, 바꿀 문자열, [찾을 문자열, 바꿀 문자열] X N)
	
	- 다중 치환할 때 사용
	- 못찾으면 null을 반환

*/

-- tblcomedian 성별 > 남자, 여자

SELECT
	gender,
	CASE
		WHEN gender = 'm' THEN '남자'
		WHEN gender = 'f' THEN '여자'
	END AS g1,
	replace(gender, 'm', '남자') AS g2,
	replace(replace(gender, 'm', '남자'), 'f', '여자') AS g3, -- 가독성 하락!!!
	decode(gender, 'm', '남자', 'f', '여자') AS g4 -- 못찾으면 null을 반환
FROM tblcomedian;


-- tblcoimedian 남자수? 여자수?
SELECT
	count(CASE
		WHEN gender = 'm' THEN 1
	END) AS m1,
	count(CASE
		WHEN gender = 'f' THEN 1
	END) AS f1, 
	count(decode(gender, 'm', 1)) AS m2,
	count(decode(gender, 'f', 1)) AS f2
FROM tblcomedian;