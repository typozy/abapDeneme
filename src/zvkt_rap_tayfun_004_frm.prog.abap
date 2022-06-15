*&---------------------------------------------------------------------*
*& Include          ZVKT_RAP_TAYFUN_004_FRM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form GET_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .
  SELECT *
    FROM zegt_ogrl_t0001
    INTO TABLE @gt_alv.

  gt_ilkodu = gt_alv.
  SORT gt_ilkodu BY il_kodu.
  DELETE ADJACENT DUPLICATES FROM gt_ilkodu COMPARING il_kodu.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_FCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fcat .
  DATA: lv_count     TYPE int4 VALUE 2,
        lv_fieldname TYPE string,
        lv_ilkodu    TYPE string,
        lv_text      TYPE string.
  PERFORM build_fcat USING '1' 'MATNR' 'Malzeme' 'Malzeme' 'Malzeme'.
  LOOP AT gt_ilkodu INTO DATA(ls_ilkodu).
    lv_ilkodu = ls_ilkodu-il_kodu.
    CONCATENATE 'IL_KODU' lv_ilkodu INTO lv_fieldname.
    CONCATENATE 'İl_Kodu' lv_ilkodu INTO lv_text.
    PERFORM build_fcat USING lv_count lv_fieldname lv_text lv_text lv_text.
    lv_count = lv_count + 1.
    CLEAR: lv_fieldname, lv_text.
  ENDLOOP.
  PERFORM create_dynamic_table.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form BUILD_FCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*      -->P_       text
*      -->P_       text
*      -->P_       text
*      -->P_       text
*      -->P_       text
*&---------------------------------------------------------------------*
FORM build_fcat USING p_col_pos
                      p_fieldname
                      p_scrtext_s
                      p_scrtext_m
                      p_scrtext_l.
  CLEAR gs_fcat.
  gs_fcat-col_pos = p_col_pos.
  gs_fcat-fieldname = p_fieldname.
  gs_fcat-scrtext_s = p_scrtext_s.
  gs_fcat-scrtext_m = p_scrtext_m.
  gs_fcat-scrtext_l = p_scrtext_l.
  IF gs_fcat-fieldname = 'MATNR'.
    gs_fcat-datatype = 'MATNR'.
    gs_fcat-intlen = 40.
  ELSE.
    gs_fcat-datatype = 'MATNR'.
    gs_fcat-intlen = 10.
  ENDIF.
  APPEND gs_fcat TO gt_fcat.
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
  DATA: lv_fieldname TYPE string,
        lv_ilkodu    TYPE string.

  CALL METHOD cl_alv_table_create=>create_dynamic_table
    EXPORTING
      it_fieldcatalog = gt_fcat    " Field Catalog
    IMPORTING
      ep_table        = gt_table.    " Pointer to Dynamic Data Table
  ASSIGN gt_table->* TO <dyn_table>.
  CREATE DATA gs_table LIKE LINE OF <dyn_table>.
  ASSIGN gs_table->* TO <gfs_table>.

  gt_malzm = gt_alv.
  SORT gt_malzm BY matnr.
  DELETE ADJACENT DUPLICATES FROM gt_malzm COMPARING matnr.

  LOOP AT gt_malzm INTO DATA(ls_malzm).
    APPEND INITIAL LINE TO <dyn_table> ASSIGNING <gfs_table>.
    IF <gfs_table> IS ASSIGNED.
      ASSIGN COMPONENT 'MATNR' OF STRUCTURE <gfs_table> TO <gfs1>.
      IF <gfs1> IS ASSIGNED.
        <gfs1> = ls_malzm-matnr.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
          EXPORTING
            input  = <gfs1>
          IMPORTING
            output = <gfs1>.
      ENDIF.
    ENDIF.
    LOOP AT gt_alv INTO DATA(ls_alv) WHERE matnr = ls_malzm-matnr.
      lv_ilkodu = ls_alv-il_kodu.
      CONCATENATE 'IL_KODU' lv_ilkodu INTO lv_fieldname.
      IF <gfs_table> IS ASSIGNED.
        ASSIGN COMPONENT lv_fieldname OF STRUCTURE <gfs_table> TO <gfs1>.
        IF <gfs1> IS ASSIGNED.
          <gfs1> = ls_alv-fiyat.
          "CONDENSE <gfs1>.
        ENDIF.
      ENDIF.
    ENDLOOP.
*    APPEND <gfs_table> TO <dyn_table>.
*    CLEAR <gfs_table>.
  ENDLOOP.
*  LOOP AT gt_alv INTO DATA(ls_alv) GROUP BY ( matnr = ls_alv-matnr
*                                              index = GROUP INDEX
*                                              size = GROUP SIZE ) ASCENDING ASSIGNING FIELD-SYMBOL(<lfs_group>).
*    LOOP AT GROUP <lfs_group> ASSIGNING FIELD-SYMBOL(<lfs_s_group>).
*    ENDLOOP.
*  ENDLOOP.
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
  gs_layout-zebra = 'X'.
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
