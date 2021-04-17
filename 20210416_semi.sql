--�� ���񰳼� ��ȸ ���ν����� VIEW ����
CREATE OR REPLACE VIEW VIEW_OS
AS
SELECT T.*
FROM
(
    SELECT ROWNUM "NUM", OS_CD "OS_CD", OC_CD "OC_CD", SUB_CD "SUB_CD", PR_ID "PR_ID"
          ,BK_CD "BK_CD", RAT_CD "RAT_CD", SUB_BD "SUB_BD", SUB_ED "SUB_ED"
    FROM TBL_OS
)T;


--�� ���񰳼� ��ü ��ȸ ���ν��� ����
CREATE OR REPLACE PROCEDURE PRC_OS_LOOKUP
IS
    V_CRS_NM    TBL_CRS.CRS_NM%TYPE;    --������
    V_CRS_RM    TBL_OC.CRS_RM%TYPE;     --���ǽ�
    V_SUB_NM    TBL_SUB.SUB_NM%TYPE;    --�����
    V_SUB_BD    TBL_OS.SUB_BD%TYPE;     --�������
    V_SUB_ED    TBL_OS.SUB_ED%TYPE;     --��������
    V_BK_NM     TBL_BK.BK_NM%TYPE;      --�����
    V_PR_FN     TBL_PR.PR_FN%TYPE;      --������
    V_PR_LN     TBL_PR.PR_LN%TYPE;      --�����̸�
    
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
        DBMS_OUTPUT.PUT_LINE('������: ' || V_CRS_NM);
        DBMS_OUTPUT.PUT_LINE('���ǽ�: ' || V_CRS_RM);
        DBMS_OUTPUT.PUT_LINE('�����: ' || V_SUB_NM);
        DBMS_OUTPUT.PUT_LINE('����Ⱓ: ' || V_SUB_BD || ' ~ ' || V_SUB_ED);
        DBMS_OUTPUT.PUT_LINE('�����: ' || V_BK_NM);
        DBMS_OUTPUT.PUT_LINE('������: ' || V_PR_FN || ' ' || V_PR_LN);
        
        V_NUM := V_NUM+1;
        
        EXIT WHEN V_NUM > V_ROWNUM;
    END LOOP;
END;


--�� �׽�Ʈ�� ������ �Է�
INSERT INTO TBL_OS(OS_CD,OC_CD,SUB_CD,PR_ID,BK_CD,RAT_CD,SUB_BD,SUB_ED)
VALUES('A_J001','A_SW001','J001','PR001','B001','RT001','21/02/01','21/03/01');
INSERT INTO TBL_OS(OS_CD,OC_CD,SUB_CD,PR_ID,BK_CD,RAT_CD,SUB_BD,SUB_ED)
VALUES('A_O001','A_WB001','O001','PR001','B002','RT001','21/07/01','21/08/01');

INSERT INTO TBL_OC(OC_CD,CRS_CD,CRS_BD,CRS_ED,CRS_RM)
VALUES('A_SW001','SW001','21/04/01','21/05/01','F���ǽ�');
INSERT INTO TBL_OC(OC_CD,CRS_CD,CRS_BD,CRS_ED,CRS_RM)
VALUES('A_O001','WB001','21/05/01','21/06/01','E���ǽ�');

INSERT INTO TBL_CRS(CRS_CD,CRS_NM) VALUES('SW001','SW����Ʈ����');
INSERT INTO TBL_CRS(CRS_CD,CRS_NM) VALUES('WB001','WB������');

INSERT INTO TBL_SUB(SUB_CD,SUB_NM) VALUES('J001','�ڹ�');
INSERT INTO TBL_SUB(SUB_CD,SUB_NM) VALUES('O001','����Ŭ');

INSERT INTO TBL_PR(PR_ID,PR_SSN,PR_FN,PR_LN,PR_DT,PR_PW)
VALUES('PR001','121212-121212','KIM','HOJIN','21/01/01','121212');

INSERT INTO TBL_BK(BK_CD,BK_NM) VALUES('B001','�ڹ�������');
INSERT INTO TBL_BK(BK_CD,BK_NM) VALUES('B002','����Ŭ������');


