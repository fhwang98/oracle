--ex30_plsql3.sql

/*
	
	저장 프로시저
	1. 저장 프로시저
	2. 저장 함수
	
	저장함수 Stored Function > 함수(Function)
	- 저장 프로시저와 동일
	- 반환값이 반드시 존재 > out 파라미터를 말하는게 아님 > return 문을 사용한다.
	- out 파라미터 사용금지 > 대신 return문을 사용
	- in 파라미터는 사용한다.
	- 이런 특성 때문에 호출하는 구문이 조금 다르다(***)

	
	프로젝트 > 취업자료를 만드는 부분도 신경써야함
	프로시저 + 함수 + 트리거 최소한이라도 사용해야함
	
	
	면접 > 어떤 업무에 저장 프로시저를 써보셨고 그에 대한 본인 생각은 ??
	대답 > 회원가입 하는데 이런 작업이 반복되었고 그냥 ansi-sql을 작성하는 것보다는 저장 프로시저를 활용하니 어떤 부분에서 효율성이 개선되었고 어쩌구 ...
	면접 > 저장 프로시저가 몬가요?
	대답 > 저장 프로시저는 이런거구 저는 이런 부분에서 사용햇는데 어땟고 저쨌고 > 정의 + 내경험/내생각 = 100점대답!
*/


-- num1 + num2 > 합

-- 프로시저
CREATE OR REPLACE PROCEDURE procsum (
	num1 IN NUMBER,
	num2 IN NUMBER,
	presult OUT NUMBER
)
IS
BEGIN
	presult := num1 + num2;
END procsum;


-- 함수
CREATE OR REPLACE FUNCTION fnsum(
	num1 IN NUMBER,
	num2 IN NUMBER
	--presult OUT NUMBER -- out을 사용하면 함수 고유의 특성이 사라진다. 프로시저와 동일해진다. 금지!
) RETURN NUMBER
IS
BEGIN
	--presult := num1 + num2;
	RETURN num1 + num2;
END fnsum;



DECLARE
	vresult NUMBER;
BEGIN
	procsum(10, 20, vresult);
	dbms_output.put_line(vresult);

	vresult := fnsum(10, 20);
	dbms_output.put_line(vresult);
END;


-- 프로시저: PL/SQL 전용 > 업무 절차 모듈화
-- 함수: ANSI-SQL 보조 > 쿼리 짤 떄 효율굿
SELECT
	name, basicpay, sudang,
	--basicpay + sudang
	--procsum(basicpay, sudang, 변수) 안됨
	fnsum(basicpay, sudang) -- 함수는 PL/SQL 요소임에도 ANSI-SQL에서 사용 가능
FROM tblinsa;


--이름, 부서, 직원, 성별(남자|여자)

SELECT
	name, buseo, jikwi,
	CASE
		WHEN substr(ssn, 8, 1) = '1' THEN '남자'
		WHEN substr(ssn, 8, 1) = '2' THEN '여자'
	END AS gender,
	fngender(ssn) AS gender2
FROM tblinsa;

-- 팀작업 초반, 팀플 중에라도 함수를 짜놓으면 용이!!
CREATE OR REPLACE FUNCTION fngender(
	pssn varchar2
) RETURN varchar2
IS
BEGIN
	RETURN CASE
				WHEN substr(pssn, 8, 1) = '1' THEN '남자'
				WHEN substr(pssn, 8, 1) = '2' THEN '여자'
			END;
END fngender;


/*
	프로시저
	1. 프로시저
	2. 함수
	3. 트리거
	
	트리거, Trigger
	- 프로시저의 한 종류
	- 함수, 프로시저와 성질이 다름
	- 개발자의 호출이 아닌, 미리 지정한 특정 사건이 발생하면 시스템이 자동으로 실행하는 프로시저
	- 예약(사건) > 사건 발생 > 프로시저 호출
	- 특정 테이블 지정 > 지정 테이블 오라클 감시
		> insert or update or delete > 미리 준비해놓은 프로시저를 호출
		
	트리거 구문
	create or replace trigger 트리거명
		before|after
		insert|update|delete
		on 테이블명
		[for each row]
	declare
		선언부;
	begin
		구현부;
	exception
		예외처리부;
	end; 
	
*/

-- tblinsa > 직원 삭제
CREATE OR REPLACE TRIGGER trginsa
	BEFORE		-- 삭제가 발생하기 직전에 아래의 구현부를 먼저 실행해라!! > BEFORE트리거
	DELETE		-- 삭제가 발생하는지 감시 
	ON tblinsa	-- tblinsa 테이블에서(감시)
