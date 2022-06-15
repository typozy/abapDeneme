*&---------------------------------------------------------------------*
*& Include          ZEGT_GALIP_013_TOP
*&---------------------------------------------------------------------*

DATA: gt_fcat     TYPE lvc_t_fcat,
      gs_fcat     TYPE lvc_s_fcat.

DATA: gt_table TYPE REF TO data,
      gs_table TYPE REF TO data.

DATA: go_grid   TYPE REF TO cl_gui_alv_grid,
      gs_layout TYPE lvc_s_layo.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS: p_month TYPE fcmnr,
            p_year  TYPE gjahr.
SELECTION-SCREEN END OF BLOCK b1.

FIELD-SYMBOLS: <dyn_table> TYPE STANDARD TABLE,
               <gfs_table>,
               <gfs1>,
               <gfs2>.

DATA: gv_lastdate LIKE sy-datum,
      gv_lastday  TYPE i.

DATA: gs_celltable TYPE lvc_s_scol.
