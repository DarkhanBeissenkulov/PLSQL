prompt
prompt Creating function SCENARIO#0111
prompt ===============================
prompt
CREATE OR REPLACE FUNCTION AML_USER.SCENARIO#0111(
  IN_ID                    IN OUT NUMBER,   -- ��
  IN_ISSUEDBID             IN OUT NUMBER,   -- �� ��������
  IN_BANKOPERATIONID       IN OUT VARCHAR2, -- ����� ��������
  IN_ORDERNUMBER           IN OUT VARCHAR2, -- ����� ������ � �������
  IN_BRANCH                IN OUT VARCHAR2, -- ��� �������
  IN_CURRENCYCODE          IN OUT VARCHAR2, -- ��� ������
  IN_OPERATIONDATETIME     IN OUT DATE,     -- ���� ��������
  IN_BASEAMOUNT            IN OUT NUMBER,   -- ����� (���)
  IN_CURRENCYAMOUNT        IN OUT NUMBER,   -- ����� (���)
  IN_EKNPCODE              IN OUT VARCHAR2, -- ���
  IN_DOCNUMBER             IN OUT VARCHAR2, -- � ���������
  IN_DOCDATE               IN OUT DATE,     -- ���� ���������
  IN_DOCCATEGORY           IN OUT NUMBER,   -- ��������� ���������
  IN_DOCSUSPIC             IN OUT NUMBER,   -- ��� ����������������
  IN_OPERATIONSTATUS       IN OUT NUMBER,   -- ��������� ��������
  IN_OPERATIONREASON       IN OUT VARCHAR2, -- ��������� ����������
  OUT_MESS_NUMBER          OUT NUMBER,      -- ��1 - ����� �����
  OUT_MESS_DATE            OUT DATE,        -- ��1 - ���� �����
  OUT_MESS_KIND            OUT NUMBER,      -- ��1 - ��� ���������
  OUT_MESS_STATUS          OUT NUMBER,      -- ��1 - ��������� ������
  OUT_SUSPIC_KIND          OUT NUMBER,      -- ��� ��������� (��/��������)
  OUT_SUSPICIOUSTYPECODE   OUT NUMBER,      -- ��� ��������� ��
  OUT_CRITERIAFIRST        OUT NUMBER,      -- ������� ���������������� 1
  OUT_CRITERIASECOND       OUT NUMBER,      -- ������� ���������������� 2
  OUT_CRITERIATHIRD        OUT NUMBER,      -- ������� ���������������� 3
  OUT_CRITERIADIFFICULTIES OUT VARCHAR2,    -- �����������
  OUT_OPERATIONEXTRAINFO   OUT VARCHAR2,    -- �������������� ����������
  OUT_OFFLINEOPERATIONID   OUT NUMBER,      -- ID �������� �� TB_OFFLINEOPERATIONS
  OUT_OPERATION_LIST       OUT VARCHAR2     -- ������ ID �������� TB_OFFLINEOPERATIONS
) RETURN NUMBER IS
  v_res NUMBER; -- ������ ��������, ���� ����������� ��������, �� ���������� 1
  sWord VARCHAR2(50) := '';

BEGIN
  v_res := -1;

  /*************************************************************************************
  �������� ��������:
  0111 - ��������� ��������, �� ����������� ���������� ����.

  ����� > = 3 000 000 KZT � ��������� ��������� = 3,4
  �
  ��������� ��������: ����, �����,�������,��������


  *************************************************************************************/
  -- ������ ����������������� ����
  IF IN_BASEAMOUNT >= 3000000 AND IN_DOCCATEGORY IN (3,4) THEN

    IF INSTR(UPPER(IN_OPERATIONREASON), '�����') > 0 THEN
      sWord := '�����';
    ELSIF INSTR(UPPER(IN_OPERATIONREASON), '���� ') > 0 OR
          INSTR(UPPER(IN_OPERATIONREASON), '����.') > 0 OR
          INSTR(UPPER(IN_OPERATIONREASON), '����,') > 0 OR
          INSTR(UPPER(IN_OPERATIONREASON), '����!') > 0 OR
          INSTR(UPPER(IN_OPERATIONREASON), '����)') > 0 OR
          INSTR(UPPER(IN_OPERATIONREASON), '����(') > 0 OR
          INSTR(UPPER(IN_OPERATIONREASON), '����:') > 0 OR
          INSTR(UPPER(IN_OPERATIONREASON), '����;') > 0 OR
          INSTR(UPPER(IN_OPERATIONREASON), '����?') > 0 OR
          INSTR(UPPER(IN_OPERATIONREASON), '����[') > 0 OR
          INSTR(UPPER(IN_OPERATIONREASON), '����]') > 0 OR
          INSTR(UPPER(IN_OPERATIONREASON), '����{') > 0 OR
          INSTR(UPPER(IN_OPERATIONREASON), '����}') > 0 OR
          INSTR(UPPER(IN_OPERATIONREASON), '����#') > 0 OR
          INSTR(UPPER(IN_OPERATIONREASON), '����@') > 0 OR
          INSTR(UPPER(IN_OPERATIONREASON), '����!') > 0 OR
          INSTR(UPPER(IN_OPERATIONREASON), '����$') > 0
    THEN
      sWord := '����';
    END IF;

    IF sWord IS NOT NULL THEN

      OUT_MESS_NUMBER          := get_mess_number();
      OUT_MESS_DATE            := SYSDATE;
      OUT_MESS_KIND            := '1';
      OUT_MESS_STATUS          := '1';
      OUT_SUSPIC_KIND          := '1';
      OUT_SUSPICIOUSTYPECODE   := '0111';
      OUT_CRITERIAFIRST        := NULL;
      OUT_CRITERIASECOND       := NULL;
      OUT_CRITERIATHIRD        := NULL;
      OUT_CRITERIADIFFICULTIES := '';
      OUT_OPERATIONEXTRAINFO   := '[�������� � 0111] ������� ��������' ||
                                  chr(10) ||
                                  '���������� �������: '||IN_OPERATIONREASON||chr(10)||
                                  get_doc_desc(IN_DOCDATE,IN_DOCNUMBER) ||
                                  /*'��������� ��������, � ������� > 1000000 KZT' ||
                                  chr(10) || '��� = 119' || chr(10) ||*/
                                  '���������� �� ������: ' || sWord;
      IN_OPERATIONREASON       := '28';
      IN_DOCNUMBER             := '';
      IN_DOCDATE               := '';
      OUT_OFFLINEOPERATIONID   := IN_ID;
      OUT_OPERATION_LIST       := IN_ID;
      v_res                    := 1;
    END IF;

  END IF;

  -- ����� ����������������� ����
  RETURN v_res;