BEGIN
	dbms_output.put_line(to_char(sysdate, 'hh24:mi:ss') || '트리거가 실행되었습니다.');

	-- 월요일에는 퇴사가 불가능
	IF to_char(sysdate, 'dy') ='월' THEN
		
	-- 강제로 에러 발생 > before 트리거일때 o
	-- java : throw new Excetion()
	-- 앞에 적는 코드 > -20000 ~ -29999
	raise_application_error(-20001, '월요일에는 퇴사가 불가능합니다.');
	
	END IF;

END trginsa;

SELECT * FROM tblinsa;

DELETE FROM tblinsa WHERE num = 1010;
ROLLBACK;

SELECT * FROM tblbonus;
DELETE FROM tblbonus;
COMMIT;

-- 트리거 >  오라클 운영상 성능에 도움이 되지는 않음



-- 로그 기록
SELECT * FROM tbldiary;

CREATE TABLE tbllogdiary (
	seq NUMBER PRIMARY KEY,
	message varchar2(1000) NOT NULL,
	regdate DATE DEFAULT sysdate NOT null
);
DROP TABLE tbllogdiary;

CREATE SEQUENCE seqlogdiary;

-- 트리거 생성
CREATE OR REPLACE TRIGGER trgdiary
	AFTER
	INSERT OR UPDATE OR DELETE
	ON tbldiary
DECLARE
	vmessage varchar2(1000);
BEGIN
	
	--dbms_output.put_line(to_char(sysdate, 'hh24:mi:ss') || '트리거가 실행되었습니다.');
	IF inserting THEN -- 예약어
		--dbms_output.put_line('추가');
		vmessage := '새로운 항목이 추가되었습니다.';
	ELSIF updating THEN
		--dbms_output.put_line('수정');
		vmessage := '기존 항목이 수정되었습니다.';
	ELSIF deleting THEN
		--dbms_output.put_line('삭제');
		vmessage := '기존 항목이 삭제되었습니다.';
	END IF;
	
	INSERT INTO tbllogdiary VALUES (seqlogdiary.nextVal, vmessage, sysdate);

END trgdiary;

-- 삽입
INSERT INTO tbldiary VALUES (11, '프로시저를 공부했다.', '흐림', sysdate);
-- 수정
UPDATE tbldiary SET subject = '프로시저를 복습했다.' WHERE seq = 11;
-- 삭제
DELETE FROM tbldiary WHERE seq = 11;

SELECT * FROM tbllogdiary;



/*
	[for each row]
	
	1. 생략
		- 문장(Query) 단위 트리거 Table Level Trigger
		- 사건에 적용된 행의 개수 무관 > 트리거는 딱 1회만 호출
		- 적용된 레코드의 정보는 중요하지 않은 경우 + 사건 자체가 중요한 경우
	
	2. 사용
		- 행(Record) 단위 트리거
		- 사건에 적용된 행의 개수만큼 > 트리거가 호출
		- 적용된 레코드의 정보가 중요한 경우 + 사건자체보다..
		- 상관 관계를 사용한다. > 일종의 가상 레코드 > :old, :new
		
		insert 
		- :new > 방금 추가된 행
		
		update
		- :old > 수정되기 전 행
		- :new > 수정된  후 행
		
		delete
		- :old > 삭제된 행
*/

SELECT * FROM tblmen;

CREATE OR REPLACE TRIGGER trgmen
	AFTER
	DELETE
	ON tblmen
	FOR EACH ROW
BEGIN
	-- 누가 삭제됐는지 궁금해서 이름을 찍고 싶음 > 문장 단위에서는 알 수 없음
	dbms_output.put_line('레코드를 삭제했습니다.' || :OLD.name);
END trgmen;

DELETE FROM tblmen WHERE name = '홍길동'; -- 1명 삭제 > 문장 단위 : 트리거 1회 실행 / 행단위 : 1회 실행

DELETE FROM tblmen WHERE age < 25; -- 4명 삭제 > 문장 단위 : 트리거 1회 실행 / 행단위 : 4회 실행


ROLLBACK;




CREATE OR REPLACE TRIGGER trgmen
	AFTER
	UPDATE
	ON tblmen
	FOR EACH ROW
BEGIN
	dbms_output.put_line('레코드를 수정했습니다. > ' || :OLD.name);
	dbms_output.put_line('수정하기 전 나이: ' || :OLD.age);
	dbms_output.put_line('수정한 후 나이: ' || :NEW.age);
END trgmen;

UPDATE tblmen SET age = age + 1 WHERE name = '홍길동';

UPDATE tblmen SET age = age + 1;

SELECT * FROM tblmen;
ROLLBACK;







-- 퇴사 > 프로젝트 위임
SELECT * FROM tblstaff;
SELECT * FROM tblproject;

-- 직원을 퇴사 > 퇴사 바로 직전(delete, before 트리거) > 담당 프로젝트 체크 > 위임

