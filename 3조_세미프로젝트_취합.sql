--오라클 세미 프로젝트
--3조 김아별, 선혜연, 장서현, 정주희, 한혜림


--① 테이블 생성----------------------------------------------------------------


--○ 1-1. 관리자계정 테이블 생성
CREATE TABLE TBL_AD 
( AD_ID 	VARCHAR2(10)
, AD_PW 	VARCHAR2(10)	CONSTRAINT AD_PW_NN NOT NULL
, CONSTRAINT AD_ID_PK PRIMARY KEY(AD_ID)
);

--○ 1-2. 교수계정 테이블 생성
CREATE TABLE TBL_PR
( PR_ID     VARCHAR2(50)    
, PR_SSN    CHAR(14)       CONSTRAINT PR_SSN_NN NOT NULL
, PR_FN     VARCHAR2(50)    CONSTRAINT PR_FN_NN NOT NULL
, PR_LN     VARCHAR2(50)    CONSTRAINT PR_LN_NN NOT NULL
, PR_DT     DATE            DEFAULT SYSDATE
, PR_PW     VARCHAR2(10)   CONSTRAINT PR_PW_NN NOT NULL
, CONSTRAINT PR_ID_PK PRIMARY KEY (PR_ID)
);

--○ 1-3. 학생계정 테이블 생성
CREATE TABLE TBL_ST
( ST_ID     VARCHAR2(50)   
, ST_SSN    CHAR(14)       CONSTRAINT ST_SSN_NN NOT NULL
, ST_FN     VARCHAR2(50)    CONSTRAINT ST_FN_NN NOT NULL
, ST_LN     VARCHAR2(50)    CONSTRAINT ST_LN_NN NOT NULL
, ST_DT     DATE           DEFAULT SYSDATE
, ST_PW     VARCHAR2(10)   CONSTRAINT ST_PW_NN NOT NULL
, CONSTRAINT ST_ID_PK PRIMARY KEY(ST_ID) 
);

--○ 1-4. 과정 테이블 생성
CREATE TABLE TBL_CRS
( CRS_CD    VARCHAR2(10)
, CRS_NM    VARCHAR2(100)    CONSTRAINT CRS_NM_NN NOT NULL
, CONSTRAINT CRS_CD_PK PRIMARY KEY(CRS_CD)
, CONSTRAINT CRS_NM_UQ UNIQUE(CRS_NM)
);

--○ 1-5. 과목 테이블 생성
CREATE TABLE TBL_SUB
( SUB_CD VARCHAR2(10)
, SUB_NM VARCHAR2(100) CONSTRAINT SUB_NM_NN NOT NULL
, CONSTRAINT SUB_CD_PK PRIMARY KEY(SUB_CD)
, CONSTRAINT SUB_NM_UQ UNIQUE(SUB_NM)
);

--○ 1-6. 배점 테이블 생성
CREATE TABLE TBL_RAT
( RAT_CD    VARCHAR2(10)
, RAT_AT    NUMBER(3)       CONSTRAINT RAT_AT_NN NOT NULL
, RAT_WT    NUMBER(3)       CONSTRAINT RAT_WT_NN NOT NULL
, RAT_PT    NUMBER(3)       CONSTRAINT RAT_PT_NN NOT NULL
, CONSTRAINT RAT_CD_PK PRIMARY KEY(RAT_CD)
);

--○ 1-7. 교재 테이블 생성
CREATE TABLE TBL_BK
( BK_CD VARCHAR2(10)
, BK_NM VARCHAR2(100) CONSTRAINT BK_NM_NN  NOT NULL
, CONSTRAINT BK_CD_PK PRIMARY KEY(BK_CD)
);


--○ 2. 과정개설 테이블 생성
CREATE TABLE TBL_OC
( OC_CD     VARCHAR2(10)
, CRS_CD    VARCHAR2(10)    CONSTRAINT OC_CRS_CD_NN NOT NULL
, CRS_BD    DATE            CONSTRAINT OC_CRS_BD_NN NOT NULL
, CRS_ED    DATE            CONSTRAINT OC_CRS_ED_NN NOT NULL
, CRS_RM    VARCHAR2(10)    CONSTRAINT OC_CRS_RM_NN NOT NULL
, CONSTRAINT OC_CD_PK PRIMARY KEY (OC_CD)
, CONSTRAINT OC_CRS_CD_FK FOREIGN KEY(CRS_CD)
             REFERENCES TBL_CRS(CRS_CD)
             ON DELETE CASCADE 
, CONSTRAINT OC_CRS_ED_CK CHECK(CRS_ED > CRS_BD)
);


--○ 3-1. 과목개설 테이블 생성
CREATE TABLE TBL_OS
( OS_CD     VARCHAR2(10)
, OC_CD     VARCHAR2(10) CONSTRAINT OS_OC_CD_NN  NOT NULL
, SUB_CD    VARCHAR2(10) CONSTRAINT OS_SUB_CD_NN NOT NULL
, PR_ID     VARCHAR2(10) CONSTRAINT OS_PR_ID_NN NOT NULL
, BK_CD     VARCHAR2(10)
, RAT_CD    VARCHAR2(10) CONSTRAINT OS_RAT_CD_NN NOT NULL
, SUB_BD    DATE         
, SUB_ED    DATE         
, CONSTRAINT OS_CD_PK    PRIMARY KEY(OS_CD) 
, CONSTRAINT OS_OC_CD_FK    FOREIGN KEY(OC_CD)  REFERENCES TBL_OC(OC_CD)    ON DELETE CASCADE 
, CONSTRAINT OS_SUB_CD_FK   FOREIGN KEY(SUB_CD) REFERENCES TBL_SUB(SUB_CD)  ON DELETE CASCADE 
, CONSTRAINT OS_PR_ID_FK    FOREIGN KEY(PR_ID)  REFERENCES TBL_PR(PR_ID)    ON DELETE CASCADE 
, CONSTRAINT OS_BK_CD_FK    FOREIGN KEY(BK_CD)  REFERENCES TBL_BK(BK_CD)    ON DELETE CASCADE 
, CONSTRAINT OS_RAT_CD_FK   FOREIGN KEY(RAT_CD) REFERENCES TBL_RAT(RAT_CD)  ON DELETE CASCADE 
, CONSTRAINT SUB_ED_CK      CHECK(SUB_ED>=SUB_BD)
);

--○ 3-2. 수강신청 테이블 생성
CREATE TABLE TBL_REG
( REG_CD    VARCHAR2(10)
, ST_ID     VARCHAR2(10)    CONSTRAINT REG_ST_ID_NN NOT NULL
, OC_CD     VARCHAR2(10)    CONSTRAINT REG_OC_CD_NN NOT NULL
, REG_DT    DATE    DEFAULT SYSDATE    
, CONSTRAINT REG_CD_PK PRIMARY KEY(REG_CD)
, CONSTRAINT REG_ST_ID_FK  FOREIGN KEY(ST_ID)
             REFERENCES TBL_ST(ST_ID)
             ON DELETE CASCADE 
, CONSTRAINT REG_OC_CD_FK  FOREIGN KEY(OC_CD)
             REFERENCES TBL_OC(OC_CD)
             ON DELETE CASCADE 
);


--○ 4-1. 성적 테이블 생성
CREATE TABLE TBL_SC
( SC_CD     VARCHAR2(10)    
, REG_CD    VARCHAR2(10)    CONSTRAINT SC_REG_CD_NN NOT NULL
, OS_CD     VARCHAR2(10)    CONSTRAINT SC_OS_CD_NN NOT NULL
, SC_AT     NUMBER(3)       CONSTRAINT SC_AT_NN NOT NULL
, SC_WT     NUMBER(3)       CONSTRAINT SC_WT_NN NOT NULL
, SC_PT     NUMBER(3)       CONSTRAINT SC_PT_NN NOT NULL
, CONSTRAINT SC_CD_PK PRIMARY KEY(SC_CD)
, CONSTRAINT SC_REG_CD_FK FOREIGN KEY(REG_CD)
            REFERENCES TBL_REG(REG_CD)
            ON DELETE CASCADE 
, CONSTRAINT SC_OS_CD_FK FOREIGN KEY(OS_CD)
            REFERENCES TBL_OS(OS_CD)
            ON DELETE CASCADE 
);

--○ 4-2. 중도탈락 테이블 생성
CREATE TABLE TBL_QT
( QT_CD 	VARCHAR2(10)
, REG_CD 	VARCHAR2(10)	CONSTRAINT QT_REG_CD_NN NOT NULL
, QT_DT		DATE		    DEFAULT SYSDATE
, CONSTRAINT QT_CD_PK PRIMARY KEY(QT_CD)
, CONSTRAINT QT_REG_CD_FK FOREIGN KEY(REG_CD)
			  REFERENCES TBL_REG(REG_CD)
              ON DELETE CASCADE
);


--------------------------------------------------------------------------------


--○ 확인
SELECT *
FROM TAB;
/*
TBL_AD	TABLE
TBL_BK	TABLE
TBL_CRS	TABLE
TBL_OC	TABLE
TBL_OS	TABLE
TBL_PR	TABLE
TBL_QT	TABLE
TBL_RAT	TABLE
TBL_REG	TABLE
TBL_SC	TABLE
TBL_ST	TABLE
TBL_SUB	TABLE
*/

SELECT *
FROM USER_OBJECTS
ORDER BY 1;

SELECT *
FROM ALL_CONSTRAINTS
WHERE TABLE_NAME LIKE 'TBL_%';
/*
OWNER	CONSTRAINT_NAME	CONSTRAINT_TYPE	TABLE_NAME	SEARCH_CONDITION	R_OWNER	R_CONSTRAINT_NAME
TEST	OC_CRS_CD_FK	R	            TBL_OC		TEST	            CRS_CD_PK
TEST	OS_OC_CD_FK	    R	            TBL_OS		TEST	            OC_CD_PK
TEST	OS_SUB_CD_FK	R	            TBL_OS		TEST	            SUB_CD_PK
TEST	OS_PR_ID_FK	    R	            TBL_OS		TEST	            PR_ID_PK
TEST	OS_BK_CD_FK	    R	            TBL_OS		TEST	            BK_CD_PK
TEST	OS_RAT_CD_FK	R	            TBL_OS		TEST	            RAT_CD_PK
TEST	REG_ST_ID_FK	R	            TBL_REG		TEST	            ST_ID_PK
TEST	REG_OC_CD_FK	R	            TBL_REG		TEST	            OC_CD_PK
TEST	SC_REG_CD_FK	R	            TBL_SC		TEST	            REG_CD_PK
TEST	SC_OS_CD_FK	    R	            TBL_SC		TEST	            OS_CD_PK
TEST	QT_REG_CD_FK	R	            TBL_QT		TEST	            REG_CD_PK
TEST	AD_PW_NN	    C	            TBL_AD	                        "AD_PW" IS NOT NULL		
TEST	AD_ID_PK	    P	            TBL_AD			
TEST	PR_SSN_NN	    C	            TBL_PR	                        "PR_SSN" IS NOT NULL		
TEST	PR_FN_NN	    C	            TBL_PR	                        "PR_FN" IS NOT NULL		
TEST	PR_LN_NN	    C	            TBL_PR	                        "PR_LN" IS NOT NULL		
TEST	PR_PW_NN	    C	            TBL_PR	                        "PR_PW" IS NOT NULL		
TEST	PR_ID_PK	    P	            TBL_PR			
TEST	ST_SSN_NN	    C	            TBL_ST	                        "ST_SSN" IS NOT NULL		
TEST	ST_FN_NN	    C	            TBL_ST	                        "ST_FN" IS NOT NULL		
TEST	ST_LN_NN	    C	            TBL_ST	                        "ST_LN" IS NOT NULL		
TEST	ST_PW_NN	    C	            TBL_ST	                        "ST_PW" IS NOT NULL		
TEST	ST_ID_PK	    P	            TBL_ST			
TEST	CRS_NM_NN	    C	            TBL_CRS	                        "CRS_NM" IS NOT NULL		
TEST	CRS_CD_PK	    P	            TBL_CRS			
TEST	SUB_NM_NN	    C	            TBL_SUB	                        "SUB_NM" IS NOT NULL		
TEST	SUB_CD_PK	    P	            TBL_SUB			
TEST	RAT_AT_NN	    C	            TBL_RAT	                        "RAT_AT" IS NOT NULL		
TEST	RAT_WT_NN	    C	            TBL_RAT	                        "RAT_WT" IS NOT NULL		
TEST	RAT_PT_NN	    C	            TBL_RAT	                        "RAT_PT" IS NOT NULL		
TEST	RAT_CD_PK	    P	            TBL_RAT			
TEST	BK_NM_NN	    C	            TBL_BK	                        "BK_NM" IS NOT NULL		
TEST	BK_CD_PK	    P	            TBL_BK			
TEST	OC_CRS_CD_NN	C	            TBL_OC	                        "CRS_CD" IS NOT NULL		
TEST	OC_CRS_BD_NN	C	            TBL_OC	                        "CRS_BD" IS NOT NULL		
TEST	OC_CRS_ED_NN	C	            TBL_OC	                        "CRS_ED" IS NOT NULL		
TEST	OC_CRS_RM_NN	C	            TBL_OC	                        "CRS_RM" IS NOT NULL		
TEST	OC_CRS_ED_CK	C	            TBL_OC	                        CRS_ED > CRS_BD		
TEST	OC_CD_PK	    P	            TBL_OC			
TEST	OS_OC_CD_NN	    C	            TBL_OS	                        "OC_CD" IS NOT NULL		
TEST	OS_SUB_CD_NN	C	            TBL_OS	                        "SUB_CD" IS NOT NULL		
TEST	OS_PR_ID_NN	    C	            TBL_OS	                        "PR_ID" IS NOT NULL		
TEST	OS_RAT_CD_NN	C	            TBL_OS	                        "RAT_CD" IS NOT NULL		
TEST	SUB_ED_CK	    C	            TBL_OS	                        SUB_ED>=SUB_BD		
TEST	OS_CD_PK	    P	            TBL_OS			
TEST	REG_ST_ID_NN	C	            TBL_REG	                        "ST_ID" IS NOT NULL		
TEST	REG_OC_CD_NN	C	            TBL_REG	                        "OC_CD" IS NOT NULL		
TEST	REG_CD_PK	    P	            TBL_REG			
TEST	SC_REG_CD_NN	C	            TBL_SC	                        "REG_CD" IS NOT NULL		
TEST	SC_OS_CD_NN 	C	            TBL_SC	                        "OS_CD" IS NOT NULL		
TEST	SC_AT_NN	    C	            TBL_SC	                        "SC_AT" IS NOT NULL		
TEST	SC_WT_NN	    C	            TBL_SC	                        "SC_WT" IS NOT NULL		
TEST	SC_PT_NN	    C	            TBL_SC	                        "SC_PT" IS NOT NULL		
TEST	SC_CD_PK	    P	            TBL_SC			
TEST	QT_REG_CD_NN	C	            TBL_QT	                        "REG_CD" IS NOT NULL		
TEST	QT_CD_PK	    P	            TBL_QT			
*/



