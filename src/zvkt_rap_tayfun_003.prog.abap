*&---------------------------------------------------------------------*
*& Report ZVKT_RAP_TAYFUN_003
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvkt_rap_tayfun_003.

INCLUDE: zvkt_rap_tayfun_003_top,
         zvkt_rap_tayfun_003_cls,
         zvkt_rap_tayfun_003_pbo,
         zvkt_rap_tayfun_003_pai.

START-OF-SELECTION.

  go_oo_alv = NEW lcl_alv( ).

  go_oo_alv->get_data( ).
  go_oo_alv->set_layout( ).
  go_oo_alv->set_fcat( ).

  CASE abap_true.
    WHEN p_full.
      go_oo_alv->display_alv_full( ).
    WHEN p_cont.
      go_oo_alv->display_alv_cont( ).
    WHEN p_evnt.
      go_oo_alv->display_alv_event( ).
  ENDCASE.

  CALL SCREEN 0100.
