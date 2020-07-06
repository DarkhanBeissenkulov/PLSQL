prompt
prompt Creating procedure CHECK_REQUIS_ENCASH_DICTAT
prompt =============================================
prompt
CREATE OR REPLACE PROCEDURE UNIFORM_CARD_INDEX.CHECK_REQUIS_ENCASH_DICTAT (client_ in client.client%type) IS
  PROCNAME VARCHAR2(50) := 'CHECK_REQUIS_ENCASH_DICTAT';
  E_ERROR EXCEPTION;
  V_ACCOUNT_NUMBER_     UNIFORM_CARD_INDEX.MT_BODY.ACCOUNT_NUMBER%TYPE;
  V_RNN_CLIENT_         UNIFORM_CARD_INDEX.MT_BODY.RNN_CLIENT%TYPE;
  V_BIK_CLIENT_         UNIFORM_CARD_INDEX.MT_BODY.BIK_CLIENT%TYPE;
  BANK_SYSTEM_          UNIFORM_CARD_INDEX.MT_BODY.G_BANK_SYSTEM%TYPE;
  V_SYSTEM_CODE_        UNIFORM_CARD_INDEX.G_BANK_SYSTEMS.SYSTEM_CODE%TYPE;
  V_NONACCEPTANCE_      UNIFORM_CARD_INDEX.G_NONACCEPTANCE.G_NONACCEPTANCE%TYPE;
  CHECK_MESSAGE_        UNIFORM_CARD_INDEX.G_NONACCEPTANCE.NAME_RUS%TYPE;
  V_BANK_SYSTEM_        VARCHAR2(2);
  BASE_RNN_             VARCHAR2(12);
  OUT_MESSAGE           VARCHAR2(1000);
  RESULT_               VARCHAR2(10);
  STATUS_               VARCHAR2(50);
  KNP_COUNT             NUMBER;
  KBK_COUNT             NUMBER;
  CHECK_MESSAGE_CODE_   NUMBER;
  OUT_MESSAGE_CODE      NUMBER;
  OUT_HIS_ACCOUNT_BLOCK NUMBER;
  G_Status_             number;
  Oper_Type_            varchar2(10);
  Name_Client_          varchar2(500);
  Name_Client_DD        varchar2(500);
  Podpisant1            varchar2(500);
  Podpisant2            varchar2(500);
  Err_PTP               number;
  Doc_ID_               number;
  Event_Code_           UNIFORM_CARD_INDEX.G_EVENTS.CODE%TYPE;
  Spec_FL_              number;
  g_dd_                 Uniform_Card_Index.Document_Detail.g_Document_Detail%type;
  dbz_no_               Uniform_Card_Index.Document_Detail.Dbz_No%type;
  dbz_date_             Uniform_Card_Index.Document_Detail.Dbz_Date%type;
  DBZ_Name              varchar2(255);
  -- Запрос SD 3625662 от 31.03.2016г.
  NAME_NK_LST           UNIFORM_CARD_INDEX.BIN_BENEFICIAR_LST.NAME_NK%TYPE;
  OPER_TYPE_LST         UNIFORM_CARD_INDEX.BIN_BENEFICIAR_LST.OPER_TYPE%TYPE;
  RNN_NK_LST            UNIFORM_CARD_INDEX.BIN_BENEFICIAR_LST.RNN_NK%TYPE;
  -- end Запрос SD 3625662 от 31.03.2016г.
  CURRENCY_ACCOUNT_     UNIFORM_CARD_INDEX.MT_BODY.CURRENCY_ACCOUNT%TYPE;
  SWIFT_ACCOUNT_        VARCHAR2(3);
  ACCOUNT_NUMBER_ESCROW UNIFORM_CARD_INDEX.MT_BODY.ACCOUNT_NUMBER%TYPE;
  cnt                   NUMBER;
  SYSTAME_CODE_         VARCHAR2(200);
  V_Contract_status varchar2(500);
  Unuse_close_ow NUMBER;
  V_date_expire DATE;
    V_is_ready VARCHAR2(5);
  TYPE TREC IS RECORD(
    MT_BODY_        UNIFORM_CARD_INDEX.MT_BODY.MT_BODY%TYPE,
    INGOING_MT_     UNIFORM_CARD_INDEX.MT_BODY.INGOING_MT%TYPE,
    ACCOUNT_NUMBER_ UNIFORM_CARD_INDEX.MT_BODY.ACCOUNT_NUMBER%TYPE,
    RNN_CLIENT_     UNIFORM_CARD_INDEX.MT_BODY.RNN_CLIENT%TYPE,
    BIK_CLIENT_     UNIFORM_CARD_INDEX.MT_BODY.BIK_CLIENT%TYPE,
    PAY_SUMM_       UNIFORM_CARD_INDEX.MT_BODY.PAY_SUMM%TYPE,
    DOC_NUMBER_     UNIFORM_CARD_INDEX.MT_BODY.DOC_NUMBER%TYPE,
    DOC_DATE_       UNIFORM_CARD_INDEX.MT_BODY.DOC_DATE%TYPE,
    CODE3_          UNIFORM_CARD_INDEX.G_CURRENCY.CODE3%TYPE,
    G_ORDER_TYPE_   UNIFORM_CARD_INDEX.MT_BODY.G_ORDER_TYPE%TYPE,
    KNP_            UNIFORM_CARD_INDEX.MT_BODY.KNP%TYPE,
    KBK_            UNIFORM_CARD_INDEX.MT_BODY.BCLASS%TYPE,
    OPER_TYPE_      UNIFORM_CARD_INDEX.MT_BODY.OPER_TYPE%TYPE,
    Name_Client_    UNIFORM_CARD_INDEX.MT_BODY.NAME_CLIENT%TYPE,
    Doc_Nuber_DD    UNIFORM_CARD_INDEX.MT_BODY.DD_DOC_NUMBER%TYPE,
    Doc_Date_DD     UNIFORM_CARD_INDEX.MT_BODY.DD_DOC_DATE%TYPE,
    G_DD            UNIFORM_CARD_INDEX.MT_BODY.G_DOCUMENT_DETAIL%TYPE,
    Kod             varchar2(10),
    Kbe             varchar2(10),
    Create_Time_    UNIFORM_CARD_INDEX.MT_BODY.CREATE_TIME%TYPE,
    client          UNIFORM_CARD_INDEX.MT_BODY.CLIENT%type,
    -- Запрос SD 3625662 от 31.03.2016г.
    RNN_NK_         UNIFORM_CARD_INDEX.MT_BODY.RNN_NK%TYPE,
    NAME_NK_        UNIFORM_CARD_INDEX.MT_BODY.NAME_NK%TYPE,
    -- end Запрос SD 3625662 от 31.03.2016г.
    -- MMD5014
    ACCOUNT_NK_     UNIFORM_CARD_INDEX.MT_BODY.ACCOUNT_NK%TYPE,
    BIK_NK_         UNIFORM_CARD_INDEX.MT_BODY.BIK_NK%TYPE
    -- end MMD5014
    );
  REC TREC;
  CURSOR CUR IS
    SELECT M.MT_BODY, M.INGOING_MT, M.ACCOUNT_NUMBER, M.RNN_CLIENT,
           M.BIK_CLIENT, M.PAY_SUMM, M.DOC_NUMBER, M.DOC_DATE, GC.CODE3,
           M.G_ORDER_TYPE, M.KNP, M.BCLASS, M.OPER_TYPE, KazWin_UTF(m.name_client),
           m.dd_doc_number, m.dd_doc_date, m.g_document_detail,
           m.resident_client||m.econ_sector_client as kod,
           m.resident_nk||m.econ_sector_nk as kbe, to_date(m.create_time),m.client,
           -- Запрос SD 3625662 от 31.03.2016г.
           m.rnn_nk, m.name_nk,
           -- end Запрос SD 3625662 от 31.03.2016г.
           -- MMD5014
           m.ACCOUNT_NK, m.BIK_NK
           -- end MMD5014
    FROM   MT_BODY M, G_CURRENCY GC
    WHERE  M.G_STATUS = 1
       AND m.client=client_
         AND m.client is not null
           AND M.MT_REFERENCE IS NOT NULL
           AND M.G_CURRENCY = GC.G_CURRENCY
           AND (
                    (
                        m.load_time < (TRUNC(sysdate)+17/24) AND client_ = 4
                    ) 
                    or 
                    client_ != 4
                )
    ORDER  BY M.MT_BODY;
