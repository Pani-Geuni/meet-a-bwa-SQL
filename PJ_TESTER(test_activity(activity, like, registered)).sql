-- (TEST_ACTIVITY) CREATE TABLE
CREATE TABLE TEST_ACTIVITY(	
    ACTIVITY_NO VARCHAR2(100 BYTE) NOT NULL, 
	ACTIVITY_IMAGE VARCHAR2(4000 BYTE), 
	ACTIVITY_NAME VARCHAR2(40 BYTE) NOT NULL, 
	ACTIVITY_DESCRIPTION VARCHAR2(2000 BYTE) NOT NULL, 
	ACTIVITY_CITY VARCHAR2(40 BYTE), 
	ACTIVITY_COUNTY VARCHAR2(40 BYTE), 
	ACTIVITY_INTEREST_NAME VARCHAR2(60 BYTE), 
	ACTIVITY_GENDER VARCHAR2(8 BYTE), 
	ACTIVITY_NOP NUMBER NOT NULL, 
	ACTIVITY_AGE NUMBER, 
	ACTIVITY_DATE DATE NOT NULL, 
	USER_NO VARCHAR2(100 BYTE) NOT NULL,
    MEET_NO VARCHAR2(100 BYTE) NOT NULL
);

-- (TEST_ACTIVITY) PRIMARY KEY SET
ALTER TABLE TEST_ACTIVITY
ADD CONSTRAINT TEST_ACTIVITY_PK PRIMARY KEY
(
  ACTIVITY_NO 
)
ENABLE;

-- (TEST_ACTIVITY) FOREIGN KEY SET
ALTER TABLE TEST_ACTIVITY
ADD CONSTRAINT TEST_ACTIVITY_FK1 FOREIGN KEY
(
  USER_NO 
)
REFERENCES TEST_USER
(
  USER_NO 
)
ENABLE;
ALTER TABLE TEST_ACTIVITY
ADD CONSTRAINT TEST_ACTIVITY_FK2 FOREIGN KEY
(
  MEET_NO 
)
REFERENCES TEST_MEET
(
  MEET_NO 
)
ENABLE;

-- SEQUENCE CREATE
drop sequence SEQ_TEST_ACTIVITY;
CREATE SEQUENCE SEQ_TEST_ACTIVITY INCREMENT BY 1 START WITH 1001;

insert into test_activity(activity_no, activity_name, activity_description, activity_city, activity_county, activity_interest_name, activity_gender, activity_nop, activity_age, activity_date, user_no, meet_no)
values ('A'||SEQ_TEST_ACTIVITY.nextval, '20대 모임', '20대들 모여라아!', '서울특별시', '역삼동', '친목/모임', 'F', 20, 20, '20220926', 'U1003', 'M1002');
insert into test_activity(activity_no, activity_name, activity_description, activity_city, activity_county, activity_interest_name, activity_gender, activity_nop, activity_age, activity_date, user_no, meet_no)
values ('A'||SEQ_TEST_ACTIVITY.nextval, '금광동 골프존 액티비티', '금광동 액티비티입니다..', '경기도', '성남시', null, null, 20, null, '20220926', 'U1001',  'M1004');
commit;
rollback;

------------------------------------------------------------------------------

-- (TEST_ACTIVITY_LIKE) TABLE CREATE
CREATE TABLE TEST_ACTIVITY_LIKE(	
    ACTIVITY_LIKE_NO VARCHAR2(100 BYTE) NOT NULL,
	ACTIVITY_NO VARCHAR2(100 BYTE) NOT NULL,
	USER_NO VARCHAR2(100 BYTE) NOT NULL
);
   
-- (TEST_ACTIVITY_LIKE) PRIMARY KEY SET
ALTER TABLE TEST_ACTIVITY_LIKE
ADD CONSTRAINT TEST_ACTIVITY_LIKE_PK PRIMARY KEY
(
  ACTIVITY_LIKE_NO 
)
ENABLE;

-- (TEST_ACTIVITY_LIKE) FOREIGN KEY SET
ALTER TABLE TEST_ACTIVITY_LIKE
ADD CONSTRAINT TEST_ACTIVITY_LIKE_FK1 FOREIGN KEY
(
  ACTIVITY_NO 
)
REFERENCES TEST_ACTIVITY
(
  ACTIVITY_NO 
)
ENABLE;
ALTER TABLE c
ADD CONSTRAINT TEST_ACTIVITY_LIKE_FK2 FOREIGN KEY
(
  USER_NO 
)
REFERENCES TEST_USER
(
  USER_NO 
)
ENABLE;

