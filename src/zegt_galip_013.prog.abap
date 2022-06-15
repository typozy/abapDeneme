*&---------------------------------------------------------------------*
*& Report ZEGT_GALIP_013
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zegt_galip_013.

INCLUDE: zegt_galip_013_top,
         zegt_galip_013_frm,
         zegt_galip_013_pbo,
         zegt_galip_013_pai.

START-OF-SELECTION.

  data checked TYPE boolean.
  PERFORM check_if_valid CHANGING checked.
  if checked = 'X'.
    PERFORM set_fcat.
    PERFORM create_dynamic_table.

    IF <dyn_table> IS ASSIGNED AND <dyn_table> IS NOT INITIAL.
      CALL SCREEN 0100.
    ENDIF.
  ENDIF.
