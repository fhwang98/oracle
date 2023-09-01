--ex20_join.sql
--0831

/*

	관계형 데이터베이스 시스템이 지양하는 것들
	-테이블을 다시 수정해야 고쳐지는 것들 > 구조적인 문제!
	
	1. 테이블에 기본 키가 없는 상태 > 데이터 조작 곤란
	2. null이 많은 상태의 테이블 > 공간 낭비
	3. 데이터가 중복되는 상태 > 공간 낭비 + 데이터 조작 곤란
	4. 하나의 속성값이 원자값이 아닌 상태 > 더이상 쪼개지지 않는 값을 넣어야 한다.


*/

-- 데이터가 중복되는 상태
CREATE TABLE tblTest
(
	name varchar2(3) NOT NULL,
	age number(3) NOT NULL,
	nick varchar2(30) NOT NULL
);

-- 홍길동, 20, 강아지
-- 아무개, 22, 바보
-- 테스트, 20, 반장
-- 홍길동, 20, 강아지 > 발생(x), 조작(?)

--이럴때 생겨나는 문제
--홍길동 별명 수정
UPDATE tblTest SET nick = '고양이' WHERE name = '홍길동'; --식별 불가능

--홍길동 탈퇴
DELETE FROM tblTest WHERE name = '홍길동'; --식별 불가능


--2. null이 많은 상태의 테이블 > 공간 낭비
CREATE TABLE tblTest
(
	name varchar2(3) PRIMARY KEY,
	age number(3) NOT NULL,
	nick varchar2(30) NOT NULL,
	hobby1 varchar2(100) NULL,
	hobby2 varchar2(100) NULL,
	hobby3 varchar2(100) NULL,
	...
	hobby8 varchar2(100) NULL,
);

--홍길동, 20, 강아지, null, null, null, null, null, null, null, null
--아무개, 22, 고양이, 게임, null, null, null, null, null, null, null
--이순신, 24, 거북이, 수영, 활쏘기, null, null, null, null, null, null
--테스트, 25, 닭, 수영, 독서, 낮잠, 여행, 맛집, 공부, 코딩, 영화
--안됨! 구조 수정해야됨



-- 직원 정보
-- 직원(번호(PK), 직원명, 급여, 거주지, 담당 프로젝트)
CREATE TABLE tblstaff
(
	seq NUMBER PRIMARY KEY,			--직원번호(PK)
	name varchar2(30) NOT NULL,		--직원명
	salary NUMBER NOT NULL,			--급여
	address varchar2(300) NOT NULL,	--거주지
	project varchar2(300)			--담당 프로젝트
);

DROP TABLE tblstaff;

INSERT INTO tblstaff (seq, name, salary, address, project)
	VALUES (1, '홍길동', 300, '서울시', '홍콩 수출');


INSERT INTO tblstaff (seq, name, salary, address, project)
	VALUES (2, '아무개', 250, '인천시', 'TV 광고');

INSERT INTO tblstaff (seq, name, salary, address, project)
	VALUES (3, '하하하', 350, '의정부시', '매출 분석');

SELECT * FROM tblstaff;


--'홍길동'에게 담당 프로젝트 1건 추가
--'홍콩 수출,고객 관리'
-- UPDATE tblstaff SET project = project + ',고객 관리' WHERE seq = '1'; -- 절대 금지

--값이 달라 질 수 있음 이것도 좋은 방법은 아님
INSERT INTO tblstaff (seq, name, salary, address, project)
	VALUES (4, '홍길동', 300, '서울시', '고객 관리');

--이렇게 하면 안됨
INSERT INTO tblstaff (seq, name, salary, address, project)
	VALUES (5, '호호호', 250, '서울시', '게시판 관리,회원 응대');

INSERT INTO tblstaff (seq, name, salary, address, project)
	VALUES (6, '후후후', 250, '부산시', '불량 회원 응대');


-- 'TV 광고' > 담당자 확인
SELECT * FROM tblstaff WHERE project = 'TV 광고';

