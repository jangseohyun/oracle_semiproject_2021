--����Ŭ ���� ������Ʈ
--3�� ��ƺ�, ������, �弭��, ������, ������


--�� ���̺� ����----------------------------------------------------------------


--�� 1-1. �����ڰ��� ���̺� ����
CREATE TABLE TBL_AD 
( AD_ID 	VARCHAR2(10)
, AD_PW 	VARCHAR2(10)	CONSTRAINT AD_PW_NN NOT NULL
, CONSTRAINT AD_ID_PK PRIMARY KEY(AD_ID)
);

--�� 1-2. �������� ���̺� ����
CREATE TABLE TBL_PR
( PR_ID     VARCHAR2(50)    
, PR_SSN    CHAR(14)       CONSTRAINT PR_SSN_NN NOT NULL
, PR_FN     VARCHAR2(50)    CONSTRAINT PR_FN_NN NOT NULL
, PR_LN     VARCHAR2(50)    CONSTRAINT PR_LN_NN NOT NULL
, PR_DT     DATE                DEFAULT SYSDATE
, PR_PW     VARCHAR2(10)   CONSTRAINT PR_PW_NN NOT NULL
, CONSTRAINT PR_ID_PK PRIMARY KEY (PR_ID)
);

--�� 1-3. �л����� ���̺� ����
CREATE TABLE TBL_ST
( ST_ID     VARCHAR2(50)   
, ST_SSN    CHAR(14)       CONSTRAINT ST_SSN_NN NOT NULL
, ST_FN     VARCHAR2(50)    CONSTRAINT ST_FN_NN NOT NULL
, ST_LN     VARCHAR2(50)    CONSTRAINT ST_LN_NN NOT NULL
, ST_DT     DATE           DEFAULT SYSDATE
, ST_PW     VARCHAR2(10)   CONSTRAINT ST_PW_NN NOT NULL
, CONSTRAINT ST_ID_PK PRIMARY KEY(ST_ID) 
);

--�� 1-4. ���� ���̺� ����
CREATE TABLE TBL_CRS
( CRS_CD    VARCHAR2(10)
, CRS_NM    VARCHAR2(100)    CONSTRAINT CRS_NM_NN NOT NULL
, CONSTRAINT CRS_CD_PK PRIMARY KEY(CRS_CD)
);

--�� 1-5. ���� ���̺� ����
CREATE TABLE TBL_SUB
( SUB_CD VARCHAR2(10)
, SUB_NM VARCHAR2(100) CONSTRAINT SUB_NM_NN NOT NULL
, CONSTRAINT SUB_CD_PK PRIMARY KEY(SUB_CD)
);

--�� 1-6. ���� ���̺� ����
CREATE TABLE TBL_RAT
( RAT_CD    VARCHAR2(10)
, RAT_AT    NUMBER(3)       CONSTRAINT RAT_AT_NN NOT NULL
, RAT_WT    NUMBER(3)       CONSTRAINT RAT_WT_NN NOT NULL
, RAT_PT    NUMBER(3)       CONSTRAINT RAT_PT_NN NOT NULL
, CONSTRAINT RAT_CD_PK PRIMARY KEY(RAT_CD)
);

--�� 1-7. ���� ���̺� ����
CREATE TABLE TBL_BK
( BK_CD VARCHAR2(10)
, BK_NM VARCHAR2(100) CONSTRAINT BK_NM_NN  NOT NULL
, CONSTRAINT BK_CD_PK PRIMARY KEY(BK_CD)
);


--�� 2. �������� ���̺� ����
CREATE TABLE TBL_OC
( OC_CD     VARCHAR2(10)
, CRS_CD    VARCHAR2(10)    CONSTRAINT OC_CRS_CD_NN NOT NULL
, CRS_BD    DATE            CONSTRAINT OC_CRS_BD_NN NOT NULL
, CRS_ED    DATE            CONSTRAINT OC_CRS_ED_NN NOT NULL
, CRS_RM    VARCHAR2(10)    CONSTRAINT OC_CRS_RM_NN NOT NULL
, CONSTRAINT OC_CD_PK PRIMARY KEY (OC_CD)
, CONSTRAINT OC_CRS_CD_FK FOREIGN KEY(CRS_CD)
             REFERENCES TBL_CRS(CRS_CD)
, CONSTRAINT OC_CRS_ED_CK CHECK(CRS_ED > CRS_BD)
);


