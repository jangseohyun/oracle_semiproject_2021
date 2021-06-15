--�� Ư�� �л��� Ư�� ���� ���� ��ȸ ���ν���

--�� ����
CREATE OR REPLACE VIEW VIEW_OS
AS
SELECT T.*
FROM
(   SELECT ROWNUM "NUM_OS", OS_CD "OS_CD", OC_CD "OC_CD", SUB_CD "SUB_CD", PR_ID "PR_ID"
         , BK_CD "BK_CD", RAT_CD "RAT_CD", SUB_BD "SUB_BD", SUB_ED "SUB_ED"
    FROM TBL_OS
    ORDER BY 3
)T;

CREATE OR REPLACE VIEW VIEW_OS_ORDER
AS
SELECT T.*
FROM
(   SELECT ROWNUM "NUM_OS_ORDER", NUM_OS "NUM_OS", OS_CD "OS_CD", OC_CD "OC_CD", SUB_CD "SUB_CD", PR_ID "PR_ID"
         , BK_CD "BK_CD", RAT_CD "RAT_CD", SUB_BD "SUB_BD", SUB_ED "SUB_ED"
    FROM VIEW_OS
)T;


--���ν��� ����
CREATE OR REPLACE PROCEDURE PRC_REG_ST_LOOKUP
(
    V_ST_ID       IN TBL_ST.ST_ID%TYPE    -- �л����̵�
,   V_REG_CD      IN TBL_REG.REG_CD%TYPE  -- �������� �ڵ�
,   V_OS_CD       IN TBL_OS.OS_CD%TYPE
,   V_NUM         NUMBER    DEFAULT 1
)
IS
    V_ST_FN       TBL_ST.ST_FN%TYPE;    -- �л� ��
    V_ST_LN       TBL_ST.ST_LN%TYPE;    -- �л� �̸�
    V_CRS_NM      TBL_CRS.CRS_NM%TYPE;  -- ������
    V_SUB_NM      TBL_SUB.SUB_NM%TYPE;  -- �����
    V_SC_AT       TBL_SC.SC_AT%TYPE;    -- ���
    V_SC_WT       TBL_SC.SC_WT%TYPE;    -- �ʱ�
    V_SC_PT       TBL_SC.SC_PT%TYPE;    -- �Ǳ�
    V_SUB_BD      TBL_OS.SUB_BD%TYPE;
    V_SUB_ED      TBL_OS.SUB_ED%TYPE;
    V_BK_NM       TBL_BK.BK_NM%TYPE;

    V_CRS_CD      TBL_CRS.CRS_CD%TYPE;  -- �����ڵ�
    V_SUB_CD      TBL_SUB.SUB_CD%TYPE;  -- �����ڵ�
    V_SC_CD       TBL_SC.SC_CD%TYPE;
    V_OC_CD       TBL_OC.OC_CD%TYPE;
    V_BK_CD       TBL_BK.BK_CD%TYPE;
    
    V_SC_TOT       NUMBER;             -- �������� ����
    V_SC_RK        NUMBER;             --���
    
    V_COUNT         NUMBER;
    V_COUNT_QT      NUMBER;
    V_MINNUM        NUMBER;
    V_MAXNUM        NUMBER;
    
    NONEXIST_ERROR  EXCEPTION;
