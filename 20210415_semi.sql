CREATE TABLE TBL_AD --�����ڰ���
( AD_ID 	VARCHAR2(10)
, AD_PW 	VARCHAR2(10)	CONSTRAINT AD_PW_NN NOT NULL
, CONSTRAINT AD_ID_PK PRIMARY KEY(AD_ID)
);

CREATE TABLE TBL_QT --�ߵ�Ż��
( QT_CD 	VARCHAR2(10)
, REG_CD 	VARCHAR2(10)	CONSTRAINT QT_REG_CD_NN NOT NULL
, QT_DT		DATE		    DEFAULT SYSDATE
, CONSTRAINT QT_CD_PK PRIMARY KEY(QT_CD)
, CONSTRAINT QT_REG_CD_FK FOREIGN KEY(REG_CD)
			  REFERENCES TBL_REG(REG_CD)
);

CREATE TABLE TBL_RAT --����
( RAT_CD    VARCHAR2(10)
, RAT_AT    NUMBER(3)       CONSTRAINT RAT_AT_NN NOT NULL
, RAT_WT    NUMBER(3)       CONSTRAINT RAT_WT_NN NOT NULL
, RAT_PT    NUMBER(3)       CONSTRAINT RAT_PT_NN NOT NULL
, CONSTRAINT RAT_CD_PK PRIMARY KEY(RAT_CD)
);


--Ȯ�ο� ������ �Է�
INSERT INTO TBL_AD(AD_ID,AD_PW) VALUES('ADMIN', 'ADMIN');


--Ȯ��
SELECT *
FROM TBL_AD;

DESC TBL_AD;

SELECT TABLE_NAME, TABLESPACE_NAME
FROM USER_TABLES;

--Ŀ��
COMMIT;


--��� �� ������� ��ü �����Ͽ� �ٽ� ���� ����
DROP TABLE TBL_AD;
DROP TABLE TBL_RAT;


--------------------------------------------------------------------------------


--�� �ߵ�Ż���ڵ� ������ ������ ����
CREATE SEQUENCE SEQ_QUIT
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCACHE;


--�� �ߵ�Ż�� �Է� ���ν��� ����
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


--�� ���� ����
EXEC PRC_QUIT_INSERT('RG001',SYSDATE);
EXEC PRC_QUIT_INSERT('RG002',SYSDATE);
/*
QT_CD	REG_CD	QT_DT
Q001	RG001   21/04/15
Q002	RG002   21/04/15
*/

EXEC PRC_QUIT_INSERT('RG001',SYSDATE);
--==> ���� �߻�(ORA-20001: �̹� �����ϴ� �������Դϴ�.)


--�� �ߵ�Ż�� ���� ���ν��� ����
CREATE OR REPLACE PROCEDURE PRC_QUIT_UPDATE
(   V_REG_CD    IN TBL_QT.REG_CD%TYPE
,   V_QT_DT     IN TBL_QT.QT_DT%TYPE
)
IS
    NONEXIST_ERROR     EXCEPTION;
BEGIN
    --������û�ڵ尡 ��ġ�� ��� ������ ����
    UPDATE TBL_QT
    SET REG_CD = V_REG_CD, QT_DT = V_QT_DT
    WHERE REG_CD = V_REG_CD;
    
    --������û�ڵ尡 ��ġ�ϴ� ���� ���� ������ ������� �ʾ��� ��� ���� �߻�
    IF SQL%NOTFOUND
        THEN RAISE NONEXIST_ERROR;
    END IF;
    
    --Ŀ��
    COMMIT;
    
    --����ó��
    EXCEPTION
        WHEN NONEXIST_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002,'�Է��Ͻ� ������ ��ġ�ϴ� �����Ͱ� �����ϴ�.');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;


--�� ���� ����
EXEC PRC_QUIT_UPDATE('RG001','21/04/01');
/*
QT_CD	REG_CD	QT_DT
Q001	RG001   21/04/01
Q002	RG002   21/04/15
*/

EXEC PRC_QUIT_UPDATE('RG003','21/04/01');
--==> ���� �߻�(ORA-20002: �Է��Ͻ� ������ ��ġ�ϴ� �����Ͱ� �����ϴ�.)


--�� �ߵ�Ż�� ���� ���ν��� ����
CREATE OR REPLACE PROCEDURE PRC_QUIT_DELETE
(   V_QT_CD    IN TBL_QT.QT_CD%TYPE
)
IS
    NONEXIST_ERROR     EXCEPTION;
BEGIN
    --�ߵ�Ż���ڵ尡 ��ġ�� ��� ������ ����
    DELETE
    FROM TBL_QT
    WHERE QT_CD = V_REG_CD;
    
    --�ߵ�Ż���ڵ尡 ��ġ�ϴ� ���� ���� ������ ������� �ʾ��� ��� ���� �߻�
    IF SQL%NOTFOUND
        THEN RAISE NONEXIST_ERROR;
    END IF;
    
    --Ŀ��
    COMMIT;
    
    --����ó��
    EXCEPTION
        WHEN NONEXIST_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002,'�Է��Ͻ� ������ ��ġ�ϴ� �����Ͱ� �����ϴ�.');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;


--�� ���� ����
EXEC PRC_QUIT_DELETE('Q002');
/*
QT_CD	REG_CD	QT_DT
Q001	RG001   21/04/01
*/

EXEC PRC_QUIT_DELETE('Q003');
--==> ���� �߻�(ORA-20002: �Է��Ͻ� ������ ��ġ�ϴ� �����Ͱ� �����ϴ�.)


--�� �ߵ�Ż�� ���̺�(��ü ������) ��ȸ ���ν��� (��� X)
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
    --Ŀ�� ����
    OPEN CUR_QUIT_LOOKUP;
    
    LOOP
        FETCH CUR_QUIT_LOOKUP INTO V_QT_CD,V_REG_CD,V_QT_DT;
        
        EXIT WHEN CUR_QUIT_LOOKUP%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(V_QT_CD || ' ' || V_REG_CD || ' ' || V_QT_DT);
    END LOOP;
    
    --Ŀ�� Ŭ����
    CLOSE CUR_QUIT_LOOKUP;
END;


--�� ���� ����
EXEC PRC_QUIT_LOOKUP;
/*
QT_CD	REG_CD	QT_DT
Q001	RG001   21/04/01
*/


--�� �ߵ�Ż�� ���� ��ȸ ���ν��� ����
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
        THEN DBMS_OUTPUT.PUT_LINE('�ߵ�Ż�� �л��Դϴ�.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('��ϵ� �л��Դϴ�.');
    END IF;
END;