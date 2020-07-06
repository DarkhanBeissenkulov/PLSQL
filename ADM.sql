prompt
prompt Creating table G_BRANCH
prompt =======================
prompt
create table ADM_UNIFORM_CARD_INDEX.G_BRANCH
(
  g_branch         NUMBER not null,
  branch_hi        NUMBER,
  branch_code      VARCHAR2(10 CHAR) not null,
  branch_name      VARCHAR2(255 CHAR) not null,
  bik              VARCHAR2(30 CHAR),
  rnn              VARCHAR2(12 CHAR),
  is_active        NUMBER(1) default 1 not null,
  colvir_code      VARCHAR2(6 CHAR),
  card_branch      VARCHAR2(25 CHAR),
  bin              VARCHAR2(15 CHAR),
  address          VARCHAR2(250 CHAR),
  director_name    VARCHAR2(250 CHAR),
  chief_accountant VARCHAR2(250 CHAR),
  code_branch      VARCHAR2(10 CHAR),
  full_name_branch VARCHAR2(255 CHAR),
  chief_name_operu VARCHAR2(250 CHAR),
  dir_post         VARCHAR2(250 CHAR),
  chief_operu_post VARCHAR2(250 CHAR),
  colvir_bs_code   VARCHAR2(6 CHAR)
)
tablespace EKARCH
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
comment on table ADM_UNIFORM_CARD_INDEX.G_BRANCH
  is 'Справочник филиалов';
comment on column ADM_UNIFORM_CARD_INDEX.G_BRANCH.bik
  is 'БИК';
comment on column ADM_UNIFORM_CARD_INDEX.G_BRANCH.card_branch
  is 'Карточка филиала';
comment on column ADM_UNIFORM_CARD_INDEX.G_BRANCH.bin
  is 'БИН';
comment on column ADM_UNIFORM_CARD_INDEX.G_BRANCH.address
  is 'Адрес';
comment on column ADM_UNIFORM_CARD_INDEX.G_BRANCH.director_name
  is 'Директора ОФ/РФ';
comment on column ADM_UNIFORM_CARD_INDEX.G_BRANCH.chief_accountant
  is 'Главный бухгалтер';
comment on column ADM_UNIFORM_CARD_INDEX.G_BRANCH.chief_name_operu
  is 'Начальник ОПЕРУ';
comment on column ADM_UNIFORM_CARD_INDEX.G_BRANCH.dir_post
  is 'Должность директора';
comment on column ADM_UNIFORM_CARD_INDEX.G_BRANCH.chief_operu_post
  is 'Должность начальника ОПЕРУ';
create index ADM_UNIFORM_CARD_INDEX.IDX_COLVIR_CODE on ADM_UNIFORM_CARD_INDEX.G_BRANCH (COLVIR_CODE)
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
alter table ADM_UNIFORM_CARD_INDEX.G_BRANCH
  add constraint PK_G_BRANCH primary key (G_BRANCH)
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
alter table ADM_UNIFORM_CARD_INDEX.G_BRANCH
  add constraint FK_G_BRANCH_REL_114_G_BRANCH foreign key (BRANCH_HI)
  references ADM_UNIFORM_CARD_INDEX.G_BRANCH (G_BRANCH);
grant references on ADM_UNIFORM_CARD_INDEX.G_BRANCH to ACCOUNTS_BLOCK;
grant select on ADM_UNIFORM_CARD_INDEX.G_BRANCH to ACCOUNTS_BLOCK with grant option;
grant select, references on ADM_UNIFORM_CARD_INDEX.G_BRANCH to UNIFORM_CARD_INDEX;

prompt
prompt Creating table BRANCH_OW4
prompt =========================
prompt
create table ADM_UNIFORM_CARD_INDEX.BRANCH_OW4
(
  branch_code VARCHAR2(32 CHAR),
  g_branch    NUMBER
)
tablespace EKARCH
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
comment on table ADM_UNIFORM_CARD_INDEX.BRANCH_OW4
  is 'Справочник филиалов OW4';