--�� 3-1. ���񰳼� ���̺� ����
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
, CONSTRAINT OS_OC_CD_FK    FOREIGN KEY(OC_CD)  REFERENCES TBL_OC(OC_CD)
, CONSTRAINT OS_SUB_CD_FK   FOREIGN KEY(SUB_CD) REFERENCES TBL_SUB(SUB_CD)
, CONSTRAINT OS_PR_ID_FK    FOREIGN KEY(PR_ID)  REFERENCES TBL_PR(PR_ID)
, CONSTRAINT OS_BK_CD_FK    FOREIGN KEY(BK_CD)  REFERENCES TBL_BK(BK_CD)
, CONSTRAINT OS_RAT_CD_FK   FOREIGN KEY(RAT_CD) REFERENCES TBL_RAT(RAT_CD)
, CONSTRAINT SUB_ED_CK      CHECK(SUB_ED>=SUB_BD)
);

--�� 3-2. ������û ���̺� ����
CREATE TABLE TBL_REG
( REG_CD    VARCHAR2(10)
, ST_ID     VARCHAR2(10)    CONSTRAINT REG_ST_ID_NN NOT NULL
, OC_CD     VARCHAR2(10)    CONSTRAINT REG_OC_CD_NN NOT NULL
, REG_DT    DATE    DEFAULT SYSDATE    
, CONSTRAINT REG_CD_PK PRIMARY KEY(REG_CD)
, CONSTRAINT REG_ST_ID_FK  FOREIGN KEY(ST_ID)
             REFERENCES TBL_ST(ST_ID)
, CONSTRAINT REG_OC_CD_FK  FOREIGN KEY(OC_CD)
             REFERENCES TBL_OC(OC_CD)
);


--�� 4-1. ���� ���̺� ����
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
, CONSTRAINT SC_OS_CD_FK FOREIGN KEY(OS_CD)
            REFERENCES TBL_OS(OS_CD)
);

--�� 4-2. �ߵ�Ż�� ���̺� ����
CREATE TABLE TBL_QT
( QT_CD 	VARCHAR2(10)
, REG_CD 	VARCHAR2(10)	CONSTRAINT QT_REG_CD_NN NOT NULL
, QT_DT		DATE		    DEFAULT SYSDATE
, CONSTRAINT QT_CD_PK PRIMARY KEY(QT_CD)
, CONSTRAINT QT_REG_CD_FK FOREIGN KEY(REG_CD)
			  REFERENCES TBL_REG(REG_CD)
);


--------------------------------------------------------------------------------


--�� Ȯ��
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



--�� �Է� ���ν��� ����---------------------------------------------------------


--�� ���� �Է� ���ν���

--������ ����
CREATE SEQUENCE SEQ_PRCODE
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCACHE;
--==>> Sequence SEQ_PRCODE��(��) �����Ǿ����ϴ�.

--���ν��� ����
CREATE OR REPLACE PROCEDURE PRC_PR_INSERT
( VPR_SSN    IN TBL_PR.PR_SSN%TYPE
, VPR_FN     IN TBL_PR.PR_FN%TYPE
, VPR_LN     IN TBL_PR.PR_LN%TYPE
, VPR_DT     IN TBL_PR.PR_DT%TYPE    DEFAULT SYSDATE
)
IS
    -- ���� ����
    VPR_ID  TBL_PR.PR_ID%TYPE;
    VPR_PW  TBL_PR.PR_PW%TYPE;
