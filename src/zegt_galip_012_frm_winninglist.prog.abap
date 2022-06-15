*&---------------------------------------------------------------------*
*& Include          ZEGT_GALIP_012_FRM_WINNINGLIST
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Form CHECK_TICKET_AND_winning_DATES
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*      <--P_CHECK_SUCCESSFUL  text
*&---------------------------------------------------------------------*
FORM check_ticket_and_lottery_dates  CHANGING p_check_successful.
  CONCATENATE p_date2+6(2) p_date2+4(2) p_date2(4) INTO DATA(lv_date2) SEPARATED BY '.'.

  SELECT COUNT(*) UP TO 1 ROWS
    FROM zegt_galip_t005
    WHERE ticket_date EQ lv_date2.

  IF sy-dbcnt = 0.
    p_check_successful = ' '.
    MESSAGE 'Bu tarihli bilet yok.' TYPE 'I'.
    EXIT.
  ENDIF.

  SELECT COUNT(*) UP TO 1 ROWS
    FROM zegt_galip_t006
    WHERE lottery_date EQ lv_date2.

  IF sy-dbcnt = 0.
    p_check_successful = ' '.
    MESSAGE 'Bu tarihte çekiliş yapılmamış.' TYPE 'S' DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.

  p_check_successful = 'X'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_WINNING_FIELDCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_winning_fieldcat .
  CLEAR gs_winning_fieldcat.
  gs_winning_fieldcat-col_pos = 1.
  gs_winning_fieldcat-fieldname = 'TICKET_NO'.
  gs_winning_fieldcat-scrtext_s = 'Bilet No.'.
  gs_winning_fieldcat-scrtext_m = 'Bilet Numarası'.
  gs_winning_fieldcat-scrtext_l = 'Bilet Numarası'.
  gs_winning_fieldcat-intlen = 40.
  APPEND gs_winning_fieldcat TO gt_winning_fieldcat.

  CLEAR gs_winning_fieldcat.
  gs_winning_fieldcat-col_pos = 2.
  gs_winning_fieldcat-fieldname = 'PRIZE_TYPE'.
  gs_winning_fieldcat-scrtext_s = 'Ödül T.'.
  gs_winning_fieldcat-scrtext_m = 'Ödül Türü'.
  gs_winning_fieldcat-scrtext_l = 'Ödül Türü'.
  gs_winning_fieldcat-intlen = 40.
  APPEND gs_winning_fieldcat TO gt_winning_fieldcat.

  CLEAR gs_winning_fieldcat.
  gs_winning_fieldcat-col_pos = 3.
  gs_winning_fieldcat-fieldname = 'PRIZE_AMOUNT'.
  gs_winning_fieldcat-scrtext_s = 'İkramiye'.
  gs_winning_fieldcat-scrtext_m = 'İkramiye'.
  gs_winning_fieldcat-scrtext_l = 'İkramiye'.
  gs_winning_fieldcat-intlen = 40.
  APPEND gs_winning_fieldcat TO gt_winning_fieldcat.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_DYNAMIC_WINNING_TABLE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_dynamic_winning_table .
  CONCATENATE p_date2+6(2) p_date2+4(2) p_date2(4) INTO DATA(lv_date2) SEPARATED BY '.'.
  DATA: lt_itab1 TYPE RANGE OF char7,
        lt_itab2 TYPE RANGE OF char7,
        lt_itab3 TYPE RANGE OF char7,
        lt_itab4 TYPE RANGE OF char7,
        lt_itab5 TYPE RANGE OF char7,
        lt_itab6 TYPE RANGE OF char7,
        lt_itab7 TYPE RANGE OF char7,
        ls_itab  LIKE LINE OF lt_itab1.
  ls_itab-sign = 'I'.
  ls_itab-option = 'EQ'.

  DATA record_count TYPE i.
  DATA lv_pred_cnt TYPE i.

  SELECT COUNT(*)
    FROM zegt_galip_t005
    WHERE ticket_date EQ lv_date2.

  record_count = sy-dbcnt.

  SELECT ticket_no
    FROM zegt_galip_t005
    WHERE ticket_date EQ @lv_date2
    INTO TABLE @DATA(lt_tickettab).

  FIELD-SYMBOLS <lfs_ticket> LIKE LINE OF lt_tickettab.

  SELECT winning_number
    FROM zegt_galip_t006
    WHERE lottery_date EQ @lv_date2
    INTO TABLE @DATA(lt_itab).

  DATA: BEGIN OF gty_prize,
          predicted_count TYPE integer,
          prize_amount    TYPE wert,
        END OF gty_prize.

  DATA: lt_prize LIKE SORTED TABLE OF gty_prize WITH UNIQUE KEY predicted_count.

  SELECT predicted_count,
         prize_amount
    FROM zegt_galip_t007
    INTO TABLE @lt_prize.

  DATA iterator TYPE i.
  iterator = 1.
  WHILE iterator <= 78.
    READ TABLE lt_itab INDEX iterator ASSIGNING FIELD-SYMBOL(<lfs_line>).
    IF sy-subrc = 0.
      DATA(strlength) = strlen( <lfs_line>-winning_number ).
      ls_itab-low = <lfs_line>-winning_number.
      IF strlength = 1.
        APPEND ls_itab TO lt_itab1.
      ELSEIF strlength = 2.
        APPEND ls_itab TO lt_itab2.
      ELSEIF strlength = 3.
        APPEND ls_itab TO lt_itab3.
      ELSEIF strlength = 4.
        APPEND ls_itab TO lt_itab4.
      ELSEIF strlength = 5.
        APPEND ls_itab TO lt_itab5.
      ELSEIF strlength = 6.
        APPEND ls_itab TO lt_itab6.
      ELSE.
        APPEND ls_itab TO lt_itab7.
      ENDIF.
    ENDIF.
    iterator = iterator + 1.
  ENDWHILE.

  FIELD-SYMBOLS <lfs> LIKE LINE OF lt_itab.

  CALL METHOD cl_alv_table_create=>create_dynamic_table
    EXPORTING
      it_fieldcatalog = gt_winning_fieldcat    " Field Catalog
    IMPORTING
      ep_table        = gt_dynamic_winning_table.    " Pointer to Dynamic Data Table
  ASSIGN gt_dynamic_winning_table->* TO <dyn_winning_table>.
  CREATE DATA gs_dynamic_winning_table LIKE LINE OF <dyn_winning_table>.
  ASSIGN gs_dynamic_winning_table->* TO <gfs_winning_table>.

  iterator = 1.
  WHILE iterator <= record_count.
    APPEND INITIAL LINE TO <dyn_winning_table> ASSIGNING <gfs_winning_table>.
    IF <gfs_winning_table> IS ASSIGNED.
      ASSIGN COMPONENT 'TICKET_NO' OF STRUCTURE <gfs_winning_table> TO <gfs_winning>.
      IF <gfs_winning> IS ASSIGNED.
        READ TABLE lt_tickettab INDEX iterator ASSIGNING <lfs_ticket>.
        IF sy-subrc = 0.
          <gfs_winning> = <lfs_ticket>-ticket_no.
        ENDIF.
      ENDIF.
      ASSIGN COMPONENT 'PRIZE_TYPE' OF STRUCTURE <gfs_winning_table> TO <gfs_winning>.
      IF <gfs_winning> IS ASSIGNED.
        IF <lfs_ticket>-ticket_no IN lt_itab7.
          lv_pred_cnt = 7.
          <gfs_winning> = 'Büyük ikramiyeyi kazandı!'.
        ELSEIF <lfs_ticket>-ticket_no+1 IN lt_itab6.
          lv_pred_cnt = 6.
          <gfs_winning> = 'Son 6 rakamına göre kazandı'.
        ELSEIF <lfs_ticket>-ticket_no+2 IN lt_itab5.
          lv_pred_cnt = 5.
          <gfs_winning> = 'Son 5 rakamına göre kazandı'.
        ELSEIF <lfs_ticket>-ticket_no+3 IN lt_itab4.
          lv_pred_cnt = 4.
          <gfs_winning> = 'Son 4 rakamına göre kazandı'.
        ELSEIF <lfs_ticket>-ticket_no+4 IN lt_itab3.
          lv_pred_cnt = 3.
          <gfs_winning> = 'Son 3 rakamına göre kazandı'.
        ELSEIF <lfs_ticket>-ticket_no+5 IN lt_itab2.
          lv_pred_cnt = 2.
          <gfs_winning> = 'Son 2 rakamına göre kazandı'.
        ELSEIF <lfs_ticket>-ticket_no+6 IN lt_itab1.
          lv_pred_cnt = 1.
          <gfs_winning> = 'Amorti'.
        ELSE.
          lv_pred_cnt = 0.
          <gfs_winning> = 'Kazanamadı'.
        ENDIF.
      ENDIF.
      ASSIGN COMPONENT 'PRIZE_AMOUNT' OF STRUCTURE <gfs_winning_table> TO <gfs_winning>.
      IF <gfs_winning> IS ASSIGNED.
        READ TABLE lt_prize WITH TABLE KEY predicted_count = lv_pred_cnt INTO DATA(lv_count).
        <gfs_winning> = lv_count-prize_amount.
      ENDIF.
    ENDIF.
    iterator = iterator + 1.
  ENDWHILE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_WINNING_SCREEN
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_winning_screen .
  IF go_winning_alv IS INITIAL.
    PERFORM set_winning_layout.

    CREATE OBJECT go_winning_alv
      EXPORTING
        i_parent = cl_gui_container=>screen0.

    CALL METHOD go_winning_alv->set_table_for_first_display
      EXPORTING
        is_layout       = gs_winning_layout
      CHANGING
        it_outtab       = <dyn_winning_table>
        it_fieldcatalog = gt_winning_fieldcat.
    IF sy-subrc <> 0.
*       MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ELSE.
    go_winning_alv->refresh_table_display( ).
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_WINNING_LAYOUT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_winning_layout .
  gs_winning_layout-cwidth_opt = 'X'.
  gs_winning_layout-zebra = 'X'.
ENDFORM.
