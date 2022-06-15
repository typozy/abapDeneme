*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZEGT_GALIP_T004.................................*
DATA:  BEGIN OF STATUS_ZEGT_GALIP_T004               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZEGT_GALIP_T004               .
CONTROLS: TCTRL_ZEGT_GALIP_T004
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZEGT_GALIP_T004               .
TABLES: ZEGT_GALIP_T004                .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