--② 프로시저 생성---------------------------------------------------------


--○ 로그인 프로시저

--관리자 로그인 프로시저 생성
CREATE OR REPLACE PROCEDURE PRC_LOGIN_AD 
(
    V_USERID IN TBL_AD.AD_ID%TYPE
,   V_USERPWD IN TBL_AD.AD_PW%TYPE
)
IS
    V_COUNT            NUMBER;
BEGIN
    SELECT COUNT(AD_ID) INTO V_COUNT FROM TBL_AD
    WHERE AD_ID=V_USERID AND AD_PW=V_USERPWD;
    
    IF(V_COUNT > 0) THEN
        DBMS_OUTPUT.PUT_LINE(V_USERID||'님 관리자계정으로 로그인 되었습니다.');  
    ELSE
        DBMS_OUTPUT.PUT_LINE('아이디 또는 비밀번호가 잘못되었습니다.');
    END IF;
END;
--==>> Procedure PRC_LOGIN_AD이(가) 컴파일되었습니다.

--교수 로그인 프로시저 생성
CREATE OR REPLACE PROCEDURE PRC_LOGIN_PR 
(
    V_USERID IN TBL_PR.PR_ID%TYPE
,   V_USERPWD IN TBL_PR.PR_PW%TYPE
)
IS
    V_COUNT            NUMBER;
BEGIN
    SELECT COUNT(PR_ID) INTO V_COUNT FROM TBL_PR
    WHERE PR_ID=V_USERID AND PR_PW=V_USERPWD;
 
    IF(V_COUNT > 0) THEN
        DBMS_OUTPUT.PUT_LINE(V_USERID||'님 교수계정으로 로그인 되었습니다.');  
    ELSE
        DBMS_OUTPUT.PUT_LINE('아이디 또는 비밀번호가 잘못되었습니다.');    
    END IF;
  
END;
--==>> Procedure PRC_LOGIN_PR이(가) 컴파일되었습니다.

--학생 로그인 프로시저 생성
CREATE OR REPLACE PROCEDURE PRC_LOGIN_ST 
(
    V_USERID IN TBL_ST.ST_ID%TYPE
,   V_USERPWD IN TBL_ST.ST_PW%TYPE
)
IS
    V_COUNT            NUMBER;
BEGIN
    SELECT COUNT(ST_ID) INTO V_COUNT FROM TBL_ST
    WHERE ST_ID=V_USERID AND ST_PW=V_USERPWD;
 
    IF(V_COUNT > 0) THEN
        DBMS_OUTPUT.PUT_LINE(V_USERID||'님 학생계정으로 로그인 되었습니다.');  
    ELSE
        DBMS_OUTPUT.PUT_LINE('아이디 또는 비밀번호가 잘못되었습니다.');
    END IF;
 
END;
--==>> Procedure PRC_LOGIN_ST이(가) 컴파일되었습니다.

--로그인 프로시저 생성
CREATE OR REPLACE PROCEDURE PRC_LOGIN
(
    V_USER    IN NUMBER    
,   V_USERID  IN TBL_PR.PR_ID%TYPE
,   V_USERPWD IN TBL_PR.PR_PW%TYPE
)
IS
    INPUT_ERROR    EXCEPTION;
    V_COUNT        NUMBER;
BEGIN
    IF(V_USER = 1) -- 관리자 = 1
        THEN PRC_LOGIN_AD(V_USERID, V_USERPWD);
      
    ELSIF(V_USER = 2) -- 교수 = 2
        THEN PRC_LOGIN_PR(V_USERID, V_USERPWD);
  
      
    ELSIF(V_USER = 3) -- 학생 = 3
        THEN PRC_LOGIN_ST(V_USERID, V_USERPWD);  
    ELSIF (V_USER != 1 AND V_USER != 2 AND V_USER != 3)
        THEN RAISE INPUT_ERROR;
    END IF; 
    
    EXCEPTION
    WHEN INPUT_ERROR
        THEN RAISE_APPLICATION_ERROR(-20009, '사용자 유형을 입력해주세요. (1.관리자, 2.교수, 3.학생)');
             ROLLBACK;
    WHEN OTHERS
        THEN ROLLBACK;
 
END;
--==>> Procedure PRC_LOGIN이(가) 컴파일되었습니다.


--------------------------------------------------------------------------------


--○ 교수 입력 프로시저

--시퀀스 생성
CREATE SEQUENCE SEQ_PRCODE
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCACHE;
--==>> Sequence SEQ_PRCODE이(가) 생성되었습니다.

--프로시저 생성
CREATE OR REPLACE PROCEDURE PRC_PR_INSERT
( VPR_SSN    IN TBL_PR.PR_SSN%TYPE
, VPR_FN     IN TBL_PR.PR_FN%TYPE
, VPR_LN     IN TBL_PR.PR_LN%TYPE
, VPR_DT     IN TBL_PR.PR_DT%TYPE    DEFAULT SYSDATE
)
IS
    -- 변수 선언
    VPR_ID  TBL_PR.PR_ID%TYPE;
    VPR_PW  TBL_PR.PR_PW%TYPE;
    
    -- 주민번호 중복 예외 
    PR_SSN_ERROR EXCEPTION;
    VCOUNT  NUMBER;
    
BEGIN
    -- 동일한 주민번호가 있는지 체크
    SELECT COUNT(*) INTO VCOUNT
    FROM TBL_PR
    WHERE PR_SSN = VPR_SSN;
    
    -- 동일한 주민번호가 없으면 INSERT 
    IF (VCOUNT =1)
        THEN 
            RAISE PR_SSN_ERROR;
    ELSE 
        -- VPR_PW 연산 (교수 비밀번호)
        VPR_PW := SUBSTR(VPR_SSN,8);
        
        -- VPR_ID 연산 (교수ID)
        VPR_ID := 'PR' || LPAD(SEQ_PRCODE.NEXTVAL,3,'0');      

        -- 교수 정보 INSERT 쿼리문
        INSERT INTO TBL_PR(PR_ID, PR_SSN, PR_FN, PR_LN, PR_PW, PR_DT)
        VALUES(VPR_ID, VPR_SSN, VPR_FN, VPR_LN, VPR_PW, VPR_DT);
        
    END IF;
    
    --커밋
    COMMIT;
    
    --예외처리
    EXCEPTION
        WHEN PR_SSN_ERROR
            THEN RAISE_APPLICATION_ERROR(-20001,'이미 존재하는 데이터입니다.');
            ROLLBACK;
        WHEN OTHERS THEN ROLLBACK;
END;
--==>> Procedure PRC_PR_INSERT이(가) 컴파일되었습니다.


--○ 교수 수정 프로시저

CREATE OR REPLACE PROCEDURE PRC_PR_UPDATE
( VPR_ID    IN TBL_PR.PR_ID%TYPE
, VPR_SSN   IN TBL_PR.PR_SSN%TYPE
, VPR_FN    IN TBL_PR.PR_FN%TYPE
, VPR_LN    IN TBL_PR.PR_LN%TYPE
, VPR_DT    IN TBL_PR.PR_DT%TYPE
)
IS
    VCOUNT NUMBER;
    PR_DATE_ERROR   EXCEPTION;  -- DT가 오늘보다 미래이면 예외처리
BEGIN
    --동일한 주민번호가 아니면 UPDATE
    IF ( TO_NUMBER(SYSDATE - VPR_DT)<0 )
        THEN RAISE PR_DATE_ERROR;
    
    ELSE    
    -- 교수 테이블 수정
    UPDATE TBL_PR
    SET PR_SSN = VPR_SSN
      , PR_FN = VPR_FN
      , PR_LN = VPR_LN
      , PR_DT = VPR_DT
    WHERE PR_ID = VPR_ID;

    END IF;
    
    --커밋
    COMMIT;
    
    -- 예외처리
    EXCEPTION
        WHEN PR_DATE_ERROR 
            THEN RAISE_APPLICATION_ERROR(-20005, '유효하지 않은 날짜입니다.');
            ROLLBACK; 
        WHEN OTHERS THEN ROLLBACK;
END;


--○ 교수 삭제 프로시저

CREATE OR REPLACE PROCEDURE PRC_PR_DELETE
( VPR_ID    IN TBL_PR.PR_ID%TYPE
)
IS
    NONEXIST_ERROR  EXCEPTION;
    ING_ERROR       EXCEPTION;
    VCOUNT          NUMBER;
    VCOUNT2         NUMBER;
    
BEGIN
    -- 동일한 교수ID가 있는지 체크
    SELECT COUNT(*) INTO VCOUNT
    FROM TBL_PR
    WHERE PR_ID = VPR_ID;
    
    -- 개설과목이 있는 교수인지 체크
    SELECT COUNT(*) INTO VCOUNT2
    FROM TBL_OS
    WHERE PR_ID = VPR_ID;

    -- 교수코드가 일치하지 않을 경우 실행되는 에러
    IF VCOUNT = 0
        THEN RAISE NONEXIST_ERROR;
    ELSIF VCOUNT2 >=1
        THEN RAISE ING_ERROR;
        
    ELSE 
        -- 교수 정보 삭제
        DELETE
        FROM TBL_PR
        WHERE PR_ID = VPR_ID;
    
    END IF;
    
    --커밋
    COMMIT;
    
        --예외처리
    EXCEPTION
        WHEN NONEXIST_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002,'존재하지 않는 데이터입니다.');
                ROLLBACK;
        WHEN ING_ERROR
            THEN RAISE_APPLICATION_ERROR(-20010, '강의 중인 교수입니다. 과목의 교수자를 먼저 변경해주세요.');
            ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;

END;
--==>> Procedure PRC_PR_DELETE이(가) 컴파일되었습니다.


--○ 교수 조회 프로시저 1 (1교수 전체과목)

--뷰 생성
CREATE OR REPLACE VIEW VIEW_PR
AS
SELECT T.*
FROM
(
    SELECT ROWNUM "NUM_PR", PR_ID "PR_ID", PR_SSN "PR_SSN", PR_FN "PR_FN", PR_LN "PR_LN", PR_DT "PR_DT", PR_PW "PR_PW"
    FROM TBL_PR
)T;

CREATE OR REPLACE VIEW VIEW_OS
AS
SELECT T.*
FROM
(   SELECT ROWNUM "NUM_OS", OS_CD "OS_CD", OC_CD "OC_CD", SUB_CD "SUB_CD", PR_ID "PR_ID"
         , BK_CD "BK_CD", RAT_CD "RAT_CD", SUB_BD "SUB_BD", SUB_ED "SUB_ED"
    FROM TBL_OS
    ORDER BY 3
)T;

--프로시저 생성
CREATE OR REPLACE PROCEDURE PRC_PR_LOOKUP
(
    V_PR_ID      IN TBL_PR.PR_ID%TYPE   -- 교수아이디
)
IS
    V_SUB_NM     TBL_SUB.SUB_NM%TYPE; -- 배정된 과목명
    V_SUB_BD     TBL_OS.SUB_BD%TYPE;  -- 과목 시작일
    V_SUB_ED     TBL_OS.SUB_ED%TYPE;  -- 과목 종료일
    V_BK_CD      TBL_BK.BK_CD%TYPE;   -- 교재코드
    V_BK_NM      TBL_BK.BK_NM%TYPE;   -- 교재명
    V_OC_CD      TBL_OC.OC_CD%TYPE;   -- 강의실코드
    V_CRS_RM     TBL_OC.CRS_RM%TYPE;  -- 강의실
    
    V_OS_CD      TBL_OS.OS_CD%TYPE;
    V_SUB_CD     TBL_SUB.SUB_CD%TYPE;
    
    V_ING        VARCHAR(50);         -- 강의 진행 여부
    V_DATE1      NUMBER;              -- 날짜 연산 변수
    V_DATE2      NUMBER;
    
    V_NUM        NUMBER;
    V_ROWNUM     NUMBER;
    
BEGIN
    SELECT MIN(ROWNUM),MAX(ROWNUM) INTO V_NUM,V_ROWNUM
    FROM TBL_OS
    WHERE PR_ID = V_PR_ID;

    LOOP    
        SELECT OS_CD,SUB_BD,SUB_ED,BK_CD,OC_CD INTO V_OS_CD,V_SUB_BD,V_SUB_ED,V_BK_CD,V_OC_CD
        FROM VIEW_OS
        WHERE PR_ID = V_PR_ID AND NUM_OS = V_NUM;
        
        SELECT SUB_NM INTO V_SUB_NM
        FROM TBL_SUB
        WHERE SUB_CD = (SELECT SUB_CD FROM TBL_OS WHERE OS_CD = V_OS_CD);
        
        SELECT BK_NM INTO V_BK_NM
        FROM TBL_BK
        WHERE BK_CD = V_BK_CD;

        SELECT CRS_RM INTO V_CRS_RM
        FROM TBL_OC
        WHERE OC_CD = V_OC_CD;
        
        V_DATE1 := TO_NUMBER(SYSDATE - V_SUB_BD);
        V_DATE2 := TO_NUMBER(SYSDATE - V_SUB_ED);
        
        IF (V_DATE1 > 0 AND V_DATE2 < 0) 
            THEN V_ING := '강의 중';
        ELSIF (V_DATE1 < 0 AND V_DATE2 < 0) 
            THEN V_ING := '강의 예정';
        ELSIF (V_DATE1 > 0 AND V_DATE2 > 0)
            THEN V_ING := '강의 종료';
        ELSE V_ING := '확인불가';
        END IF;
        
        -- 교수 정보 출력        
        DBMS_OUTPUT.PUT_LINE(V_NUM || '.');
        DBMS_OUTPUT.PUT_LINE('교수ID : ' || V_PR_ID);
        DBMS_OUTPUT.PUT_LINE('배정된 과목명 : ' || V_SUB_NM  );
        DBMS_OUTPUT.PUT_LINE('과목 기간 : ' || V_SUB_BD || '~' || V_SUB_ED );
        DBMS_OUTPUT.PUT_LINE('교재명 : ' || V_BK_NM );
        DBMS_OUTPUT.PUT_LINE('강의실 : ' || V_CRS_RM );
        DBMS_OUTPUT.PUT_LINE('강의 진행 여부 : ' || V_ING );
        
        V_NUM := V_NUM+1;
        
        EXIT WHEN V_NUM > V_ROWNUM;
    END LOOP;