-- '회원 응대' > 담당자 확인
-- '게시판 관리,회원 응대' > 그냥 찾을 수 없음!
SELECT * FROM tblstaff WHERE project = '회원 응대';
SELECT * FROM tblstaff WHERE project LIKE '%회원 응대%'; --관계없는 레코드도 나옴!

-- '회원 응대' > '멤버 조치' 수정
-- UPDATE tblstaff SET project = '멤버 조치' WHERE project LIKE '%,회원 응대%'; 컴마 앞의 내용은 날아간다... 안됨



-- 해결 > 테이블 재구성
DROP TABLE tblstaff;

--직원 정보
-- 직원(번호(PK), 직원명, 급여, 거주지)
CREATE TABLE tblstaff
(
	seq NUMBER PRIMARY KEY,			--직원번호(PK)
	name varchar2(30) NOT NULL,		--직원명
	salary NUMBER NOT NULL,			--급여
	address varchar2(300) NOT NULL	--거주지
);

--프로젝트 정보
CREATE TABLE tblProject
(
	seq NUMBER PRIMARY KEY,			--프로젝트 번호(PK)
	project varChar2(100) NOT NULL,	--프로젝트명
	staff_seq NUMBER NOT NULL		--담당 직원 번호
);

DROP TABLE tblproject;

INSERT INTO tblstaff (seq, name, salary, address) VALUES (1, '홍길동', 300, '서울시');
INSERT INTO tblstaff (seq, name, salary, address) VALUES (2, '아무개', 250, '인천시');
INSERT INTO tblstaff (seq, name, salary, address) VALUES (3, '하하하', 250, '부산시');


INSERT INTO tblproject (seq, project, staff_seq) values(1, '홍콩 수출', 1); --홍길동
INSERT INTO tblproject (seq, project, staff_seq) values(2, 'TV 광고', 2); --아무개
INSERT INTO tblproject (seq, project, staff_seq) values(3, '매출 분석', 3); --하하하
INSERT INTO tblproject (seq, project, staff_seq) values(4, '노조 협상', 1); --홍길동
INSERT INTO tblproject (seq, project, staff_seq) values(5, '대리점 분양', 2); --아무개

SELECT * FROM tblstaff;
SELECT * FROM tblproject;

--TV 광고 담당자
SELECT staff_seq FROM tblproject WHERE project = 'TV 광고';

SELECT * 
FROM tblstaff 
	WHERE seq = (SELECT staff_seq FROM tblproject WHERE project = 'TV 광고');
	
-- A. 신입사원 입사 > 신규 프로젝트 담당
-- A.1 신입사원 추가
INSERT INTO tblstaff (seq, name, salary, address) VALUES (4, '호호호', 250, '성남시');

--A.2 신규 프로젝트 추가
INSERT INTO tblproject (seq, project, staff_seq) values(6, '자재 매입', 4); --호호호

--A.3 신규 프로젝트 추가 > 잘못됐는데 에러(X) > 논리 오류!!!!
INSERT INTO tblproject (seq, project, staff_seq) values(7, '고객 유치', 5); --5번 직원은 없는데??? 잘들어감

-- 담당자 없음
SELECT * 
FROM tblstaff 
	WHERE seq = (SELECT staff_seq FROM tblproject WHERE project = '고객 유치');

--B. '홍길동' 퇴사
--B.1 '홍길동' 삭제
--프로젝트에는 그대로 '홍길동' 사번 .. 그냥 삭제하면 안됨!
DELETE FROM tblstaff WHERE seq = 1;

-- 담당자 없음
SELECT * 
FROM tblstaff 
	WHERE seq = (SELECT staff_seq FROM tblproject WHERE project = '홍콩 수출');


--B.2 '홍길동' 삭제 전 > 인수인계(위임)
-- 다른 사람에게 프로젝트를 넘김
UPDATE tblproject SET staff_seq = 2 WHERE staff_seq = 1;

