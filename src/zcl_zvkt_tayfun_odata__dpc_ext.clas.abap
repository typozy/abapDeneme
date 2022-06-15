class ZCL_ZVKT_TAYFUN_ODATA__DPC_EXT definition
  public
  inheriting from ZCL_ZVKT_TAYFUN_ODATA__DPC
  create public .

public section.
protected section.

  methods TABLO1SET_CREATE_ENTITY
    redefinition .
  methods TABLO1SET_DELETE_ENTITY
    redefinition .
  methods TABLO1SET_GET_ENTITY
    redefinition .
  methods TABLO1SET_GET_ENTITYSET
    redefinition .
  methods TABLO1SET_UPDATE_ENTITY
    redefinition .
  methods TABLO2SET_CREATE_ENTITY
    redefinition .
  methods TABLO2SET_GET_ENTITY
    redefinition .
  methods TABLO2SET_GET_ENTITYSET
    redefinition .
  methods TABLO2SET_UPDATE_ENTITY
    redefinition .
  methods TABLO2SET_DELETE_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZVKT_TAYFUN_ODATA__DPC_EXT IMPLEMENTATION.


  METHOD tablo1set_create_entity.
    DATA: ls_entity   TYPE zvkt_tayfun_s003,
          ls_entity_t TYPE zvkt_tayfun_t003.
    TRY.
        io_data_provider->read_entry_data(
          IMPORTING
            es_data                      = ls_entity
        ).
      CATCH /iwbep/cx_mgw_tech_exception.
    ENDTRY.
    IF ls_entity IS NOT INITIAL.
      MOVE-CORRESPONDING ls_entity TO ls_entity_t.
      ls_entity_t-mandt = sy-mandt.
      SELECT SINGLE COUNT(*)
        FROM zvkt_tayfun_t003
        WHERE vbeln = @ls_entity_t-vbeln
        INTO @DATA(ls_count).
      IF sy-subrc NE 0.
        INSERT zvkt_tayfun_t003 FROM ls_entity_t.
        IF sy-subrc EQ 0.
          COMMIT WORK AND WAIT.
        ELSE.
          ROLLBACK WORK.
        ENDIF.
      else.
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            textid                 = /iwbep/cx_mgw_busi_exception=>business_error
            message                = 'Insert edilecek olan veriler zaten tabloda bulunuyor.'
        .
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD tablo1set_delete_entity.
    DATA lv_vbeln TYPE vbeln.

    READ TABLE it_key_tab INTO DATA(ls_key) WITH KEY name = 'Vbeln'.
    IF sy-subrc EQ 0.
      lv_vbeln = ls_key-value.
    ENDIF.

    lv_vbeln = |{ lv_vbeln ALPHA = IN }|.
    DELETE FROM zvkt_tayfun_t003 WHERE vbeln = lv_vbeln.
    IF sy-subrc EQ 0.
      COMMIT WORK AND WAIT.
    ELSE.
      ROLLBACK WORK.
    ENDIF.
  ENDMETHOD.


  method TABLO1SET_GET_ENTITY.
    data lv_vbeln type vbeln.
    read table it_key_tab into data(ls_key) with key name = 'Vbeln'.
    if sy-subrc eq 0.
      lv_vbeln = ls_key-value.
    endif.
    lv_vbeln = |{ lv_vbeln ALPHA = IN }|.
    select SINGLE *
      from zvkt_tayfun_t003
      into CORRESPONDING FIELDS OF er_entity
      where vbeln = lv_vbeln.
  endmethod.


  method TABLO1SET_GET_ENTITYSET.
