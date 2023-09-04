-- employees. 'Munich' 도시에 위치한 부서에 소속된 직원들 명단?
SELECT *
FROM employees e
	INNER JOIN departments d
		ON e.department_id = d.department_id
			INNER JOIN locations l
				 ON d.location_id = l.location_id
				 	WHERE l.city = 'Munich';
			


-- tblMan. tblWoman. 서로 짝이 있는 사람 중 남자와 여자의 정보를 모두 가져오시오.
--    [남자]        [남자키]   [남자몸무게]     [여자]    [여자키]   [여자몸무게]
--    홍길동         180       70              장도연     177        65
--    아무개         175       null            이세영     163        null
--    ..

SELECT
	m.name AS 남자,
	m.height AS 남자키,
	m.weight AS 남자몸무게,
	w.name AS 여자,
	w.height AS 여자키,
	w.weight AS 여자몸무게
FROM tblmen m
	INNER JOIN tblwomen w
		ON m.couple = w.name;


-- tblAddressBook. 가장 많은 사람들이 가지고 있는 직업은 주로 어느 지역 태생(hometown)인가?
SELECT hometown
FROM tbladdressbook
GROUP BY hometown;


SELECT
	hometown, count(*)
FROM tbladdressbook
WHERE job = (SELECT job
			FROM tbladdressbook
				GROUP BY job
					HAVING count(*) = (SELECT max(count(*))
										FROM tbladdressbook
											GROUP BY job))
	GROUP BY hometown
		ORDER BY count(*) desc
;

		

-- tblAddressBook. 이메일 도메인들 중 평균 아이디 길이가 가장 긴 이메일 사이트의 도메인은 무엇인가?

SELECT substr(email, instr(email, '@') + 1),
	avg(LENGTH(substr(email, 1, instr(email, '@') - 1)))
FROM tbladdressbook
	GROUP BY substr(email, instr(email, '@') + 1)
	HAVING avg(LENGTH(substr(email, 1, instr(email, '@') - 1))) =
		(SELECT max(avg(LENGTH(substr(email, 1, instr(email, '@') - 1)))) FROM tbladdressbook GROUP BY substr(email, instr(email, '@') + 1));





-- tblAddressBook. 평균 나이가 가장 많은 출신(hometown)들이 가지고 있는 직업 중 가장 많은 직업은?
SELECT job
FROM tbladdressbook
	WHERE hometown = (SELECT hometown
			FROM tbladdressbook
				GROUP BY hometown
					HAVING avg(age) = 
			(SELECT max(avg(age))
			FROM tbladdressbook
			GROUP BY hometown))
GROUP BY job
	HAVING count(*) = (SELECT max(count(*))
						FROM tbladdressbook
							WHERE hometown = (SELECT hometown
									FROM tbladdressbook
										GROUP BY hometown
											HAVING avg(age) = 
									(SELECT max(avg(age))
									FROM tbladdressbook
									GROUP BY hometown))
						GROUP BY job);



	

-- tblAddressBook. 남자 평균 나이보다 나이가 많은 서울 태생 + 직업을 가지고 있는 사람들을 가져오시오.
SELECT *
FROM tbladdressbook
WHERE age > (SELECT avg(age) FROM tbladdressbook GROUP BY gender HAVING gender = 'm') AND
		job IS NOT null;
					
					
					
					

-- tblAddressBook. gmail.com을 사용하는 사람들의 성별 > 세대별(10,20,30,40대) 인원수를 가져오시오.
SELECT
	count(CASE
		WHEN age BETWEEN 10 AND 19 THEN 1
	END) AS "10대",
	count(CASE
		WHEN age BETWEEN 20 AND 29 THEN 1
	END) AS "20대",
	count(CASE
		WHEN age BETWEEN 30 AND 39 THEN 1
	END) AS "30대",
	count(CASE
		WHEN age BETWEEN 40 AND 49 THEN 1
	END) AS "40대"
FROM tbladdressbook
	WHERE substr(email, instr(email, '@') + 1) =
		(SELECT
			substr(email, instr(email, '@') + 1)
		FROM tbladdressbook
			GROUP BY substr(email, instr(email, '@') + 1)
				HAVING substr(email, instr(email, '@') + 1) = 'gmail.com');


-- tblAddressBook. 가장 나이가 많으면서 가장 몸무게가 많이 나가는 사람과 같은 직업을 가지는 사람들을 가져오시오.
SELECT *
FROM tbladdressbook
	WHERE job = (SELECT job
				FROM tbladdressbook
					WHERE age = (SELECT max(age) FROM tbladdressbook) AND
							weight = (SELECT max(weight) FROM tbladdressbook));



