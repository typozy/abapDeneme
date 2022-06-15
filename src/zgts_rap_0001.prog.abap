*&---------------------------------------------------------------------*
*& Report ZGTS_RAP_0001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgts_rap_0001.

INCLUDE : zgts_rap_0001_top,
          zgts_rap_0001_cls,
          zgts_rap_0001_frm,
          zgts_rap_0001_pai,
          zgts_rap_0001_pbo.

INITIALIZATION.
  PERFORM add_button.

START-OF-SELECTION.
  CREATE OBJECT go_oo_alv.
  go_oo_alv->get_data( ).

  CALL SCREEN 0100.
