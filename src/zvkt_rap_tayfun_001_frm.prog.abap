*&---------------------------------------------------------------------*
*& Include          ZVKT_RAP_TAYFUN_001_FRM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form GET_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM  get_data .
  SELECT vbeln,
         kunnr,
         netwr,
         waerk,
         vkorg,
         erdat,
         spart
    FROM vbak
    WHERE vbeln IN @so_vbeln
    INTO CORRESPONDING FIELDS OF TABLE @gt_table.

  LOOP AT gt_table INTO DATA(ls_table).
*    IF ls_table-netwr EQ 2000.
*      ls_table-line_color = 'C610'.
*    ELSEIF ls_table-netwr EQ 800.
*      ls_table-line_color = 'C110'.
*    ENDIF.

    IF ls_table-waerk = 'TRY'.
      gs_cellcolor-fieldname = 'NETWR'.
      gs_cellcolor-color-col = 6.
      gs_cellcolor-color-int = 1.
      gs_cellcolor-color-inv = 1.
      APPEND gs_cellcolor TO ls_table-cell_color.
    ENDIF.
    MODIFY gt_table FROM ls_table.
  ENDLOOP.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_FCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fcat .
  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
*     I_PROGRAM_NAME   =
*     I_INTERNAL_TABNAME           =
      i_structure_name = 'ZVKT_S0045'
*     I_CLIENT_NEVER_DISPLAY       = 'X'
*     I_INCLNAME       =
*     I_BYPASSING_BUFFER           =
*     I_BUFFER_ACTIVE  =
    CHANGING
      ct_fieldcat      = gt_fcat
* EXCEPTIONS
*     INCONSISTENT_INTERFACE       = 1
*     PROGRAM_ERROR    = 2
*     OTHERS           = 3
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_LAYOUT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_layout .
  gs_layout-zebra = 'X'.
  gs_layout-colwidth_optimize = 'X'.
*  gs_layout-info_fieldname = 'LINE_COLOR'.
  gs_layout-coltab_fieldname = 'CELL_COLOR'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_alv .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK                 = ' '
*     I_BYPASSING_BUFFER                = ' '
*     I_BUFFER_ACTIVE                   = ' '
*     I_CALLBACK_PROGRAM                = ' '
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
*     I_CALLBACK_TOP_OF_PAGE            = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME                  =
*     I_BACKGROUND_ID                   = ' '
*     I_GRID_TITLE                      =
*     I_GRID_SETTINGS                   =
      is_layout   = gs_layout
      it_fieldcat = gt_fcat
*     IT_EXCLUDING                      =
*     IT_SPECIAL_GROUPS                 =
*     IT_SORT     =
*     IT_FILTER   =
*     IS_SEL_HIDE =
*     I_DEFAULT   = 'X'
*     I_SAVE      = ' '
*     IS_VARIANT  =
*     IT_EVENTS   =
*     IT_EVENT_EXIT                     =
*     IS_PRINT    =
*     IS_REPREP_ID                      =
*     I_SCREEN_START_COLUMN             = 0
*     I_SCREEN_START_LINE               = 0
*     I_SCREEN_END_COLUMN               = 0
*     I_SCREEN_END_LINE                 = 0
*     I_HTML_HEIGHT_TOP                 = 0
*     I_HTML_HEIGHT_END                 = 0
*     IT_ALV_GRAPHICS                   =
*     IT_HYPERLINK                      =
*     IT_ADD_FIELDCAT                   =
*     IT_EXCEPT_QINFO                   =
*     IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      t_outtab    = gt_table
* EXCEPTIONS
*     PROGRAM_ERROR                     = 1
*     OTHERS      = 2
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_LIST
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_list .
  CALL FUNCTION 'REUSE_ALV_LIST_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK              = ' '
*     I_BYPASSING_BUFFER             =
*     I_BUFFER_ACTIVE                = ' '
*     I_CALLBACK_PROGRAM             = ' '
*     I_CALLBACK_PF_STATUS_SET       = ' '
*     I_CALLBACK_USER_COMMAND        = ' '
*     I_STRUCTURE_NAME               =
      is_layout   = gs_layout
      it_fieldcat = gt_fcat
*     IT_EXCLUDING                   =
*     IT_SPECIAL_GROUPS              =
*     IT_SORT     =
*     IT_FILTER   =
*     IS_SEL_HIDE =
*     I_DEFAULT   = 'X'
*     I_SAVE      = ' '
*     IS_VARIANT  =
*     IT_EVENTS   =
*     IT_EVENT_EXIT                  =
*     IS_PRINT    =
*     IS_REPREP_ID                   =
*     I_SCREEN_START_COLUMN          = 0
*     I_SCREEN_START_LINE            = 0
*     I_SCREEN_END_COLUMN            = 0
*     I_SCREEN_END_LINE              = 0
*     IR_SALV_LIST_ADAPTER           =
*     IT_EXCEPT_QINFO                =
*     I_SUPPRESS_EMPTY_DATA          = ABAP_FALSE
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER        =
*     ES_EXIT_CAUSED_BY_USER         =
    TABLES
      t_outtab    = gt_table
* EXCEPTIONS
*     PROGRAM_ERROR                  = 1
*     OTHERS      = 2
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_POPUP
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_popup .
  CALL FUNCTION 'REUSE_ALV_POPUP_TO_SELECT'
    EXPORTING
      i_title          = 'POP-UP ALV'
*     I_SELECTION      = 'X'
*     I_ALLOW_NO_SELECTION          =
      i_zebra          = ' '
*     I_SCREEN_START_COLUMN         = 0
*     I_SCREEN_START_LINE           = 0
*     I_SCREEN_END_COLUMN           = 0
*     I_SCREEN_END_LINE             = 0
*     I_CHECKBOX_FIELDNAME          =
*     I_LINEMARK_FIELDNAME          =
*     I_SCROLL_TO_SEL_LINE          = 'X'
      i_tabname        = 1
      i_structure_name = 'ZVKT_S0045'
*     IT_FIELDCAT      =
*     IT_EXCLUDING     =
*     I_CALLBACK_PROGRAM            =
*     I_CALLBACK_USER_COMMAND       =
*     IS_PRIVATE       =
* IMPORTING
*     ES_SELFIELD      =
*     E_EXIT           =
    TABLES
      t_outtab         = gt_table
* EXCEPTIONS
*     PROGRAM_ERROR    = 1
*     OTHERS           = 2
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