BEGIN
    -- VPR_PW ���� (���� ��й�ȣ)
    VPR_PW := SUBSTR(VPR_SSN,8);
    
    -- VPR_ID ���� (����ID)
    VPR_ID := 'PR' || LPAD(SEQ_PRCODE.NEXTVAL,3,'0');     

    -- ���� ���� INSERT ������
    INSERT INTO TBL_PR(PR_ID, PR_SSN, PR_FN, PR_LN, PR_PW, PR_DT)
        VALUES(VPR_ID, VPR_SSN, VPR_FN, VPR_LN, VPR_PW, VPR_DT);
END;
--==>> Procedure PRC_PR_INSERT��(��) �����ϵǾ����ϴ�.


--�� �л� �Է� ���ν���

--������ ���� 
CREATE SEQUENCE SEQ_ST_CODE
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCACHE;

--���ν��� ����
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
        -- �л� ���̵� ���� 
        V_ST_ID := 'ST' || LPAD(SEQ_ST_CODE.NEXTVAL,3,'0');     
        V_ST_PW := SUBSTR(V_ST_SSN,8);   
         -- ���̺� ������ �Է� 
        INSERT INTO TBL_ST(ST_ID, ST_SSN, ST_FN, ST_LN, ST_PW)
        VALUES (V_ST_ID, V_ST_SSN, V_ST_FN, V_ST_LN, V_ST_PW);
        
    ELSE RAISE DUPLICATE_ERROR;
    END IF;
    
    COMMIT;
    
    EXCEPTION
        WHEN DUPLICATE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20001,'�̹� �����ϴ� �������Դϴ�.');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==>> Procedure PRC_ST_INSERT��(��) �����ϵǾ����ϴ�.


--�� ���� �Է� ���ν��� ����

--������ ����
CREATE SEQUENCE SEQ_CRS
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCACHE;
--==>> Sequence SEQ_CRS��(��) �����Ǿ����ϴ�.

--���ν��� ����
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
    --������ �ߺ� ���� Ȯ��
    SELECT COUNT(*) INTO V_COUNT
    FROM TBL_CRS
    WHERE CRS_NM = V_CRS_NM;
    
    --�ߺ��� ���� �߻�
    IF V_COUNT >= 1
        THEN RAISE DUPLICATE_ERROR;
    END IF;
    
    --ù �� ���ڰ� ���ĺ� �빮�� �� �������� Ȯ��
    V_CD_ASCII := TO_NUMBER(ASCII(SUBSTR(V_CRS_NM,1,1))) + TO_NUMBER(ASCII(SUBSTR(V_CRS_NM,2,1)));
    
    IF (V_CD_ASCII >= 130 AND V_CD_ASCII <= 180)
        THEN
            V_CRS_CD := SUBSTR(V_CRS_NM,1,2) || LPAD(SEQ_CRS.NEXTVAL,3,'0');
            INSERT INTO TBL_CRS(CRS_CD, CRS_NM) VALUES (V_CRS_CD, V_CRS_NM);
    ELSE
        RAISE CREATE_CODE_ERROR;
    END IF;
    
    -- Ŀ��
    COMMIT;
    
    EXCEPTION
        WHEN DUPLICATE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20001, '�̹� �����ϴ� �������Դϴ�.');
                 ROLLBACK;
        WHEN CREATE_CODE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20007,'��ȿ���� ���� �������Դϴ�.');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==>> Procedure PRC_CRS_INSERT��(��) �����ϵǾ����ϴ�.


--�� ���� �Է� ���ν���

--������ ����
CREATE SEQUENCE SEQ_SUB_CODE
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCACHE;
--==>> Sequence SEQ_SUB_CODE��(��) �����Ǿ����ϴ�.

--���ν��� ����
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

    --������ �����ڵ��� �ִ��� üũ
    SELECT COUNT(*) INTO V_COUNT
    FROM TBL_SUB
    WHERE SUB_CD = V_SUB_CD;
      
    --ù �� ���ڰ� ���ĺ� �빮�� �� �������� Ȯ��
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
             THEN RAISE_APPLICATION_ERROR(-20001, '�̹� �����ϴ� �������Դϴ�.');
             ROLLBACK;
        WHEN CREATE_CODE_ERROR
             THEN RAISE_APPLICATION_ERROR(-20004, '������� ���� �빮�ڷ� �Է��ϼ���.');
        WHEN OTHERS
             THEN ROLLBACK;
