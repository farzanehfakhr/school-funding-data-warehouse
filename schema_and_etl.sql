CREATE TABLE staging_funding (
    school_year TEXT NULL,
    schoolname TEXT NULL,
    ncesid TEXT NULL,
    ncesdistid_admin TEXT NULL,
    ncesdistid_geo TEXT NULL,
    census_id TEXT NULL,
    pp_stloc_raw TEXT NULL,
    pp_fed_raw TEXT NULL,
    pp_total_raw TEXT NULL,
    pp_total_norm_NERDS TEXT NULL,
    flag_nerds TEXT NULL,
    flag_f33 TEXT NULL,
    schoolstloc_raw TEXT NULL,
    schoolfed_raw TEXT NULL,
    schooltot_raw TEXT NULL,
    distid_stateassigned TEXT NULL,
    schoolid_stateassigned TEXT NULL,
    distname TEXT NULL
);

COPY staging_funding 
FROM '/tmp/nerds_funding_cleaned.csv' 
WITH (FORMAT csv, HEADER true, NULL 'NRD');


--COPY staging_funding FROM '/tmp/nerds_funding_cleaned.csv'
--WITH (FORMAT csv, HEADER true, NULL 'NRD');

Drop Table staging_funding;

--COPY staging_funding FROM '/Users/farzanehfakhr/Documents/cleaned_output.csv' DELIMITER ',' CSV HEADER;

--COPY staging_funding FROM '/tmp/nerds_funding_cleaned.csv' DELIMITER ',' CSV HEADER;
COPY staging_funding FROM '/tmp/cleaned_output.csv' WITH (FORMAT csv, HEADER true, NULL '');
select * from staging_funding;

CREATE TABLE staging_test_scores (
    county_code TEXT,
    district_code TEXT,
    school_code TEXT,
    filler TEXT,
    test_year TEXT,
    student_group_id TEXT,
    test_type TEXT,
    total_tested TEXT,
    total_tested_with_scores TEXT,
    grade TEXT,
    test_id TEXT,
    students_enrolled TEXT,
    students_tested TEXT,
    mean_scale_score TEXT,
    percentage_standard_exceeded TEXT,
    percentage_standard_met TEXT,
    percentage_standard_met_and_above TEXT,
    percentage_standard_nearly_met TEXT,
    percentage_standard_not_met TEXT,
    students_with_scores TEXT,
    area1_percentage_above_standard TEXT,
    area1_percentage_near_standard TEXT,
    area1_percentage_below_standard TEXT,
    area2_percentage_above_standard TEXT,
    area2_percentage_near_standard TEXT,
    area2_percentage_below_standard TEXT,
    area3_percentage_above_standard TEXT,
    area3_percentage_near_standard TEXT,
    area3_percentage_below_standard TEXT,
    area4_percentage_above_standard TEXT,
    area4_percentage_near_standard TEXT,
    area4_percentage_below_standard TEXT,
    type_id TEXT
);

DROP TABLE staging_test_scores;
COPY staging_test_scores 
FROM '/tmp/performance.csv' 
WITH (FORMAT csv, HEADER true, NULL '');

UPDATE staging_test_scores
SET total_tested = NULLIF(total_tested, '*'),
    total_tested_with_scores = NULLIF(total_tested_with_scores, '*'),
    students_enrolled = NULLIF(students_enrolled, '*'),
    students_tested = NULLIF(students_tested, '*'),
    mean_scale_score = NULLIF(mean_scale_score, '*'),
    percentage_standard_exceeded = NULLIF(percentage_standard_exceeded, '*'),
    percentage_standard_met = NULLIF(percentage_standard_met, '*'),
    percentage_standard_met_and_above = NULLIF(percentage_standard_met_and_above, '*'),
    percentage_standard_nearly_met = NULLIF(percentage_standard_nearly_met, '*'),
    percentage_standard_not_met = NULLIF(percentage_standard_not_met, '*'),
    students_with_scores = NULLIF(students_with_scores, '*');


select * from staging_test_scores;

CREATE TABLE staging_school_data (
    county_code TEXT,
    district_code TEXT,
    school_code TEXT,
    filler TEXT,
    test_year TEXT,
    type_id TEXT,
    county_name TEXT,
    district_name TEXT,
    school_name TEXT,
    zip_code TEXT
);


