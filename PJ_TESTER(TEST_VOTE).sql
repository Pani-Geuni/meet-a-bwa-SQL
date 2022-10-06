-- (TEST_VOTE) CREATE TABLE
CREATE TABLE TEST_VOTE 
(
  VOTE_NO VARCHAR2(50 BYTE) NOT NULL 
, VOTE_TITLE VARCHAR2(60 BYTE) NOT NULL 
, VOTE_DESCRIPTION VARCHAR2(600 BYTE) NOT NULL 
, VOTE_EOD DATE NOT NULL 
, VOTE_STATE CHAR NOT NULL 
, USER_NO VARCHAR2(50 BYTE) NOT NULL 
, MEET_NO VARCHAR2(50 BYTE) 
, ACTIVITY_NO VARCHAR2(50 BYTE) 
, CONSTRAINT TEST_VOTE_PK PRIMARY KEY 
  (
    VOTE_NO 
  )
  ENABLE 
);


-- (TEST_VOTE) PRIMARY KEY SET
ALTER TABLE TEST_VOTE
ADD CONSTRAINT TEST_VOTE_FK1 FOREIGN KEY
(
  USER_NO 
)
REFERENCES TEST_USER
(
  USER_NO 
)
ENABLE;


-- (TEST_VOTE) FOREIGN KEY SET
ALTER TABLE TEST_VOTE
ADD CONSTRAINT TEST_VOTE_FK2 FOREIGN KEY
(
  MEET_NO 
)
REFERENCES TEST_MEET
(
  MEET_NO 
)
ENABLE;

ALTER TABLE TEST_VOTE
ADD CONSTRAINT TEST_VOTE_FK3 FOREIGN KEY
(
  ACTIVITY_NO 
)
REFERENCES TEST_ACTIVITY
(
  ACTIVITY_NO 
)
ENABLE;


-- SEQUENCE CREATE
CREATE SEQUENCE SEQ_TEST_VOTE INCREMENT BY 1 START WITH 1001;


TRUNCATE TABLE TEST_VOTE;

INSERT INTO TEST_VOTE(VOTE_NO, VOTE_TITLE, VOTE_DESCRIPTION, VOTE_EOD, VOTE_STATE, USER_NO, MEET_NO, ACTIVITY_NO)
VALUES ('V'||SEQ_TEST_VOTE.NEXTVAL, '가장 좋아하는 원두는?', '본인이 가장 좋아하는 원두에 투표해주세요!', '2022/09/30 23:59:59', 'N', 'U1002', 'M1001', null);
commit;
ROLLBACK;


--------------------------------------------------------------------------------------------------------------------


-- (TEST_VOTE_CONTENT) CREATE TABLE
CREATE TABLE TEST_VOTE_CONTENT 
(
  CONTENT_NO VARCHAR2(50 BYTE) NOT NULL 
, VOTE_NO VARCHAR2(50 BYTE) NOT NULL 
, VOTE_CONTENT VARCHAR2(200 BYTE) NOT NULL 
, CONSTRAINT TEST_VOTE_CONTENT_PK PRIMARY KEY 
  (
    CONTENT_NO 
  )
  ENABLE 
);

ALTER TABLE TEST_VOTE_CONTENT
ADD CONSTRAINT TEST_VOTE_CONTENT_FK1 FOREIGN KEY
(
  VOTE_NO 
)
REFERENCES TEST_VOTE
(
  VOTE_NO 
)
ENABLE;


-- SEQUENCE CREATE
CREATE SEQUENCE SEQ_TEST_VOTE_CONTENT INCREMENT BY 1 START WITH 1001;

INSERT INTO TEST_VOTE_CONTENT(CONTENT_NO, VOTE_NO, VOTE_CONTENT)
VALUES ('VC'||SEQ_TEST_VOTE_CONTENT.NEXTVAL, 'V1001', '아라비아 원두');
commit;
ROLLBACK;


--------------------------------------------------------------------------------------------------------------------


-- (TEST_VOTE_RESULT) CREATE TABLE
CREATE TABLE TEST_VOTE_RESULT 
(
  VOTE_RESULT_NO VARCHAR2(50 BYTE) NOT NULL 
, VOTE_NO VARCHAR2(50 BYTE) NOT NULL 
, USER_NO VARCHAR2(50 BYTE) NOT NULL 
, CONTENT_NO VARCHAR2(200 BYTE) NOT NULL 
, CONSTRAINT TEST_VOTE_RESULT_PK PRIMARY KEY 
  (
    VOTE_RESULT_NO 
  )
  ENABLE 
);

-- FOREIGN KEY
ALTER TABLE TEST_VOTE_RESULT
ADD CONSTRAINT TEST_VOTE_RESULT_FK1 FOREIGN KEY
(
  VOTE_NO 
)
REFERENCES TEST_VOTE
(
  VOTE_NO 
)
ENABLE;

ALTER TABLE TEST_VOTE_RESULT
ADD CONSTRAINT TEST_VOTE_RESULT_FK2 FOREIGN KEY
(
  USER_NO 
)
REFERENCES TEST_USER
(
  USER_NO 
)
ENABLE;

ALTER TABLE TEST_VOTE_RESULT
ADD CONSTRAINT TEST_VOTE_RESULT_FK3 FOREIGN KEY
(
  CONTENT_NO 
)
REFERENCES TEST_VOTE_CONTENT
(
  CONTENT_NO 
)
ENABLE;


-- SEQUENCE CREATE
CREATE SEQUENCE SEQ_TEST_VOTE_RESULT INCREMENT BY 1 START WITH 1001;

INSERT INTO TEST_VOTE_RESULT(VOTE_RESULT_NO, VOTE_NO, USER_NO, CONTENT_NO)
VALUES ('VR'||SEQ_TEST_VOTE_RESULT.NEXTVAL, 'V1001', 'U1001', 'VC1001');
INSERT INTO TEST_VOTE_RESULT(VOTE_RESULT_NO, VOTE_NO, USER_NO, CONTENT_NO)
VALUES ('VR'||SEQ_TEST_VOTE_RESULT.NEXTVAL, 'V1001', 'U1002', 'VC1001');
INSERT INTO TEST_VOTE_RESULT(VOTE_RESULT_NO, VOTE_NO, USER_NO, CONTENT_NO)
VALUES ('VR'||SEQ_TEST_VOTE_RESULT.NEXTVAL, 'V1001', 'U1003', 'VC1002');
commit;


-------------------------------------------



CREATE OR REPLACE VIEW  VOTE_USER_VIEW AS 
SELECT V.VOTE_NO, VOTE_TITLE, VOTE_DESCRIPTION, VOTE_EOD, VOTE_STATE, V.USER_NO, ACTIVITY_NO, USER_CNT
FROM TEST_VOTE V LEFT OUTER JOIN (SELECT VOTE_NO, COUNT(USER_NO) AS USER_CNT FROM TEST_VOTE_RESULT GROUP BY VOTE_NO) VR
ON V.VOTE_NO=VR.VOTE_NO;
 
