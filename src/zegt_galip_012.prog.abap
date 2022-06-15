*&---------------------------------------------------------------------*
*& Report ZEGT_GALIP_012
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zegt_galip_012.

INCLUDE: zegt_galip_012_top,
         zegt_galip_012_pbo,
         zegt_galip_012_pai,
         zegt_galip_012_frm,
         zegt_galip_012_frm_ticketlist,
         zegt_galip_012_frm_lottery,
         zegt_galip_012_frm_winninglist.

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF r_sayisl EQ 'X'.
      IF screen-group1 EQ 'ID1' OR
         screen-group1 EQ 'ID2' OR
         screen-group1 EQ 'ID3' OR
         screen-group1 EQ 'ID4'.
        screen-active = 0.
        screen-invisible = 1.
        MODIFY SCREEN.
      ENDIF.
    ELSEIF r_satnal EQ 'X'.
      IF screen-group1 = 'ID4'.
        screen-active = 0.
        screen-invisible = 1.
        MODIFY SCREEN.
      ELSEIF screen-group1 = 'ID1' OR
             screen-group1 = 'ID2' OR
             screen-group1 = 'ID3'.
        screen-active = 1.
        screen-invisible = 0.
        MODIFY SCREEN.
      ENDIF.
    ELSE.
      IF screen-group1 = 'ID4'.
        screen-active = 1.
        screen-invisible = 0.
        MODIFY SCREEN.
      ELSEIF screen-group1 = 'ID1' OR
             screen-group1 = 'ID2' OR
             screen-group1 = 'ID3'.
        screen-active = 0.
        screen-invisible = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDIF.
  ENDLOOP.

START-OF-SELECTION.

  CASE 'X'.
    WHEN r_sayisl.
      CALL SCREEN 0100.
    WHEN r_satnal.
      PERFORM generate_ticket_numbers.
      CALL SCREEN 0300.
    WHEN r_cekils.
      PERFORM generate_winning_numbers.
      PERFORM set_lottery_fieldcat.
      PERFORM create_dynamic_lottery_table.
      IF <dyn_lottery_table> IS ASSIGNED AND <dyn_lottery_table> IS NOT INITIAL.
        CALL SCREEN 0400.
      ENDIF.
    WHEN r_bletlr.
      DATA checked TYPE boolean.
      PERFORM check_ticket_and_lottery_dates CHANGING checked.
      IF checked = 'X'.
        PERFORM set_winning_fieldcat.
        PERFORM create_dynamic_winning_table.
        IF <dyn_winning_table> IS ASSIGNED AND <dyn_winning_table> IS NOT INITIAL.
          CALL SCREEN 0500.
        ENDIF.
      ENDIF.
  ENDCASE.
