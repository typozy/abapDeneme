*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZGTS_FG_SANS1_TM
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZGTS_FG_SANS1_TM   .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