BEGIN
    --�ߵ�Ż�� ���� ��ȸ
    SELECT COUNT(*) INTO V_COUNT
    FROM TBL_QT
    WHERE REG_CD = V_REG_CD;
            
    -- �л� �̸�
    SELECT ST_FN, ST_LN INTO V_ST_FN, V_ST_LN
    FROM TBL_ST
    WHERE ST_ID = V_ST_ID;
        
    -- �������� - ���������ڵ�
    SELECT OC_CD INTO V_OC_CD
    FROM TBL_REG
    WHERE REG_CD = V_REG_CD;
        
    -- �������� - ���������ڵ� �� �����ڵ�
    SELECT CRS_CD INTO V_CRS_CD
    FROM TBL_OC
    WHERE OC_CD = V_OC_CD;
                    
    -- ���� - �����ڵ� / �������� - �����ڵ� �� ������
    SELECT CRS_NM INTO V_CRS_NM
    FROM TBL_CRS
    WHERE CRS_CD = V_CRS_CD;
                    
    -- ���񰳼� - ���������ڵ� / �������� - ���������ڵ� �� �����ڵ�
		SELECT SUB_CD INTO V_SUB_CD
    FROM VIEW_OS
    WHERE OS_CD = V_OS_CD;
                    
    -- ���� - �����ڵ� / ���񰳼� - �����ڵ� �� �����
    SELECT SUB_NM INTO V_SUB_NM
    FROM TBL_SUB
    WHERE SUB_CD = V_SUB_CD;
                    
    -- �Ⱓ 
    SELECT SUB_BD, SUB_ED INTO V_SUB_BD, V_SUB_ED
    FROM TBL_OS
    WHERE SUB_CD = V_SUB_CD;
                    
    -- ���� -> �����ڵ� 
		SELECT BK_CD INTO V_BK_CD
    FROM VIEW_OS_ORDER
    WHERE OS_CD = V_OS_CD;
                    
    -- ����� 
    SELECT BK_NM INTO V_BK_NM  
    FROM TBL_BK
    WHERE BK_CD = V_BK_CD;
                     
    IF (V_COUNT = 0)
        THEN 
            -- �����ڵ� 
            SELECT SC_CD INTO V_SC_CD
            FROM TBL_SC
            WHERE REG_CD = V_REG_CD AND OS_CD = V_OS_CD;
                            
            -- ��, ��, ��
            SELECT SC_AT, SC_WT, SC_PT INTO V_SC_AT, V_SC_WT, V_SC_PT
            FROM TBL_SC
            WHERE REG_CD = V_REG_CD AND OS_CD = V_OS_CD;
                            
            -- ����
            SELECT (SC_AT + SC_WT + SC_PT) INTO V_SC_TOT
            FROM TBL_SC
            WHERE SC_CD = V_SC_CD;
                            
            -- ���
            SELECT RANK() OVER (ORDER BY (SC_AT + SC_WT + SC_PT) DESC) INTO V_SC_RK
            FROM TBL_SC
            WHERE SC_CD = V_SC_CD;
            
            DBMS_OUTPUT.PUT_LINE('�л���: ' || V_ST_FN || V_ST_LN);
            DBMS_OUTPUT.PUT_LINE('������: ' || V_CRS_NM);
            DBMS_OUTPUT.PUT_LINE('�����: ' || V_SUB_NM);
            DBMS_OUTPUT.PUT_LINE('����Ⱓ: ' || V_SUB_BD || ' ~ ' || V_SUB_ED);
            DBMS_OUTPUT.PUT_LINE('�����: ' || V_BK_NM);
            DBMS_OUTPUT.PUT_LINE('���: ' || V_SC_AT);
            DBMS_OUTPUT.PUT_LINE('�ʱ�: ' || V_SC_WT);
            DBMS_OUTPUT.PUT_LINE('�Ǳ�: ' || V_SC_PT);
            DBMS_OUTPUT.PUT_LINE('����: ' || V_SC_TOT);
            DBMS_OUTPUT.PUT_LINE('���: ' || V_SC_RK);
    ELSIF V_COUNT > 0 
        THEN 
            DBMS_OUTPUT.PUT_LINE('�л���: ' || V_ST_FN || V_ST_LN);
            DBMS_OUTPUT.PUT_LINE('������: ' || V_CRS_NM);
            DBMS_OUTPUT.PUT_LINE('�����: ' || V_SUB_NM);
            DBMS_OUTPUT.PUT_LINE('����Ⱓ: ' || V_SUB_BD || ' ~ ' || V_SUB_ED);
            DBMS_OUTPUT.PUT_LINE('�����: ' || V_BK_NM);
            DBMS_OUTPUT.PUT_LINE('�� �� ������ �ߵ�Ż���Ͽ� ��ȸ�� ������ �����ϴ�. ��');
    END IF;
        
    -- ���� ó��
    EXCEPTION
        WHEN NONEXIST_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002, '�������� �ʴ� �������Դϴ�.');
END;


--�� ���� ����
EXEC PRC_REG_ST_LOOKUP('ST001','A-FS001');
/*
�л���: KIMABYUL
������: FS �ڹ�
�����: J �ڹ�
����Ⱓ: 21/02/01 ~ 21/03/16
�����: Java�� ����
���: 30
�ʱ�: 20
�Ǳ�: 48
����: 98
���: 1
*/