COPY staging_school_data 
FROM '/tmp/entity1.csv' 
WITH (FORMAT csv, HEADER true, NULL '');

select * from staging_school_data;

CREATE TABLE staging_test_info (
    test_id TEXT NULL,
    test_id_num TEXT NULL,
    test_name TEXT NULL
);
copy staging_test_info FROM '/tmp/tests.csv' DELIMITER ',' CSV HEADER;

select * from staging_school_data;

CREATE TABLE staging_student_groups (
    demographic_id TEXT,
    demographic_id_num TEXT,
    demographic_name TEXT,
    student_group TEXT
);

--COPY staging_student_groups
--FROM '/tmp/StudentGroups.csv' 
--DELIMITER ',' 
--CSV HEADER;

--- create Tables
CREATE TABLE academic_year (
    year_id SERIAL PRIMARY KEY,
    school_year TEXT UNIQUE NOT NULL
);


CREATE TABLE county (
    county_id SERIAL PRIMARY KEY,
    county_code TEXT UNIQUE,
    county_name TEXT
);

INSERT INTO county (county_code, county_name)
SELECT DISTINCT county_code, county_name FROM staging_school_data;

select * from county;

CREATE TABLE district (
    district_id SERIAL PRIMARY KEY,
    district_code TEXT UNIQUE,
    district_name TEXT,
    county_id INT REFERENCES county(county_id)
);

CREATE TABLE school (
    school_id SERIAL PRIMARY KEY,
    school_code TEXT UNIQUE,
    school_name TEXT,
    district_id INT REFERENCES district(district_id),
    zip_code TEXT
);


select * from district;
drop table district;

INSERT INTO district (district_code, district_name, county_id)
SELECT DISTINCT s.district_code, s.district_name, c.county_id
FROM staging_school_data s
JOIN county c ON s.county_code = c.county_code
ON CONFLICT (district_code) DO NOTHING;
select * from district;

INSERT INTO school (school_code, school_name, district_id, zip_code)
SELECT DISTINCT s.school_code, s.school_name, d.district_id, s.zip_code
FROM staging_school_data s
JOIN district d ON s.district_code = d.district_code
ON CONFLICT (school_code) DO NOTHING;


select* from School;
drop Table school;

CREATE TABLE academic_year (
    year_id SERIAL PRIMARY KEY,
    school_year TEXT UNIQUE
);

INSERT INTO academic_year (school_year) 
VALUES ('2022');

UPDATE academic_year
SET school_year = '2021-2022'
WHERE school_year = '2022';


-----
SELECT d.district_code, d.district_name
FROM district d
JOIN county c ON d.county_id = c.county_id
WHERE c.county_name = 'Alameda'
ORDER BY d.district_name;

SELECT s.school_code, s.school_name,school_id
FROM school s
JOIN district d ON s.district_id = d.district_id
WHERE d.district_name LIKE '%Pleasanton%'
ORDER BY s.school_name;

SELECT s.school_code, s.school_name, d.district_name
FROM school s
JOIN district d ON s.district_id = d.district_id
JOIN county c ON d.county_id = c.county_id
WHERE c.county_name = 'Alameda'
ORDER BY d.district_name;

CREATE TABLE grades (
    grade_id SERIAL PRIMARY KEY,
    grade_code TEXT UNIQUE,
    grade_description TEXT
);

INSERT INTO grades (grade_code, grade_description) VALUES
    ('3', 'Grade 3'),
    ('4', 'Grade 4'),
    ('5', 'Grade 5'),
    ('6', 'Grade 6'),
    ('7', 'Grade 7'),
    ('8', 'Grade 8'),
    ('11', 'Grade 11'),
    ('13', 'All Grades (Includes Grades 3–8 and 11)');

	select * from grades;
	DROP table grades;

CREATE TABLE test (
    test_id SERIAL PRIMARY KEY,
    test_code INT UNIQUE,
    test_name TEXT
);

INSERT INTO test (test_code, test_name)
SELECT DISTINCT CAST(test_id_num AS integer), test_name
FROM staging_test_info
ON CONFLICT (test_code) DO NOTHING;

INSERT INTO test (test_code, test_name)
VALUES 
    (1, 'SB - English Language Arts/Literacy'),
    (2, 'SB - Mathematics')
ON CONFLICT (test_code) DO NOTHING;


