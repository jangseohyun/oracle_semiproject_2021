CREATE TABLE TBL_AD --관리자계정
( AD_ID 	VARCHAR2(10)
, AD_PW 	VARCHAR2(10)	CONSTRAINT AD_PW_NN NOT NULL
, CONSTRAINT AD_ID_PK PRIMARY KEY(AD_ID)
);

CREATE TABLE TBL_QT --중도탈락
( QT_CD 	VARCHAR2(10)
, REG_CD 	VARCHAR2(10)	CONSTRAINT QT_REG_CD_NN NOT NULL
, QT_DT		DATE		    DEFAULT SYSDATE
, CONSTRAINT QT_CD_PK PRIMARY KEY(QT_CD)
, CONSTRAINT QT_REG_CD_FK FOREIGN KEY(REG_CD)
			  REFERENCES TBL_REG(REG_CD)
);

CREATE TABLE TBL_RAT --배점
( RAT_CD    VARCHAR2(10)
, RAT_AT    NUMBER(3)       CONSTRAINT RAT_AT_NN NOT NULL
, RAT_WT    NUMBER(3)       CONSTRAINT RAT_WT_NN NOT NULL
, RAT_PT    NUMBER(3)       CONSTRAINT RAT_PT_NN NOT NULL
, CONSTRAINT RAT_CD_PK PRIMARY KEY(RAT_CD)
);


--확인용 데이터 입력
INSERT INTO TBL_AD(AD_ID,AD_PW) VALUES('ADMIN', 'ADMIN');


--확인
SELECT *
FROM TBL_AD;

DESC TBL_AD;

SELECT TABLE_NAME, TABLESPACE_NAME
FROM USER_TABLES;

--커밋
COMMIT;


--드랍 후 팀원들과 전체 취합하여 다시 만들 예정
DROP TABLE TBL_AD;
DROP TABLE TBL_RAT;


--------------------------------------------------------------------------------


--○ 중도탈락코드 생성용 시퀀스 생성
CREATE SEQUENCE SEQ_QUIT
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCACHE;


--○ 중도탈락 입력 프로시저 생성
CREATE OR REPLACE PROCEDURE PRC_QUIT_INSERT
(   V_REG_CD    IN TBL_QT.REG_CD%TYPE
,   V_QT_DT     IN TBL_QT.QT_DT%TYPE   DEFAULT SYSDATE
)
IS
    V_QT_CD             VARCHAR2(10);
    V_COUNT             NUMBER;
    DUPLICATE_ERROR     EXCEPTION;
BEGIN
    --수강신청코드 중복 여부 확인
    SELECT COUNT(*) INTO V_COUNT
    FROM TBL_QT
    WHERE REG_CD = V_REG_CD;
    
    --중복이 아닐 경우 데이터 입력
    IF V_COUNT = 0
        THEN
            --중도탈락코드 생성
            V_QT_CD := 'Q' || LPAD(SEQ_QUIT.NEXTVAL,3,'0');
            --TBL_REG 테이블에 데이터 입력
            INSERT INTO TBL_QT(QT_CD,REG_CD) VALUES(V_QT_CD,V_REG_CD);
    --중복일 경우 에러 발생
    ELSE RAISE DUPLICATE_ERROR;
    END IF;
    
    --커밋
    COMMIT;
    
    --예외처리
    EXCEPTION
        WHEN DUPLICATE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20001,'이미 존재하는 데이터입니다.');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;


--○ 실행 예시
EXEC PRC_QUIT_INSERT('RG001',SYSDATE);
EXEC PRC_QUIT_INSERT('RG002',SYSDATE);
/*
QT_CD	REG_CD	QT_DT
Q001	RG001   21/04/15
Q002	RG002   21/04/15
*/

EXEC PRC_QUIT_INSERT('RG001',SYSDATE);
--==> 에러 발생(ORA-20001: 이미 존재하는 데이터입니다.)


--○ 중도탈락 수정 프로시저 생성
CREATE OR REPLACE PROCEDURE PRC_QUIT_UPDATE
(   V_REG_CD    IN TBL_QT.REG_CD%TYPE
,   V_QT_DT     IN TBL_QT.QT_DT%TYPE
)
IS
    NONEXIST_ERROR     EXCEPTION;
