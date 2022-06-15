*&---------------------------------------------------------------------*
*& Include          ZEGT_GALIP_012_FRM_TICKETLIST
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form SET_TICKET_LAYOUT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_ticket_layout .
  gs_ticket_layout-zebra = 'X'.
  gs_ticket_layout-cwidth_opt = abap_true.
  gs_ticket_layout-col_opt = abap_true.
  gs_ticket_layout-box_fname = 'TICKET_TYPE'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_TICKET_SCREEN
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_ticket_screen .
  IF go_ticket_alv IS INITIAL.
    CREATE OBJECT go_ticket_alv
      EXPORTING
        i_parent = cl_gui_container=>screen0.

    PERFORM set_ticket_layout.
    PERFORM set_ticket_fieldcat.

    CALL METHOD go_ticket_alv->set_table_for_first_display
      EXPORTING
        is_layout       = gs_ticket_layout
      CHANGING
        it_outtab       = gt_ticket_table
        it_fieldcatalog = gt_ticket_fieldcat.
    IF sy-subrc <> 0.
*       MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ELSE.
    go_ticket_alv->refresh_table_display( ).
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_TICKET_FIELDCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_ticket_fieldcat .
  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = 'ZEGT_GALIP_S005'
    CHANGING
      ct_fieldcat            = gt_ticket_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  LOOP AT gt_ticket_fieldcat ASSIGNING FIELD-SYMBOL(<lfs_fieldcat>).
    IF <lfs_fieldcat>-fieldname EQ 'TICKET_NO'.
      <lfs_fieldcat>-scrtext_s = 'Bilet No.'.
      <lfs_fieldcat>-scrtext_m = 'Bilet Numarası'.
      <lfs_fieldcat>-scrtext_l = 'Bilet Numarası'.
    ELSEIF <lfs_fieldcat>-fieldname EQ 'USER_NAME'.
      <lfs_fieldcat>-scrtext_s = 'Kul. Adı'.
      <lfs_fieldcat>-scrtext_m = 'Kullanıcı Adı'.
      <lfs_fieldcat>-scrtext_l = 'Kullanıcı Adı'.
    ELSEIF <lfs_fieldcat>-fieldname EQ 'TICKET_DATE'.
      <lfs_fieldcat>-scrtext_s = 'Bilet Tar.'.
      <lfs_fieldcat>-scrtext_m = 'Bilet Tarihi'.
      <lfs_fieldcat>-scrtext_l = 'Bilet Tarihi'.
    ELSEIF <lfs_fieldcat>-fieldname EQ 'TICKET_TYPE'.
      <lfs_fieldcat>-edit = 'X'.
      <lfs_fieldcat>-no_out = 'X'.
    ELSEIF <lfs_fieldcat>-fieldname EQ 'TICKET_COUNT'.
      <lfs_fieldcat>-no_out = 'X'.
    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form BUY_TICKETS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM buy_tickets .
  DATA: lt_rows TYPE lvc_t_row,
        ls_rows TYPE lvc_s_row.

  go_ticket_alv->get_selected_rows(
    IMPORTING
      et_index_rows = lt_rows ).

  LOOP AT lt_rows INTO ls_rows.
    READ TABLE gt_ticket_table INDEX ls_rows-index ASSIGNING FIELD-SYMBOL(<lfs_ticket>).
    IF sy-subrc EQ 0.
      MODIFY zegt_galip_t005 FROM <lfs_ticket>.
      IF sy-subrc EQ 0.
        COMMIT WORK AND WAIT.
      ELSE.
        ROLLBACK WORK.
      ENDIF.
    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GENERATE_TICKET_NUMBERS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM generate_ticket_numbers .
  DATA: lt_itab TYPE RANGE OF i,
        ls_itab LIKE LINE OF lt_itab.
  ls_itab-sign = 'I'.
  ls_itab-option = 'EQ'.

  CLEAR gt_ticket_table.

  CLEAR lt_itab.
  DATA iterator TYPE i VALUE 0.
  DATA random_integer TYPE i.
  WHILE iterator LT p_adet.
    CLEAR gs_ticket_table.
    CALL FUNCTION 'QF05_RANDOM_INTEGER'
      EXPORTING
        ran_int_max   = 9999999
        ran_int_min   = 0
      IMPORTING
        ran_int       = random_integer
      EXCEPTIONS
        invalid_input = 1
        OTHERS        = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.
    IF lt_itab IS INITIAL OR
       random_integer NOT IN lt_itab.
      gs_ticket_table-mandt = sy-mandt.
      gs_ticket_table-ticket_no = random_integer.
      gs_ticket_table-ticket_no = |{ gs_ticket_table-ticket_no ALPHA = IN }|.
      gs_ticket_table-user_name = sy-uname.
      CONCATENATE p_date1+6(2) p_date1+4(2) p_date1(4) INTO gs_ticket_table-ticket_date SEPARATED BY '.'.
      APPEND gs_ticket_table TO gt_ticket_table.
      ls_itab-low = random_integer.
      APPEND ls_itab TO lt_itab.
      iterator = iterator + 1.
    ENDIF.
  ENDWHILE.
ENDFORM.