END;
--==>> Procedure PRC_SUB_INSERT��(��) �����ϵǾ����ϴ�.


--�� ���� �Է� ���ν���

-- ������ ����
CREATE SEQUENCE SEQ_RAT
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCACHE;
--==> Sequence SEQ_RAT��(��) �����Ǿ����ϴ�.

--���ν��� ����
CREATE OR REPLACE PROCEDURE PRC_RAT_INSERT
( V_RAT_AT      TBL_RAT.RAT_AT%TYPE
, V_RAT_WT      TBL_RAT.RAT_WT%TYPE
, V_RAT_PT      TBL_RAT.RAT_PT%TYPE
)
IS
    V_RAT_CD    TBL_RAT.RAT_CD%TYPE;
    PROPORTION_ERROR    EXCEPTION;
BEGIN
    -- �����ڵ� ����
    V_RAT_CD := 'RT' || LPAD(SEQ_RAT.NEXTVAL,3,'0');
    
    -- ��ü ������ 100�� ���� ���� ��� INSERT
    IF ( (V_RAT_AT + V_RAT_WT + V_RAT_PT) = 100 )
         THEN INSERT INTO TBL_RAT (RAT_CD, RAT_AT, RAT_WT, RAT_PT) 
              VALUES (V_RAT_CD,V_RAT_AT, V_RAT_WT, V_RAT_PT);
    -- ������ ���� ���� �߻�
    ELSE RAISE PROPORTION_ERROR;
    END IF;
    
    -- Ŀ��
    COMMIT;
    
    -- ���� ó��
    EXCEPTION
        WHEN PROPORTION_ERROR
            THEN RAISE_APPLICATION_ERROR(-20006, '�� ������ 100�� ���� �����Դϴ�.');
                ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==> Procedure PRC_RAT_INSERT��(��) �����ϵǾ����ϴ�.


--�� ���� �Է� ���ν���

--������ ����
CREATE SEQUENCE SEQ_BK_CODE
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCACHE;
--==>> Sequence SEQ_BK_CODE��(��) �����Ǿ����ϴ�.

--���ν��� ����
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
             THEN RAISE_APPLICATION_ERROR(-20001, '�̹� �����ϴ� �������Դϴ�.');
             ROLLBACK;
        WHEN OTHERS
             THEN ROLLBACK;
END;
--==>> Procedure PRC_BK_INSERT��(��) �����ϵǾ����ϴ�.


--�� �������� �Է� ���ν���

-- ������ ����
CREATE SEQUENCE SEQ_OC
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCACHE;
--==>> Sequence SEQ_OC��(��) �����Ǿ����ϴ�.

--���ν��� ����
CREATE OR REPLACE PROCEDURE PRC_OC_INSERT
( VCRS_CD   IN TBL_OC.CRS_CD%TYPE
, VCRS_BD   IN TBL_OC.CRS_BD%TYPE
, VCRS_ED   IN TBL_OC.CRS_ED%TYPE
, VCRS_RM   IN TBL_OC.CRS_RM%TYPE
)
IS
    -- �ֿ� ���� ����
    VOC_CD  TBL_OC.OC_CD%TYPE;      
    VCRS_NM TBL_CRS.CRS_NM%TYPE;    
    
    -- ���� ���� ���� (��¥)
    OC_DATE_ERROR   EXCEPTION;   
