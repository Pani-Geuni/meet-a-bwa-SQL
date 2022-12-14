-- (MEETBOARD) CREATE TABLE
CREATE TABLE MEETBOARD (
	BOARD_NO VARCHAR2(20) NOT NULL,
	BOARD_TITLE VARCHAR2(40) NOT NULL,
	BOARD_CONTENT VARCHAR2(2000) NOT NULL,
	BOARD_DATE DATE NOT NULL,
	USER_NO VARCHAR2(20) NOT NULL,
	MEET_NO VARCHAR2(20) NOT NULL
);

-- (MEETBOARD) PRIMARY KEY SET
ALTER TABLE MEETBOARD
ADD CONSTRAINT MEETBOARD_PK PRIMARY KEY
(
  BOARD_NO 
)
ENABLE;

-- (MEETBOARD) FOREIGN KEY SET
ALTER TABLE MEETBOARD
ADD CONSTRAINT MEETBOARD_FK1 FOREIGN KEY
(
  MEET_NO 
)
REFERENCES TEST_MEET
(
  MEET_NO 
)
ENABLE;


-- SEQUENCE CREATE
CREATE SEQUENCE SEQ_MEETBOARD INCREMENT BY 1 START WITH 1001;


-----------------------
-- INSERT DUMMY DATA IN MEET BOARD --
-----------------------

INSERT INTO MEETBOARD(BOARD_NO, BOARD_TITLE, BOARD_CONTENT, BOARD_DATE, USER_NO, MEET_NO) VALUES ('B'||SEQ_MEETBOARD.nextval, '테스트', '테스트?', SYSDATE, 'U1001', 'M1002');
INSERT INTO MEETBOARD(BOARD_NO, BOARD_TITLE, BOARD_CONTENT, BOARD_DATE, USER_NO, MEET_NO) VALUES ('B'||SEQ_MEETBOARD.nextval, '테스트', '테스트?', SYSDATE, 'U1002', 'M1001');
INSERT INTO MEETBOARD(BOARD_NO, BOARD_TITLE, BOARD_CONTENT, BOARD_DATE, USER_NO, MEET_NO) VALUES ('B'||SEQ_MEETBOARD.nextval, '테스트', '테스트?', SYSDATE, 'U1003', 'M1001');
COMMIT;


----------------------------------
-- CREATE VIEW : USER MEETBOARD --
----------------------------------

CREATE VIEW MEETBOARD_USER_VIEW (
    USER_NO,
    USER_NAME,
    BOARD_NO,
    BOARD_TITLE,
    BOARD_CONTENT,
    BOARD_DATE,
    MEET_NO
) AS
SELECT U.USER_NO as USER_NO, U.USER_NAME AS USER_NAME, MB.BOARD_NO AS BOARD_NO, MB.BOARD_TITLE AS BOARD_TITLE, MB.BOARD_CONTENT AS BOARD_CONTENT, MB.BOARD_DATE AS BOARD_DATE, MB.MEET_NO AS MEET_NO
FROM TEST_USER U JOIN MEETBOARD MB
ON U.USER_NO = MB.USER_NO;
