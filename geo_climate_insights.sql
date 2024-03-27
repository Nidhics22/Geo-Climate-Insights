create database lmu;

use lmu;

create table mean_sea_level(
    object_id INT PRIMARY KEY,
    country VARCHAR(10),
    iso2 VARCHAR(2),
    iso3 VARCHAR(3),
    indicator VARCHAR(52),
    unit VARCHAR(11),
    source VARCHAR(400),
    cts_code VARCHAR(4),
    cts_name VARCHAR(70),
    measure VARCHAR(20),
    date DATE,
    value FLOAT
);

CREATE TABLE country_sea (
    country varchar(200),
    sea varchar(200)
);


CREATE table country_temperature (
    date DATE,
    average_temperature FLOAT,
    average_temperature_uncertainty FLOAT,
    country varchar(200)
);



SELECT * from (SELECT
    DATE_FORMAT(date, '%Y-%m') AS month_year,
    country,
    MAX(average_temperature) AS max_average_temperature
FROM
    country_temperature
where
    date > '1992-11-30' and
    average_temperature IS NOT NULL
GROUP BY
    month_year, country
order by
    country, month_year) as ct ;


SELECT
    msl.month_year as month,
    ct.country,
    msl.sea,
    msl.max_sea_level,
    ct.max_average_temperature
FROM
    (SELECT
        DATE_FORMAT(date, '%Y-%m') AS month_year,
        measure AS sea,
        MAX(value) AS max_sea_level
    FROM
        mean_sea_level
    GROUP BY
        month_year, measure) AS msl
JOIN
    (SELECT
        DATE_FORMAT(date, '%Y-%m') AS month_year,
        country,
        MAX(average_temperature) AS max_average_temperature
    FROM
        country_temperature
    WHERE
        date > '1992-11-30' AND
        average_temperature IS NOT NULL
    GROUP BY
        month_year, country
   ) AS ct ON msl.month_year = ct.month_year
AND msl.sea = (SELECT sea FROM country_sea WHERE country = ct.country)
where country = 'New Zealand'
order by country, month desc;