alter table ADM_UNIFORM_CARD_INDEX.BRANCH_OW4
  add constraint UK_BRANCH_CODE unique (BRANCH_CODE)
  using index 
  tablespace INDX
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
alter table ADM_UNIFORM_CARD_INDEX.BRANCH_OW4
  add constraint FK_G_BRANCH_OW4 foreign key (G_BRANCH)
  references ADM_UNIFORM_CARD_INDEX.G_BRANCH (G_BRANCH);
grant select on ADM_UNIFORM_CARD_INDEX.BRANCH_OW4 to ACCOUNTS_BLOCK;
grant select on ADM_UNIFORM_CARD_INDEX.BRANCH_OW4 to UNIFORM_CARD_INDEX;

prompt
prompt Creating table G_BRANCH_DETAIL
prompt ==============================
prompt
create table ADM_UNIFORM_CARD_INDEX.G_BRANCH_DETAIL
(
  g_branch     NUMBER not null,
  long_name_kz VARCHAR2(500),
  post_code    VARCHAR2(10),
  address_kz   VARCHAR2(200),
  phone        VARCHAR2(100),
  fax          VARCHAR2(100)
)
tablespace EKARCH
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table ADM_UNIFORM_CARD_INDEX.G_BRANCH_DETAIL
  add constraint FK_G_BRANCH_DETAIL foreign key (G_BRANCH)
  references ADM_UNIFORM_CARD_INDEX.G_BRANCH (G_BRANCH);
grant select on ADM_UNIFORM_CARD_INDEX.G_BRANCH_DETAIL to ACCOUNTS_BLOCK;
grant select on ADM_UNIFORM_CARD_INDEX.G_BRANCH_DETAIL to UNIFORM_CARD_INDEX;

prompt
prompt Creating table G_LIST_SEND
prompt ==========================
prompt
create table ADM_UNIFORM_CARD_INDEX.G_LIST_SEND
(
  g_list_send NUMBER not null,
  list_code   VARCHAR2(20 CHAR),
  list_name   VARCHAR2(255 CHAR),
  is_active   NUMBER default 1
)
tablespace EKARCH
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
comment on table ADM_UNIFORM_CARD_INDEX.G_LIST_SEND
  is 'Справочник "Список рассылки"';
comment on column ADM_UNIFORM_CARD_INDEX.G_LIST_SEND.g_list_send
  is 'ID';
comment on column ADM_UNIFORM_CARD_INDEX.G_LIST_SEND.list_code
  is 'Код рассылки';
comment on column ADM_UNIFORM_CARD_INDEX.G_LIST_SEND.list_name
  is 'Наименование рассылки';
comment on column ADM_UNIFORM_CARD_INDEX.G_LIST_SEND.is_active
  is 'Активна (0-нет, 1 - да)';
alter table ADM_UNIFORM_CARD_INDEX.G_LIST_SEND
  add constraint PK_LIST_SEND primary key (G_LIST_SEND)
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


prompt
prompt Creating procedure A_GET_ROLE_INFO
prompt ==================================
prompt
CREATE OR REPLACE PROCEDURE ADM_UNIFORM_CARD_INDEX.A_GET_ROLE_INFO
(
  IN_G_ROLE IN NUMBER, OUT_ROLE_CODE OUT VARCHAR2, OUT_ROLE_NAME OUT VARCHAR2,
  OUT_ROLE_SHORT_NAME OUT VARCHAR2, CUR_RIGHT OUT TYPE_LIBRARY.CUR,
  CUR_MENU OUT TYPE_LIBRARY.CUR
) IS
BEGIN
  SELECT R.ROLE_CODE, R.ROLE_NAME, R.ROLE_SHORT_NAME
  INTO   OUT_ROLE_CODE, OUT_ROLE_NAME, OUT_ROLE_SHORT_NAME
  FROM   G_ROLES R
  WHERE  R.G_ROLE = IN_G_ROLE;
  OPEN CUR_RIGHT FOR
    SELECT A.R_ACTION, A.ACTION_NAME
    FROM   G_ROLES R, R_RIGHTS_ITEMS RR, R_ACTIONS A
    WHERE  R.G_ROLE = RR.G_ROLE
           AND RR.R_ACTION = A.R_ACTION
           AND A.IS_ACTIVE = 1
           AND R.G_ROLE = IN_G_ROLE;
  OPEN CUR_MENU FOR
    SELECT A.R_MENU_ITEM, A.ITEM_NAME
    FROM   G_ROLES R, R_MENU_ITEMS_ROLES RR, R_MENU_ITEMS A
    WHERE  R.G_ROLE = RR.G_ROLE
           AND RR.R_MENU_ITEM = A.R_MENU_ITEM
           AND A.IS_ACTIVE = 1
           AND R.G_ROLE = IN_G_ROLE;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    RAISE;