--�� Ư�� �л��� ��ü ���� ��ȸ ���ν���

--�� ����
CREATE OR REPLACE VIEW VIEW_REG
AS
SELECT T.*
FROM
(   SELECT ROWNUM "NUM_REG", REG_CD "REG_CD", ST_ID "ST_ID", OC_CD "OC_CD", REG_DT "REG_DT"
    FROM TBL_REG
		ORDER BY 3
)T;

CREATE OR REPLACE VIEW VIEW_REG_ORDER
AS
SELECT T.*
FROM
(   SELECT ROWNUM "NUM_REG_ORDER", REG_CD "REG_CD", ST_ID "ST_ID", OC_CD "OC_CD", REG_DT "REG_DT"
    FROM VIEW_REG
)T;


--���ν��� ����
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

--�� ���� ����
EXEC PRC_REG_ST_LOOKUP_ALL('ST001');
/*
1.
�л���: KIMABYUL
������: FS �ڹ�
�����: J �ڹ�
����Ⱓ: 21/02/01 ~ 21/03/16
�����: Java�� ����
���: 30
�ʱ�: 20
�Ǳ�: 48
����: 98
���: 1
2.
�л���: KIMABYUL
������: FS �ڹ�
�����: H HTML
����Ⱓ: 21/03/17 ~ 21/03/20
�����: Java�� ����
���: 10
�ʱ�: 10
�Ǳ�: 10
����: 30
���: 1
*/


--�� �������� ��ȸ ���ν��� 1 (1�л� 1����) 

CREATE OR REPLACE PROCEDURE PRC_REG_LOOKUP
(
    V_ST_ID     IN TBL_ST.ST_ID%TYPE    -- �л����̵�
,   V_OC_CD     IN TBL_OC.OC_CD%TYPE    -- ���� �ڵ�
)
IS
    V_ST_FN       TBL_ST.ST_FN%TYPE;   -- �л� ��
    V_ST_LN       TBL_ST.ST_LN%TYPE;   -- �л� �̸�
    V_CRS_NM      TBL_CRS.CRS_NM%TYPE; -- ������
    V_SUB_NM      TBL_SUB.SUB_NM%TYPE; -- �����
    V_SC_AT       TBL_SC.SC_AT%TYPE;   -- ���
    V_SC_WT       TBL_SC.SC_WT%TYPE;   -- �ʱ�
    V_SC_PT       TBL_SC.SC_PT%TYPE;   -- �Ǳ�
    
    V_OS_CD       TBL_OS.OS_CD%TYPE;
    V_CRS_CD      TBL_CRS.CRS_CD%TYPE;  -- �����ڵ�
    V_SUB_CD      TBL_SUB.SUB_CD%TYPE;  -- �����ڵ�
    V_REG_CD      TBL_REG.REG_CD%TYPE; -- ������û�ڵ�
    
    V_SC_TOT        NUMBER;             -- �������� ����
    
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
            -- �л��� ��ȸ�Ǵ� �ּ� ��ȣ(ROWNUM)���� �ִ� ��ȣ��
            SELECT MIN(ROWNUM),MAX(ROWNUM) INTO V_MINNUM,V_MAXNUM
            FROM VIEW_REG
            WHERE ST_ID = V_ST_ID AND OC_CD = V_OC_CD;
            
            -- �ش� �л��� ���� ������ ����ٸ�     
            LOOP
                --������û�ڵ�, ���������ڵ�
                SELECT REG_CD INTO V_REG_CD
                FROM VIEW_REG_ORDER
                WHERE ST_ID = V_ST_ID AND OC_CD = V_OC_CD;
                
                -- �л� �̸�
                SELECT ST_FN, ST_LN INTO V_ST_FN, V_ST_LN
                FROM TBL_ST
                WHERE ST_ID = V_ST_ID;
                
                -- �������� - ���������ڵ� / �������� - ���������ڵ� �� �����ڵ�
                SELECT CRS_CD INTO V_CRS_CD
                FROM TBL_OC
                WHERE OC_CD = V_OC_CD;
                
                -- ���� - �����ڵ� / �������� - �����ڵ� �� ������
                SELECT CRS_NM INTO V_CRS_NM
                FROM TBL_CRS
                WHERE CRS_CD = V_CRS_CD;
                
                -- ���񰳼� - ���������ڵ� / �������� - ���������ڵ� �� �����ڵ�
                SELECT OS_CD,SUB_CD INTO V_OS_CD,V_SUB_CD
                FROM VIEW_OS_ORDER
                WHERE OC_CD = V_OC_CD AND NUM_OS = V_NUM AND SYSDATE - SUB_ED > 0;
                
                -- ���� - �����ڵ� / ���񰳼� - �����ڵ� �� �����
                SELECT SUB_NM INTO V_SUB_NM
                FROM TBL_SUB
                WHERE SUB_CD = V_SUB_CD;
                
                -- �����Է� - ������û�ڵ� / �������� - ������û�ڵ� �� ����
                SELECT SC_AT, SC_WT, SC_PT INTO V_SC_AT, V_SC_WT, V_SC_PT
                FROM TBL_SC
                WHERE REG_CD = V_REG_CD AND OS_CD = V_OS_CD;
                
                
                V_SC_TOT := (V_SC_AT + V_SC_WT + V_SC_PT);   --����
                

               -- �ߵ�Ż�� �л� ���� ���� Ȯ��
		        SELECT COUNT(*) INTO Q_COUNT
		        FROM TBL_QT
		        WHERE REG_CD = V_REG_CD;
                
		        IF (Q_COUNT = 0)
                    THEN 
                        -- �л� �̸�, ������, ��������, �������� ����
                        -- �л� ���� ���
                        DBMS_OUTPUT.PUT_LINE('�л��̸� : ' || V_ST_FN || V_ST_LN);
                        DBMS_OUTPUT.PUT_LINE('������ : ' || V_CRS_NM);
                        DBMS_OUTPUT.PUT_LINE('�������� : ' || V_SUB_NM);
                        DBMS_OUTPUT.PUT_LINE('�������� ���� : ' || V_SC_TOT);
		        ELSIF (Q_COUNT > 0)
                    THEN
                        DBMS_OUTPUT.PUT_LINE('�л� �̸� : ' || V_ST_FN || V_ST_LN);
                        DBMS_OUTPUT.PUT_LINE('������ : ' || V_CRS_NM);
                        DBMS_OUTPUT.PUT_LINE('�� �� ������ �ߵ�Ż���� �л��Դϴ�.');
		        END IF;
                
                V_MINNUM := V_MINNUM+1;
                V_NUM := V_NUM + 1;
                
                EXIT WHEN V_MINNUM > V_MAXNUM;
            
            END LOOP;
            
    ELSE RAISE NONEXIST_ERROR;
        
    END IF;
    
    
    -- Ŀ��
    COMMIT;
    
    -- ���� ó��
    EXCEPTION
        WHEN NONEXIST_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002, '�������� �ʴ� �������Դϴ�.');
                ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
    