--B.3 '홍길동' 삭제 
--퇴사
DELETE FROM tblstaff WHERE seq = 1;




--참조하는 테이블을 반드시 먼저 삭제해야한다.
-- ORA-02449: unique/primary keys in table referenced by foreign keys
DROP TABLE tblstaff;
DROP TABLE tblProject;

--직원 정보
-- 직원(번호(PK), 직원명, 급여, 거주지)
CREATE TABLE tblstaff
(
	seq NUMBER PRIMARY KEY,			--직원번호(PK)
	name varchar2(30) NOT NULL,		--직원명
	salary NUMBER NOT NULL,			--급여
	address varchar2(300) NOT NULL	--거주지
);

--프로젝트 정보
--참조당하는 테이블을 반드시 먼저 만들어야 한다
-- ORA-00942: table or view does not exist
CREATE TABLE tblProject
(
	seq NUMBER PRIMARY KEY,								--프로젝트 번호(PK)
	project varChar2(100) NOT NULL,						--프로젝트명
	staff_seq NUMBER NOT NULL REFERENCES tblStaff(seq)	--담당 직원 번호(FK)
);

INSERT INTO tblstaff (seq, name, salary, address) VALUES (1, '홍길동', 300, '서울시');
INSERT INTO tblstaff (seq, name, salary, address) VALUES (2, '아무개', 250, '인천시');
INSERT INTO tblstaff (seq, name, salary, address) VALUES (3, '하하하', 250, '부산시');


INSERT INTO tblproject (seq, project, staff_seq) values(1, '홍콩 수출', 1); --홍길동
INSERT INTO tblproject (seq, project, staff_seq) values(2, 'TV 광고', 2); --아무개
INSERT INTO tblproject (seq, project, staff_seq) values(3, '매출 분석', 3); --하하하
INSERT INTO tblproject (seq, project, staff_seq) values(4, '노조 협상', 1); --홍길동
INSERT INTO tblproject (seq, project, staff_seq) values(5, '대리점 분양', 2); --아무개

SELECT * FROM tblstaff;
SELECT * FROM tblproject;

-- A. 신입사원 입사 > 신규 프로젝트 담당
-- A.1 신입사원 추가
INSERT INTO tblstaff (seq, name, salary, address) VALUES (4, '호호호', 250, '성남시');

--A.2 신규 프로젝트 추가
INSERT INTO tblproject (seq, project, staff_seq) values(6, '자재 매입', 4); --호호호

--A.3 신규 프로젝트 추가
-- 5번 직원은 없음
--ORA-02291: integrity constraint (HR.SYS_C007133) violated - parent key not found
INSERT INTO tblproject (seq, project, staff_seq) values(7, '고객 유치', 5);

--B. '홍길동' 퇴사
--B.1 '홍길동' 삭제
-- 삭제할 수 없다
-- ORA-02292: integrity constraint (HR.SYS_C007133) violated - child record found
DELETE FROM tblstaff WHERE seq = 1;

--B.2 '홍길동' 삭제 전 > 인수인계(위임)
-- 다른 사람에게 프로젝트를 넘김
UPDATE tblproject SET staff_seq = 2 WHERE staff_seq = 1;

--B.3 '홍길동' 삭제 
--퇴사
DELETE FROM tblstaff WHERE seq = 1;





--------------------------------------------------------------------------------------------


--customer.video.data.sql 테이블 생성


-- *** 자식 테이블보다 부모 테이블이 먼저 발생한다.(테이블 생성, 레코드 생성)

-- 고객 테이블
create table tblCustomer (
    seq number primary key,         --고객번호(PK)
    name varchar2(30) not null,     --고객명
    tel varchar2(15) not null,      --연락처
    address varchar2(100) not null  --주소
);

-- 판매내역 테이블
create table tblSales (
    seq number primary key,                             --판매번호(PK)
    item varchar2(50) not null,                         --제품명
    qty number not null,                                --판매수량
    regdate date default sysdate not null,              --판매날짜
    cseq number not null references tblCustomer(seq)    --판매한 고객번호(FK)
);





