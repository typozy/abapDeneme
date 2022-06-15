*&---------------------------------------------------------------------*
*& Include          ZEGT_GALIP_012_FRM_LOTTERY
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form GENERATE_WINNING_NUMBERS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM generate_winning_numbers .
  DATA: lt_itab TYPE RANGE OF i,
        ls_itab LIKE LINE OF lt_itab.
  ls_itab-sign = 'I'.
  ls_itab-option = 'EQ'.

  CONCATENATE p_date2+6(2) p_date2+4(2) p_date2(4) INTO DATA(lv_date2) SEPARATED BY '.'.

  SELECT COUNT(*)
    FROM zegt_galip_t006
    WHERE lottery_date EQ @lv_date2.

  IF sy-dbcnt > 0.
    MESSAGE 'Bu tarihte zaten çekiliş yapılmış.' TYPE 'I'.
    EXIT.
  ENDIF.

  DATA lt_lottery_table TYPE TABLE OF zegt_galip_t006.
  DATA random_integer TYPE i.
  CLEAR gt_lottery_table.

  DATA: winning1 TYPE char1.
  CLEAR lt_itab.
  CLEAR lt_lottery_table.
  DATA iterator TYPE i VALUE 0.
  WHILE iterator < 2.
    CLEAR gs_lottery_table.
    CALL FUNCTION 'QF05_RANDOM_INTEGER'
      EXPORTING
        ran_int_max   = 9
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
      winning1 = random_integer.
      winning1 = |{ winning1 ALPHA = IN }|.
      gs_lottery_table-mandt = sy-mandt.
      gs_lottery_table-lottery_date = lv_date2.
      gs_lottery_table-winning_number = winning1.
      APPEND gs_lottery_table TO lt_lottery_table.
      ls_itab-low = random_integer.
      APPEND ls_itab TO lt_itab.
      iterator = iterator + 1.
    ENDIF.
  ENDWHILE.

  SORT lt_lottery_table BY winning_number.
  APPEND LINES OF lt_lottery_table TO gt_lottery_table.

  DATA: winning2 TYPE char2.
  CLEAR lt_itab.
  CLEAR lt_lottery_table.
  iterator = 0.
  WHILE iterator < 25.
    CLEAR gs_lottery_table.
    CALL FUNCTION 'QF05_RANDOM_INTEGER'
      EXPORTING
        ran_int_max   = 99
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
      winning2 = random_integer.
      winning2 = |{ winning2 ALPHA = IN }|.
      gs_lottery_table-mandt = sy-mandt.
      gs_lottery_table-lottery_date = lv_date2.
      gs_lottery_table-winning_number = winning2.
      APPEND gs_lottery_table TO lt_lottery_table.
      ls_itab-low = random_integer.
      APPEND ls_itab TO lt_itab.
      iterator = iterator + 1.
    ENDIF.
  ENDWHILE.

  SORT lt_lottery_table BY winning_number.
  APPEND LINES OF lt_lottery_table TO gt_lottery_table.

  DATA: winning3 TYPE char3.
  CLEAR lt_itab.
  CLEAR lt_lottery_table.
  iterator = 0.
  WHILE iterator < 20.
    CLEAR gs_lottery_table.
    CALL FUNCTION 'QF05_RANDOM_INTEGER'
      EXPORTING
        ran_int_max   = 999
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
      winning3 = random_integer.
      winning3 = |{ winning3 ALPHA = IN }|.
      gs_lottery_table-mandt = sy-mandt.
      gs_lottery_table-lottery_date = lv_date2.
      gs_lottery_table-winning_number = winning3.
      APPEND gs_lottery_table TO lt_lottery_table.
      ls_itab-low = random_integer.
      APPEND ls_itab TO lt_itab.
      iterator = iterator + 1.
    ENDIF.
  ENDWHILE.

  SORT lt_lottery_table BY winning_number.
  APPEND LINES OF lt_lottery_table TO gt_lottery_table.

  DATA: winning4 TYPE char4.
  CLEAR lt_itab.
  CLEAR lt_lottery_table.
  iterator = 0.
  WHILE iterator < 15.
    CLEAR gs_lottery_table.
    CALL FUNCTION 'QF05_RANDOM_INTEGER'
      EXPORTING
        ran_int_max   = 9999
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
      winning4 = random_integer.
      winning4 = |{ winning4 ALPHA = IN }|.
      gs_lottery_table-mandt = sy-mandt.
      gs_lottery_table-lottery_date = lv_date2.
      gs_lottery_table-winning_number = winning4.
      APPEND gs_lottery_table TO lt_lottery_table.
      ls_itab-low = random_integer.
      APPEND ls_itab TO lt_itab.
      iterator = iterator + 1.
    ENDIF.
  ENDWHILE.

  SORT lt_lottery_table BY winning_number.
  APPEND LINES OF lt_lottery_table TO gt_lottery_table.

  DATA: winning5 TYPE char5.
  CLEAR lt_itab.
  CLEAR lt_lottery_table.
  iterator = 0.
  WHILE iterator < 10.
    CLEAR gs_lottery_table.
    CALL FUNCTION 'QF05_RANDOM_INTEGER'
      EXPORTING
        ran_int_max   = 99999
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
      winning5 = random_integer.
      winning5 = |{ winning5 ALPHA = IN }|.
      gs_lottery_table-mandt = sy-mandt.
      gs_lottery_table-lottery_date = lv_date2.
      gs_lottery_table-winning_number = winning5.
      APPEND gs_lottery_table TO lt_lottery_table.
      ls_itab-low = random_integer.
      APPEND ls_itab TO lt_itab.
      iterator = iterator + 1.
    ENDIF.
  ENDWHILE.

  SORT lt_lottery_table BY winning_number.
  APPEND LINES OF lt_lottery_table TO gt_lottery_table.

  DATA: winning6 TYPE char6.
  CLEAR lt_itab.
  CLEAR lt_lottery_table.
  iterator = 0.
  WHILE iterator < 5.
    CLEAR gs_lottery_table.
    CALL FUNCTION 'QF05_RANDOM_INTEGER'
      EXPORTING
        ran_int_max   = 999999
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
      winning6 = random_integer.
      winning6 = |{ winning6 ALPHA = IN }|.
      gs_lottery_table-mandt = sy-mandt.
      gs_lottery_table-lottery_date = lv_date2.
      gs_lottery_table-winning_number = winning6.
      APPEND gs_lottery_table TO lt_lottery_table.
      ls_itab-low = random_integer.
      APPEND ls_itab TO lt_itab.
      iterator = iterator + 1.
    ENDIF.
  ENDWHILE.

  SORT lt_lottery_table BY winning_number.
  APPEND LINES OF lt_lottery_table TO gt_lottery_table.

  DATA winning7 TYPE char7.
  CLEAR gs_lottery_table.
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

  winning7 = random_integer.
  winning7 = |{ winning7 ALPHA = IN }|.
  gs_lottery_table-mandt = sy-mandt.
  gs_lottery_table-lottery_date = lv_date2.
  gs_lottery_table-winning_number = winning7.
  APPEND gs_lottery_table TO gt_lottery_table.

  MODIFY zegt_galip_t006 FROM TABLE gt_lottery_table.
  IF sy-subrc EQ 0.
    COMMIT WORK AND WAIT.
  ELSE.
    ROLLBACK WORK.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_LOTTERY_SCREEN
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_lottery_screen .
  IF go_lottery_alv IS INITIAL.
    PERFORM set_lottery_layout.

    CREATE OBJECT go_lottery_alv
      EXPORTING
        i_parent = cl_gui_container=>screen0.

    CALL METHOD go_lottery_alv->set_table_for_first_display
      EXPORTING
        is_layout       = gs_lottery_layout
      CHANGING
        it_outtab       = <dyn_lottery_table>
        it_fieldcatalog = gt_lottery_fieldcat.
    IF sy-subrc <> 0.