BEGIN
    -- ���� �߻�
    IF (TO_NUMBER(VCRS_ED - VCRS_BD) < 0)
        THEN RAISE OC_DATE_ERROR;
    END IF;
    
    -- ������ ã�� VCRS_NM
    SELECT CRS_NM INTO VCRS_NM
    FROM TBL_CRS
    WHERE CRS_CD = VCRS_CD;
    
    -- VOC_CD �������� �ڵ�
    VOC_CD := TO_CHAR('A' || '_' || SUBSTR(VCRS_NM,1,2) || LPAD(SEQ_OC.NEXTVAL,3,'0'));
    
    INSERT INTO TBL_OC(OC_CD, CRS_CD, CRS_BD, CRS_ED, CRS_RM)
    VALUES(VOC_CD ,VCRS_CD, VCRS_BD, VCRS_ED, VCRS_RM);
 
    COMMIT;
    
    EXCEPTION
        WHEN OC_DATE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20005, '��ȿ���� ���� ��¥�Դϴ�');
                 ROLLBACK;
        WHEN OTHERS THEN ROLLBACK;
END;




--�� ���񰳼� �Է� ���ν���

CREATE OR REPLACE PROCEDURE PRC_OS_INSERT
(
    V_OC_CD     IN  TBL_OC.OC_CD%TYPE   -- ������
,   V_SUB_CD    IN  TBL_SUB.SUB_CD%TYPE -- �����
,   V_PR_ID     IN  TBL_PR.PR_ID%TYPE   -- ������ ��
,   V_BK_CD     IN  TBL_BK.BK_CD%TYPE   -- �����
,   V_RAT_CD    IN  TBL_RAT.RAT_CD%TYPE -- ����
,   V_SUB_BD    IN  TBL_OS.SUB_BD%TYPE  -- ������۳�¥ (NULL ����)
,   V_SUB_ED    IN  TBL_OS.SUB_ED%TYPE  -- �������ᳯ¥ (NULL ����)
)
IS

    TEMP                         TBL_OS.OS_CD%TYPE;
    V_OS_CD                      TBL_OS.OS_CD%TYPE;
    V_COUNT                      NUMBER; -- �������� �ߺ� üũ
    V_COUNT1                     NUMBER; -- FK1 ���������ڵ� üũ
    V_COUNT2                     NUMBER; -- FK2 �����ڵ� üũ  
    V_COUNT3                     NUMBER; -- FK3 �������̵� üũ
    V_COUNT4                     NUMBER; -- FK4 �����ڵ� üũ
    V_COUNT5                     NUMBER; -- FK5 �����ڵ� üũ
    
    ALREADY_REGISTERED_ERROR    EXCEPTION; -- �ߺ�������
    
BEGIN
    
    -- ���� ���̺��� �����ڵ带 ��Ƽ� EX) J001
    SELECT SUB_CD INTO TEMP
    FROM TBL_SUB
    WHERE SUB_CD = V_SUB_CD;

    -- �տ� E �� �ٿ��� ���񰳼� ���̺��� ���������ڵ�� ����� EX) EJ001
    V_OS_CD := 'E' || TEMP;

    --������ ���������ڵ��� �ִ��� üũ = 0
    SELECT COUNT(*) INTO V_COUNT
    FROM TBL_OS
    WHERE OS_CD = V_OS_CD;

    --FK1 ���������ڵ� üũ = 1
    SELECT COUNT(*) INTO V_COUNT1
    FROM TBL_OC
    WHERE OC_CD = V_OC_CD;

    --FK2 �����ڵ� üũ
    SELECT COUNT(*) INTO V_COUNT2
    FROM TBL_SUB
    WHERE SUB_CD = V_SUB_CD;
    
    --FK3 �������̵� üũ
    SELECT COUNT(*) INTO V_COUNT3
    FROM TBL_PR
    WHERE PR_ID = V_PR_ID;
    
    --FK4 ����� üũ
    SELECT COUNT(*) INTO V_COUNT4
    FROM TBL_BK
    WHERE BK_CD = V_BK_CD;
    
    --FK5 �����ڵ� üũ
    SELECT COUNT(*) INTO V_COUNT5
    FROM TBL_RAT
    WHERE RAT_CD = V_RAT_CD;
    
    
    IF ((V_COUNT = 0) AND (V_COUNT1 = 1) AND (V_COUNT2 = 1) AND (V_COUNT3 = 1) AND (V_COUNT4 = 1) AND (V_COUNT5 = 1))
        THEN
            INSERT INTO TBL_OS(OS_CD, OC_CD, SUB_CD, PR_ID, BK_CD, RAT_CD, SUB_BD, SUB_ED) 
            VALUES(V_OS_CD, V_OC_CD, V_SUB_CD, V_PR_ID, V_BK_CD, V_RAT_CD, V_SUB_BD, V_SUB_ED);
    ELSIF (V_COUNT > 0)
        THEN RAISE ALREADY_REGISTERED_ERROR;
    END IF; 
    
    COMMIT;
     
    EXCEPTION
        WHEN ALREADY_REGISTERED_ERROR
             THEN RAISE_APPLICATION_ERROR(-20001, '�̹� �����ϴ� �������Դϴ�.');