-- SEQUENCE CREATE
drop SEQUENCE SEQ_TEST_ACTIVITY_L; 
CREATE SEQUENCE SEQ_TEST_ACTIVITY_L INCREMENT BY 1 START WITH 1001;

insert into TEST_ACTIVITY_LIKE(ACTIVITY_LIKE_NO, ACTIVITY_NO, USER_NO)
values ('AL'||SEQ_TEST_ACTIVITY_L.nextval, 'A1002', 'U1002');
insert into TEST_ACTIVITY_LIKE(ACTIVITY_LIKE_NO, ACTIVITY_NO, USER_NO)
values ('AL'||SEQ_TEST_ACTIVITY_L.nextval, 'A1002', 'U1003');
commit;
rollback;



--------------------------------------------------------------------------------------------------------


-- (TEST_ACTIVITY_REGISTERED) TABLE CREATE
CREATE TABLE TEST_ACTIVITY_REGISTERED(	
    REGISTERED_NO VARCHAR2(100 BYTE) NOT NULL,
	ACTIVITY_NO VARCHAR2(100 BYTE) NOT NULL,
	USER_NO VARCHAR2(100 BYTE) NOT NULL
);
   
-- (TEST_ACTIVITY_REGISTERED) PRIMARY KEY SET
ALTER TABLE TEST_ACTIVITY_REGISTERED
ADD CONSTRAINT TEST_ACTIVITY_REGISTERED_PK PRIMARY KEY
(
  REGISTERED_NO 
)
ENABLE;

-- (TEST_ACTIVITY_REGISTERED) FOREIGN KEY SET
ALTER TABLE TEST_ACTIVITY_REGISTERED
ADD CONSTRAINT TEST_ACTIVITY_REGISTERED_FK1 FOREIGN KEY
(
  ACTIVITY_NO 
)
REFERENCES TEST_ACTIVITY
(
  ACTIVITY_NO 
)
ENABLE;
ALTER TABLE TEST_ACTIVITY_REGISTERED
ADD CONSTRAINT TEST_ACTIVITY_REGISTERED_FK2 FOREIGN KEY
(
  USER_NO 
)
REFERENCES TEST_USER
(
  USER_NO 
)
ENABLE;


-- SEQUENCE CREATE
drop SEQUENCE SEQ_TEST_ACTIVITY_R; 
CREATE SEQUENCE SEQ_TEST_ACTIVITY_R INCREMENT BY 1 START WITH 1001;


insert into test_activity_registered(REGISTERED_NO, activity_no, user_no)
values ('AR'||SEQ_TEST_ACTIVITY_R.NEXTVAL, 'A1002', 'U1001');
insert into test_activity_registered(REGISTERED_NO, activity_no, user_no)
values ('AR'||SEQ_TEST_ACTIVITY_R.NEXTVAL, 'A1002', 'U1002');
insert into test_activity_registered(REGISTERED_NO, activity_no, user_no)
values ('AR'||SEQ_TEST_ACTIVITY_R.NEXTVAL, 'A1001', 'U1003');
commit;


-----------------------------------------------------------------------------------------------

create or replace view activity_join_view
as (
    select a2.activity_no, activity_image, activity_name, activity_description, activity_city, activity_county, activity_interest_name, activity_gender, activity_nop, activity_age, activity_date, user_no, meet_no, like_cnt, a3.user_cnt
from (
        select activity_no, activity_image, activity_name, activity_description, activity_city, activity_county, activity_interest_name, activity_gender, activity_nop, activity_age, activity_date, user_no, meet_no, a1.like_cnt
        from test_activity a left outer join
            (select activity_no as activity_no2, count(activity_no) as like_cnt 
            from test_activity_like 
            group by activity_no) a1 on a.activity_no = a1.activity_no2) a2
            left outer join (select activity_no as activity_no3, count(activity_no) as user_cnt from test_activity_registered group by activity_no) a3 on a2.activity_no = a3.activity_no3
);

select * from activity_join_view order by activity_no;


select activity_no, activity_image, activity_name, activity_description, activity_city, activity_county, activity_interest_name, activity_gender, activity_nop, activity_age, activity_date, user_no, meet_no, like_cnt, user_cnt
from activity_join_view
where rownum between 1 and 10
order by activity_no;