BEGIN
    --수강신청코드가 일치할 경우 데이터 수정
    UPDATE TBL_QT
    SET REG_CD = V_REG_CD, QT_DT = V_QT_DT
    WHERE REG_CD = V_REG_CD;
    
    --수강신청코드가 일치하는 행이 없어 수정이 실행되지 않았을 경우 에러 발생
    IF SQL%NOTFOUND
        THEN RAISE NONEXIST_ERROR;
    END IF;
    
    --커밋
    COMMIT;
    
    --예외처리
    EXCEPTION
        WHEN NONEXIST_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002,'입력하신 정보와 일치하는 데이터가 없습니다.');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;


--○ 실행 예시
EXEC PRC_QUIT_UPDATE('RG001','21/04/01');
/*
QT_CD	REG_CD	QT_DT
Q001	RG001   21/04/01
Q002	RG002   21/04/15
*/

EXEC PRC_QUIT_UPDATE('RG003','21/04/01');
--==> 에러 발생(ORA-20002: 입력하신 정보와 일치하는 데이터가 없습니다.)


--○ 중도탈락 삭제 프로시저 생성
CREATE OR REPLACE PROCEDURE PRC_QUIT_DELETE
(   V_QT_CD    IN TBL_QT.QT_CD%TYPE
)
IS
    NONEXIST_ERROR     EXCEPTION;
BEGIN
    --중도탈락코드가 일치할 경우 데이터 삭제
    DELETE
    FROM TBL_QT
    WHERE QT_CD = V_REG_CD;
    
    --중도탈락코드가 일치하는 행이 없어 삭제가 실행되지 않았을 경우 에러 발생
    IF SQL%NOTFOUND
        THEN RAISE NONEXIST_ERROR;
    END IF;
    
    --커밋
    COMMIT;
    
    --예외처리
    EXCEPTION
        WHEN NONEXIST_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002,'입력하신 정보와 일치하는 데이터가 없습니다.');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;


--○ 실행 예시
EXEC PRC_QUIT_DELETE('Q002');
/*
QT_CD	REG_CD	QT_DT
Q001	RG001   21/04/01
*/

EXEC PRC_QUIT_DELETE('Q003');
--==> 에러 발생(ORA-20002: 입력하신 정보와 일치하는 데이터가 없습니다.)


--○ 중도탈락 테이블(전체 데이터) 조회 프로시저 (사용 X)
CREATE OR REPLACE PROCEDURE PRC_QUIT_LOOKUP
IS
    V_QT_CD     TBL_QT.QT_CD%TYPE;
    V_REG_CD    TBL_QT.QT_CD%TYPE;
    V_QT_DT     TBL_QT.QT_CD%TYPE;
    
    CURSOR CUR_QUIT_LOOKUP
    IS
    SELECT QT_CD,REG_CD,QT_DT
    FROM TBL_QT;
BEGIN
    --커서 오픈
    OPEN CUR_QUIT_LOOKUP;
    
    LOOP
        FETCH CUR_QUIT_LOOKUP INTO V_QT_CD,V_REG_CD,V_QT_DT;
        
        EXIT WHEN CUR_QUIT_LOOKUP%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(V_QT_CD || ' ' || V_REG_CD || ' ' || V_QT_DT);
    END LOOP;
    
    --커서 클로즈
    CLOSE CUR_QUIT_LOOKUP;
END;


--○ 실행 예시
EXEC PRC_QUIT_LOOKUP;
/*
QT_CD	REG_CD	QT_DT
Q001	RG001   21/04/01
*/


--○ 중도탈락 여부 조회 프로시저 생성
CREATE OR REPLACE PROCEDURE PRC_QUIT_LOOKUP
(
    V_ST_ID     IN TBL_REG.ST_ID%TYPE
,   V_REG_CD    IN TBL_QT.REG_CD%TYPE
)
IS
    V_COUNT     NUMBER;
BEGIN
    SELECT COUNT(*) INTO V_COUNT
    FROM TBL_QT
    WHERE (SELECT ST_ID FROM TBL_REG WHERE REG_CD = V_REG_CD) = V_ST_ID;
    
    IF V_COUNT = 0
        THEN DBMS_OUTPUT.PUT_LINE('중도탈락 학생입니다.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('등록된 학생입니다.');
    END IF;
END;