INSERT INTO test (test_code, test_name)
SELECT DISTINCT test_id_num, test_name
FROM staging_test_info
ON CONFLICT (test_code) DO NOTHING;
select * from test;
Drop table test;
 -- still works on
CREATE TABLE student_group (
    group_id SERIAL PRIMARY KEY,
    demographic_id TEXT,
    demographic_id_num TEXT UNIQUE,
    demographic_name TEXT,
    student_group TEXT
);

INSERT INTO student_group (demographic_id, demographic_id_num, demographic_name, student_group)
SELECT DISTINCT demographic_id, demographic_id_num, demographic_name, student_group
FROM staging_student_groups
ON CONFLICT (demographic_id_num) DO NOTHING;


select * from student_group;

--- normalize table funding 
CREATE TABLE districtf (
    districtf_id SERIAL PRIMARY KEY,
    ncesdistid_admin TEXT UNIQUE,  
    ncesdistid_geo TEXT,
    distid_stateassigned TEXT,
    distname TEXT
);

CREATE TABLE schoolf (
    schoolf_id SERIAL PRIMARY KEY,
    ncesid TEXT UNIQUE,
    schoolname TEXT,
    census_id TEXT,
    schoolid_stateassigned TEXT,
    districtf_id INT REFERENCES districtf(districtf_id)
);
select * from schoolf;


CREATE TABLE fundingf (
    funding_id SERIAL PRIMARY KEY,
    schoolf_id INT REFERENCES schoolf(schoolf_id),
    year_id INT REFERENCES academic_year(year_id),
    pp_stloc_raw TEXT,
    pp_fed_raw TEXT,
    pp_total_raw TEXT,
    schoolstloc_raw TEXT,
    schoolfed_raw TEXT,
    schooltot_raw TEXT,
    UNIQUE (schoolf_id, year_id)
);
DROP Table fundingf;
INSERT INTO districtf (ncesdistid_admin, ncesdistid_geo, distid_stateassigned, distname)
SELECT DISTINCT
    ncesdistid_admin,
    ncesdistid_geo,
    distid_stateassigned,
    distname
FROM staging_funding
WHERE ncesdistid_admin IS NOT NULL;

INSERT INTO schoolf (ncesid, schoolname, census_id, schoolid_stateassigned, districtf_id)
SELECT DISTINCT
    st.ncesid,
    st.schoolname,
    st.census_id,
    st.schoolid_stateassigned,
    d.districtf_id
FROM staging_funding st
JOIN districtf d ON st.ncesdistid_admin = d.ncesdistid_admin
WHERE st.ncesid IS NOT NULL;

select * from schoolf;

INSERT INTO fundingf (
    schoolf_id, 
    year_id, 
    pp_stloc_raw, 
    pp_fed_raw, 
    pp_total_raw,
    schoolstloc_raw, 
    schoolfed_raw, 
    schooltot_raw
)
SELECT DISTINCT
    schf.schoolf_id,
    ay.year_id,
    st.pp_stloc_raw::numeric,
    st.pp_fed_raw::numeric,
    st.pp_total_raw::numeric,
    st.schoolstloc_raw::numeric,
    st.schoolfed_raw::numeric,
    st.schooltot_raw::numeric
FROM staging_funding st
JOIN schoolf schf ON st.ncesid = schf.ncesid
JOIN academic_year ay ON st.school_year = ay.school_year;
select * from fundingf;

CREATE TABLE school_mapping1 (
    mapping_id SERIAL PRIMARY KEY,
    school_id INT NOT NULL REFERENCES school(school_id),
    schoolf_id INT NOT NULL REFERENCES schoolf(schoolf_id)
);

INSERT INTO school_mapping1 (school_id, schoolf_id)
SELECT s.school_id, sf.schoolf_id
FROM school s
JOIN district d ON s.district_id = d.district_id
JOIN schoolf sf ON s.school_name = sf.schoolname
JOIN districtf df ON sf.districtf_id = df.districtf_id
WHERE d.district_name = df.distname;

--

drop Table school_mapping1;
---
select * from school_mapping1;