END A_GET_ROLE_INFO;
/

prompt
prompt Creating procedure A_NOTICE_ON_EMAIL
prompt ====================================
prompt
CREATE OR REPLACE PROCEDURE ADM_UNIFORM_CARD_INDEX.A_NOTICE_ON_EMAIL
(
  IN_LIST_CODE IN VARCHAR2, IN_G_BRANCH IN NUMBER, IN_G_BANK_SYSTEM IN NUMBER,
  IN_TXT_MESSAGE IN CLOB
) IS
  -- Author  : Bahgeldiev Baglan
  -- Created : 28.06.2010
  -- Purpose :
  LNG_      NUMBER;
  MSG_BODY_ CLOB;
  CURSOR CUR_MAIL(LIST_CODE_ VARCHAR2, G_BRANCH_ NUMBER, G_BANK_SYSTEM_ NUMBER) IS
    SELECT DISTINCT O.NAME, O.EMAIL, L.LIST_NAME
    FROM   NOTIFICATIONS_LIST LN, NOTIFICATIONS_LIST_OFFICIAL LO,
           G_LIST_SEND L, OFFICIALS O
    WHERE  LN.NOTIFICATION_LIST = LO.NOTIFICATION_LIST
           AND LO.OFFICIAL = O.OFFICIAL
           AND LN.G_LIST_SEND = L.G_LIST_SEND
           AND L.LIST_CODE = LIST_CODE_
           AND LN.G_BANK_SYSTEM = G_BANK_SYSTEM_
           AND O.G_BRANCH IN (G_BRANCH_, 2);
  TYPE T_REC IS RECORD(
    NAME_    ADM_UNIFORM_CARD_INDEX.OFFICIALS.NAME%TYPE,
    EMAIL_   ADM_UNIFORM_CARD_INDEX.OFFICIALS.EMAIL%TYPE,
    SUBJECT_ ADM_UNIFORM_CARD_INDEX.G_LIST_SEND.LIST_NAME%TYPE);
  CURREC T_REC;