END;
/

prompt
prompt Creating function SCENARIO#0121
prompt ===============================
prompt
CREATE OR REPLACE FUNCTION AML_USER.SCENARIO#0121(
  IN_ID                    IN OUT NUMBER,   -- ��
  IN_ISSUEDBID             IN OUT NUMBER,   -- �� ��������
  IN_BANKOPERATIONID       IN OUT VARCHAR2, -- ����� ��������
  IN_ORDERNUMBER           IN OUT VARCHAR2, -- ����� ������ � �������
  IN_BRANCH                IN OUT VARCHAR2, -- ��� �������
  IN_CURRENCYCODE          IN OUT VARCHAR2, -- ��� ������
  IN_OPERATIONDATETIME     IN OUT DATE,     -- ���� ��������
  IN_BASEAMOUNT            IN OUT NUMBER,   -- ����� (���)
  IN_CURRENCYAMOUNT        IN OUT NUMBER,   -- ����� (���)
  IN_EKNPCODE              IN OUT VARCHAR2, -- ���
  IN_DOCNUMBER             IN OUT VARCHAR2, -- � ���������
  IN_DOCDATE               IN OUT DATE,     -- ���� ���������
  IN_DOCCATEGORY           IN OUT NUMBER,   -- ��������� ���������
  IN_DOCSUSPIC             IN OUT NUMBER,   -- ��� ����������������
  IN_OPERATIONSTATUS       IN OUT NUMBER,   -- ��������� ��������
  IN_OPERATIONREASON       IN OUT VARCHAR2, -- ��������� ����������
  OUT_MESS_NUMBER          OUT NUMBER,      -- ��1 - ����� �����
  OUT_MESS_DATE            OUT DATE,        -- ��1 - ���� �����
  OUT_MESS_KIND            OUT NUMBER,      -- ��1 - ��� ���������
  OUT_MESS_STATUS          OUT NUMBER,      -- ��1 - ��������� ������
  OUT_SUSPIC_KIND          OUT NUMBER,      -- ��� ��������� (��/��������)
  OUT_SUSPICIOUSTYPECODE   OUT NUMBER,      -- ��� ��������� ��
  OUT_CRITERIAFIRST        OUT NUMBER,      -- ������� ���������������� 1
  OUT_CRITERIASECOND       OUT NUMBER,      -- ������� ���������������� 2
  OUT_CRITERIATHIRD        OUT NUMBER,      -- ������� ���������������� 3
  OUT_CRITERIADIFFICULTIES OUT VARCHAR2,    -- �����������
  OUT_OPERATIONEXTRAINFO   OUT VARCHAR2,    -- �������������� ����������
  OUT_OFFLINEOPERATIONID   OUT NUMBER,      -- ID �������� �� TB_OFFLINEOPERATIONS
  OUT_OPERATION_LIST       OUT VARCHAR2     -- ������ ID �������� TB_OFFLINEOPERATIONS
) RETURN NUMBER IS
  v_res NUMBER; -- ������ ��������, ���� ����������� ��������, �� ���������� 1
  sWord VARCHAR2(50) := '';

BEGIN
  v_res := -1;

  /*************************************************************************************
  �������� ��������:
  0121 - ��������� �������� �� ����������� ���������� �������� ���� � ������� ����������;

  ����� > = 3 000 000 KZT � ��������� ��������� =3, 4
  �
  ��������� ��������: �����,��������,��������,��������, ����

  *************************************************************************************/
  -- ������ ����������������� ����
  IF IN_BASEAMOUNT >= 3000000 AND IN_DOCCATEGORY IN (3,4) THEN

    IF INSTR(UPPER(IN_OPERATIONREASON), '����') > 0 then
      sWord := '����';
    elsif INSTR(UPPER(IN_OPERATIONREASON), '����') > 0 then
      sWord := '����';
    elsif INSTR(UPPER(IN_OPERATIONREASON), '�����') > 0 then
      sWord := '�����';
    end if;

    IF sWord IS NOT NULL THEN

      OUT_MESS_NUMBER          := get_mess_number();
      OUT_MESS_DATE            := SYSDATE;
      OUT_MESS_KIND            := '1';
      OUT_MESS_STATUS          := '1';
      OUT_SUSPIC_KIND          := '1';
      OUT_SUSPICIOUSTYPECODE   := '0121';
      OUT_CRITERIAFIRST        := NULL;
      OUT_CRITERIASECOND       := NULL;
      OUT_CRITERIATHIRD        := NULL;
      OUT_CRITERIADIFFICULTIES := '';
      OUT_OPERATIONEXTRAINFO   := '[�������� � 0121] ������� ��������' ||
                                  chr(10) ||
                                  '���������� �������: '||IN_OPERATIONREASON||chr(10)||
                                  get_doc_desc(IN_DOCDATE,IN_DOCNUMBER) ||
                                  /*'��������� ��������, � ������� > 1000000 KZT' ||
                                  chr(10) || '��� = 119' || chr(10) ||*/
                                  '���������� �� ������: ' || sWord;
      IN_OPERATIONREASON       := '28';
      IN_DOCNUMBER             := '';
      IN_DOCDATE               := '';
      OUT_OFFLINEOPERATIONID   := IN_ID;
      OUT_OPERATION_LIST       := IN_ID;
      v_res                    := 1;
    END IF;

  END IF;

  -- ����� ����������������� ����
  RETURN v_res;
END;
/