END;


--○ 교수 조회 프로시저 2 (전체교수 전체과목)

CREATE OR REPLACE PROCEDURE PRC_PR_LOOKUP_ADMIN
IS
    V_PR_ID      TBL_PR.PR_ID%TYPE;
    V_NUM        NUMBER := 1;
    V_ROWNUM     NUMBER; 
BEGIN
    SELECT MAX(ROWNUM) INTO V_ROWNUM
    FROM TBL_PR;
    
    LOOP
        SELECT PR_ID INTO V_PR_ID
        FROM VIEW_OS
        WHERE NUM_OS = V_NUM;
        
        PRC_PR_LOOKUP(V_PR_ID);
        V_NUM := V_NUM + 1;
        
        EXIT WHEN V_NUM > V_ROWNUM;
    END LOOP;
END;


--------------------------------------------------------------------------------


--○ 학생 입력 프로시저

--시퀀스 생성 
CREATE SEQUENCE SEQ_ST_CODE
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCACHE;

--프로시저 생성
CREATE OR REPLACE PROCEDURE PRC_ST_INSERT
(
  V_ST_SSN  IN TBL_ST.ST_SSN%TYPE
, V_ST_FN   IN TBL_ST.ST_FN%TYPE
, V_ST_LN   IN TBL_ST.ST_LN%TYPE
, V_ST_DT   IN TBL_ST.ST_DT%TYPE    DEFAULT SYSDATE
)
IS
    V_ST_PW         VARCHAR2(10);
    V_ST_ID         VARCHAR2(10);
    V_COUNT         NUMBER;
    DUPLICATE_ERROR EXCEPTION;
BEGIN
    SELECT COUNT(*) INTO V_COUNT
    FROM TBL_ST
    WHERE ST_SSN = V_ST_SSN;
    
    IF V_COUNT = 0
        THEN
        -- 학생 아이디 생성 
        V_ST_ID := 'ST' || LPAD(SEQ_ST_CODE.NEXTVAL,3,'0');     
        V_ST_PW := SUBSTR(V_ST_SSN,8);   
         -- 테이블에 데이터 입력 
        INSERT INTO TBL_ST(ST_ID, ST_SSN, ST_FN, ST_LN, ST_PW)
        VALUES (V_ST_ID, V_ST_SSN, V_ST_FN, V_ST_LN, V_ST_PW);
        
    ELSE RAISE DUPLICATE_ERROR;
    END IF;
    
    COMMIT;
    
    EXCEPTION
        WHEN DUPLICATE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20001,'이미 존재하는 데이터입니다.');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;


--○ 학생 수정 프로시저

CREATE OR REPLACE PROCEDURE PRC_ST_UPDATE
(
  V_ST_ID   IN TBL_ST.ST_ID%TYPE
, V_ST_SSN  IN TBL_ST.ST_SSN%TYPE
, V_ST_FN   IN TBL_ST.ST_FN%TYPE
, V_ST_LN   IN TBL_ST.ST_LN%TYPE
, V_ST_DT   IN TBL_ST.ST_DT%TYPE    DEFAULT SYSDATE
)
IS
    NONEXIST_ERROR  EXCEPTION;
BEGIN
    UPDATE TBL_ST
    SET ST_FN = V_ST_FN, ST_LN = V_ST_LN, ST_DT = V_ST_DT
    WHERE ST_ID = V_ST_ID;
    
    IF SQL%NOTFOUND
        THEN RAISE NONEXIST_ERROR;
    END IF;
       
    COMMIT;
    
    EXCEPTION
        WHEN NONEXIST_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002,'입력하신 정보와 일치하는 데이터가 없습니다.');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;


--○ 학생 삭제 프로시저

CREATE OR REPLACE PROCEDURE PRC_ST_DELETE
(
  V_ST_ID   IN TBL_ST.ST_ID%TYPE
)
IS
    V_REG_CD        TBL_REG.REG_CD%TYPE;
    
    NONEXIST_ERROR  EXCEPTION;
BEGIN
   
    -- 학생 삭제 
    DELETE
    FROM TBL_ST
    WHERE ST_ID = V_ST_ID;
    
    IF SQL%NOTFOUND
        THEN RAISE NONEXIST_ERROR;
    END IF;
       
    COMMIT;
    
    EXCEPTION
        WHEN NONEXIST_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002,'존재하지 않는 데이터입니다.');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;


--------------------------------------------------------------------------------


--○ 과정 입력 프로시저 생성

--시퀀스 생성
CREATE SEQUENCE SEQ_CRS
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCACHE;

--프로시저 생성
CREATE OR REPLACE PROCEDURE PRC_CRS_INSERT 
(
    V_CRS_NM    IN  TBL_CRS.CRS_NM%TYPE
)
IS
    V_CRS_CD    TBL_CRS.CRS_CD%TYPE;
    V_DUP_CHAR  CHAR(1);
    V_DUP_NUM   VARCHAR2(3);
    V_CD_ASCII  NUMBER;
    V_COUNT     NUMBER;
    CREATE_CODE_ERROR EXCEPTION;
    DUPLICATE_ERROR   EXCEPTION;
BEGIN
    --과정명 중복 여부 확인
    SELECT COUNT(*) INTO V_COUNT
    FROM TBL_CRS
    WHERE CRS_NM = V_CRS_NM;
    
    --중복시 에러 발생
    IF V_COUNT >= 1
        THEN RAISE DUPLICATE_ERROR;
    END IF;
    
    --첫 두 글자가 알파벳 대문자 두 글자인지 확인
    V_CD_ASCII := TO_NUMBER(ASCII(SUBSTR(V_CRS_NM,1,1))) + TO_NUMBER(ASCII(SUBSTR(V_CRS_NM,2,1)));
    
    IF (V_CD_ASCII >= 130 AND V_CD_ASCII <= 180)
        THEN
            V_CRS_CD := SUBSTR(V_CRS_NM,1,2) || LPAD(SEQ_CRS.NEXTVAL,3,'0');
            INSERT INTO TBL_CRS(CRS_CD, CRS_NM) VALUES (V_CRS_CD, V_CRS_NM);
    ELSE
        RAISE CREATE_CODE_ERROR;
    END IF;
    
    -- 커밋
    COMMIT;
    
    EXCEPTION
        WHEN DUPLICATE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20001, '이미 존재하는 데이터입니다.');
                 ROLLBACK;
        WHEN CREATE_CODE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20007,'유효하지 않은 과정명입니다.');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;


--○ 과정 수정 프로시저

CREATE OR REPLACE PROCEDURE PRC_CRS_UPDATE
( V_CRS_CD    IN  TBL_CRS.CRS_CD%TYPE
, V_CRS_NM    IN  TBL_CRS.CRS_NM%TYPE
)
IS
    V_COUNT     NUMBER;
    O_CRS_NM    TBL_CRS.CRS_CD%TYPE;
    
    CREATE_CODE_ERROR EXCEPTION;
    NONEXIST_ERROR   EXCEPTION;
BEGIN
    --과정명 코드가 존재하는지 확인
    SELECT COUNT(*) INTO V_COUNT
    FROM TBL_CRS
    WHERE CRS_CD = V_CRS_CD;
    
    -- 코드가 존재하지 않으면 에러발생
    IF (V_COUNT = 0)
        THEN RAISE NONEXIST_ERROR;
        
    END IF;
    
    -- 과정명의 앞 두글자 추출
    SELECT CRS_NM INTO O_CRS_NM
    FROM TBL_CRS
    WHERE CRS_CD = V_CRS_CD;
    
    IF ( SUBSTR(V_CRS_NM,1,2) = SUBSTR(O_CRS_NM,1,2) )
         THEN
            UPDATE TBL_CRS
            SET CRS_NM = V_CRS_NM
            WHERE CRS_CD = V_CRS_CD;
     ELSE
        RAISE CREATE_CODE_ERROR;
        
     END IF;
    
    -- 커밋
    COMMIT;
    
    EXCEPTION
        WHEN NONEXIST_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002, '존재하지 않는 데이터입니다.');
                 ROLLBACK;
        WHEN CREATE_CODE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20007,'유효하지 않은 과정명입니다.');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;


--○ 과정 삭제 프로시저

CREATE OR REPLACE PROCEDURE PRC_CRS_DELETE
(   V_CRS_CD  IN TBL_CRS.CRS_CD%TYPE
)
IS
    NONEXIST_ERROR  EXCEPTION;
BEGIN
    -- 과정코드가 일치할 경우 데이터 삭제
    DELETE
    FROM TBL_CRS
    WHERE CRS_CD = V_CRS_CD;
    
    -- 과정코드가 일치하지 않을 경우 실행되는 에러
    IF SQL%NOTFOUND
        THEN RAISE NONEXIST_ERROR;
    END IF;
    
    -- 커밋
    COMMIT;
    
    --예외처리
    EXCEPTION
        WHEN NONEXIST_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002,'존재하지 않는 데이터입니다.');
                ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;


--------------------------------------------------------------------------------


--○ 과목 입력 프로시저

--시퀀스 생성
CREATE SEQUENCE SEQ_SUB_CODE
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCACHE;

--프로시저 생성
CREATE OR REPLACE PROCEDURE PRC_SUB_INSERT
(
   V_SUB_NM    IN  TBL_SUB.SUB_NM%TYPE  
)
IS
    V_SUB_CD                    TBL_SUB.SUB_CD%TYPE;
    V_COUNT                     NUMBER;
    ALREADY_REGISTERED_ERROR    EXCEPTION;
    V_CD_ASCII                  NUMBER;
    CREATE_CODE_ERROR           EXCEPTION;
BEGIN

    --동일한 과목코드이 있는지 체크
    SELECT COUNT(*) INTO V_COUNT
    FROM TBL_SUB
    WHERE SUB_CD = V_SUB_CD;
      
    --첫 두 글자가 알파벳 대문자 한 글자인지 확인
    V_CD_ASCII := TO_NUMBER(ASCII(SUBSTR(V_SUB_NM,1,1)));
    
    IF (V_CD_ASCII >= 65 AND V_CD_ASCII <= 90) AND (V_COUNT = 0)
        THEN
            V_SUB_CD := SUBSTR(V_SUB_NM,1,1) || LPAD(SEQ_SUB_CODE.NEXTVAL,3,'0');
            INSERT INTO TBL_SUB(SUB_CD, SUB_NM) VALUES(V_SUB_CD, V_SUB_NM);
    ELSIF (V_CD_ASCII < 65 OR V_CD_ASCII > 90)
        THEN RAISE CREATE_CODE_ERROR;
    ELSIF (V_COUNT > 0)
        THEN RAISE ALREADY_REGISTERED_ERROR;
    END IF;
    
    COMMIT;
     
    EXCEPTION
        WHEN ALREADY_REGISTERED_ERROR
             THEN RAISE_APPLICATION_ERROR(-20001, '이미 존재하는 데이터입니다.');
             ROLLBACK;
        WHEN CREATE_CODE_ERROR
             THEN RAISE_APPLICATION_ERROR(-20004, '과목명은 영어 대문자로 입력하세요.');
        WHEN OTHERS
             THEN ROLLBACK;
END;


--○ 과목 수정 프로시저

CREATE OR REPLACE PROCEDURE PRC_SUB_UPDATE
(
    V_SUB_CD    IN  TBL_SUB.SUB_CD%TYPE
,   V_SUB_NM    IN  TBL_SUB.SUB_NM%TYPE 
)
IS
    V_COUNT             NUMBER;
    NOT_FOUND_ERROR    EXCEPTION;
BEGIN
    --동일한 과목코드이 있는지 체크
    SELECT COUNT(*) INTO V_COUNT
    FROM TBL_SUB
    WHERE SUB_CD = V_SUB_CD;
    
    --동일한 과목코드가 있으면 UPDATE
    IF V_COUNT = 1
    THEN
        UPDATE TBL_SUB
        SET    SUB_NM = V_SUB_NM
        WHERE  SUB_CD = V_SUB_CD;
        
        COMMIT;
    ELSE
        RAISE NOT_FOUND_ERROR;
    END IF;
    
    EXCEPTION
    WHEN NOT_FOUND_ERROR
        THEN RAISE_APPLICATION_ERROR(-20002, '입력하신 정보와 일치하는 데이터가 없습니다.');
             ROLLBACK;
    WHEN OTHERS
        THEN ROLLBACK;
END;


--○ 과목 삭제 프로시저 

CREATE OR REPLACE PROCEDURE PRC_SUB_DELETE
(
    V_SUB_CD    IN  TBL_SUB.SUB_CD%TYPE
)
IS
    NONEXIST_ERROR     EXCEPTION;
BEGIN

    DELETE
    FROM TBL_SUB
    WHERE SUB_CD = V_SUB_CD;
    
    IF SQL%NOTFOUND
    THEN RAISE NONEXIST_ERROR;
    END IF;
        
    COMMIT;

    EXCEPTION
        WHEN NONEXIST_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002,'입력하신 정보와 일치하는 데이터가 없습니다.');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;

END;


--○ 과목명 조회 프로시저

--뷰 생성
CREATE OR REPLACE VIEW VIEW_SUB
AS
SELECT T.*
FROM
(
    SELECT ROWNUM "NUM_SUB", SUB_CD "SUB_CD", SUB_NM "SUB_NM"
    FROM TBL_SUB
)T;

--프로시저 생성
CREATE OR REPLACE PROCEDURE PRC_SUB_LOOKUP
IS
    V_SUB_CD     TBL_SUB.SUB_CD%TYPE;
    V_SUB_NM    TBL_SUB.SUB_NM%TYPE;
    V_NUM       NUMBER := 1;
    V_ROWNUM    NUMBER;