--�� ������ �Է� �� VIEW Ȯ��
/*
NUM	OS_CD	  OC_CD	  SUB_CD	PR_ID	BK_CD	RAT_CD	SUB_BD	  SUB_ED
1	  A_J001	A_SW001	J001	  PR001	B001	RT001	  21/02/01	21/03/01
2	  A_O001	A_WB001	O001	  PR001	B002	RT001	  21/07/01	21/08/01
*/


--�� ���� ����
EXEC PRC_OS_LOOKUP;
/*
1.
������: SW����Ʈ����
���ǽ�: F���ǽ�
�����: �ڹ�
����Ⱓ: 21/02/01 ~ 21/03/01
�����: �ڹ�������
������: KIM HOJIN
2.
������: WB������
���ǽ�: E���ǽ�
�����: ����Ŭ
����Ⱓ: 21/07/01 ~ 21/08/01
�����: ����Ŭ������
������: KIM HOJIN
*/


--------------------------------------------------------------------------------


--�� ���� �Է� ���ν����� SEQUENCE ����
CREATE SEQUENCE SEQ_CRS
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCACHE;


--�� ���� �Է� ���ν��� ����
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


--�� ���� ����
EXEC PRC_CRS_INSERT('FE����Ʈ����');
/*
CRS_CD	CRS_NM
FE001	  FE����Ʈ����
*/
EXEC PRC_CRS_INSERT('FE����Ʈ����');
--==>> ORA-20001: �̹� �����ϴ� �������Դϴ�.

EXEC PRC_CRS_INSERT('BE�鿣��');
/*
CRS_CD	CRS_NM
FE001	  FE����Ʈ����
BE002	  BE�鿣��
*/

EXEC PRC_CRS_INSERT('Ǯ����');
--==>> ORA-20007: ��ȿ���� ���� �������Դϴ�.


--------------------------------------------------------------------------------


--�� �׽�Ʈ�� ������ �Է� �� ����
INSERT INTO TBL_PR(PR_ID,PR_SSN,PR_FN,PR_LN,PR_DT,PR_PW)
VALUES('PR002','111111-222222','HAN','HYERI','21/02/02','222222');

UPDATE TBL_OS
SET PR_ID = 'PR002'
WHERE OC_CD = 'A_WB001';


--�� ���� ���̺� ������ ���
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

--�� �� ����
CREATE OR REPLACE VIEW VIEW_PR
AS
SELECT T.*
FROM
(
    SELECT ROWNUM "NUM", PR_ID "PR_ID", PR_SSN "PR_SSN", PR_FN "PR_FN", PR_LN "PR_LN", PR_DT "PR_DT", PR_PW "PR_PW"
    FROM TBL_PR
)T;


--�� Ư�� ������ ��ü ���Ǹ�� ��ȸ
CREATE OR REPLACE PROCEDURE PRC_PR_LOOKUP
(
    V_PR_ID      IN TBL_PR.PR_ID%TYPE   -- �������̵�
)
IS
    V_SUB_NM     TBL_SUB.SUB_NM%TYPE; -- ������ �����
    V_SUB_BD     TBL_OS.SUB_BD%TYPE;  -- ���� ������
    V_SUB_ED     TBL_OS.SUB_ED%TYPE;  -- ���� ������
    V_BK_CD      TBL_BK.BK_CD%TYPE;   -- �����ڵ�
    V_BK_NM      TBL_BK.BK_NM%TYPE;   -- �����
    V_OC_CD      TBL_OC.OC_CD%TYPE;   -- ���ǽ��ڵ�
    V_CRS_RM     TBL_OC.CRS_RM%TYPE;  -- ���ǽ�
    
    V_OS_CD      TBL_OS.OS_CD%TYPE;
    V_SUB_CD     TBL_SUB.SUB_CD%TYPE;
    
    V_ING        VARCHAR(50);         -- ���� ���� ����
    V_DATE1      NUMBER;              -- ��¥ ���� ����
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
            THEN V_ING := '���� ��';
        ELSIF (V_DATE1 < 0 AND V_DATE2 < 0) 
            THEN V_ING := '���� ����';
        ELSIF (V_DATE1 > 0 AND V_DATE2 > 0)
            THEN V_ING := '���� ����';
        ELSE V_ING := 'Ȯ�κҰ�';
        END IF;
        
        -- ���� ���� ���        
        DBMS_OUTPUT.PUT_LINE(V_NUM || '.');
        DBMS_OUTPUT.PUT_LINE('����ID : ' || V_PR_ID);
        DBMS_OUTPUT.PUT_LINE('������ ����� : ' || V_OS_CD  );
        DBMS_OUTPUT.PUT_LINE('���� �Ⱓ : ' || V_SUB_BD || '~' || V_SUB_ED );
        DBMS_OUTPUT.PUT_LINE('����� : ' || V_BK_NM );
        DBMS_OUTPUT.PUT_LINE('���ǽ� : ' || V_CRS_RM );
        DBMS_OUTPUT.PUT_LINE('���� ���� ���� : ' || V_ING );
        
        V_NUM := V_NUM+1;
        
        EXIT WHEN V_NUM > V_ROWNUM;
    END LOOP;
