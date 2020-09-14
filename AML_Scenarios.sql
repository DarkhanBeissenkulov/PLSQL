prompt
prompt Creating function SCENARIO#0111
prompt ===============================
prompt
CREATE OR REPLACE FUNCTION AML_USER.SCENARIO#0111(
  IN_ID                    IN OUT NUMBER,   -- ИД
  IN_ISSUEDBID             IN OUT NUMBER,   -- БД ИСТОЧНИК
  IN_BANKOPERATIONID       IN OUT VARCHAR2, -- НОМЕР ОПЕРАЦИИ
  IN_ORDERNUMBER           IN OUT VARCHAR2, -- НОМЕР ЗАЯВКИ В СИСТЕМЕ
  IN_BRANCH                IN OUT VARCHAR2, -- КОД ФИЛИАЛА
  IN_CURRENCYCODE          IN OUT VARCHAR2, -- КОД ВАЛЮТЫ
  IN_OPERATIONDATETIME     IN OUT DATE,     -- ДАТА ОПЕРАЦИИ
  IN_BASEAMOUNT            IN OUT NUMBER,   -- СУММА (НАЦ)
  IN_CURRENCYAMOUNT        IN OUT NUMBER,   -- СУММА (ВАЛ)
  IN_EKNPCODE              IN OUT VARCHAR2, -- КНП
  IN_DOCNUMBER             IN OUT VARCHAR2, -- № ДОКУМЕНТА
  IN_DOCDATE               IN OUT DATE,     -- ДАТА ДОКУМЕНТА
  IN_DOCCATEGORY           IN OUT NUMBER,   -- КАТЕГОРИЯ ДОКУМЕНТА
  IN_DOCSUSPIC             IN OUT NUMBER,   -- ТИП ПОДОЗРИТЕЛЬНОСТИ
  IN_OPERATIONSTATUS       IN OUT NUMBER,   -- СОСТОЯНИЕ ОПЕРАЦИИ
  IN_OPERATIONREASON       IN OUT VARCHAR2, -- ОСНОВАНИЕ СОВЕРШЕНИЯ
  OUT_MESS_NUMBER          OUT NUMBER,      -- ФМ1 - НОМЕР ФОРМЫ
  OUT_MESS_DATE            OUT DATE,        -- ФМ1 - ДАТА ФОРМЫ
  OUT_MESS_KIND            OUT NUMBER,      -- ФМ1 - ВИД ДОКУМЕНТА
  OUT_MESS_STATUS          OUT NUMBER,      -- ФМ1 - ОСНОВАНИЕ ПОДАЧИ
  OUT_SUSPIC_KIND          OUT NUMBER,      -- ВИД ДОКУМЕНТА (ФМ/ПОДОЗРИТ)
  OUT_SUSPICIOUSTYPECODE   OUT NUMBER,      -- КОД КАТЕГОРИИ ФМ
  OUT_CRITERIAFIRST        OUT NUMBER,      -- ПРИЗНАК ПОДОЗРИТЕЛЬНОСТИ 1
  OUT_CRITERIASECOND       OUT NUMBER,      -- ПРИЗНАК ПОДОЗРИТЕЛЬНОСТИ 2
  OUT_CRITERIATHIRD        OUT NUMBER,      -- ПРИЗНАК ПОДОЗРИТЕЛЬНОСТИ 3
  OUT_CRITERIADIFFICULTIES OUT VARCHAR2,    -- ЗАТРУДНЕНИЯ
  OUT_OPERATIONEXTRAINFO   OUT VARCHAR2,    -- ДОПОЛНИТЕЛЬНАЯ ИНФОРМАЦИЯ
  OUT_OFFLINEOPERATIONID   OUT NUMBER,      -- ID ОПЕРАЦИИ ИЗ TB_OFFLINEOPERATIONS
  OUT_OPERATION_LIST       OUT VARCHAR2     -- СПИСОК ID ОПЕРАЦИЙ TB_OFFLINEOPERATIONS
) RETURN NUMBER IS
  v_res NUMBER; -- СТАТУС ВОЗВРАТА, ЕСЛИ СРАБАТЫВАЕТ СЦЕНАРИЙ, ТО ВОЗВРАЩАЕМ 1
  sWord VARCHAR2(50) := '';

BEGIN
  v_res := -1;

  /*************************************************************************************
  ОПИСАНИЕ СЦЕНАРИЯ:
  0111 - получение выигрыша, по результатам проведения пари.

  СУММА > = 3 000 000 KZT и Категория документа = 3,4
  И
  ОСНОВАНИЕ СОДЕРЖИТ: пари, выигр,выигрыш,выигрыша


  *************************************************************************************/
  -- НАЧАЛО ПОЛЬЗОВАТЕЛЬСКОГО КОДА
  IF IN_BASEAMOUNT >= 3000000 AND IN_DOCCATEGORY IN (3,4) THEN

    IF INSTR(UPPER(IN_OPERATIONREASON), 'ВЫИГР') > 0 THEN
      sWord := 'ВЫИГР';
    ELSIF INSTR(UPPER(IN_OPERATIONREASON), 'ПАРИ ') > 0 OR
          INSTR(UPPER(IN_OPERATIONREASON), 'ПАРИ.') > 0 OR
          INSTR(UPPER(IN_OPERATIONREASON), 'ПАРИ,') > 0 OR
          INSTR(UPPER(IN_OPERATIONREASON), 'ПАРИ!') > 0 OR
          INSTR(UPPER(IN_OPERATIONREASON), 'ПАРИ)') > 0 OR
          INSTR(UPPER(IN_OPERATIONREASON), 'ПАРИ(') > 0 OR
          INSTR(UPPER(IN_OPERATIONREASON), 'ПАРИ:') > 0 OR
          INSTR(UPPER(IN_OPERATIONREASON), 'ПАРИ;') > 0 OR
          INSTR(UPPER(IN_OPERATIONREASON), 'ПАРИ?') > 0 OR
          INSTR(UPPER(IN_OPERATIONREASON), 'ПАРИ[') > 0 OR
          INSTR(UPPER(IN_OPERATIONREASON), 'ПАРИ]') > 0 OR
          INSTR(UPPER(IN_OPERATIONREASON), 'ПАРИ{') > 0 OR
          INSTR(UPPER(IN_OPERATIONREASON), 'ПАРИ}') > 0 OR
          INSTR(UPPER(IN_OPERATIONREASON), 'ПАРИ#') > 0 OR
          INSTR(UPPER(IN_OPERATIONREASON), 'ПАРИ@') > 0 OR
          INSTR(UPPER(IN_OPERATIONREASON), 'ПАРИ!') > 0 OR
          INSTR(UPPER(IN_OPERATIONREASON), 'ПАРИ$') > 0
    THEN
      sWord := 'ПАРИ';
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
      OUT_OPERATIONEXTRAINFO   := '[Сценарий № 0111] Разовая операция' ||
                                  chr(10) ||
                                  'Назначение платежа: '||IN_OPERATIONREASON||chr(10)||
                                  get_doc_desc(IN_DOCDATE,IN_DOCNUMBER) ||
                                  /*'Получение выигрыша, в размере > 1000000 KZT' ||
                                  chr(10) || 'КНП = 119' || chr(10) ||*/
                                  'Совпадение со словом: ' || sWord;
      IN_OPERATIONREASON       := '28';
      IN_DOCNUMBER             := '';
      IN_DOCDATE               := '';
      OUT_OFFLINEOPERATIONID   := IN_ID;
      OUT_OPERATION_LIST       := IN_ID;
      v_res                    := 1;
    END IF;

  END IF;

  -- КОНЕЦ ПОЛЬЗОВАТЕЛЬСКОГО КОДА
  RETURN v_res;