BEGIN
    -- Check for operday is opened
    if(uci_pe.is_oper_time(5) = false) then
        return;
    end if;
  OPEN CUR;
  LOOP
    BEGIN
    FETCH CUR
      INTO REC;
    EXIT WHEN CUR%NOTFOUND;
    OUT_MESSAGE       := '';
    Spec_FL_:=0; --обнуление перед новым циклом
    V_ACCOUNT_NUMBER_ := UPPER(TRIM(REC.ACCOUNT_NUMBER_));
    V_RNN_CLIENT_     := TRIM(REC.RNN_CLIENT_);
    V_BIK_CLIENT_     := UPPER(TRIM(REC.BIK_CLIENT_));
    V_BANK_SYSTEM_    := SUBSTR(TRIM(V_ACCOUNT_NUMBER_), 11, 1);
    IF (LENGTH(V_ACCOUNT_NUMBER_) = 20) AND (V_BIK_CLIENT_ = 'HSBKKZKX') THEN
      IF V_BANK_SYSTEM_ = '1' THEN
        --Colvir корпоративный
        BEGIN
      SELECT V_BS.RNN, 'CBS', V_BS.CLI_LONGNAME,
      CASE WHEN (REC.G_ORDER_TYPE_ not in (1,6) or (REC.G_ORDER_TYPE_ in (1,6) AND REC.ACCOUNT_NK_ = 'KZ24070105KSN0000000'))
                 AND ACCOUNTS_BLOCK.GET_ACCOUNT_INFO(V_ACCOUNT_NUMBER_,'ACC_TYPE_ID') = 375
           THEN 2                                                                        --Эскроу счет в тенге
           WHEN (REC.G_ORDER_TYPE_ not in (1,6) or (REC.G_ORDER_TYPE_ in (1,6) AND REC.ACCOUNT_NK_ = 'KZ24070105KSN0000000'))
                 AND ACCOUNTS_BLOCK.GET_ACCOUNT_INFO(V_ACCOUNT_NUMBER_,'ACC_TYPE_ID') = 376
           THEN 3                                                                        --Эскроу счет в тенге
           WHEN (REC.G_ORDER_TYPE_ not in (1,6) or (REC.G_ORDER_TYPE_ in (1,6) AND REC.ACCOUNT_NK_ = 'KZ24070105KSN0000000'))
                 AND EXISTS (SELECT 1 FROM ca, ab, ACCOUNTS_BLOCK.G_BLOCK_KINDS BK
                 WHERE ca.ACCOUNT_NUMBER = V_ACCOUNT_NUMBER_ AND ca.G_BANK_SYSTEM = 2
                 AND ab.CLIENT_ACCOUNT = ca.CLIENT_ACCOUNT AND ab.G_BLOCK_KIND = BK.G_BLOCK_KIND AND BK.BLOCK_CODE = 'B_LIM_ESCROW')
           THEN 4                                                                        --Эскроу лимит
           WHEN (REC.G_ORDER_TYPE_ not in (1,6) or (REC.G_ORDER_TYPE_ in (1,6) AND REC.ACCOUNT_NK_ = 'KZ24070105KSN0000000'))
                 AND EXISTS (SELECT 1 FROM ca, ab, ACCOUNTS_BLOCK.G_BLOCK_KINDS BK
                 WHERE ca.ACCOUNT_NUMBER = V_ACCOUNT_NUMBER_ AND ca.G_BANK_SYSTEM = 2
                 AND ab.CLIENT_ACCOUNT = ca.CLIENT_ACCOUNT AND ab.G_BLOCK_KIND = BK.G_BLOCK_KIND AND BK.BLOCK_CODE = 'B_ESCROW')
           THEN 5 ELSE 0                                                                 --Эскроу блок
      END  RESULT_, V_BS.ACCTYP
      INTO   BASE_RNN_, V_SYSTEM_CODE_, Name_Client_,
             RESULT_, SYSTAME_CODE_
      FROM   COLVIR.ZV_EK_ACCOUNT@AUCI_CBS3C V_BS
      WHERE  V_BS.CODE_ACC = V_ACCOUNT_NUMBER_
             AND ROWNUM = 1;
    IF    RESULT_ = 2
      THEN OUT_MESSAGE := 'Ограничение по Эскроу счету в тенге ' ||V_ACCOUNT_NUMBER_||' c кодом продукта:'||SYSTAME_CODE_; V_NONACCEPTANCE_:=2; GOTO WRONGREQUSITION;
    ELSIF RESULT_ = 3
      THEN OUT_MESSAGE := 'Ограничение по Эскроу счету в валюте '||V_ACCOUNT_NUMBER_||' c кодом продукта:'||SYSTAME_CODE_; V_NONACCEPTANCE_:=2; GOTO WRONGREQUSITION;
    ELSIF RESULT_ = 4
      THEN OUT_MESSAGE := 'Наличие Эскроу лимита по счету '      ||V_ACCOUNT_NUMBER_||' c кодом продукта:'||SYSTAME_CODE_; V_NONACCEPTANCE_:=2; GOTO WRONGREQUSITION;
    ELSIF RESULT_ = 5
      THEN OUT_MESSAGE := 'Наличие Эскроу блока по счету '       ||V_ACCOUNT_NUMBER_||' c кодом продукта:'||SYSTAME_CODE_; V_NONACCEPTANCE_:=2; GOTO WRONGREQUSITION;
    END IF;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            V_NONACCEPTANCE_    := 1;
            CHECK_MESSAGE_CODE_ := 1;
            CHECK_MESSAGE_      := 'Клиент-плательщик не найден!';
            INS_CHECK_CLIENT_LOGS(REC.INGOING_MT_,
                                  V_NONACCEPTANCE_,
                                  V_ACCOUNT_NUMBER_,
                                  TRIM(BASE_RNN_),
                                  REC.KBK_,
                                  REC.KNP_,
                                  CHECK_MESSAGE_CODE_,
                                  CHECK_MESSAGE_,
                                  OUT_MESSAGE_CODE,
                                  OUT_MESSAGE);
            IF OUT_MESSAGE IS NOT NULL THEN
              RAISE E_ERROR;
            END IF;
            GOTO WRONGREQUSITION;
        END;
        -- Author  : Beissenkulov Darkhan
        -- Edited  : 17.08.2016
        -- Reason  : MMD5014.
        -- BEGIN MMD5014
        BEGIN
          SELECT C.ACCOUNT_NUMBER
          INTO ACCOUNT_NUMBER_ESCROW
          FROM ACCOUNTS_BLOCK.ACCOUNTS_BLOCK  T,
             ACCOUNTS_BLOCK.CLIENT_ACCOUNTS C,
             ACCOUNTS_BLOCK.G_BLOCK_KINDS   BK
           WHERE BK.BLOCK_CODE = 'B_ESCROW'
           AND C.G_BANK_SYSTEM = 2
           AND T.CLIENT_ACCOUNT = C.CLIENT_ACCOUNT
           AND T.G_BLOCK_KIND = BK.G_BLOCK_KIND
           AND (REC.G_ORDER_TYPE_ IN (2,3,4,5,7,8,9,10,11,12)
                OR (REC.G_ORDER_TYPE_ in (1,6)
                   AND REC.ACCOUNT_NK_ = 'KZ24070105KSN0000000'
                   AND SUBSTR(REC.ACCOUNT_NK_, 5, 3) = '070'
                   AND 'KKMFKZ2A' = REC.BIK_NK_))
           AND C.ACCOUNT_NUMBER = V_ACCOUNT_NUMBER_;
          OUT_MESSAGE := 'Запрет/ограничение на проведение операций по счету ' ||
                 ACCOUNT_NUMBER_ESCROW || ' в режиме эскроу';
          V_NONACCEPTANCE_    := 1;
          CHECK_MESSAGE_CODE_ := 1;
          CHECK_MESSAGE_      := 'Клиент-плательщик не найден!';
          GOTO WRONGREQUSITION;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
          ACCOUNT_NUMBER_ESCROW := '';
        END;
    -- END MMD5014
      ELSIF (V_BANK_SYSTEM_ = '2') THEN
        --OpenWay
        RESULT_ := ACCOUNTS_BLOCK.SET_OW4_CUR(V_ACCOUNT_NUMBER_,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL);
        BEGIN
          SELECT T.IIN, 'OW4', t.last_nam||' '||t.first_nam||' '||t.father_s_nam,
                 instr(t.scheme_name,'Special Account'), T.CONTRACT_STATUS, T.date_expire,t.IS_READY
          INTO   BASE_RNN_, V_SYSTEM_CODE_, Name_Client_, Spec_FL_, V_Contract_status,V_date_expire,V_is_ready
          FROM   ACCOUNTS_BLOCK.TEMP_CUR_OW4# T;
          --DELETE ACCOUNTS_BLOCK.TEMP_CUR_OW4# T;
          ACCOUNTS_BLOCK.Del_Temp_Ow;
          if Spec_FL_ > 0 then
            Spec_FL_:=1;
          else
            Spec_FL_:=0;
          end if;
           -- SELECT count(*) INTO Unuse_close_ow FROM UNIFORM_CARD_INDEX.Z_EK_PARAM zep  WHERE UPPER(zep.CODE)='ACCOUNT_CLOSED_OW' AND zep.VAL='1';
          --if ow account has "close" status and unusable
            IF (UPPER(V_Contract_status) IN ('CLOSED ACCOUNT', 'ACCOUNT TO CLOSE')
 
          AND V_is_ready = 'Y')
        THEN 
          NULL;
        ELSIF (UPPER(V_Contract_status) IN ('CLOSED ACCOUNT', 'ACCOUNT TO CLOSE')
             AND V_is_ready = 'C') THEN
         
           V_NONACCEPTANCE_    := 3;
          CHECK_MESSAGE_CODE_ := 1;
          CHECK_MESSAGE_      := 'Счет плательщика закрыт!';
          INS_CHECK_CLIENT_LOGS(REC.INGOING_MT_,
                                V_NONACCEPTANCE_,
                                V_ACCOUNT_NUMBER_,
                                TRIM(BASE_RNN_),
                                REC.KBK_,
                                REC.KNP_,
                                CHECK_MESSAGE_CODE_,
                                CHECK_MESSAGE_,
                                OUT_MESSAGE_CODE,
                                OUT_MESSAGE);
          IF OUT_MESSAGE IS NOT NULL THEN
            RAISE E_ERROR;
          END IF;
          GOTO WRONGREQUSITION;
       ELSIF (UPPER(V_Contract_status) IN ('ACCOUNT CLOSED')) THEN
          
       
          V_NONACCEPTANCE_    := 3;
          CHECK_MESSAGE_CODE_ := 1;
          CHECK_MESSAGE_      := 'Счет плательщика закрыт!';
          INS_CHECK_CLIENT_LOGS(REC.INGOING_MT_,
                                V_NONACCEPTANCE_,
                                V_ACCOUNT_NUMBER_,
                                TRIM(BASE_RNN_),
                                REC.KBK_,
                                REC.KNP_,
                                CHECK_MESSAGE_CODE_,
                                CHECK_MESSAGE_,
                                OUT_MESSAGE_CODE,
                                OUT_MESSAGE);
          IF OUT_MESSAGE IS NOT NULL THEN
            RAISE E_ERROR;
          END IF;
          GOTO WRONGREQUSITION;
        END IF;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            V_NONACCEPTANCE_    := 1;
            CHECK_MESSAGE_CODE_ := 1;
            CHECK_MESSAGE_      := 'Клиент-плательщик не найден!';
            INS_CHECK_CLIENT_LOGS(REC.INGOING_MT_,
                                  V_NONACCEPTANCE_,
                                  V_ACCOUNT_NUMBER_,
                                  TRIM(BASE_RNN_),
                                  REC.KBK_,
                                  REC.KNP_,
                                  CHECK_MESSAGE_CODE_,
                                  CHECK_MESSAGE_,
                                  OUT_MESSAGE_CODE,
                                  OUT_MESSAGE);
            IF OUT_MESSAGE IS NOT NULL THEN
              RAISE E_ERROR;
            END IF;
            GOTO WRONGREQUSITION;
        END;
      ELSIF (V_BANK_SYSTEM_ = '3') THEN
        --Colvir розничный
        BEGIN
          SELECT RS.TAXCODE,
                 'CRS',
                 RS.FIO,
                 -- Author  : Beissenkulov Darkhan
                 -- Edited  : 17.08.2016
                 -- Reason  : MMD5014.
                 -- BEGIN MMD5014
                 CASE
                   WHEN (NVL(RS.SPECFL, 0) = 0 AND
                        (SELECT COUNT(1)
                           FROM LIST_MMD5014 T
                          WHERE T.PRODUCT_CODE_ABIS = RS.CODE
                            AND T.G_ORDER_TYPE = REC.G_ORDER_TYPE_
                             AND RS.SPECFL = T.SPECFL) > 0)
                 -- END MMD5014
                        or
                       --begin MMD4808 Эйр Астана
                        (RS.CODE = '15904' and --эскроу счета в РС
                        (REC.G_ORDER_TYPE_ not IN
                        (1, 6) OR
                        (REC.G_ORDER_TYPE_ in (1, 6) AND
                        (REC.ACCOUNT_NK_ = 'KZ24070105KSN0000000' OR 'KKMFKZ2A' = REC.BIK_NK_))))
                   -- END MMD4808 Эйр Астана
                    THEN
                    1
                   ELSE
                    NVL(RS.SPECFL, 0)
                 END SPECFL
                 -- BEGIN JIRA 714 Author: Beissenkulov Darkhan
                 ,CASE
                   WHEN (REC.G_ORDER_TYPE_ not in (1,6) or (REC.G_ORDER_TYPE_ in (1,6) AND REC.ACCOUNT_NK_ = 'KZ24070105KSN0000000'))
                     AND EXISTS (SELECT 1 FROM ca, ab, ACCOUNTS_BLOCK.G_BLOCK_KINDS BK
                     WHERE ca.ACCOUNT_NUMBER = V_ACCOUNT_NUMBER_ AND ca.G_BANK_SYSTEM = 3
                     AND ab.CLIENT_ACCOUNT = ca.CLIENT_ACCOUNT AND ab.G_BLOCK_KIND = BK.G_BLOCK_KIND AND (BK.BLOCK_CODE = 'B_LIM_ESCROW' or BK.BLOCK_CODE = 'B_ESCROW'))
                     AND RS.CODE in ('0195','15722')
                   THEN
                     1
                   ELSE 0
                 END RESULT_
                 -- END JIRA 714
            INTO BASE_RNN_, V_SYSTEM_CODE_, NAME_CLIENT_, SPEC_FL_, RESULT_
            FROM COLVIR.ZRS_UNIFORMCARDINDEX_ACC@AUCI_CRS3 RS
           WHERE RS.ACC_CODE = V_ACCOUNT_NUMBER_
             AND RS.STAT_CODE NOT IN ('CARRIED_OVER');
        -- BEGIN JIRA 714
        IF    RESULT_ = 1
          THEN OUT_MESSAGE := 'Ограничение по Эскроу счету ' ||V_ACCOUNT_NUMBER_; V_NONACCEPTANCE_:=2; GOTO WRONGREQUSITION;
        end if;
        -- END JIRA 714
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            V_NONACCEPTANCE_    := 1;
            CHECK_MESSAGE_CODE_ := 1;
            CHECK_MESSAGE_      := 'Клиент-плательщик не найден!';
            INS_CHECK_CLIENT_LOGS(REC.INGOING_MT_,
                                  V_NONACCEPTANCE_,
                                  V_ACCOUNT_NUMBER_,
                                  TRIM(BASE_RNN_),
                                  REC.KBK_,
                                  REC.KNP_,
                                  CHECK_MESSAGE_CODE_,
                                  CHECK_MESSAGE_,
                                  OUT_MESSAGE_CODE,
                                  OUT_MESSAGE);
            IF OUT_MESSAGE IS NOT NULL THEN
              RAISE E_ERROR;
            END IF;
            GOTO WRONGREQUSITION;
        END;
      ELSE
        BASE_RNN_ := '';
      END IF;
      IF TRIM(V_RNN_CLIENT_) <> TRIM(BASE_RNN_) THEN
        V_NONACCEPTANCE_    := 6;
        CHECK_MESSAGE_CODE_ := 1;
        CHECK_MESSAGE_      := 'Неверный РНН плательщика!';
        INS_CHECK_CLIENT_LOGS(REC.INGOING_MT_,
                              V_NONACCEPTANCE_,
                              V_ACCOUNT_NUMBER_,
                              TRIM(BASE_RNN_),
                              REC.KBK_,
                              REC.KNP_,
                              CHECK_MESSAGE_CODE_,
                              CHECK_MESSAGE_,
                              OUT_MESSAGE_CODE,
                              OUT_MESSAGE);
        IF OUT_MESSAGE IS NOT NULL THEN
          RAISE E_ERROR;
        END IF;
        GOTO WRONGREQUSITION;
      ELSE
        IF REC.KNP_ IS NOT NULL THEN
          SELECT COUNT(*)
          INTO   KNP_COUNT
          FROM   G_KNP N
          WHERE  N.CODE = REC.KNP_
          and not exists (select 1 from g_knp_old gold where n.code = gold.code);
          IF KNP_COUNT = 0 THEN
            V_NONACCEPTANCE_    := 5;
            CHECK_MESSAGE_CODE_ := 1;
            CHECK_MESSAGE_      := 'Недопустимый ЕКНП!';
            INS_CHECK_CLIENT_LOGS(REC.INGOING_MT_,
                                  V_NONACCEPTANCE_,
                                  V_ACCOUNT_NUMBER_,
                                  TRIM(BASE_RNN_),
                                  REC.KBK_,
                                  REC.KNP_,
                                  CHECK_MESSAGE_CODE_,
                                  CHECK_MESSAGE_,
                                  OUT_MESSAGE_CODE,
                                  OUT_MESSAGE);
            IF OUT_MESSAGE IS NOT NULL THEN
              RAISE E_ERROR;
            END IF;
            GOTO WRONGREQUSITION;
          END IF;
        END IF;
        BEGIN
          SELECT G.G_BANK_SYSTEM
          INTO   BANK_SYSTEM_
          FROM   G_BANK_SYSTEMS G
          WHERE  G.SYSTEM_CODE = V_SYSTEM_CODE_;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            BANK_SYSTEM_:=null;
        END;
        STATUS_ := GET_ACCOUNT_STATUS(V_ACCOUNT_NUMBER_,
                                      V_RNN_CLIENT_,
                                      NULL,
                                      BANK_SYSTEM_);
        IF TRIM(UPPER(STATUS_)) = 'CLOSE' THEN
          V_NONACCEPTANCE_    := 3;
          CHECK_MESSAGE_CODE_ := 1;
          CHECK_MESSAGE_      := 'Счет плательщика закрыт!';
          INS_CHECK_CLIENT_LOGS(REC.INGOING_MT_,
                                V_NONACCEPTANCE_,
                                V_ACCOUNT_NUMBER_,
                                TRIM(BASE_RNN_),
                                REC.KBK_,
                                REC.KNP_,
                                CHECK_MESSAGE_CODE_,
                                CHECK_MESSAGE_,
                                OUT_MESSAGE_CODE,
                                OUT_MESSAGE);
          IF OUT_MESSAGE IS NOT NULL THEN
            RAISE E_ERROR;
          END IF;
          GOTO WRONGREQUSITION;
        END IF;
        IF REC.KBK_ IS NOT NULL
          and rec.client=4 and substr(REC.KBK_,1,1)='1'--отключаем с 03.07.2015
          THEN
          SELECT COUNT(*)
          INTO   KBK_COUNT
          FROM   G_KBK B
          WHERE  B.CODE = REC.KBK_
          and not exists (select 1 from kbk_old o where o.code=b.code) --включаем с 03.07.2015
          ;
          IF KBK_COUNT = 0 THEN
            V_NONACCEPTANCE_    := 4;
            CHECK_MESSAGE_CODE_ := 1;
            CHECK_MESSAGE_      := 'Недопустимый КБК!';
            INS_CHECK_CLIENT_LOGS(REC.INGOING_MT_,
                                  V_NONACCEPTANCE_,
                                  V_ACCOUNT_NUMBER_,
                                  TRIM(BASE_RNN_),
                                  REC.KBK_,
                                  REC.KNP_,
                                  CHECK_MESSAGE_CODE_,
                                  CHECK_MESSAGE_,
                                  OUT_MESSAGE_CODE,
                                  OUT_MESSAGE);
            IF OUT_MESSAGE IS NOT NULL THEN
              RAISE E_ERROR;
            END IF;
            GOTO WRONGREQUSITION;
          END IF;
        END IF;
        -- Author  : Beissenkulov Darkhan
        -- Edited  : 02.04.2016
        -- Reason  : Запрос SD 3625662 от 31.03.2016г.
        -- BEGIN SD 3625662
        BEGIN
      SELECT LST.OPER_TYPE
        INTO OPER_TYPE_LST
        FROM BIN_BENEFICIAR_LST LST
       WHERE LST.ACTIVE = 1
         AND LST.OPER_TYPE = rec.OPER_TYPE_
         AND ROWNUM <= 1;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            OPER_TYPE_LST:=null;
        END;
    IF REC.RNN_NK_ IS NOT NULL AND rec.OPER_TYPE_ = OPER_TYPE_LST THEN
          SELECT '%' || LST.NAME_NK || '%'
            INTO NAME_NK_LST
            FROM BIN_BENEFICIAR_LST LST
           WHERE LST.ACTIVE = 1
             AND ROWNUM <= 1;
          SELECT LST.RNN_NK
            INTO RNN_NK_LST
            FROM BIN_BENEFICIAR_LST LST
           WHERE LST.ACTIVE = 1
             AND ROWNUM <= 1;
          IF TRIM(REC.RNN_NK_) != RNN_NK_LST
            OR TRIM(UPPER(REC.NAME_NK_)) NOT LIKE TRIM(UPPER(NAME_NK_LST))
            THEN
            V_NONACCEPTANCE_    := 11;
            CHECK_MESSAGE_CODE_ := 1;
            CHECK_MESSAGE_      := 'Ошибки в реквизитах Бенефициара!';
            INS_CHECK_CLIENT_LOGS(REC.INGOING_MT_,
                                  V_NONACCEPTANCE_,
                                  V_ACCOUNT_NUMBER_,
                                  TRIM(BASE_RNN_),
                                  REC.KBK_,
                                  REC.KNP_,
                                  CHECK_MESSAGE_CODE_,
                                  CHECK_MESSAGE_,
                                  OUT_MESSAGE_CODE,
                                  OUT_MESSAGE);
            IF OUT_MESSAGE IS NOT NULL THEN
              RAISE E_ERROR;
            END IF;
            GOTO WRONGREQUSITION;
          END IF;
        END IF;
        -- END SD 3625662
      END IF;
    ELSE
      V_NONACCEPTANCE_    := 2;
      CHECK_MESSAGE_CODE_ := 1;
      CHECK_MESSAGE_      := 'Счет плательщика не найден!';
      INS_CHECK_CLIENT_LOGS(REC.INGOING_MT_,
                            V_NONACCEPTANCE_,
                            V_ACCOUNT_NUMBER_,
                            TRIM(BASE_RNN_),
                            REC.KBK_,
                            REC.KNP_,
                            CHECK_MESSAGE_CODE_,
                            CHECK_MESSAGE_,
                            OUT_MESSAGE_CODE,
                            OUT_MESSAGE);
      IF OUT_MESSAGE IS NOT NULL THEN
        RAISE E_ERROR;
      END IF;
      GOTO WRONGREQUSITION;
    END IF;
    V_NONACCEPTANCE_    := 10;
    CHECK_MESSAGE_CODE_ := 0;
    CHECK_MESSAGE_      := 'Принято банком!';
    INS_CHECK_CLIENT_LOGS(REC.INGOING_MT_,
                          V_NONACCEPTANCE_,
                          V_ACCOUNT_NUMBER_,
                          TRIM(BASE_RNN_),
                          REC.KBK_,
                          REC.KNP_,
                          CHECK_MESSAGE_CODE_,
                          CHECK_MESSAGE_,
                          OUT_MESSAGE_CODE,
                          OUT_MESSAGE);
    IF OUT_MESSAGE IS NOT NULL THEN
      RAISE E_ERROR;
    END IF;
    if REC.OPER_TYPE_ = '99' then --ПТ
        Err_PTP:=0;
        if (Spec_FL_ = 1) and Err_PTP = 0 then--Спецсчет
          Err_PTP:=1;
          V_NONACCEPTANCE_ := 17;
        end if;
        if (kazwin_utf(upper(trim(rec.Name_Client_))) <> kazwin_utf(upper(trim(Name_Client_)))) and Err_PTP = 0 then--ФИО
          Err_PTP:=1;
          V_NONACCEPTANCE_ := 20;
        end if;
        if (rec.Kod <> '19' and rec.Kbe <> '14') and Err_PTP = 0 then--Код Кбе
          Err_PTP:=1;
          V_NONACCEPTANCE_ := 15;
        end if;
        if Err_PTP = 0 then
        begin
          select dd.doc_id, dd.client_name, dd.g_document_detail, dd.dbz_no, dd.dbz_date
          into Doc_ID_, Name_Client_DD, g_dd_, dbz_no_, dbz_date_
          from document_detail dd
          where dd.client_rnn = rec.RNN_CLIENT_
                and trim(dd.dbz_no) = trim(rec.Doc_Nuber_DD)
                and dd.dbz_date = rec.Doc_Date_DD
                --and dd.g_document_detail = rec.G_DD  -- исключено по НПА НБРК
                and dd.g_status = 5
                and dd.arch_date >= trunc(sysdate)
                and dd.doc_id = (select max(d.doc_id)
                                from document_detail d
                                where d.client_rnn = rec.RNN_CLIENT_
                                      and trim(d.dbz_no) = trim(rec.Doc_Nuber_DD)
                                      and d.dbz_date = rec.Doc_Date_DD
                                      --and d.g_document_detail = rec.G_DD --исключено по НПА НБРК
                               );
          ADD_RELAT_TO_DOC_FILES(REC.MT_BODY_,
                                 Doc_ID_,
                                 'FROM_FILE_MANAGER',
                                 OUT_MESSAGE);
          begin
            select gd.name
            into DBZ_Name
            from g_document_detail gd
            where gd.g_document_detail = g_dd_;
            exception
              when no_data_found then
                DBZ_Name:=null;
          end;
          update mt_body mm
          set mm.assign = mm.assign||' '||DBZ_Name||' '||dbz_no_||' '||dbz_date_
          where mm.mt_body = rec.MT_BODY_;
        exception
          when no_data_found then
            Err_PTP:=2;
            V_NONACCEPTANCE_ := 16;
        end;
        end if;
        select mp.CHIF_NAME_BENIFICAR, mp.MAIN_BUH_BENIFICAR
        into   Podpisant1, Podpisant2
        from mt_body_ptp mp
        where mp.mt_body = rec.MT_BODY_;
        if (Podpisant1 is null or Podpisant2 is null) and Err_PTP = 0 then--Код Кбе
          Err_PTP:=1;
          V_NONACCEPTANCE_ := 18;
        end if;
        if ((rec.Create_Time_-rec.DOC_DATE_) > 10) and Err_PTP = 0 then--Код Кбе
          Err_PTP:=1;
          V_NONACCEPTANCE_ := 19;
        end if;
        /*dbms_session.Set_NLS ('NLS_TIME_FORMAT','''HH24.MI.SSXFF''');
        if (to_char(rec.Create_Time_,'hh24') >= '17') then
          Err_PTP:=1;
          V_NONACCEPTANCE_ := 21;
        end if;*/
        if Err_PTP = 0 then
          V_NONACCEPTANCE_ := 10;
        end if;
        Event_Code_:='EVENT_BD';
      else
        Event_Code_:='EVENT_SD';
        if Spec_FL_ = 1 then
          V_NONACCEPTANCE_    := 2;
        end if;
      end if;--ПТ
      if BANK_SYSTEM_ is null then
        V_NONACCEPTANCE_ := 2;
      end if;
    <<WRONGREQUSITION>>
    IF V_NONACCEPTANCE_ <> 10 THEN
      UPDATE MT_BODY MT
      SET    MT.G_STATUS        = 7,
             MT.G_NONACCEPTANCE = V_NONACCEPTANCE_,
             MT.G_BANK_SYSTEM   = DECODE(V_BANK_SYSTEM_,
                                         '1',
                                         2,
                                         '2',
                                         4,
                                         '3',
                                         3),
             MT.CLOSE_TIME      = SYSDATE
      WHERE  MT.MT_BODY = REC.MT_BODY_;
    ELSE
      UPDATE MT_BODY MT
      SET    MT.G_BANK_SYSTEM   = BANK_SYSTEM_,
             MT.G_NONACCEPTANCE = V_NONACCEPTANCE_
      WHERE  MT.MT_BODY = REC.MT_BODY_;
      select mm.g_status
      into G_Status_
      from mt_body mm
      where mm.mt_body = REC.MT_BODY_;
      IF G_Status_ <> 7 THEN
        BLOCKING_FOR_CARD_INDEX('SYSTEM_CARD_INDEX',
                                REC.OPER_TYPE_,
                                BANK_SYSTEM_,
                                V_ACCOUNT_NUMBER_,
                                V_RNN_CLIENT_,
                                REC.DOC_NUMBER_,
                                REC.DOC_DATE_,
                                'ИР/ПТ на основании' || '  № ' ||
                                REC.DOC_NUMBER_ || ' от ' ||
                                TO_CHAR(REC.DOC_DATE_, 'dd.mm.yyyy'),
                                REC.PAY_SUMM_,
                                REC.CODE3_,
                                Event_Code_,
                                OUT_HIS_ACCOUNT_BLOCK,
                                OUT_MESSAGE,
                                REC.MT_BODY_);
        IF OUT_MESSAGE IS NOT NULL THEN
          RAISE E_ERROR;
        END IF;
        UPDATE MT_BODY MT
        SET    MT.HIS_ACCOUNT_BLOCK = OUT_HIS_ACCOUNT_BLOCK
        WHERE  MT.MT_BODY = REC.MT_BODY_;
        
        DISPATCH_IN_CARD_INDEX(REC.MT_BODY_,
                             'SYSTEM_CARD_INDEX',
                             OUT_MESSAGE);
        IF OUT_MESSAGE IS NOT NULL THEN
          RAISE E_ERROR;
        END IF;
        
        BEGIN
        SELECT COUNT(*) INTO cnt FROM LIST_NOTICE_MMD5174 e WHERE e.iin_bin = V_RNN_CLIENT_;
        SELECT g.system_code INTO SYSTAME_CODE_ FROM G_BANK_SYSTEMS g WHERE g.g_bank_system = BANK_SYSTEM_;
        END;
        IF cnt > 0 THEN
        BEGIN
          for rec_of in (select nl.official
                           from LIST_NOT_OFF_MMD5174 nl
                          where nl.g_order_type = rec.G_ORDER_TYPE_ ) loop
                            ADM_UNIFORM_CARD_INDEX.A_NOTICE_USER_ON_EMAIL(rec_of.official,
                                                                          'Уведомление о поступлении требования',
                                                                          'Kartoteka',
                                                                          'ИР/ПТ № ' || REC.DOC_NUMBER_ || ' от ' || REC.DOC_DATE_ ||' по счету: ' || V_ACCOUNT_NUMBER_ || '(' || SYSTAME_CODE_ ||') клиента ' || Name_Client_ ||' помещен в картотеку.'||
                                                                          '<br/>Необходимо сообщить клиенту о помещении ИР/ПТ в картотеку.');
                         END LOOP;
        END;
      END IF;
      END IF;
      SWIFT_ACCOUNT_ := GET_CURR_WITHOUT_COMMIT(BANK_SYSTEM_, V_ACCOUNT_NUMBER_);
      BEGIN
        SELECT GC.G_CURRENCY
        INTO   CURRENCY_ACCOUNT_
        FROM   G_CURRENCY GC
        WHERE  GC.SWIFT_CODE = SWIFT_ACCOUNT_;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          CURRENCY_ACCOUNT_ := '';
      END;
      UPDATE MT_BODY M
      SET    M.CURRENCY_ACCOUNT = CURRENCY_ACCOUNT_
      WHERE  M.CURRENCY_ACCOUNT IS NULL
      AND    M.MT_BODY = REC.MT_BODY_;
    END IF;
    COMMIT;
  EXCEPTION
    WHEN E_ERROR THEN
      ROLLBACK;
      INS_E_EXCEPTIONS_LOGS(PROCNAME, SQLCODE, 'REC.MT_BODY_:'||REC.MT_BODY_||'; '||OUT_MESSAGE || '. ' || DBMS_UTILITY.format_error_backtrace(), NULL, NULL);
      CONTINUE;
    WHEN OTHERS THEN
      ROLLBACK;
      INS_E_EXCEPTIONS_LOGS(PROCNAME, SQLCODE, 'REC.MT_BODY_:'||REC.MT_BODY_||'; '||SQLERRM || '. ' || DBMS_UTILITY.format_error_backtrace(), NULL, NULL);
      CONTINUE;
  END;
  END LOOP;
  CLOSE CUR;
EXCEPTION
  WHEN OTHERS THEN
    BEGIN
      ROLLBACK;
      INS_E_EXCEPTIONS_LOGS(PROCNAME, SQLCODE, 'client_:'||client_||'; '||SQLERRM||'. '||DBMS_UTILITY.format_error_backtrace(), NULL, NULL);
    END;
END CHECK_REQUIS_ENCASH_DICTAT;
/