-- tblAddressBook.  동명이인이 여러명 있습니다. 이 중 가장 인원수가 많은 동명이인(모든 이도윤)의 명단을 가져오시오.



-- tblAddressBook. 가장 사람이 많은 직업의(332명) 세대별 비율을 구하시오.
--    [10대]       [20대]       [30대]       [40대]
--    8.7%        30.7%        28.3%        32.2%

















-- tblStaff, tblProject. 현재 재직중인 모든 직원의 이름, 주소, 월급, 담당프로젝트명을 가져오시오.

       
       
-- tblVideo, tblRent, tblMember. '뽀뽀할까요' 라는 비디오를 빌려간 회원의 이름은?

    
    
-- tblStaff, tblProejct. 'TV 광고'을 담당한 직원의 월급은 얼마인가?

    
    
-- tblVideo, tblRent, tblMember. '털미네이터' 비디오를 한번이라도 빌려갔던 회원들의 이름은?

                
-- tblStaff, tblProject. 서울시에 사는 직원을 제외한 나머지 직원들의 이름, 월급, 담당프로젝트명을 가져오시오.

        
-- tblCustomer, tblSales. 상품을 2개(단일상품) 이상 구매한 회원의 연락처, 이름, 구매상품명, 수량을 가져오시오.

                                
-- tblVideo, tblRent, tblGenre. 모든 비디오 제목, 보유수량, 대여가격을 가져오시오.
          
                
-- tblVideo, tblRent, tblMember, tblGenre. 2007년 2월에 대여된 구매내역을 가져오시오. 회원명, 비디오명, 언제, 대여가격

        
-- tblVideo, tblRent, tblMember. 현재 반납을 안한 회원명과 비디오명, 대여날짜를 가져오시오.

    
    
-- employees, departments. 사원들의 이름, 부서번호, 부서명을 가져오시오.

        
        
-- employees, jobs. 사원들의 정보와 직업명을 가져오시오.

        
        
-- employees, jobs. 직무(job_id)별 최고급여(max_salary) 받는 사원 정보를 가져오시오.

      
    
    
-- departments, locations. 모든 부서와 각 부서가 위치하고 있는 도시의 이름을 가져오시오.

        
        
-- locations, countries. location_id 가 2900인 도시가 속한 국가 이름을 가져오시오.

            
            
-- employees. 급여를 12000 이상 받는 사원과 같은 부서에서 근무하는 사원들의 이름, 급여, 부서번호를 가져오시오.

        
        
-- employees, departments. locations.  'Seattle'에서(LOC) 근무하는 사원의 이름, Job_id, 부서번호, 부서이름을 가져오시오.

    
    
-- employees, departments. first_name이 'Jonathon'인 직원과 같은 부서에 근무하는 직원들 정보를 가져오시오.

    
    
-- employees, departments. 사원이름과 그 사원이 속한 부서의 부서명, 그리고 월급을 출력하는데 월급이 3000이상인 사원을 가져오시오.

            
            
-- employees, departments. 부서번호가 10번인 사원들의 부서번호, 부서이름, 사원이름, 월급을 가져오시오.

            
            
-- departments, job_history. 퇴사한 사원의 입사일, 퇴사일, 근무했던 부서 이름을 가져오시오.

        
        
-- employees. 사원번호와 사원이름, 그리고 그 사원을 관리하는 관리자의 사원번호와 사원이름을 출력하되 각각의 컬럼명을 '사원번호', '사원이름', '관리자번호', '관리자이름'으로 하여 가져오시오.

        
        
-- employees, jobs. 직책(Job Title)이 Sales Manager인 사원들의 입사년도와 입사년도(hire_date)별 평균 급여를 가져오시오. 년도를 기준으로 오름차순 정렬.




-- employees, departments. locations. 각 도시(city)에 있는 모든 부서 사원들의 평균급여가 가장 낮은 도시부터 도시명(city)과 평균연봉, 해당 도시의 사원수를 가져오시오. 단, 도시에 근 무하는 사원이 10명 이상인 곳은 제외하고 가져오시오.

            
            
-- employees, jobs, job_history. ‘Public  Accountant’의 직책(job_title)으로 과거에 근무한 적이 있는 모든 사원의 사번과 이름을 가져오시오. 현재 ‘Public Accountant’의 직책(job_title)으로 근무하는 사원은 고려 하지 말것.

    
    
-- employees, departments, locations. 커미션을 받는 모든 사람들의 first_name, last_name, 부서명, 지역 id, 도시명을 가져오시오.

    
    
-- employees. 자신의 매니저보다 먼저 고용된 사원들의 first_name, last_name, 고용일을 가져오시오.