-- [비디오 대여점]

-- 장르 테이블
create table tblGenre (
    seq number primary key,         --장르 번호(PK)
    name varchar2(30) not null,     --장르명
    price number not null,          --대여가격
    period number not null          --대여기간(일)
);

-- 비디오 테이블
create table tblVideo (
    seq number primary key,                         --비디오 번호(PK)
    name varchar2(100) not null,                    --비디오 제목
    qty number not null,                            --보유 수량
    company varchar2(50) null,                      --제작사
    director varchar2(50) null,                     --감독
    major varchar2(50) null,                        --주연배우
    genre number not null references tblGenre(seq)  --장르 번호(FK)
);


-- 고객 테이블
create table tblMember (
    seq number primary key,         --고객번호(PK)
    name varchar2(30) not null,     --고객명
    grade number(1) not null,       --고객등급(1,2,3)
    byear number(4) not null,       --생년
    tel varchar2(15) not null,      --연락처
    address varchar2(300) null,     --주소
    money number not null           --예치금
);

-- 대여 테이블
create table tblRent (
    seq number primary key,                             --대여번호(PK)
    member number not null references tblMember(seq),   --회원번호(FK)
    video number not null references tblVideo(seq),     --비디오번호(FK)
    rentdate date default sysdate not null,             --대여시각
    retdate date null,                                  --반납시각
    remark varchar2(500) null                           --비고
);




SELECT * FROM tblgenre;
SELECT * FROM tblvideo;
SELECT * FROM tblmember;
SELECT * FROM tblrent;

/*

	조인, join
	- (서로 관계를 맺은) 2개(1개) 이상의 테이블을 1개의 결과셋으로 만드는 기술
	
	조인의 종류
	1. 단순 조인, CROSS JOIN
	2. 내부 조인, INNER JOIN ***
	3. 외부 조인, OUTER JOIN ***
	4. 셀프 조인, SELF JOIN
	5. 전체 외부 조인, FULL OUTER JOIN

*/

/*

	1. 단순 조인, CROSS JOIN, 카티션곱(데카르트곱)
	- A 테이블 X B 테이블
	- 쓸모없다. > 가치 있는 행과 가치 없는 행이 뒤섞여 있어서...
	- 더미 데이터 만들때 사용(유효성과 무관)

	select 컬럼리스트 from 테이블 A cross join 테이블B;
	
*/

SELECT * FROM tblcustomer; -- 3명
SELECT * FROM tblsales; -- 9건

SELECT * FROM tblcustomer CROSS JOIN tblsales; --ANSI_SQL(추천)
SELECT * FROM tblcustomer, tblsales; --PL/SQL (Oracle)

/*
	
	2. 내부 조인, INNER JOIN ***
	- 단순 조인에서 유효한 레코드만 추출한 조인
	
	select 컬럼리스트 from 테이블A inner join 테이블B on 조건;
	
	select 컬럼리스트 from 테이블A inner join 테이블B on 테이블A.PK = 테이블B.FK;
	
	select
		컬럼리스트
	from 테이블A
		inner join 테이블B
			on 테이블A.PK = 테이블B.FK;
	
*/



SELECT * FROM tblstaff;
SELECT * FROM tblproject;

--직원 테이블, 프로젝트 테이블
SELECT
	*
FROM tblstaff
	CROSS JOIN tblproject;

--sql의 별칭 > 개명 > 별칭을 지정하면 원래 이름은 쓸 수 없다.
-- ORA-00904: "TBLPROJECT"."STAFF_SEQ": invalid identifier
SELECT											--2.
	tblstaff.seq,
	tblstaff.name,
	tblproject.seq,
	tblproject.project
FROM tblstaff s									--1.1
	INNER JOIN tblproject p						--1.2
		ON tblstaff.seq = tblproject.staff_seq	--1.3
	ORDER BY tblproject.seq; 					--3.

