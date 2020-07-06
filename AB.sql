prompt
prompt Creating table ACCOUNTS_BLOCK
prompt =============================
prompt
create table ACCOUNTS_BLOCK.ACCOUNTS_BLOCK
(
  account_block    NUMBER not null,
  client_account   NUMBER not null,
  g_block_kind     NUMBER not null,
  g_initiator      NUMBER not null,
  g_basis_blocking NUMBER not null,
  doc_number       VARCHAR2(50 CHAR) not null,
  doc_date         DATE not null,
  block_official   NUMBER not null,
  block_time       DATE default sysdate not null,
  note             VARCHAR2(1000 CHAR),
  summ_arrest      NUMBER(19,2),
  from_date_arrest DATE,
  to_date_arrest   DATE,
  g_currency       NUMBER default 155
)
tablespace EKARCH
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 8K
    minextents 1
    maxextents unlimited
  );
comment on table ACCOUNTS_BLOCK.ACCOUNTS_BLOCK
  is 'Перечень арестов';
comment on column ACCOUNTS_BLOCK.ACCOUNTS_BLOCK.account_block
  is 'ID ареста';
comment on column ACCOUNTS_BLOCK.ACCOUNTS_BLOCK.client_account
  is 'ID с CLIENT_ACCOUNT';
comment on column ACCOUNTS_BLOCK.ACCOUNTS_BLOCK.g_block_kind
  is 'Виды блокировок из справочника G_BLOCK_KINDS';
comment on column ACCOUNTS_BLOCK.ACCOUNTS_BLOCK.g_initiator
  is 'G_INITIATORs-8НК,9Таможня,12БВУ,13Клиент,11и14Иное';
comment on column ACCOUNTS_BLOCK.ACCOUNTS_BLOCK.g_basis_blocking
  is 'Основание блокировки';
comment on column ACCOUNTS_BLOCK.ACCOUNTS_BLOCK.doc_number
  is 'Номер основания (постановления)';
comment on column ACCOUNTS_BLOCK.ACCOUNTS_BLOCK.doc_date
  is 'Дата основания (постановления)';
comment on column ACCOUNTS_BLOCK.ACCOUNTS_BLOCK.block_official
  is 'Пользователь';
comment on column ACCOUNTS_BLOCK.ACCOUNTS_BLOCK.block_time
  is 'Время блокировки';
comment on column ACCOUNTS_BLOCK.ACCOUNTS_BLOCK.note
  is 'Комментарий';
comment on column ACCOUNTS_BLOCK.ACCOUNTS_BLOCK.summ_arrest
  is 'Сумма ареста';
comment on column ACCOUNTS_BLOCK.ACCOUNTS_BLOCK.from_date_arrest
  is 'Дата ареста с';
comment on column ACCOUNTS_BLOCK.ACCOUNTS_BLOCK.to_date_arrest
  is 'Дата ареста по';
comment on column ACCOUNTS_BLOCK.ACCOUNTS_BLOCK.g_currency
  is 'Валюта требования из G_CURRENCY 155-KZT, 156-USD, 50-EUR, 180-RUB, 158-GBP, 159-CHF';
create index ACCOUNTS_BLOCK.IDX$$_35010003 on ACCOUNTS_BLOCK.ACCOUNTS_BLOCK (CLIENT_ACCOUNT)
  tablespace EKARCH
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index ACCOUNTS_BLOCK.RELATIONSHIP_77_FK on ACCOUNTS_BLOCK.ACCOUNTS_BLOCK (G_BLOCK_KIND)
  tablespace EKARCH
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index ACCOUNTS_BLOCK.REL_113_FK on ACCOUNTS_BLOCK.ACCOUNTS_BLOCK (BLOCK_OFFICIAL)
  tablespace EKARCH
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table ACCOUNTS_BLOCK.ACCOUNTS_BLOCK
  add constraint PK_ACCOUNTS_BLOCK primary key (ACCOUNT_BLOCK)
  using index 
  tablespace EKARCH
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table ACCOUNTS_BLOCK.ACCOUNTS_BLOCK
  add constraint FK_ACC_BLC_G_BASIS_BLOCKING foreign key (G_BASIS_BLOCKING)
  references ACCOUNTS_BLOCK.G_BASIS_BLOCKINGS (G_BASIS_BLOCKING);
alter table ACCOUNTS_BLOCK.ACCOUNTS_BLOCK
  add constraint FK_ACC_BLC_G_INITIATOR foreign key (G_INITIATOR)
  references ACCOUNTS_BLOCK.G_INITIATORS (G_INITIATOR);
alter table ACCOUNTS_BLOCK.ACCOUNTS_BLOCK
  add constraint FK_ACCOUNTS_REL_113_OFFICIAL foreign key (BLOCK_OFFICIAL)
  references ADM_UNIFORM_CARD_INDEX.OFFICIALS (OFFICIAL);
alter table ACCOUNTS_BLOCK.ACCOUNTS_BLOCK
  add constraint FK_ACCOUNTS_REL_77_G_BLOCK_ foreign key (G_BLOCK_KIND)
  references ACCOUNTS_BLOCK.G_BLOCK_KINDS (G_BLOCK_KIND);
grant select on ACCOUNTS_BLOCK.ACCOUNTS_BLOCK to DBT_USER;
grant select on ACCOUNTS_BLOCK.ACCOUNTS_BLOCK to UNICI_SUBP_LNK;
grant select, insert, update, delete, references on ACCOUNTS_BLOCK.ACCOUNTS_BLOCK to UNIFORM_CARD_INDEX;

prompt
prompt Creating sequence ACC_BLOCK_SEQ
prompt ===============================
prompt
create sequence ACCOUNTS_BLOCK.ACC_BLOCK_SEQ
minvalue 1
maxvalue 9999999999999999999
start with 22
increment by 1
nocache
cycle;

prompt
prompt Creating view EK_Z_NOMOVE
prompt =========================
prompt
CREATE OR REPLACE FORCE VIEW ACCOUNTS_BLOCK.EK_Z_NOMOVE AS
SELECT /*+ CHOOSE*/
  z.acc_code, h.longname, h.taxcode, z.msg,z.err_fl,z.correctdt,b.CODE
   FROM colvir.Z_S03_EK_Z_NOMOVE@auci_crs3 z,
        colvir.G_ACCBLN@auci_crs3          G,
        colvir.S_DEAACC@auci_crs3          SD,
        colvir.t_dea@auci_crs3             td,
        colvir.g_clihst@auci_crs3          h,
        colvir.T_PROCMEM@auci_crs3 M,
            colvir.T_PROCESS@auci_crs3 S,
            colvir.T_BOP_STAT@auci_crs3 B
  WHERE  z.acc_code = g.code
    and G.DEP_ID = SD.ACC_DEP_ID
    AND G.ID = SD.ACC_ID
    and tD.DEP_ID = sd.DEP_ID
    AND tD.ID = sd.ID
    and td.cli_dep_id = h.dep_id
    and td.cli_id = h.id
    AND SYSDATE BETWEEN H.FROMDATE AND H.TODATE
    AND td.DEP_ID = M.DEP_ID
            AND td.ID = M.ORD_ID
            AND M.MAINFL = '1'
            AND M.ID = S.ID
            AND S.BOP_ID = B.ID
            AND S.NSTAT = B.NORD
    union all
    SELECT /*+ CHOOSE*/
  z.acc_code, h.longname, h.taxcode, z.msg,z.err_fl,z.correctdt,b.CODE
   FROM colvir.Z_S03_EK_Z_NOMOVE@auci_crs3 z,
        colvir.G_ACCBLN@auci_crs3          G,
        colvir.D_DEA@auci_crs3          SD,
        colvir.t_dea@auci_crs3             td,
        colvir.g_clihst@auci_crs3          h,
        colvir.T_PROCMEM@auci_crs3 M,
            colvir.T_PROCESS@auci_crs3 S,
            colvir.T_BOP_STAT@auci_crs3 B
  WHERE  z.acc_code = g.code
    and G.DEP_ID = SD.ACC_DEP_ID
    AND G.ID = SD.ACC_ID
    and tD.DEP_ID = sd.DEP_ID
    AND tD.ID = sd.ID
    and td.cli_dep_id = h.dep_id
    and td.cli_id = h.id
    AND SYSDATE BETWEEN H.FROMDATE AND H.TODATE
    AND td.DEP_ID = M.DEP_ID
            AND td.ID = M.ORD_ID
            AND M.MAINFL = '1'
            AND M.ID = S.ID
            AND S.BOP_ID = B.ID
            AND S.NSTAT = B.NORD;

prompt
prompt Creating view V_EK_LIMITS
prompt =========================
prompt
create or replace force view accounts_block.v_ek_limits as
select h.his_account_block,
       h.account_block,
       re.lim_id_bs,
       b.system_code,
       ca.account_number,
       ca.g_bank_system,
       ca.rnn,
       h.block_time,
       h.doc_date,
       h.summ_arrest,
       h.note,
       gi.initiator_name,
       h.doc_number,
       gc.swift_code,
       gb.g_block_kind,
       ca.name,
       t.load_time,
       t.accept_time,
       gr.name type_doc,
       gb.block_code,
       gb.block_name,
       uniform_card_index.get_user_name(t.mt_body, t.g_order_type) initiator,
       gbr.branch_name,
       t.rnn_nk,
       t.name_nk,
       t.bik_nk,
       t.account_nk,
       t.assign,
       t.mt_reference,
       to_number('') r_order_stay_acc_oper,
       t.mt_body,
       gs.g_status,
       gs.name_rus status
  from his_accounts_block               h,
       client_accounts                  ca,
       g_block_kinds                    gb,
       bank_systems_block_kinds         b,
       RELAT_EK_BS_LIMITS               re,
       g_initiators                     gi,
       uniform_card_index.g_currency    gc,
       uniform_card_index.mt_body       t,
       uniform_card_index.g_orders_type gr,
       uniform_card_index.mt_body_ptp   mp,
       adm_uniform_card_index.g_branch  gbr,
       adm_uniform_card_index.officials o,
       uniform_card_index.g_status      gs
 where h.client_account = ca.client_account
   and ca.g_bank_system = 3
   and h.is_archive = 0
   and h.g_block_kind = gb.g_block_kind
   and h.g_block_kind = b.g_block_kind
   and b.g_bank_system = ca.g_bank_system
   and re.his_account_block(+) = h.his_account_block
   and h.g_initiator = gi.g_initiator(+)
   and h.oper_type = 1
   and re.lim_id_bs is not null
   and h.summ_arrest is not null
   and h.g_currency = gc.g_currency
   and re.oper_type = 1
   and not exists
 (select 1
          from uniform_card_index.r_order_stay_acc_opers      r,
               uniform_card_index.r_order_stay_acc_oper_bodys ra
         where r.r_order_stay_acc_oper = ra.r_order_stay_acc_oper
           and ra.his_account_block = h.his_account_block)
   and t.his_account_block(+) = h.his_account_block
   and gr.g_order_type(+) = t.g_order_type
   and mp.mt_body(+) = t.mt_body
   and gbr.g_branch(+) = o.g_branch
   and o.official(+) = mp.official
   and gs.g_status(+) = t.g_status