BEGIN
    SELECT MAX(ROWNUM) INTO V_ROWNUM
    FROM TBL_SUB;

    LOOP
        SELECT SUB_CD, SUB_NM INTO V_SUB_CD, V_SUB_NM
        FROM VIEW_SUB
        WHERE NUM_SUB = V_NUM;
        DBMS_OUTPUT.PUT_LINE(V_SUB_CD || ' ' || V_SUB_NM);
                
        V_NUM := V_NUM + 1;
                                      
        EXIT WHEN V_NUM > V_ROWNUM;
    END LOOP;
END;


--------------------------------------------------------------------------------


--○ 배점 입력 프로시저

-- 시퀀스 생성
CREATE SEQUENCE SEQ_RAT
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCACHE;

--프로시저 생성
CREATE OR REPLACE PROCEDURE PRC_RAT_INSERT
( V_RAT_AT      TBL_RAT.RAT_AT%TYPE
, V_RAT_WT      TBL_RAT.RAT_WT%TYPE
, V_RAT_PT      TBL_RAT.RAT_PT%TYPE
)
IS
    V_RAT_CD    TBL_RAT.RAT_CD%TYPE;
    PROPORTION_ERROR    EXCEPTION;
BEGIN
    -- 배점코드 생성
    V_RAT_CD := 'RT' || LPAD(SEQ_RAT.NEXTVAL,3,'0');
    
    -- 전체 비율이 100이 넘지 않을 경우 INSERT
    IF ( (V_RAT_AT + V_RAT_WT + V_RAT_PT) = 100 )
         THEN INSERT INTO TBL_RAT (RAT_CD, RAT_AT, RAT_WT, RAT_PT) 
              VALUES (V_RAT_CD,V_RAT_AT, V_RAT_WT, V_RAT_PT);
    -- 나머지 경우는 에러 발생
    ELSE RAISE PROPORTION_ERROR;
    END IF;
    
    -- 커밋
    COMMIT;
    
    -- 에러 처리
    EXCEPTION
        WHEN PROPORTION_ERROR
            THEN RAISE_APPLICATION_ERROR(-20006, '총 배점은 100점 만점 기준입니다.');
                ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;


--○ 배점 수정 프로시저

CREATE OR REPLACE PROCEDURE PRC_RAT_UPDATE
( V_RAT_CD    TBL_RAT.RAT_CD%TYPE
, V_RAT_AT      TBL_RAT.RAT_AT%TYPE
, V_RAT_WT      TBL_RAT.RAT_WT%TYPE
, V_RAT_PT      TBL_RAT.RAT_PT%TYPE
)
IS
    V_COUNT_CD          NUMBER;
    PROPORTION_ERROR    EXCEPTION;
    NONEXIST_ERROR      EXCEPTION;
BEGIN
    SELECT COUNT(*) INTO V_COUNT_CD
    FROM TBL_RAT
    WHERE RAT_CD = V_RAT_CD;
    
    IF ( (V_RAT_AT + V_RAT_WT + V_RAT_PT) = 100 ) AND (V_COUNT_CD = 1)
        THEN
        -- 코드가 일치하면서 총 배점이 100이라면 업데이트
        UPDATE TBL_RAT
        SET RAT_AT = V_RAT_AT, RAT_WT = V_RAT_WT, RAT_PT = V_RAT_PT
        WHERE RAT_CD = V_RAT_CD;
    -- 총 배점이 100점이상이거나 이하이면 에러발생
    ELSIF ( ((V_RAT_AT + V_RAT_WT + V_RAT_PT) < 100) OR ((V_RAT_AT + V_RAT_WT + V_RAT_PT) > 100))
         THEN RAISE PROPORTION_ERROR;
    ELSIF (V_COUNT_CD = 0)
        THEN RAISE NONEXIST_ERROR;
    END IF;

    --커밋
    COMMIT;
    
    -- 에러 처리
    EXCEPTION
        WHEN PROPORTION_ERROR
            THEN RAISE_APPLICATION_ERROR(-20006, '총 배점은 100점 만점 기준입니다.');
                ROLLBACK;
        WHEN NONEXIST_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002, '존재하지 않는 데이터입니다.');
        WHEN OTHERS
            THEN ROLLBACK;
END;


--○ 배점 삭제 프로시저

CREATE OR REPLACE PROCEDURE PRC_RAT_DELETE
(  V_RAT_CD    TBL_RAT.RAT_CD%TYPE
)
IS
     NONEXIST_ERROR      EXCEPTION;
BEGIN
    DELETE
    FROM TBL_RAT
    WHERE RAT_CD = V_RAT_CD;
    
    IF SQL%NOTFOUND
        THEN RAISE NONEXIST_ERROR;
    END IF;
    
    -- 커밋
    COMMIT;
    
    -- 에러 처리
    EXCEPTION
        WHEN NONEXIST_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002,'존재하지 않는 데이터입니다.');
                ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;


--------------------------------------------------------------------------------


--○ 교재 입력 프로시저

--시퀀스 생성
CREATE SEQUENCE SEQ_BK_CODE
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCACHE;

--프로시저 생성
CREATE OR REPLACE PROCEDURE PRC_BK_INSERT
(
   V_BK_NM    IN  TBL_BK.BK_NM%TYPE  
)
IS
    V_BK_CD                     TBL_BK.BK_CD%TYPE;
    V_COUNT                     NUMBER;
    ALREADY_REGISTERED_ERROR    EXCEPTION;

BEGIN
    V_BK_CD := 'B' || LPAD(SEQ_BK_CODE.NEXTVAL,3,'0');
    
    SELECT COUNT(*) INTO V_COUNT
    FROM TBL_BK
    WHERE BK_CD = V_BK_CD;
    
    IF (V_COUNT > 0)
        THEN RAISE ALREADY_REGISTERED_ERROR;
    ELSE
        INSERT INTO TBL_BK(BK_CD, BK_NM) VALUES(V_BK_CD, V_BK_NM);
    END IF; 
    
    COMMIT;
     
    EXCEPTION
        WHEN ALREADY_REGISTERED_ERROR
             THEN RAISE_APPLICATION_ERROR(-20001, '이미 존재하는 데이터입니다.');
             ROLLBACK;
        WHEN OTHERS
             THEN ROLLBACK;
END;


--○ 교재 수정 프로시저

CREATE OR REPLACE PROCEDURE PRC_BK_UPDATE
(
    V_BK_CD    IN  TBL_BK.BK_CD%TYPE
,   V_BK_NM    IN  TBL_BK.BK_NM%TYPE 
)
IS
    V_COUNT             NUMBER;
    NOT_FOUND_ERROR    EXCEPTION;
BEGIN

    SELECT COUNT(*) INTO V_COUNT
    FROM TBL_BK
    WHERE BK_CD = V_BK_CD;

    IF V_COUNT = 1
    THEN
        UPDATE TBL_BK
        SET    BK_NM = V_BK_NM
        WHERE  BK_CD = V_BK_CD;
        
        COMMIT;
        
        DBMS_OUTPUT.PUT_LINE('"' || V_BK_NM || '"으로 수정되었습니다.');
        
    ELSE
        RAISE NOT_FOUND_ERROR;
    END IF;
    
    EXCEPTION
    WHEN NOT_FOUND_ERROR
        THEN RAISE_APPLICATION_ERROR(-20002, '입력하신 정보와 일치하는 데이터가 없습니다.');
             ROLLBACK;
    WHEN OTHERS
        THEN ROLLBACK;
    
END;


--○ 교재 삭제 프로시저

CREATE OR REPLACE PROCEDURE PRC_BK_DELETE
(
    V_BK_CD    IN  TBL_BK.BK_CD%TYPE
)
IS
    NONEXIST_ERROR     EXCEPTION;
BEGIN

    -- 교재테이블에서 삭제
    DELETE
    FROM TBL_BK
    WHERE BK_CD = V_BK_CD;
    
    IF SQL%NOTFOUND
    THEN RAISE NONEXIST_ERROR;
    END IF;
        
    COMMIT;
    
    EXCEPTION
    WHEN NONEXIST_ERROR
        THEN RAISE_APPLICATION_ERROR(-20002,'입력하신 정보와 일치하는 데이터가 없습니다.');
             ROLLBACK;
    WHEN OTHERS
        THEN ROLLBACK;       
END;


--------------------------------------------------------------------------------


--○ 과정개설 입력 프로시저

-- 시퀀스 생성
CREATE SEQUENCE SEQ_OC
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCACHE;

--프로시저 생성
CREATE OR REPLACE PROCEDURE PRC_OC_INSERT
( VCRS_CD   IN TBL_OC.CRS_CD%TYPE
, VCRS_BD   IN TBL_OC.CRS_BD%TYPE
, VCRS_ED   IN TBL_OC.CRS_ED%TYPE
, VCRS_RM   IN TBL_OC.CRS_RM%TYPE
)
IS
    -- 주요 변수 선언
    VOC_CD  TBL_OC.OC_CD%TYPE;      
    VCRS_NM TBL_CRS.CRS_NM%TYPE;    
    
    -- 예외 변수 선언 (날짜)
    OC_DATE_ERROR   EXCEPTION;   
BEGIN
    -- 예외 발생
    IF (TO_NUMBER(VCRS_ED - VCRS_BD) < 0)
        THEN RAISE OC_DATE_ERROR;
    END IF;
    
    -- 과정명 찾기 VCRS_NM
    SELECT CRS_NM INTO VCRS_NM
    FROM TBL_CRS
    WHERE CRS_CD = VCRS_CD;
    
    -- VOC_CD 개설과정 코드
    VOC_CD := TO_CHAR('A' || '_' || SUBSTR(VCRS_NM,1,2) || LPAD(SEQ_OC.NEXTVAL,3,'0'));
    
    INSERT INTO TBL_OC(OC_CD, CRS_CD, CRS_BD, CRS_ED, CRS_RM)
    VALUES(VOC_CD ,VCRS_CD, VCRS_BD, VCRS_ED, VCRS_RM);
 
    COMMIT;
    
    EXCEPTION
        WHEN OC_DATE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20005, '유효하지 않은 날짜입니다');
                 ROLLBACK;
        WHEN OTHERS THEN ROLLBACK;
END;


--○ 과정개설 수정 프로시저

CREATE OR REPLACE PROCEDURE PRC_OC_UPDATE
( VOC_CD    IN TBL_OC.OC_CD%TYPE
, VCRS_CD   IN TBL_OC.CRS_CD%TYPE
, VCRS_BD   IN TBL_OC.CRS_BD%TYPE
, VCRS_ED   IN TBL_OC.CRS_ED%TYPE
, VCRS_RM   IN TBL_OC.CRS_RM%TYPE
)
IS
    NOT_FOUND_ERROR EXCEPTION;    -- 과정코드 일치X 예외
    VCOUNT          NUMBER;       -- 과정코드 확인용
    OC_DATE_ERROR   EXCEPTION;    -- 날짜 관련 예외
BEGIN
    -- 동일한 과정코드가 있는지 체크
    SELECT COUNT(*) INTO VCOUNT
    FROM TBL_CRS
    WHERE CRS_CD = VCRS_CD;
    
    -- 동일한 과목코드가 있으면 과정개설 수정 UPDATE
    IF VCOUNT =1 
        AND (TO_NUMBER(VCRS_ED - VCRS_BD) > 0)
        THEN
            UPDATE TBL_OC
            SET CRS_CD = VCRS_CD
            , CRS_BD = VCRS_BD
            , CRS_ED = VCRS_ED
            , CRS_RM = VCRS_RM
            WHERE OC_CD = VOC_CD;
    ELSIF (TO_NUMBER(VCRS_ED - VCRS_BD) < 0)
        THEN RAISE OC_DATE_ERROR;
    ELSE RAISE NOT_FOUND_ERROR;
    END IF;
        
    --커밋
    COMMIT;      
    
    EXCEPTION
        WHEN NOT_FOUND_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002, '입력하신 정보와 일치하는 데이터가 없습니다.');
            ROLLBACK;
        WHEN OC_DATE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20005, '유효하지 않은 날짜입니다.');
            ROLLBACK;
        WHEN OTHERS THEN ROLLBACK;
END;


--○ 과정개설 삭제 프로시저

CREATE OR REPLACE PROCEDURE PRC_OC_DELETE
( 
    VOC_CD    IN TBL_OC.OC_CD%TYPE
)
IS
    NONEXIST_ERROR     EXCEPTION;
BEGIN
   DELETE
   FROM TBL_OC
   WHERE OC_CD = VOC_CD;
   
    IF SQL%NOTFOUND
    THEN RAISE NONEXIST_ERROR;
    END IF;
    
    -- 커밋
    COMMIT;

    EXCEPTION
    WHEN NONEXIST_ERROR
        THEN RAISE_APPLICATION_ERROR(-20002,'입력하신 정보와 일치하는 데이터가 없습니다.');
             ROLLBACK;
    WHEN OTHERS
        THEN ROLLBACK; 
           
END;


--○ 과정개설 및 과목개설 조회 프로시저

CREATE OR REPLACE PROCEDURE PRC_OC_OS_LOOKUP
IS
    V_CRS_NM    TBL_CRS.CRS_NM%TYPE;    --과정명
    V_CRS_RM    TBL_OC.CRS_RM%TYPE;     --강의실
    V_SUB_NM    TBL_SUB.SUB_NM%TYPE;    --과목명
    V_SUB_BD    TBL_OS.SUB_BD%TYPE;     --과목시작
    V_SUB_ED    TBL_OS.SUB_ED%TYPE;     --과목종료
    V_BK_NM     TBL_BK.BK_NM%TYPE;      --교재명
    V_PR_FN     TBL_PR.PR_FN%TYPE;      --교수성
    V_PR_LN     TBL_PR.PR_LN%TYPE;      --교수이름
    
    V_OC_CD     TBL_OS.OC_CD%TYPE;
    V_SUB_CD    TBL_SUB.SUB_CD%TYPE;
    V_BK_CD     TBL_BK.BK_CD%TYPE;
    V_PR_ID     TBL_PR.PR_ID%TYPE;
    V_NUM       NUMBER := 1;
    V_ROWNUM    NUMBER;