END;
/

prompt
prompt Creating function SCENARIO#0121
prompt ===============================
prompt
CREATE OR REPLACE FUNCTION AML_USER.SCENARIO#0121(
  IN_ID                    IN OUT NUMBER,   -- ИД
  IN_ISSUEDBID             IN OUT NUMBER,   -- БД ИСТОЧНИК
  IN_BANKOPERATIONID       IN OUT VARCHAR2, -- НОМЕР ОПЕРАЦИИ
  IN_ORDERNUMBER           IN OUT VARCHAR2, -- НОМЕР ЗАЯВКИ В СИСТЕМЕ
  IN_BRANCH                IN OUT VARCHAR2, -- КОД ФИЛИАЛА
  IN_CURRENCYCODE          IN OUT VARCHAR2, -- КОД ВАЛЮТЫ
  IN_OPERATIONDATETIME     IN OUT DATE,     -- ДАТА ОПЕРАЦИИ
  IN_BASEAMOUNT            IN OUT NUMBER,   -- СУММА (НАЦ)
  IN_CURRENCYAMOUNT        IN OUT NUMBER,   -- СУММА (ВАЛ)
  IN_EKNPCODE              IN OUT VARCHAR2, -- КНП
  IN_DOCNUMBER             IN OUT VARCHAR2, -- № ДОКУМЕНТА
  IN_DOCDATE               IN OUT DATE,     -- ДАТА ДОКУМЕНТА
  IN_DOCCATEGORY           IN OUT NUMBER,   -- КАТЕГОРИЯ ДОКУМЕНТА
  IN_DOCSUSPIC             IN OUT NUMBER,   -- ТИП ПОДОЗРИТЕЛЬНОСТИ
  IN_OPERATIONSTATUS       IN OUT NUMBER,   -- СОСТОЯНИЕ ОПЕРАЦИИ
  IN_OPERATIONREASON       IN OUT VARCHAR2, -- ОСНОВАНИЕ СОВЕРШЕНИЯ
  OUT_MESS_NUMBER          OUT NUMBER,      -- ФМ1 - НОМЕР ФОРМЫ
  OUT_MESS_DATE            OUT DATE,        -- ФМ1 - ДАТА ФОРМЫ
  OUT_MESS_KIND            OUT NUMBER,      -- ФМ1 - ВИД ДОКУМЕНТА
  OUT_MESS_STATUS          OUT NUMBER,      -- ФМ1 - ОСНОВАНИЕ ПОДАЧИ
  OUT_SUSPIC_KIND          OUT NUMBER,      -- ВИД ДОКУМЕНТА (ФМ/ПОДОЗРИТ)
  OUT_SUSPICIOUSTYPECODE   OUT NUMBER,      -- КОД КАТЕГОРИИ ФМ
  OUT_CRITERIAFIRST        OUT NUMBER,      -- ПРИЗНАК ПОДОЗРИТЕЛЬНОСТИ 1
  OUT_CRITERIASECOND       OUT NUMBER,      -- ПРИЗНАК ПОДОЗРИТЕЛЬНОСТИ 2
  OUT_CRITERIATHIRD        OUT NUMBER,      -- ПРИЗНАК ПОДОЗРИТЕЛЬНОСТИ 3
  OUT_CRITERIADIFFICULTIES OUT VARCHAR2,    -- ЗАТРУДНЕНИЯ
  OUT_OPERATIONEXTRAINFO   OUT VARCHAR2,    -- ДОПОЛНИТЕЛЬНАЯ ИНФОРМАЦИЯ
  OUT_OFFLINEOPERATIONID   OUT NUMBER,      -- ID ОПЕРАЦИИ ИЗ TB_OFFLINEOPERATIONS
  OUT_OPERATION_LIST       OUT VARCHAR2     -- СПИСОК ID ОПЕРАЦИЙ TB_OFFLINEOPERATIONS
) RETURN NUMBER IS
  v_res NUMBER; -- СТАТУС ВОЗВРАТА, ЕСЛИ СРАБАТЫВАЕТ СЦЕНАРИЙ, ТО ВОЗВРАЩАЕМ 1
  sWord VARCHAR2(50) := '';

BEGIN
  v_res := -1;

  /*************************************************************************************
  ОПИСАНИЕ СЦЕНАРИЯ:
  0121 - Получение выигрыша по результатам проведения азартной игры в игорных заведениях;

  СУММА > = 3 000 000 KZT и Категория документа =3, 4
  И
  ОСНОВАНИЕ СОДЕРЖИТ: азарт,азартный,азартных,азартные, ИГРА

  *************************************************************************************/
  -- НАЧАЛО ПОЛЬЗОВАТЕЛЬСКОГО КОДА
  IF IN_BASEAMOUNT >= 3000000 AND IN_DOCCATEGORY IN (3,4) THEN

    IF INSTR(UPPER(IN_OPERATIONREASON), 'ИГРА') > 0 then
      sWord := 'ИГРА';
    elsif INSTR(UPPER(IN_OPERATIONREASON), 'ИГРЫ') > 0 then
      sWord := 'ИГРЫ';
    elsif INSTR(UPPER(IN_OPERATIONREASON), 'АЗАРТ') > 0 then
      sWord := 'АЗАРТ';
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
      OUT_OPERATIONEXTRAINFO   := '[Сценарий № 0121] Разовая операция' ||
                                  chr(10) ||
                                  'Назначение платежа: '||IN_OPERATIONREASON||chr(10)||
                                  get_doc_desc(IN_DOCDATE,IN_DOCNUMBER) ||
                                  /*'Получение выигрыша, в размере > 1000000 KZT' ||
                                  chr(10) || 'КНП = 119' || chr(10) ||*/
                                  'Совпадение со словом: ' || sWord;
      IN_OPERATIONREASON       := '28';
      IN_DOCNUMBER             := '';
      IN_DOCDATE               := '';
      OUT_OFFLINEOPERATIONID   := IN_ID;
      OUT_OPERATION_LIST       := IN_ID;
      v_res                    := 1;
    END IF;

  END IF;

  -- КОНЕЦ ПОЛЬЗОВАТЕЛЬСКОГО КОДА
  RETURN v_res;
END;
/

