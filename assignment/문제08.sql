-- rownum + group by


-- 1. tblInsa. 남자 급여(기본급+수당)을 (내림차순)순위대로 가져오시오. (이름, 부서, 직위, 급여, 순위 출력)
SELECT
	a.*, rownum
FROM (SELECT
			name, buseo, jikwi, basicpay + sudang AS 급여
		FROM tblinsa
			WHERE substr(ssn, 8, 1) = 1
				ORDER BY 급여 DESC) a;


-- 2. tblInsa. 여자 급여(기본급+수당)을 (오름차순)순위대로 가져오시오. (이름, 부서, 직위, 급여, 순위 출력)
SELECT
	a.*, rownum
FROM (SELECT
			name, buseo, jikwi, basicpay + sudang AS 급여
		FROM tblinsa
			WHERE substr(ssn, 8, 1) = 2
				ORDER BY 급여) a;

			
			
			

-- 3. tblInsa. 여자 인원수가 (가장 많은 부서 및 인원수) 가져오시오.
SELECT
	a.*, rownum
FROM (SELECT
		buseo, count(*)
	FROM tblinsa
		GROUP BY buseo, substr(ssn, 8, 1)
			HAVING substr(ssn, 8, 1) = 2
				ORDER BY count(*) DESC) a
	WHERE rownum = 1;

select * from (select buseo, count(*) as cnt from tblinsa where substr(ssn, 8, 1) = '2'
	group by buseo order by count(*) desc) where rownum = 1;



-- 4. tblInsa. 지역별 인원수 (내림차순)순위를 가져오시오.(city, 인원수)


-- 5. tblInsa. 부서별 인원수가 가장 많은 부서 및원수 출력.


-- 6. tblInsa. 남자 급여(기본급+수당)을 (내림차순) 3~5등까지 가져오시오. (이름, 부서, 직위, 급여, 순위 출력)


-- 7. tblInsa. 입사일이 빠른 순서로 5순위까지만 가져오시오.


-- 8. tblhousekeeping. 지출 내역(가격 * 수량) 중 가장 많은 금액을 지출한 내역 3가지를 가져오시오.


-- 9. tblinsa. 평균 급여 2위인 부서에 속한 직원들을 가져오시오.


-- 10. tbltodo. 등록 후 가장 빠르게 완료한 할일을 순서대로 5개 가져오시오.


-- 11. tblinsa. 남자 직원 중에서 급여를 3번째로 많이 받는 직원과 9번째로 많이 받는 직원의 급여 차액은 얼마인가?