union all
select h.his_account_block,
       h.account_block,
       re.lim_id_bs,
       b.system_code,
       ca.account_number,
       ca.g_bank_system,
       ca.rnn,
       h.block_time,
       h.doc_date,
       h.summ_arrest,
       h.note,
       gi.initiator_name,
       h.doc_number,
       gc.swift_code,
       gb.g_block_kind,
       ca.name,
       r.load_time,
       to_date('') accept_time,
       gm.mt_name type_doc,
       gb.block_code,
       gb.block_name,
       o.name initiator,
       gbr.branch_name,
       r.rnn_from rnn_nk,
       r.name_from name_nk,
       '' bik_nk,
       '' account_nk,
       '' assign,
       r.mt_reference,
       r.r_order_stay_acc_oper,
       to_number('') mt_body,
       gs.g_status,
       gs.name_rus status
  from his_accounts_block                             h,
       client_accounts                                ca,
       g_block_kinds                                  gb,
       bank_systems_block_kinds                       b,
       RELAT_EK_BS_LIMITS                             re,
       g_initiators                                   gi,
       uniform_card_index.g_currency                  gc,
       uniform_card_index.r_order_stay_acc_opers      r,
       uniform_card_index.r_order_stay_acc_oper_bodys ra,
       uniform_card_index.g_mt_formats                gm,
       adm_uniform_card_index.officials               o,
       adm_uniform_card_index.g_branch                gbr,
       uniform_card_index.g_status                    gs
 where h.client_account = ca.client_account
   and ca.g_bank_system = 3
   and h.is_archive = 0
   and h.g_block_kind = gb.g_block_kind
   and h.g_block_kind = b.g_block_kind
   and b.g_bank_system = ca.g_bank_system
   and re.his_account_block(+) = h.his_account_block
   and h.g_initiator = gi.g_initiator(+)
   and h.oper_type = 1
   and re.lim_id_bs is not null
   and h.summ_arrest is not null
   and h.g_currency = gc.g_currency
   and re.oper_type = 1
   and r.r_order_stay_acc_oper = ra.r_order_stay_acc_oper
   and ra.his_account_block = h.his_account_block
   and gm.g_mt_format = r.g_mt_format
   and o.official = h.block_official
   and o.g_branch = gbr.g_branch
   and gs.g_status = r.g_status
union all
select to_number('') his_account_block,
       to_number('') account_block,
       l.lim_id lim_id_bs,
       'Z_S03_PTP_AREST' system_code,
       l.account_number,
       3,
       c.rnn,
       to_date('') block_time,
       to_date('') doc_date,
       l.amount summ_arrest,
       'Лимит ПТ (текущий счет)' note,
       '' initiator_name,
       '' doc_number,
       l.val_code swift_code,
       to_number('') g_block_kind,
       '' name,
       to_date('') load_time,
       to_date('') accept_time,
       '' type_doc,
       '' block_code,
       '' block_name,
       '' initiator,
       '' branch_name,
       '' rnn_nk,
       '' name_nk,
       '' bik_nk,
       '' account_nk,
       '' assign,
       '' mt_reference,
       to_number('') r_order_stay_acc_oper,
       to_number('') mt_body,
       to_number('') g_status,
       '' status
  from uniform_card_index.t_ptp_lim_amount l, client_accounts c
 where l.status = 0
   and l.account_number = c.account_number
   and exists (select 1
          from his_accounts_block       h,
               g_block_kinds            g,
               bank_systems_block_kinds b,
               client_accounts          c2
         where h.is_archive = 0
           and h.oper_type = 1
           and h.g_block_kind = b.g_block_kind
           and h.g_block_kind = g.g_block_kind
           and b.g_bank_system = 3
           and b.system_code = 'Z_S03_PTP_AREST'
           and c.client_account = c2.client_account
           and h.client_account = c2.client_account
           and b.g_bank_system = c2.g_bank_system);
grant select on ACCOUNTS_BLOCK.V_EK_LIMITS to CRDPROD_LNK;
grant select on ACCOUNTS_BLOCK.V_EK_LIMITS to UNICI_SUBP_LNK;

prompt
prompt Creating function GET_ACCOUNT_INFO
prompt ==================================
prompt
CREATE OR REPLACE FUNCTION ACCOUNTS_BLOCK.GET_ACCOUNT_INFO (ACCOUNT_NUMBER_ IN VARCHAR2, INFO_TYPE_ IN VARCHAR2) RETURN VARCHAR2
IS
  i integer;
  SYSTEM_ CHAR(1);
  TMP_BRANCH_ VARCHAR2(10);
  CURR_       VARCHAR2(5);
  BRANCH_     NUMBER;
  BALANCE_    NUMBER(23,2);
  ACC_TYPE_   VARCHAR2(100);
  ACC_TYPE_ID_ NUMBER;
  CODE_PR_     VARCHAR2(10);
  V_TABLE kzc_bwx.OPT_UNIFORM.TABLE_TYPE@PROD.KZC;
BEGIN
  SYSTEM_:=SUBSTR(ACCOUNT_NUMBER_,11,1);
  IF SYSTEM_ = '1' THEN
    SELECT BS.BAL, BS.CODE_DEP, A.TYPE_NAME, BS.CODE, A.SYSTEM_ID
    INTO   BALANCE_, TMP_BRANCH_, ACC_TYPE_, CURR_, ACC_TYPE_ID_
    FROM   COLVIR.ZV_EK_ACCOUNT_LST@AUCI_CBS3C BS,
           G_ACCOUNT_TYPES A
    WHERE  BS.CODE_ACC = ACCOUNT_NUMBER_
    AND    A.SYSTEM_ID = BS.ACCTYP
    AND    A.G_BANK_SYSTEM = 2
    AND    ROWNUM <= 1;
    SELECT b.g_branch
    INTO   BRANCH_
    FROM   adm_uniform_card_index.g_branch b
    WHERE  b.colvir_code = TMP_BRANCH_;
  ELSIF SYSTEM_ = '3' THEN
    SELECT v.amount, V.FILIAL, A.TYPE_NAME, V.VAL_CODE, A.SYSTEM_ID, V.CODE
    INTO   BALANCE_, TMP_BRANCH_, ACC_TYPE_, CURR_, ACC_TYPE_ID_, CODE_PR_
    FROM   COLVIR.ZRS_UNIFORMCARDINDEX_ACC@auci_crs3 V,
           G_ACCOUNT_TYPES A
    WHERE  v.acc_code = ACCOUNT_NUMBER_ AND V.STAT_CODE!='CARRIED_OVER'
    AND    A.SYSTEM_ID = nvl(V.ACCTYP,
                         (CASE
                            WHEN SUBSTR(V.CODE_PR, 1, 2) = '13' AND V.SPECFL = 0 THEN 4
                            WHEN SUBSTR(V.CODE_PR, 1, 2) = '13' AND V.SPECFL = 1 THEN 13
                            WHEN SUBSTR(V.CODE_PR, 1, 2) = '15' THEN 3
                            ELSE 1
                          END))
    AND    A.G_BANK_SYSTEM = 3
    AND    ROWNUM <= 1;
    SELECT b.g_branch
    INTO   BRANCH_
    FROM   adm_uniform_card_index.g_branch b
    WHERE  b.colvir_code = TMP_BRANCH_;
  ELSIF SYSTEM_ = '2' THEN
    V_TABLE := kzc_bwx.OPT_UNIFORM.GET_CONTRACTS@PROD.KZC(ACCOUNT_NUMBER_,
                                                      null,
                                                      null,
                                                      null,
                                                      null,
                                                      null);
    IF V_TABLE.COUNT > 0 THEN
      FOR I IN 1 .. V_TABLE.COUNT LOOP
          balance_ := f_calc_balance(v_table(i).total_balance,
                                     v_table(i).amount_available,
                                     v_table(i).cl_deposit_arrested,
                                     v_table(i).cl_deposit_suspended);
            
        SELECT b.g_branch
        INTO   BRANCH_
        FROM   adm_uniform_card_index.branch_ow4 b
        WHERE  b.branch_code = V_TABLE(I).BRANCH
        and rownum=1;
        --BRANCH_:=V_TABLE(I).BRANCH;
        CURR_:=V_TABLE(I).CURR;
        SELECT CASE WHEN upper(V_TABLE(I).SCHEME_NAME) like '%SPECIAL ACCOUNT%'
                    THEN 2 ELSE 1 END
        INTO ACC_TYPE_ID_
        FROM dual;
        SELECT A.TYPE_NAME
        INTO   ACC_TYPE_
        FROM   G_ACCOUNT_TYPES A
        WHERE  A.G_BANK_SYSTEM = 4
        AND    A.SYSTEM_ID = 1;
      END LOOP;
    END IF;
  END IF;
  IF UPPER(INFO_TYPE_) = 'BALANCE' THEN
    RETURN BALANCE_;
  ELSIF UPPER(INFO_TYPE_) = 'BRANCH' THEN
    RETURN BRANCH_;
  ELSIF UPPER(INFO_TYPE_) = 'ACC_TYPE' THEN
    RETURN ACC_TYPE_;
  ELSIF UPPER(INFO_TYPE_) = 'ACC_TYPE_ID' THEN
    RETURN ACC_TYPE_ID_;
  ELSIF UPPER(INFO_TYPE_) = 'CURRENCY' THEN
    RETURN CURR_;
  ELSIF UPPER(INFO_TYPE_) = 'CODE_PR_' THEN
    RETURN CODE_PR_;
  END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN null;
END GET_ACCOUNT_INFO;
/
grant execute on ACCOUNTS_BLOCK.GET_ACCOUNT_INFO to UNIFORM_CARD_INDEX;

prompt
prompt Creating function GET_MIDDLE_SUMM_IN_KZT
prompt ========================================
prompt
CREATE OR REPLACE FUNCTION ACCOUNTS_BLOCK.GET_MIDDLE_SUMM_IN_KZT
(
  Summ_       NUMBER,
  Currency_   NUMBER,
  Begin_Date_ Date
)
RETURN NUMBER
IS
  Result_       NUMBER(30, 5);
  KZT_Value_    NUMBER;