prompt
prompt Creating function SCENARIO#0131
prompt ===============================
prompt
CREATE OR REPLACE FUNCTION AML_USER.SCENARIO#0131(
  IN_ID                    IN OUT NUMBER,   -- ИД
  IN_ISSUEDBID             IN OUT NUMBER,   -- БД ИСТОЧНИК
  IN_BANKOPERATIONID       IN OUT VARCHAR2, -- НОМЕР ОПЕРАЦИИ
  IN_ORDERNUMBER           IN OUT VARCHAR2, -- НОМЕР ЗАЯВКИ В СИСТЕМЕ
  IN_BRANCH                IN OUT VARCHAR2, -- КОД ФИЛИАЛА
  IN_CURRENCYCODE          IN OUT VARCHAR2, -- КОД ВАЛЮТЫ
  IN_OPERATIONDATETIME     IN OUT DATE,     -- ДАТА ОПЕРАЦИИ
  IN_BASEAMOUNT            IN OUT NUMBER,   -- СУММА (НАЦ)
  IN_CURRENCYAMOUNT        IN OUT NUMBER,   -- СУММА (ВАЛ)
  IN_EKNPCODE              IN OUT VARCHAR2, -- КНП
  IN_DOCNUMBER             IN OUT VARCHAR2, -- № ДОКУМЕНТА
  IN_DOCDATE               IN OUT DATE,     -- ДАТА ДОКУМЕНТА
  IN_DOCCATEGORY           IN OUT NUMBER,   -- КАТЕГОРИЯ ДОКУМЕНТА
  IN_DOCSUSPIC             IN OUT NUMBER,   -- ТИП ПОДОЗРИТЕЛЬНОСТИ
  IN_OPERATIONSTATUS       IN OUT NUMBER,   -- СОСТОЯНИЕ ОПЕРАЦИИ
  IN_OPERATIONREASON       IN OUT VARCHAR2, -- ОСНОВАНИЕ СОВЕРШЕНИЯ
  OUT_MESS_NUMBER          OUT NUMBER,      -- ФМ1 - НОМЕР ФОРМЫ
  OUT_MESS_DATE            OUT DATE,        -- ФМ1 - ДАТА ФОРМЫ
  OUT_MESS_KIND            OUT NUMBER,      -- ФМ1 - ВИД ДОКУМЕНТА
  OUT_MESS_STATUS          OUT NUMBER,      -- ФМ1 - ОСНОВАНИЕ ПОДАЧИ
  OUT_SUSPIC_KIND          OUT NUMBER,      -- ВИД ДОКУМЕНТА (ФМ/ПОДОЗРИТ)
  OUT_SUSPICIOUSTYPECODE   OUT NUMBER,      -- КОД КАТЕГОРИИ ФМ
  OUT_CRITERIAFIRST        OUT NUMBER,      -- ПРИЗНАК ПОДОЗРИТЕЛЬНОСТИ 1
  OUT_CRITERIASECOND       OUT NUMBER,      -- ПРИЗНАК ПОДОЗРИТЕЛЬНОСТИ 2
  OUT_CRITERIATHIRD        OUT NUMBER,      -- ПРИЗНАК ПОДОЗРИТЕЛЬНОСТИ 3
  OUT_CRITERIADIFFICULTIES OUT VARCHAR2,    -- ЗАТРУДНЕНИЯ
  OUT_OPERATIONEXTRAINFO   OUT VARCHAR2,    -- ДОПОЛНИТЕЛЬНАЯ ИНФОРМАЦИЯ
  OUT_OFFLINEOPERATIONID   OUT NUMBER,      -- ID ОПЕРАЦИИ ИЗ TB_OFFLINEOPERATIONS
  OUT_OPERATION_LIST       OUT VARCHAR2     -- СПИСОК ID ОПЕРАЦИЙ TB_OFFLINEOPERATIONS
) RETURN NUMBER IS
  v_res NUMBER; -- СТАТУС ВОЗВРАТА, ЕСЛИ СРАБАТЫВАЕТ СЦЕНАРИЙ, ТО ВОЗВРАЩАЕМ 1
  sWord VARCHAR2(50) := '';

BEGIN
  v_res := -1;

  /*************************************************************************************
  ОПИСАНИЕ СЦЕНАРИЯ:
  0131 Получение выигрыша по результатам проведения лотереи
  СУММА > = 3 000 000 KZT и Категория документа = 3,4
  И
  ОСНОВАНИЕ СОДЕРЖИТ:лотерея,лотереи

  *************************************************************************************/
  -- НАЧАЛО ПОЛЬЗОВАТЕЛЬСКОГО КОДА
  IF IN_BASEAMOUNT >= 3000000 AND IN_DOCCATEGORY IN (3,4) THEN

    IF INSTR(UPPER(IN_OPERATIONREASON), 'ЛОТЕРЕЯ') > 0 THEN
      sWord := 'ЛОТЕРЕЯ';
    ELSIF INSTR(UPPER(IN_OPERATIONREASON), 'ЛОТЕРЕИ') > 0 THEN
      sWord := 'ЛОТЕРЕИ';
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
      OUT_OPERATIONEXTRAINFO   := '[Сценарий № 0131] Разовая операция' ||
                                  chr(10) ||
                                  'Назначение платежа: '||IN_OPERATIONREASON||chr(10)||
                                  get_doc_desc(IN_DOCDATE,IN_DOCNUMBER) ||
                                  /*'Получение выигрыша, в размере > 1000000 KZT' ||
                                  chr(10) || 'КНП = 119' || chr(10) ||*/
                                  'Совпадение со словом: ' || sWord;
      IN_OPERATIONREASON       := '28';
      IN_DOCNUMBER             := '';
      IN_DOCDATE               := '';
      OUT_OFFLINEOPERATIONID   := IN_ID;
      OUT_OPERATION_LIST       := IN_ID;
      v_res                    := 1;
    END IF;

  END IF;

  -- КОНЕЦ ПОЛЬЗОВАТЕЛЬСКОГО КОДА
  RETURN v_res;
END;
/

prompt
prompt Creating function SCENARIO#0211
prompt ===============================
prompt
CREATE OR REPLACE FUNCTION AML_USER.SCENARIO#0211(IN_ID                    IN OUT NUMBER, -- ИД
                                         IN_ISSUEDBID             IN OUT NUMBER, -- БД ИСТОЧНИК
                                         IN_BANKOPERATIONID       IN OUT VARCHAR2, -- НОМЕР ОПЕРАЦИИ
                                         IN_ORDERNUMBER           IN OUT VARCHAR2, -- НОМЕР ЗАЯВКИ В СИСТЕМЕ
                                         IN_BRANCH                IN OUT VARCHAR2, -- КОД ФИЛИАЛА
                                         IN_CURRENCYCODE          IN OUT VARCHAR2, -- КОД ВАЛЮТЫ
                                         IN_OPERATIONDATETIME     IN OUT DATE, -- ДАТА ОПЕРАЦИИ
                                         IN_BASEAMOUNT            IN OUT NUMBER, -- СУММА (НАЦ)
                                         IN_CURRENCYAMOUNT        IN OUT NUMBER, -- СУММА (ВАЛ)
                                         IN_EKNPCODE              IN OUT VARCHAR2, -- КНП
                                         IN_DOCNUMBER             IN OUT VARCHAR2, -- № ДОКУМЕНТА
                                         IN_DOCDATE               IN OUT DATE, -- ДАТА ДОКУМЕНТА
                                         IN_DOCCATEGORY           IN OUT NUMBER, -- КАТЕГОРИЯ ДОКУМЕНТА
                                         IN_DOCSUSPIC             IN OUT NUMBER, -- ТИП ПОДОЗРИТЕЛЬНОСТИ
                                         IN_OPERATIONSTATUS       IN OUT NUMBER, -- СОСТОЯНИЕ ОПЕРАЦИИ
                                         IN_OPERATIONREASON       IN OUT VARCHAR2, -- ОСНОВАНИЕ СОВЕРШЕНИЯ
                                         OUT_MESS_NUMBER          OUT NUMBER, -- ФМ1 - НОМЕР ФОРМЫ
                                         OUT_MESS_DATE            OUT DATE, -- ФМ1 - ДАТА ФОРМЫ
                                         OUT_MESS_KIND            OUT NUMBER, -- ФМ1 - ВИД ДОКУМЕНТА
                                         OUT_MESS_STATUS          OUT NUMBER, -- ФМ1 - ОСНОВАНИЕ ПОДАЧИ
                                         OUT_SUSPIC_KIND          OUT NUMBER, -- ВИД ДОКУМЕНТА (ФМ/ПОДОЗРИТ)
                                         OUT_SUSPICIOUSTYPECODE   OUT NUMBER, -- КОД КАТЕГОРИИ ФМ
                                         OUT_CRITERIAFIRST        OUT NUMBER, -- ПРИЗНАК ПОДОЗРИТЕЛЬНОСТИ 1
                                         OUT_CRITERIASECOND       OUT NUMBER, -- ПРИЗНАК ПОДОЗРИТЕЛЬНОСТИ 2
                                         OUT_CRITERIATHIRD        OUT NUMBER, -- ПРИЗНАК ПОДОЗРИТЕЛЬНОСТИ 3
                                         OUT_CRITERIADIFFICULTIES OUT VARCHAR2, -- ЗАТРУДНЕНИЯ
                                         OUT_OPERATIONEXTRAINFO   OUT VARCHAR2, -- ДОПОЛНИТЕЛЬНАЯ ИНФОРМАЦИЯ
                                         OUT_OFFLINEOPERATIONID   OUT NUMBER, -- ID ОПЕРАЦИИ ИЗ TB_OFFLINEOPERATIONS
                                         OUT_OPERATION_LIST       OUT VARCHAR2 -- СПИСОК ID ОПЕРАЦИЙ TB_OFFLINEOPERATIONS
                                         )

 RETURN NUMBER IS
  v_res NUMBER; -- СТАТУС ВОЗВРАТА, ЕСЛИ СРАБАТЫВАЕТ СЦЕНАРИЙ, ТО ВОЗВРАЩАЕМ 1
  sWord VARCHAR2(50) := '';
