-- ex04_operator

/*
    연산자, Operator
    
    1. 산술연산자
    - +, -, *, /
    - %(없음) > 함수로 제공 mod()
    
    2. 



*/

select
    population,
    area,
    population + area,
    population - area,
    population * area,
    population / area
from tblCountry;