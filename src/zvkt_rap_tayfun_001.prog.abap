*&---------------------------------------------------------------------*
*& Report ZVKT_RAP_TAYFUN_001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvkt_rap_tayfun_001.

INCLUDE: zvkt_rap_tayfun_001_top.
INCLUDE: zvkt_rap_tayfun_001_frm.

START-OF-SELECTION.

  PERFORM get_data.
  PERFORM set_fcat.
  PERFORM set_layout.

  CASE 'X'.
    WHEN r_grid.
      PERFORM display_alv.
    WHEN r_list.
      PERFORM display_list.
    WHEN r_popup.
      PERFORM display_popup.
  ENDCASE.