BEGIN
  v_res := -1;

  /*************************************************************************************
  ОПИСАНИЕ СЦЕНАРИЯ:
  0221 - продажа наличной иностранной валюты через обменные пункты;
  Категория документа = 8 - покупка
  И Cумма>= 10 000 000 KZT
  И КОД БД ISSUEBD = 3
  И P_OPERATIONEXTRAINFO содержит  'ПРОДАЖА'

  *************************************************************************************/
  -- НАЧАЛО ПОЛЬЗОВАТЕЛЬСКОГО КОДА
  IF INSTR(UPPER(IN_OPERATIONREASON), 'ПРОДАЖА') > 0 THEN
    sWord := 'ПРОДАЖА';  
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
    OUT_OPERATIONEXTRAINFO   := 'Назначение платежа: ' ||
                                IN_OPERATIONREASON || chr(10) ||
                                get_doc_desc(IN_DOCDATE,IN_DOCNUMBER)/*||
                                      'Покупка, продажа и обмен наличной иностранной валюты через обменные пункты, Инициатива клиента'||chr(10)||
                                      'в размере > 7000000 KZT'*/
     ;
    IN_OPERATIONREASON       := '29';
    IN_DOCNUMBER             := '';
    IN_DOCDATE               := '';
    OUT_OFFLINEOPERATIONID   := IN_ID;
    OUT_OPERATION_LIST       := IN_ID;
    v_res                    := 1;
  END IF;
  -- КОНЕЦ ПОЛЬЗОВАТЕЛЬСКОГО КОДА
  RETURN v_res;
END;
/

prompt
prompt Creating function SCENARIO#10021
prompt ================================
prompt
CREATE OR REPLACE FUNCTION AML_USER.SCENARIO#10021(IN_ID                    IN OUT NUMBER, -- ИД
                                          IN_ISSUEDBID             IN OUT NUMBER, -- БД ИСТОЧНИК
                                          IN_BANKOPERATIONID       IN OUT VARCHAR2, -- НОМЕР ОПЕРАЦИИ
                                          IN_ORDERNUMBER           IN OUT VARCHAR2, -- НОМЕР ЗАЯВКИ В СИСТЕМЕ
                                          IN_BRANCH                IN OUT VARCHAR2, -- КОД ФИЛИАЛА
                                          IN_CURRENCYCODE          IN OUT VARCHAR2, -- КОД ВАЛЮТЫ
                                          IN_OPERATIONDATETIME     IN OUT DATE, -- ДАТА ОПЕРАЦИИ
                                          IN_BASEAMOUNT            IN OUT NUMBER, -- СУММА (НАЦ)
                                          IN_CURRENCYAMOUNT        IN OUT NUMBER, -- СУММА (ВАЛ)
                                          IN_EKNPCODE              IN OUT VARCHAR2, -- КНП
                                          IN_DOCNUMBER             IN OUT VARCHAR2, -- № ДОКУМЕНТА
                                          IN_DOCDATE               IN OUT DATE, -- ДАТА ДОКУМЕНТА
                                          IN_DOCCATEGORY           IN OUT NUMBER, -- КАТЕГОРИЯ ДОКУМЕНТА
                                          IN_DOCSUSPIC             IN OUT NUMBER, -- ТИП ПОДОЗРИТЕЛЬНОСТИ
                                          IN_OPERATIONSTATUS       IN OUT NUMBER, -- СОСТОЯНИЕ ОПЕРАЦИИ
                                          IN_OPERATIONREASON       IN OUT VARCHAR2, -- ОСНОВАНИЕ СОВЕРШЕНИЯ
                                          OUT_MESS_NUMBER          OUT NUMBER, -- ФМ1 - НОМЕР ФОРМЫ
                                          OUT_MESS_DATE            OUT DATE, -- ФМ1 - ДАТА ФОРМЫ
                                          OUT_MESS_KIND            OUT NUMBER, -- ФМ1 - ВИД ДОКУМЕНТА
                                          OUT_MESS_STATUS          OUT NUMBER, -- ФМ1 - ОСНОВАНИЕ ПОДАЧИ
                                          OUT_SUSPIC_KIND          OUT NUMBER, -- ВИД ДОКУМЕНТА (ФМ/ПОДОЗРИТ)
                                          OUT_SUSPICIOUSTYPECODE   OUT NUMBER, -- КОД КАТЕГОРИИ ФМ
                                          OUT_CRITERIAFIRST        OUT NUMBER, -- ПРИЗНАК ПОДОЗРИТЕЛЬНОСТИ 1
                                          OUT_CRITERIASECOND       OUT NUMBER, -- ПРИЗНАК ПОДОЗРИТЕЛЬНОСТИ 2
                                          OUT_CRITERIATHIRD        OUT NUMBER, -- ПРИЗНАК ПОДОЗРИТЕЛЬНОСТИ 3
                                          OUT_CRITERIADIFFICULTIES OUT VARCHAR2, -- ЗАТРУДНЕНИЯ
                                          OUT_OPERATIONEXTRAINFO   OUT VARCHAR2, -- ДОПОЛНИТЕЛЬНАЯ ИНФОРМАЦИЯ
                                          OUT_OFFLINEOPERATIONID   OUT NUMBER, -- ID ОПЕРАЦИИ ИЗ TB_OFFLINEOPERATIONS
                                          OUT_OPERATION_LIST       OUT VARCHAR2 -- СПИСОК ID ОПЕРАЦИЙ TB_OFFLINEOPERATIONS
                                          ) RETURN NUMBER IS

  v_res            NUMBER; -- СТАТУС ВОЗВРАТА, ЕСЛИ СРАБАТЫВАЕТ СЦЕНАРИЙ, ТО ВОЗВРАЩАЕМ 1
  nCount1          NUMBER := 0; -- счетчик чего либо
  v_oper_list      varchar2(4000);
  v_sum            number;
  v_count          number;