SELECT 
    ts.test_score_id,
    ts.school_id,
    ts.year_id,
    ts.grade_id,
    ts.test_id,
    ts.student_group_id,
    ts.total_tested,
    ts.total_tested_with_scores,
    ts.students_enrolled,
    ts.students_tested,
    ts.students_with_scores,
    ts.mean_scale_score,
    ts.percentage_standard_exceeded,
    ts.percentage_standard_met,
    ts.percentage_standard_met_and_above,
    ts.percentage_standard_nearly_met,
    ts.percentage_standard_not_met,
    ff.funding_id,
    ff.pp_stloc_raw,
    ff.pp_fed_raw,
    ff.pp_total_raw,
    ff.schoolstloc_raw,
    ff.schoolfed_raw,
    ff.schooltot_raw,
    sm.mapping_id
FROM test_scores ts
JOIN school_mapping1 sm ON ts.school_id = sm.school_id
JOIN fundingf ff ON sm.schoolf_id = ff.schoolf_id
where ts.school_id=10182;
select * from school_mapping1
drop Table school_mapping1;
----

--- create 
CREATE TABLE test_scores (
    test_score_id SERIAL PRIMARY KEY,
    school_id INT NOT NULL REFERENCES school(school_id),
    grade_id INT NOT NULL REFERENCES grades(grade_id),
    year_id INT NOT NULL REFERENCES academic_year(year_id),
    test_id INT NOT NULL REFERENCES test(test_id),
    student_group_id TEXT,
    total_tested TEXT,
    total_tested_with_scores TEXT,
    students_enrolled TEXT,
    students_tested TEXT,
    students_with_scores TEXT,
    mean_scale_score TEXT,
    percentage_standard_exceeded TEXT,
    percentage_standard_met TEXT,
    percentage_standard_met_and_above TEXT,
    percentage_standard_nearly_met TEXT,
    percentage_standard_not_met TEXT
    
);

INSERT INTO test_scores (
    school_id,
    grade_id,
    year_id,
    test_id,
    student_group_id,
    total_tested,
    total_tested_with_scores,
    students_enrolled,
    students_tested,
    students_with_scores,
    mean_scale_score,
    percentage_standard_exceeded,
    percentage_standard_met,
    percentage_standard_met_and_above,
    percentage_standard_nearly_met,
    percentage_standard_not_met
)
SELECT
    s.school_id,
    g.grade_id,
    ay.year_id,
    t.test_code,
    st.student_group_id,
    st.total_tested,
    st.total_tested_with_scores,
    st.students_enrolled,
    st.students_tested,
    st.students_with_scores,
    st.mean_scale_score,
    st.percentage_standard_exceeded,
    st.percentage_standard_met,
    st.percentage_standard_met_and_above,
    st.percentage_standard_nearly_met,
    st.percentage_standard_not_met
FROM staging_test_scores st
JOIN school s 
    ON st.school_code = s.school_code
JOIN grades g 
    ON st.grade = g.grade_code  -- 
JOIN test t 
    ON st.test_id::int = t.test_code  -- 
JOIN academic_year ay ON ay.school_year = 
    CASE 
        WHEN st.test_year = '2022' THEN '2021-2022' 
        ELSE st.test_year 
    END;

select* from test_scores;
DROP table test_scores;





-------- dimentional Design
Drop table dim_school;
CREATE TABLE dim_school (
    school_key SERIAL PRIMARY KEY,
    school_id INT,  -- from the normalized school table
    school_name TEXT,
    school_code TEXT,
    district_name TEXT,
    county_name TEXT,
    zip_code TEXT
);

INSERT INTO dim_school (school_id, school_name, school_code, district_name, county_name, zip_code)
SELECT 
    s.school_id,
    s.school_name,
    s.school_code,
    d.district_name,
    c.county_name,
    s.zip_code
FROM school s
JOIN district d ON s.district_id = d.district_id
JOIN county c ON d.county_id = c.county_id;


ALTER TABLE dim_school 
ADD COLUMN valid_from DATE NOT NULL DEFAULT CURRENT_DATE,
ADD COLUMN valid_to DATE NULL,
ADD COLUMN is_current BOOLEAN NOT NULL DEFAULT TRUE;

CREATE OR REPLACE FUNCTION update_dim_school(
    p_school_id INT,
    p_school_name TEXT,
	p_school_code TEXT,
    p_district_name TEXT,
    p_county_name TEXT,
    p_zip_code TEXT
) RETURNS VOID AS $$
DECLARE
    existing_record RECORD;