END;


--�� �������� �Է� ���ν���

-- ������ ����
CREATE SEQUENCE SEQ_REG
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCACHE;
--==> Sequence SEQ_REG��(��) �����Ǿ����ϴ�.

--���ν��� ����
CREATE OR REPLACE PROCEDURE PRC_REG_INSERT
( V_ST_ID   TBL_ST.ST_ID%TYPE   -- �л� ���̵�
, V_OC_CD   TBL_OC.OC_CD%TYPE   -- �������� �ڵ�
, V_REG_DT  TBL_REG.REG_DT%TYPE  DEFAULT SYSDATE
)
IS
    V_REG_CD    TBL_REG.REG_CD%TYPE; --�������� �ڵ�
    V_COUNT_ID     NUMBER;
    V_COUNT_CD     NUMBER;
    INCORRECT_ERROR  EXCEPTION;
BEGIN
    SELECT COUNT(*) INTO V_COUNT_ID -- �л����̵� ��ġ�ϸ�
    FROM TBL_ST
    WHERE V_ST_ID = ST_ID;
    
    
    SELECT COUNT(*) INTO V_COUNT_CD -- ���������ڵ尡 ��ġ�ϸ�
    FROM TBL_OC
    WHERE V_OC_CD = OC_CD;
    
    IF ( (V_COUNT_ID = 1) AND (V_COUNT_CD = 1) )
        THEN
            -- ���������ڵ� ����
            V_REG_CD := 'RG' || LPAD(SEQ_REG.NEXTVAL,3,'0');
            
            -- TBL_REG ���̺� ������ �Է�
            INSERT INTO TBL_REG(REG_CD, ST_ID, OC_CD, REG_DT) 
            VALUES (V_REG_CD, V_ST_ID, V_OC_CD, V_REG_DT);
        
        -- �л����̵� ���������ڵ尡 ���� ��� ���� �߻�
        ELSE RAISE INCORRECT_ERROR;
    END IF;
        
    -- Ŀ��
    COMMIT;

    -- ����ó��
    EXCEPTION
        WHEN INCORRECT_ERROR
            THEN RAISE_APPLICATION_ERROR(-20004, '���̵� ���������ڵ尡 ��ġ���� �ʽ��ϴ�.');
                ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;


--�� ���� �Է� ���ν���

-- ������ ���� 
CREATE SEQUENCE SEQ_SC_CODE
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCACHE;
--==> Sequence SEQ_SC_CODE��(��) �����Ǿ����ϴ�.