*       MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ELSE.
    go_ticket_alv->refresh_table_display( ).
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_LOTTERY_FIELDCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_lottery_fieldcat .
  CLEAR gs_lottery_fieldcat.
  gs_lottery_fieldcat-col_pos = 1.
  gs_lottery_fieldcat-fieldname = 'PRIZE_TYPE'.
  gs_lottery_fieldcat-scrtext_s = 'Ödül T.'.
  gs_lottery_fieldcat-scrtext_m = 'Ödül Türü'.
  gs_lottery_fieldcat-scrtext_l = 'Ödül Türü'.
  gs_lottery_fieldcat-intlen = 40.
  APPEND gs_lottery_fieldcat TO gt_lottery_fieldcat.

  CLEAR gs_lottery_fieldcat.
  gs_lottery_fieldcat-col_pos = 2.
  gs_lottery_fieldcat-fieldname = 'WINNING_NUMBERS'.
  gs_lottery_fieldcat-scrtext_s = 'Kaz. N.'.
  gs_lottery_fieldcat-scrtext_m = 'Kazanan Numaralar'.
  gs_lottery_fieldcat-scrtext_l = 'Kazanan Numaralar'.
  gs_lottery_fieldcat-intlen = 100.
  APPEND gs_lottery_fieldcat TO gt_lottery_fieldcat.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_DYNAMIC_LOTTERY_TABLE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_dynamic_lottery_table .
  DATA line TYPE char100.
  DATA index TYPE i.
  CONCATENATE p_date2+6(2) p_date2+4(2) p_date2(4) INTO DATA(lv_date2) SEPARATED BY '.'.

  SELECT winning_number
    FROM zegt_galip_t006
    WHERE lottery_date EQ @lv_date2
    INTO TABLE @DATA(lt_itab).


  FIELD-SYMBOLS <lfs> LIKE LINE OF lt_itab.

  CALL METHOD cl_alv_table_create=>create_dynamic_table
    EXPORTING
      it_fieldcatalog = gt_lottery_fieldcat    " Field Catalog
    IMPORTING
      ep_table        = gt_dynamic_lottery_table.    " Pointer to Dynamic Data Table
  ASSIGN gt_dynamic_lottery_table->* TO <dyn_lottery_table>.
  CREATE DATA gs_dynamic_lottery_table LIKE LINE OF <dyn_lottery_table>.
  ASSIGN gs_dynamic_lottery_table->* TO <gfs_lottery_table>.

  index = 1.
  DATA iterator TYPE i VALUE 1.
  WHILE iterator <= 7.
    APPEND INITIAL LINE TO <dyn_lottery_table> ASSIGNING <gfs_lottery_table>.
    IF <gfs_lottery_table> IS ASSIGNED.
      ASSIGN COMPONENT 'PRIZE_TYPE' OF STRUCTURE <gfs_lottery_table> TO <gfs_lottery>.
      IF <gfs_lottery> IS ASSIGNED.
        IF iterator = 1.
          <gfs_lottery> = 'Amorti'.
        ELSEIF iterator = 2.
          <gfs_lottery> = 'Son 2 rakamına göre bilet numarası'.
        ELSEIF iterator = 3.
          <gfs_lottery> = 'Son 3 rakamına göre bilet numarası'.
        ELSEIF iterator = 4.
          <gfs_lottery> = 'Son 4 rakamına göre bilet numarası'.
        ELSEIF iterator = 5.
          <gfs_lottery> = 'Son 5 rakamına göre bilet numarası'.
        ELSEIF iterator = 6.
          <gfs_lottery> = 'Son 6 rakamına göre bilet numarası'.
        ELSE.
          <gfs_lottery> = 'Kazanan bilet numarası'.
        ENDIF.
      ENDIF.
      ASSIGN COMPONENT 'WINNING_NUMBERS' OF STRUCTURE <gfs_lottery_table> TO <gfs_lottery>.
      IF <gfs_lottery> IS ASSIGNED.
        DATA it TYPE i.
        IF iterator = 1.
          it = 0.
          WHILE it < 2.
            READ TABLE lt_itab INDEX index ASSIGNING <lfs>.
            IF sy-subrc = 0.
              IF it = 0.
                line = <lfs>-winning_number.
              ELSE.
                CONCATENATE line '-' <lfs>-winning_number INTO line.
              ENDIF.
              index = index + 1.
            ENDIF.
            it = it + 1.
          ENDWHILE.
          <gfs_lottery> = line.
        ELSEIF iterator = 2.
          it = 0.
          WHILE it < 25.
            READ TABLE lt_itab INDEX index ASSIGNING <lfs>.
            IF sy-subrc = 0.
              IF it = 0.
                line = <lfs>-winning_number.
              ELSE.
                CONCATENATE line '-' <lfs>-winning_number INTO line.
              ENDIF.
              index = index + 1.
            ENDIF.
            it = it + 1.
          ENDWHILE.
          <gfs_lottery> = line.
        ELSEIF iterator = 3.
          it = 0.
          WHILE it < 20.
            READ TABLE lt_itab INDEX index ASSIGNING <lfs>.
            IF sy-subrc = 0.
              IF it = 0.
                line = <lfs>-winning_number.
              ELSE.
                CONCATENATE line '-' <lfs>-winning_number INTO line.
              ENDIF.
              index = index + 1.
            ENDIF.
            it = it + 1.
          ENDWHILE.
          <gfs_lottery> = line.
        ELSEIF iterator = 4.
          it = 0.
          WHILE it < 15.
            READ TABLE lt_itab INDEX index ASSIGNING <lfs>.
            IF sy-subrc = 0.
              IF it = 0.
                line = <lfs>-winning_number.
              ELSE.
                CONCATENATE line '-' <lfs>-winning_number INTO line.
              ENDIF.
              index = index + 1.
            ENDIF.
            it = it + 1.
          ENDWHILE.
          <gfs_lottery> = line.
        ELSEIF iterator = 5.
          it = 0.
          WHILE it < 10.
            READ TABLE lt_itab INDEX index ASSIGNING <lfs>.
            IF sy-subrc = 0.
              IF it = 0.
                line = <lfs>-winning_number.
              ELSE.
                CONCATENATE line '-' <lfs>-winning_number INTO line.
              ENDIF.
              index = index + 1.
            ENDIF.
            it = it + 1.
          ENDWHILE.
          <gfs_lottery> = line.
        ELSEIF iterator = 6.
          it = 0.
          WHILE it < 5.
            READ TABLE lt_itab INDEX index ASSIGNING <lfs>.
            IF sy-subrc = 0.
              IF it = 0.
                line = <lfs>-winning_number.
              ELSE.
                CONCATENATE line '-' <lfs>-winning_number INTO line.
              ENDIF.
              index = index + 1.
            ENDIF.
            it = it + 1.
          ENDWHILE.
          <gfs_lottery> = line.
        ELSE.
          READ TABLE lt_itab INDEX index ASSIGNING <lfs>.
          IF sy-subrc = 0.
            <gfs_lottery> = <lfs>-winning_number.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
    iterator = iterator + 1.
  ENDWHILE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_LOTTERY_LAYOUT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_lottery_layout .
  gs_lottery_layout-cwidth_opt = 'X'.
  gs_lottery_layout-zebra = 'X'.
ENDFORM.