prompt
prompt Creating function SCENARIO#0131
prompt ===============================
prompt
CREATE OR REPLACE FUNCTION AML_USER.SCENARIO#0131(
  IN_ID                    IN OUT NUMBER,   -- ��
  IN_ISSUEDBID             IN OUT NUMBER,   -- �� ��������
  IN_BANKOPERATIONID       IN OUT VARCHAR2, -- ����� ��������
  IN_ORDERNUMBER           IN OUT VARCHAR2, -- ����� ������ � �������
  IN_BRANCH                IN OUT VARCHAR2, -- ��� �������
  IN_CURRENCYCODE          IN OUT VARCHAR2, -- ��� ������
  IN_OPERATIONDATETIME     IN OUT DATE,     -- ���� ��������
  IN_BASEAMOUNT            IN OUT NUMBER,   -- ����� (���)
  IN_CURRENCYAMOUNT        IN OUT NUMBER,   -- ����� (���)
  IN_EKNPCODE              IN OUT VARCHAR2, -- ���
  IN_DOCNUMBER             IN OUT VARCHAR2, -- � ���������
  IN_DOCDATE               IN OUT DATE,     -- ���� ���������
  IN_DOCCATEGORY           IN OUT NUMBER,   -- ��������� ���������
  IN_DOCSUSPIC             IN OUT NUMBER,   -- ��� ����������������
  IN_OPERATIONSTATUS       IN OUT NUMBER,   -- ��������� ��������
  IN_OPERATIONREASON       IN OUT VARCHAR2, -- ��������� ����������
  OUT_MESS_NUMBER          OUT NUMBER,      -- ��1 - ����� �����
  OUT_MESS_DATE            OUT DATE,        -- ��1 - ���� �����
  OUT_MESS_KIND            OUT NUMBER,      -- ��1 - ��� ���������
  OUT_MESS_STATUS          OUT NUMBER,      -- ��1 - ��������� ������
  OUT_SUSPIC_KIND          OUT NUMBER,      -- ��� ��������� (��/��������)
  OUT_SUSPICIOUSTYPECODE   OUT NUMBER,      -- ��� ��������� ��
  OUT_CRITERIAFIRST        OUT NUMBER,      -- ������� ���������������� 1
  OUT_CRITERIASECOND       OUT NUMBER,      -- ������� ���������������� 2
  OUT_CRITERIATHIRD        OUT NUMBER,      -- ������� ���������������� 3
  OUT_CRITERIADIFFICULTIES OUT VARCHAR2,    -- �����������
  OUT_OPERATIONEXTRAINFO   OUT VARCHAR2,    -- �������������� ����������
  OUT_OFFLINEOPERATIONID   OUT NUMBER,      -- ID �������� �� TB_OFFLINEOPERATIONS
  OUT_OPERATION_LIST       OUT VARCHAR2     -- ������ ID �������� TB_OFFLINEOPERATIONS
) RETURN NUMBER IS
  v_res NUMBER; -- ������ ��������, ���� ����������� ��������, �� ���������� 1
  sWord VARCHAR2(50) := '';

BEGIN
  v_res := -1;

  /*************************************************************************************
  �������� ��������:
  0131 ��������� �������� �� ����������� ���������� �������
  ����� > = 3 000 000 KZT � ��������� ��������� = 3,4
  �
  ��������� ��������:�������,�������

  *************************************************************************************/
  -- ������ ����������������� ����
  IF IN_BASEAMOUNT >= 3000000 AND IN_DOCCATEGORY IN (3,4) THEN

    IF INSTR(UPPER(IN_OPERATIONREASON), '�������') > 0 THEN
      sWord := '�������';
    ELSIF INSTR(UPPER(IN_OPERATIONREASON), '�������') > 0 THEN
      sWord := '�������';
    END IF;

    IF sWord IS NOT NULL THEN

      OUT_MESS_NUMBER          := get_mess_number();
      OUT_MESS_DATE            := SYSDATE;
      OUT_MESS_KIND            := '1';
      OUT_MESS_STATUS          := '1';
      OUT_SUSPIC_KIND          := '1';
      OUT_SUSPICIOUSTYPECODE   := '0131';
      OUT_CRITERIAFIRST        := NULL;
      OUT_CRITERIASECOND       := NULL;
      OUT_CRITERIATHIRD        := NULL;
      OUT_CRITERIADIFFICULTIES := '';
      OUT_OPERATIONEXTRAINFO   := '[�������� � 0131] ������� ��������' ||
                                  chr(10) ||
                                  '���������� �������: '||IN_OPERATIONREASON||chr(10)||
                                  get_doc_desc(IN_DOCDATE,IN_DOCNUMBER) ||
                                  /*'��������� ��������, � ������� > 1000000 KZT' ||
                                  chr(10) || '��� = 119' || chr(10) ||*/
                                  '���������� �� ������: ' || sWord;
      IN_OPERATIONREASON       := '28';
      IN_DOCNUMBER             := '';
      IN_DOCDATE               := '';
      OUT_OFFLINEOPERATIONID   := IN_ID;
      OUT_OPERATION_LIST       := IN_ID;
      v_res                    := 1;
    END IF;

  END IF;

  -- ����� ����������������� ����
  RETURN v_res;
END;
/

prompt
prompt Creating function SCENARIO#0211
prompt ===============================
prompt
CREATE OR REPLACE FUNCTION AML_USER.SCENARIO#0211(IN_ID                    IN OUT NUMBER, -- ��
                                         IN_ISSUEDBID             IN OUT NUMBER, -- �� ��������
                                         IN_BANKOPERATIONID       IN OUT VARCHAR2, -- ����� ��������
                                         IN_ORDERNUMBER           IN OUT VARCHAR2, -- ����� ������ � �������
                                         IN_BRANCH                IN OUT VARCHAR2, -- ��� �������
                                         IN_CURRENCYCODE          IN OUT VARCHAR2, -- ��� ������
                                         IN_OPERATIONDATETIME     IN OUT DATE, -- ���� ��������
                                         IN_BASEAMOUNT            IN OUT NUMBER, -- ����� (���)
                                         IN_CURRENCYAMOUNT        IN OUT NUMBER, -- ����� (���)
                                         IN_EKNPCODE              IN OUT VARCHAR2, -- ���
                                         IN_DOCNUMBER             IN OUT VARCHAR2, -- � ���������
                                         IN_DOCDATE               IN OUT DATE, -- ���� ���������
                                         IN_DOCCATEGORY           IN OUT NUMBER, -- ��������� ���������
                                         IN_DOCSUSPIC             IN OUT NUMBER, -- ��� ����������������
                                         IN_OPERATIONSTATUS       IN OUT NUMBER, -- ��������� ��������
                                         IN_OPERATIONREASON       IN OUT VARCHAR2, -- ��������� ����������
                                         OUT_MESS_NUMBER          OUT NUMBER, -- ��1 - ����� �����
                                         OUT_MESS_DATE            OUT DATE, -- ��1 - ���� �����
                                         OUT_MESS_KIND            OUT NUMBER, -- ��1 - ��� ���������
                                         OUT_MESS_STATUS          OUT NUMBER, -- ��1 - ��������� ������
                                         OUT_SUSPIC_KIND          OUT NUMBER, -- ��� ��������� (��/��������)
                                         OUT_SUSPICIOUSTYPECODE   OUT NUMBER, -- ��� ��������� ��
                                         OUT_CRITERIAFIRST        OUT NUMBER, -- ������� ���������������� 1
                                         OUT_CRITERIASECOND       OUT NUMBER, -- ������� ���������������� 2
                                         OUT_CRITERIATHIRD        OUT NUMBER, -- ������� ���������������� 3
                                         OUT_CRITERIADIFFICULTIES OUT VARCHAR2, -- �����������
                                         OUT_OPERATIONEXTRAINFO   OUT VARCHAR2, -- �������������� ����������
                                         OUT_OFFLINEOPERATIONID   OUT NUMBER, -- ID �������� �� TB_OFFLINEOPERATIONS
                                         OUT_OPERATION_LIST       OUT VARCHAR2 -- ������ ID �������� TB_OFFLINEOPERATIONS
                                         )

 RETURN NUMBER IS
  v_res NUMBER; -- ������ ��������, ���� ����������� ��������, �� ���������� 1
  sWord VARCHAR2(50) := '';
