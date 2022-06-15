*&---------------------------------------------------------------------*
*& Report ZVKT_RAP_TAYFUN_002
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvkt_rap_tayfun_002.

INCLUDE: zvkt_rap_tayfun_002_top,
         zvkt_rap_tayfun_002_cls.

START-OF-SELECTION.

  DATA: go_alv TYPE REF TO lcl_salv.

  CREATE OBJECT go_alv.

  CALL METHOD go_alv->get_data.
  CALL METHOD go_alv->display_salv.