BEGIN
    SELECT MAX(NUM_OS) INTO V_ROWNUM
    FROM VIEW_OS;
    
    LOOP
        SELECT OC_CD,SUB_CD,BK_CD,PR_ID,SUB_BD,SUB_ED INTO V_OC_CD,V_SUB_CD,V_BK_CD,V_PR_ID,V_SUB_BD,V_SUB_ED
        FROM VIEW_OS
        WHERE NUM_OS = V_NUM;
        
        SELECT CRS_NM INTO V_CRS_NM
        FROM TBL_CRS
        WHERE CRS_CD = (SELECT CRS_CD FROM TBL_OC WHERE OC_CD = V_OC_CD);
        
        SELECT CRS_RM INTO V_CRS_RM
        FROM TBL_OC
        WHERE OC_CD = V_OC_CD;
        
        SELECT SUB_NM INTO V_SUB_NM
        FROM TBL_SUB
        WHERE SUB_CD = V_SUB_CD;
        
        SELECT BK_NM INTO V_BK_NM
        FROM TBL_BK
        WHERE BK_CD = V_BK_CD;
        
        SELECT PR_FN,PR_LN INTO V_PR_FN,V_PR_LN
        FROM TBL_PR
        WHERE PR_ID = V_PR_ID;
        
        DBMS_OUTPUT.PUT_LINE(V_NUM || '.');
        DBMS_OUTPUT.PUT_LINE('과정명: ' || V_CRS_NM);
        DBMS_OUTPUT.PUT_LINE('강의실: ' || V_CRS_RM);
        DBMS_OUTPUT.PUT_LINE('과목명: ' || V_SUB_NM);
        DBMS_OUTPUT.PUT_LINE('과목기간: ' || V_SUB_BD || ' ~ ' || V_SUB_ED);
        DBMS_OUTPUT.PUT_LINE('교재명: ' || V_BK_NM);
        DBMS_OUTPUT.PUT_LINE('교수명: ' || V_PR_FN || ' ' || V_PR_LN);
        
        V_NUM := V_NUM+1;
        
        EXIT WHEN V_NUM > V_ROWNUM;
    END LOOP;
END;


--------------------------------------------------------------------------------


--○ 과목개설 입력 프로시저

CREATE OR REPLACE PROCEDURE PRC_OS_INSERT
(
    V_OC_CD     IN  TBL_OC.OC_CD%TYPE   -- 과정명
,   V_SUB_CD    IN  TBL_SUB.SUB_CD%TYPE -- 과목명
,   V_PR_ID     IN  TBL_PR.PR_ID%TYPE   -- 교수자 명
,   V_BK_CD     IN  TBL_BK.BK_CD%TYPE   -- 교재명
,   V_RAT_CD    IN  TBL_RAT.RAT_CD%TYPE -- 배점
,   V_SUB_BD    IN  TBL_OS.SUB_BD%TYPE  -- 과목시작날짜 (NULL 가능)
,   V_SUB_ED    IN  TBL_OS.SUB_ED%TYPE  -- 과목종료날짜 (NULL 가능)
)
IS

    TEMP                         TBL_OS.OS_CD%TYPE;
    V_OS_CD                      TBL_OS.OS_CD%TYPE;
    V_COUNT                      NUMBER; -- 개설과목 중복 체크
    V_COUNT1                     NUMBER; -- FK1 개설과정코드 체크
    V_COUNT2                     NUMBER; -- FK2 과목코드 체크  
    V_COUNT3                     NUMBER; -- FK3 교수아이디 체크
    V_COUNT4                     NUMBER; -- FK4 교재코드 체크
    V_COUNT5                     NUMBER; -- FK5 배점코드 체크
    
    ALREADY_REGISTERED_ERROR    EXCEPTION; -- 중복데이터 
    NOT_FOUND_ERROR             EXCEPTION; -- 외래키 참조시 부모테이블에 일치하는 값이 없을 때
    
BEGIN
    
    -- 과목 테이블의 과목코드를 담아서 EX) J001
    SELECT SUB_CD INTO TEMP
    FROM TBL_SUB
    WHERE SUB_CD = V_SUB_CD;

    -- 앞에 E 를 붙여서 과목개설 테이블의 개설과목코드로 만든다 EX) EJ001
    V_OS_CD := 'E' || TEMP;

    --동일한 개설과목코드이 있는지 체크
    SELECT COUNT(*) INTO V_COUNT
    FROM TBL_OS
    WHERE OS_CD = V_OS_CD;

    --FK1 개설과정코드 체크
    SELECT COUNT(*) INTO V_COUNT1
    FROM TBL_OC
    WHERE OC_CD = V_OC_CD;

    --FK2 과목코드 체크
    SELECT COUNT(*) INTO V_COUNT2
    FROM TBL_SUB
    WHERE SUB_CD = V_SUB_CD;
    
    --FK3 교수아이디 체크
    SELECT COUNT(*) INTO V_COUNT3
    FROM TBL_PR
    WHERE PR_ID = V_PR_ID;
    
    --FK4 교재명 체크
    SELECT COUNT(*) INTO V_COUNT4
    FROM TBL_BK
    WHERE BK_CD = V_BK_CD;
    
    --FK5 배점코드 체크
    SELECT COUNT(*) INTO V_COUNT5
    FROM TBL_RAT
    WHERE RAT_CD = V_RAT_CD;
    
    
    IF ((V_COUNT = 0) AND (V_COUNT1 = 1) AND (V_COUNT2 = 1) 
        AND (V_COUNT3 = 1) AND (V_COUNT4 = 1) AND (V_COUNT5 = 1))
        THEN
            INSERT INTO TBL_OS(OS_CD, OC_CD, SUB_CD, PR_ID, BK_CD, RAT_CD, SUB_BD, SUB_ED) 
            VALUES(V_OS_CD, V_OC_CD, V_SUB_CD, V_PR_ID, V_BK_CD, V_RAT_CD, V_SUB_BD, V_SUB_ED);
            
    ELSIF (V_COUNT > 0)
        THEN RAISE ALREADY_REGISTERED_ERROR;
    ELSE
        RAISE NOT_FOUND_ERROR;
    END IF; 
    
    COMMIT;
     
    EXCEPTION
        WHEN ALREADY_REGISTERED_ERROR
             THEN RAISE_APPLICATION_ERROR(-20001, '이미 존재하는 데이터입니다.');
             ROLLBACK;
        WHEN NOT_FOUND_ERROR
             THEN RAISE_APPLICATION_ERROR(-20002, '존재하지 않는 데이터가 포함되어있습니다.');
        WHEN OTHERS
             THEN ROLLBACK;
END;


--○ 과목개설 수정 프로시저 1 (교수자명)

CREATE OR REPLACE PROCEDURE PRC_OS_UPDATE
(
    V_OS_CD IN  TBL_OS.OS_CD%TYPE
,   V_PR_ID IN  TBL_OS.PR_ID%TYPE
)
IS
    V_COUNT                  NUMBER;    -- 과목개설코드 체크
    V_COUNT1                 NUMBER;    -- 외래키 교수자아이디 체크
    NOT_FOUND_ERROR          EXCEPTION; 
BEGIN
    --PK 과목개설코드 체크 (일치하는 데이터)
    SELECT COUNT(*) INTO V_COUNT
    FROM TBL_OS
    WHERE OS_CD = V_OS_CD;
    
    --FK3 교수아이디 체크
    SELECT COUNT(*) INTO V_COUNT1
    FROM TBL_PR
    WHERE PR_ID = V_PR_ID;
    
    IF (V_COUNT = 1) AND (V_COUNT1 = 1)
    THEN
        UPDATE TBL_OS
        SET    PR_ID = V_PR_ID
        WHERE  OS_CD = V_OS_CD;
        
        COMMIT;
    ELSE
        RAISE NOT_FOUND_ERROR;
    END IF; 

    EXCEPTION
        WHEN NOT_FOUND_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002, '입력하신 정보와 일치하는 데이터가 없습니다.');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;


--○ 과목개설 수정 프로시저 2 (전체)

CREATE OR REPLACE PROCEDURE PRC_OS_UPDATE_ALL
(
    V_OS_CD     IN  TBL_OS.OS_CD%TYPE   -- 과목개설코드
,   V_OC_CD     IN  TBL_OS.OC_CD%TYPE   -- 개설과정명
,   V_SUB_CD    IN  TBL_SUB.SUB_CD%TYPE -- 과목명
,   V_PR_ID     IN  TBL_PR.PR_ID%TYPE   -- 교수자 명
,   V_BK_CD     IN  TBL_BK.BK_CD%TYPE   -- 교재명
,   V_RAT_CD    IN  TBL_RAT.RAT_CD%TYPE -- 배점
,   V_SUB_BD    IN  TBL_OS.SUB_BD%TYPE  -- 과목시작날짜 (NULL 가능)
,   V_SUB_ED    IN  TBL_OS.SUB_ED%TYPE  -- 과목종료날짜 (NULL 가능)
)
IS
    NOT_FOUND_ERROR              EXCEPTION;
    V_COUNT                      NUMBER; -- 개설과목 중복 체크
    V_COUNT1                     NUMBER; -- FK1 개설과정코드 체크
    V_COUNT2                     NUMBER; -- FK2 과목코드 체크  
    V_COUNT3                     NUMBER; -- FK3 교수아이디 체크
    V_COUNT4                     NUMBER; -- FK4 교재코드 체크
    V_COUNT5                     NUMBER; -- FK5 배점코드 체크
BEGIN
    --PK 과목개설코드 체크 (일치하는 데이터)
    SELECT COUNT(*) INTO V_COUNT
    FROM TBL_OS
    WHERE OS_CD = V_OS_CD;
    
    --FK1 개설과정코드 체크
    SELECT COUNT(*) INTO V_COUNT1
    FROM TBL_OC
    WHERE OC_CD = V_OC_CD;

    --FK2 과목코드 체크
    SELECT COUNT(*) INTO V_COUNT2
    FROM TBL_SUB
    WHERE SUB_CD = V_SUB_CD;
    
    --FK3 교수아이디 체크
    SELECT COUNT(*) INTO V_COUNT3
    FROM TBL_PR
    WHERE PR_ID = V_PR_ID;
    
    --FK4 교재명 체크
    SELECT COUNT(*) INTO V_COUNT4
    FROM TBL_BK
    WHERE BK_CD = V_BK_CD;
    
    --FK5 배점코드 체크
    SELECT COUNT(*) INTO V_COUNT5
    FROM TBL_RAT
    WHERE RAT_CD = V_RAT_CD;

    IF ((V_COUNT = 1) AND (V_COUNT1 = 1) AND (V_COUNT2 = 1) 
        AND (V_COUNT3 = 1) AND (V_COUNT4 = 1) AND (V_COUNT5 = 1))
    THEN
        UPDATE TBL_OS
        SET    OC_CD = V_OC_CD
            ,  SUB_CD = V_SUB_CD
            ,  PR_ID = V_PR_ID
            ,  BK_CD = V_BK_CD
            ,  RAT_CD = V_RAT_CD
            ,  SUB_BD = V_SUB_BD
            ,  SUB_ED = V_SUB_ED
        WHERE  OS_CD = V_OS_CD;
        
        COMMIT;
    ELSE
        RAISE NOT_FOUND_ERROR;
    END IF;

    EXCEPTION
        WHEN NOT_FOUND_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002, '입력하신 정보와 일치하는 데이터가 없습니다.');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;


--○ 과목개설 삭제 프로시저

CREATE OR REPLACE PROCEDURE PRC_OS_DELETE
(
    V_OS_CD IN TBL_OS.OS_CD%TYPE    --개설과목코드
)
IS
    NONEXIST_ERROR     EXCEPTION;
BEGIN

    DELETE
    FROM TBL_OS
    WHERE OS_CD = V_OS_CD;
    
    IF SQL%NOTFOUND
        THEN RAISE NONEXIST_ERROR;
    END IF;
    
    COMMIT;
    
    EXCEPTION
        WHEN NONEXIST_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002,'입력하신 정보와 일치하는 데이터가 없습니다.');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;


--------------------------------------------------------------------------------


--○ 수강내역 입력 프로시저

-- 시퀀스 생성
CREATE SEQUENCE SEQ_REG
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCACHE;

--프로시저 생성
CREATE OR REPLACE PROCEDURE PRC_REG_INSERT
( V_ST_ID   TBL_ST.ST_ID%TYPE   -- 학생 아이디
, V_OC_CD   TBL_OC.OC_CD%TYPE   -- 개설과정 코드
, V_REG_DT  TBL_REG.REG_DT%TYPE  DEFAULT SYSDATE
)
IS
    V_REG_CD    TBL_REG.REG_CD%TYPE; --수강내역 코드
    V_COUNT_ID     NUMBER;
    V_COUNT_CD     NUMBER;
    INCORRECT_ERROR  EXCEPTION;
BEGIN
    SELECT COUNT(*) INTO V_COUNT_ID -- 학생아이디가 일치하면
    FROM TBL_ST
    WHERE V_ST_ID = ST_ID;
    
    
    SELECT COUNT(*) INTO V_COUNT_CD -- 개설과정코드가 일치하면
    FROM TBL_OC
    WHERE V_OC_CD = OC_CD;
    
    IF ( (V_COUNT_ID = 1) AND (V_COUNT_CD = 1) )
        THEN
            -- 수강내역코드 생성
            V_REG_CD := 'RG' || LPAD(SEQ_REG.NEXTVAL,3,'0');
            
            -- TBL_REG 테이블에 데이터 입력
            INSERT INTO TBL_REG(REG_CD, ST_ID, OC_CD, REG_DT) 
            VALUES (V_REG_CD, V_ST_ID, V_OC_CD, V_REG_DT);
        
        -- 학생아이디나 개설과정코드가 없을 경우 에러 발생
        ELSE RAISE INCORRECT_ERROR;
    END IF;
        
    -- 커밋
    COMMIT;

    -- 예외처리
    EXCEPTION
        WHEN INCORRECT_ERROR
            THEN RAISE_APPLICATION_ERROR(-20004, '아이디나 개설과정코드가 일치하지 않습니다.');
                ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;


--○ 수강내역 수정 프로시저

CREATE OR REPLACE PROCEDURE PRC_REG_UPDATE
( V_REG_CD   TBL_REG.REG_CD%TYPE  -- 수강신청코드 
, V_OC_CD    TBL_OC.OC_CD%TYPE    -- 개설과정코드
)
IS 
    NONEXIST_ERROR  EXCEPTION;
BEGIN
    --수강신청코드가 일치할 경우 데이터 수정
    UPDATE TBL_REG
    SET OC_CD = V_OC_CD
    WHERE REG_CD = V_REG_CD;
    
    -- 수강신청코드가 일치하지 않았을 시 실행되는 에러
    IF SQL%NOTFOUND
        THEN RAISE NONEXIST_ERROR;
    END IF;
    
    -- 커밋
    COMMIT;
    
    --예외처리
    EXCEPTION
        WHEN NONEXIST_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002, '입력하신 정보와 일치하는 데이터가 없습니다.');
                ROLLBACK;
            WHEN OTHERS
                THEN ROLLBACK;
