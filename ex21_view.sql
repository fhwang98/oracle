--ex21_view.sql


/*

	View, 뷰
	- 데이터베이스 객체 중 하나(테이블, 제약사항, 뷰, 시퀀스)
	- 가상 테이블, 뷰 테이블 등..
	- 테이블처럼 사용한다.(*****)
	- 쿼리의 양을 줄인다.
	
	- 정의 : 쿼리(SQL)을 저장하는 객체
	- 목적 : 권한 통제
	 
	
	create [or replace] view 뷰이름
	as 
	select문;
	
	
*/

CREATE OR REPLACE VIEW vwinsa
AS
SELECT * FROM tblinsa;

SELECT * FROM vwinsa; --tblinsa 테이블의 복사본 > 실명 뷰
SELECT * FROM (SELECT * FROM tblinsa); -- 인라인 뷰 > 익명 뷰

--영업부 직원
CREATE OR REPLACE VIEW 영업부
AS
SELECT num, name, city, basicpay, substr(ssn, 8) AS ssn 
FROM tblinsa
	WHERE buseo = '영업부';


SELECT * FROM 영업부;



-- 비디오 대여점 사장 > 날마다 > 업무
CREATE OR REPLACE VIEW vwCheck
AS
SELECT
	m.name AS 회원,
	v.name AS 비디오,
	r.rentdate AS 언제,
	r.retdate AS 반납
FROM tblrent r
	INNER JOIN tblvideo v
		ON r.video = v.seq
			INNER JOIN tblmember m
				ON r.MEMBER = m.seq;

SELECT * FROM vwcheck;


-- 연체 일수??
-- 대여 기간 > tblgenre > period
SELECT * FROM tblgenre;

CREATE OR REPLACE VIEW vwcheck
AS
SELECT
	m.name AS 회원,
	v.name AS 비디오,
	r.rentdate AS 언제,
	r.retdate AS 반납,
	g.period AS 대여기간,
	r.rentdate + g.period AS 반납예정일,
	round(sysdate - (r.rentdate + g.period)) AS 연체일,
	-- 10% 씩 연체료
	round((sysdate - (r.rentdate + g.period)) * g.price * 0.1) AS 연체료
FROM tblrent r
	INNER JOIN tblvideo v
		ON r.video = v.seq
			INNER JOIN tblmember m
				ON r.MEMBER = m.seq
					INNER JOIN tblgenre g
						ON v.genre = g.seq;

SELECT * FROM vwcheck;







--tblinsa > 서울 직원 > view
CREATE OR REPLACE VIEW vwSeoul
as
SELECT * FROM tblinsa WHERE city = '서울'; -- 뷰를 만드는 시점 > 서울 20명
SELECT * FROM vwseoul; --20명

UPDATE tblinsa SET city = '제주' WHERE num IN (1001, 1005, 1008); --원본 테이블 수정
SELECT * FROM tblinsa WHERE city = '서울'; -- 17명
SELECT * FROM vwseoul; --17명




-- 신입사원 잆사 > 업무 > 연락처 확인 > 문자 발송! > hr(java1234)
SELECT * FROM tblinsa; 	-- 신입 계정 > tblinsa 접근 권한(X)
SELECT * FROM vwtel;	-- 신입 계정 > vwtel 접근 읽기 권한(O)

CREATE OR REPLACE VIEW vwTel
AS
SELECT name, buseo, jikwi, tel FROM tblinsa;


--면접 > 뷰에 대해 설명해 주세요 > 자주 사용하는 select문을 저장하는 오브젝트입니다
-- 목적은? 자주 사용하는 쿼리를 간단하게 사용하거나 접근권한을 통제하기 위해 사용합니다.



-- 뷰 사용 주의점!!!
-- 1. select > 실행O > 뷰는 읽기 전용으로 사용한다. == 읽기 전용 테이블
-- 2. insert > 실행O > 절대 사용 금지
-- 3. update > 실행O > 절대 사용 금지
-- 4. delete > 실행O > 절대 사용 금지


-- 단순뷰 > 뷰의 select가 1개의 테이블로 구성
-- 2,3,4 되긴됨
-- 하지마시오
CREATE OR REPLACE VIEW vwtodo 
AS
SELECT * FROM tbltodo; -- 이렇게 사용할 일은 없음


SELECT * FROM tbltodo;
SELECT * FROM vwtodo;

INSERT INTO vwtodo VALUES ((SELECT max(seq) + 1 FROM tbltodo), '할일', sysdate, null);

UPDATE vwtodo SET title = '할일 완료' WHERE seq = 25;


DELETE vwtodo WHERE seq = 25;


-- 복합뷰
-- 뭐가 단순뷰고 뭐가 복합뷰인지 구별할수없다...
-- 2,3,4 절대하면안됨
SELECT * FROM vwtodo;
SELECT * FROM vwcheck;