BEGIN
  OPEN CUR_MAIL(IN_LIST_CODE, IN_G_BRANCH, IN_G_BANK_SYSTEM);
  LOOP
    <<FETCHNEXT>>
    FETCH CUR_MAIL
      INTO CURREC;
    EXIT WHEN CUR_MAIL%NOTFOUND;
    MSG_BODY_ := '<HTML><HEAD><META http-equiv=Content-Type content="text/html; charset=utf-8">' ||
                 '  <style>BODY { ' ||
                 '  margin-left: 0px;  margin-top: 0px;  margin-right: 0px;  margin-bottom: 0px;  background-color: #FFFFFF;  SCROLLBAR-FACE-COLOR: #9d9d9d; ' ||
                 '  SCROLLBAR-HIGHLIGHT-COLOR: #FFFFFF;  SCROLLBAR-SHADOW-COLOR: #FFFFFF; SCROLLBAR-3DLIGHT-COLOR: #9d9d9d;  SCROLLBAR-ARROW-COLOR: #93B488; ' ||
                 '  SCROLLBAR-TRACK-COLOR: #ECEFF0;  SCROLLBAR-DARKSHADOW-COLOR: #9d9d9d;} ' ||
                 '  #TableMenuHeader {BORDER-LEFT: #808080 1px solid;  BORDER-RIGHT: #808080 1px solid;  BORDER-TOP: #808080 1px solid;BORDER-BOTTOM: #808080 1px solid; ' ||
                 '  font-family: Tahoma, Verdana, Arial, Helvetica, sans-serif; ' ||
                 '  font-size:11px;  font-weight:bold;  color:#FFFFFF;  padding-left:8px;  padding-top: 2px;  padding-bottom: 2px;  height: 25px;  white-space: nowrap;  }  ' ||
                 ' #TableMenuItems {  BACKGROUND-COLOR: #FFFFFF;  font-family: Tahoma, Verdana, Arial, Helvetica, sans-serif;  font-size: 11px;color: #646464;} ' ||
                 ' </style></HEAD>' ||
                 ' <BODY><TABLE width="100%" height="100%" border="0" cellPadding="0" cellspacing="0">' ||
                 ' <TR vAlign=top><TD width="5px" nowrap></TD>' ||
                 ' <TD style="padding-top: 6px;"><table id="TableMenuHeader" width="100%" cellPadding="0" cellspacing="0"><tr>' ||
                 ' <td style="background-repeat:repeat-x; background-color:#a3a3a3;">Уведомление о поступлении запроса</td></tr>' ||
                 ' </table><table id="TableMenuItems" width="100%" cellPadding="0" cellspacing="0"><tr><td><br/> <b>Уважаемый(ая),</b> ' ||
                 CURREC.NAME_ || '<br/>' || IN_TXT_MESSAGE || '<br/><br/>' ||
                 '<tr><td style="BORDER-BOTTOM: #c3c3c3 1pt solid; BORDER-TOP: #c3c3c3 1pt solid">' ||
                 ' <SPAN  style="FONT: 11px sans-serif; COLOR: #646464">' ||
                 ' Данное письмо создано автоматически.<br/>Пожалуйста, не отвечайте на него.<br /></table></TD>' ||
                 ' <TD width="10px" nowrap></TD>' ||
                 ' </TR> </TABLE> </BODY></HTML>';
    LNG_      := LENGTH(MSG_BODY_);
    A_SEND_BODY_MAIL(CURREC.EMAIL_,
                     MSG_BODY_,
                     CURREC.SUBJECT_,
                     'Module RPRO');
    MSG_BODY_ := '';
  END LOOP;
  CLOSE CUR_MAIL;
END A_NOTICE_ON_EMAIL;
/
grant execute on ADM_UNIFORM_CARD_INDEX.A_NOTICE_ON_EMAIL to UNIFORM_CARD_INDEX;


prompt
prompt Creating procedure SEND_EMAIL_WITH_ATTACHMENT
prompt =============================================
prompt
CREATE OR REPLACE PROCEDURE ADM_UNIFORM_CARD_INDEX.SEND_EMAIL_WITH_ATTACHMENT(SENDER_EMAIL_ADDRESS VARCHAR2,
                                                       -- Must be single E-mail address
                                                       RECIPIENT_EMAIL_ADDRESSES VARCHAR2,
                                                       EMAIL_SUBJECT VARCHAR2,
                                                       EMAIL_BODY_TEXT VARCHAR2,
                                                       EMAIL_ATTACHMENT_TEXT CLOB,
                                                       -- No restriction on size of text
                                                       EMAIL_ATTACHMENT_FILE_NAME VARCHAR2) IS
  C                             UTL_TCP.CONNECTION;
  RC                            BINARY_INTEGER;
  V_NEXT_COLUMN                 BINARY_INTEGER;
  V_RECIPIENT_EMAIL_LENGTH      BINARY_INTEGER;
  V_RECIPIENT_EMAIL_ADDRESSES   VARCHAR2(500);
  V_SINGLE_RECIPIENT_EMAIL_ADDR VARCHAR2(100);
  -- Variables to divide the CLOB into 32000 character segments to write to the file
  J                             BINARY_INTEGER;
  CURRENT_POSITION              BINARY_INTEGER := 1;
  EMAIL_ATTACHMENT_TEXT_SEGMENT CLOB;
