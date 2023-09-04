-- ex26_hierarchical.sql


/*
	계층형 쿼리, Hierarchical Queary
	- 오라클 전용 쿼리
	- 레코드의 관계가 서로간에 상하 수직 구조인 경우에 사용
	- 자기 참조를 하는 테이블에서 사용 > 셀프 조인
	- 자바의 트리구조
	
	tblself
	홍사장
		-김부장
			-박과장
				-최대리
					-정사원
		-이부장
			-하과장
*/

SELECT * FROM tblself;

/*	
	컴퓨터
        - 본체
            - 메인보드
            - 그래픽카드
            - 랜카드
            - 메모리
            - CPU
        - 모니터
            - 보호필름
            - 모니터암
        - 프린터
            - A4용지
            - 잉크카트리지
    


*/
create table tblComputer (
    seq number primary key,                         --식별자(PK)
    name varchar2(50) not null,                     --부품명
    qty number not null,                            --수량
    pseq number null references tblComputer(seq)    --부모부품(FK)
);

insert into tblComputer values (1, '컴퓨터', 1, null);

insert into tblComputer values (2, '본체', 1, 1);
insert into tblComputer values (3, '메인보드', 1, 2);
insert into tblComputer values (4, '그래픽카드', 1, 2);
insert into tblComputer values (5, '랜카드', 1, 2);
insert into tblComputer values (6, 'CPU', 1, 2);
insert into tblComputer values (7, '메모리', 2, 2);

insert into tblComputer values (8, '모니터', 1, 1);
insert into tblComputer values (9, '보호필름', 1, 8);
insert into tblComputer values (10, '모니터암', 1, 8);

insert into tblComputer values (11, '프린터', 1, 1);
insert into tblComputer values (12, 'A4용지', 100, 11);
insert into tblComputer values (13, '잉크카트리지', 3, 11);

SELECT * FROM tblcomputer;

--부품 가져오기 + 부모 부품의 정보
-- 셀프 조인
SELECT 
	c1.name AS 부품명,
	c2.name AS 부모부품명
FROM tblcomputer c1 -- 부품(자식)
	INNER JOIN tblcomputer c2 -- 부모부품(부모)
		ON c1.pseq = c2.seq;
		
-- 계층형 쿼리
-- 1. start with절 + connect by 절
-- 2. 계층형 쿼리에서만 사용 가능한 의사 컬럼들
--	a. prior : 자기와 연관된 부모 레코드를 참조
--	b. level : 세대수(depth, generation)
	
SELECT *
FROM tblcomputer
	START WITH 조건		-- 루트 레코드 지정
		CONNECT BY 조건;	-- 현재 레코드와 부모 레코드를 연결하는 조건

		
-- 가장 위의 레코드를 루트로 지정하면 전체
SELECT
	seq AS 번호,
	lpad(' ', (LEVEL - 1) * 10) || name AS 부품명,
	PRIOR name AS 부모부품명,
	LEVEL 
FROM tblcomputer
	START WITH seq = 1
		CONNECT BY pseq = PRIOR seq; --PRIOR > 같은 테이블을 부모 테이블이라는 가정 하에 실행

-- 루트 지정을 통해 일부 그룹만 가져올 수도 있음
SELECT
	seq AS 번호,
	lpad(' ', (LEVEL - 1) * 10) || name AS 부품명,
	PRIOR name AS 부모부품명,
	LEVEL 
FROM tblcomputer
	START WITH seq = 2
		CONNECT BY pseq = PRIOR seq; 

-- tblself
SELECT
	lpad(' ', (LEVEL - 1) * 10) || name AS 이름,
	PRIOR name AS 상사
FROM tblself
	START WITH seq = 1
		CONNECT BY super = PRIOR seq;

	
-- prior : 부모 레코드 참조 > 직속 상사
-- connect_by_root : 최상위 레코드 참조 > 홍사장
-- connect_by_isleaf : 말단 노드
-- sys_connect_by_path(컬럼, 구분자)

SELECT
	lpad(' ', (LEVEL - 1) * 10) || name AS 이름,
	PRIOR name AS 상사,
	connect_by_root name,
	connect_by_isleaf, -- 더이상 자식을 갖지 않는 최하위 노드를 찾을 때 쓰는 표현식
	sys_connect_by_path(name, '-') -- 루트에서 현재까지 수직구조 한번에 나타냄
FROM tblself
	START WITH seq = 1
		CONNECT BY super = PRIOR seq;
		

-- tblcomputer
-- 같은 레벨에서의 정렬
SELECT
	seq AS 번호,
	lpad(' ', (LEVEL - 1) * 10) || name AS 부품명,
	PRIOR name AS 부모부품명,
	LEVEL 
FROM tblcomputer
	START WITH seq = 1
		CONNECT BY pseq = PRIOR seq
			ORDER siblings BY name; -- 그냥 order by 사용시 계층구조 무너짐


			
			
			
			
/*
    카테고리
    - 컴퓨터용품
        - 하드웨어
        - 소프트웨어
        - 소모품
    - 운동용품
        - 테니스
        - 골프
        - 달리기
    - 먹거리
        - 밀키트
        - 베이커리
        - 도시락		
        
   
*/
			
create table tblCategoryBig (
    seq number primary key,                 --식별자(PK)
    name varchar2(100) not null             --카테고리명
);

create table tblCategoryMedium (
    seq number primary key,                             --식별자(PK)
    name varchar2(100) not null,                        --카테고리명
    pseq number not null references tblCategoryBig(seq) --부모카테고리(FK)
);

create table tblCategorySmall (
    seq number primary key,                                 --식별자(PK)
    name varchar2(100) not null,                            --카테고리명
    pseq number not null references tblCategoryMedium(seq)  --부모카테고리(FK)
);


insert into tblCategoryBig values (1, '카테고리');

insert into tblCategoryMedium values (1, '컴퓨터용품', 1);
insert into tblCategoryMedium values (2, '운동용품', 1);
insert into tblCategoryMedium values (3, '먹거리', 1);

insert into tblCategorySmall values (1, '하드웨어', 1);
insert into tblCategorySmall values (2, '소프트웨어', 1);
insert into tblCategorySmall values (3, '소모품', 1);

insert into tblCategorySmall values (4, '테니스', 2);
insert into tblCategorySmall values (5, '골프', 2);
insert into tblCategorySmall values (6, '달리기', 2);

insert into tblCategorySmall values (7, '밀키트', 3);
insert into tblCategorySmall values (8, '베이커리', 3);
insert into tblCategorySmall values (9, '도시락', 3);


SELECT * FROM tblcategorybig;
SELECT * FROM tblcategorymedium;
SELECT * FROM tblcategorysmall;

SELECT
	b.name AS "상",
	m.name AS "중",
	s.name AS "하"
FROM tblcategorybig b
	INNER JOIN tblcategorymedium m
		ON b.seq = m.pseq
			INNER JOIN tblcategorysmall s
				ON m.seq = s.pseq;



-- depth 가 예측이 되면 자기참조형,  예측할 수 없으면 테이블 분리

	
	