BEGIN
  v_res := -1;

  /*************************************************************************************
  ОПИСАНИЕ СЦЕНАРИЯ:
  1.22 Операция (сделка) с деньгами и (или) иным имуществом по которой возникает основание полагать,
  что данная операция (сделка) не имеет очевидного экономического смысла

  Контрольная операция:
  КД = 1,3,7,10
  И в основании платежа есть слова, характеризующий счет как депозит
  Один из участников с Client_role = 3,4
  Минимальная сумма операции - указать?

  Накопительно:
  Все операции за период = 30 календарных дней
  с категорией документа = 1,3,7,10
  Где у клиента счет = счету из контрольной операции
  И роль этого клиента = роли участника из контрольной операции

  сумма (накопительная) >=  10 млн.тг


  *************************************************************************************/
  -- НАЧАЛО ПОЛЬЗОВАТЕЛЬСКОГО КОДА

  IF IN_DOCCATEGORY IN (1, 3, 7, 10) AND is_deposit(IN_OPERATIONREASON) = 1 THEN

    SELECT COUNT(*)
    INTO   nCount1
    FROM   tb_off_members t
    WHERE  t.p_operationid = IN_ID
    AND    t.p_clientrole IN (3, 4)
    AND    instr(t.p_name, 'НАРОДНЫЙ БАНК') = 0;

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
      OUT_OPERATIONEXTRAINFO   := '[Сценарий 1002.1] Разовая операция' ||
                                  chr(10) || 'Назначение платежа: ' ||
                                  IN_OPERATIONREASON || chr(10) ||
                                  'Отправитель денег/вноситель денег на депозит не является владельцем сберегательного счета (депозита)'
                                  ||chr(10)||get_history_details(v_oper_list);
      IN_OPERATIONREASON       := '29';
      OUT_OFFLINEOPERATIONID   := IN_ID;
      OUT_OPERATION_LIST       := v_oper_list;
      v_res                    := 1;
    END IF;
  END IF;

  -- КОНЕЦ ПОЛЬЗОВАТЕЛЬСКОГО КОДА
  RETURN v_res;
END;
/

prompt
prompt Creating function SCENARIO#10022
prompt ================================
prompt
create or replace function aml_user.SCENARIO#10022(IN_ID                    in out NUMBER, -- ИД
                                         IN_ISSUEDBID             in out NUMBER, -- БД ИСТОЧНИК
                                         IN_BANKOPERATIONID       in out VARCHAR2, -- НОМЕР ОПЕРАЦИИ
                                         IN_ORDERNUMBER           in out VARCHAR2, -- НОМЕР ЗАЯВКИ В СИСТЕМЕ
                                         IN_BRANCH                in out VARCHAR2, -- КОД ФИЛИАЛА
                                         IN_CURRENCYCODE          in out VARCHAR2, -- КОД ВАЛЮТЫ
                                         IN_OPERATIONDATETIME     in out DATE, -- ДАТА ОПЕРАЦИИ
                                         IN_BASEAMOUNT            in out NUMBER, -- СУММА (НАЦ)
                                         IN_CURRENCYAMOUNT        in out NUMBER, -- СУММА (ВАЛ)
                                         IN_EKNPCODE              in out VARCHAR2, -- КНП
                                         IN_DOCNUMBER             in out VARCHAR2, -- № ДОКУМЕНТА
                                         IN_DOCDATE               in out DATE, -- ДАТА ДОКУМЕНТА
                                         IN_DOCCATEGORY           in out NUMBER, -- КАТЕГОРИЯ ДОКУМЕНТА
                                         IN_DOCSUSPIC             in out NUMBER, -- ТИП ПОДОЗРИТЕЛЬНОСТИ
                                         IN_OPERATIONSTATUS       in out NUMBER, -- СОСТОЯНИЕ ОПЕРАЦИИ
                                         IN_OPERATIONREASON       in out VARCHAR2, -- ОСНОВАНИЕ СОВЕРШЕНИЯ
                                         OUT_MESS_NUMBER          out NUMBER, -- ФМ1 - НОМЕР ФОРМЫ
                                         OUT_MESS_DATE            out DATE, -- ФМ1 - ДАТА ФОРМЫ
                                         OUT_MESS_KIND            out NUMBER, -- ФМ1 - ВИД ДОКУМЕНТА
                                         OUT_MESS_STATUS          out NUMBER, -- ФМ1 - ОСНОВАНИЕ ПОДАЧИ
                                         OUT_SUSPIC_KIND          out NUMBER, -- ВИД ДОКУМЕНТА (ФМ/ПОДОЗРИТ)
                                         OUT_SUSPICIOUSTYPECODE   out NUMBER, -- КОД КАТЕГОРИИ ФМ
                                         OUT_CRITERIAFIRST        out NUMBER, -- ПРИЗНАК ПОДОЗРИТЕЛЬНОСТИ 1
                                         OUT_CRITERIASECOND       out NUMBER, -- ПРИЗНАК ПОДОЗРИТЕЛЬНОСТИ 2
                                         OUT_CRITERIATHIRD        out NUMBER, -- ПРИЗНАК ПОДОЗРИТЕЛЬНОСТИ 3
                                         OUT_CRITERIADIFFICULTIES out VARCHAR2, -- ЗАТРУДНЕНИЯ
                                         OUT_OPERATIONEXTRAINFO   out VARCHAR2, -- ДОПОЛНИТЕЛЬНАЯ ИНФОРМАЦИЯ
                                         OUT_OFFLINEOPERATIONID   out NUMBER, -- ID ОПЕРАЦИИ ИЗ TB_OFFLINEOPERATIONS
                                         OUT_OPERATION_LIST       out VARCHAR2 -- СПИСОК ID ОПЕРАЦИЙ TB_OFFLINEOPERATIONS
                                         )

 return number is
  v_res  number; -- СТАТУС ВОЗВРАТА, ЕСЛИ СРАБАТЫВАЕТ СЦЕНАРИЙ, ТО ВОЗВРАЩАЕМ 1
  nCheck number(1) := 0; -- статус проверки, 0 все нормально, 1 сработала проверка
  nCount number := 0; -- счетчик чего либо