END;


--○ 수강내역 삭제 프로시저

CREATE OR REPLACE PROCEDURE PRC_REG_DELETE
( V_REG_CD      TBL_REG.REG_CD%TYPE
)
IS
    NONEXIST_ERROR  EXCEPTION;
BEGIN
    -- 수강신청코드가 일치한다면 내역 삭제
    DELETE
    FROM TBL_REG
    WHERE REG_CD = V_REG_CD;

    -- 수강신청코드가 일치하지 않았을 시 실행되는 에러
    IF SQL%NOTFOUND
        THEN RAISE NONEXIST_ERROR;
    END IF;
    
    -- 커밋
    COMMIT;
    
    --예외처리
    EXCEPTION
        WHEN NONEXIST_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002, '입력하신 정보와 일치하는 데이터가 없습니다.');
                ROLLBACK;
            WHEN OTHERS
                THEN ROLLBACK;
END;


--○ 수강내역 조회 (전체) 프로시저

-- 뷰 생성
CREATE OR REPLACE VIEW VIEW_REG
AS
SELECT T.*
FROM
(   SELECT ROWNUM "NUM_REG", REG_CD "REG_CD", ST_ID "ST_ID", OC_CD "OC_CD", REG_DT "REG_DT"
    FROM TBL_REG
	ORDER BY 3,4
)T;

--프로시저 생성
CREATE OR REPLACE PROCEDURE PRC_REG_LOOKUP
(
    V_ST_ID     IN TBL_ST.ST_ID%TYPE    -- 학생아이디
,   V_OC_CD     IN TBL_OC.OC_CD%TYPE    -- 과정 코드
)
IS
    V_ST_FN       TBL_ST.ST_FN%TYPE;   -- 학생 성
    V_ST_LN       TBL_ST.ST_LN%TYPE;   -- 학생 이름
    V_CRS_NM      TBL_CRS.CRS_NM%TYPE; -- 과정명
    V_SUB_NM      TBL_SUB.SUB_NM%TYPE; -- 과목명
    V_SC_AT       TBL_SC.SC_AT%TYPE;   -- 출결
    V_SC_WT       TBL_SC.SC_WT%TYPE;   -- 필기
    V_SC_PT       TBL_SC.SC_PT%TYPE;   -- 실기
    
    V_OS_CD       TBL_OS.OS_CD%TYPE;
    V_CRS_CD      TBL_CRS.CRS_CD%TYPE;  -- 과정코드
    V_SUB_CD      TBL_SUB.SUB_CD%TYPE;  -- 과목코드
    V_REG_CD      TBL_REG.REG_CD%TYPE; -- 수강신청코드
    
    V_SC_TOT        NUMBER;             -- 수강과목 총점
    
    V_COUNT         NUMBER;
    Q_COUNT         NUMBER;
    V_MINNUM        NUMBER;
    V_MAXNUM        NUMBER;
    V_NUM           NUMBER := 1;
    
    NONEXIST_ERROR  EXCEPTION;
    
BEGIN
    
    SELECT COUNT(*) INTO V_COUNT
    FROM TBL_REG
    WHERE ST_ID = V_ST_ID AND OC_CD = V_OC_CD;
    
    IF (V_COUNT > 0)
        THEN 
            -- 학생이 조회되는 최소 번호(ROWNUM)부터 최대 번호값
            SELECT MIN(ROWNUM),MAX(ROWNUM) INTO V_MINNUM,V_MAXNUM
            FROM VIEW_REG
            WHERE ST_ID = V_ST_ID AND OC_CD = V_OC_CD;
            
            -- 해당 학생이 여러 과목을 들었다면     
            LOOP
                --수강신청코드, 개설과정코드
                SELECT REG_CD INTO V_REG_CD
                FROM VIEW_REG_ORDER
                WHERE ST_ID = V_ST_ID AND OC_CD = V_OC_CD;
                
                -- 학생 이름
                SELECT ST_FN, ST_LN INTO V_ST_FN, V_ST_LN
                FROM TBL_ST
                WHERE ST_ID = V_ST_ID;
                
                -- 과정개설 - 개설과정코드 / 수강내역 - 개설과정코드 → 과정코드
                SELECT CRS_CD INTO V_CRS_CD
                FROM TBL_OC
                WHERE OC_CD = V_OC_CD;
                
                -- 과정 - 과정코드 / 과정개설 - 과정코드 → 과정명
                SELECT CRS_NM INTO V_CRS_NM
                FROM TBL_CRS
                WHERE CRS_CD = V_CRS_CD;
                
                -- 과목개설 - 개설과정코드 / 수강내역 - 개설과정코드 → 과목코드
                SELECT OS_CD,SUB_CD INTO V_OS_CD,V_SUB_CD
                FROM VIEW_OS_ORDER
                WHERE OC_CD = V_OC_CD AND NUM_OS = V_NUM AND SYSDATE - SUB_ED > 0;
                
                -- 과목 - 과목코드 / 과목개설 - 과목코드 → 과목명
                SELECT SUB_NM INTO V_SUB_NM
                FROM TBL_SUB
                WHERE SUB_CD = V_SUB_CD;
                
                -- 성적입력 - 수강신청코드 / 수강내역 - 수강신청코드 → 성적
                SELECT SC_AT, SC_WT, SC_PT INTO V_SC_AT, V_SC_WT, V_SC_PT
                FROM TBL_SC
                WHERE REG_CD = V_REG_CD AND OS_CD = V_OS_CD;
                
                
                V_SC_TOT := (V_SC_AT + V_SC_WT + V_SC_PT);   --총점
                

               -- 중도탈락 학생 존재 여부 확인
		        SELECT COUNT(*) INTO Q_COUNT
		        FROM TBL_QT
		        WHERE REG_CD = V_REG_CD;
                
		        IF (Q_COUNT = 0)
                    THEN 
                        -- 학생 이름, 과정명, 수강과목, 수강과목 총점
                        -- 학생 정보 출력
                        DBMS_OUTPUT.PUT_LINE('학생이름 : ' || V_ST_FN || V_ST_LN);
                        DBMS_OUTPUT.PUT_LINE('과정명 : ' || V_CRS_NM);
                        DBMS_OUTPUT.PUT_LINE('수강과목 : ' || V_SUB_NM);
                        DBMS_OUTPUT.PUT_LINE('수강과목 총점 : ' || V_SC_TOT);
		        ELSIF (Q_COUNT > 0)
                    THEN
                        DBMS_OUTPUT.PUT_LINE('학생 이름 : ' || V_ST_FN || V_ST_LN);
                        DBMS_OUTPUT.PUT_LINE('과정명 : ' || V_CRS_NM);
                        DBMS_OUTPUT.PUT_LINE('※ 본 과정을 중도탈락한 학생입니다.');
		        END IF;
                
                V_MINNUM := V_MINNUM+1;
                V_NUM := V_NUM + 1;
                
                EXIT WHEN V_MINNUM > V_MAXNUM;
            
            END LOOP;
            
    ELSE RAISE NONEXIST_ERROR;
        
    END IF;
    
    
    -- 커밋
    COMMIT;
    
    -- 에러 처리
    EXCEPTION
        WHEN NONEXIST_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002, '존재하지 않는 데이터입니다.');
                ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
    

END;


--------------------------------------------------------------------------------


--○ 성적 입력 프로시저

-- 시퀀스 생성 
CREATE SEQUENCE SEQ_SC_CODE
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCACHE;

-- 프로시저 생성
CREATE OR REPLACE PROCEDURE PRC_SC_INSERT
(
    V_REG_CD    IN TBL_REG.REG_CD%TYPE          -- 수강신청 코드 
,   V_OS_CD     IN TBL_OS.OS_CD%TYPE            -- 개설과목 코드 
,   V_SC_AT     IN TBL_SC.SC_AT%TYPE            -- 출결 
,   V_SC_WT     IN TBL_SC.SC_WT%TYPE            -- 필기 
,   V_SC_PT     IN TBL_SC.SC_PT%TYPE            -- 실기 
)
IS
    V_SC_CD             TBL_SC.SC_CD%TYPE;      -- 성적 코드 
    V_COUNT_RCD         NUMBER;                 -- 예외처리용 수강신청코드1
    V_COUNT_OCD         NUMBER;                 -- 예외처리용 개설과목코드1
    V_COUNT_REG         NUMBER;                 -- 예외처리용 수강신청코드2
    V_COUNT_OS          NUMBER;                 -- 예외처리용 개설과목코드2
    V_COUNT_QT          NUMBER;
    V_SC_TOT            NUMBER;
    INCORRECT_ERROR     EXCEPTION;
    DUPLICATE_ERROR     EXCEPTION;
    TOTAL_SC_ERROR      EXCEPTION;
    QUIT_STUDENT_ERROR  EXCEPTION;
BEGIN
    SELECT COUNT(*) INTO V_COUNT_RCD
    FROM TBL_REG
    WHERE REG_CD = V_REG_CD;     
    
    SELECT COUNT(*) INTO V_COUNT_OCD
    FROM TBL_OS
    WHERE OS_CD = V_OS_CD;  
    
    SELECT COUNT(*) INTO V_COUNT_REG
    FROM TBL_SC
    WHERE REG_CD = V_REG_CD;
    
    -- 중도탈락한 학생일 때
    SELECT COUNT(*) INTO V_COUNT_QT
    FROM TBL_QT
    WHERE REG_CD = V_REG_CD;
    
    IF V_COUNT_QT > 0
        THEN RAISE QUIT_STUDENT_ERROR;
    END IF;
    
    IF ((V_COUNT_RCD = 1) AND (V_COUNT_OCD = 1))
        THEN V_SC_CD := 'SC' || LPAD(SEQ_SC_CODE.NEXTVAL,3,'0'); 
    -- 정확하지 않은 코드 입력했을 때 
    ELSE RAISE INCORRECT_ERROR;
    END IF;
    
    -- 이미 입력한 정보일때 
    IF V_COUNT_REG > 0
        THEN RAISE DUPLICATE_ERROR;
    END IF;
    
    IF (V_SC_AT + V_SC_WT + V_SC_PT) > 100
            THEN RAISE TOTAL_SC_ERROR;
    END IF;
        
    -- 테이블에 데이터 입력 
    INSERT INTO TBL_SC(SC_CD, REG_CD, OS_CD, SC_AT, SC_WT, SC_PT)
    VALUES (V_SC_CD, V_REG_CD, V_OS_CD, V_SC_AT, V_SC_WT, V_SC_PT);
        
    V_SC_TOT := V_SC_AT + V_SC_WT + V_SC_PT;
    DBMS_OUTPUT.PUT_LINE('총점 : ' || V_SC_TOT);    
    
    COMMIT;
    
    EXCEPTION
        WHEN INCORRECT_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002,'존재하지 않는 데이터입니다.');
                 ROLLBACK;
        WHEN TOTAL_SC_ERROR
            THEN RAISE_APPLICATION_ERROR(-20003,'배점 비율을 고려하여 입력하여 주십시오.');   
                 ROLLBACK;         
        WHEN QUIT_STUDENT_ERROR
            THEN RAISE_APPLICATION_ERROR(-20008,'중도탈락한 학생입니다.');
                 ROLLBACK;
        WHEN DUPLICATE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20001, '이미 존재하는 데이터입니다.');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;


--○ 성적 수정 프로시저

CREATE OR REPLACE PROCEDURE PRC_SC_UPDATE
( 
  V_SC_CD   IN TBL_SC.SC_CD%TYPE
, V_SC_AT   IN TBL_SC.SC_AT%TYPE
, V_SC_WT   IN TBL_SC.SC_WT%TYPE
, V_SC_PT   IN TBL_SC.SC_PT%TYPE
)
IS
    NONEXIST_ERROR  EXCEPTION;
    TOTAL_SC_ERROR  EXCEPTION;
BEGIN
    UPDATE TBL_SC
    SET SC_AT = V_SC_AT, SC_WT = V_SC_WT, SC_PT = V_SC_PT
    WHERE SC_CD = V_SC_CD;
    
    IF SQL%NOTFOUND
        THEN RAISE NONEXIST_ERROR;
    END IF;
    
    IF (V_SC_AT + V_SC_WT + V_SC_PT) > 100
            THEN RAISE TOTAL_SC_ERROR;
    END IF;
       
    COMMIT;
    
    EXCEPTION
        WHEN NONEXIST_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002,'입력하신 정보와 일치하는 데이터가 없습니다.');
                 ROLLBACK;
        WHEN TOTAL_SC_ERROR
            THEN RAISE_APPLICATION_ERROR(-20003,'배점 비율을 고려하여 입력하여 주십시오.');
        WHEN OTHERS
            THEN ROLLBACK;
END;


--○ 성적 삭제 프로시저 

CREATE OR REPLACE PROCEDURE PRC_SC_DELETE
(
  V_SC_CD   IN TBL_SC.SC_CD%TYPE
)
IS
    NONEXIST_ERROR  EXCEPTION;
BEGIN
    DELETE
    FROM TBL_SC
    WHERE SC_CD = V_SC_CD;
    
    IF SQL%NOTFOUND
        THEN RAISE NONEXIST_ERROR;
    END IF;
       
    COMMIT;
    
    EXCEPTION
        WHEN NONEXIST_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002,'입력하신 정보와 일치하는 데이터가 없습니다.');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;


--○ 성적 조회 프로시저 (전체과목 전체학생) 

CREATE OR REPLACE VIEW VIEW_SC
AS
SELECT T.*
FROM
(   SELECT ROWNUM "NUM_SC", SC_CD "SC_CD", REG_CD "REG_CD", OS_CD "OS_CD", SC_AT "SC_AT"
         , SC_WT "SC_WT", SC_PT "SC_PT", SC_AT+SC_WT+SC_PT "SC_TT"
         , RANK() OVER (ORDER BY (SC_AT+SC_WT+SC_PT) DESC) "SC_RK"
    FROM TBL_SC
)T;

