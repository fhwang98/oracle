-- ex24_pseudo.sql

/*
	의사 컬럼, Pseudo Column
	- 실제 컬럼이 아닌데 컬럼처럼 행동하는 객체
	
	rownum
	- 오라클 전용
	- MS-SQL(top n)
	- MySQL(limit n, m)
	- 행번호
	- 시퀀스 객체와 아무 상관X
	- 현재 테이블의 행번호를 가져오는 역할
	- 테이블에 저장된 값이 아니라, select 실행 시 동적으로 계산되어 만들어진다.(******)
	- from 절이 실행될 때 각 레코드에 rownum을 할당한다.(******************)
	- where절이 실행될 때 상황에 따라 rownum 재계산된다.(********) > from절에서 만들어진 rownum은 where절이 실행될 때 변경될 수 있다. 

*/


SELECT
	name, buseo, --컬럼(속성) > OUTPUT > 객체(레코드)의 특성에 따라 다른 값을 가진다.
	100, --상수 > OUTPUT > 모든 레코드가 동일한 값을 가진다.(쓸일이 거의 없음)
	substr(name, 2), --함수 > INPUT + OUTPUT > 객체의 특성에 따라 다른 값을 가진다.
	rownum --의사컬럼 > OUTPUT
FROM tblinsa;

-- rownum 사용
-- 게시판 > 페이지
-- 1페이지 > rownum between 1 and 20
-- 2페이지 > rownum between 21 and 40
-- 3페이지 > rownum between 41 and 60
-- ... 
--등수를 통해 부분추출



SELECT
	 name, buseo, rownum
FROM tblinsa
	WHERE rownum = 1;

SELECT
	 name, buseo, rownum
FROM tblinsa
	WHERE rownum <= 5;


-- 결과 없음
SELECT
	 name, buseo, rownum
FROM tblinsa
	WHERE rownum = 5;

-- 결과 없음
SELECT
	 name, buseo, rownum
FROM tblinsa
	WHERE rownum > 5 AND rownum <= 10;



SELECT						--2. 소비 > 1에서 만든 rownum을 가져온다.(여기서 생성X)
	 name, buseo, rownum
FROM tblinsa;				--1. 생성 > from절이 실행되는 순간 모든 레코드에 rownum 할당한다.


-- 이건 되는데
SELECT						-- 3. 소비
	 name, buseo, rownum
FROM tblinsa				-- 1. 생성
	WHERE rownum = 1;		-- 2. 조건을 검색
	
-- 왜 이건 안되지?
SELECT						-- 3. 소비
	 name, buseo, rownum
FROM tblinsa				-- 1. 생성
	WHERE rownum = 3;		-- 2. 조건을 검색
-- 처음 rownum = 3?? 확인 > 조건만족x > 첫번째 레코드 버림 > 번호 다시 1부터 매겨짐 > .... 영원히반복
-- 1이 포함되지 않으면 결과가 나올 수 없다

	

SELECT
	name, buseo, basicpay, rownum
FROM tblinsa						--1. rownum 할당
	ORDER BY basicpay DESC;			--2. 정렬
	
-- *** 내가 원하는 순서대로 정렬 후 > rownum을 할당하는 방법 > 서브쿼리 사용(***)
SELECT
	name, buseo, basicpay, rownum, rnum
FROM (SELECT name, buseo, basicpay, rownum AS rnum
		FROM tblinsa
		ORDER BY basicpay DESC)
	WHERE rownum <= 3;
-- 안쪽 rownum 별칭 지정하지 않으면 덮어쓰기됨
	
	
--급여 5~10등까지
--원하는 범위 추출(1이 포함x) > rownum 사용 불가능
-- 1. 내가 원하는 순서대로 정렬한다.
-- 2. 1을 서브쿼리로 묶는다. + 그 때의 rownum을 구한다. (rnum)
-- 3. 2를 서브쿼리로 묶는다. + rownum(불필요) + rnum(사용***)
SELECT
	name, buseo, basicpay, rnum, rownum
FROM (SELECT
		name, buseo, basicpay, rownum AS rnum	-- 2.
		FROM (SELECT name, buseo, basicpay
			FROM tblinsa
			ORDER BY basicpay DESC))			-- 1.
	WHERE rnum BETWEEN 5 AND 10;	
	

--페이징 > 나눠서 보기 > 한번에 20명씩 보기 + 이름순 정렬
SELECT * FROM tbladdressbook; --2000건

--1. 내가 원하는 대로 정렬한다.
SELECT * FROM tbladdressbook ORDER BY name;

--2. 1을 서브쿼리로 묶고 rownum을 구한다.
SELECT
	a.*, rownum -- *(와일드카드)와 개별 컬럼을 그냥 적을 수 없다. 앞에 테이블명을 적어준다.
FROM (SELECT * FROM tbladdressbook ORDER BY name) a;
	
--3. rownum을 조건으로 사용 > 한번 더 서브쿼리로 묶는다.
SELECT *
FROM (SELECT
			a.*, rownum AS rnum
		FROM (SELECT * FROM tbladdressbook ORDER BY name) a);

-- 1page
SELECT *
FROM (SELECT
			a.*, rownum AS rnum
		FROM (SELECT * FROM tbladdressbook ORDER BY name) a)
	WHERE rnum BETWEEN 1 AND 20;

-- 2page
SELECT *
FROM (SELECT
			a.*, rownum AS rnum
		FROM (SELECT * FROM tbladdressbook ORDER BY name) a)
	WHERE rnum BETWEEN 21 AND 40;

-- last page
SELECT *
FROM (SELECT
			a.*, rownum AS rnum
		FROM (SELECT * FROM tbladdressbook ORDER BY name) a)
	WHERE rnum BETWEEN 1981 AND 2000;

--view로 만들어서 사용 가능
-- ORA-00998: must name this expression with a column alias
-- rownum에 alias 필수
CREATE OR REPLACE VIEW vwaddressbook
AS
SELECT
	a.*, rownum AS rnum
	FROM (SELECT * FROM tbladdressbook ORDER BY name) a;

SELECT * FROM vwaddressbook;

SELECT * FROM vwaddressbook
	WHERE rnum BETWEEN 1 AND 20;	