-- ���ν��� ����
CREATE OR REPLACE PROCEDURE PRC_SC_INSERT
(
    V_REG_CD    IN TBL_REG.REG_CD%TYPE          -- ������û �ڵ� 
,   V_OS_CD     IN TBL_OS.OS_CD%TYPE            -- �������� �ڵ� 
,   V_SC_AT     IN TBL_SC.SC_AT%TYPE            -- ��� 
,   V_SC_WT     IN TBL_SC.SC_WT%TYPE            -- �ʱ� 
,   V_SC_PT     IN TBL_SC.SC_PT%TYPE            -- �Ǳ� 
)
IS
    V_SC_CD             TBL_SC.SC_CD%TYPE;      -- ���� �ڵ� 
    V_COUNT_RCD         NUMBER;                 -- ����ó���� ������û�ڵ�1
    V_COUNT_OCD         NUMBER;                 -- ����ó���� ���������ڵ�1
    V_COUNT_REG         NUMBER;                 -- ����ó���� ������û�ڵ�2
    V_COUNT_OS          NUMBER;                 -- ����ó���� ���������ڵ�2
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
    
    -- �ߵ�Ż���� �л��� ��
    SELECT COUNT(*) INTO V_COUNT_QT
    FROM TBL_QT
    WHERE REG_CD = V_REG_CD;
    
    IF V_COUNT_QT > 0
        THEN RAISE QUIT_STUDENT_ERROR;
    END IF;
    
    IF ((V_COUNT_RCD = 1) AND (V_COUNT_OCD = 1))
        THEN V_SC_CD := 'SC' || LPAD(SEQ_SC_CODE.NEXTVAL,3,'0'); 
    -- ��Ȯ���� ���� �ڵ� �Է����� �� 
    ELSE RAISE INCORRECT_ERROR;
    END IF;
    
    -- �̹� �Է��� �����϶� 
    IF V_COUNT_REG > 0
        THEN RAISE DUPLICATE_ERROR;
    END IF;
    
    IF (V_SC_AT + V_SC_WT + V_SC_PT) > 100
            THEN RAISE TOTAL_SC_ERROR;
    END IF;
        
    -- ���̺� ������ �Է� 
    INSERT INTO TBL_SC(SC_CD, REG_CD, OS_CD, SC_AT, SC_WT, SC_PT)
    VALUES (V_SC_CD, V_REG_CD, V_OS_CD, V_SC_AT, V_SC_WT, V_SC_PT);
        
    V_SC_TOT := V_SC_AT + V_SC_WT + V_SC_PT;
    DBMS_OUTPUT.PUT_LINE('���� : ' || V_SC_TOT);    
    
    COMMIT;
    
    EXCEPTION
        WHEN INCORRECT_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002,'�������� �ʴ� �������Դϴ�.');
                 ROLLBACK;
        WHEN TOTAL_SC_ERROR
            THEN RAISE_APPLICATION_ERROR(-20003,'���� ������ ����Ͽ� �Է��Ͽ� �ֽʽÿ�.');   
                 ROLLBACK;         
        WHEN QUIT_STUDENT_ERROR
            THEN RAISE_APPLICATION_ERROR(-20008,'�ߵ�Ż���� �л��Դϴ�.');
                 ROLLBACK;
        WHEN DUPLICATE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20001, '�̹� �����ϴ� �������Դϴ�.');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==> Procedure PRC_SC_INSERT��(��) �����ϵǾ����ϴ�.


--�� �ߵ�Ż�� �Է� ���ν���

--������ ����
CREATE SEQUENCE SEQ_QUIT
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCACHE;

--���ν��� ����
CREATE OR REPLACE PROCEDURE PRC_QUIT_INSERT
(   V_REG_CD    IN TBL_QT.REG_CD%TYPE
,   V_QT_DT     IN TBL_QT.QT_DT%TYPE   DEFAULT SYSDATE
)
IS
    V_QT_CD             VARCHAR2(10);
    V_COUNT             NUMBER;
    DUPLICATE_ERROR     EXCEPTION;
BEGIN
    --������û�ڵ� �ߺ� ���� Ȯ��
    SELECT COUNT(*) INTO V_COUNT
    FROM TBL_QT
    WHERE REG_CD = V_REG_CD;
    
    --�ߺ��� �ƴ� ��� ������ �Է�
    IF V_COUNT = 0
        THEN
            --�ߵ�Ż���ڵ� ����
            V_QT_CD := 'Q' || LPAD(SEQ_QUIT.NEXTVAL,3,'0');
            --TBL_REG ���̺� ������ �Է�
            INSERT INTO TBL_QT(QT_CD,REG_CD) VALUES(V_QT_CD,V_REG_CD);
    --�ߺ��� ��� ���� �߻�
    ELSE RAISE DUPLICATE_ERROR;
    END IF;
    
    --Ŀ��
    COMMIT;
    
    --����ó��
    EXCEPTION
        WHEN DUPLICATE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20001,'�̹� �����ϴ� �������Դϴ�.');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;



