*&---------------------------------------------------------------------*
*& Include          ZGTS_RAP_0001_FRM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form ADD_BUTTON
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM add_button .
  gs_sel_button-icon_id = icon_xls.
  gs_sel_button-icon_text = 'Şablon'.
  gs_sel_button-quickinfo = 'Şablonu İndir'.
  sscrfields-functxt_01 = gs_sel_button.
ENDFORM.

FORM create_excel_format.

  DATA: excel    TYPE ole2_object,
        workbook TYPE ole2_object,
        sheet    TYPE ole2_object,
        cell     TYPE ole2_object,
        row      TYPE ole2_object.

  CREATE OBJECT excel 'EXCEL.APPLICATION'.

*  Create an Excel workbook Object.
  CALL METHOD OF excel 'WORKBOOKS' = workbook .

*  Put Excel in background
  "SET PROPERTY OF excel 'VISIBLE' = 0 .

*  Put Excel in front.
  SET PROPERTY OF excel 'VISIBLE' = 1 .

  CALL METHOD OF workbook 'add'.

  CALL METHOD OF excel 'Worksheets' = sheet EXPORTING #1 = 1.

  CALL METHOD OF sheet 'Activate'.

  DATA lv_sname TYPE dd02l-tabname.
  DATA lt_fieldcat TYPE lvc_t_fcat.
  CASE 'X'.
    WHEN r_but1.
      lv_sname = 'ZGTS_S0001'.
    WHEN r_but2.
      lv_sname = 'ZGTS_S0002'.
    WHEN OTHERS.
  ENDCASE.

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = lv_sname
    CHANGING
      ct_fieldcat            = lt_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  DATA: length TYPE i.
  DATA: colname TYPE string.
  LOOP AT lt_fieldcat ASSIGNING FIELD-SYMBOL(<lfs_fieldcat>).
    CALL FUNCTION 'ZEGT_GALIP_SD_GET_COLUMN_NAME'
      EXPORTING
        iv_column_number = <lfs_fieldcat>-col_pos
      IMPORTING
        ev_column_name   = colname.

    CONCATENATE colname '1' INTO colname.

    CALL METHOD OF excel 'RANGE' = cell EXPORTING #1 = colname.
    SET PROPERTY OF cell 'VALUE' = <lfs_fieldcat>-scrtext_l.
    length = strlen( <lfs_fieldcat>-scrtext_l ).
    SET PROPERTY OF cell 'ColumnWidth' = length.
    SET PROPERTY OF cell 'ShrinkToFit' = 1.
  ENDLOOP.

*  " Excel Sample Row 1
*  LS_EXCEL_FORMAT-MATNR = '0000000001'.
*  LS_EXCEL_FORMAT-WERKS = '1000'.
*  LS_EXCEL_FORMAT-COST  = '197549'.
*
*  APPEND LS_EXCEL_FORMAT TO LT_EXCEL_FORMAT.
*
*  " Append Excel Sample Data to Internal Table.
*  LOOP AT LT_EXCEL_FORMAT.
*    CALL METHOD OF EXCEL 'ROWS' = ROW EXPORTING #1 = '2' .
*    CALL METHOD OF ROW 'INSERT' NO FLUSH.
*    CALL METHOD OF EXCEL 'RANGE' = CELL EXPORTING #1 = 'A2' .
*    SET PROPERTY OF CELL 'VALUE' = LT_EXCEL_FORMAT-MATNR NO FLUSH.
*    CALL METHOD OF EXCEL 'RANGE' = CELL EXPORTING #1 = 'B2' .
*    SET PROPERTY OF CELL 'VALUE' = LT_EXCEL_FORMAT-WERKS NO FLUSH.
*    CALL METHOD OF EXCEL 'RANGE' = CELL EXPORTING #1 = 'C2' .
*    SET PROPERTY OF CELL 'VALUE' = LT_EXCEL_FORMAT-COST NO FLUSH.
*
*  ENDLOOP.

  CALL METHOD OF excel 'SAVE'.
  CALL METHOD OF excel 'QUIT'.

*  Free all objects
  FREE OBJECT cell.
  FREE OBJECT workbook.
  FREE OBJECT excel.
  excel-handle = -1.
  FREE OBJECT row.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form DOWNLOAD_TEMPLATE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*      -->P_       text
*&---------------------------------------------------------------------*
*FORM download_template  USING    pv_object type w3objid.
*
*data: ls_return type bapiret2.
*
*CALL FUNCTION 'Z_EXPORT_TEMPLATE'
*  EXPORTING
*    IV_OBJECT_NAME       = pv_object
*  IMPORTING
*    ES_RETURN            = ls_return.
*
*  if ls_return-type = 'E'.
*    MESSAGE ID ls_return-id TYPE 'I' number ls_return-NUMBER.
*  endif.

