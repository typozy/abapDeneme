*&---------------------------------------------------------------------*
*& Report ZVKT_RAP_TAYFUN_004
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvkt_rap_tayfun_004.

INCLUDE: zvkt_rap_tayfun_004_top,
         zvkt_rap_tayfun_004_frm,
         zvkt_rap_tayfun_004_pbo,
         zvkt_rap_tayfun_004_pai.

START-OF-SELECTION.

  PERFORM get_data.
  PERFORM set_fcat.
  IF <dyn_table> IS ASSIGNED AND <dyn_table> IS NOT INITIAL.
    CALL SCREEN 0100.
  ENDIF.
