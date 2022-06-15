*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZEGT_GALIP_T007.................................*
DATA:  BEGIN OF STATUS_ZEGT_GALIP_T007               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZEGT_GALIP_T007               .
CONTROLS: TCTRL_ZEGT_GALIP_T007
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZEGT_GALIP_T007               .
TABLES: ZEGT_GALIP_T007                .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
