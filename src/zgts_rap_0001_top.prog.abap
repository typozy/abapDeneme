*&---------------------------------------------------------------------*
*& Include          ZGTS_RAP_0001_TOP
*&---------------------------------------------------------------------*

CLASS lcl_alv DEFINITION DEFERRED.

TABLES: sscrfields.
TABLES: ekko,
        ekpo.

DATA: gs_sel_button TYPE smp_dyntxt.

FIELD-SYMBOLS: <gfs_table> type STANDARD TABLE.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS p_file TYPE localfile.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
PARAMETERS: r_but1 RADIOBUTTON GROUP r1,
            r_but2 RADIOBUTTON GROUP r1.
SELECTION-SCREEN END OF BLOCK b2.

DATA: go_oo_alv TYPE REF TO lcl_alv.

SELECTION-SCREEN FUNCTION KEY 1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.

  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      field_name = 'P_FILE'
    IMPORTING
      file_name  = p_file.

AT SELECTION-SCREEN.
  CASE sscrfields-ucomm.
    WHEN 'FC01'.
      PERFORM create_excel_format.
    WHEN OTHERS.
  ENDCASE.
