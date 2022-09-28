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
                select meet_no as meet_no2, count(meet_no) as like_cnt from TEST_MEET_LIKE group by meet_no) m1 on m.meet_no = m1.meet_no2) m2
   left outer join (select meet_no as meet_no3, count(meet_no) as user_cnt from TEST_MEET_REGISTERED group by meet_no) m3 on m2.meet_no = m3.meet_no3
);

select * from MEET_JOIN_VIEW;
