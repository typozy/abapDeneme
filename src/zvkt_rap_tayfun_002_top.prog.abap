*&---------------------------------------------------------------------*
*& Include          ZVKT_RAP_TAYFUN_002_TOP
*&---------------------------------------------------------------------*

TABLES: ekko.

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: so_ebeln FOR ekko-ebeln.
SELECTION-SCREEN: END OF BLOCK b1.