CREATE OR REPLACE TRIGGER trgdeletestaff
	BEFORE		--3. 전에
	DELETE		--2. 퇴사하기
	ON tblstaff	--1. 직원테이블에서
	FOR EACH ROW--4. 해당 직원 정보
BEGIN
	--5. 위임 진행
	UPDATE tblproject SET staff_seq = 3 WHERE staff_seq = :OLD.seq; -- 퇴사하는 직원 번호
	
END trgdeletestaff;

DELETE FROM tblstaff WHERE seq = 1;

ROLLBACK;


-- 회원 테이블, 게시판 테이블
-- 포인트 제도
-- 1. 글 작성 > 포인트 + 100
-- 2. 글 삭제 > 포인트 - 50

CREATE TABLE tbluser (
	id varchar2(30) PRIMARY KEY,
	point NUMBER DEFAULT 1000 NOT NULL
);

INSERT INTO tbluser VALUES ('hong', default);

CREATE TABLE tblboard (
	seq NUMBER PRIMARY KEY,
	subject varchar2(1000) NOT NULL,
	id varchar2(30) NOT NULL REFERENCES tbluser(id)
);

CREATE SEQUENCE seqboard;

SELECT * FROM tbluser;
SELECT * FROM tblboard;

SELECT * FROM tabs;

-- A. 글을 쓴다(삭제한다.)
-- B. 포인트를 누적(차감)한다. 

-- Case 1. Hard
-- 개발자 직접 제어
-- 실수 > 일부 업무 누락;; 가능성o

-- 1.1 글쓰기
INSERT INTO tblboard VALUES (seqboard.nextval, '게시판입니다.', 'hong');

-- 1.2 포인트 누적하기
UPDATE tbluser SET point = point + 100 WHERE id = 'hong';

-- 1.3 글삭제
DELETE FROM tblboard WHERE seq = 1;

-- 1.4 포인트 차감하기
UPDATE tbluser SET point = point - 50 WHERE id = 'hong';


SELECT * FROM tbluser;
SELECT * FROM tblboard;


-- Case 2. 프로시저
CREATE OR REPLACE PROCEDURE procaddboard (
	pid varchar2,
	psubject varchar2
)
IS
BEGIN
	--2.1 글쓰기
	INSERT INTO tblboard VALUES (seqboard.nextval, psubject, pid);
	
	--2.2 포인트 누적하기
	UPDATE tbluser SET point = point + 100 WHERE id = pid;

END procaddboard;

CREATE OR REPLACE PROCEDURE procdeleteboard (
	pseq NUMBER
)
IS
	vid varchar2(30);
BEGIN
	
	-- 2.1 삭제들의 작성자를 미리 알아내기
	SELECT id INTO vid FROM tblboard WHERE seq = pseq;

	-- 2.2 글삭제
	DELETE FROM tblboard WHERE seq = pseq;

	-- 2.3 포인트 차감하기
	UPDATE tbluser SET point = point - 50 WHERE id = vid;

END procdeleteboard;



BEGIN
	--procaddboard('hong', '글을 작성합니다.');
	procdeleteboard(3);
END;

SELECT * FROM tbluser;
SELECT * FROM tblboard;



-- Case 3. 트리거
CREATE OR REPLACE TRIGGER trgboard
	AFTER
	INSERT OR DELETE
	ON tblboard
	FOR EACH ROW
DECLARE
BEGIN
	
	IF inserting THEN
	
		UPDATE tbluser SET point = point + 100 WHERE id = :NEW.id;
	
	ELSIF deleting THEN
	
		UPDATE tbluser SET point = point - 50 WHERE id = :OLD.id;
	
	END IF;
END trgboard;

SELECT * FROM tbluser;
SELECT * FROM tblboard;

-- 3.1 글쓰기
INSERT INTO tblboard VALUES (seqboard.nextval, '또 다시 글을 씁니다.', 'hong');

-- 3.2 글삭제
DELETE FROM tblboard WHERE seq = 4;


-- 프로시저 or 트리거 둘 다 할 수 있는 일이라면 > 프로시저로 하는게 효율적
-- 트리거는 계속 행동을 감시 > 자원 낭비 o


/*
	프로젝트 예시)
	1조
	- 5명 구성
	
	- 프로시저 > 50개
	- 뷰 > 100개
	- 함수 > 30개
	- 트리거 > 10개
	
	업무 분장 > 이렇게하면안됨!!!!!
	- A > 프로시저 50개
	- B > 뷰 60개
	- C > 뷰 40개
	- D > 함수 20개
	- E > 함수 10개 + 트리거 10개
	
	각 기술 > n분의 1
	
	프로젝트 > 개인 프로젝트의 집합
	모든 프로세스와 모든 업무를 팀원들이 골고루 해야함
	
*/