BEGIN
    -- Find existing active record
    SELECT * INTO existing_record 
    FROM dim_school 
    WHERE school_id = p_school_id AND is_current = TRUE;

    -- If school details changed, create a new version
    IF existing_record IS NOT NULL AND 
       (existing_record.school_name <> p_school_name OR
        existing_record.district_name <> p_district_name OR
		existing_record.county_name <> p_county_name OR
        existing_record.zip_code <> p_zip_code) THEN
        
        -- Mark old record as inactive
        UPDATE dim_school
        SET valid_to = CURRENT_DATE, is_current = FALSE
        WHERE school_id = p_school_id AND is_current = TRUE;

        -- Insert new version
        INSERT INTO dim_school (school_id, school_name,school_code, district_name,county_name, zip_code, valid_from, is_current)
        VALUES (p_school_id, p_school_name, p_school_code,p_district_name, p_county_name,p_zip_code, CURRENT_DATE, TRUE);
    END IF;
END;
$$ LANGUAGE plpgsql;
----

CREATE OR REPLACE FUNCTION update_dim_school(
    p_school_id INT,
    p_school_name TEXT,
    p_school_code TEXT,
    p_district_name TEXT,
    p_county_name TEXT,
    p_zip_code TEXT
) RETURNS VOID AS $$
DECLARE
    existing_record RECORD;
BEGIN
    -- Check if the school exists and is active
    SELECT * INTO existing_record 
    FROM dim_school 
    WHERE school_code = p_school_code AND is_current = TRUE;

    -- If school does not exist, insert a new record
    IF existing_record IS NULL THEN
        INSERT INTO dim_school (school_id, school_name, school_code, district_name, county_name, zip_code, valid_from, is_current)
        VALUES (p_school_id, p_school_name, p_school_code, p_district_name, p_county_name, p_zip_code, CURRENT_DATE, TRUE);
    
    -- If the school exists but has changed, update with a new version
    ELSIF (existing_record.school_name <> p_school_name OR
           existing_record.district_name <> p_district_name OR
           existing_record.county_name <> p_county_name OR
           existing_record.zip_code <> p_zip_code) THEN
        
        -- Mark old record as inactive
        UPDATE dim_school
        SET valid_to = CURRENT_DATE, is_current = FALSE
        WHERE school_key = existing_record.school_key;

        -- Insert new version
        INSERT INTO dim_school (school_id, school_name, school_code, district_name, county_name, zip_code, valid_from, is_current)
        VALUES (p_school_id, p_school_name, p_school_code, p_district_name, p_county_name, p_zip_code, CURRENT_DATE, TRUE);
    END IF;
END;
$$ LANGUAGE plpgsql;

SELECT update_dim_school(2, 'Environmental Charter High - Lawndale','1996438', 'Environmental Charter High - Lawndale','Los Angeles', '94607');

select * from dim_school where is_current = False;
---- update fact table

DROP FUNCTION update_fact_school_metrics();
---
CREATE OR REPLACE FUNCTION update_fact_school_metrics()
RETURNS TRIGGER AS $$
BEGIN
    -- Update fact table to reference the latest active school version
    UPDATE fact_school_metrics f
    SET school_key = ds.school_key
    FROM dim_school ds
    WHERE f.school_key = OLD.school_key  -- Ensure we're updating the correct records
    AND ds.is_current = TRUE;
    
    RETURN NEW; -- Required for a trigger function
END;
$$ LANGUAGE plpgsql;


CREATE TABLE dim_academic_year (
    year_id SERIAL PRIMARY KEY,
    school_year TEXT NOT NULL UNIQUE
);

INSERT INTO dim_academic_year (school_year)
SELECT DISTINCT school_year FROM academic_year;


CREATE TABLE dim_test (
    test_id SERIAL PRIMARY KEY,
    test_name TEXT NOT NULL UNIQUE
);

INSERT INTO dim_test (test_name)
SELECT DISTINCT test_name FROM test;

select * from dim_test;
DRop Table dim_test;
CREATE TABLE dim_grade (
    grade_id SERIAL PRIMARY KEY,
    grade_level TEXT NOT NULL UNIQUE
);

INSERT INTO dim_grade (grade_level)
SELECT DISTINCT grade_code FROM grades;
select * from dim_grade;