--�� ������ �Է�----------------------------------------------------------------


INSERT INTO TBL_AD(AD_ID, AD_PW) VALUES('ADMIN','ADMIN');

SELECT *
FROM TBL_AD;
/*
AD_ID	AD_PW
ADMIN	ADMIN
*/

EXEC PRC_PR_INSERT('750416-1234567', '��', 'ȣ��', '21/01/01');
EXEC PRC_PR_INSERT('971006-2234567', '��', '����', '21/02/01');

SELECT *
FROM TBL_PR;
/*
PR_ID	PR_SSN	        PR_FN	PR_LN	PR_DT	    PR_PW
PR001	750416-1234567	��	    ȣ��	21/01/01	1234567
PR002	971006-2234567	��	    ����	21/04/01	2234567
*/

EXEC PRC_ST_INSERT('930308-2000001', '��', '�ƺ�', '21/01/30');
EXEC PRC_ST_INSERT('951102-2000002', '��', '����', '21/01/19');
EXEC PRC_ST_INSERT('971224-2000003', '��', '����', '21/01/27');
EXEC PRC_ST_INSERT('980709-2000004', '��', '����', '21/01/28');

SELECT *
FROM TBL_ST;
/*
ST_ID	ST_SSN	        ST_FN	ST_LN	ST_DT	    ST_PW
ST001	930308-2000001	��	    �ƺ�	21/01/30	2000001
ST002	951102-2000002	��	    ����	21/01/19	2000002
ST003	971224-2000003	��	    ����	21/01/27	2000003
ST004	980709-2000004	��	    ����	21/01/28	2000004
*/

EXEC PRC_CRS_INSERT('FS �ڹ�(JAVA)�� Ȱ���� Ǯ���� ���� SW������ �缺����');

SELECT *
FROM TBL_CRS;
/*
CRS_CD	CRS_NM
FS001	FS �ڹ�(JAVA)�� Ȱ���� Ǯ���� ���� SW������ �缺����
*/

EXEC PRC_SUB_INSERT('J �ڹ� ���α׷���');
EXEC PRC_SUB_INSERT('O �����ͺ��̽� ���α׷���(����Ŭ)');

SELECT *
FROM TBL_SUB;
/*
SUB_CD	SUB_NM
J001	J �ڹ� ���α׷���
O002	O �����ͺ��̽� ���α׷���(����Ŭ)
*/

EXEC PRC_RAT_INSERT(30,20,50);

SELECT *
FROM TBL_RAT;
/*
RAT_CD	RAT_AT	RAT_WT	RAT_PT
RT001	30	    20	    50
*/

EXEC PRC_BK_INSERT('Java�� ����');
EXEC PRC_BK_INSERT('����Ŭ SQL�� PL/SQL');

SELECT *
FROM TBL_BK;
/*
BK_CD	BK_NM
B001	Java�� ����
B002	����Ŭ SQL�� PL/SQL
*/

EXEC PRC_OC_INSERT('FS001','21/02/01','21/07/12','F���ǽ�');

SELECT *
FROM TBL_OC;
/*
OC_CD	CRS_CD	CRS_BD	    CRS_ED	    CRS_RM
A_FS001	FS001	21/02/01	21/07/12	F���ǽ�
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
--==>> ���� : 92
EXEC PRC_SC_INSERT('RG002', 'EJ001', 28, 18, 50);
--==>> ���� : 96
EXEC PRC_SC_INSERT('RG003', 'EJ001', 28, 16, 42);
--==>> ���� : 86
EXEC PRC_SC_INSERT('RG004', 'EJ001', 30, 20, 48);
--==>> ���� : 98

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