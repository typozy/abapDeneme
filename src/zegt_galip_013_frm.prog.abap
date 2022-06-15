*&---------------------------------------------------------------------*
*& Include          ZEGT_GALIP_013_FRM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form SET_FCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fcat .
  DATA: lv_lastdayc TYPE char2.
  DATA: lv_date_input LIKE sy-datum.

  CONCATENATE p_year p_month '01' INTO lv_date_input.

  CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
    EXPORTING
      day_in            = lv_date_input
    IMPORTING
      last_day_of_month = gv_lastdate
    EXCEPTIONS
      day_in_no_date    = 1
      OTHERS            = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
  lv_lastdayc = gv_lastdate+6(2).
  gv_lastday = lv_lastdayc.


  DATA iterator TYPE i VALUE 1.
  DATA iteratorc TYPE char30.
  WHILE iterator LE gv_lastday.
    DATA current_day TYPE char2.
    current_day = iterator.
    current_day = |{ current_day ALPHA = IN }|.
    CONCATENATE current_day gv_lastdate+4(2) gv_lastdate(4) INTO DATA(current_date) SEPARATED BY '.'.
    iteratorc = iterator.
    CONDENSE iteratorc.
    PERFORM build_fcat USING iterator iteratorc current_date current_date current_date
                       CHANGING gt_fcat.
    iterator = iterator + 1.
  ENDWHILE.
  PERFORM build_fcat USING    iterator 'CELLCOLOR' '' '' ''
                     CHANGING gt_fcat.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form CREATE_DYNAMIC_TABLE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_dynamic_table .
  cl_alv_table_create=>create_dynamic_table(
    EXPORTING
      it_fieldcatalog           = gt_fcat    " Field Catalog
    IMPORTING
      ep_table                  = gt_table    " Pointer to Dynamic Data Table
    EXCEPTIONS
      generate_subpool_dir_full = 1
      OTHERS                    = 2
  ).
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  ASSIGN gt_table->* TO <dyn_table>.
  CREATE DATA gs_table LIKE LINE OF <dyn_table>.
  ASSIGN gs_table->* TO <gfs_table>.

  APPEND INITIAL LINE TO <dyn_table> ASSIGNING <gfs_table>.

  IF <gfs_table> IS ASSIGNED.
    ASSIGN COMPONENT 'CELLCOLOR' OF STRUCTURE <gfs_table> TO <gfs2>.
  ENDIF.

  DATA iterator TYPE i VALUE 1.
  WHILE iterator LE gv_lastday.
    IF <gfs_table> IS ASSIGNED.
      ASSIGN COMPONENT iterator OF STRUCTURE <gfs_table> TO <gfs1>.
      IF <gfs1> IS ASSIGNED.
        DATA curr_date LIKE sy-datum.
        DATA curr_day TYPE char2.
        DATA daynum TYPE i.
        DATA daytext TYPE char10.
        DATA daynr  LIKE  hrvsched-daynr.
        DATA daytxt LIKE  hrvsched-daytxt.
        curr_day = iterator.
        curr_day = |{ curr_day ALPHA = IN }|.
        CONCATENATE gv_lastdate(6) curr_day INTO curr_date.
        CALL FUNCTION 'RH_GET_DATE_DAYNAME'
          EXPORTING
            langu  = sy-langu
            date   = curr_date
*           CALID  =
          IMPORTING
            daynr  = daynr
            daytxt = daytxt
*           DAYFREE                   =
*           EXCEPTIONS
*           NO_LANGU                  = 1
*           NO_DATE                   = 2
*           NO_DAYTXT_FOR_LANGU       = 3
*           INVALID_DATE              = 4
*           OTHERS = 5
          .
        IF sy-subrc <> 0.
* Implement suitable error handling here
        ENDIF.
        <gfs1> = daytxt.

        daynum = daynr MOD 7.
        IF daynum EQ 6 OR daynum EQ 0.
          IF <gfs2> IS ASSIGNED.
            DATA iteratorc TYPE char30.
            iteratorc = iterator.
            CONDENSE iteratorc.
            PERFORM color_it USING iteratorc <gfs2>.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
    iterator = iterator + 1.
  ENDWHILE.
*  BREAK-POINT.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display .
  IF go_grid IS INITIAL.
    PERFORM set_layout.
    CREATE OBJECT go_grid
      EXPORTING
        i_parent = cl_gui_container=>screen0.    " Parent Container
    CALL METHOD go_grid->set_table_for_first_display
      EXPORTING
        is_layout       = gs_layout    " Layout
      CHANGING
        it_outtab       = <dyn_table>    " Output Table
        it_fieldcatalog = gt_fcat.    " Field Catalog

  ELSE.
    CALL METHOD go_grid->refresh_table_display.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_LAYOUT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_layout .
  gs_layout-cwidth_opt = 'X'.
  "gs_layout-zebra = 'X'.
  "gs_layout-no_toolbar = 'X'.
  gs_layout-ctab_fname = 'CELLCOLOR'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form BUILD_FCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*      -->P_POS  text
*      -->P_FNAME  text
*      -->P_TEXT_S  text
*      -->P_TEXT_M  text
*      -->P_TEXT_L  text
*      <--P_FCAT  text
*&---------------------------------------------------------------------*
FORM build_fcat USING    p_pos
                         p_fname
                         p_text_s
                         p_text_m
                         p_text_l
                CHANGING p_fcat TYPE lvc_t_fcat.
  CLEAR gs_fcat.
  gs_fcat-col_pos = p_pos.
  gs_fcat-fieldname = p_fname.
  gs_fcat-scrtext_s = p_text_s.
  gs_fcat-scrtext_m = p_text_m.
  gs_fcat-scrtext_l = p_text_l.
  IF p_fname = 'CELLCOLOR'.
    "gs_fcat-tech = 'X'.
    gs_fcat-no_out = 'X'.
    gs_fcat-ref_field = 'COLTAB'.
    gs_fcat-ref_table = 'CALENDAR_TYPE'.
  ENDIF.
  APPEND gs_fcat TO p_fcat.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form COLOR_IT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*      -->P_FNAME  text
*      -->P_TABLE  text
*&---------------------------------------------------------------------*
FORM color_it  USING p_fname
                     p_table TYPE lvc_t_scol.
  gs_celltable-fname = p_fname.
  gs_celltable-color-col = 3.
  gs_celltable-color-int = 1.
  gs_celltable-color-inv = 1.
  APPEND gs_celltable TO p_table.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHECK_IF_VALID
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*      <--P_VALID  text
*&---------------------------------------------------------------------*
FORM check_if_valid  CHANGING p_valid.
  IF p_month IS INITIAL OR p_year IS INITIAL.
    p_valid = ' '.
    MESSAGE 'Ay/yıl alanlarını doldurunuz.' TYPE 'I'.
  ELSEIF p_month < 0 OR p_month > 12 OR p_year < 1601.
    p_valid = ' '.
    MESSAGE 'Geçerli ay/yıl giriniz.' TYPE 'I'.
  ELSE.
    p_valid = 'X'.
  ENDIF.
ENDFORM.
