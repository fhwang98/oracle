--ex11_casting_function.sql


/*
	
	형변환 함수
	- (int)num
	
	1. to_char(숫자) : 숫자 > 문자
	2. to_char(날짜) : 날짜 > 문자 ***
	3. to_number(문자) : 문자 > 숫자
	4. to_date(문자) : 문자 > 날짜 ***


	1. to_char(숫자 [, 형식문자열)
	
	형식 문자열 구성요소
	a. 9 : 숫자 1개를 문자 1개로 바꾸는 역할. 빈자리를 스페이스로 치환.	(java > %5d)
	b. 0 : 숫자 1개를 문자 1개로 바꾸는 역할. 빈자리를 0으로 치환.	(java > %05d)
	c. $ : 통화 기호 표현
	d. L : 통화 기호 표현(Locale)
	e. . : 소숫점
	f. , : 천단위 표기


*/

SELECT
	weight,
	to_char(weight),
	length(to_char(weight)), -- 문자열 함수
	length(weight), -- weight > (암시적 형변환) > 문자열 //sql이 알아서...
	substr(weight, 1, 1),
	weight || 'kg',
	to_char(weight || 'kg')
FROM tblcomedian;


SELECT
	weight,
	'@' || to_char(weight) || '@' , 
	'@' || to_char(weight, '99999') || '@', -- @    64@ 5자리 + 1부호 > 총 6자리
	'@' || to_char(-weight, '99999') || '@', -- @   -64@
	'@' || to_char(weight, '00000') || '@', -- @ 00064@
	'@' || to_char(-weight, '00000') || '@' -- @-00064@
FROM tblcomedian;

SELECT
	100,
	'$' || 100,
	to_char(100, '$999'),
	-- to_char(100, '999달러'), 달러 > 아무거나 오면 안됨
	100 || '달러',
	to_char(100, 'L999')
FROM dual;

SELECT
	1234567.89,
	to_char(1234567.89, '9,999,999.9'), --%,d 이렇게 안되고 직접 찍어줘야됨..
	ltrim(to_char(567.89, '9,999,999.9')),
	to_char(2341234567.89, '9,999,999.9') -- 내가 지정한 자릿수를 넘어가면 동작 안함!
FROM dual;

/*
	2. to_char(날짜)
	- 날짜 > 문자
	- char to_char(컬럼, 형식문자열)
	
	형식문자열 구성요소
	a. yyyy
	b. yy
	c. month
	d. mon
	e. mm
	f. day
	g. dy
	h. ddd
	i. dd
	j. d
	k. hh
	1. hh24
	m. mi
	n. ss
	o. am(pm)
	


*/

SELECT sysdate FROM dual;

SELECT to_char(sysdate) FROM dual; 
SELECT to_char(sysdate, 'yyyy') FROM dual;	--년(4자리)
SELECT to_char(sysdate, 'yy') FROM dual;	--년(2자리)
SELECT to_char(sysdate, 'month') FROM dual;	--월(풀네임) August
SELECT to_char(sysdate, 'mon') FROM dual;	--월(약어) Aug
SELECT to_char(sysdate, 'mm') FROM dual;	--월(2자리)
SELECT to_char(sysdate, 'day') FROM dual;	--요일(풀네임) 
SELECT to_char(sysdate, 'dy') FROM dual;	--요일(약어)
SELECT to_char(sysdate, 'ddd') FROM dual;	--일(올해의 며칠)
SELECT to_char(sysdate, 'dd') FROM dual;	--일(이번달의 며칠)
SELECT to_char(sysdate, 'd') FROM dual;		--일(이번주의 며칠) == 요일(숫자) --일요일1 토요일7
SELECT to_char(sysdate, 'hh') FROM dual;	--시(12시간 체계)
SELECT to_char(sysdate, 'hh24') FROM dual;	--시(24시간 체계)
SELECT to_char(sysdate, 'mi') FROM dual;	--분
SELECT to_char(sysdate, 'ss') FROM dual;	--초
SELECT to_char(sysdate, 'am') FROM dual;	--오전/오후
SELECT to_char(sysdate, 'pm') FROM dual;	--오전/오후


-- 암기!!
SELECT
	sysdate,
	to_char(sysdate, 'yyyy-mm-dd'),
	to_char(sysdate, 'hh24:mi:ss'),
	to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss'),
	to_char(sysdate, 'day am hh:mi:ss') --화요일 오후 02:48:20
FROM dual;


SELECT
	name,
	to_char(ibsadate, 'yyyy-mm-dd') AS ibsadate,
	to_char(ibsadate, 'day') AS DAY,
	CASE
		WHEN to_char(ibsadate, 'd') IN ('1', '7') THEN '휴일입사'
		ELSE '평일입사'
	END
FROM tblinsa;


-- 요일별 입사 인원수?
SELECT
	count(CASE
		WHEN to_char(ibsadate, 'd') = '1' THEN 1
	END) AS 일요일,
	count(decode(to_char(ibsadate, 'd'), '2', 1)) AS 월요일,
	count(decode(to_char(ibsadate, 'd'), '3', 1)) AS 화요일,
	count(decode(to_char(ibsadate, 'd'), '4', 1)) AS 수요일,
	count(decode(to_char(ibsadate, 'd'), '5', 1)) AS 목요일,
	count(decode(to_char(ibsadate, 'd'), '6', 1)) AS 금요일,
	count(decode(to_char(ibsadate, 'd'), '7', 1)) AS 토요일
FROM tblinsa;


-- SQL에는 날짜 상수(리터럴)이 없다.

--입사 날짜 > 2000년 이후
SELECT * FROM tblinsa WHERE ibsadate >= '2000-01-01'; -- 문자열 > 암시적 형변환

--입사 날짜 > 2000년
SELECT * FROM tblinsa
	WHERE ibsadate >= '2000-01-01' AND ibsadate <= '2000-12-31'; -- 오답!! 2000-12-31 00:00:00 -> 그이후에 입사한 데이터 x
	
--SELECT * FROM tblinsa
--	WHERE ibsadate >= '2000-01-01 00:00:00' AND ibsadate <= '2000-12-31 23:59:59'; -- 안됨

SELECT * FROM tblinsa
	WHERE to_char(ibsadate, 'yyyy') = '2000';
	

-- 3. number to_number(문자)

SELECT
	'123' * 2, -- 굳이 to_number() 안해줘도 암시적 형변환 자동으로 .. 
	to_number('123') * 2
FROM dual;

-- 4. date to_date(문자, 형식문자열)

SELECT
	'2023-08-29', -- 자료형? 문자 vs 날짜
	to_date('2023-08-29'), -- 날짜
	to_date('2023-08-29', 'yyyy-mm-dd'),
	to_date('20230829'),
	to_date('20230829', 'yyyymmdd'),
	to_date('2023/08/29'),
	to_date('2023/08/29', 'yyyy/mm/dd'),
	--to_date('2023년08월29일', 'yyyy년mm월dd일')
	to_date('2023-08-29 15:28:39', 'yyyy-mm-dd hh24:mi:ss')
FROM dual;

SELECT * FROM tblinsa
	WHERE ibsadate >= to_date('2000-01-01 00:00:00', 'yyyy-mm-dd hh24:mi:ss')
	AND ibsadate <= to_date('2000-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
