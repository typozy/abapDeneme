*&---------------------------------------------------------------------*
*& Include          ZGTS_RAP_0001_PBO
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  data lv_status type string.

  CASE 'X'.
    WHEN r_but1.
      lv_status = '0100'.
    WHEN r_but2.
      lv_status = '0200'.
    WHEN OTHERS.
  ENDCASE.

  SET PF-STATUS lv_status.
* SET TITLEBAR 'xxx'.

  go_oo_alv->display_oo_alv( ).

ENDMODULE.