-- 조인 > 테이블 별칭 자주 사용
SELECT							--2.
	s.seq,
	s.name,
	p.seq,
	p.project
FROM tblstaff s					--1.1
	INNER JOIN tblproject p		--1.2
		ON s.seq = p.staff_seq	--1.3
	ORDER BY p.seq; 			--3.


	
-- 고객 테이블, 판매 테이블
SELECT
	c.name AS 고객명,
	s.item AS 제품명,
	s.qty AS 개수
	FROM tblcustomer c
		INNER JOIN tblsales s
			ON c.seq = s.cseq;

		
-- FK로 엮여있지 않은 테이블도 조인할 수 있다.		
SELECT * FROM tblmen;
SELECT * FROM tblwomen;

SELECT
	*
FROM tblmen m
	INNER JOIN tblwomen w
		ON m.name = w.couple;

	
-- 아무런 관계 없는 테이블도 연결이 된다.
-- seq가 생긴건 같아도 전혀 연관이 없다.
-- 실제로 쓸 일은 없다.
SELECT
	*
FROM tblstaff st
	INNER JOIN tblsales sa
		ON st.seq = sa.cseq;
	
-- 서로 관계가 있는 테이블들에 inner join을 한다.
	
	
	
--고객명(tblcustomer) + 판매물품명(tblsales) > 가져오시오
--1. 조인
SELECT
	c.name AS 고객명,
	s.item AS 물품명
FROM tblcustomer c
	INNER JOIN tblsales s
		ON c.seq = s.cseq;


--2. 서브쿼리 > 상관서브쿼리
-- 메인쿼리 > 자식테이블
-- 상관서브쿼리 > 부모테이블
SELECT
	item AS 물품명,
	(SELECT name FROM tblcustomer WHERE seq = tblsales.cseq) AS 고객명
FROM tblsales;




-- 0901

--비디오 + 장르 > 조인
SELECT
	v.name AS 비디오제목,
	g.name AS 장르,
	g.price AS 가격
FROM tblgenre g
	INNER JOIN tblvideo v
		ON g.seq = v.genre;



-- 비디오 + 장르 + 대여 > 조인
SELECT
	v.name AS 비디오제목,
	g.name AS 장르,
	g.price AS 가격,
	r.MEMBER AS 회원,
	r.rentdate AS 대여일,
	r.retdate AS 반납일
FROM tblgenre g
	INNER JOIN tblvideo v
		ON g.seq = v.genre
			INNER JOIN tblrent r
				ON v.seq = r.video;

-- 비디오 + 장르 + 대여 + 회원 > 조인
SELECT
	m.name AS 회원,
	v.name AS 비디오제목,
	g.price AS 가격,
	r.rentdate AS 대여일
FROM tblgenre g
	INNER JOIN tblvideo v
		ON g.seq = v.genre
			INNER JOIN tblrent r
				ON v.seq = r.video
					INNER JOIN tblmember m
						ON r.MEMBER = m.seq;


-- hr 샘플 데이터 조인
SELECT
	e.first_name || ' ' || e.last_name AS 직원명,
	d.department_name AS 부서명,
	l.city AS 도시명,
	c.country_name AS 국가명,
	r.region_name AS 대륙명,
	j.job_title AS 직업
FROM employees e
	INNER JOIN departments d
		ON e.department_id = d.department_id
			INNER JOIN locations l
				ON d.location_id = l.location_id
				INNER JOIN countries c
					ON l.country_id = c.country_id
						INNER JOIN regions r
							ON c.region_id = r.region_id
	INNER JOIN jobs j
		ON e.job_id = j.job_id;




/*

	3. 외부 조인, OUTER JOIN
	- 내부조인의 반대되는 개념이 아님.
	- 내부 조인 결과 + α 내부 조인에 포함되지 않았던 부모 테이블의 나머지 레코드를 합하는 조인 

	이너조인
	select
		컬럼리스트
	from 테이블A
		inner join 테이블B
			on 테이블A.컬럼 = 테이블B.컬럼;
			
	아우터조인
	select
		컬럼리스트
	from 테이블A
		(left|right) outer join 테이블B
			on 테이블A.컬럼 = 테이블B.컬럼;		
	
*/