BEGIN
  v_res := -1;

  /*************************************************************************************
  �������� ��������:
  0221 - ������� �������� ����������� ������ ����� �������� ������;
  ��������� ��������� = 8 - �������
  � C����>= 10 000 000 KZT
  � ��� �� ISSUEBD = 3
  � P_OPERATIONEXTRAINFO ��������  '�������'

  *************************************************************************************/
  -- ������ ����������������� ����
  IF INSTR(UPPER(IN_OPERATIONREASON), '�������') > 0 THEN
    sWord := '�������';  
  END IF;

  IF IN_BASEAMOUNT >= 10000000
     AND IN_DOCCATEGORY = 8
     AND sWord IS NOT NULL
     AND IN_ISSUEDBID = 3
  THEN
    OUT_MESS_NUMBER          := get_mess_number();
    OUT_MESS_DATE            := SYSDATE;
    OUT_MESS_KIND            := '1';
    OUT_MESS_STATUS          := '1';
    OUT_SUSPIC_KIND          := '1';
    OUT_SUSPICIOUSTYPECODE   := '0211';
    OUT_CRITERIAFIRST        := NULL;
    OUT_CRITERIASECOND       := NULL;
    OUT_CRITERIATHIRD        := NULL;
    OUT_CRITERIADIFFICULTIES := '';
    OUT_OPERATIONEXTRAINFO   := '���������� �������: ' ||
                                IN_OPERATIONREASON || chr(10) ||
                                get_doc_desc(IN_DOCDATE,IN_DOCNUMBER)/*||
                                      '�������, ������� � ����� �������� ����������� ������ ����� �������� ������, ���������� �������'||chr(10)||
                                      '� ������� > 7000000 KZT'*/
     ;
    IN_OPERATIONREASON       := '29';
    IN_DOCNUMBER             := '';
    IN_DOCDATE               := '';
    OUT_OFFLINEOPERATIONID   := IN_ID;
    OUT_OPERATION_LIST       := IN_ID;
    v_res                    := 1;
  END IF;
  -- ����� ����������������� ����
  RETURN v_res;
END;
/

prompt
prompt Creating function SCENARIO#10021
prompt ================================
prompt
CREATE OR REPLACE FUNCTION AML_USER.SCENARIO#10021(IN_ID                    IN OUT NUMBER, -- ��
                                          IN_ISSUEDBID             IN OUT NUMBER, -- �� ��������
                                          IN_BANKOPERATIONID       IN OUT VARCHAR2, -- ����� ��������
                                          IN_ORDERNUMBER           IN OUT VARCHAR2, -- ����� ������ � �������
                                          IN_BRANCH                IN OUT VARCHAR2, -- ��� �������
                                          IN_CURRENCYCODE          IN OUT VARCHAR2, -- ��� ������
                                          IN_OPERATIONDATETIME     IN OUT DATE, -- ���� ��������
                                          IN_BASEAMOUNT            IN OUT NUMBER, -- ����� (���)
                                          IN_CURRENCYAMOUNT        IN OUT NUMBER, -- ����� (���)
                                          IN_EKNPCODE              IN OUT VARCHAR2, -- ���
                                          IN_DOCNUMBER             IN OUT VARCHAR2, -- � ���������
                                          IN_DOCDATE               IN OUT DATE, -- ���� ���������
                                          IN_DOCCATEGORY           IN OUT NUMBER, -- ��������� ���������
                                          IN_DOCSUSPIC             IN OUT NUMBER, -- ��� ����������������
                                          IN_OPERATIONSTATUS       IN OUT NUMBER, -- ��������� ��������
                                          IN_OPERATIONREASON       IN OUT VARCHAR2, -- ��������� ����������
                                          OUT_MESS_NUMBER          OUT NUMBER, -- ��1 - ����� �����
                                          OUT_MESS_DATE            OUT DATE, -- ��1 - ���� �����
                                          OUT_MESS_KIND            OUT NUMBER, -- ��1 - ��� ���������
                                          OUT_MESS_STATUS          OUT NUMBER, -- ��1 - ��������� ������
                                          OUT_SUSPIC_KIND          OUT NUMBER, -- ��� ��������� (��/��������)
                                          OUT_SUSPICIOUSTYPECODE   OUT NUMBER, -- ��� ��������� ��
                                          OUT_CRITERIAFIRST        OUT NUMBER, -- ������� ���������������� 1
                                          OUT_CRITERIASECOND       OUT NUMBER, -- ������� ���������������� 2
                                          OUT_CRITERIATHIRD        OUT NUMBER, -- ������� ���������������� 3
                                          OUT_CRITERIADIFFICULTIES OUT VARCHAR2, -- �����������
                                          OUT_OPERATIONEXTRAINFO   OUT VARCHAR2, -- �������������� ����������
                                          OUT_OFFLINEOPERATIONID   OUT NUMBER, -- ID �������� �� TB_OFFLINEOPERATIONS
                                          OUT_OPERATION_LIST       OUT VARCHAR2 -- ������ ID �������� TB_OFFLINEOPERATIONS
                                          ) RETURN NUMBER IS

  v_res            NUMBER; -- ������ ��������, ���� ����������� ��������, �� ���������� 1
  nCount1          NUMBER := 0; -- ������� ���� ����
  v_oper_list      varchar2(4000);
  v_sum            number;
  v_count          number;