*  DATA: lo_application TYPE ole2_object,
*        lo_workbook    TYPE ole2_object,
*        lo_workbooks   TYPE ole2_object,
*        lo_range       TYPE ole2_object,
*        lo_worksheet   TYPE ole2_object,
*        lo_worksheets  TYPE ole2_object,
*        lo_column      TYPE ole2_object,
*        lo_row         TYPE ole2_object,
*        lo_cell        TYPE ole2_object,
*        lo_font        TYPE ole2_object,
*        lo_cellstart   TYPE ole2_object,
*        lo_cellend     TYPE ole2_object,
*        lo_selection   TYPE ole2_object,
*        lo_validation  TYPE ole2_object.
*
*  DATA: lv_selected_folder TYPE string,
*        lv_complete_path   TYPE char256,
*        lv_titulo          TYPE string.
*
*  TYPES: BEGIN OF lty_exc_title,
*           string(100) TYPE c,
*         END OF lty_exc_title.
*
*  DATA: ls_exc_title TYPE lty_exc_title,
*        lt_exc_title TYPE TABLE OF lty_exc_title.
*
*  TYPES: BEGIN OF lty_column,
*           column TYPE char2,
*         END OF lty_column,
*         ltt_column TYPE TABLE OF lty_column.
*
*  DATA: lt_column TYPE ltt_column,
*        ls_column TYPE lty_column.
*
*  lt_column = VALUE #(  ( column = 'A' )
*                        ( column = 'B' )
*                        ( column = 'C' )
*                        ( column = 'D' )
*                        ( column = 'E' )
*                        ( column = 'F' )
*                        ( column = 'G' )
*                        ( column = 'H' )
*                        ( column = 'I' )
*                        ( column = 'J' )
*                        ( column = 'K' )
*                        ( column = 'L' )
*                        ( column = 'M' )
*                        ( column = 'N' )
*                        ( column = 'O' )
*                        ( column = 'P' )
*                        ( column = 'Q' )
*                        ( column = 'R' )
*                        ( column = 'S' )
*                        ( column = 'T' )
*                        ( column = 'U' )
*                        ( column = 'W' )
*                        ( column = 'X' )
*                        ( column = 'Y' )
*                        ( column = 'Z' )
*                        ( column = 'AA' )
*                        ( column = 'AB' )
*                        ( column = 'AC' )
*                        ( column = 'AD' )
*                        ( column = 'AE' )
*                        ( column = 'AF' )
*                        ( column = 'AG' )
*                        ( column = 'AH' )
*                        ( column = 'AI' )
*                        ( column = 'AJ' )
*                        ( column = 'AK' )
*                        ( column = 'AL' )
*                        ( column = 'AM' )
*                        ( column = 'AN' )
*                        ( column = 'AO' )
*                        ( column = 'AP' )
*                        ( column = 'AQ' )
*                        ( column = 'AR' )
*                        ( column = 'AS' )
*                        ( column = 'AT' )
*                        ( column = 'AU' )
*                        ( column = 'AW' )
*                        ( column = 'AX' )
*                        ( column = 'AY' )
*                        ( column = 'AZ' ) ).
*
*  CALL METHOD cl_gui_frontend_services=>directory_browse
*    EXPORTING
*      window_title    = lv_titulo
*      initial_folder  = 'C:\'
*    CHANGING
*      selected_folder = lv_selected_folder
*    EXCEPTIONS
*      cntl_error      = 1
*      error_no_gui    = 2
*      OTHERS          = 3.
*  CHECK NOT lv_selected_folder IS INITIAL.
*
*  CREATE OBJECT lo_application 'EXCEL.application'.
*  CALL METHOD OF lo_application
*      'WORKBOOKS' = lo_workbooks.
*  CALL METHOD OF lo_workbooks
*      'ADD' = lo_workbook.
*  SET PROPERTY OF lo_application 'VISIBLE' = 0.
*  GET PROPERTY OF lo_application 'ACTIVESHEET' = lo_worksheet.
*
*
*  CALL FUNCTION 'NAMETAB_GET'
*    EXPORTING
**     LANGU               = SY-LANGU
**     ONLY                = ' '
*      tabname             = pv_kontab
**    IMPORTING
**     header              = ls_header
**     RC                  =
*    TABLES
*      nametab             = gt_dntab
*    EXCEPTIONS
*      internal_error      = 1
*      table_has_no_fields = 2
*      table_not_activ     = 3
*      no_texts_found      = 4
*      OTHERS              = 5.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
**
*  LOOP AT gt_dntab INTO DATA(ls_dntab).
*    CLEAR: ls_exc_title.
*    IF NOT ( ls_dntab-fieldname EQ 'MANDT' OR ls_dntab-fieldname EQ 'KAPPL' OR ls_dntab-fieldname EQ 'KSCHL' ).
*      ls_exc_title-string = ls_dntab-fieldtext.
*      APPEND ls_exc_title TO lt_exc_title.
*    ENDIF.
*  ENDLOOP.
*
*  LOOP AT lt_exc_title INTO ls_exc_title.
*    READ TABLE lt_column INTO ls_column INDEX sy-tabix.
*    CALL METHOD OF lo_worksheet
*      'Cells'      = lo_cell
*    EXPORTING
*      #1           = 1    "ROW
*      #2           = ls_column-column. " 'A'. "COL
*    SET PROPERTY OF lo_cell 'Value' = ls_exc_title-string.
*  ENDLOOP.
*
*
*  CONCATENATE lv_selected_folder '\Listeleme-Hariç Tutma Şablonu' INTO lv_complete_path.
*
*  CALL METHOD OF lo_workbook 'SaveAs'
*    EXPORTING
*      #1 = lv_complete_path.
*  IF sy-subrc EQ 0.
*    MESSAGE 'Dosya kaydedildi!' TYPE 'S'.
*  ELSE.
*    MESSAGE 'Dosya kaydedilemedi!' TYPE 'E'.
*  ENDIF.
*
*  CALL METHOD OF lo_application 'QUIT'.
*  FREE OBJECT lo_worksheet.
*  FREE OBJECT lo_workbook.
*  FREE OBJECT lo_application.
*
*ENDFORM.