SELECT * FROM tblcustomer; --3명

SELECT * FROM tblsales; -- 9건 

INSERT INTO tblcustomer VALUES (4, '호호호', '010-1234-1234', '서울시');
INSERT INTO tblcustomer VALUES (5, '이순신', '010-1234-1234', '서울시');

COMMIT;

-- 내부 조인
-- 업무 > 물건을 한번이라도 구매한 이력이 있는 고객의 정보와 그 고객이 사간 구매 내역을 가져오시오.
SELECT 
	*
FROM tblcustomer c
	INNER JOIN tblsales s
		ON c.seq = s.cseq;
--결과 9건
	

-- left 외부 조인
SELECT
	*
FROM tblcustomer c
	LEFT OUTER JOIN tblsales s
		ON c.seq = s.cseq;
--결과 11건


-- right 외부 조인
SELECT
	*
FROM tblcustomer c
	RIGHT OUTER JOIN tblsales s
		ON c.seq = s.cseq;
--결과 9건
-- 현재 상태에서는 내부 조인과 동일한 결과

	
--보편적인 테이블 구조에서 아우터 조인은 부모 테이블을 가리키도록 한다(여기선 left)	
	
	
	
SELECT * FROM tblstaff; -- 3건
SELECT * FROM tblproject; -- 6건

COMMIT;
UPDATE tblproject SET staff_seq = 4 WHERE staff_seq = 3;

-- inner join
-- 프로젝트를 1건 이상 담당하고 있는 직원을 가져오시오.
SELECT
	*
FROM tblstaff s
	INNER JOIN tblproject p
		ON s.seq = p.staff_seq;
	
-- outer join
-- 담당 프로젝트의 유무와 관계없이 모든 직원을 가져오시오.
SELECT
	*
FROM tblstaff s
	LEFT OUTER JOIN tblproject p
		ON s.seq = p.staff_seq;



-- 대여가 한번이라도 발생한 비디오와 대여기록
SELECT
	*
FROM tblvideo v
	INNER JOIN tblrent r
		ON v.seq = r.video;

-- 한번도 대여되지 않은 비디오
SELECT
	*
FROM tblvideo v
	LEFT OUTER JOIN tblrent r
		ON v.seq = r.video;
		

--대여를 최소 1회 이상 했던 회원과 대여기록
SELECT
	*
FROM tblmember m
	INNER JOIN tblrent r
		ON m.seq = r.MEMBER;
	
-- 한번도 대여하지 않은 회원	
SELECT
	*
FROM tblmember m
	LEFT OUTER JOIN tblrent r
		ON m.seq = r.MEMBER;
		
	
-- 요구사항] 대여를 한번도 하지 않은 고객의 명단을 가져오시오.
SELECT
	*
FROM tblmember m
	LEFT OUTER JOIN tblrent r
		ON m.seq = r.MEMBER
			WHERE r.seq IS NULL;
		
--요구사항] 대여 기록이 있는 회원의 이름을 중복 없이 가져오시오.
SELECT
	DISTINCT m.name
FROM tblmember m
	INNER JOIN tblrent r
		ON m.seq = r.MEMBER;
		
--요구사항] 대여 기록이 있는 회원의 이름 + 회원별 대여 횟수
SELECT
	m.name,
	count(*)
FROM tblmember m
	INNER JOIN tblrent r
		ON m.seq = r.MEMBER
			GROUP BY m.name;
		
--요구사항] 대여 기록이 있는 회원의 이름 + 회원별 대여 횟수
SELECT
	m.name,
	count(r.seq) AS 대여횟수 --count(*) > 대여기록이 NULL이어도 다른 컬럼이 있어서 카운트가 1이 됨