BEGIN
  v_res := -1;

  /*************************************************************************************
  �������� ��������:
  1.22 �������� (������) � �������� � (���) ���� ���������� �� ������� ��������� ��������� ��������,
  ��� ������ �������� (������) �� ����� ���������� �������������� ������

  ����������� ��������:
  �� = 1,3,7,10
  � � ��������� ������� ���� �����, ��������������� ���� ��� �������
  ���� �� ���������� � Client_role = 3,4
  ����������� ����� �������� - �������?

  ������������:
  ��� �������� �� ������ = 30 ����������� ����
  � ���������� ��������� = 1,3,7,10
  ��� � ������� ���� = ����� �� ����������� ��������
  � ���� ����� ������� = ���� ��������� �� ����������� ��������

  ����� (�������������) >=  10 ���.��


  *************************************************************************************/
  -- ������ ����������������� ����

  IF IN_DOCCATEGORY IN (1, 3, 7, 10) AND is_deposit(IN_OPERATIONREASON) = 1 THEN

    SELECT COUNT(*)
    INTO   nCount1
    FROM   tb_off_members t
    WHERE  t.p_operationid = IN_ID
    AND    t.p_clientrole IN (3, 4)
    AND    instr(t.p_name, '�������� ����') = 0;

    IF nCount1 = 0 THEN
      return v_res;
    END IF;

    for rec_client in (
      select t.p_account,
             t.p_name,
             t.p_clientrole
      from   tb_off_members t
      where  t.p_operationid = in_id
      and    t.p_clientrole not in (3,4)
      and    t.p_account !='-'
    )
    loop

      SELECT sum(o.p_baseamount),
             count(1),
             stragg(o.id||'|')
      INTO   v_sum,
             v_count,
             v_oper_list
      FROM   tb_offlineoperations o,
             tb_off_members m
      WHERE  m.p_operationid = o.id
      AND    o.p_operationdatetime between IN_OPERATIONDATETIME - 30
                                   and     IN_OPERATIONDATETIME
      AND    m.p_account = rec_client.p_account
      AND    m.p_clientrole = rec_client.p_clientrole
      AND    is_deposit(o.p_operationreason) = 1
      AND    o.p_doccategory IN (1, 3, 7, 10)
      AND    EXISTS(
               SELECT 1
               FROM   tb_off_members m1
               WHERE  m1.p_operationid = o.id
               AND    m1.p_clientrole in (3,4)
               and    m1.p_name != m.p_name
             );
    end loop;
    IF v_sum >= 10000000 and v_count > 1 THEN

      OUT_MESS_NUMBER          := -1;
      OUT_MESS_DATE            := SYSDATE;
      OUT_MESS_KIND            := '1';
      OUT_MESS_STATUS          := '2';
      OUT_SUSPIC_KIND          := '1';
      OUT_SUSPICIOUSTYPECODE   := '0911';
      OUT_CRITERIAFIRST        := '1036';
      OUT_CRITERIASECOND       := NULL;
      OUT_CRITERIATHIRD        := NULL;
      OUT_CRITERIADIFFICULTIES := '';
      OUT_OPERATIONEXTRAINFO   := '[�������� 1002.1] ������� ��������' ||
                                  chr(10) || '���������� �������: ' ||
                                  IN_OPERATIONREASON || chr(10) ||
                                  '����������� �����/��������� ����� �� ������� �� �������� ���������� ��������������� ����� (��������)'
                                  ||chr(10)||get_history_details(v_oper_list);
      IN_OPERATIONREASON       := '29';
      OUT_OFFLINEOPERATIONID   := IN_ID;
      OUT_OPERATION_LIST       := v_oper_list;
      v_res                    := 1;
    END IF;
  END IF;

  -- ����� ����������������� ����
  RETURN v_res;
END;
/

prompt
prompt Creating function SCENARIO#10022
prompt ================================
prompt
create or replace function aml_user.SCENARIO#10022(IN_ID                    in out NUMBER, -- ��
                                         IN_ISSUEDBID             in out NUMBER, -- �� ��������
                                         IN_BANKOPERATIONID       in out VARCHAR2, -- ����� ��������
                                         IN_ORDERNUMBER           in out VARCHAR2, -- ����� ������ � �������
                                         IN_BRANCH                in out VARCHAR2, -- ��� �������
                                         IN_CURRENCYCODE          in out VARCHAR2, -- ��� ������
                                         IN_OPERATIONDATETIME     in out DATE, -- ���� ��������
                                         IN_BASEAMOUNT            in out NUMBER, -- ����� (���)
                                         IN_CURRENCYAMOUNT        in out NUMBER, -- ����� (���)
                                         IN_EKNPCODE              in out VARCHAR2, -- ���
                                         IN_DOCNUMBER             in out VARCHAR2, -- � ���������
                                         IN_DOCDATE               in out DATE, -- ���� ���������
                                         IN_DOCCATEGORY           in out NUMBER, -- ��������� ���������
                                         IN_DOCSUSPIC             in out NUMBER, -- ��� ����������������
                                         IN_OPERATIONSTATUS       in out NUMBER, -- ��������� ��������
                                         IN_OPERATIONREASON       in out VARCHAR2, -- ��������� ����������
                                         OUT_MESS_NUMBER          out NUMBER, -- ��1 - ����� �����
                                         OUT_MESS_DATE            out DATE, -- ��1 - ���� �����
                                         OUT_MESS_KIND            out NUMBER, -- ��1 - ��� ���������
                                         OUT_MESS_STATUS          out NUMBER, -- ��1 - ��������� ������
                                         OUT_SUSPIC_KIND          out NUMBER, -- ��� ��������� (��/��������)
                                         OUT_SUSPICIOUSTYPECODE   out NUMBER, -- ��� ��������� ��
                                         OUT_CRITERIAFIRST        out NUMBER, -- ������� ���������������� 1
                                         OUT_CRITERIASECOND       out NUMBER, -- ������� ���������������� 2
                                         OUT_CRITERIATHIRD        out NUMBER, -- ������� ���������������� 3
                                         OUT_CRITERIADIFFICULTIES out VARCHAR2, -- �����������
                                         OUT_OPERATIONEXTRAINFO   out VARCHAR2, -- �������������� ����������
                                         OUT_OFFLINEOPERATIONID   out NUMBER, -- ID �������� �� TB_OFFLINEOPERATIONS
                                         OUT_OPERATION_LIST       out VARCHAR2 -- ������ ID �������� TB_OFFLINEOPERATIONS
                                         )

 return number is
  v_res  number; -- ������ ��������, ���� ����������� ��������, �� ���������� 1
  nCheck number(1) := 0; -- ������ ��������, 0 ��� ���������, 1 ��������� ��������
  nCount number := 0; -- ������� ���� ����
begin
  v_res := -1;

  /*************************************************************************************
  �������� ��������:
  1.22 �������� (������) � �������� � (���) ���� ���������� �� ������� ��������� ��������� ��������,
  ��� ������ �������� (������) �� ����� ���������� �������������� ������

    (���������� = ����������
    �
    ����������� = ����������)
    �
    ����� > 15 000 000 KZT

  *************************************************************************************/
  -- ������ ����������������� ����

  if IN_BASEAMOUNT >= 15000000 then

    -- ������, � ������, (���������� = ����������
    Select count(1)
      into nCheck
      From tb_off_members t
     where t.p_operationid = IN_ID
       and p_clientrole in (1, 2)
       and p_countrycode != 398
       and instr(t.p_name, '�������� ����') = 0;

    select count(1)
      into nCount
      from (select count(1)
              from tb_off_members t
             where t.p_operationid = IN_ID
               and p_countrycode != 398
               and p_clientrole in (1, 2)
               and instr(t.p_name, '�������� ����') = 0
             group by t.p_name);

    if ncount > 1 then
      return v_res;
    end if;

    Select count(1)
      into nCount
      From tb_off_members t
     where t.p_client_type != 2
     and t.p_operationid = in_ID;

    if nCount > 0 then
      return v_res;
    end if;

    if nCheck > 1 then

      OUT_MESS_NUMBER          := -1;
      OUT_MESS_DATE            := sysdate;
      OUT_MESS_KIND            := '1';
      OUT_MESS_STATUS          := '2';
      OUT_SUSPIC_KIND          := '1';
      OUT_SUSPICIOUSTYPECODE   := '0911';
      OUT_CRITERIAFIRST        := '1036';
      OUT_CRITERIASECOND       := null;
      OUT_CRITERIATHIRD        := null;
      OUT_CRITERIADIFFICULTIES := '';
      OUT_OPERATIONEXTRAINFO   := '[�������� � 1002.2] ������� ��������' ||
                                  chr(10) || '���������� �������: ' ||
                                  IN_OPERATIONREASON || chr(10) ||
                                  '�������� (������) � �������� � (���) ���� ���������� �� ������� ��������� ��������� ��������,' ||
                                  chr(10) ||
                                  '��� ������ �������� (������) �� ����� ���������� �������������� ������' ||
                                  chr(10) ||
                                  '���������� � ����������� ����������� , � ������� > 15000000 KZT';
      IN_OPERATIONREASON       := '29';
      OUT_OFFLINEOPERATIONID   := IN_ID;
      OUT_OPERATION_LIST       := IN_ID;
      v_res                    := 1;
    end if;
  end if;

  -- ����� ����������������� ����
  return v_res;
end;
/

prompt
prompt Creating function SCENARIO#10023
prompt ================================
prompt
create or replace function aml_user.SCENARIO#10023(IN_ID                    in out NUMBER, -- ��
                                         IN_ISSUEDBID             in out NUMBER, -- �� ��������
                                         IN_BANKOPERATIONID       in out VARCHAR2, -- ����� ��������
                                         IN_ORDERNUMBER           in out VARCHAR2, -- ����� ������ � �������
                                         IN_BRANCH                in out VARCHAR2, -- ��� �������
                                         IN_CURRENCYCODE          in out VARCHAR2, -- ��� ������
                                         IN_OPERATIONDATETIME     in out DATE, -- ���� ��������
                                         IN_BASEAMOUNT            in out NUMBER, -- ����� (���)
                                         IN_CURRENCYAMOUNT        in out NUMBER, -- ����� (���)
                                         IN_EKNPCODE              in out VARCHAR2, -- ���
                                         IN_DOCNUMBER             in out VARCHAR2, -- � ���������
                                         IN_DOCDATE               in out DATE, -- ���� ���������
                                         IN_DOCCATEGORY           in out NUMBER, -- ��������� ���������
                                         IN_DOCSUSPIC             in out NUMBER, -- ��� ����������������
                                         IN_OPERATIONSTATUS       in out NUMBER, -- ��������� ��������
                                         IN_OPERATIONREASON       in out VARCHAR2, -- ��������� ����������
                                         OUT_MESS_NUMBER          out NUMBER, -- ��1 - ����� �����
                                         OUT_MESS_DATE            out DATE, -- ��1 - ���� �����
                                         OUT_MESS_KIND            out NUMBER, -- ��1 - ��� ���������
                                         OUT_MESS_STATUS          out NUMBER, -- ��1 - ��������� ������
                                         OUT_SUSPIC_KIND          out NUMBER, -- ��� ��������� (��/��������)
                                         OUT_SUSPICIOUSTYPECODE   out NUMBER, -- ��� ��������� ��
                                         OUT_CRITERIAFIRST        out NUMBER, -- ������� ���������������� 1
                                         OUT_CRITERIASECOND       out NUMBER, -- ������� ���������������� 2
                                         OUT_CRITERIATHIRD        out NUMBER, -- ������� ���������������� 3
                                         OUT_CRITERIADIFFICULTIES out VARCHAR2, -- �����������
                                         OUT_OPERATIONEXTRAINFO   out VARCHAR2, -- �������������� ����������
                                         OUT_OFFLINEOPERATIONID   out NUMBER, -- ID �������� �� TB_OFFLINEOPERATIONS
                                         OUT_OPERATION_LIST       out VARCHAR2 -- ������ ID �������� TB_OFFLINEOPERATIONS
                                         )

 return number is
  v_res  number; -- ������ ��������, ���� ����������� ��������, �� ���������� 1
  nCheck number(1) := 0; -- ������ ��������, 0 ��� ���������, 1 ��������� ��������
  nCount number := 0; -- ������� ���� ����
begin
  v_res := -1;

  /*************************************************************************************
  �������� ��������:
  1.3 ������������� ��������, ��������� ��� ���������� ����� �� ������� � ������ �������� ����,
  �� �������� ���������� �������������� ������

    ��� = 119, 110
    �
    ���������� = �����
    �
    ����������� = ��������
    �
    ����� = 1 500 000 KZT


  *************************************************************************************/
  -- ������ ����������������� ����
  if IN_BASEAMOUNT >= 2000000 then

    if IN_EKNPCODE in ('119', '110') then
      if instr(UPPER(IN_OPERATIONREASON),
               '������� ����� �� �����') > 0 or
         instr(UPPER(IN_OPERATIONREASON), '�� ����') > 0 or
         instr(UPPER(IN_OPERATIONREASON), '�������� �������') > 0 or
         instr(UPPER(IN_OPERATIONREASON), 'HALYK-�������') > 0 or
         instr(UPPER(IN_OPERATIONREASON), 'HALYK - ������� 2011') > 0 then
        -- ������, � ������, ���������� = �����
        Select count(1)
          into nCount
          From tb_off_members t
         where t.p_operationid = IN_ID
           and p_clientrole = 2
           and p_countrycode = 156
           and instr(t.p_name, '�������� ����') = 0;

        if nCount > 0 then
          -- ���� �����, �� ������ ����������� = ��������
          Select count(1)
            into nCheck
            From tb_off_members t
           where t.p_operationid = IN_ID
             and p_clientrole = 1
             and p_countrycode = 398
             and instr(t.p_name, '�������� ����') = 0;
        end if;

        if nCheck > 0 then

          OUT_MESS_NUMBER          := -1;
          OUT_MESS_DATE            := sysdate;
          OUT_MESS_KIND            := '1';
          OUT_MESS_STATUS          := '2';
          OUT_SUSPIC_KIND          := '1';
          OUT_SUSPICIOUSTYPECODE   := '0911';
          OUT_CRITERIAFIRST        := '1036';
          OUT_CRITERIASECOND       := null;
          OUT_CRITERIATHIRD        := null;
          OUT_CRITERIADIFFICULTIES := '';
          OUT_OPERATIONEXTRAINFO   := '[�������� � 1002.3] ������� ��������' ||
                                      chr(10) || '���������� �������: ' ||
                                      IN_OPERATIONREASON || chr(10) ||
                                      '������������� ��������, ��������� ��� ���������� ����� �� ������� � ������ ' ||
                                      chr(10) ||
                                      '�������� ����, � ������� > 1500000 KZT';
          IN_OPERATIONREASON       := '29';
          OUT_OFFLINEOPERATIONID   := IN_ID;
          OUT_OPERATION_LIST       := IN_ID;
          v_res                    := 1;
        end if;
      end if;
    end if;
  end if;
  -- ����� ����������������� ����
  return v_res;