BEGIN
  V_RECIPIENT_EMAIL_ADDRESSES := RECIPIENT_EMAIL_ADDRESSES;
  V_RECIPIENT_EMAIL_LENGTH    := LENGTH(V_RECIPIENT_EMAIL_ADDRESSES);
  V_RECIPIENT_EMAIL_ADDRESSES := V_RECIPIENT_EMAIL_ADDRESSES || ','; -- Add comma for the last asddress
  V_NEXT_COLUMN               := 1;
  IF INSTR(V_RECIPIENT_EMAIL_ADDRESSES, ',') = 0 THEN
    -- Single E-mail address
    V_SINGLE_RECIPIENT_EMAIL_ADDR := V_RECIPIENT_EMAIL_ADDRESSES;
    V_RECIPIENT_EMAIL_LENGTH      := 1;
  END IF;
  -- Open the SMTP port 25 on UWA mailhost local machine
  C := UTL_TCP.OPEN_CONNECTION('monarch', 25);
  -- Performs handshaking with the SMTP Server.  HELO is the correct spelling.
  -- DO NOT CHANGE.  Causes problems.
  RC := UTL_TCP.WRITE_LINE(C, 'HELO localhost');
  DBMS_OUTPUT.PUT_LINE(UTL_TCP.GET_LINE(C, TRUE));
  WHILE V_NEXT_COLUMN <= V_RECIPIENT_EMAIL_LENGTH
  LOOP
    -- Process Multiple E-mail addresses in the loop OR single E-mail address once.
    V_SINGLE_RECIPIENT_EMAIL_ADDR := SUBSTR(V_RECIPIENT_EMAIL_ADDRESSES,
                                            V_NEXT_COLUMN,
                                            INSTR(V_RECIPIENT_EMAIL_ADDRESSES,
                                                  ',',
                                                  V_NEXT_COLUMN) -
                                            V_NEXT_COLUMN);
    V_NEXT_COLUMN                 := INSTR(V_RECIPIENT_EMAIL_ADDRESSES,
                                           ',',
                                           V_NEXT_COLUMN) + 1;
    RC                            := UTL_TCP.WRITE_LINE(C,
                                                        'MAIL FROM: ' ||
                                                        SENDER_EMAIL_ADDRESS); -- MAIL BOX SENDING THE EMAIL
    DBMS_OUTPUT.PUT_LINE(UTL_TCP.GET_LINE(C, TRUE));
    RC := UTL_TCP.WRITE_LINE(C,
                             'RCPT TO: ' || V_SINGLE_RECIPIENT_EMAIL_ADDR); -- MAIL BOX RECIEVING THE EMAIL
    DBMS_OUTPUT.PUT_LINE(UTL_TCP.GET_LINE(C, TRUE));
    RC := UTL_TCP.WRITE_LINE(C, 'DATA'); -- START EMAIL MESSAGE BODY
    DBMS_OUTPUT.PUT_LINE(UTL_TCP.GET_LINE(C, TRUE));
    RC := UTL_TCP.WRITE_LINE(C,
                             'Date: ' ||
                             TO_CHAR(SYSDATE, 'dd Mon yy hh24:mi:ss'));
    RC := UTL_TCP.WRITE_LINE(C, 'From: ' || SENDER_EMAIL_ADDRESS);
    RC := UTL_TCP.WRITE_LINE(C, 'MIME-Version: 1.0');
    RC := UTL_TCP.WRITE_LINE(C, 'To: ' || V_SINGLE_RECIPIENT_EMAIL_ADDR);
    RC := UTL_TCP.WRITE_LINE(C, 'Subject: ' || EMAIL_SUBJECT);
    RC := UTL_TCP.WRITE_LINE(C, 'Content-Type: multipart/mixed;'); -- INDICATES THAT THE BODY CONSISTS OF MORE THAN ONE PART
    RC := UTL_TCP.WRITE_LINE(C, ' boundary="-----SECBOUND"'); -- SEPERATOR USED TO SEPERATE THE BODY PARTS
    RC := UTL_TCP.WRITE_LINE(C, '-------SECBOUND');
    RC := UTL_TCP.WRITE_LINE(C, 'Content-Type: text/plain'); -- 1ST BODY PART. EMAIL TEXT MESSAGE
    RC := UTL_TCP.WRITE_LINE(C, 'Content-Transfer-Encoding: 7bit');
    RC := UTL_TCP.WRITE_LINE(C, EMAIL_BODY_TEXT); -- TEXT OF EMAIL MESSAGE
    RC := UTL_TCP.WRITE_LINE(C, '-------SECBOUND');
    RC := UTL_TCP.WRITE_LINE(C, 'Content-Type: text/plain;'); -- 2ND BODY PART.
    RC := UTL_TCP.WRITE_LINE(C,
                             ' name="' || EMAIL_ATTACHMENT_FILE_NAME || '"');
    RC := UTL_TCP.WRITE_LINE(C, 'Content-Transfer_Encoding: 8bit');
    RC := UTL_TCP.WRITE_LINE(C, 'Content-Disposition: attachment;'); -- INDICATES THAT THIS IS AN ATTACHMENT
    -- Divide the CLOB into 32000 character segments to write to the file.
    -- Even though SUBSTR looks for 32000 characters, UTL_TCP.WRITE_LINE does not blank pad it.
    CURRENT_POSITION := 1;
    J                := (ROUND(LENGTH(EMAIL_ATTACHMENT_TEXT)) / 32000) + 1;
    DBMS_OUTPUT.PUT_LINE('j= ' || J || ' length=  ' ||
                         LENGTH(EMAIL_ATTACHMENT_TEXT));
    FOR I IN 1 .. J
    LOOP
      EMAIL_ATTACHMENT_TEXT_SEGMENT := SUBSTR(EMAIL_ATTACHMENT_TEXT,
                                              CURRENT_POSITION,
                                              32000);
      RC                            := UTL_TCP.WRITE_LINE(C,
                                                          EMAIL_ATTACHMENT_TEXT_SEGMENT);
      CURRENT_POSITION              := CURRENT_POSITION + 32000;
    END LOOP;
    RC := UTL_TCP.WRITE_LINE(C, '-------SECBOUND--');
    RC := UTL_TCP.WRITE_LINE(C, '.'); -- END EMAIL MESSAGE BODY
    DBMS_OUTPUT.PUT_LINE(UTL_TCP.GET_LINE(C, TRUE));
    DBMS_OUTPUT.PUT_LINE('***** Single E-mail= ' ||
                         V_SINGLE_RECIPIENT_EMAIL_ADDR || '  ' ||
                         V_NEXT_COLUMN);
  END LOOP;
  RC := UTL_TCP.WRITE_LINE(C, 'QUIT'); -- ENDS EMAIL TRANSACTION
  DBMS_OUTPUT.PUT_LINE(UTL_TCP.GET_LINE(C, TRUE));
  UTL_TCP.CLOSE_CONNECTION(C); -- CLOSE SMTP PORT CONNECTION
END; --  of Procedure SEND_EMAIL_WITH_ATTACHMENT
/

prompt
prompt Creating procedure SET_BRANCH_DATA
prompt ==================================
prompt
create or replace procedure adm_uniform_card_index.SET_BRANCH_DATA
(
  in_user_code  in varchar2,
  in_dir_post   in varchar2,
  in_dir        in varchar2,
  in_operu_post in varchar2,
  in_operu      in varchar2,
  out_message   out varchar2
)
is
  branch_ g_branch.g_branch%type;
begin
  begin
    select o.g_branch
    into   branch_
    from officials o
    where o.user_code = in_user_code;
  exception
    when no_data_found then
      out_message:='Ой!! А юзер с учеткой: '||in_user_code||' к великому сожалению не найден!';
  end;
  update g_branch b
  set b.dir_post = in_dir_post,
      b.director_name = in_dir,
      b.chief_operu_post = in_operu_post,
      b.chief_name_operu = in_operu
  where b.g_branch = branch_;
  
  exception
    when others then
      out_message:='Ой!! Неведомая ошибка!';
end SET_BRANCH_DATA;
/
