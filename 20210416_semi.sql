--○ 과목개설 조회 프로시저용 VIEW 생성
CREATE OR REPLACE VIEW VIEW_OS
AS
SELECT T.*
FROM
(
    SELECT ROWNUM "NUM", OS_CD "OS_CD", OC_CD "OC_CD", SUB_CD "SUB_CD", PR_ID "PR_ID"
          ,BK_CD "BK_CD", RAT_CD "RAT_CD", SUB_BD "SUB_BD", SUB_ED "SUB_ED"
    FROM TBL_OS
)T;


--○ 과목개설 전체 조회 프로시저 생성
CREATE OR REPLACE PROCEDURE PRC_OS_LOOKUP
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
    SELECT MAX(NUM) INTO V_ROWNUM
    FROM VIEW_OS;
    
    LOOP
        SELECT OC_CD,SUB_CD,BK_CD,PR_ID,SUB_BD,SUB_ED INTO V_OC_CD,V_SUB_CD,V_BK_CD,V_PR_ID,V_SUB_BD,V_SUB_ED
        FROM VIEW_OS
        WHERE NUM = V_NUM;
        
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


--○ 테스트용 데이터 입력
INSERT INTO TBL_OS(OS_CD,OC_CD,SUB_CD,PR_ID,BK_CD,RAT_CD,SUB_BD,SUB_ED)
VALUES('A_J001','A_SW001','J001','PR001','B001','RT001','21/02/01','21/03/01');
INSERT INTO TBL_OS(OS_CD,OC_CD,SUB_CD,PR_ID,BK_CD,RAT_CD,SUB_BD,SUB_ED)
VALUES('A_O001','A_WB001','O001','PR001','B002','RT001','21/07/01','21/08/01');

INSERT INTO TBL_OC(OC_CD,CRS_CD,CRS_BD,CRS_ED,CRS_RM)
VALUES('A_SW001','SW001','21/04/01','21/05/01','F강의실');
INSERT INTO TBL_OC(OC_CD,CRS_CD,CRS_BD,CRS_ED,CRS_RM)
VALUES('A_O001','WB001','21/05/01','21/06/01','E강의실');

INSERT INTO TBL_CRS(CRS_CD,CRS_NM) VALUES('SW001','SW소프트웨어');
INSERT INTO TBL_CRS(CRS_CD,CRS_NM) VALUES('WB001','WB웹개발');

INSERT INTO TBL_SUB(SUB_CD,SUB_NM) VALUES('J001','자바');
INSERT INTO TBL_SUB(SUB_CD,SUB_NM) VALUES('O001','오라클');

INSERT INTO TBL_PR(PR_ID,PR_SSN,PR_FN,PR_LN,PR_DT,PR_PW)
VALUES('PR001','121212-121212','KIM','HOJIN','21/01/01','121212');

INSERT INTO TBL_BK(BK_CD,BK_NM) VALUES('B001','자바의정석');
INSERT INTO TBL_BK(BK_CD,BK_NM) VALUES('B002','오라클의정석');


--○ 데이터 입력 후 VIEW 확인
/*
NUM	OS_CD	  OC_CD	  SUB_CD	PR_ID	BK_CD	RAT_CD	SUB_BD	  SUB_ED
1	  A_J001	A_SW001	J001	  PR001	B001	RT001	  21/02/01	21/03/01
2	  A_O001	A_WB001	O001	  PR001	B002	RT001	  21/07/01	21/08/01
*/


--○ 실행 예시
EXEC PRC_OS_LOOKUP;
/*
1.
과정명: SW소프트웨어
강의실: F강의실
과목명: 자바
과목기간: 21/02/01 ~ 21/03/01
교재명: 자바의정석
교수명: KIM HOJIN
2.
과정명: WB웹개발
강의실: E강의실
과목명: 오라클
과목기간: 21/07/01 ~ 21/08/01
교재명: 오라클의정석
교수명: KIM HOJIN
*/


--------------------------------------------------------------------------------


--○ 과정 입력 프로시저용 SEQUENCE 생성
CREATE SEQUENCE SEQ_CRS
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCACHE;


--○ 과정 입력 프로시저 생성
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


--○ 실행 예시
EXEC PRC_CRS_INSERT('FE프론트엔드');
/*
CRS_CD	CRS_NM
FE001	  FE프론트엔드
*/
EXEC PRC_CRS_INSERT('FE프론트엔드');
--==>> ORA-20001: 이미 존재하는 데이터입니다.

EXEC PRC_CRS_INSERT('BE백엔드');
/*
CRS_CD	CRS_NM
FE001	  FE프론트엔드
BE002	  BE백엔드
*/