END;


--�� ���� ����
EXEC PRC_PR_LOOKUP('PR001');
/*
1.
����ID : PR001
������ ����� : A_J001
���� �Ⱓ : 21/02/01~21/03/01
����� : �ڹ�������
���ǽ� : F���ǽ�
���� ���� ���� : ���� ����
*/


--�� ��ü ������ ��ü ���Ǹ�� ��ȸ
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


--�� ���� ����
EXEC PRC_PR_LOOKUP_ADMIN;
/*
1.
����ID : PR001
������ ����� : A_J001
���� �Ⱓ : 21/02/01~21/03/01
����� : �ڹ�������
���ǽ� : F���ǽ�
���� ���� ���� : ���� ����
1.
����ID : PR002
������ ����� : A_O001
���� �Ⱓ : 21/07/01~21/08/01
����� : ����Ŭ������
���ǽ� : E���ǽ�
���� ���� ���� : ���� ����
*/


--------------------------------------------------------------------------------


--�� ���� ��ȸ �� ���� 
CREATE OR REPLACE VIEW VIEW_SC
AS
SELECT T.*
FROM
(
    --����
    SELECT ROWNUM "NUM", SC_CD "SC_CD", REG_CD "REG_CD", OS_CD "OS_CD"
         , SC_AT "SC_AT", SC_WT "SC_WT", SC_PT "SC_PT"
    FROM TBL_SC
)T; 


--�� ���� ��ȸ ���ν��� �ۼ� 
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
    V_SC_TT     NUMBER; --����
    V_SC_RK     NUMBER; --���
    
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
        --�߰�
        SELECT REG_CD,OS_CD,SC_CD INTO V_REG_CD,V_OS_CD,V_SC_CD
        FROM VIEW_SC
        WHERE NUM = V_NUM;
        
        SELECT ST_FN, ST_LN INTO V_ST_FN, V_ST_LN
        FROM TBL_ST
        WHERE ST_ID = (SELECT ST_ID FROM TBL_REG WHERE REG_CD = V_REG_CD);
        
        --�߰�
        SELECT CRS_CD INTO V_CRS_CD
        FROM TBL_OC
        WHERE OC_CD = (SELECT OC_CD FROM TBL_OS WHERE OS_CD = V_OS_CD);
        
        SELECT CRS_NM INTO V_CRS_NM
        FROM TBL_CRS
        WHERE CRS_CD = V_CRS_CD;
        
        --�߰�
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
        DBMS_OUTPUT.PUT_LINE('��: ' || V_ST_FN);
        DBMS_OUTPUT.PUT_LINE('�̸�: ' || V_ST_LN);
        DBMS_OUTPUT.PUT_LINE('������: ' || V_CRS_NM);
        DBMS_OUTPUT.PUT_LINE('�����: ' || V_SUB_NM);
        DBMS_OUTPUT.PUT_LINE('����Ⱓ: ' || V_SUB_BD || ' ~ ' || V_SUB_ED);
        DBMS_OUTPUT.PUT_LINE('�����: ' || V_BK_NM);
        DBMS_OUTPUT.PUT_LINE('���: ' || V_SC_AT);
        DBMS_OUTPUT.PUT_LINE('�ʱ�: ' || V_SC_WT);
        DBMS_OUTPUT.PUT_LINE('�Ǳ�: ' || V_SC_PT);
        DBMS_OUTPUT.PUT_LINE('����: ' || V_SC_TT);
        DBMS_OUTPUT.PUT_LINE('���: ' || V_SC_RK);
        
        V_NUM := V_NUM+1;
        
        EXIT WHEN V_NUM > V_ROWNUM;
    END LOOP;
END;