begin
  v_res := -1;

  /*************************************************************************************
  ОПИСАНИЕ СЦЕНАРИЯ:
  1.22 Операция (сделка) с деньгами и (или) иным имуществом по которой возникает основание полагать,
  что данная операция (сделка) не имеет очевидного экономического смысла

    (Получатель = нерезидент
    И
    Отправитель = нерезидент)
    И
    Сумма > 15 000 000 KZT

  *************************************************************************************/
  -- НАЧАЛО ПОЛЬЗОВАТЕЛЬСКОГО КОДА

  if IN_BASEAMOUNT >= 15000000 then

    -- найдем, в начале, (Получатель = нерезидент
    Select count(1)
      into nCheck
      From tb_off_members t
     where t.p_operationid = IN_ID
       and p_clientrole in (1, 2)
       and p_countrycode != 398
       and instr(t.p_name, 'НАРОДНЫЙ БАНК') = 0;

    select count(1)
      into nCount
      from (select count(1)
              from tb_off_members t
             where t.p_operationid = IN_ID
               and p_countrycode != 398
               and p_clientrole in (1, 2)
               and instr(t.p_name, 'НАРОДНЫЙ БАНК') = 0
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
      OUT_OPERATIONEXTRAINFO   := '[Сценарий № 1002.2] Разовая операция' ||
                                  chr(10) || 'Назначение платежа: ' ||
                                  IN_OPERATIONREASON || chr(10) ||
                                  'Операция (сделка) с деньгами и (или) иным имуществом по которой возникает основание полагать,' ||
                                  chr(10) ||
                                  'что данная операция (сделка) не имеет очевидного экономического смысла' ||
                                  chr(10) ||
                                  'Получатель и отправитель нерезиденты , в размере > 15000000 KZT';
      IN_OPERATIONREASON       := '29';
      OUT_OFFLINEOPERATIONID   := IN_ID;
      OUT_OPERATION_LIST       := IN_ID;
      v_res                    := 1;
    end if;
  end if;

  -- КОНЕЦ ПОЛЬЗОВАТЕЛЬСКОГО КОДА
  return v_res;
end;
/

prompt
prompt Creating function SCENARIO#10023
prompt ================================
prompt
create or replace function aml_user.SCENARIO#10023(IN_ID                    in out NUMBER, -- ИД
                                         IN_ISSUEDBID             in out NUMBER, -- БД ИСТОЧНИК
                                         IN_BANKOPERATIONID       in out VARCHAR2, -- НОМЕР ОПЕРАЦИИ
                                         IN_ORDERNUMBER           in out VARCHAR2, -- НОМЕР ЗАЯВКИ В СИСТЕМЕ
                                         IN_BRANCH                in out VARCHAR2, -- КОД ФИЛИАЛА
                                         IN_CURRENCYCODE          in out VARCHAR2, -- КОД ВАЛЮТЫ
                                         IN_OPERATIONDATETIME     in out DATE, -- ДАТА ОПЕРАЦИИ
                                         IN_BASEAMOUNT            in out NUMBER, -- СУММА (НАЦ)
                                         IN_CURRENCYAMOUNT        in out NUMBER, -- СУММА (ВАЛ)
                                         IN_EKNPCODE              in out VARCHAR2, -- КНП
                                         IN_DOCNUMBER             in out VARCHAR2, -- № ДОКУМЕНТА
                                         IN_DOCDATE               in out DATE, -- ДАТА ДОКУМЕНТА
                                         IN_DOCCATEGORY           in out NUMBER, -- КАТЕГОРИЯ ДОКУМЕНТА
                                         IN_DOCSUSPIC             in out NUMBER, -- ТИП ПОДОЗРИТЕЛЬНОСТИ
                                         IN_OPERATIONSTATUS       in out NUMBER, -- СОСТОЯНИЕ ОПЕРАЦИИ
                                         IN_OPERATIONREASON       in out VARCHAR2, -- ОСНОВАНИЕ СОВЕРШЕНИЯ
                                         OUT_MESS_NUMBER          out NUMBER, -- ФМ1 - НОМЕР ФОРМЫ
                                         OUT_MESS_DATE            out DATE, -- ФМ1 - ДАТА ФОРМЫ
                                         OUT_MESS_KIND            out NUMBER, -- ФМ1 - ВИД ДОКУМЕНТА
                                         OUT_MESS_STATUS          out NUMBER, -- ФМ1 - ОСНОВАНИЕ ПОДАЧИ
                                         OUT_SUSPIC_KIND          out NUMBER, -- ВИД ДОКУМЕНТА (ФМ/ПОДОЗРИТ)
                                         OUT_SUSPICIOUSTYPECODE   out NUMBER, -- КОД КАТЕГОРИИ ФМ
                                         OUT_CRITERIAFIRST        out NUMBER, -- ПРИЗНАК ПОДОЗРИТЕЛЬНОСТИ 1
                                         OUT_CRITERIASECOND       out NUMBER, -- ПРИЗНАК ПОДОЗРИТЕЛЬНОСТИ 2
                                         OUT_CRITERIATHIRD        out NUMBER, -- ПРИЗНАК ПОДОЗРИТЕЛЬНОСТИ 3
                                         OUT_CRITERIADIFFICULTIES out VARCHAR2, -- ЗАТРУДНЕНИЯ
                                         OUT_OPERATIONEXTRAINFO   out VARCHAR2, -- ДОПОЛНИТЕЛЬНАЯ ИНФОРМАЦИЯ
                                         OUT_OFFLINEOPERATIONID   out NUMBER, -- ID ОПЕРАЦИИ ИЗ TB_OFFLINEOPERATIONS
                                         OUT_OPERATION_LIST       out VARCHAR2 -- СПИСОК ID ОПЕРАЦИЙ TB_OFFLINEOPERATIONS
                                         )

 return number is
  v_res  number; -- СТАТУС ВОЗВРАТА, ЕСЛИ СРАБАТЫВАЕТ СЦЕНАРИЙ, ТО ВОЗВРАЩАЕМ 1
  nCheck number(1) := 0; -- статус проверки, 0 все нормально, 1 сработала проверка
  nCount number := 0; -- счетчик чего либо
begin
  v_res := -1;

  /*************************************************************************************
  ОПИСАНИЕ СЦЕНАРИЯ:
  1.3 Осуществление платежей, переводов или зачисление денег на депозит в пользу третьего лица,
  не имеющего очевидного экономического смысла

    КНП = 119, 110
    И
    Получатель = Китай
    И
    Отправитель = резидент
    И
    СУММА = 1 500 000 KZT


  *************************************************************************************/
  -- НАЧАЛО ПОЛЬЗОВАТЕЛЬСКОГО КОДА
  if IN_BASEAMOUNT >= 2000000 then

    if IN_EKNPCODE in ('119', '110') then
      if instr(UPPER(IN_OPERATIONREASON),
               'ЦЕЛЕВОЙ ВКЛАД НА ДЕТЕЙ') > 0 or
         instr(UPPER(IN_OPERATIONREASON), 'АК БОТА') > 0 or
         instr(UPPER(IN_OPERATIONREASON), 'НАРОДНЫЙ ДЕТСКИЙ') > 0 or
         instr(UPPER(IN_OPERATIONREASON), 'HALYK-ДЕТСКИЙ') > 0 or
         instr(UPPER(IN_OPERATIONREASON), 'HALYK - ДЕТСКИЙ 2011') > 0 then
        -- найдем, в начале, Получатель = Китай
        Select count(1)
          into nCount
          From tb_off_members t
         where t.p_operationid = IN_ID
           and p_clientrole = 2
           and p_countrycode = 156
           and instr(t.p_name, 'НАРОДНЫЙ БАНК') = 0;

        if nCount > 0 then
          -- если нашли, то найдем Отправитель = резидент
          Select count(1)
            into nCheck
            From tb_off_members t
           where t.p_operationid = IN_ID
             and p_clientrole = 1
             and p_countrycode = 398
             and instr(t.p_name, 'НАРОДНЫЙ БАНК') = 0;
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
          OUT_OPERATIONEXTRAINFO   := '[Сценарий № 1002.3] Разовая операция' ||
                                      chr(10) || 'Назначение платежа: ' ||
                                      IN_OPERATIONREASON || chr(10) ||
                                      'Осуществление платежей, переводов или зачисление денег на депозит в пользу ' ||
                                      chr(10) ||
                                      'третьего лица, в размере > 1500000 KZT';
          IN_OPERATIONREASON       := '29';
          OUT_OFFLINEOPERATIONID   := IN_ID;
          OUT_OPERATION_LIST       := IN_ID;
          v_res                    := 1;
        end if;
      end if;
    end if;
  end if;
  -- КОНЕЦ ПОЛЬЗОВАТЕЛЬСКОГО КОДА
  return v_res;
end;
/

prompt
prompt Creating function SCENARIO#10024
prompt ================================
prompt
create or replace function aml_user.SCENARIO#10024(IN_ID                    in out NUMBER, -- ИД
                                         IN_ISSUEDBID             in out NUMBER, -- БД ИСТОЧНИК
                                         IN_BANKOPERATIONID       in out VARCHAR2, -- НОМЕР ОПЕРАЦИИ
                                         IN_ORDERNUMBER           in out VARCHAR2, -- НОМЕР ЗАЯВКИ В СИСТЕМЕ
                                         IN_BRANCH                in out VARCHAR2, -- КОД ФИЛИАЛА
                                         IN_CURRENCYCODE          in out VARCHAR2, -- КОД ВАЛЮТЫ
                                         IN_OPERATIONDATETIME     in out DATE, -- ДАТА ОПЕРАЦИИ
                                         IN_BASEAMOUNT            in out NUMBER, -- СУММА (НАЦ)
                                         IN_CURRENCYAMOUNT        in out NUMBER, -- СУММА (ВАЛ)
                                         IN_EKNPCODE              in out VARCHAR2, -- КНП
                                         IN_DOCNUMBER             in out VARCHAR2, -- № ДОКУМЕНТА
                                         IN_DOCDATE               in out DATE, -- ДАТА ДОКУМЕНТА
                                         IN_DOCCATEGORY           in out NUMBER, -- КАТЕГОРИЯ ДОКУМЕНТА
                                         IN_DOCSUSPIC             in out NUMBER, -- ТИП ПОДОЗРИТЕЛЬНОСТИ
                                         IN_OPERATIONSTATUS       in out NUMBER, -- СОСТОЯНИЕ ОПЕРАЦИИ
                                         IN_OPERATIONREASON       in out VARCHAR2, -- ОСНОВАНИЕ СОВЕРШЕНИЯ
                                         OUT_MESS_NUMBER          out NUMBER, -- ФМ1 - НОМЕР ФОРМЫ
                                         OUT_MESS_DATE            out DATE, -- ФМ1 - ДАТА ФОРМЫ
                                         OUT_MESS_KIND            out NUMBER, -- ФМ1 - ВИД ДОКУМЕНТА
                                         OUT_MESS_STATUS          out NUMBER, -- ФМ1 - ОСНОВАНИЕ ПОДАЧИ
                                         OUT_SUSPIC_KIND          out NUMBER, -- ВИД ДОКУМЕНТА (ФМ/ПОДОЗРИТ)
                                         OUT_SUSPICIOUSTYPECODE   out NUMBER, -- КОД КАТЕГОРИИ ФМ
                                         OUT_CRITERIAFIRST        out NUMBER, -- ПРИЗНАК ПОДОЗРИТЕЛЬНОСТИ 1
                                         OUT_CRITERIASECOND       out NUMBER, -- ПРИЗНАК ПОДОЗРИТЕЛЬНОСТИ 2
                                         OUT_CRITERIATHIRD        out NUMBER, -- ПРИЗНАК ПОДОЗРИТЕЛЬНОСТИ 3
                                         OUT_CRITERIADIFFICULTIES out VARCHAR2, -- ЗАТРУДНЕНИЯ
                                         OUT_OPERATIONEXTRAINFO   out VARCHAR2, -- ДОПОЛНИТЕЛЬНАЯ ИНФОРМАЦИЯ
                                         OUT_OFFLINEOPERATIONID   out NUMBER, -- ID ОПЕРАЦИИ ИЗ TB_OFFLINEOPERATIONS
                                         OUT_OPERATION_LIST       out VARCHAR2 -- СПИСОК ID ОПЕРАЦИЙ TB_OFFLINEOPERATIONS
                                         )

 return number is
  v_res  number; -- СТАТУС ВОЗВРАТА, ЕСЛИ СРАБАТЫВАЕТ СЦЕНАРИЙ, ТО ВОЗВРАЩАЕМ 1
  nCheck number(1) := 0; -- статус проверки, 0 все нормально, 1 сработала проверка
  nCount number := 0; -- счетчик чего либо
