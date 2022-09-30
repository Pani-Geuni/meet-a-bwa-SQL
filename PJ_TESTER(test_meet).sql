-- TEST_MEET CREATE TABLE
CREATE TABLE TEST_MEET(	
    MEET_NO VARCHAR2(100 BYTE) NOT NULL, 
	MEET_IMAGE VARCHAR2(4000 BYTE), 
	MEET_NAME VARCHAR2(40 BYTE) NOT NULL, 
	MEET_DESCRIPTION VARCHAR2(2000 BYTE) NOT NULL, 
	MEET_CITY VARCHAR2(40 BYTE), 
	MEET_COUNTY VARCHAR2(40 BYTE), 
	MEET_INTEREST_NAME VARCHAR2(60 BYTE), 
	MEET_GENDER VARCHAR2(8 BYTE), 
	MEET_NOP NUMBER NOT NULL, 
	MEET_AGE NUMBER, 
	MEET_DATE DATE NOT NULL, 
	USER_NO VARCHAR2(20 BYTE) NOT NULL
);

-- TEST_MEET PRIMARY KEY SET
ALTER TABLE TEST_MEET
ADD CONSTRAINT TEST_MEET_PK PRIMARY KEY
(
  MEET_NO 
)
ENABLE;

-- TEST_MEET FOREIGN KEY SET
ALTER TABLE TEST_MEET
ADD CONSTRAINT TEST_MEET_FK1 FOREIGN KEY
(
  USER_NO 
)
REFERENCES TEST_USER
(
  USER_NO 
)
ENABLE;

-- SEQUENCE CREATE
CREATE SEQUENCE SEQ_TEST_MEET INCREMENT BY 1 START WITH 1001;

insert into test_meet(MEET_NO, MEET_NAME, MEET_DESCRIPTION, MEET_CITY, MEET_COUNTY, MEET_INTEREST_NAME, MEET_GENDER, MEET_NOP, MEET_AGE, MEET_DATE, USER_NO) 
values ('M'||SEQ_TEST_MEET.NEXTVAL, '경기광주 커피처돌이', '경기광주 거주하시는 커피처돌이님들 대환영입니다^^', '경기도', '광주시', '취미', null, 20,  20, '2022-09-24', 'U1002');
insert into test_meet(MEET_NO, MEET_NAME, MEET_DESCRIPTION, MEET_CITY, MEET_COUNTY, MEET_INTEREST_NAME, MEET_GENDER, MEET_NOP, MEET_AGE, MEET_DATE, USER_NO) 
values ('M'||SEQ_TEST_MEET.NEXTVAL, '성남동초등학교 동창회', '12기 성남동초등학교 동창회를 모집합니다!!!', '경기도', '성남시', '친목/모임', null, 20,  null, '2022-09-25', 'U1001');
insert into test_meet(MEET_NO, MEET_NAME, MEET_DESCRIPTION, MEET_CITY, MEET_COUNTY, MEET_INTEREST_NAME, MEET_GENDER, MEET_NOP, MEET_AGE, MEET_DATE, USER_NO) 
values ('M'||SEQ_TEST_MEET.NEXTVAL, '경기도 성남시 거주민 모임', '경기도 성남사람들 이리오슈', '경기도', '성남시', '친목/모임', null, 10,  null, '2022-09-27', 'U1003');
commit;
ROLLBACK;

--------------------------------------------------------------------------------------------------------------------

-- TEST_MEET_LIKE TABLE CREATE
CREATE TABLE TEST_MEET_LIKE(	
    MEET_LIKE_NO VARCHAR2(100 BYTE) NOT NULL,
	MEET_NO VARCHAR2(100 BYTE) NOT NULL,
	USER_NO VARCHAR2(100 BYTE) NOT NULL
);
   
-- TEST_MEET_LIKE PRIMARY KEY SET
ALTER TABLE TEST_MEET_LIKE
ADD CONSTRAINT TEST_MEET_LIKE_PK PRIMARY KEY
(
  MEET_LIKE_NO 
)
ENABLE;

-- TEST_MEET_LIKE FOREIGN KEY SET
ALTER TABLE TEST_MEET_LIKE
ADD CONSTRAINT TEST_MEET_LIKE_FK1 FOREIGN KEY
(
  MEET_NO 
)
REFERENCES TEST_MEET
(
  MEET_NO 
)
ENABLE;
ALTER TABLE TEST_MEET_LIKE
ADD CONSTRAINT TEST_MEET_LIKE_FK2 FOREIGN KEY
(
  USER_NO 
)
REFERENCES TEST_USER
(
  USER_NO 
)
ENABLE;