CREATE OR REPLACE PROCEDURE PRC_SC_LOOKUP
IS
    V_ST_FN     TBL_ST.ST_FN%TYPE;
    V_ST_LN     TBL_ST.ST_LN%TYPE;
    V_CRS_NM    TBL_CRS.CRS_NM%TYPE;
    V_SUB_NM    TBL_SUB.SUB_NM%TYPE;
    V_SUB_BD    TBL_OS.SUB_BD%TYPE;
    V_SUB_ED    TBL_OS.SUB_ED%TYPE;
    V_BK_NM     TBL_BK.BK_NM%TYPE;
    V_SC_AT     TBL_SC.SC_AT%TYPE;
    V_SC_WT     TBL_SC.SC_WT%TYPE;
    V_SC_PT     TBL_SC.SC_PT%TYPE;
    V_SC_TT     NUMBER; --총점
    V_SC_RK     NUMBER; --등수
    
    V_SC_CD     TBL_SC.SC_CD%TYPE;
    V_REG_CD    TBL_REG.REG_CD%TYPE;
    V_OS_CD     TBL_OS.OS_CD%TYPE;
    V_CRS_CD    TBL_CRS.CRS_CD%TYPE;
    V_SUB_CD    TBL_SUB.SUB_CD%TYPE;
    V_BK_CD     TBL_BK.BK_CD%TYPE;
    V_NUM       NUMBER := 1;
    V_ROWNUM    NUMBER;
   
BEGIN
    SELECT MAX(NUM_SC) INTO V_ROWNUM
    FROM VIEW_SC;
    
    LOOP
        --추가
        SELECT REG_CD,OS_CD,SC_CD INTO V_REG_CD,V_OS_CD,V_SC_CD
        FROM VIEW_SC
        WHERE NUM_SC = V_NUM;
        
        SELECT ST_FN, ST_LN INTO V_ST_FN, V_ST_LN
        FROM TBL_ST
        WHERE ST_ID = (SELECT ST_ID FROM TBL_REG WHERE REG_CD = V_REG_CD);
        
        --추가
        SELECT CRS_CD INTO V_CRS_CD
        FROM TBL_OC
        WHERE OC_CD = (SELECT OC_CD FROM TBL_OS WHERE OS_CD = V_OS_CD);
        
        SELECT CRS_NM INTO V_CRS_NM
        FROM TBL_CRS
        WHERE CRS_CD = V_CRS_CD;
        
        --추가
        SELECT SUB_CD,BK_CD INTO V_SUB_CD,V_BK_CD
        FROM TBL_OS
        WHERE OS_CD = V_OS_CD;
        
        SELECT SUB_NM INTO V_SUB_NM
        FROM TBL_SUB
        WHERE SUB_CD = V_SUB_CD;
        
				SELECT SUB_BD, SUB_ED INTO V_SUB_BD, V_SUB_ED
        FROM TBL_OS
        WHERE OS_CD = V_OS_CD;
        
        SELECT BK_NM INTO V_BK_NM  
        FROM TBL_BK
        WHERE BK_CD = V_BK_CD;
        
        SELECT SC_AT, SC_WT, SC_PT INTO V_SC_AT, V_SC_WT, V_SC_PT
        FROM TBL_SC
        WHERE SC_CD = V_SC_CD;
        
        SELECT (SC_AT + SC_WT + SC_PT) INTO V_SC_TT
        FROM TBL_SC
        WHERE SC_CD = V_SC_CD;
        
        SELECT RANK() OVER (ORDER BY (SC_AT + SC_WT + SC_PT) DESC) INTO V_SC_RK
        FROM TBL_SC
        WHERE SC_CD = V_SC_CD;
        
        IF V_SC_TT IS NOT NULL
            THEN
                DBMS_OUTPUT.PUT_LINE(V_NUM || '.');
                DBMS_OUTPUT.PUT_LINE('성: ' || V_ST_FN);
                DBMS_OUTPUT.PUT_LINE('이름: ' || V_ST_LN);
                DBMS_OUTPUT.PUT_LINE('과정명: ' || V_CRS_NM);
                DBMS_OUTPUT.PUT_LINE('과목명: ' || V_SUB_NM);
                DBMS_OUTPUT.PUT_LINE('과목기간: ' || V_SUB_BD || ' ~ ' || V_SUB_ED);
                DBMS_OUTPUT.PUT_LINE('교재명: ' || V_BK_NM);
                DBMS_OUTPUT.PUT_LINE('출결: ' || V_SC_AT);
                DBMS_OUTPUT.PUT_LINE('필기: ' || V_SC_WT);
                DBMS_OUTPUT.PUT_LINE('실기: ' || V_SC_PT);
                DBMS_OUTPUT.PUT_LINE('총점: ' || V_SC_TT);
                DBMS_OUTPUT.PUT_LINE('등수: ' || V_SC_RK);
       
        ELSIF V_SC_TT IS NULL
            THEN 
                DBMS_OUTPUT.PUT_LINE(V_NUM || '.');
                DBMS_OUTPUT.PUT_LINE('성: ' || V_ST_FN);
                DBMS_OUTPUT.PUT_LINE('이름: ' || V_ST_LN);
                DBMS_OUTPUT.PUT_LINE('과정명: ' || V_CRS_NM);
                DBMS_OUTPUT.PUT_LINE('과목명: ' || V_SUB_NM);
                DBMS_OUTPUT.PUT_LINE('과목기간: ' || V_SUB_BD || ' ~ ' || V_SUB_ED);
                DBMS_OUTPUT.PUT_LINE('교재명: ' || V_BK_NM);
                DBMS_OUTPUT.PUT_LINE('※ 본 과목을 중도탈락하여 조회할 성적이 없습니다. ※');
        END IF;
        
        V_NUM := V_NUM+1;
        
        EXIT WHEN V_NUM > V_ROWNUM;
    END LOOP;
END;


--○ 성적 조회 프로시저 (1교수 전체학생) 

CREATE OR REPLACE PROCEDURE PRC_PR_SC_LOOKUP
(
    V_PR_ID      IN TBL_PR.PR_ID%TYPE   -- 교수아이디
)
IS
    V_SUB_NM     TBL_SUB.SUB_NM%TYPE; -- 배정된 과목명
    V_SUB_BD     TBL_OS.SUB_BD%TYPE;  -- 과목 시작일
    V_SUB_ED     TBL_OS.SUB_ED%TYPE;  -- 과목 종료일
    V_BK_CD      TBL_BK.BK_CD%TYPE;   -- 교재코드
    V_BK_NM      TBL_BK.BK_NM%TYPE;   -- 교재명
    
    V_OS_CD      TBL_OS.OS_CD%TYPE;   -- 과목개설코드
    V_SUB_CD     TBL_SUB.SUB_CD%TYPE; -- 과목코드
    
    V_REG_CD     TBL_REG.REG_CD%TYPE; -- 수강내역코드
    V_ST_ID      TBL_ST.ST_ID%TYPE;
    
    V_SC_CD      TBL_SC.SC_CD%TYPE;   -- 성적코드
    V_SC_AT      TBL_SC.SC_AT%TYPE;   -- 출결
    V_SC_WT      TBL_SC.SC_WT%TYPE;   -- 필기
    V_SC_PT      TBL_SC.SC_PT%TYPE;   -- 실기
    
    V_SC_TT     NUMBER; --총점
    V_SC_RK     NUMBER; --등수
    
    V_OC_CD      TBL_OC.OC_CD%TYPE;   -- 개설과정코드
    V_CRS_CD     TBL_OC.CRS_CD%TYPE;  -- 과정코드
    VCRS_NM      TBL_CRS.CRS_NM%TYPE; -- 과정명
    
    V_ST_FN      TBL_ST.ST_FN%TYPE;   -- 학생 성
    V_ST_LN      TBL_ST.ST_LN%TYPE;   -- 학생 이름
    
    V_NUM        NUMBER;   
    V_ROWNUM     NUMBER;
    V_NUM2       NUMBER;
    V_NUM3       NUMBER := 1;
    V_ROWNUM2    NUMBER;
    V_COUNT      NUMBER;
BEGIN
    SELECT MIN(ROWNUM),MAX(ROWNUM) INTO V_NUM,V_ROWNUM
    FROM VIEW_OS
    WHERE PR_ID = V_PR_ID AND SYSDATE > SUB_ED;

    LOOP
        SELECT OS_CD,SUB_BD,SUB_ED,BK_CD,OC_CD INTO V_OS_CD,V_SUB_BD,V_SUB_ED,V_BK_CD,V_OC_CD
        FROM VIEW_OS
        WHERE PR_ID = V_PR_ID AND NUM_OS = V_NUM;
        
        SELECT SUB_NM INTO V_SUB_NM
        FROM TBL_SUB
        WHERE SUB_CD = (SELECT SUB_CD FROM TBL_OS WHERE OS_CD = V_OS_CD);
        
        SELECT BK_NM INTO V_BK_NM
        FROM TBL_BK
        WHERE BK_CD = V_BK_CD;
        
        -- 개설 과정코드 찾기
        SELECT CRS_CD INTO V_CRS_CD
        FROM TBL_OC
        WHERE OC_CD = V_OC_CD;
        
        -- 개설 과정명 찾기
        SELECT CRS_NM INTO VCRS_NM
        FROM TBL_CRS
        WHERE CRS_CD = V_CRS_CD;
        
        -- 학생들 번호 생성
        SELECT MIN(ROWNUM),MAX(ROWNUM) INTO V_NUM2,V_ROWNUM2
        FROM TBL_REG
        WHERE OC_CD = V_OC_CD;
        
        --강의과목 정보 출력
        DBMS_OUTPUT.PUT_LINE(V_NUM || '.');
        DBMS_OUTPUT.PUT_LINE('과정명 : '|| VCRS_NM );
        DBMS_OUTPUT.PUT_LINE('과목명 : ' || V_SUB_NM  );
        DBMS_OUTPUT.PUT_LINE('과목 기간 : ' || V_SUB_BD || '~' || V_SUB_ED );
        DBMS_OUTPUT.PUT_LINE('교재명 : ' || V_BK_NM );
        DBMS_OUTPUT.PUT_LINE('');
        
        LOOP
            --중도탈락 학생 존재 여부 확인
            SELECT COUNT(*) INTO V_COUNT
            FROM TBL_QT
            WHERE REG_CD = V_REG_CD;
            
            -- 수강내역코드 연산
            SELECT REG_CD INTO V_REG_CD
            FROM VIEW_REG
            WHERE OC_CD = V_OC_CD AND NUM_REG = V_NUM2;
            
            -- 학생 코드 연산
            SELECT ST_ID INTO V_ST_ID
            FROM VIEW_REG
            WHERE REG_CD = V_REG_CD AND NUM_REG = V_NUM2;
            
            -- 학생 성 가져오기
            SELECT ST_FN INTO V_ST_FN
            FROM TBL_ST
            WHERE ST_ID = V_ST_ID;
            
            -- 학생 이름 가져오기
            SELECT ST_LN INTO V_ST_LN
            FROM TBL_ST
            WHERE ST_ID = V_ST_ID;
            
            --중도탈락하지 않았을 경우
            IF V_COUNT = 0
                THEN
                    -- 성적 코드 가져오기
                    SELECT SC_CD INTO V_SC_CD
                    FROM TBL_SC
                    WHERE REG_CD = V_REG_CD;
                    
                    -- 출결
                    SELECT SC_AT INTO V_SC_AT
                    FROM TBL_SC
                    WHERE REG_CD = V_REG_CD;
                    
                    -- 필기
                    SELECT SC_WT INTO V_SC_WT
                    FROM TBL_SC
                    WHERE REG_CD = V_REG_CD;
                    
                    -- 실기
                    SELECT SC_PT INTO V_SC_PT
                    FROM TBL_SC
                    WHERE REG_CD = V_REG_CD; 
                    
                    -- 총점
                    SELECT SC_TT INTO V_SC_TT
                    FROM VIEW_SC
                    WHERE SC_CD = V_SC_CD;
                    
                    -- 등수
                    SELECT SC_RK INTO V_SC_RK
                    FROM VIEW_SC
                    WHERE SC_CD = V_SC_CD;
                    
                    -- 과목의 학생 성적 정보 출력        
                    DBMS_OUTPUT.PUT_LINE(V_NUM3 || ')');
                    DBMS_OUTPUT.PUT_LINE('학생 이름 : ' || V_ST_FN || V_ST_LN );
                    DBMS_OUTPUT.PUT_LINE('출결 : ' || V_SC_AT  || '점, 필기 : ' || V_SC_WT  || '점, 실기 : ' || V_SC_PT );
                    DBMS_OUTPUT.PUT_LINE('총점 : ' || V_SC_TT || '점');
                    DBMS_OUTPUT.PUT_LINE('등수 : ' || V_SC_RK || '등');
            --중도탈락일 경우
            ELSIF V_COUNT > 0
                THEN 
                    DBMS_OUTPUT.PUT_LINE(V_NUM3 || ')');
                    DBMS_OUTPUT.PUT_LINE('학생 이름 : ' || V_ST_FN || V_ST_LN );
                    DBMS_OUTPUT.PUT_LINE('※ 본 과목을 중도탈락하여 조회할 성적이 없습니다. ※');
            END IF;
        
            V_NUM2 := V_NUM2+1;
            V_NUM3 := V_NUM3+1;
            
            EXIT WHEN V_NUM2 > V_ROWNUM2;
        END LOOP;
        
        V_NUM := V_NUM+1;
        
        EXIT WHEN V_NUM > V_ROWNUM;
    END LOOP;
END;


--○ 성적 조회 프로시저 (1학생 1과목)

--뷰 생성
CREATE OR REPLACE VIEW VIEW_OS_ORDER
AS
SELECT T.*
FROM
(   SELECT ROWNUM "NUM_OS_ORDER", NUM_OS "NUM_OS", OS_CD "OS_CD", OC_CD "OC_CD", SUB_CD "SUB_CD", PR_ID "PR_ID"
         , BK_CD "BK_CD", RAT_CD "RAT_CD", SUB_BD "SUB_BD", SUB_ED "SUB_ED"
    FROM VIEW_OS
)T;