end;
/

prompt
prompt Creating function SCENARIO#10024
prompt ================================
prompt
create or replace function aml_user.SCENARIO#10024(IN_ID                    in out NUMBER, -- ��
                                         IN_ISSUEDBID             in out NUMBER, -- �� ��������
                                         IN_BANKOPERATIONID       in out VARCHAR2, -- ����� ��������
                                         IN_ORDERNUMBER           in out VARCHAR2, -- ����� ������ � �������
                                         IN_BRANCH                in out VARCHAR2, -- ��� �������
                                         IN_CURRENCYCODE          in out VARCHAR2, -- ��� ������
                                         IN_OPERATIONDATETIME     in out DATE, -- ���� ��������
                                         IN_BASEAMOUNT            in out NUMBER, -- ����� (���)
                                         IN_CURRENCYAMOUNT        in out NUMBER, -- ����� (���)
                                         IN_EKNPCODE              in out VARCHAR2, -- ���
                                         IN_DOCNUMBER             in out VARCHAR2, -- � ���������
                                         IN_DOCDATE               in out DATE, -- ���� ���������
                                         IN_DOCCATEGORY           in out NUMBER, -- ��������� ���������
                                         IN_DOCSUSPIC             in out NUMBER, -- ��� ����������������
                                         IN_OPERATIONSTATUS       in out NUMBER, -- ��������� ��������
                                         IN_OPERATIONREASON       in out VARCHAR2, -- ��������� ����������
                                         OUT_MESS_NUMBER          out NUMBER, -- ��1 - ����� �����
                                         OUT_MESS_DATE            out DATE, -- ��1 - ���� �����
                                         OUT_MESS_KIND            out NUMBER, -- ��1 - ��� ���������
                                         OUT_MESS_STATUS          out NUMBER, -- ��1 - ��������� ������
                                         OUT_SUSPIC_KIND          out NUMBER, -- ��� ��������� (��/��������)
                                         OUT_SUSPICIOUSTYPECODE   out NUMBER, -- ��� ��������� ��
                                         OUT_CRITERIAFIRST        out NUMBER, -- ������� ���������������� 1
                                         OUT_CRITERIASECOND       out NUMBER, -- ������� ���������������� 2
                                         OUT_CRITERIATHIRD        out NUMBER, -- ������� ���������������� 3
                                         OUT_CRITERIADIFFICULTIES out VARCHAR2, -- �����������
                                         OUT_OPERATIONEXTRAINFO   out VARCHAR2, -- �������������� ����������
                                         OUT_OFFLINEOPERATIONID   out NUMBER, -- ID �������� �� TB_OFFLINEOPERATIONS
                                         OUT_OPERATION_LIST       out VARCHAR2 -- ������ ID �������� TB_OFFLINEOPERATIONS
                                         )

 return number is
  v_res  number; -- ������ ��������, ���� ����������� ��������, �� ���������� 1
  nCheck number(1) := 0; -- ������ ��������, 0 ��� ���������, 1 ��������� ��������
  nCount number := 0; -- ������� ���� ����
begin
  v_res := -1;

  /*************************************************************************************
  �������� ��������:
  1.3 ������������� ��������, ��������� ��� ���������� ����� �� ������� � ������ �������� ����,
  �� �������� ���������� �������������� ������

    ��� = 110,111, 112,119
    �
    ���������� = (�� � ��������)
    �
    ����������� = (�� � ��������)
    �
    ����� >= 10 000 000 KZT


  *************************************************************************************/
  -- ������ ����������������� ����
  if IN_BASEAMOUNT >= 10000000 then
    if IN_EKNPCODE in ('110', '111', '112', '119') then
      if instr(UPPER(IN_OPERATIONREASON),
               '������� ����� �� �����') > 0 or
         instr(UPPER(IN_OPERATIONREASON), '�� ����') > 0 or
         instr(UPPER(IN_OPERATIONREASON), '�������� �������') > 0 or
         instr(UPPER(IN_OPERATIONREASON), 'HALYK-�������') > 0 or
         instr(UPPER(IN_OPERATIONREASON), 'HALYK - ������� 2011') > 0 then
        -- ������, � ������, ���������� = (�� � ��������)
        Select count(1)
          into nCount
          From tb_off_members t
         where t.p_operationid = IN_ID
           and t.p_clientrole = 2
           and t.p_countrycode = 398
           and t.p_client_type = 2
           and instr(t.p_name, '�������� ����') = 0;

        if nCount > 0 then
          -- ���� �����, �� ������ ����������� = (�� � ��������)
          Select count(1)
            into nCheck
            From tb_off_members t
           where t.p_operationid = IN_ID
             and p_clientrole = 1
             and p_countrycode = 398
             and t.p_client_type = 2
             and instr(t.p_name, '�������� ����') = 0;
        end if;

        if nCheck > 0 then

          OUT_MESS_NUMBER          := get_mess_number();
          OUT_MESS_DATE            := sysdate;
          OUT_MESS_KIND            := '1';
          OUT_MESS_STATUS          := '2';
          OUT_SUSPIC_KIND          := '1';
          OUT_SUSPICIOUSTYPECODE   := '0911';
          OUT_CRITERIAFIRST        := '1036';
          OUT_CRITERIASECOND       := null;
          OUT_CRITERIATHIRD        := null;
          OUT_CRITERIADIFFICULTIES := '';
          OUT_OPERATIONEXTRAINFO   := '[�������� � 1002.4] ������� ��������' ||
                                      chr(10) || '���������� �������: ' ||
                                      IN_OPERATIONREASON || chr(10) ||
                                      '������������� ��������, ��������� ��� ���������� ����� �� ������� � ������ ' ||
                                      chr(10) ||
                                      '�������� ����, � ������� > 10000000 KZT';
          IN_OPERATIONREASON       := '29';
          OUT_OFFLINEOPERATIONID   := IN_ID;
          OUT_OPERATION_LIST       := IN_ID;
          v_res                    := 1;
        end if;
      end if;
    end if;
  end if;
  -- ����� ����������������� ����
  return v_res;