EXEC PRC_CRS_INSERT('풀스택');
--==>> ORA-20007: 유효하지 않은 과정명입니다.


--------------------------------------------------------------------------------


--○ 테스트용 데이터 입력 및 수정
INSERT INTO TBL_PR(PR_ID,PR_SSN,PR_FN,PR_LN,PR_DT,PR_PW)
VALUES('PR002','111111-222222','HAN','HYERI','21/02/02','222222');

UPDATE TBL_OS
SET PR_ID = 'PR002'
WHERE OC_CD = 'A_WB001';


--○ 현재 테이블 데이터 목록
/*
TBL_PR
PR_ID	PR_SSN	        PR_FN	PR_LN	PR_DT	    PR_PW
PR001	121212-121212 	KIM	  HOJIN	21/01/01	121212
PR002	111111-222222 	HAN	  HYERI	21/02/02	222222

TBL_OS
OS_CD	OC_CD	SUB_CD	  PR_ID	BK_CD	RAT_CD	SUB_BD	SUB_ED
A_J001	A_SW001	J001	  PR001	B001	RT001	  21/02/01	21/03/01
A_O001	A_WB001	O001	  PR002	B002	RT001	  21/07/01	21/08/01
*/

--○ 뷰 생성
CREATE OR REPLACE VIEW VIEW_PR
AS
SELECT T.*
FROM
(
    SELECT ROWNUM "NUM", PR_ID "PR_ID", PR_SSN "PR_SSN", PR_FN "PR_FN", PR_LN "PR_LN", PR_DT "PR_DT", PR_PW "PR_PW"
    FROM TBL_PR
)T;


--○ 특정 교수의 전체 강의목록 조회
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
        FROM TBL_OS
        WHERE PR_ID = V_PR_ID;
        
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
        DBMS_OUTPUT.PUT_LINE('배정된 과목명 : ' || V_OS_CD  );
        DBMS_OUTPUT.PUT_LINE('과목 기간 : ' || V_SUB_BD || '~' || V_SUB_ED );
        DBMS_OUTPUT.PUT_LINE('교재명 : ' || V_BK_NM );
        DBMS_OUTPUT.PUT_LINE('강의실 : ' || V_CRS_RM );
        DBMS_OUTPUT.PUT_LINE('강의 진행 여부 : ' || V_ING );
        
        V_NUM := V_NUM+1;
        
        EXIT WHEN V_NUM > V_ROWNUM;
    END LOOP;
END;


--○ 실행 예시
EXEC PRC_PR_LOOKUP('PR001');
/*
1.
교수ID : PR001
배정된 과목명 : A_J001
과목 기간 : 21/02/01~21/03/01
교재명 : 자바의정석
강의실 : F강의실
강의 진행 여부 : 강의 종료
*/


--○ 전체 교수의 전체 강의목록 조회
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
        FROM VIEW_PR
        WHERE NUM = V_NUM;
        
        PRC_PR_LOOKUP(V_PR_ID);
        V_NUM := V_NUM + 1;
        
        EXIT WHEN V_NUM > V_ROWNUM;
    END LOOP;
END;


--○ 실행 예시
EXEC PRC_PR_LOOKUP_ADMIN;
/*
1.
교수ID : PR001
배정된 과목명 : A_J001
과목 기간 : 21/02/01~21/03/01
교재명 : 자바의정석
강의실 : F강의실
강의 진행 여부 : 강의 종료
1.
교수ID : PR002
배정된 과목명 : A_O001
과목 기간 : 21/07/01~21/08/01
교재명 : 오라클의정석
강의실 : E강의실
강의 진행 여부 : 강의 예정
*/


--------------------------------------------------------------------------------


--○ 성적 조회 뷰 생성 
CREATE OR REPLACE VIEW VIEW_SC
AS
SELECT T.*
FROM
(
    --수정
    SELECT ROWNUM "NUM", SC_CD "SC_CD", REG_CD "REG_CD", OS_CD "OS_CD"
         , SC_AT "SC_AT", SC_WT "SC_WT", SC_PT "SC_PT"
    FROM TBL_SC
)T; 


--○ 성적 조회 프로시저 작성 
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
    SELECT MAX(NUM) INTO V_ROWNUM
    FROM VIEW_SC;
    
    LOOP
        --추가
        SELECT REG_CD,OS_CD,SC_CD INTO V_REG_CD,V_OS_CD,V_SC_CD
        FROM VIEW_SC
        WHERE NUM = V_NUM;
        
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
        WHERE SUB_CD = V_SUB_CD;
        
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
        
        V_NUM := V_NUM+1;
        
        EXIT WHEN V_NUM > V_ROWNUM;
    END LOOP;
END;
