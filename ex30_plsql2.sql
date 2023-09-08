-- 실명 프로시저
/*
    명령어 실행 > 처리 과정
    
    select * from tblinsa; 처리 과정
    
    1. ANSI-SQL
    2. 익명 프로시저
    1.2 동작 방식 같음
        a. 클라이언트 > 구문 작성(select)
        b. 실행(Ctrl + Enter)
        c. 명령어를 오라클 서버에 전달
        d. 서버가 명령어를 수신
        e. 구문 분석(파싱) + 문법 검사
        f. 컴파일
        g. 실행(select)
        h. 결과셋 도출
        i. 결과셋을 클라이언트에게 반환
        j. 결과셋을 화면에 출력
        
        > 다시 실행
        a. ~ j. 다시 반복
        - 한번 실행했던 명령어를 다시 실행 > 위의 모든 과정을 처음부터 끝까지 다시 실행한다.
        - 첫번째 실행 비용 = 다시 실행 비용
    
    3. 실명 프로시저
    	a. 클라이언트 > 구문 작성(create)(프로시저 만드는 구문)
    	b. 실행(Ctrl + Enter)
    	c. 명령어를 오라클 서버에 전달
    	d. 서버가 명령어를 수신
    	e. 구문 분석(파싱) + 문법 검사
    	f. 컴파일
    	g. 실행(create)
    	h. 오라클 서버 > 프로시저 생성 > 저장(컴파일된 결과)(*******)
    	i. 완료
    	
    	a. 클라이언트 > 구문 작성(호출)
    	b. 실행(Ctrl + Enter)
    	c. 명령어를 오라클 서버에 전달
    	d. 서버가 명령어를 수신
    	e. 구문 분석(파싱) + 문법 검사
    	f. 컴파일
    	g. 실행 > 프로시저 실행
    	
    	> 다시 실행
    	a. 클라이언트 > 구문 작성(호출)
    	b. 실행(Ctrl + Enter)
    	c. 명령어를 오라클 서버에 전달
    	d. 서버가 명령어를 수신
    	e. 구문 분석(파싱) + 문법 검사
    	f. 컴파일
    	g. 실행 > 프로시저 실행
    	
    	
    
*/

select * from tblinsa;

/*
    프로시저
    1. 익명 프로시저
        - 1회용
    
    2. 실명 프로시저
        - 재사용
        - 오라클에 저장


	실명 프로시저
	- 저장 프로시저(Stored procedure)
	1. 저장 프로시저, Stored procedure
		- 매개변수 / 반환값 구성 > 자유
	
	2. 저장 함수, Stored Function
		- 매개변수 / 반환값 구성 > 필수


	익명 프로시저 선언
	
	[declare
		변수 선언;
		커서 선언;] 
	begin
		구현부;
	[exception
		예외처리;]
	end;
	
	
	저장 프로시저 선언
	
	create [or replace] procedure 프로시저명
	is(as)
		[변수 선언;
		커서 선언;] 
	begin
		구현부;
	[exception
		예외처리;]
	end;
	
		
	
*/

-- 즉시 실행
DECLARE
	vnum NUMBER;
BEGIN
	vnum:= 100;
	dbms_output.put_line(vnum);
END;



-- 저장 프로시저
CREATE OR REPLACE PROCEDURE proctest
IS
	vnum NUMBER;
BEGIN
	vnum:= 100;
	dbms_output.put_line(vnum);
END;


-- 저장 프로시저를 호출하는 방법
BEGIN
	proctest; -- 프로시저 호출
END;


-- 저장 프로시저 = 메소드
-- 매개변수 + 반환값

-- 1. 매개변수가 있는 프로시저
CREATE OR REPLACE PROCEDURE proctest(pnum NUMBER) -- 매개변수
IS
	vresult NUMBER; --일반 변수
BEGIN
	vresult := pnum * 2;
	dbms_output.put_line(vresult);
END proctest; -- 프로시저 이름 생략 가능


BEGIN
	-- PL/SQL 영역
	proctest(100);
	proctest(200);
	proctest(300);
END;

-- 무슨 영역?
-- ANSI-SQL 영역
-- ANSI-SQL 영역에서는 PL/SQL을 사용할 수 없다.
-- proctest(400); 에러

-- 실행 가능한 방법
EXECUTE proctest(400); 
EXEC proctest(500); 
CALL proctest(600); 



CREATE OR REPLACE PROCEDURE proctest(
	width NUMBER,
	height NUMBER
)
IS
	vresult NUMBER;