-- SEQUENCE CREATE
CREATE SEQUENCE SEQ_TEST_MEET_L INCREMENT BY 1 START WITH 1001;

insert into TEST_MEET_LIKE(meet_like_no, meet_no, user_no) values ('ML'||SEQ_TEST_MEET_L.nextval, 'M1001', 'U1001');
insert into TEST_MEET_LIKE(meet_like_no, meet_no, user_no) values ('ML'||SEQ_TEST_MEET_L.nextval, 'M1001', 'U1002');
commit;
rollback;


--------------------------------------------------------------------------------------------------------------------


-- (TEST_MEET_REGISTERED) TABLE CREATE
CREATE TABLE TEST_MEET_REGISTERED(	
    REGISTERED_NO VARCHAR2(100 BYTE) NOT NULL,
	MEET_NO VARCHAR2(100 BYTE) NOT NULL,
	USER_NO VARCHAR2(100 BYTE) NOT NULL
);
   
-- (TEST_MEET_REGISTERED) PRIMARY KEY SET
ALTER TABLE TEST_MEET_REGISTERED
ADD CONSTRAINT TEST_MEET_REGISTERED_PK PRIMARY KEY
(
  REGISTERED_NO 
)
ENABLE;

-- TEST_MEET_LIKE FOREIGN KEY SET
ALTER TABLE TEST_MEET_REGISTERED
ADD CONSTRAINT TEST_MEET_REGISTERED_FK1 FOREIGN KEY
(
  MEET_NO 
)
REFERENCES TEST_MEET
(
  MEET_NO 
)
ENABLE;
ALTER TABLE TEST_MEET_REGISTERED
ADD CONSTRAINT TEST_MEET_REGISTERED_FK2 FOREIGN KEY
(
  USER_NO 
)
REFERENCES TEST_USER
(
  USER_NO 
)
ENABLE;

-- SEQUENCE CREATE
CREATE SEQUENCE SEQ_TEST_MEET_R INCREMENT BY 1 START WITH 1001;

insert into TEST_MEET_REGISTERED(registered_no, meet_no, user_no) values ('MR'||SEQ_TEST_MEET_R.nextval, 'M1001', 'U1001');
insert into TEST_MEET_REGISTERED(registered_no, meet_no, user_no) values ('MR'||SEQ_TEST_MEET_R.nextval, 'M1001', 'U1002');
insert into TEST_MEET_REGISTERED(registered_no, meet_no, user_no) values ('MR'||SEQ_TEST_MEET_R.nextval, 'M1001', 'U1003');
insert into TEST_MEET_REGISTERED(registered_no, meet_no, user_no) values ('MR'||SEQ_TEST_MEET_R.nextval, 'M1002', 'U1002');
commit;
rollback;


--------------------------------------------------------------------------------------------------------------------


drop view MEET_JOIN_VIEW;

create or replace view MEET_JOIN_VIEW(
    meet_no,
    meet_image,
    meet_name,
    meet_description,
    meet_county,
    meet_interest_name,
    meet_gender,
    meet_nop,
    meet_age,
    meet_date,
    user_no,
    like_cnt,
    user_cnt
)as(
    select m2.meet_no, meet_image, meet_name, meet_description, meet_county, meet_interest_name, meet_gender, meet_nop, meet_age, meet_date, user_no, nvl(like_cnt, 0) as like_cnt, m3.user_cnt
    from 
        (
            select meet_no, meet_image, meet_name, meet_description, meet_county, meet_interest_name, meet_gender, meet_nop, meet_age, meet_date, user_no, m1.like_cnt
            from TEST_MEET m left outer join(
                select meet_no as meet_no2, count(meet_no) as like_cnt from TEST_MEET_LIKE group by meet_no) m1 
                on m.meet_no = m1.meet_no2) m2 left outer join (select meet_no as meet_no3, count(meet_no) as user_cnt from TEST_MEET_REGISTERED group by meet_no) m3 on m2.meet_no = m3.meet_no3
);

select * from MEET_JOIN_VIEW;