*    data r_vbeln type RANGE OF vbeln.
*    loop at it_filter_select_options into data(ls_filter).
*      CASE ls_filter-property.
*        WHEN 'Vbeln'.
*          MOVE-CORRESPONDING ls_filter-select_options to r_vbeln.
*      ENDCASE.
*    ENDLOOP.
*
*    loop at r_vbeln ASSIGNING FIELD-SYMBOL(<lfs_vbeln>).
*      <lfs_vbeln>-low = |{ <lfs_vbeln>-low ALPHA = IN }|.
*      <lfs_vbeln>-high = |{ <lfs_vbeln>-high ALPHA = IN }|.
*    ENDLOOP.
*
*    select *
*      from zvkt_tayfun_t003
*      into CORRESPONDING FIELDS OF TABLE et_entityset
*      where vbeln in r_vbeln.

    select *
      from zvkt_tayfun_t003
      into CORRESPONDING FIELDS OF TABLE et_entityset
      where (iv_filter_string).

  endmethod.


  method TABLO1SET_UPDATE_ENTITY.
    DATA: ls_entity   TYPE zvkt_tayfun_s003,
          ls_entity_t TYPE zvkt_tayfun_t003.
    TRY.
        io_data_provider->read_entry_data(
          IMPORTING
            es_data                      = ls_entity
        ).
      CATCH /iwbep/cx_mgw_tech_exception.

    ENDTRY.

    IF ls_entity IS NOT INITIAL.
      MOVE-CORRESPONDING ls_entity TO ls_entity_t.
      ls_entity_t-mandt = sy-mandt.
      SELECT SINGLE COUNT(*)
        FROM zvkt_tayfun_t003
        WHERE vbeln = @ls_entity_t-vbeln
        INTO @DATA(ls_count).
      IF sy-subrc EQ 0.
        UPDATE zvkt_tayfun_t003 FROM ls_entity_t.
        IF sy-subrc EQ 0.
          COMMIT WORK AND WAIT.
        ELSE.
          ROLLBACK WORK.
        ENDIF.
      else.
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            textid                 = /iwbep/cx_mgw_busi_exception=>business_error
            message                = 'Update edilecek olan veriler tabloda bulunmuyor.'
        .
      ENDIF.
    ENDIF.
  endmethod.


  method TABLO2SET_CREATE_ENTITY.
    DATA: ls_entity   TYPE zvkt_tayfun_s004,
          ls_entity_t TYPE zvkt_tayfun_t004.
    TRY.
        io_data_provider->read_entry_data(
          IMPORTING
            es_data                      = ls_entity
        ).
      CATCH /iwbep/cx_mgw_tech_exception.
    ENDTRY.
    IF ls_entity IS NOT INITIAL.
      MOVE-CORRESPONDING ls_entity TO ls_entity_t.
      ls_entity_t-mandt = sy-mandt.
      SELECT SINGLE COUNT(*)
        FROM zvkt_tayfun_t004
        WHERE vbeln = @ls_entity_t-vbeln and
              posnr = @ls_entity_t-posnr
        INTO @DATA(ls_count).
      IF sy-subrc NE 0.
        INSERT zvkt_tayfun_t004 FROM ls_entity_t.
        IF sy-subrc EQ 0.
          COMMIT WORK AND WAIT.
        ELSE.
          ROLLBACK WORK.
        ENDIF.
      else.
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            textid                 = /iwbep/cx_mgw_busi_exception=>business_error
            message                = 'Insert edilecek olan veriler zaten tabloda bulunuyor.'
        .
      ENDIF.
    ENDIF.
  endmethod.


  METHOD tablo2set_delete_entity.
    DATA: lv_vbeln TYPE vbeln,
          lv_posnr TYPE posnr.

    READ TABLE it_key_tab INTO DATA(ls_key) WITH KEY name = 'Vbeln'.
    IF sy-subrc EQ 0.
      lv_vbeln = ls_key-value.
    ENDIF.
    READ TABLE it_key_tab INTO ls_key WITH KEY name = 'Posnr'.
    IF sy-subrc EQ 0.
      lv_posnr = ls_key-value.
    ENDIF.

    lv_vbeln = |{ lv_vbeln ALPHA = IN }|.
    lv_posnr = |{ lv_posnr ALPHA = IN }|.

    DELETE FROM zvkt_tayfun_t004
      WHERE vbeln = lv_vbeln AND
            posnr = lv_posnr.
    IF sy-subrc EQ 0.
      COMMIT WORK AND WAIT.
    ELSE.
      ROLLBACK WORK.
    ENDIF.
  ENDMETHOD.


  METHOD tablo2set_get_entity.
    DATA: lv_vbeln TYPE vbeln,
          lv_posnr TYPE posnr.

    READ TABLE it_key_tab INTO DATA(ls_key) WITH KEY name = 'Vbeln'.
    IF sy-subrc EQ 0.
      lv_vbeln = ls_key-value.
    ENDIF.
    lv_vbeln = |{ lv_vbeln ALPHA = IN }|.

    READ TABLE it_key_tab INTO ls_key WITH KEY name = 'Posnr'.
    IF sy-subrc EQ 0.
      lv_posnr = ls_key-value.
    ENDIF.
    lv_posnr = |{ lv_posnr ALPHA = IN }|.

    SELECT SINGLE *
      FROM zvkt_tayfun_t004
      INTO CORRESPONDING FIELDS OF er_entity
      WHERE vbeln = lv_vbeln and
            posnr = lv_posnr.

  ENDMETHOD.


  METHOD tablo2set_get_entityset.

    DATA: r_vbeln TYPE RANGE OF vbeln,
          r_posnr TYPE RANGE OF posnr.

    LOOP AT it_filter_select_options INTO DATA(ls_filter).
      CASE ls_filter-property.
        WHEN 'Vbeln'.
          MOVE-CORRESPONDING ls_filter-select_options TO r_vbeln.
        WHEN 'Posnr'.
          MOVE-CORRESPONDING ls_filter-select_options TO r_posnr.
      ENDCASE.
    ENDLOOP.

    LOOP AT r_vbeln ASSIGNING FIELD-SYMBOL(<lfs_vbeln>).
      <lfs_vbeln>-low = |{ <lfs_vbeln>-low ALPHA = IN }|.
      <lfs_vbeln>-high = |{ <lfs_vbeln>-high ALPHA = IN }|.
    ENDLOOP.

    LOOP AT r_posnr ASSIGNING FIELD-SYMBOL(<lfs_posnr>).
      <lfs_posnr>-low = |{ <lfs_posnr>-low ALPHA = IN }|.
      <lfs_posnr>-high = |{ <lfs_posnr>-high ALPHA = IN }|.
    ENDLOOP.

    SELECT *
      FROM zvkt_tayfun_t004
      INTO CORRESPONDING FIELDS OF TABLE et_entityset
      WHERE vbeln IN r_vbeln AND
            posnr IN r_posnr.