BEGIN

  IF Currency_=155 THEN 
    KZT_Value_:=1;
  ELSE
    begin
      SELECT k.rate
        into KZT_Value_
        FROM COLVIR.ZV_KURS_CONT@COLVIR_PLEDGE K,
             COLVIR.ZV_VAL_CONT@COLVIR_PLEDGE  C,
             uniform_card_index.g_currency  CU
       WHERE cu.g_currency = Currency_
         and K.VAL_ID = C.ID
         AND (CU.SWIFT_CODE = C.CODE OR
             (C.CODE = 'RUR' AND cu.swift_code = 'RUB'))
         AND K.FROMDATE = TO_DATE(Begin_Date_, 'dd.mm.yyyy');
    exception
      when no_data_found then
        begin
          SELECT k.rate
            into KZT_Value_
            FROM COLVIR.ZV_KURS_CONT@COLVIR_PLEDGE K,
                 COLVIR.ZV_VAL_CONT@COLVIR_PLEDGE  C,
                 uniform_card_index.g_currency  CU
           WHERE cu.g_currency = Currency_
             and K.VAL_ID = C.ID
             AND (CU.SWIFT_CODE = C.CODE OR
                 (C.CODE = 'RUR' AND cu.swift_code = 'RUB'))
             AND K.FROMDATE = (select max(k1.fromdate)
                                 from COLVIR.ZV_KURS_CONT@COLVIR_PLEDGE K1
                                where k1.VAL_ID = k.VAL_ID
                                  and k1.fromdate < Begin_Date_);
        exception
          when no_data_found then
            KZT_Value_ := 0;
        end;
    end;
  END IF;
  
  Result_ := Summ_ * KZT_Value_;
  RETURN Result_;

EXCEPTION
  WHEN OTHERS THEN
    RETURN 0;
END;
/
grant execute on ACCOUNTS_BLOCK.GET_MIDDLE_SUMM_IN_KZT to UNIFORM_CARD_INDEX;

prompt
prompt Creating procedure P_REQ_PROCESSING
prompt ===================================
prompt
CREATE OR REPLACE PROCEDURE ACCOUNTS_BLOCK.P_REQ_PROCESSING
(in_status IN NUMBER)
is
  PROCNAME varchar2(20):='P_REQ_PROCESSING';
  type type_rpt is record
  (
    id number,
    official  number,
    from_date  date,
    to_date  date,
    account_number  varchar2(25),
    ingoing_num  varchar2(200),
    ingoing_date  date,
    address_halyk  varchar2(500),
    g_bank_system  number,
    g_branch  number,
    name_ben  varchar2(500),
    address_ben  varchar2(500),
    fio_ruk  varchar2(500),
    post_ruk  varchar2(500),
    post_ruk_dep  varchar2(500),
    phone  varchar2(100),
    rcomment  clob,
    act_num  varchar2(200),
    act_date  date,
    resident_type  number,
    account_status  number,
    req_status  number(1),
    iin_list_id  number,
    lang  varchar2(2),
    create_date  date,
    acc_req_mov_id number
  );
  rec type_rpt;
  Cursor cur is
    select * from (
    select id, official, --from_date, to_date, account_number, -- убрано №MMD0000005002 от 29.07.2016
           to_date(arm.from_date) from_date, to_date(arm.to_date) to_date, arm.account_number,-- добавлено №MMD0000005002 от 29.07.2016
           ingoing_num, ingoing_date, address_halyk, g_bank_system, g_branch,
           name_ben, address_ben, fio_ruk, post_ruk, post_ruk_dep, phone,
           rcomment, act_num, act_date, resident_type, account_status,
           req_status, iin_list_id, lang, create_date,arm.acc_req_mov_id
    from   p_rpt_bu_registry r,
           t_acc_req_mov arm -- добавлено №MMD0000005002 от 29.07.2016
    where  r.REQ_STATUS = in_status
       and r.acc_lst_id=arm.acc_lst_id -- добавлено №MMD0000005002 от 29.07.2016
       and exists(
           select * from RELAT_REPORT_REQ p
           where r.id=p.report_id
           and p.req_id=6
       )-- добавлено №MMD0000005002 от 29.07.2016
       and not exists(
          select *
          from UNIFORM_CARD_INDEX.lst_proc_arc_db ls
               where ls.status = 0
                 and ls.request_id=r.id
       )
    union all
    select id, official, from_date, to_date, account_number,
           ingoing_num, ingoing_date, address_halyk, g_bank_system, g_branch,
           name_ben, address_ben, fio_ruk, post_ruk, post_ruk_dep, phone,
           rcomment, act_num, act_date, resident_type, account_status,
           req_status, iin_list_id, lang, create_date,0 acc_req_mov_id
    from   p_rpt_bu_registry r
    where  r.REQ_STATUS = in_status
       and
       exists(
           select * from RELAT_REPORT_REQ p
           where r.id=p.report_id
           and p.req_id<>6
       )-- добавлено №MMD0000005002 от 29.07.2016
    ) r
    order by r.id;

  type T_Rec_Acc_Req is record
  (
    R_ACCOUNT_NUMBER varchar2(50),
    R_rnn_           varchar2(20)
  );
  CURSOR CUR_T(FROM_DATE_ DATE, TO_DATE_ DATE, INGOING_NUM_ VARCHAR2, INGOING_DATE_ DATE, G_BRANCH_ NUMBER) IS
    SELECT C.ACCOUNT_NUMBER, C.RNN
    FROM (SELECT ROWNUM as RN, CA.ACCOUNT_NUMBER, CA.RNN
            FROM HIS_ACCOUNTS_BLOCK H, CLIENT_ACCOUNTS CA
           WHERE H.G_BLOCK_KIND in (12,13,14,
                                    80,81,82,83,84-- добавлено MMD0000005143 от 20.10.2016
                                   )
             AND TRUNC(H.Block_Time) BETWEEN FROM_DATE_ AND TO_DATE_
             AND H.IS_ARCHIVE = 0 AND H.IS_COMPLETE = 1 AND H.OPER_TYPE = 1
             AND ((INGOING_NUM_ IS NULL AND INGOING_DATE_ IS NULL)OR(INGOING_NUM_ = H.DOC_NUMBER AND INGOING_DATE_ = H.DOC_DATE))
             AND H.CLIENT_ACCOUNT = CA.CLIENT_ACCOUNT
             AND (G_BRANCH_ IS NULL OR ca.g_branch = G_BRANCH_)
             AND CA.G_BANK_SYSTEM = 4) C
    WHERE ROWNUM <= C.RN;
  rec_t T_Rec_Acc_Req;
  REQ_CODE_  varchar2(30);
  FROM_DATE_ date;
  system_id  char(1);
  V_TABLE    kzc_bwx.OPT_INCASSO_PKG.Movements_Table_Type@PROD.KZC;
  RESULT_    VARCHAR2(10);
  CNT_       NUMBER;
  iin_list_  TYPE_IIN;
  REQ_CODE_2 NUMBER;
  CNT2_      NUMBER;
  CNT3_      NUMBER;
  SQL_ALL    CLOB;
  SQL_BS     CLOB;
  SQL_RS     CLOB;
  SQL_OW     CLOB;
  STR_       CLOB;
  BANK_SYSTEM_ NUMBER;
  E_ERROR      EXCEPTION;
  TXT_MESSAGE_ VARCHAR2(4000);
  ERR_MSG VARCHAR2(4000);
  BS_LINK_ VARCHAR2(100);
  RS_LINK_ VARCHAR2(100);
  available_ number;