-- 아마 여기부터 실행시키면 될 듯 (09월 30일 오후 10시 기준)
-- VO3을 위한 Meet과 user 조인 view
create or replace view MEET_JOIN_USER_VIEW (
    meet_no,
    meet_image, 
    meet_name, 
    meet_description, 
    meet_county, 
    meet_interest_name, 
    meet_gender, 
    meet_nop, 
    meet_age, 
    meet_date, 
    user_no, 
    user_nickname, 
    like_cnt, 
    user_cnt 
) as (
    SELECT meet_no, meet_image, meet_name, meet_Description, meet_county, meet_interest_name, meet_gender, meet_nop, meet_age, meet_date, m.user_no, u.user_nickname, like_cnt, user_cnt 
    from MEET_JOIN_VIEW m 
    left outer join TEST_USER u 
    on m.user_no = u.user_no 
);

SELECT * from MEET_JOIN_USER_VIEW;

---------- 모임 리스트 -----------
-- 모임에 가입한 유저 리스트 불러오기 --
-------------------------------
SELECT REGISTERED_NO, MEET_NO, mr.USER_NO, USER_NICKNAME
FROM TEST_MEET_REGISTERED mr JOIN TEST_USER u
ON mr.USER_NO = u.USER_NO
WHERE meet_no = 'M1001'
;



SELECT MR.USER_NO, REGISTERED_NO, MEET_NO
FROM TEST_MEET_REGISTERED mr
JOIN TEST_USER u
ON mr.USER_NO = u.USER_NO
ORDER BY USER_NO ASC
;


---------------------------
-- 마이 페이지 나의 모임 리스트 --
---------------------------
create or replace view REGISTERED_VIEW1 (
    REGISTERED_NO,
    MEET_NO,
    USER_NO,
    MEET_IMAGE,
    MEET_NAME,
    MEET_DESCRIPTION,
    MEET_CITY,
    MEET_COUNTY,
    MEET_INTEREST_NAME,
    MEET_GENDER,
    MEET_NOP,
    MEET_AGE,
    MEET_DATE
) as (
    SELECT mr.REGISTERED_NO, mr.MEET_NO, mr.USER_NO, m.MEET_IMAGE, m.MEET_NAME, m.MEET_DESCRIPTION, m.MEET_CITY, m.MEET_COUNTY, m.MEET_INTEREST_NAME, m.MEET_GENDER, m.MEET_NOP, m.MEET_AGE, m.MEET_DATE
    FROM TEST_MEET_REGISTERED mr
    LEFT OUTER JOIN TEST_MEET m
    ON mr.MEET_NO = m.MEET_NO
);

SELECT * FROM REGISTERED_VIEW1;

create or replace view LIKE_VIEW (
    MEET_no,
    like_cnt
) as (
    SELECT MEET_NO, COUNT(ml.MEET_NO)
    FROM TEST_MEET_LIKE ml GROUP BY MEET_NO
);

SELECT * FROM LIKE_VIEW;


create or replace view REG_LIKE_VIEW (
    registered_no, meet_no, user_no, meet_image, meet_name, meet_description, meet_city, meet_county, meet_interest_name, meet_gender, meet_nop, meet_age, meet_date, like_cnt
) as (
    SELECT registered_no, rv1.meet_no, user_no, meet_image, meet_name, meet_description, meet_city, meet_county, meet_interest_name, meet_gender, meet_nop, meet_age, meet_date, lv.like_cnt
    FROM REGISTERED_VIEW1 rv1
    LEFT OUTER JOIN LIKE_VIEW lv
    ON rv1.meet_no = lv.meet_no
);

select * from REG_LIKE_VIEW;


create or replace view USER_CNT_VIEW (
    meet_no, user_cnt
) as (
    select meet_no, count(meet_no)
    from test_meet_registered group by meet_no
);

select * from user_cnt_view;


create or replace view REG_USER_LIKE_VIEW (
    registered_no, meet_no, user_no, meet_image, meet_name, meet_description, meet_city, meet_county, meet_interest_name, meet_gender, meet_nop, meet_age, meet_date, like_cnt, user_cnt
) as (
    SELECT registered_no, lv.meet_no, user_no, meet_image, meet_name, meet_description, meet_city, meet_county, meet_interest_name, meet_gender, meet_nop, meet_age, meet_date, nvl(like_cnt, 0), nvl(cv.user_cnt, 0)
    FROM REG_LIKE_VIEW lv
    LEFT OUTER JOIN USER_CNT_VIEW cv
    ON lv.meet_no = cv.meet_no
);

select * from reg_user_like_view where user_no = 'U1002';