*    select *
*      from zvkt_tayfun_t004
*      into CORRESPONDING FIELDS OF TABLE et_entityset
*      where (iv_filter_string).

  ENDMETHOD.


  method TABLO2SET_UPDATE_ENTITY.
    DATA: ls_entity   TYPE zvkt_tayfun_s004,
          ls_entity_t TYPE zvkt_tayfun_t004.
    TRY.
        io_data_provider->read_entry_data(
          IMPORTING
            es_data                      = ls_entity
        ).
      CATCH /iwbep/cx_mgw_tech_exception.

    ENDTRY.

    IF ls_entity IS NOT INITIAL.
      MOVE-CORRESPONDING ls_entity TO ls_entity_t.
      ls_entity_t-mandt = sy-mandt.
      SELECT SINGLE COUNT(*)
        FROM zvkt_tayfun_t004
        WHERE vbeln = @ls_entity_t-vbeln and
              posnr = @ls_entity_t-posnr
        INTO @DATA(ls_count).
      IF sy-subrc EQ 0.
        UPDATE zvkt_tayfun_t004 FROM ls_entity_t.
        IF sy-subrc EQ 0.
          COMMIT WORK AND WAIT.
        ELSE.
          ROLLBACK WORK.
        ENDIF.
      else.
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            textid                 = /iwbep/cx_mgw_busi_exception=>business_error
            message                = 'Update edilecek olan veriler tabloda bulunmuyor.'
        .
      ENDIF.
    ENDIF.
  endmethod.
ENDCLASS.