begin
  v_res := -1;

  /*************************************************************************************
  ОПИСАНИЕ СЦЕНАРИЯ:
  1.3 Осуществление платежей, переводов или зачисление денег на депозит в пользу третьего лица,
  не имеющего очевидного экономического смысла

    КНП = 110,111, 112,119
    И
    Получатель = (ФЛ И резидент)
    И
    Отправитель = (ФЛ И резидент)
    И
    СУММА >= 10 000 000 KZT


  *************************************************************************************/
  -- НАЧАЛО ПОЛЬЗОВАТЕЛЬСКОГО КОДА
  if IN_BASEAMOUNT >= 10000000 then
    if IN_EKNPCODE in ('110', '111', '112', '119') then
      if instr(UPPER(IN_OPERATIONREASON),
               'ЦЕЛЕВОЙ ВКЛАД НА ДЕТЕЙ') > 0 or
         instr(UPPER(IN_OPERATIONREASON), 'АК БОТА') > 0 or
         instr(UPPER(IN_OPERATIONREASON), 'НАРОДНЫЙ ДЕТСКИЙ') > 0 or
         instr(UPPER(IN_OPERATIONREASON), 'HALYK-ДЕТСКИЙ') > 0 or
         instr(UPPER(IN_OPERATIONREASON), 'HALYK - ДЕТСКИЙ 2011') > 0 then
        -- найдем, в начале, Получатель = (ФЛ И резидент)
        Select count(1)
          into nCount
          From tb_off_members t
         where t.p_operationid = IN_ID
           and t.p_clientrole = 2
           and t.p_countrycode = 398
           and t.p_client_type = 2
           and instr(t.p_name, 'НАРОДНЫЙ БАНК') = 0;

        if nCount > 0 then
          -- если нашли, то найдем Отправитель = (ФЛ И резидент)
          Select count(1)
            into nCheck
            From tb_off_members t
           where t.p_operationid = IN_ID
             and p_clientrole = 1
             and p_countrycode = 398
             and t.p_client_type = 2
             and instr(t.p_name, 'НАРОДНЫЙ БАНК') = 0;
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
          OUT_OPERATIONEXTRAINFO   := '[Сценарий № 1002.4] Разовая операция' ||
                                      chr(10) || 'Назначение платежа: ' ||
                                      IN_OPERATIONREASON || chr(10) ||
                                      'Осуществление платежей, переводов или зачисление денег на депозит в пользу ' ||
                                      chr(10) ||
                                      'третьего лица, в размере > 10000000 KZT';
          IN_OPERATIONREASON       := '29';
          OUT_OFFLINEOPERATIONID   := IN_ID;
          OUT_OPERATION_LIST       := IN_ID;
          v_res                    := 1;
        end if;
      end if;
    end if;
  end if;
  -- КОНЕЦ ПОЛЬЗОВАТЕЛЬСКОГО КОДА
  return v_res;