end;
/

prompt
prompt Creating function SCENARIO#10025
prompt ================================
prompt
create or replace function aml_user.SCENARIO#10025(IN_ID                    in out NUMBER, -- ��
                                         IN_ISSUEDBID             in out NUMBER, -- �� ��������
                                         IN_BANKOPERATIONID       in out VARCHAR2, -- ����� ��������
                                         IN_ORDERNUMBER           in out VARCHAR2, -- ����� ������ � �������
                                         IN_BRANCH                in out VARCHAR2, -- ��� �������
                                         IN_CURRENCYCODE          in out VARCHAR2, -- ��� ������
                                         IN_OPERATIONDATETIME     in out DATE, -- ���� ��������
                                         IN_BASEAMOUNT            in out NUMBER, -- ����� (���)
                                         IN_CURRENCYAMOUNT        in out NUMBER, -- ����� (���)
                                         IN_EKNPCODE              in out VARCHAR2, -- ���
                                         IN_DOCNUMBER             in out VARCHAR2, -- � ���������
                                         IN_DOCDATE               in out DATE, -- ���� ���������
                                         IN_DOCCATEGORY           in out NUMBER, -- ��������� ���������
                                         IN_DOCSUSPIC             in out NUMBER, -- ��� ����������������
                                         IN_OPERATIONSTATUS       in out NUMBER, -- ��������� ��������
                                         IN_OPERATIONREASON       in out VARCHAR2, -- ��������� ����������
                                         OUT_MESS_NUMBER          out NUMBER, -- ��1 - ����� �����
                                         OUT_MESS_DATE            out DATE, -- ��1 - ���� �����
                                         OUT_MESS_KIND            out NUMBER, -- ��1 - ��� ���������
                                         OUT_MESS_STATUS          out NUMBER, -- ��1 - ��������� ������
                                         OUT_SUSPIC_KIND          out NUMBER, -- ��� ��������� (��/��������)
                                         OUT_SUSPICIOUSTYPECODE   out NUMBER, -- ��� ��������� ��
                                         OUT_CRITERIAFIRST        out NUMBER, -- ������� ���������������� 1
                                         OUT_CRITERIASECOND       out NUMBER, -- ������� ���������������� 2
                                         OUT_CRITERIATHIRD        out NUMBER, -- ������� ���������������� 3
                                         OUT_CRITERIADIFFICULTIES out VARCHAR2, -- �����������
                                         OUT_OPERATIONEXTRAINFO   out VARCHAR2, -- �������������� ����������
                                         OUT_OFFLINEOPERATIONID   out NUMBER, -- ID �������� �� TB_OFFLINEOPERATIONS
                                         OUT_OPERATION_LIST       out VARCHAR2 -- ������ ID �������� TB_OFFLINEOPERATIONS
                                         )

 return number is
  v_res  number; -- ������ ��������, ���� ����������� ��������, �� ���������� 1
  nCheck number(1) := 0; -- ������ ��������, 0 ��� ���������, 1 ��������� ��������
  nCount number := 0; -- ������� ���� ����
begin
  v_res := -1;

  /*************************************************************************************
  �������� ��������:
  1.3 ������������� ��������, ��������� ��� ���������� ����� �� ������� � ������ �������� ����,
  �� �������� ���������� �������������� ������

    ��� =  111, 112
    �
    ���������� = (�� � ����������)
    �
    ����������� = (�� � ��������)
    �
    ����� >= 2 000 000 KZT

  *************************************************************************************/
  -- ������ ����������������� ����
  if IN_BASEAMOUNT >= 2000000 then
    if IN_EKNPCODE in ('111', '112') then
      if instr(UPPER(IN_OPERATIONREASON),
               '������� ����� �� �����') > 0 or
         instr(UPPER(IN_OPERATIONREASON), '�� ����') > 0 or
         instr(UPPER(IN_OPERATIONREASON), '�������� �������') > 0 or
         instr(UPPER(IN_OPERATIONREASON), 'HALYK-�������') > 0 or
         instr(UPPER(IN_OPERATIONREASON), 'HALYK - ������� 2011') > 0 then
        -- ������, � ������, ���������� = (�� � ����������)
        Select count(1)
          into nCount
          From tb_off_members t
         where t.p_operationid = IN_ID
           and t.p_clientrole = 2
           and t.p_countrycode != 398
           and t.p_client_type = 2
           and instr(t.p_name, '�������� ����') = 0;

        if nCount > 0 then
          -- ���� �����, �� ������ ����������� = (�� � ��������)
          Select count(1)
            into nCheck
            From tb_off_members t
           where t.p_operationid = IN_ID
             and p_clientrole = 1
             and p_countrycode = 398
             and t.p_client_type = 2
             and instr(t.p_name, '�������� ����') = 0;
        end if;

        if nCheck > 0 then

          OUT_MESS_NUMBER          := get_mess_number();
          OUT_MESS_DATE            := sysdate;
          OUT_MESS_KIND            := '1';
          OUT_MESS_STATUS          := '2';
          OUT_SUSPIC_KIND          := '1';
          OUT_SUSPICIOUSTYPECODE   := '0911';
          OUT_CRITERIAFIRST        := '1036';
          OUT_CRITERIASECOND       := null;
          OUT_CRITERIATHIRD        := null;
          OUT_CRITERIADIFFICULTIES := '';
          OUT_OPERATIONEXTRAINFO   := '[�������� � 1002.5] ������� ��������' ||
                                      chr(10) || '���������� �������: ' ||
                                      IN_OPERATIONREASON || chr(10) ||
                                      '������������� ��������, ��������� ��� ���������� ����� �� ������� � ������ ' ||
                                      chr(10) ||
                                      '�������� ����, � ������� > 2000000 KZT';
          IN_OPERATIONREASON       := '29';
          OUT_OFFLINEOPERATIONID   := IN_ID;
          OUT_OPERATION_LIST       := IN_ID;
          v_res                    := 1;
        end if;
      end if;
    end if;
  end if;
  -- ����� ����������������� ����
  return v_res;
end;
/