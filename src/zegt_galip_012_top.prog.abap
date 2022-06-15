*&---------------------------------------------------------------------*
*& Include          ZEGT_GALIP_012_TOP
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.

PARAMETERS: r_sayisl RADIOBUTTON GROUP r1 DEFAULT 'X' USER-COMMAND u1,
            r_satnal RADIOBUTTON GROUP r1,
            r_cekils RADIOBUTTON GROUP r1,
            r_bletlr RADIOBUTTON GROUP r1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.

PARAMETERS: p_adet TYPE i MODIF ID id1.
PARAMETERS: p_date1 LIKE sy-datum MODIF ID id2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
PARAMETERS: r_tam    RADIOBUTTON GROUP r2 DEFAULT 'X' USER-COMMAND u2 MODIF ID id3,
            r_yarim  RADIOBUTTON GROUP r2 MODIF ID id3,
            r_ceyrek RADIOBUTTON GROUP r2 MODIF ID id3.
SELECTION-SCREEN END OF BLOCK b3.

SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE TEXT-004.
PARAMETERS: p_date2 LIKE sy-datum MODIF ID id4.
SELECTION-SCREEN END OF BLOCK b4.

SELECTION-SCREEN END OF BLOCK b1.

TYPES: BEGIN OF gty_numlist,
         num1 TYPE numc2,
         num2 TYPE numc2,
         num3 TYPE numc2,
         num4 TYPE numc2,
         num5 TYPE numc2,
         num6 TYPE numc2,
       END OF gty_numlist.

TYPES: BEGIN OF gty_card,
         part1 TYPE numc4,
         part2 TYPE numc4,
         part3 TYPE numc4,
         part4 TYPE numc4,
         cvv   TYPE numc3,
       END OF gty_card.

DATA: gs_numlist_in  TYPE gty_numlist,
      gs_numlist_out TYPE gty_numlist,
      gs_cardnum     TYPE gty_card.

DATA: gt_numtab TYPE TABLE OF i.

DATA: gv_account  TYPE wert VALUE '500.00',
      gv_addition TYPE wert VALUE '0.00'.

DATA: gt_ticket_table TYPE TABLE OF zegt_galip_t005,
      gs_ticket_table TYPE zegt_galip_t005.

DATA: go_ticket_alv  TYPE REF TO cl_gui_alv_grid.

DATA: go_lottery_alv  TYPE REF TO cl_gui_alv_grid.

DATA: go_winning_alv  TYPE REF TO cl_gui_alv_grid.

DATA: gt_ticket_fieldcat TYPE lvc_t_fcat,
      gs_ticket_fieldcat TYPE lvc_s_fcat,
      gs_ticket_layout   TYPE lvc_s_layo.

DATA: gt_lottery_fieldcat TYPE lvc_t_fcat,
      gs_lottery_fieldcat TYPE lvc_s_fcat,
      gs_lottery_layout   TYPE lvc_s_layo.

DATA: gt_winning_fieldcat TYPE lvc_t_fcat,
      gs_winning_fieldcat TYPE lvc_s_fcat,
      gs_winning_layout   TYPE lvc_s_layo.

DATA: gt_lottery_table TYPE TABLE OF zegt_galip_t006,
      gs_lottery_table TYPE zegt_galip_t006.

DATA: gt_dynamic_lottery_table TYPE REF TO data,
      gs_dynamic_lottery_table TYPE REF TO data.

DATA: gt_dynamic_winning_table TYPE REF TO data,
      gs_dynamic_winning_table TYPE REF TO data.

FIELD-SYMBOLS: <dyn_lottery_table> TYPE STANDARD TABLE,
               <gfs_lottery_table>,
               <gfs_lottery>.

FIELD-SYMBOLS: <dyn_winning_table> TYPE STANDARD TABLE,
               <gfs_winning_table>,
               <gfs_winning>.