drop table fact_school_metrics;
CREATE TABLE fact_school_metrics (
    metric_id SERIAL PRIMARY KEY,
    school_key INT REFERENCES dim_school(school_key) ON DELETE CASCADE,
    test_id INT REFERENCES dim_test(test_id) ON DELETE CASCADE,
    grade_id INT REFERENCES dim_grade(grade_id) ON DELETE CASCADE,
    year_id INT REFERENCES dim_academic_year(year_id) ON DELETE CASCADE,

    -- Performance Metrics
    total_tested NUMERIC,
    mean_scale_score NUMERIC,
    pct_standard_exceeded NUMERIC,
    pct_standard_met NUMERIC,
    pct_standard_met_above NUMERIC,
    pct_standard_nearly_met NUMERIC,
    pct_standard_not_met NUMERIC,

    -- Funding Metrics
    pp_stloc_raw NUMERIC,
    pp_fed_raw NUMERIC,
    pp_total_raw NUMERIC,
    schoolstloc_raw NUMERIC,
    schoolfed_raw NUMERIC,
    schooltot_raw NUMERIC
);


 INSERT INTO fact_school_metrics (
    school_key, 
    test_id, 
    grade_id, 
    year_id, 
    total_tested, 
    mean_scale_score, 
    pct_standard_exceeded, 
    pct_standard_met, 
    pct_standard_met_above, 
    pct_standard_nearly_met, 
    pct_standard_not_met,
    pp_stloc_raw, 
    pp_fed_raw, 
    pp_total_raw, 
    schoolstloc_raw, 
    schoolfed_raw, 
    schooltot_raw
)
SELECT 
    ds.school_key, 
    t.test_id, 
    g.grade_id, 
    ay.year_id, 
    CAST(p.total_tested AS NUMERIC), 
    CAST(p.mean_scale_score AS NUMERIC), 
    CAST(p.percentage_standard_exceeded AS NUMERIC), 
    CAST(p.percentage_standard_met AS NUMERIC), 
    CAST(p.percentage_standard_met_and_above AS NUMERIC), 
    CAST(p.percentage_standard_nearly_met AS NUMERIC), 
    CAST(p.percentage_standard_not_met AS NUMERIC),
    CAST(f.pp_stloc_raw AS NUMERIC), 
    CAST(f.pp_fed_raw AS NUMERIC), 
    CAST(f.pp_total_raw AS NUMERIC), 
    CAST(f.schoolstloc_raw AS NUMERIC), 
    CAST(f.schoolfed_raw AS NUMERIC), 
    CAST(f.schooltot_raw AS NUMERIC)
FROM test_scores p
JOIN school_mapping1 sm ON p.school_id = sm.school_id
JOIN dim_school ds ON sm.schoolf_id = ds.school_id
JOIN dim_test t ON p.test_id = t.test_id
JOIN dim_grade g ON p.grade_id = g.grade_id
JOIN dim_academic_year ay ON p.year_id = ay.year_id
LEFT JOIN fundingf f ON ds.school_id = f.schoolf_id AND ay.year_id = f.year_id;
   
 ---Query for performance and funding   ----
SELECT 
    f.metric_id, 
    ds.school_name, 
    ds.district_name, 
    ay.school_year,
    t.test_name, 
    g.grade_level, 
    
    -- Performance Metrics
    f.total_tested, 
    f.mean_scale_score, 
    f.pct_standard_exceeded, 
    f.pct_standard_met, 
    f.pct_standard_met_above, 
    f.pct_standard_nearly_met, 
    f.pct_standard_not_met,

    -- Funding Metrics
    f.pp_stloc_raw, 
    f.pp_fed_raw, 
    f.pp_total_raw, 
    f.schoolstloc_raw, 
    f.schoolfed_raw, 
    f.schooltot_raw

FROM fact_school_metrics f
JOIN dim_school ds ON f.school_key = ds.school_key
JOIN dim_academic_year ay ON f.year_id = ay.year_id
JOIN dim_test t ON f.test_id = t.test_id
JOIN dim_grade g ON f.grade_id = g.grade_id

-- Only include funding if available 
ORDER BY ds.school_name, ay.school_year, g.grade_level;

    
SELECT COUNT(*) FROM fact_school_metrics;
SELECT * FROM fact_school_metrics;

---
SELECT f.metric_id, f.school_key, ds.school_name, ds.is_current, ds.valid_from, ds.valid_to
FROM fact_school_metrics f
JOIN dim_school ds ON f.school_key = ds.school_key
ORDER BY ds.school_key;


