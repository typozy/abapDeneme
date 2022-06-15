*&---------------------------------------------------------------------*
*& Include          ZGTS_RAP_0001_CLS
*&---------------------------------------------------------------------*
CLASS lcl_alv DEFINITION.
  PUBLIC SECTION.
    METHODS: get_data,
      set_fieldcat,
      set_layout,
      display_oo_alv,
      refresh,
      create_contract,
      get_detail,
      change_contract.

  PRIVATE SECTION.
    TYPES: BEGIN OF gty_msg,
             msgid  TYPE sy-msgid,
             msgty  TYPE sy-msgty,
             msgno  TYPE sy-msgno,
             msgv1  TYPE sy-msgv1,
             msgv2  TYPE sy-msgv2,
             msgv3  TYPE sy-msgv3,
             msgv4  TYPE sy-msgv4,
             lineno TYPE mesg-zeile,
           END OF gty_msg.

    DATA: gt_raw             TYPE truxs_t_text_data,
          gt_table           TYPE TABLE OF zgts_s0001,
          gt_table2          TYPE TABLE OF zgts_s0002,
          gt_internal_table  TYPE TABLE OF zgts_s0003,
          gt_internal_table2 TYPE TABLE OF zgts_s0004.
    DATA: gt_fieldcat TYPE lvc_t_fcat,
          gs_fieldcat TYPE lvc_s_fcat,
          gs_layout   TYPE lvc_s_layo.
    DATA: go_alv  TYPE REF TO cl_gui_alv_grid,
          go_cont TYPE REF TO cl_gui_custom_container.
ENDCLASS.

CLASS lcl_alv IMPLEMENTATION.
  METHOD get_data.
    CASE 'X'.
      WHEN r_but1.
        ASSIGN gt_table TO <gfs_table>.
      WHEN r_but2.
        ASSIGN gt_table2 TO <gfs_table>.
      WHEN OTHERS.
    ENDCASE.
    CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
      EXPORTING
        i_line_header        = abap_true
        i_tab_raw_data       = gt_raw
        i_filename           = p_file
      TABLES
        i_tab_converted_data = <gfs_table>
      EXCEPTIONS
        conversion_failed    = 1
        OTHERS               = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    CASE 'X'.
      WHEN r_but1.
        MOVE-CORRESPONDING gt_table TO gt_internal_table.
        ASSIGN gt_internal_table TO <gfs_table>.
      WHEN r_but2.
        MOVE-CORRESPONDING gt_table2 TO gt_internal_table2.
        ASSIGN gt_internal_table2 TO <gfs_table>.
      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.

  METHOD set_fieldcat.
    DATA lv_fcatname TYPE dd02l-tabname.
    CASE 'X'.
      WHEN r_but1.
        lv_fcatname = 'ZGTS_S0003'.
      WHEN r_but2.
        lv_fcatname = 'ZGTS_S0004'.
      WHEN OTHERS.
    ENDCASE.

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name       = lv_fcatname
*       i_internal_tabname     = gt_internal_table
      CHANGING
        ct_fieldcat            = gt_fieldcat
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.
    IF sy-subrc <> 0.
*     Implement suitable error handling here
    ENDIF.

    LOOP AT gt_fieldcat ASSIGNING FIELD-SYMBOL(<lfs_fcat>).
      IF <lfs_fcat>-fieldname EQ 'CHECK'.
        <lfs_fcat>-edit = 'X'.
*       <lfs_fcat>-checkbox = 'X'.
        <lfs_fcat>-no_out = 'X'.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD set_layout.
    gs_layout-zebra = 'X'.
    gs_layout-cwidth_opt = abap_true .
    gs_layout-col_opt = abap_true .
    gs_layout-box_fname = 'CHECK'.
  ENDMETHOD.

  METHOD display_oo_alv.
    IF go_alv IS INITIAL.
      CREATE OBJECT go_cont
        EXPORTING
          container_name = 'CC_CONT'.

      CREATE OBJECT go_alv
        EXPORTING
          i_parent = go_cont.

      set_layout( ).
      set_fieldcat( ).

      CALL METHOD go_alv->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layout
        CHANGING
          it_outtab       = <gfs_table>
          it_fieldcatalog = gt_fieldcat.
      IF sy-subrc <> 0.