BEGIN
	vresult := width * height;
	dbms_output.put_line(vresult);
END proctest;


BEGIN
	proctest(10, 20);
END;


-- *** 프로시저 매개변수는 길이와 not null 표현은 불가능하다.
CREATE OR REPLACE PROCEDURE proctest(
	name varchar2
)
IS -- 변수를 선언하지 않아도 생략할 수 없음

BEGIN
	
	dbms_output.put_line('안녕하세요. '|| name || '님');

END proctest;


BEGIN
	proctest('홍길동');
END;


-- default
CREATE OR REPLACE PROCEDURE proctest(
	width NUMBER,
	height NUMBER DEFAULT 10 -- DEFAULT가 맨 뒤에 와야함
)
IS
	vresult NUMBER;
BEGIN
	vresult := width * height;
	dbms_output.put_line(vresult);
END proctest;


BEGIN
	proctest(10, 20);	-- width(10), height(20)
	proctest(10);		-- width(10), height(10 - default)
END;


/*

	매개변수 모드
	- 매개변수가 값을 전달하는 방식
	- Call by Value > 매개변수 > 값을 넘기는 방식(값형 인자)
	- Call by Reference > 매개변수 > 참조값(주소)을 넘기는 방식(참조형 인자)
	
	1. in 모드 > 기본
	2. out 모드
	3. in out 모드(잘안씀)


*/

CREATE OR REPLACE PROCEDURE proctest (
	pnum1 IN NUMBER, -- in paremeter // 인자값
	pnum2 IN NUMBER,
	presult OUT NUMBER, -- out PARAMETER // 반환값 역할
	presult2 OUT NUMBER, -- 반환값
	presult3 OUT NUMBER -- 반환값
)
IS
BEGIN
	presult := pnum1 + pnum2;
	presult2 := pnum1 - pnum2;
	presult3 := pnum1 * pnum2;
END proctest;


DECLARE
	vnum NUMBER;
	vnum2 NUMBER;
	vnum3 NUMBER;
BEGIN
	--proctest(10, 20, 변수);
	proctest(10, 20, vnum, vnum2, vnum3); -- 변수의 주솟값이 전달됨
	dbms_output.put_line(vnum);
	dbms_output.put_line(vnum2);
	dbms_output.put_line(vnum3);
END;



-- 문제
-- 1. 부서 전달(인자) > 해당 부서의 직원 중 급여를 가장 많이 받는 사람의 번호 반환(out) > 출력
--	in 1개 + out 1개

-- 2. 직원 번호 전달(인자) > 같은 지역에 사는 직원수?, 같은 직위 직원수? 해당 직원보다 급여를 더 많이 받는 직원수? 반환
--	in 1개 + out 3개


CREATE OR REPLACE PROCEDURE proctest1 (
	pbuseo IN varchar2,
	pnum OUT NUMBER
)
IS
BEGIN
	SELECT num INTO pnum FROM tblinsa 
		WHERE basicpay = 
			(SELECT max(basicpay) 
				FROM tblinsa WHERE buseo = pbuseo) AND buseo = pbuseo;
END proctest1;

DECLARE
	vnum NUMBER; -- out에게 넘길 변수
BEGIN
	 proctest1('기획부', vnum);
	 dbms_output.put_line(vnum);
END;




CREATE OR REPLACE PROCEDURE proctest2 (
	pnum IN NUMBER, -- 직원 번호
	pcnt1 OUT NUMBER,	
	pcnt2 OUT NUMBER,	
	pcnt3 OUT NUMBER	
)
IS 
BEGIN
	--같은 지역에 사는 직원수?, 같은 직위 직원수? 해당 직원보다 급여를 더 많이 받는 직원수?
	SELECT count(*) INTO pcnt1 FROM tblinsa
			WHERE city = (SELECT city FROM tblinsa WHERE num = pnum);
	SELECT count(*) INTO pcnt2 FROM tblinsa
			WHERE jikwi = (SELECT jikwi FROM tblinsa WHERE num = pnum);
	SELECT count(*) INTO pcnt3 FROM tblinsa
			WHERE basicpay > (SELECT basicpay FROM tblinsa WHERE num = pnum);
END proctest2;

DECLARE
	vcnt1 NUMBER;
	vcnt2 NUMBER;
	vcnt3 NUMBER;
