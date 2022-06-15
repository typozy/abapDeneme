*&---------------------------------------------------------------------*
*& Include          ZEGT_GALIP_012_FRM
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Form PLAY
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM play .
  DATA numbers_ok TYPE boolean.
  PERFORM fill_numbers.
  PERFORM input_check USING ' ' gs_numlist_out CHANGING numbers_ok.
  WHILE numbers_ok EQ abap_false.
    PERFORM fill_numbers.
    PERFORM input_check USING ' ' gs_numlist_out CHANGING numbers_ok.
  ENDWHILE.
  DATA predicted_count TYPE i.
  PERFORM find_numbers_predicted CHANGING predicted_count.
  IF predicted_count < 2.
    gv_account = gv_account - '50.0'.
    MESSAGE 'Ödül kazanamadınız.' TYPE 'S' DISPLAY LIKE 'E'.
  ELSE.
    SELECT prize_amount
      FROM zegt_galip_t004
      WHERE predicted_count EQ @predicted_count
      INTO @DATA(lv_addition).
    ENDSELECT.
    gv_account = gv_account + lv_addition.
    DATA lv_add_str TYPE char50.
    lv_add_str = lv_addition.
    CONCATENATE lv_add_str ' TL kazandınız!' INTO DATA(lv_message).
    MESSAGE lv_message TYPE 'S'.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form FILL_NUMBERS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM fill_numbers .
  DATA: random_number TYPE i..

  CLEAR gt_numtab.
  DATA iterator TYPE i VALUE 0.
  WHILE iterator < 6.
    CALL FUNCTION 'QF05_RANDOM_INTEGER'
      EXPORTING
        ran_int_max   = 49
        ran_int_min   = 1
      IMPORTING
        ran_int       = random_number
      EXCEPTIONS
        invalid_input = 1
        OTHERS        = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.
    APPEND random_number TO gt_numtab.
    iterator = iterator + 1.
  ENDWHILE.

  SORT gt_numtab.

  READ TABLE gt_numtab INTO random_number INDEX 1.
  gs_numlist_out-num1 = random_number.
  READ TABLE gt_numtab INTO random_number INDEX 2.
  gs_numlist_out-num2 = random_number.
  READ TABLE gt_numtab INTO random_number INDEX 3.
  gs_numlist_out-num3 = random_number.
  READ TABLE gt_numtab INTO random_number INDEX 4.
  gs_numlist_out-num4 = random_number.
  READ TABLE gt_numtab INTO random_number INDEX 5.
  gs_numlist_out-num5 = random_number.
  READ TABLE gt_numtab INTO random_number INDEX 6.
  gs_numlist_out-num6 = random_number.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form FIND_NUMBERS_PREDICTED
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*      <--P_PREDICTED_COUNT  text
*&---------------------------------------------------------------------*
FORM find_numbers_predicted  CHANGING p_predicted_count.
  p_predicted_count = 0.

  DATA: lt_seltab TYPE RANGE OF i,
        ls_sel    LIKE LINE OF lt_seltab.

  ls_sel-sign = 'I'.
  ls_sel-option = 'EQ'.
  ls_sel-low = gs_numlist_out-num1.
  APPEND ls_sel TO lt_seltab.
  ls_sel-low = gs_numlist_out-num2.
  APPEND ls_sel TO lt_seltab.
  ls_sel-low = gs_numlist_out-num3.
  APPEND ls_sel TO lt_seltab.
  ls_sel-low = gs_numlist_out-num4.
  APPEND ls_sel TO lt_seltab.
  ls_sel-low = gs_numlist_out-num5.
  APPEND ls_sel TO lt_seltab.
  ls_sel-low = gs_numlist_out-num6.
  APPEND ls_sel TO lt_seltab.

  DATA lt_table_in TYPE TABLE OF i.

  APPEND gs_numlist_in-num1 TO lt_table_in.
  APPEND gs_numlist_in-num2 TO lt_table_in.
  APPEND gs_numlist_in-num3 TO lt_table_in.
  APPEND gs_numlist_in-num4 TO lt_table_in.
  APPEND gs_numlist_in-num5 TO lt_table_in.
  APPEND gs_numlist_in-num6 TO lt_table_in.

  DATA: iterator TYPE i VALUE 1.
  WHILE iterator LE 6.
    READ TABLE lt_table_in INTO DATA(num) INDEX iterator.
    IF num IN lt_seltab.
      p_predicted_count = p_predicted_count + 1.
    ENDIF.
    iterator = iterator + 1.
  ENDWHILE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_SCREEN
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_screen .
  LOOP AT SCREEN.
    IF screen-group1 EQ 'G1'.
      IF gv_account < '50'.
        screen-active = 0.
        screen-invisible = 1.
        MODIFY SCREEN.
      ELSE.
        screen-active = 1.
        screen-invisible = 0.
        MODIFY SCREEN.
      ENDIF.
    ELSE.
      screen-active = 1.
      screen-invisible = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form INPUT_CHECK
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*      -->P_MY_INPUT  text
*      -->P_NUMLIST  text
*      <--P_INPUT_OK  text
*&---------------------------------------------------------------------*
FORM input_check  USING    p_my_input
                           p_numlist TYPE gty_numlist
                  CHANGING p_input_ok.
  p_input_ok = abap_false.
  IF p_numlist-num1 IS INITIAL OR
     p_numlist-num2 IS INITIAL OR
     p_numlist-num3 IS INITIAL OR
     p_numlist-num4 IS INITIAL OR
     p_numlist-num5 IS INITIAL OR
     p_numlist-num6 IS INITIAL.
    IF p_my_input = 'X'.
      MESSAGE 'Tüm zorunlu alanları doldurunuz.' TYPE 'S' DISPLAY LIKE 'E'.
    ENDIF.
  ELSEIF p_numlist-num1 < 1 OR p_numlist-num1 > 49 OR
         p_numlist-num2 < 1 OR p_numlist-num2 > 49 OR
         p_numlist-num3 < 1 OR p_numlist-num3 > 49 OR
         p_numlist-num4 < 1 OR p_numlist-num4 > 49 OR
         p_numlist-num5 < 1 OR p_numlist-num5 > 49 OR
         p_numlist-num6 < 1 OR p_numlist-num6 > 49.
    IF p_my_input = 'X'.
      MESSAGE '1-49 aralığında değerler giriniz.' TYPE 'S' DISPLAY LIKE 'E'.
    ENDIF.
  ELSE.
    CLEAR gt_numtab.
    APPEND p_numlist-num1 TO gt_numtab.
    APPEND p_numlist-num2 TO gt_numtab.
    APPEND p_numlist-num3 TO gt_numtab.
    APPEND p_numlist-num4 TO gt_numtab.
    APPEND p_numlist-num5 TO gt_numtab.
    APPEND p_numlist-num6 TO gt_numtab.
    SORT gt_numtab.
    DATA iterator TYPE i VALUE 1.
    DATA input_error TYPE boolean VALUE abap_false.
    WHILE iterator < 6.
      READ TABLE gt_numtab INTO DATA(num1) INDEX iterator.
      iterator = iterator + 1.
      READ TABLE gt_numtab INTO DATA(num2) INDEX iterator.
      IF num1 EQ num2.
        IF p_my_input = 'X'.
          MESSAGE 'Sayılar birbirine eşit olmamalı.' TYPE 'S' DISPLAY LIKE 'E'.
        ENDIF.
        input_error = abap_true.
        EXIT.
      ENDIF.
    ENDWHILE.
    IF input_error EQ abap_true.
      EXIT.
    ENDIF.
    iterator = 1.
    WHILE iterator < 5.
      READ TABLE gt_numtab INTO DATA(num3) INDEX iterator.
      num3 = num3 + 1.
      iterator = iterator + 1.
      READ TABLE gt_numtab INTO DATA(num4) INDEX iterator.
      iterator = iterator + 1.
      READ TABLE gt_numtab INTO DATA(num5) INDEX iterator.
      num5 = num5 - 1.
      IF num3 EQ num4 AND num4 EQ num5.
        IF p_my_input = 'X'.
          MESSAGE 'Ardışık 3 sayı olmamalı.' TYPE 'S' DISPLAY LIKE 'E'.
        ENDIF.
        input_error = abap_true.
        EXIT.
      ENDIF.
      iterator = iterator - 1.
    ENDWHILE.
    IF input_error EQ abap_true.
      EXIT.
    ENDIF.
    DATA: primecount TYPE i VALUE 0,
          oddcount   TYPE i VALUE 0,
          evencount  TYPE i VALUE 0,
          prime      TYPE boolean,
          even       TYPE boolean.
    iterator = 1.
    WHILE iterator <= 6.
      READ TABLE gt_numtab INTO DATA(num6) INDEX iterator.
      CALL FUNCTION 'ZEGT_FM_GALIP_ISPRIMEOREVEN'
        EXPORTING
          iv_number = num6
        IMPORTING
          ev_prime  = prime
          ev_even   = even.
      IF prime EQ abap_true.
        primecount = primecount + 1.
      ELSEIF even EQ abap_true.
        evencount = evencount + 1.
      ELSE.
        oddcount = oddcount + 1.
      ENDIF.
      iterator = iterator + 1.
    ENDWHILE.
    IF primecount EQ 0 OR
       evencount  EQ 0 OR
       oddcount   EQ 0.
      IF p_my_input = 'X'.
        MESSAGE 'Numara listesinde yeterince asal/tek/çift sayı yok.' TYPE 'S' DISPLAY LIKE 'E'.
      ENDIF.
      EXIT.
    ENDIF.
    p_input_ok = abap_true.
  ENDIF.
ENDFORM.
