*&---------------------------------------------------------------------*
*& Report ZEGT_GALIP_015
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEGT_GALIP_015.

data itab type TABLE OF i.

data int type i.

IMPORT itab FROM MEMORY ID 'ITABMEM'.
IMPORT int FROM MEMORY ID 'VALMEM'.

BREAK-POINT.