BEGIN
  BS_LINK_:='AUCI_CBS3C';
  RS_LINK_:='AUCI_CRS3';
  BEGIN
  execute immediate'alter session set NLS_DATE_FORMAT=''dd.mm.yyyy''';
  END;
  OPEN cur;
  LOOP --Main loop
    FETCH cur INTO rec;
    EXIT WHEN cur%NOTFOUND;
    BEGIN
      REQ_CODE_2:=3;
      CNT3_:=0;
      ERR_MSG:='';
      system_id:=substr(rec.ACCOUNT_NUMBER, 11, 1);
      FROM_DATE_:=NVL(rec.from_date, '01.01.2000');

      SELECT t.iin BULK COLLECT INTO iin_list_
      FROM   t_iin t
      WHERE  t.list_id = rec.iin_list_id;
      CNT_:= iin_list_.count;

      IF CNT_ > 0 THEN
        STR_:='(select iin from accounts_block.t_iin t where list_id = '||rec.iin_list_id||')';
      END IF;

      FOR rq IN (select r.req_code

                   from g_requests r,
                        relat_report_req rr
                  where r.req_id = rr.req_id
                    and rr.report_id = rec.id)
      LOOP --multiple mt_formats loop
        REQ_CODE_:=rq.req_code;
        SQL_ALL:='';
        IF REQ_CODE_ = 'BLOCKS' AND (rec.ingoing_date IS NOT NULL AND rec.ingoing_num IS NOT NULL) THEN  --Блокировка
          --BS
          SQL_BS:='SELECT   --+ordered use_nl(H, V_BS) parallel (2)
                            V_BS.CLI_LONGNAME as name,
                            V_BS.RNN as rnn,
                            V_BS.CODE_ACC as account_number,
                            V_BS.CODE as VAL_CODE,
                            DECODE('''||rec.lang||''', ''RU'', A.TYPE_NAME, A.TYPE_NAME_KZ),
                            null as acc_balance,
                            DECODE(H.SUMM_ARREST,NULL,NULL,
                                   H.SUMM_ARREST,trim(to_char(h.summ_arrest,''999999999999990D99'',''NLS_NUMERIC_CHARACTERS = '''',.'''''') || '' '' || CUR.SWIFT_CODE)
                                   ) as summ_arrest,
                            DECODE('''||rec.lang||''', ''RU'', BR.FULL_NAME_BRANCH, (SELECT BD.LONG_NAME_KZ FROM ADM_UNIFORM_CARD_INDEX.G_BRANCH_DETAIL BD WHERE BD.G_BRANCH=BR.G_BRANCH)),
                            ACC_STATUS
                    FROM   (SELECT C.* FROM
                           (SELECT ROWNUM as RN, CA.ACCOUNT_NUMBER,H.CLIENT_ACCOUNT, H.G_CURRENCY,  CA.RNN, H.SUMM_ARREST
                              FROM HIS_ACCOUNTS_BLOCK H, CLIENT_ACCOUNTS CA
                             WHERE H.G_BLOCK_KIND in (12,13,14,'
                                                   ||'80,81,82,83,84'||-- добавлено MMD0000005143 от 20.10.2016
                                                   ')
                               AND H.IS_ARCHIVE = 0 AND H.IS_COMPLETE = 1 AND H.OPER_TYPE = 1
                               AND TRUNC(H.Block_Time) BETWEEN '''||FROM_DATE_||''' AND '''||rec.to_date||'''
                               AND (('''||rec.ingoing_num||''' IS NULL AND '''||rec.ingoing_date||''' IS NULL)OR('''||rec.ingoing_num||''' = H.DOC_NUMBER AND '''||rec.ingoing_date||''' = H.DOC_DATE))
                               AND H.CLIENT_ACCOUNT = CA.CLIENT_ACCOUNT
                               AND ('''||rec.g_branch||''' IS NULL OR ca.g_branch = '''||rec.g_branch||''')
                               AND CA.G_BANK_SYSTEM = 2) C
                             WHERE ROWNUM <= C.RN
                               ) H,
                             COLVIR.ZV_EK_ACCOUNT_LST@AUCI_CBS3C V_BS,
                            (SELECT BAS.STATUS_CODE,
                                    DECODE('''||rec.lang||''', ''RU'', GS.status_name || '' (''||BAS.status_code||'')'', GS.status_name_kz || '' (''||BAS.status_code||'')'') acc_status
                               FROM G_ACCOUNTS_STATUS GS, BANK_SYSTEMS_ACCOUNT_STATUS BAS
                              WHERE BAS.G_BANK_SYSTEM = 2
                                AND BAS.G_ACCOUNT_STATUS = GS.G_ACCOUNT_STATUS
                                AND ('''||rec.account_status||''' = -1 OR (('''||rec.account_status||''' =1 and GS.G_ACCOUNT_STATUS in (1,4,5,6)) or ('''||rec.account_status||'''=2 and GS.G_ACCOUNT_STATUS in (2,3))))) BAS,
                            ADM_UNIFORM_CARD_INDEX.G_BRANCH BR,
                            UNIFORM_CARD_INDEX.G_CURRENCY CUR,
                            G_ACCOUNT_TYPES A
                       WHERE UPPER(V_BS.ACC_STATE) = BAS.STATUS_CODE
                         AND H.G_CURRENCY = CUR.G_CURRENCY
                         AND V_BS.CODE_ACC = H.ACCOUNT_NUMBER
                         AND V_BS.RNN = H.RNN
                         AND A.SYSTEM_ID = V_BS.ACCTYP
                         AND A.G_BANK_SYSTEM = 2
                         AND V_BS.CODE_DEP = BR.COLVIR_CODE';
          /*if rec.account_number IS NOT NULL then
            SQL_BS:=SQL_BS||' AND V_BS.CODE_ACC = '''||rec.account_number||'''';
          end if;
          if CNT_ > 0 then
             SQL_BS:=SQL_BS||' AND V_BS.RNN in '||str_;
          end if;*/

          --RS
          SQL_RS:='SELECT   --+ordered use_nl(H, V_RS) parallel (2)
                            V_RS.FIO as name,
                            V_RS.TAXCODE as rnn,
                            V_RS.ACC_CODE as account_number,
                            V_RS.VAL_CODE,
                            DECODE('''||rec.lang||''', ''RU'', A.TYPE_NAME, A.TYPE_NAME_KZ),
                            null as acc_balance,
                            DECODE(H.SUMM_ARREST,NULL,NULL,
                                   H.SUMM_ARREST,trim(to_char(h.summ_arrest,''999999999999990D99'',''NLS_NUMERIC_CHARACTERS = '''',.'''''') || '' '' || CUR.SWIFT_CODE)
                                   ) as summ_arrest,
                            DECODE('''||rec.lang||''', ''RU'', BR.FULL_NAME_BRANCH, (SELECT BD.LONG_NAME_KZ FROM ADM_UNIFORM_CARD_INDEX.G_BRANCH_DETAIL BD WHERE BD.G_BRANCH=BR.G_BRANCH)),
                            ACC_STATUS
                    FROM   (SELECT C.* FROM
                           (SELECT ROWNUM as RN, CA.ACCOUNT_NUMBER,H.CLIENT_ACCOUNT, H.G_CURRENCY,  CA.RNN, H.SUMM_ARREST
                              FROM HIS_ACCOUNTS_BLOCK H, CLIENT_ACCOUNTS CA
                             WHERE H.G_BLOCK_KIND in (12,13,14,'
                                                   ||'80,81,82,83,84'||-- добавлено MMD0000005143 от 20.10.2016
                                                   ')
                               AND H.IS_ARCHIVE = 0 AND H.IS_COMPLETE = 1 AND H.OPER_TYPE = 1
                               AND TRUNC(H.Block_Time) BETWEEN '''||FROM_DATE_||''' AND '''||rec.to_date||'''
                               AND (('''||rec.ingoing_num||''' IS NULL AND '''||rec.ingoing_date||''' IS NULL)OR('''||rec.ingoing_num||''' = H.DOC_NUMBER AND '''||rec.ingoing_date||''' = H.DOC_DATE))
                               AND H.CLIENT_ACCOUNT = CA.CLIENT_ACCOUNT
                               AND ('''||rec.g_branch||''' IS NULL OR ca.g_branch = '''||rec.g_branch||''')
                               AND CA.G_BANK_SYSTEM = 3) C
                             WHERE ROWNUM <= C.RN
                               ) H,
                            COLVIR.ZRS_UNIFORMCARDINDEX_ACC@AUCI_CRS3 V_RS,
                            (SELECT BAS.STATUS_CODE,
                                    DECODE('''||rec.lang||''', ''RU'', GS.status_name || '' (''||BAS.status_code||'')'', GS.status_name_kz || '' (''||BAS.status_code||'')'') acc_status
                               FROM G_ACCOUNTS_STATUS GS, BANK_SYSTEMS_ACCOUNT_STATUS BAS
                              WHERE BAS.G_BANK_SYSTEM = 3
                                AND BAS.G_ACCOUNT_STATUS = GS.G_ACCOUNT_STATUS
                                AND ('''||rec.account_status||''' = -1 OR (('''||rec.account_status||''' =1 and GS.G_ACCOUNT_STATUS in (1,4,5,6)) or ('''||rec.account_status||'''=2 and GS.G_ACCOUNT_STATUS in (2,3))))) BAS,
                            ADM_UNIFORM_CARD_INDEX.G_BRANCH BR,
                            UNIFORM_CARD_INDEX.G_CURRENCY CUR,
                            G_ACCOUNT_TYPES A
                    WHERE   UPPER(V_RS.STAT_CODE) = BAS.STATUS_CODE
                    AND     H.G_CURRENCY = CUR.G_CURRENCY
                    AND     V_RS.ACC_CODE = H.ACCOUNT_NUMBER
                    AND     V_RS.TAXCODE = H.RNN
                    AND     A.SYSTEM_ID = (CASE
                                             WHEN SUBSTR(V_RS.CODE_PR, 1, 2) = ''13'' AND V_RS.SPECFL = 0 THEN 4
                                             WHEN SUBSTR(V_RS.CODE_PR, 1, 2) = ''13'' AND V_RS.SPECFL = 1 THEN 13
                                             WHEN SUBSTR(V_RS.CODE_PR, 1, 2) = ''15'' THEN 3
                                             ELSE 1
                                           END)
                    AND     A.G_BANK_SYSTEM = 3
                    AND     V_RS.FILIAL = BR.COLVIR_CODE
                    AND     V_RS.STAT_CODE NOT IN (''CARRIED_OVER'')';
          /*if rec.account_number IS NOT NULL then
            SQL_RS:=SQL_RS||' AND V_RS.ACC_CODE = '''||rec.account_number||'''';
          end if;
          if CNT_ > 0 then
             SQL_RS:=SQL_RS||' AND V_RS.TAXCODE in '||str_;
          end if;*/

          --OW
          SQL_OW:='SELECT   --+ordered use_nl(H, T) parallel (2)
                            DISTINCT
                            uniform_card_index.kazwin_utf(T.LAST_NAM || '' '' || T.FIRST_NAM || '' '' || T.FATHER_S_NAM) as name,
                            T.IIN as rnn,
                            TRIM(T.CONTRACT_NUMBER) as account_number,
                            T.CURR as VAL_CODE,
                            DECODE('''||rec.lang||''', ''RU'', A.TYPE_NAME, A.TYPE_NAME_KZ) as ACC_TYPE,
                            null as acc_balance,
                            DECODE(H.SUMM_ARREST,NULL,NULL,
                                   H.SUMM_ARREST,trim(to_char(h.summ_arrest,''999999999999990D99'',''NLS_NUMERIC_CHARACTERS = '''',.'''''') || '' '' || CUR.SWIFT_CODE)
                                   ) as summ_arrest,
                            DECODE('''||rec.lang||''', ''RU'', BR.FULL_NAME_BRANCH, (SELECT BD.LONG_NAME_KZ FROM ADM_UNIFORM_CARD_INDEX.G_BRANCH_DETAIL BD WHERE BD.G_BRANCH=BR.G_BRANCH)),
                            DECODE('''||rec.lang||''',
                                    ''RU'',
                                    GS.status_name,
                                    GS.status_name_kz) || '' ('' || UPPER(T.CONTRACT_STATUS) || '')'' ACC_STATUS
                    FROM   (SELECT C.* FROM
                           (SELECT ROWNUM as RN, CA.ACCOUNT_NUMBER,H.CLIENT_ACCOUNT, H.G_CURRENCY,  CA.RNN, H.SUMM_ARREST
                              FROM HIS_ACCOUNTS_BLOCK H, CLIENT_ACCOUNTS CA
                             WHERE H.G_BLOCK_KIND in (12,13,14,'
                                                   ||'80,81,82,83,84'||-- добавлено MMD0000005143 от 20.10.2016
                                                   ')
                               AND H.IS_ARCHIVE = 0 AND H.IS_COMPLETE = 1 AND H.OPER_TYPE = 1
                               AND TRUNC(H.Block_Time) BETWEEN '''||FROM_DATE_||''' AND '''||rec.to_date||'''
                               AND (('''||rec.ingoing_num||''' IS NULL AND '''||rec.ingoing_date||''' IS NULL)OR('''||rec.ingoing_num||''' = H.DOC_NUMBER AND '''||rec.ingoing_date||''' = H.DOC_DATE))
                               AND H.CLIENT_ACCOUNT = CA.CLIENT_ACCOUNT
                               AND ('''||rec.g_branch||''' IS NULL OR ca.g_branch = '''||rec.g_branch||''')
                               AND CA.G_BANK_SYSTEM = 4) C
                             WHERE ROWNUM <= C.RN
                               ) H,
                            TEMP_CUR_OW4# T,
                            ADM_UNIFORM_CARD_INDEX.G_BRANCH BR,
                            ADM_UNIFORM_CARD_INDEX.Branch_Ow4 BO,
                            UNIFORM_CARD_INDEX.G_CURRENCY CUR,
                            G_ACCOUNT_TYPES A,
                            G_ACCOUNTS_STATUS GS
                    WHERE   GS.G_ACCOUNT_STATUS = DECODE(t.is_ready,''Y'',1,''C'',2,6)
                    AND     ('''||rec.account_status||''' = -1 OR (('''||rec.account_status||''' =1 and t.is_ready = ''Y'') or ('''||rec.account_status||'''=2 and t.is_ready = ''C'')))
                    AND     H.G_CURRENCY = CUR.G_CURRENCY
                    AND     TRIM(T.CONTRACT_NUMBER) = H.ACCOUNT_NUMBER
                    AND     T.IIN = H.RNN
                    AND     A.G_BANK_SYSTEM = 4
                    AND     DECODE(instr(t.scheme_name,''Special Account''),4,2,1) = A.SYSTEM_ID
                    AND     T.BRANCH = BO.BRANCH_CODE
                    AND     BO.G_BRANCH = BR.G_BRANCH
                    AND     LENGTH(TRIM(T.CONTRACT_NUMBER)) = 20
                    AND     substr(T.CONTRACT_NUMBER,1,2) != ''RS''';
          /*if rec.account_number IS NOT NULL then
            SQL_OW:=SQL_OW||' AND TRIM(T.CONTRACT_NUMBER) = '''||rec.account_number||'''';
          end if;
          if CNT_ > 0 then
             SQL_OW:=SQL_OW||' AND T.IIN in '||str_;
          end if;*/
          IF rec.G_BANK_SYSTEM = 2 or system_id = 1 OR rec.G_BANK_SYSTEM = -1 THEN -- BS
            SQL_ALL:=SQL_BS;
            SQL_ALL:= 'INSERT INTO ACCOUNTS_BLOCK.T_REQ_BLOCK(ID, CLI_NAME, IIN, ACCOUNT_NUMBER, VAL_CODE, TYPE_NAME, ACC_BALANCE, SUMM_ARREST, BRANCH_NAME, ACC_STATUS, REPORT_ID)
                     SELECT ACCOUNTS_BLOCK.SEQ_T_REQ_BLOCK.NEXTVAL, T.*, '||rec.id||' FROM (' || SQL_ALL ||') T';
            EXECUTE IMMEDIATE SQL_ALL;
            SQL_ALL:='';
          END IF;
          IF rec.G_BANK_SYSTEM = 3 or system_id = 3 OR rec.G_BANK_SYSTEM = -1 THEN -- RS
            SQL_ALL:=SQL_RS;
            SQL_ALL:= 'INSERT INTO ACCOUNTS_BLOCK.T_REQ_BLOCK(ID, CLI_NAME, IIN, ACCOUNT_NUMBER, VAL_CODE, TYPE_NAME, ACC_BALANCE, SUMM_ARREST, BRANCH_NAME, ACC_STATUS, REPORT_ID)
                     SELECT ACCOUNTS_BLOCK.SEQ_T_REQ_BLOCK.NEXTVAL, T.*, '||rec.id||' FROM (' || SQL_ALL ||') T';
            EXECUTE IMMEDIATE SQL_ALL;
            SQL_ALL:='';
          END IF;
          IF rec.G_BANK_SYSTEM = 4 or system_id = 2 OR rec.G_BANK_SYSTEM = -1 THEN -- OpenWay4
            IF rec.ACCOUNT_NUMBER IS NULL THEN
              OPEN CUR_T(FROM_DATE_, rec.to_date, rec.ingoing_num, rec.ingoing_date, rec.g_branch);
               LOOP
                 FETCH CUR_T INTO rec_t;
                 EXIT WHEN CUR_T%NOTFOUND;
                 BEGIN
                   RESULT_ := SET_OW4_CUR(rec_t.R_ACCOUNT_NUMBER,
                                          null,
                                          null,
                                          rec_t.R_rnn_,
                                          null);
                 END;
               END LOOP;
               CLOSE CUR_T;
            END IF;
            /*IF rec.account_number IS NOT NULL THEN
              RESULT_ := SET_OW4_CUR(rec.ACCOUNT_NUMBER,
                                     null,
                                     null,
                                     null,
                                     null);
            END IF;*/
            /*IF CNT_ > 0 THEN
              for iin_rec in (select column_value as iin from table(iin_list_))
              loop
                RESULT_ := SET_OW4_CUR(null,
                                       null,
                                       null,
                                       iin_rec.iin,
                                       null);

              end loop;
            END IF;*/
            SQL_ALL:=SQL_OW;
            SQL_ALL:= 'INSERT INTO ACCOUNTS_BLOCK.T_REQ_BLOCK(ID, CLI_NAME, IIN, ACCOUNT_NUMBER, VAL_CODE, TYPE_NAME, ACC_BALANCE, SUMM_ARREST, BRANCH_NAME, ACC_STATUS, REPORT_ID)
                     SELECT ACCOUNTS_BLOCK.SEQ_T_REQ_BLOCK.NEXTVAL, T.*, '||rec.id||' FROM (' || SQL_ALL ||') T';
            EXECUTE IMMEDIATE SQL_ALL;
            DELETE FROM TEMP_CUR_OW4# T;
            SQL_ALL:='';
          END IF;
          /*ELSIF rec.G_BANK_SYSTEM = -1 THEN --Все
            IF rec.ACCOUNT_NUMBER IS NULL THEN
              OPEN CUR_T(FROM_DATE_, rec.to_date, rec.ingoing_num, rec.ingoing_date, rec.g_branch);
               LOOP
                 FETCH CUR_T INTO rec_t;
                 EXIT WHEN CUR_T%NOTFOUND;
                 BEGIN
                   RESULT_ := SET_OW4_CUR(rec_t.R_ACCOUNT_NUMBER,
                                          null,
                                          null,
                                          rec_t.R_rnn_,
                                          null);

                 END;
               END LOOP;
               CLOSE CUR_T;
            END IF;
            \*IF rec.account_number IS NOT NULL THEN
              RESULT_ := SET_OW4_CUR(rec.ACCOUNT_NUMBER,
                                     null,
                                     null,
                                     null,
                                     null);

            END IF;
            IF CNT_ > 0 THEN
              for iin_rec in (select column_value as iin from table(iin_list_))
              loop
                RESULT_ := SET_OW4_CUR(null,
                                       null,
                                       null,
                                       iin_rec.iin,
                                       null);
              end loop;
            END IF;*\
            SQL_ALL:= SQL_BS || ' UNION ALL ' || SQL_RS || ' UNION ALL ' || SQL_OW;
          END IF;*/
        ELSIF REQ_CODE_ = 'ACC_EXISTS' THEN  --Наличие счетов
          select count(*)
          into   CNT2_
          from   g_requests r,
                 relat_report_req rr
          where  r.req_id = rr.req_id
          and    rr.report_id = rec.id
          and    r.req_code = 'ACC_BALANCE';
          IF CNT2_ = 0 THEN
            REQ_CODE_  := 'ACC_BALANCE';
            REQ_CODE_2 := 4;
          END IF;
        END IF;

        IF REQ_CODE_ = 'ACC_BALANCE' THEN  --Остаток по счету
          -- Выводит остаток по счету на дату FROM_DATE_
          IF rec.ACCOUNT_NUMBER is not null OR CNT_ > 0 THEN
            --BS
            SQL_BS:='SELECT  --+ordered use_nl(t, V_BS) parallel (2)
                             V_BS.CLI_LONGNAME as name,
                             V_BS.RNN as rnn,
                             V_BS.CODE_ACC as account_number,
                             V_BS.CODE as VAL_CODE,
                             DECODE('''||rec.lang||''', ''RU'', A.TYPE_NAME, A.TYPE_NAME_KZ) TYPE_NAME,
                             DECODE('||REQ_CODE_2||',
                                    4,
                                    NULL, --Наличие счетов
                                    3,
                                    trim(colvir.Z_EK_ACCOUNT_BAL@AUCI_CBS3C(V_BS.CODE_ACC,
                                                                                    '''||rec.to_date||'''))
                                                 ) as acc_balance,
                             DECODE('''||rec.lang||''',
                                    ''RU'',
                                    BR.FULL_NAME_BRANCH,
                                    (SELECT BD.LONG_NAME_KZ
                                       FROM ADM_UNIFORM_CARD_INDEX.G_BRANCH_DETAIL BD
                                      WHERE BD.G_BRANCH = BR.G_BRANCH)) BRANCH_NAME,
                             DECODE('''||rec.lang||''',
                                    ''RU'',
                                    GS.status_name || '' ('' || BAS.status_code || '')'',
                                    GS.status_name_kz || '' ('' || BAS.status_code || '')'') acc_status
                              FROM COLVIR.ZV_EK_ACCOUNT_LST@AUCI_CBS3C V_BS,
                                   BANK_SYSTEMS_ACCOUNT_STATUS         BAS,
                                   G_ACCOUNTS_STATUS                   GS,
                                   G_ACCOUNT_TYPES                     A,
                                   adm_uniform_card_index.g_branch     br
                     WHERE BAS.G_ACCOUNT_STATUS = GS.G_ACCOUNT_STATUS(+)
                       AND UPPER(V_BS.ACC_STATE) = BAS.STATUS_CODE(+)
                       AND BAS.G_BANK_SYSTEM(+) = 2
                       AND A.SYSTEM_ID = V_BS.ACCTYP
                       AND A.G_BANK_SYSTEM = 2
                       AND br.colvir_code = V_BS.CODE_DEP
                       AND ('||rec.account_status||' = -1 OR
                           (('||rec.account_status||' = 1 and
                           GS.G_ACCOUNT_STATUS in (1, 4, 5, 6)) or
                           ('||rec.account_status||' = 2 and
                           GS.G_ACCOUNT_STATUS in (2, 3))))';
            if rec.g_branch IS NOT NULL then
              SQL_BS:=SQL_BS||' AND br.g_branch = ' || rec.g_branch;
            end if;
            if rec.account_number IS NOT NULL then
              SQL_BS:=SQL_BS||' AND V_BS.CODE_ACC = '''||rec.account_number||'''';
            end if;
            IF CNT_ > 0 THEN
              SQL_BS:=SQL_BS||' AND V_BS.RNN in '||str_;
            END IF;

            --RS
            SQL_RS:='SELECT  --+ use_nl(V_RS) parallel (2)
                             V_RS.FIO as name,
                             V_RS.TAXCODE as rnn,
                             V_RS.ACC_CODE as account_number,
                             V_RS.VAL_CODE,
                             DECODE('''||rec.lang||''', ''RU'', A.TYPE_NAME, A.TYPE_NAME_KZ) as TYPE_NAME,
                             DECODE('''||REQ_CODE_2||''',
                                    4,
                                    NULL, --Наличие счетов
                                    3,
                                    trim(colvir.Z_EK_ACCOUNT_BAL@AUCI_CRS3(V_RS.ACC_CODE,
                                                                                   '''||rec.to_date||'''))
                                                 ) as acc_balance,
                             DECODE('''||rec.lang||''',
                                    ''RU'',
                                    BR.FULL_NAME_BRANCH,
                                    (SELECT BD.LONG_NAME_KZ
                                       FROM ADM_UNIFORM_CARD_INDEX.G_BRANCH_DETAIL BD
                                      WHERE BD.G_BRANCH = BR.G_BRANCH)) BRANCH_NAME,
                             DECODE('''||rec.lang||''',
                                    ''RU'',
                                    BAS.STATUS_NAME || '' ('' || BAS.status_code || '')'',
                                    bas.status_name_kz || '' ('' || BAS.status_code || '')'') acc_status
                        FROM (select --+ordered use_nl(t,n,o)
                                     O.CLI_NAME AS FIO,
                                     O.CODE AS ACC_CODE,
                                     O.VAL AS VAL_CODE,
                                     NVL(N.STAT_CODE, ''CLOSED'') STAT_CODE,
                                     NVL(N.CODE_PR, DECODE(O.DCL_CODE, ''0195'', ''1300'', ''1500'')) AS CODE_PR,
                                     N.FILIAL,
                                     O.TAXCODE,
                                     NVL(N.SPECFL,0) SPECFL
                                from COLVIR.ZRS_UNIFORMCARDINDEX_ACC@AUCI_CRS3 N,
                                     colvir.ZV_003_CLI_ACCOUNT_BSK@AUCI_CRS3 O
                               where nvl(N.STAT_CODE, ''CLOSED'') <> ''CARRIED_OVER''
                                 and O.CODE = N.ACC_CODE
                                 AND O.TAXCODE = N.TAXCODE
                                     :tax_list
                             ) V_RS,
                             BANK_SYSTEMS_ACCOUNT_STATUS               BAS,
                             G_ACCOUNT_TYPES                           A,
                             adm_uniform_card_index.g_branch           br
                       WHERE UPPER(V_RS.STAT_CODE) = BAS.STATUS_CODE(+)
                         AND BAS.G_BANK_SYSTEM(+) = 3
                         AND A.SYSTEM_ID = (CASE
                                              WHEN SUBSTR(V_RS.CODE_PR, 1, 2) = ''13'' AND V_RS.SPECFL = 0 THEN 4
                                              WHEN SUBSTR(V_RS.CODE_PR, 1, 2) = ''13'' AND V_RS.SPECFL = 1 THEN 13
                                              WHEN SUBSTR(V_RS.CODE_PR, 1, 2) = ''15'' THEN 3
                                              ELSE 1
                                            END)
                         AND A.G_BANK_SYSTEM = 3
                         AND br.colvir_code(+) = V_RS.FILIAL
                         AND ('||rec.account_status||' = -1 OR
                           (('||rec.account_status||' = 1 and
                           bas.G_ACCOUNT_STATUS in (1, 4, 5, 6)) or
                           ('||rec.account_status||' = 2 and
                           bas.G_ACCOUNT_STATUS in (2, 3))))';
            if rec.g_branch IS NOT NULL then
              SQL_RS:=SQL_RS||' AND br.g_branch = ' || rec.g_branch;
            end if;
            if rec.account_number IS NOT NULL then
              SQL_RS:=SQL_RS||' AND V_RS.ACC_CODE = '''||rec.account_number||'''';
            end if;
            IF CNT_ > 0 THEN
              --SQL_RS:=SQL_RS||' AND V_RS.TAXCODE in '||str_;
              SQL_RS := REPLACE(SQL_RS,':tax_list',' AND N.TAXCODE in '||str_);
            END IF;

            --OW
            SQL_OW:='SELECT  --+ordered use_nl(t, T) parallel (2)
                             DISTINCT
                             uniform_card_index.kazwin_utf(T.LAST_NAM || '' '' || T.FIRST_NAM || '' '' || T.FATHER_S_NAM) as name,
                             T.IIN as rnn,
                             TRIM(T.CONTRACT_NUMBER) as account_number,
                             T.CURR as VAL_CODE,
                             DECODE('''||rec.lang||''', ''RU'', A.TYPE_NAME, A.TYPE_NAME_KZ) as TYPE_NAME,
                             DECODE('''||REQ_CODE_2||''',
                                    4,
                                    NULL, --Наличие счетов
                                    3,
                                    UNIFORM_CARD_INDEX.Get_Balance_ow(T.IIN, TRIM(T.CONTRACT_NUMBER),'''||rec.to_date||''')) as acc_balance,
                             DECODE('''||rec.lang||''',
                                    ''RU'',
                                    BR.FULL_NAME_BRANCH,
                                    (SELECT BD.LONG_NAME_KZ
                                       FROM ADM_UNIFORM_CARD_INDEX.G_BRANCH_DETAIL BD
                                      WHERE BD.G_BRANCH = BR.G_BRANCH)) BRANCH_NAME,
                             DECODE('''||rec.lang||''',
                                    ''RU'',
                                    GS.status_name,
                                    GS.status_name_kz) || '' ('' || UPPER(T.CONTRACT_STATUS) || '')'' acc_status
                        FROM TEMP_CUR_OW4#                      T,
                             G_ACCOUNTS_STATUS                  GS,
                             uniform_card_index.g_resident_type r,
                             G_ACCOUNT_TYPES                    A,
                             adm_uniform_card_index.g_branch    br,
                             ADM_UNIFORM_CARD_INDEX.Branch_Ow4  BO
                       WHERE GS.G_ACCOUNT_STATUS = DECODE(t.is_ready,''Y'',1,''C'',2,6)
                         AND UPPER(R.TYPE_CODE) = UPPER(case
                                                          when T.RESIDENT IN
                                                               (''Commercial Resident'', ''Commercial NonResident'') THEN
                                                           ''Commercial Resident''
                                                          when T.RESIDENT IN
                                                               (''Private Resident'', ''Private NonResident'') THEN
                                                           ''Private Resident''
                                                          else
                                                           null
                                                        end)
                         AND (R.G_RESIDENT_TYPE = '''||rec.resident_type||''' OR '''||rec.resident_type||''' = -1)
                         AND A.G_BANK_SYSTEM = 4
                         AND (case when instr(t.scheme_name, ''Special Account'') > 0 then 2
                                else 1
                              end) =
                             A.SYSTEM_ID
                         AND BO.BRANCH_CODE = T.Branch
                         AND BO.G_BRANCH = br.g_branch
                         AND LENGTH(TRIM(T.CONTRACT_NUMBER)) = 20
                         AND substr(T.CONTRACT_NUMBER, 1, 2) != ''RS''
                         AND ('||rec.account_status||' = -1 OR
                           (('||rec.account_status||' = 1 and
                           t.is_ready = ''Y'') or
                           ('||rec.account_status||' = 2 and
                           t.is_ready = ''C'')))';
            if rec.g_branch IS NOT NULL then
              SQL_OW:=SQL_OW||' AND br.g_branch = ' || rec.g_branch;
            end if;
             if rec.account_number IS NOT NULL then
              SQL_OW:=SQL_OW||' AND TRIM(T.CONTRACT_NUMBER) = '''||rec.account_number||'''';
            end if;
            IF CNT_ > 0 THEN
              SQL_OW:=SQL_OW||' AND T.IIN in '||str_;
            END IF;

            CNT3_:=1;
            IF rec.G_BANK_SYSTEM = 2 or system_id = 1 THEN -- BS
              SQL_ALL:=SQL_BS;
            ELSIF rec.G_BANK_SYSTEM = 3 or system_id = 3 THEN -- RS
              SQL_ALL:=SQL_RS;
            ELSIF rec.G_BANK_SYSTEM = 4 or system_id = 2 THEN  -- OpenWay4
              IF rec.account_number IS NOT NULL THEN
                RESULT_ := SET_OW4_CUR(rec.ACCOUNT_NUMBER,
                                       null,
                                       null,
                                       null,
                                       null);
              END IF;
              IF CNT_ > 0 THEN
                for iin_rec in (select column_value as iin from table(iin_list_))
                loop
                  RESULT_ := SET_OW4_CUR(null,
                                         null,
                                         null,
                                         iin_rec.iin,
                                         null);
                end loop;
              END IF;
              SQL_ALL:=SQL_OW;
            ELSIF rec.G_BANK_SYSTEM = -1 THEN
              IF rec.account_number IS NOT NULL THEN
                RESULT_ := SET_OW4_CUR(rec.account_number,
                                       null,
                                       null,
                                       null,
                                       null);
              END IF;
              IF CNT_ > 0 THEN
                for iin_rec in (select column_value as iin from table(iin_list_))
                loop
                  RESULT_ := SET_OW4_CUR(null,
                                         null,
                                         null,
                                         iin_rec.iin,
                                         null);
                end loop;
              END IF;
              SQL_ALL:= SQL_BS || ' UNION ALL ' || SQL_RS || ' UNION ALL ' || SQL_OW;
            END IF;
            SQL_ALL:= 'INSERT  INTO T_REQ_BLOCK(ID, CLI_NAME, IIN, ACCOUNT_NUMBER, VAL_CODE, TYPE_NAME, ACC_BALANCE, BRANCH_NAME, ACC_STATUS, REPORT_ID)
                       SELECT  SEQ_T_REQ_BLOCK.NEXTVAL,
                               NVL(T.NAME, I.FIO) FIO,
                               NVL(T.RNN, I.IIN) IIN,
                               NVL(T.ACCOUNT_NUMBER, DECODE('''||rec.lang||''', ''RU'', ''Отсутствует'', ''Жо'' || CHR(53915))) ACCOUNT_NUMBER,
                               VAL_CODE,
                               TYPE_NAME,
                               ACC_BALANCE,--to_number(replace(ACC_BALANCE,'','' , ''.'' )) ACC_BALANCE,
                               BRANCH_NAME,
                               ACC_STATUS,
                               '||rec.id||'
                       FROM   (' || SQL_ALL ||') T
                       RIGHT JOIN (select * from t_iin i where i.list_id = '||rec.iin_list_id||') I
                       ON T.RNN = I.IIN';
            EXECUTE IMMEDIATE SQL_ALL;
            DELETE FROM TEMP_CUR_OW4# T;
          END IF;
        ELSIF REQ_CODE_ = 'ENCUMBRANCES' THEN --Обременения
          INSERT INTO T_REQ_ENCUMBRANCE(ID, CLI_NAME, IIN, ACCOUNT_NUMBER, ACC_VAL_CODE, BLOCK_NAME, DOC_NUMBER, DOC_DATE, BLOCK_TIME, SUM_ARREST, SUM_VAL_CODE, INITIATOR_NAME, BRANCH_NAME, REPORT_ID)
          SELECT /*+ rule*/
                 SEQ_T_REQ_ENCUMBRANCE.NEXTVAL,
                 ca.name cli_name, ca.rnn iin, ca.account_number, c1.swift_code acc_val_code,
                 bk.block_name, ab.doc_number, ab.doc_date,
                 ab.block_time, ab.summ_arrest sum_arrest, c2.swift_code sum_val_code, i.initiator_name,
                 br.full_name_branch,
                 rec.id
          FROM   client_accounts ca,
                 accounts_block ab,
                 uniform_card_index.g_currency c1,
                 uniform_card_index.g_currency c2,
                 g_initiators i,
                 g_block_kinds bk,
                 adm_uniform_card_index.g_branch br
          WHERE  ca.client_account = ab.client_account
          AND    ca.g_currency = c1.g_currency
          AND    ab.g_currency = c2.g_currency
          AND    ab.g_block_kind = bk.g_block_kind
          AND    ab.g_initiator = i.g_initiator
          AND    ca.g_branch = br.g_branch
          AND    (rec.g_branch IS NULL OR ca.g_branch = rec.g_branch)
          AND    TRUNC(ab.block_Time) <= trunc(rec.to_date)
          AND    ((rec.ingoing_num IS NULL AND rec.ingoing_date IS NULL) OR (rec.ingoing_num = ab.DOC_NUMBER AND rec.ingoing_date = ab.DOC_DATE))
          AND    (rec.account_number IS NULL OR ca.account_number = rec.account_number)
          AND    (/*CNT_ = 0 OR */CA.RNN IN (select * from table(iin_list_)));
        ELSIF REQ_CODE_ = 'UNBLOCKS' THEN  --Разблокировка
          INSERT INTO T_REQ_UNBLOCK(ID, CLI_NAME, IIN, SUMM_ARREST, BRANCH_NAME, REPORT_ID)
          SELECT  /*+ rule*/
                  SEQ_T_REQ_UNBLOCK.Nextval,
                  CA.NAME,
                  CA.RNN,
                  DECODE(H.SUMM_ARREST, NULL, NULL,
                         H.SUMM_ARREST, trim(to_char(H.SUMM_ARREST,'999999999999990D99','NLS_NUMERIC_CHARACTERS = '',.''') || ' ' || G.SWIFT_CODE)
                        )as SUMM_ARREST,
                  DECODE(rec.lang, 'RU', BR.FULL_NAME_BRANCH, (SELECT BD.LONG_NAME_KZ FROM ADM_UNIFORM_CARD_INDEX.G_BRANCH_DETAIL BD WHERE BD.G_BRANCH=BR.G_BRANCH)),
                  rec.id
          FROM    HIS_ACCOUNTS_BLOCK H,
                  CLIENT_ACCOUNTS CA,
                  UNIFORM_CARD_INDEX.G_BANK_SYSTEMS B,
                  ADM_UNIFORM_CARD_INDEX.G_BRANCH BR,
                  UNIFORM_CARD_INDEX.G_CURRENCY G
          WHERE   H.CLIENT_ACCOUNT = CA.CLIENT_ACCOUNT
          AND     CA.G_BANK_SYSTEM = B.G_BANK_SYSTEM
          AND     CA.G_BRANCH = BR.G_BRANCH
          AND     H.G_CURRENCY = G.G_CURRENCY
          AND     H.OPER_TYPE = 2
          AND     H.IS_ARCHIVE = 1
          AND     H.IS_COMPLETE = 1
          AND     H.G_BLOCK_KIND in (12,13,14,
                                     80,81,82,83,84-- добавлено MMD0000005143 от 20.10.2016
                                    )
          AND     (CA.G_BANK_SYSTEM = rec.G_BANK_SYSTEM OR rec.G_BANK_SYSTEM = -1)
          AND     TRUNC(H.UNBLOCK_TIME) BETWEEN FROM_DATE_ AND rec.to_date
          AND     (rec.g_branch IS NULL OR ca.g_branch = rec.g_branch)
          AND     (rec.account_number IS NULL OR ca.account_number = rec.account_number)
          AND     (CNT_ = 0 OR CA.RNN IN (select * from table(iin_list_)))
          AND     ((rec.ingoing_num IS NULL AND rec.ingoing_date IS NULL)OR(rec.ingoing_num = H.DOC_NUMBER AND rec.ingoing_date = H.DOC_DATE));
        ELSIF REQ_CODE_ = 'ACC_MOVE' THEN  --Движение по счету
          SELECT DECODE(system_id, 1, 2, 3, 3, 2, 4, system_id)
          INTO   BANK_SYSTEM_
          FROM   DUAL;
          UNIFORM_CARD_INDEX.GET_ARC_MOV(rec.id, 2, BANK_SYSTEM_, rec.account_number, FROM_DATE_, rec.to_date, ERR_MSG, available_);
          IF ERR_MSG IS NULL THEN
            INSERT INTO T_REQ_ACC_MOV(ID, OPER_DATE, DEBITS, CREDITS, VAL_CODE, DETAILS, REPORT_ID, ACC_REQ_MOV_ID)
            SELECT SEQ_T_REQ_ACC_MOV.Nextval, A.*, rec.id, rec.acc_req_mov_id
            FROM   (
                   SELECT DISTINCT DOPER,
                          (case when SDOK < 0 then SDOK else null end) debits,
                          (case when SDOK > 0 then SDOK else null end) credits,
                          VAL_K, TXT_DSCR
                     FROM UNIFORM_CARD_INDEX.ACC_MOV AC
                    WHERE AC.REPORT_ID = rec.id
                    ORDER BY DOPER
                   ) A;
            DELETE UNIFORM_CARD_INDEX.ACC_MOV AC
            WHERE  AC.REPORT_ID = rec.id;
          ELSE
            RAISE E_ERROR;
          END IF;
          IF BANK_SYSTEM_ = 2 THEN --CBS
            colvir.Z_003_TRNACCBINBYSPM@AUCI_CBS3C
                      (
                        null,
                        rec.ACCOUNT_NUMBER,
                        FROM_DATE_,
                        rec.to_date
                      );
            INSERT INTO T_REQ_ACC_MOV(ID, OPER_DATE, DEBITS, CREDITS, VAL_CODE, DETAILS, REPORT_ID,ACC_REQ_MOV_ID)
            select SEQ_T_REQ_ACC_MOV.Nextval,
                   DOPER as OPER_DATE,
                   CASE
                     WHEN decode(PRO, 'D', SDOK*-1, SDOK) < 0 THEN decode(PRO, 'D', SDOK*-1, SDOK)
                     ELSE NULL
                   END as DEBITS,
                   CASE
                     WHEN decode(PRO, 'D', SDOK*-1, SDOK) > 0 THEN decode(PRO, 'D', SDOK*-1, SDOK)
                     ELSE NULL
                   END as CREDITS,
                   VAL_K as CURRENCY,
                   replace(replace(replace(TXT_DSCR,chr(10),' '),chr(12),' '),chr(13),' ') as ASSIGN,
                   rec.id,
                   rec.acc_req_mov_id
            from   colvir.Z_003_ACCTRN@AUCI_CBS3C bs;
          ELSIF BANK_SYSTEM_ = 3 THEN -- RS
            colvir.Z_S03_TRNACCBINBYSPM@AUCI_CRS3
                      (
                        null,
                        rec.ACCOUNT_NUMBER,
                        FROM_DATE_,
                        rec.to_date
                      );
            INSERT INTO T_REQ_ACC_MOV(ID, OPER_DATE, DEBITS, CREDITS, VAL_CODE, DETAILS, REPORT_ID, ACC_REQ_MOV_ID)
            select SEQ_T_REQ_ACC_MOV.Nextval,
                   DOPER as OPER_DATE,
                   CASE
                     WHEN decode(PRO, 'D', SDOK*-1, SDOK) < 0 THEN decode(PRO, 'D', SDOK*-1, SDOK)
                     ELSE NULL
                   END as DEBITS,
                   CASE
                     WHEN decode(PRO, 'D', SDOK*-1, SDOK) > 0 THEN decode(PRO, 'D', SDOK*-1, SDOK)
                     ELSE NULL
                   END as CREDITS,
                   VAL_K as CURRENCY,
                   replace(replace(replace(TXT_DSCR,chr(10),' '),chr(12),' '),chr(13),' ') as ASSIGN,
                   rec.id,
                   rec.acc_req_mov_id
            from   colvir.Z_S03_ACCTRN@AUCI_CRS3 rs;
          ELSIF BANK_SYSTEM_ = 4 THEN --OW
            V_TABLE := kzc_bwx.OPT_INCASSO_PKG.FUNDS_MOVEMENTS@PROD.KZC(rec.ACCOUNT_NUMBER,
                                                                    FROM_DATE_,
                                                                    rec.to_date);
            FOR I IN 1 .. V_TABLE.COUNT
            LOOP
              INSERT INTO UNIFORM_CARD_INDEX.TEMP_OW4_FUNDS_MOVEMENTS#
                (CONTRACT_NUMBER,OPERATION_DATE,AMOUNT,CURR,DETAILS)
              VALUES
                (V_TABLE(I).CONTRACT_NUMBER,V_TABLE(I).OPERATION_DATE,V_TABLE(I).AMOUNT,V_TABLE(I).CURR,V_TABLE(I).DETAILS);
            END LOOP;
            INSERT INTO T_REQ_ACC_MOV(ID, OPER_DATE, DEBITS, CREDITS, VAL_CODE, DETAILS, REPORT_ID,ACC_REQ_MOV_ID)
            select SEQ_T_REQ_ACC_MOV.Nextval,
                   m.operation_date as OPER_DATE,
                   CASE
                     WHEN m.amount < 0 THEN m.amount
                     ELSE NULL
                   END as DEBITS,
                   CASE
                     WHEN m.amount > 0 THEN m.amount
                     ELSE NULL
                   END as CREDITS,
                   m.curr as CURRENCY,
                   m.details as ASSIGN,
                   rec.id,
                   rec.acc_req_mov_id
            from   UNIFORM_CARD_INDEX.TEMP_OW4_FUNDS_MOVEMENTS# m;
            delete UNIFORM_CARD_INDEX.TEMP_OW4_FUNDS_MOVEMENTS#;
          END IF;
        ELSIF REQ_CODE_ = 'DEPOSIT_BOXES' THEN --Сейфовые ячейки
          IF rec.G_BANK_SYSTEM IN (3, -1) AND CNT_ > 0 THEN
            COLVIR.C_PKGCONNECT.POPENLINK@AUCI_CRS3('NBPORT_SUBP', '1');
            SQL_ALL:='INSERT INTO T_REQ_DEPOSIT_BOXES(ID, REPORT_ID, IIN, BOX_CODE, BOX_DATE, STAT_NAME)
                      SELECT --+parallel(3)
                             SEQ_T_REQ_DEPOSIT_BOXES.NEXTVAL, '||rec.id||', BIN_IIN, SAFE_CODE, FROMDATE, STAT_NAME
                      FROM   colvir.Z_S03_SSAFEORD@'||RS_LINK_||'
                      WHERE  TRUNC(FROMDATE) <= '''||rec.to_date||'''
                      AND    BIN_IIN IN '||STR_;
            EXECUTE IMMEDIATE SQL_ALL;
          END IF;
        ELSIF REQ_CODE_ = 'CREDITS' THEN       --Кредиты
          SQL_BS:='COLVIR.C_PKGCONNECT.POPENLINK@'||BS_LINK_||'(''NBPORT_SUBP'', ''1'');
                   FOR REC IN (SELECT * FROM T_IIN T WHERE T.LIST_ID = '||rec.iin_list_id||') LOOP
                     INSERT INTO T_REQ_CREDITS(ID, REPORT_ID, IIN, DOG_NUMBER, DOG_DATE, AMOUNT, CLI_NAME, BS_OST_OD3, BS_LL4, BS_GG5, BS_UU6, BS_DDD7, BS_AAA8, BS_PCN_OD, BS_PCN_PROV)
                     SELECT --+parallel(3)
                            SEQ_T_REQ_CREDITS.NEXTVAL, '||rec.id||', TAXCODE, CODE, DORD, UNIFORM_CARD_INDEX.STR_TO_NUMBER(AMOUNT), rec.fio, OST_OD3, LL4, GG5, UU6, DDD7, AAA8, PCN_OD, PCN_PROV
                     FROM   colvir.Z_003_SLOAN_OS@'||BS_LINK_||'
                     WHERE  DORD <= '''||rec.to_date||'''
                     AND    TAXCODE = REC.IIN;
                   END LOOP; ';
          SQL_RS:='COLVIR.C_PKGCONNECT.POPENLINK@'||RS_LINK_||'(''NBPORT_SUBP'', ''1'');
                   FOR REC IN (SELECT * FROM T_IIN T WHERE T.LIST_ID = '||rec.iin_list_id||') LOOP
                     INSERT INTO T_REQ_CREDITS(ID, REPORT_ID, IIN, DOG_NUMBER, DOG_DATE, AMOUNT, CLI_NAME, RS_ALLSUMSHDOD, RS_LOAN_PEN, RS_LOAN_PEN_BEFDEBT, RS_LOAN_PEN_OFF_PRC, RS_CR_EXP_PD, RS_CR_WD_SH_BPR, RS_CR_PEN_PD_V, RS_CR_INT_CH)
                     SELECT --+parallel(3)
                            SEQ_T_REQ_CREDITS.NEXTVAL, '||rec.id||', IIN, CODE, DORD, UNIFORM_CARD_INDEX.STR_TO_NUMBER(AMOUNT), rec.fio, ALLSUMSHDOD, LOAN_PEN, LOAN_PEN_BEFDEBT, LOAN_PEN_OFF_PRC, CR_EXP_PD, CR_WD_SH_BPR, CR_PEN_PD_V, CR_INT_CH
                     FROM   colvir.Z_S03_SLOAN_OS@'||RS_LINK_||'
                     WHERE  DORD <= '''||rec.to_date||'''
                     AND    IIN = REC.IIN;
                   END LOOP; ';
          IF rec.g_bank_system = 2 THEN
            SQL_ALL:=SQL_BS;
          ELSIF rec.g_bank_system = 3 THEN
            SQL_ALL:=SQL_RS;
          ELSIF rec.g_bank_system = -1 THEN
            SQL_ALL:=SQL_BS||CHR(13)||CHR(10)||SQL_RS;
          ELSE
            SQL_ALL:='null;';
          END IF;
          IF CNT_ > 0 THEN
            EXECUTE IMMEDIATE 'BEGIN '||SQL_ALL||' END;';
          END IF;
        ELSIF REQ_CODE_ = 'ENSURING' THEN     --Обеспечения
          IF rec.G_BANK_SYSTEM IN (2, -1) AND CNT_ > 0 THEN
            SQL_ALL:='INSERT INTO T_REQ_ENSURING(ID, REPORT_ID, IIN, LONGNAME, ADDRESS, REG_DATE, FROM_DATE, TO_DATE)
                      SELECT --+parallel(3)
                             SEQ_T_REQ_ENSURING.NEXTVAL, '||rec.id||', IIN, LONGNAME, FULLADDR, DREG, FROMDATE, TODATE
                      FROM   colvir.Z_003_MRTORD@'||BS_LINK_||'
                      WHERE  '''||rec.to_date||''' BETWEEN FROMDATE AND TODATE
                      AND    IIN IN ' || STR_||';';
            EXECUTE IMMEDIATE 'BEGIN
                                 COLVIR.C_PKGCONNECT.POPENLINK@'||BS_LINK_||'(''NBPORT_SUBP'', ''1'');
                                 '||SQL_ALL||'
                               END;';
          END IF;
        ELSIF REQ_CODE_ = 'TRANSFERS' THEN      --Переводы
          IF rec.G_BANK_SYSTEM IN (3, -1) AND CNT_ > 0 THEN
            SQL_ALL:='INSERT INTO T_REQ_TRANSFERS(ID, REPORT_ID, IIN_CR, IIN_CL, ACCOUNT_NUMBER_CR, ACCOUNT_NUMBER_CL, FIO_CR, FIO_CL, DOC_DATE, VAL_CODE, AMOUNT, OPER_LONGNAME)
                      SELECT SEQ_T_REQ_TRANSFERS.NEXTVAL, '||rec.id||', T.*
                      FROM
                        (
                        SELECT --+ordered use_nl(t, RS) parallel (2)
                               RNN_CR, RNN_CL, CODE_ACR, null, TXT_BEN, TXT_PAY, DVAL, ACC_VAL_CODE,
                               UNIFORM_CARD_INDEX.STR_TO_NUMBER(AMOUNT), LONGNAME
                        FROM   colvir.Z_S03_MPAYORD@'||RS_LINK_||' RS
                        WHERE  DVAL <= '''||rec.to_date||'''
                        AND    RNN_CR IN '||STR_||'
                        UNION ALL
                        SELECT --+ordered use_nl(t, RS) parallel (2)
                               RNN_CR, RNN_CL, CODE_ACR, null, TXT_BEN, TXT_PAY, DVAL, ACC_VAL_CODE,
                               UNIFORM_CARD_INDEX.STR_TO_NUMBER(AMOUNT), LONGNAME
                        FROM   colvir.Z_S03_MPAYORD@'||RS_LINK_||' RS
                        WHERE  DVAL <= '''||rec.to_date||'''
                        AND    RNN_CL IN '||STR_||'
                        UNION ALL
                        SELECT --+ordered use_nl(t, RS) parallel (2)
                               RNN_P, RNN_B, ACC_PAY, null, null, null, DVAL, VALCODE,
                               UNIFORM_CARD_INDEX.STR_TO_NUMBER(AMOUNT), null
                        FROM   colvir.Z_S03_REQPAY@'||RS_LINK_||' RS
                        WHERE  DVAL <= '''||rec.to_date||'''
                        AND    RNN_P IN '||STR_||'
                        ) T;';
            EXECUTE IMMEDIATE 'BEGIN
                                 COLVIR.C_PKGCONNECT.POPENLINK@'||RS_LINK_||'(''NBPORT_SUBP'', ''1'');
                                 '||SQL_ALL||'
                               END;';
          END IF;
        END IF;
      END LOOP;

      select count(*)
      into CNT_
      from UNIFORM_CARD_INDEX.lst_proc_arc_db ls
               where ls.status = 0
                 and ls.request_id=rec.id;

      if cnt_=0 then
        UPDATE P_RPT_BU_REGISTRY R
        SET    R.Req_Status = 1
        WHERE  R.ID = rec.id;


      TXT_MESSAGE_ := 'Отчет по реестру блокирования/разблокирования счетов по вашему запросу готов, просьба проверить данные!';
      ADM_UNIFORM_CARD_INDEX.A_NOTICE_USER_ON_EMAIL(rec.official,
                                                    'NOTICE',
                                                    PROCNAME,
                                                    TXT_MESSAGE_);
     end if;

      COMMIT;
    EXCEPTION
      WHEN E_ERROR THEN
        ROLLBACK;
        UNIFORM_CARD_INDEX.INS_E_EXCEPTIONS_LOGS(PROCNAME, SQLCODE, null, rec.id||': '||ERR_MSG, SQL_ALL);
   UPDATE p_rpt_bu_registry r SET R.Req_Status = 4 WHERE r.id=rec.id;--по проблеме 3672 пропуск ошибочных запросов
  COMMIT;
        continue;
      WHEN OTHERS THEN
        ROLLBACK;
        ERR_MSG:=rec.id||': '||SQLERRM||'. '||DBMS_UTILITY.format_error_backtrace();
        UNIFORM_CARD_INDEX.INS_E_EXCEPTIONS_LOGS(PROCNAME, SQLCODE, null, ERR_MSG, SQL_ALL);
        UPDATE p_rpt_bu_registry r SET R.Req_Status = 4 WHERE r.id=rec.id;--по проблеме 3672 пропуск ошибочных запросов
        COMMIT;
        continue;
    END;
  END LOOP;
  CLOSE cur;
  --Очистка данных более месяца была перемещенна в процедуру P_REQ_PROCESSING_CL_mo так как долго отрабатывалась по проблеме 3672
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    ERR_MSG:=SQLERRM||'. '||DBMS_UTILITY.format_error_backtrace();
    UNIFORM_CARD_INDEX.INS_E_EXCEPTIONS_LOGS(PROCNAME, SQLCODE, null, ERR_MSG, null);
END;
/