--프로시저 생성
CREATE OR REPLACE PROCEDURE PRC_REG_ST_LOOKUP
(
    V_ST_ID       IN TBL_ST.ST_ID%TYPE    -- 학생아이디
,   V_REG_CD      IN TBL_REG.REG_CD%TYPE  -- 수강내역 코드
,   V_OS_CD       IN TBL_OS.OS_CD%TYPE
,   V_NUM         NUMBER    DEFAULT 1
)
IS
    V_ST_FN       TBL_ST.ST_FN%TYPE;    -- 학생 성
    V_ST_LN       TBL_ST.ST_LN%TYPE;    -- 학생 이름
    V_CRS_NM      TBL_CRS.CRS_NM%TYPE;  -- 과정명
    V_SUB_NM      TBL_SUB.SUB_NM%TYPE;  -- 과목명
    V_SC_AT       TBL_SC.SC_AT%TYPE;    -- 출결
    V_SC_WT       TBL_SC.SC_WT%TYPE;    -- 필기
    V_SC_PT       TBL_SC.SC_PT%TYPE;    -- 실기
    V_SUB_BD      TBL_OS.SUB_BD%TYPE;
    V_SUB_ED      TBL_OS.SUB_ED%TYPE;
    V_BK_NM       TBL_BK.BK_NM%TYPE;

    V_CRS_CD      TBL_CRS.CRS_CD%TYPE;  -- 과정코드
    V_SUB_CD      TBL_SUB.SUB_CD%TYPE;  -- 과목코드
    V_SC_CD       TBL_SC.SC_CD%TYPE;
    V_OC_CD       TBL_OC.OC_CD%TYPE;
    V_BK_CD       TBL_BK.BK_CD%TYPE;
    
    V_SC_TOT       NUMBER;             -- 수강과목 총점
    V_SC_RK        NUMBER;             --등수
    
    V_COUNT         NUMBER;
    V_COUNT_QT      NUMBER;
    V_MINNUM        NUMBER;
    V_MAXNUM        NUMBER;
    
    NONEXIST_ERROR  EXCEPTION;
BEGIN
    --중도탈락 여부 조회
    SELECT COUNT(*) INTO V_COUNT
    FROM TBL_QT
    WHERE REG_CD = V_REG_CD;
            
    -- 학생 이름
    SELECT ST_FN, ST_LN INTO V_ST_FN, V_ST_LN
    FROM TBL_ST
    WHERE ST_ID = V_ST_ID;
        
    -- 과정개설 - 개설과정코드
    SELECT OC_CD INTO V_OC_CD
    FROM TBL_REG
    WHERE REG_CD = V_REG_CD;
        
    -- 수강내역 - 개설과정코드 → 과정코드
    SELECT CRS_CD INTO V_CRS_CD
    FROM TBL_OC
    WHERE OC_CD = V_OC_CD;
                    
    -- 과정 - 과정코드 / 과정개설 - 과정코드 → 과정명
    SELECT CRS_NM INTO V_CRS_NM
    FROM TBL_CRS
    WHERE CRS_CD = V_CRS_CD;
                    
    -- 과목개설 - 개설과정코드 / 수강내역 - 개설과정코드 → 과목코드
		SELECT SUB_CD INTO V_SUB_CD
    FROM VIEW_OS
    WHERE OS_CD = V_OS_CD;
                    
    -- 과목 - 과목코드 / 과목개설 - 과목코드 → 과목명
    SELECT SUB_NM INTO V_SUB_NM
    FROM TBL_SUB
    WHERE SUB_CD = V_SUB_CD;
                    
    -- 기간 
    SELECT SUB_BD, SUB_ED INTO V_SUB_BD, V_SUB_ED
    FROM TBL_OS
    WHERE SUB_CD = V_SUB_CD;
                    
    -- 과정 -> 과목코드 
		SELECT BK_CD INTO V_BK_CD
    FROM VIEW_OS_ORDER
    WHERE OS_CD = V_OS_CD;
                    
    -- 교재명 
    SELECT BK_NM INTO V_BK_NM  
    FROM TBL_BK
    WHERE BK_CD = V_BK_CD;
                     
    IF (V_COUNT = 0)
        THEN 
            -- 성적코드 
            SELECT SC_CD INTO V_SC_CD
            FROM TBL_SC
            WHERE REG_CD = V_REG_CD AND OS_CD = V_OS_CD;
                            
            -- 출, 필, 실
            SELECT SC_AT, SC_WT, SC_PT INTO V_SC_AT, V_SC_WT, V_SC_PT
            FROM TBL_SC
            WHERE REG_CD = V_REG_CD AND OS_CD = V_OS_CD;
                            
            -- 총점
            SELECT (SC_AT + SC_WT + SC_PT) INTO V_SC_TOT
            FROM TBL_SC
            WHERE SC_CD = V_SC_CD;
                            
            -- 등수
            SELECT RANK() OVER (ORDER BY (SC_AT + SC_WT + SC_PT) DESC) INTO V_SC_RK
            FROM TBL_SC
            WHERE SC_CD = V_SC_CD;
            
            DBMS_OUTPUT.PUT_LINE('학생명: ' || V_ST_FN || V_ST_LN);
            DBMS_OUTPUT.PUT_LINE('과정명: ' || V_CRS_NM);
            DBMS_OUTPUT.PUT_LINE('과목명: ' || V_SUB_NM);
            DBMS_OUTPUT.PUT_LINE('과목기간: ' || V_SUB_BD || ' ~ ' || V_SUB_ED);
            DBMS_OUTPUT.PUT_LINE('교재명: ' || V_BK_NM);
            DBMS_OUTPUT.PUT_LINE('출결: ' || V_SC_AT);
            DBMS_OUTPUT.PUT_LINE('필기: ' || V_SC_WT);
            DBMS_OUTPUT.PUT_LINE('실기: ' || V_SC_PT);
            DBMS_OUTPUT.PUT_LINE('총점: ' || V_SC_TOT);
            DBMS_OUTPUT.PUT_LINE('등수: ' || V_SC_RK);
    ELSIF V_COUNT > 0 
        THEN 
            DBMS_OUTPUT.PUT_LINE('학생명: ' || V_ST_FN || V_ST_LN);
            DBMS_OUTPUT.PUT_LINE('과정명: ' || V_CRS_NM);
            DBMS_OUTPUT.PUT_LINE('과목명: ' || V_SUB_NM);
            DBMS_OUTPUT.PUT_LINE('과목기간: ' || V_SUB_BD || ' ~ ' || V_SUB_ED);
            DBMS_OUTPUT.PUT_LINE('교재명: ' || V_BK_NM);
            DBMS_OUTPUT.PUT_LINE('※ 본 과목을 중도탈락하여 조회할 성적이 없습니다. ※');
    END IF;
        
    -- 에러 처리
    EXCEPTION
        WHEN NONEXIST_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002, '존재하지 않는 데이터입니다.');
END;


--○ 성적 조회 프로시저 (1학생 전체과목)

--뷰 생성
CREATE OR REPLACE VIEW VIEW_REG_ORDER
AS
SELECT T.*
FROM
(   SELECT ROWNUM "NUM_REG_ORDER", NUM_REG "NUM_REG", REG_CD "REG_CD", ST_ID "ST_ID", OC_CD "OC_CD", REG_DT "REG_DT"
    FROM VIEW_REG
)T;

--프로시저 생성
CREATE OR REPLACE PROCEDURE PRC_REG_ST_LOOKUP_ALL
(   V_ST_ID     IN TBL_ST.ST_ID%TYPE
)
IS
    V_REG_CD      TBL_REG.REG_CD%TYPE;
    V_OS_CD       TBL_OS.OS_CD%TYPE;
    V_OC_CD       TBL_OC.OC_CD%TYPE;
    
    V_NUM        NUMBER := 1;
    V_MINNUM     NUMBER; 
    V_MAXNUM     NUMBER;
BEGIN
    SELECT MIN(ROWNUM),MAX(ROWNUM) INTO V_MINNUM,V_MAXNUM
    FROM VIEW_REG_ORDER
    WHERE ST_ID = V_ST_ID;
    
    SELECT REG_CD,OC_CD INTO V_REG_CD,V_OC_CD
    FROM VIEW_REG_ORDER
    WHERE NUM_REG_ORDER = V_MINNUM;
    
    LOOP        
        SELECT OS_CD INTO V_OS_CD
        FROM VIEW_OS_ORDER
        WHERE OC_CD = V_OC_CD AND NUM_OS_ORDER = V_MINNUM;
        
        DBMS_OUTPUT.PUT_LINE(V_MINNUM || '.');
        PRC_REG_ST_LOOKUP(V_ST_ID,V_REG_CD,V_OS_CD,V_NUM);
        
        V_MINNUM := V_MINNUM + 1;
        V_NUM := V_NUM +1;
        
        EXIT WHEN V_MINNUM > V_MAXNUM;
    END LOOP;
END;


--------------------------------------------------------------------------------


--○ 중도탈락 입력 프로시저

--시퀀스 생성
CREATE SEQUENCE SEQ_QUIT
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCACHE;

--프로시저 생성
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


--○ 중도탈락 수정 프로시저

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


--○ 중도 탈락 삭제 프로시저

CREATE OR REPLACE PROCEDURE PRC_QUIT_DELETE
(   V_QT_CD    IN TBL_QT.QT_CD%TYPE
)
IS
    NONEXIST_ERROR     EXCEPTION;
BEGIN
    --중도탈락코드가 일치할 경우 데이터 삭제
    DELETE
    FROM TBL_QT
    WHERE QT_CD = V_QT_CD;
    
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


--○ 중도탈락 조회 프로시저

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



--③ 데이터 입력----------------------------------------------------------------


INSERT INTO TBL_AD(AD_ID, AD_PW) VALUES('ADMIN','ADMIN');

SELECT *
FROM TBL_AD;
/*
AD_ID	AD_PW
ADMIN	ADMIN
*/

EXEC PRC_PR_INSERT('750416-1234567', '김', '호진', '21/01/01');
EXEC PRC_PR_INSERT('971006-2234567', '한', '혜림', '21/02/01');

SELECT *
FROM TBL_PR;
/*
PR_ID	PR_SSN	        PR_FN	PR_LN	PR_DT	    PR_PW
PR001	750416-1234567	김	    호진	21/01/01	1234567
PR002	971006-2234567	한	    혜림	21/04/01	2234567
*/

EXEC PRC_ST_INSERT('930308-2000001', '김', '아별', '21/01/30');
EXEC PRC_ST_INSERT('951102-2000002', '선', '혜연', '21/01/19');
EXEC PRC_ST_INSERT('971224-2000003', '정', '주희', '21/01/27');
EXEC PRC_ST_INSERT('980709-2000004', '장', '서현', '21/01/28');

SELECT *
FROM TBL_ST;
/*
ST_ID	ST_SSN	        ST_FN	ST_LN	ST_DT	    ST_PW
ST001	930308-2000001	김	    아별	21/01/30	2000001
ST002	951102-2000002	선	    혜연	21/01/19	2000002
ST003	971224-2000003	정	    주희	21/01/27	2000003
ST004	980709-2000004	장	    서현	21/01/28	2000004
*/

EXEC PRC_CRS_INSERT('FS 자바(JAVA)를 활용한 풀스택 융합 SW개발자 양성과정');

SELECT *
FROM TBL_CRS;
/*
CRS_CD	CRS_NM
FS001	FS 자바(JAVA)를 활용한 풀스택 융합 SW개발자 양성과정
*/

EXEC PRC_SUB_INSERT('J 자바 프로그래밍');
EXEC PRC_SUB_INSERT('O 데이터베이스 프로그래밍(오라클)');

SELECT *
FROM TBL_SUB;
/*
SUB_CD	SUB_NM
J001	J 자바 프로그래밍
O002	O 데이터베이스 프로그래밍(오라클)
*/

EXEC PRC_RAT_INSERT(30,20,50);

SELECT *
FROM TBL_RAT;
/*
RAT_CD	RAT_AT	RAT_WT	RAT_PT
RT001	30	    20	    50
*/

EXEC PRC_BK_INSERT('Java의 정석');
EXEC PRC_BK_INSERT('오라클 SQL과 PL/SQL');

SELECT *
FROM TBL_BK;
/*
BK_CD	BK_NM
B001	Java의 정석
B002	오라클 SQL과 PL/SQL
*/

EXEC PRC_OC_INSERT('FS001','21/02/01','21/07/12','F강의실');

SELECT *
FROM TBL_OC;
/*
OC_CD	CRS_CD	CRS_BD	    CRS_ED	    CRS_RM
A_FS001	FS001	21/02/01	21/07/12	F강의실
*/

EXEC PRC_OS_INSERT('A_FS001', 'J001', 'PR001', 'B001', 'RT001', '21/02/01', '21/03/16');
EXEC PRC_OS_INSERT('A_FS001', 'O002', 'PR001', 'B002', 'RT001', '21/03/17', '21/04/19');

SELECT *
FROM TBL_OS;
/*
OS_CD	OC_CD	SUB_CD	PR_ID	BK_CD	RAT_CD	SUB_BD	    SUB_ED
EJ001	A_FS001	J001	PR001	B001	RT001	21/02/01	21/03/16
EO002	A_FS001	O002	PR001	B002	RT001	21/03/17	21/04/19
*/

EXEC PRC_REG_INSERT('ST003', 'A_FS001', '21/01/25');
EXEC PRC_REG_INSERT('ST001', 'A_FS001', '21/01/29');
EXEC PRC_REG_INSERT('ST004', 'A_FS001', '21/01/30');
EXEC PRC_REG_INSERT('ST002', 'A_FS001', '21/01/31');

SELECT *
FROM TBL_REG
ORDER BY 1;
/*
REG_CD	ST_ID	OC_CD	REG_DT
RG001	ST003	A_FS001	21/01/25
RG002	ST001	A_FS001	21/01/29
RG003	ST004	A_FS001	21/01/30
RG004	ST002	A_FS001	21/01/31
*/

EXEC PRC_SC_INSERT('RG001', 'EJ001', 30, 16, 46);
--==>> 총점 : 92
EXEC PRC_SC_INSERT('RG002', 'EJ001', 28, 18, 50);
--==>> 총점 : 96
EXEC PRC_SC_INSERT('RG003', 'EJ001', 28, 16, 42);
--==>> 총점 : 86
EXEC PRC_SC_INSERT('RG004', 'EJ001', 30, 20, 48);
--==>> 총점 : 98

SELECT *
FROM TBL_SC
ORDER BY 1;
/*
SC_CD	REG_CD	OS_CD	SC_AT	SC_WT	SC_PT
SC001	RG001	EJ001	30	    16	    46
SC002	RG002	EJ001	28	    18	    50
SC003	RG003	EJ001	28	    16	    42
SC004	RG004	EJ001	30	    20	    48
*/

EXEC PRC_QUIT_INSERT('RG004','21/04/01');

SELECT *
FROM TBL_QT;
/*
QT_CD	REG_CD	QT_DT
Q001	RG004	21/04/16
*/