*       MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
    ELSE.
      refresh( ).
    ENDIF.
  ENDMETHOD.

  METHOD refresh.
    go_alv->refresh_table_display( ).
  ENDMETHOD.

  METHOD create_contract.
    DATA: ls_header  TYPE bapimeoutheader,
          ls_headerx TYPE bapimeoutheaderx.

    DATA: lv_purchasingdoc TYPE bapimeoutheader-number,
          lv_exp_header    TYPE bapimeoutheader.

    DATA: lt_return TYPE TABLE OF bapiret2.

    DATA: lt_item  TYPE TABLE OF bapimeoutitem,
          lt_itemx TYPE TABLE OF bapimeoutitemx.

    DATA: ls_item  TYPE bapimeoutitem,
          ls_itemx TYPE bapimeoutitemx.

    DATA: lv_ebelp TYPE ebelp VALUE 10.
    DATA: lv_first TYPE char1 VALUE 'X'.

    DATA: lt_rows TYPE lvc_t_row,
          ls_rows TYPE lvc_s_row.

    go_alv->get_selected_rows(
      IMPORTING
        et_index_rows = lt_rows ).

    LOOP AT lt_rows INTO ls_rows.

      READ TABLE gt_internal_table INDEX ls_rows-index ASSIGNING FIELD-SYMBOL(<lfs_table>).

      CLEAR: ls_item,
             ls_itemx.

      IF lv_first EQ 'X'.
        ls_header-comp_code = <lfs_table>-bukrs.
        ls_header-doc_type = <lfs_table>-bsart.
        ls_header-vendor = <lfs_table>-lifnr.
        ls_header-pmnttrms = <lfs_table>-zterm.
        ls_header-purch_org = <lfs_table>-ekorg.
        ls_header-pur_group = <lfs_table>-ekgrp.
        ls_header-currency = <lfs_table>-waers.
        ls_header-vper_start = <lfs_table>-kdatb.
        ls_header-vper_end = <lfs_table>-kdate.
        lv_first = ' '.

        ls_headerx-comp_code = 'X'.
        ls_headerx-doc_type = 'X'.
        ls_headerx-vendor = 'X'.
        ls_headerx-pmnttrms = 'X'.
        ls_headerx-purch_org = 'X'.
        ls_headerx-pur_group = 'X'.
        ls_headerx-currency = 'X'.
        ls_headerx-vper_start = 'X'.
        ls_headerx-vper_end = 'X'.
      ENDIF.

      ls_item-item_no = lv_ebelp.
      ls_item-item_no = | { ls_item-item_no ALPHA = IN } |.
      <lfs_table>-ebelp = lv_ebelp.
      <lfs_table>-ebelp = | { <lfs_table>-ebelp ALPHA = IN } |.
      lv_ebelp = lv_ebelp + 10.
      ls_item-material = <lfs_table>-matnr.
      ls_item-plant = <lfs_table>-werks.
      ls_item-target_qty = <lfs_table>-menge.
      ls_item-po_unit = <lfs_table>-meins.
      ls_item-net_price = <lfs_table>-netpr.
      ls_item-price_unit = <lfs_table>-peinh.
      ls_item-plan_del = <lfs_table>-plifz.
      ls_item-under_dlv_tol = <lfs_table>-untto.
      ls_item-over_dlv_tol = <lfs_table>-uebto.
      ls_item-gr_ind = 'X'.
      ls_item-ir_ind = 'X'.
      ls_item-gr_basediv = 'X'.
      APPEND ls_item TO lt_item.

      ls_itemx-item_no = 'X'.
      ls_itemx-material = 'X'.
      ls_itemx-plant = 'X'.
      ls_itemx-target_qty = 'X'.
      ls_itemx-po_unit = 'X'.
      ls_itemx-net_price = 'X'.
      ls_itemx-price_unit = 'X'.
      ls_itemx-plan_del = 'X'.
      ls_itemx-under_dlv_tol = 'X'.
      ls_itemx-over_dlv_tol = 'X'.
      ls_itemx-gr_ind = 'X'.
      ls_itemx-ir_ind = 'X'.
      ls_itemx-gr_basediv = 'X'.
      APPEND ls_itemx TO lt_itemx.
    ENDLOOP.

    CALL FUNCTION 'BAPI_CONTRACT_CREATE'
      EXPORTING
        header             = ls_header
        headerx            = ls_headerx
      IMPORTING
        purchasingdocument = lv_purchasingdoc
        exp_header         = lv_exp_header
      TABLES
        return             = lt_return
        item               = lt_item
        itemx              = lt_itemx.

    LOOP AT lt_rows INTO ls_rows.
      READ TABLE gt_internal_table INDEX ls_rows-index ASSIGNING <lfs_table>.
      <lfs_table>-ebeln = lv_purchasingdoc.
    ENDLOOP.

    DATA: lt_message_popup TYPE TABLE OF gty_msg.

    LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<lfs_return>) WHERE type CA 'AEX'.
      APPEND INITIAL LINE TO lt_message_popup ASSIGNING FIELD-SYMBOL(<lfs_popup>).
      <lfs_popup>-msgty = <lfs_return>-type .
      <lfs_popup>-msgid = <lfs_return>-id .
      <lfs_popup>-msgno = <lfs_return>-number .
      <lfs_popup>-msgv1 = <lfs_return>-message_v1 .
      <lfs_popup>-msgv2 = <lfs_return>-message_v2 .
      <lfs_popup>-msgv3 = <lfs_return>-message_v3 .
      <lfs_popup>-msgv4 = <lfs_return>-message_v4 .
      <lfs_popup>-lineno = sy-tabix.
    ENDLOOP.

    CALL FUNCTION 'C14Z_MESSAGES_SHOW_AS_POPUP'
      TABLES
        i_message_tab = lt_message_popup.
  ENDMETHOD.

  METHOD get_detail.
*CALL FUNCTION 'BAPI_CONTRACT_GETDETAIL'
*  EXPORTING
*    purchasingdocument          =
*   ITEM_DATA                   = 'X'
*   ACCOUNT_DATA                = ' '
*   CONDITION_DATA              = ' '
*   TEXT_DATA                   = ' '
*   PARTNER_DATA                = ' '
*   RELEASE_DATA                = ' '
* IMPORTING
*   HEADER                      =
* TABLES
*   ITEM                        =
*   ACCOUNT                     =
*   DELIVERY_ADDRESS            =
*   ITEM_COND_VALIDITY          =
*   ITEM_CONDITION              =
*   ITEM_COND_SCALE_VALUE       =
*   ITEM_COND_SCALE_QUAN        =
*   ITEM_TEXT                   =
*   HEADER_TEXT                 =
*   HEAD_COND_VALIDITY          =
*   HEAD_CONDITION              =
*   HEAD_COND_SCALE_VAL         =
*   HEAD_COND_SCALE_QUAN        =
*   PARTNER                     =
*   RELEASE_DOCU                =
*   EXTENSIONOUT                =
*   RETURN                      =
          .

  ENDMETHOD.

  METHOD change_contract.

  ENDMETHOD.
ENDCLASS.