END;


--�� �������� ��ȸ ���ν��� 2 (��ü���� ��ü���� ��ü�л�)

CREATE OR REPLACE PROCEDURE PRC_AD_REG_LOOKUP
IS
    V_ST_ID      TBL_ST.ST_ID%TYPE;
    V_OC_CD      TBL_OC.OC_CD%TYPE;
    V_NUM        NUMBER := 1;
    V_ROWNUM     NUMBER; 
    V_MINNUM     NUMBER;
    V_MAXNUM     NUMBER;
BEGIN
    SELECT MIN(ROWNUM),MAX(ROWNUM) INTO V_MINNUM,V_MAXNUM
    FROM VIEW_OC;
    
    LOOP
        SELECT OC_CD INTO V_OC_CD
        FROM VIEW_OC
        WHERE NUM_OC = V_MINNUM;
        
        SELECT MAX(ROWNUM) INTO V_ROWNUM
        FROM TBL_REG
        WHERE OC_CD = V_OC_CD;
    
        LOOP
            SELECT ST_ID INTO V_ST_ID
            FROM VIEW_REG_ORDER
            WHERE NUM_REG_ORDER = V_NUM;
            
            DBMS_OUTPUT.PUT_LINE(V_NUM || '.');
            PRC_REG_LOOKUP(V_ST_ID,V_OC_CD);
            V_NUM := V_NUM + 1;
            
            EXIT WHEN V_NUM > V_ROWNUM;
        END LOOP;
        
        V_MINNUM := V_MINNUM +1;
        EXIT WHEN V_MINNUM > V_MAXNUM;
    END LOOP;
END;