BEGIN
	proctest2(1023, vcnt1, vcnt2, vcnt3);
	dbms_output.put_line(vcnt1);
	dbms_output.put_line(vcnt2);
	dbms_output.put_line(vcnt3);
END;

DECLARE
	vnum NUMBER;
	vcnt1 NUMBER;
	vcnt2 NUMBER;
	vcnt3 NUMBER;
BEGIN
	proctest1('기획부', vnum);
	proctest2(vnum, vcnt1, vcnt2, vcnt3);
	dbms_output.put_line(vcnt1);
	dbms_output.put_line(vcnt2);
	dbms_output.put_line(vcnt3);
END;



-- 직원 퇴사 프로시저, procdeletestaff
-- 1. 퇴사 직원 > 담당 프로젝트 유무 확인?
-- 2. 담당 프로젝트 존재 > 위임
-- 3. 퇴사 직원 삭제

CREATE OR REPLACE PROCEDURE procdeletestaff (
	pseq NUMBER,		-- 퇴사할 직원번호
	pstaff NUMBER,		-- 위임받을 직원번호
	presult OUT NUMBER	-- 성공(1) OR 실패(0) > 피드백
)
IS
	vcnt NUMBER; -- 퇴사 직원의 담당 프로젝트 개수
BEGIN
	
	--1. 퇴사 직원의 담당 프로젝트가 있는지?
	SELECT count(*) INTO vcnt FROM tblproject WHERE staff_seq = pseq;
	
	--2. 조건 > 위임 유무 결정
	IF vcnt > 0 THEN
		--3. 위임
		UPDATE tblproject SET staff_seq = pstaff WHERE staff_seq = pseq;
	ELSE 
		--3. 아무것도 안함
		NULL; -- 이 조건의 else절에서는 아무것도 하지 마시오!! > 개발자의 의도 표현
	END IF;
		
	-- 4. 퇴사
	DELETE FROM tblstaff WHERE seq = pseq;

	-- 피드백 > 성공
	presult := 1;

EXCEPTION
	WHEN OTHERS THEN
	presult := 0;

END procdeletestaff;

DECLARE
	vresult NUMBER;
BEGIN
	procdeletestaff(1, 2, vresult);
	IF vresult = 1 THEN
		dbms_output.put_line('퇴사 성공');
	ELSE
		dbms_output.put_line('퇴사 실패');
	END IF;
END;


SELECT * FROM tblstaff;
SELECT * FROM tblproject;

INSERT INTO tblstaff VALUES (4, '호호호', 200, '서울시');




-- 위임받을 직원 > 현재 프로젝트를 가장 적게 담당하는 직원에게 자동으로 위임
-- 동률 > rownum = 1
CREATE OR REPLACE PROCEDURE procdeletestaff (
	pseq NUMBER,		-- 퇴사할 직원번호
	presult OUT NUMBER	-- 성공(1) OR 실패(0) > 피드백
)
IS
	vcnt NUMBER; -- 퇴사 직원의 담당 프로젝트 개수
	vstaff_seq NUMBER; -- 담당 프로젝트가 가장 적은 직원 번호
BEGIN
	
	--1. 퇴사 직원의 담당 프로젝트가 있는지?
	SELECT count(*) INTO vcnt FROM tblproject WHERE staff_seq = pseq;

	--2. 조건 > 위임 유무 결정
	IF vcnt > 0 THEN
	
		-- 2.5 프로젝트를 적게 맡고 있는 직원 번호?
		SELECT seq INTO vstaff_seq FROM (
		SELECT s.seq, count(p.staff_seq)
			FROM tblstaff s 
			LEFT OUTER JOIN tblproject p
				ON s.seq = p.staff_seq
					GROUP BY s.seq
						HAVING count(p.staff_seq) =
								(SELECT min(count(p.staff_seq))
								FROM tblstaff s 
								LEFT OUTER JOIN tblproject p
								ON s.seq = p.staff_seq
								GROUP BY s.seq))
							WHERE rownum = 1;
				
	
		--3. 위임
		UPDATE tblproject SET staff_seq = vstaff_seq WHERE staff_seq = pseq;
	ELSE 
		--3. 아무것도 안함
		NULL; -- 이 조건의 else절에서는 아무것도 하지 마시오!! > 개발자의 의도 표현
	END IF;
		
	-- 4. 퇴사
	DELETE FROM tblstaff WHERE seq = pseq;

	-- 피드백 > 성공
	presult := 1;

EXCEPTION
	WHEN OTHERS THEN
	presult := 0;

END procdeletestaff;




