--ex22_union.sql

/*

	관계 대수 연산
	1. 셀렉션 > select where
	2. 프로젝션 > select column
	3. 조인
	4. 합집합(union), 차집합(minus), 교집합(intersect)

	유니온, union
	- 스키마가 동일한 결과셋끼리만 가능
	 
*/


SELECT * FROM tblmen
UNION
SELECT * FROM tblwomen;


SELECT * FROM tblstaff
UNION
SELECT * FROM tblinsa;


-- 컬럼의 이름은 중요하지 않고 안에 들어있는 자료형이 맞으면 됨
SELECT name, address, salary FROM tblstaff
UNION
SELECT name, city, basicpay FROM tblinsa;


--사용하는 경우

-- 어떤 회사 > 부서별 게시판
SELECT * FROM 영업부게시판;
SELECT * FROM 총무부게시판;
SELECT * FROM 개발부게시판;


-- 회장님 > 모든 부서의 게시판 글 > 한번에 열람
SELECT * FROM 영업부게시판
union
SELECT * FROM 총무부게시판
union
SELECT * FROM 개발부게시판;


-- 야구선수 > 공격수, 수비수
SELECT * FROM 공격수;
SELECT * FROM 수비수;

SELECT * FROM 공격수
union
SELECT * FROM 수비수;



-- SNS > 하나의 테이블 + 다량의 데이터 > 기간별 테이블 분할
SELECT * FROM 게시판2020;
SELECT * FROM 게시판2021;
SELECT * FROM 게시판2022;
SELECT * FROM 게시판2023;

SELECT * FROM 게시판2020
union
SELECT * FROM 게시판2021
union
SELECT * FROM 게시판2022
union
SELECT * FROM 게시판2023;


CREATE TABLE tblaaa (
	name varchar2(30) NOT NULL
);



CREATE TABLE tblbbb (
	name varchar2(30) NOT NULL
);


INSERT INTO tblaaa VALUES ('강아지');
INSERT INTO tblaaa VALUES ('고양이');
INSERT INTO tblaaa VALUES ('토끼');
INSERT INTO tblaaa VALUES ('거북이');
INSERT INTO tblaaa VALUES ('병아리');

INSERT INTO tblbbb VALUES ('강아지');
INSERT INTO tblbbb VALUES ('고양이');
INSERT INTO tblbbb VALUES ('호랑이');
INSERT INTO tblbbb VALUES ('사자');
INSERT INTO tblbbb VALUES ('코끼리');

SELECT * FROM tblaaa;
SELECT * FROM tblbbb;


--union > 수학의 집합 > 중복 제거
SELECT * FROM tblaaa
UNION
SELECT * FROM tblbbb;

-- union all > 중복값 허용
SELECT * FROM tblaaa
UNION ALL 
SELECT * FROM tblbbb;


--intersect > 교집합
SELECT * FROM tblaaa
INTERSECT
SELECT * FROM tblbbb;


--minus > 차집합
-- 피연산자의 위치가 중요하다
SELECT * FROM tblaaa
MINUS
SELECT * FROM tblbbb;

SELECT * FROM tblbbb
MINUS
SELECT * FROM tblaaa;