FROM tblmember m
	LEFT OUTER JOIN tblrent r
		ON m.seq = r.MEMBER
			GROUP BY m.name
				ORDER BY count(r.seq) DESC;

SELECT * FROM dual;		
/*

	4. 셀프 조인, SELF JOIN
	(사용 빈도수 적음 > 복습 비중 낮게)
	- 1개의 테이블을 사용하는 조인
	- 테이블이 자기 스스로와 관계를 맺는 경우
	
	- 다중 조인(2개 이상의 테이블을 조인) + 내부 조인
	- 다중 조인(2개 이상의 테이블을 조인) + 외부 조인
	
	- 셀프 조인(1개) + 내부 조인
	- 셀프 조인(1개) + 외부 조인
	
*/

--직원 테이블
CREATE TABLE tblself
(
	seq NUMBER PRIMARY KEY,						--직원번호(PK)
	name varchar2(30) NOT NULL,					--직원명
	department varchar2(30) NOT NULL,			--부서명
	super NUMBER NULL REFERENCES tblself(seq)	--직속상사의 직원번호(FK)
);

INSERT INTO tblself VALUES (1, '홍사장', '사장', null);
INSERT INTO tblself VALUES (2, '김부장', '영업부', 1);
INSERT INTO tblself VALUES (3, '박과장', '영업부', 2);
INSERT INTO tblself VALUES (4, '최대리', '영업부', 3);
INSERT INTO tblself VALUES (5, '정사원', '영업부', 4);
INSERT INTO tblself VALUES (6, '이부장', '개발부', 1);
INSERT INTO tblself VALUES (7, '하과장', '개발부', 6);
INSERT INTO tblself VALUES (8, '신과장', '개발부', 6);
INSERT INTO tblself VALUES (9, '황대리', '개발부', 7);
INSERT INTO tblself VALUES (10, '허사원', '개발부', 9);

--직원 명단을 가져오시오. 단, 상사의 이름까지
-- 1. join
-- 2. sub query
-- 3. 계층형 쿼리 

-- self inner join
SELECT * FROM tblself;

SELECT
	b.name AS 직원명,
	b.department AS 부서명,
	a.name AS 상사명
FROM tblself a				--a 역할 : 부모테이블 > 상사
	INNER JOIN tblself b	--b 역할 : 자식테이블 > 직원
		ON a.seq = b.super;


-- self outer join
-- 사장 > 상사 없음 자식 테이블에서 가져와야하므로 right outer join
SELECT
	b.name AS 직원명,
	b.department AS 부서명,
	a.name AS 상사명
FROM tblself a					--a 역할 : 부모테이블 > 상사
	RIGHT OUTER JOIN tblself b	--b 역할 : 자식테이블 > 직원
		ON a.seq = b.super;


-- sub query
SELECT
	name AS 직원명,
	department AS 부서명,
	(SELECT name FROM tblself WHERE seq = s.super) AS 상사명
FROM tblself s ;


/*
	5. 전체 외부 조인, FULL OUTER JOIN
	(셀프 조인보다 발생 빈도 낮음 > 복습 비중 낮게)
	- 서로 참조하고 있는 관계에서 사용

*/

SELECT * FROM tblmen;	--부모 / 자식
SELECT * FROM tblwomen;	--자식 / 부모

--커플인 남자, 여자 가져오시오
SELECT
	m.name,
	w.name
FROM tblmen m
	INNER JOIN tblwomen w
		ON m.name = w.couple;
	
-- 남자 명단	
SELECT
	m.name,
	w.name
FROM tblmen m
	LEFT OUTER JOIN tblwomen w
		ON m.name = w.couple;
		
-- 여자 명단
SELECT
	m.name,
	w.name
FROM tblmen m
	RIGHT OUTER JOIN tblwomen w
		ON m.name = w.couple;
		
-- 전체 명단	
SELECT
	m.name,
	w.name
FROM tblmen m
	FULL OUTER JOIN tblwomen w
		ON m.name = w.couple;

	