end;
/

prompt
prompt Creating function SCENARIO#10025
prompt ================================
prompt
create or replace function aml_user.SCENARIO#10025(IN_ID                    in out NUMBER, -- ИД
                                         IN_ISSUEDBID             in out NUMBER, -- БД ИСТОЧНИК
                                         IN_BANKOPERATIONID       in out VARCHAR2, -- НОМЕР ОПЕРАЦИИ
                                         IN_ORDERNUMBER           in out VARCHAR2, -- НОМЕР ЗАЯВКИ В СИСТЕМЕ
                                         IN_BRANCH                in out VARCHAR2, -- КОД ФИЛИАЛА
                                         IN_CURRENCYCODE          in out VARCHAR2, -- КОД ВАЛЮТЫ
                                         IN_OPERATIONDATETIME     in out DATE, -- ДАТА ОПЕРАЦИИ
                                         IN_BASEAMOUNT            in out NUMBER, -- СУММА (НАЦ)
                                         IN_CURRENCYAMOUNT        in out NUMBER, -- СУММА (ВАЛ)
                                         IN_EKNPCODE              in out VARCHAR2, -- КНП
                                         IN_DOCNUMBER             in out VARCHAR2, -- № ДОКУМЕНТА
                                         IN_DOCDATE               in out DATE, -- ДАТА ДОКУМЕНТА
                                         IN_DOCCATEGORY           in out NUMBER, -- КАТЕГОРИЯ ДОКУМЕНТА
                                         IN_DOCSUSPIC             in out NUMBER, -- ТИП ПОДОЗРИТЕЛЬНОСТИ
                                         IN_OPERATIONSTATUS       in out NUMBER, -- СОСТОЯНИЕ ОПЕРАЦИИ
                                         IN_OPERATIONREASON       in out VARCHAR2, -- ОСНОВАНИЕ СОВЕРШЕНИЯ
                                         OUT_MESS_NUMBER          out NUMBER, -- ФМ1 - НОМЕР ФОРМЫ
                                         OUT_MESS_DATE            out DATE, -- ФМ1 - ДАТА ФОРМЫ
                                         OUT_MESS_KIND            out NUMBER, -- ФМ1 - ВИД ДОКУМЕНТА
                                         OUT_MESS_STATUS          out NUMBER, -- ФМ1 - ОСНОВАНИЕ ПОДАЧИ
                                         OUT_SUSPIC_KIND          out NUMBER, -- ВИД ДОКУМЕНТА (ФМ/ПОДОЗРИТ)
                                         OUT_SUSPICIOUSTYPECODE   out NUMBER, -- КОД КАТЕГОРИИ ФМ
                                         OUT_CRITERIAFIRST        out NUMBER, -- ПРИЗНАК ПОДОЗРИТЕЛЬНОСТИ 1
                                         OUT_CRITERIASECOND       out NUMBER, -- ПРИЗНАК ПОДОЗРИТЕЛЬНОСТИ 2
                                         OUT_CRITERIATHIRD        out NUMBER, -- ПРИЗНАК ПОДОЗРИТЕЛЬНОСТИ 3
                                         OUT_CRITERIADIFFICULTIES out VARCHAR2, -- ЗАТРУДНЕНИЯ
                                         OUT_OPERATIONEXTRAINFO   out VARCHAR2, -- ДОПОЛНИТЕЛЬНАЯ ИНФОРМАЦИЯ
                                         OUT_OFFLINEOPERATIONID   out NUMBER, -- ID ОПЕРАЦИИ ИЗ TB_OFFLINEOPERATIONS
                                         OUT_OPERATION_LIST       out VARCHAR2 -- СПИСОК ID ОПЕРАЦИЙ TB_OFFLINEOPERATIONS
                                         )

 return number is
  v_res  number; -- СТАТУС ВОЗВРАТА, ЕСЛИ СРАБАТЫВАЕТ СЦЕНАРИЙ, ТО ВОЗВРАЩАЕМ 1
  nCheck number(1) := 0; -- статус проверки, 0 все нормально, 1 сработала проверка
  nCount number := 0; -- счетчик чего либо
begin
  v_res := -1;

  /*************************************************************************************
  ОПИСАНИЕ СЦЕНАРИЯ:
  1.3 Осуществление платежей, переводов или зачисление денег на депозит в пользу третьего лица,
  не имеющего очевидного экономического смысла

    КНП =  111, 112
    И
    Получатель = (ФЛ И нерезидент)
    И
    Отправитель = (ФЛ И резидент)
    И
    СУММА >= 2 000 000 KZT

  *************************************************************************************/
  -- НАЧАЛО ПОЛЬЗОВАТЕЛЬСКОГО КОДА
  if IN_BASEAMOUNT >= 2000000 then
    if IN_EKNPCODE in ('111', '112') then
      if instr(UPPER(IN_OPERATIONREASON),
               'ЦЕЛЕВОЙ ВКЛАД НА ДЕТЕЙ') > 0 or
         instr(UPPER(IN_OPERATIONREASON), 'АК БОТА') > 0 or
         instr(UPPER(IN_OPERATIONREASON), 'НАРОДНЫЙ ДЕТСКИЙ') > 0 or
         instr(UPPER(IN_OPERATIONREASON), 'HALYK-ДЕТСКИЙ') > 0 or
         instr(UPPER(IN_OPERATIONREASON), 'HALYK - ДЕТСКИЙ 2011') > 0 then
        -- найдем, в начале, Получатель = (ФЛ И нерезидент)
        Select count(1)
          into nCount
          From tb_off_members t
         where t.p_operationid = IN_ID
           and t.p_clientrole = 2
           and t.p_countrycode != 398
           and t.p_client_type = 2
           and instr(t.p_name, 'НАРОДНЫЙ БАНК') = 0;

        if nCount > 0 then
          -- если нашли, то найдем Отправитель = (ФЛ И резидент)
          Select count(1)
            into nCheck
            From tb_off_members t
           where t.p_operationid = IN_ID
             and p_clientrole = 1
             and p_countrycode = 398
             and t.p_client_type = 2
             and instr(t.p_name, 'НАРОДНЫЙ БАНК') = 0;
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
          OUT_OPERATIONEXTRAINFO   := '[Сценарий № 1002.5] Разовая операция' ||
                                      chr(10) || 'Назначение платежа: ' ||
                                      IN_OPERATIONREASON || chr(10) ||
                                      'Осуществление платежей, переводов или зачисление денег на депозит в пользу ' ||
                                      chr(10) ||
                                      'третьего лица, в размере > 2000000 KZT';
          IN_OPERATIONREASON       := '29';
          OUT_OFFLINEOPERATIONID   := IN_ID;
          OUT_OPERATION_LIST       := IN_ID;
          v_res                    := 1;
        end if;
      end if;
    end if;
  end if;
  -- КОНЕЦ ПОЛЬЗОВАТЕЛЬСКОГО КОДА
  return v_res;
end;
/