*&---------------------------------------------------------------------*
*& Report ZEGT_GALIP_014
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zegt_galip_014.

DATA itab TYPE TABLE OF i.
DATA int TYPE i VALUE 19.

APPEND 6 TO itab.
APPEND 7 TO itab.
APPEND 8 TO itab.
APPEND 9 TO itab.
APPEND 10 TO itab.

EXPORT itab TO MEMORY ID 'ITABMEM'.
EXPORT int TO MEMORY ID 'VALMEM'.

SUBMIT zegt_galip_015 AND RETURN.

*DATA a TYPE TABLE OF string.
*DATA b TYPE TABLE OF string.
*
*APPEND 'ı' TO a.
*APPEND 'i' TO a.
*APPEND 'I' TO a.
*APPEND 'İ' TO a.
*APPEND 'ğ' TO a.
*APPEND 'ü' TO a.
*APPEND 'ş' TO a.
*APPEND 'ö' TO a.
*APPEND 'ç' TO a.
*
*APPEND 'ı' TO b.
*APPEND 'i' TO b.
*APPEND 'I' TO b.
*APPEND 'İ' TO b.
*APPEND 'Ğ' TO b.
*APPEND 'Ü' TO b.
*APPEND 'Ş' TO b.
*APPEND 'Ö' TO b.
*APPEND 'Ç' TO b.
*
*DATA it1 TYPE i VALUE 1.
*DATA it2 TYPE i.
*
*WHILE it1 <= 9.
*  read TABLE a index it1 INTO DATA(c).
*  it2 = 1.
*  WHILE it2 <= 9.
*    read TABLE b index it2 INTO DATA(d).
*    if c cs d.
*      WRITE :/ c,' eşit ', d.
*    ENDIF.
*    it2 = it2 + 1.
*  ENDWHILE.
*  it1 = it1 + 1.
*ENDWHILE.

*data ali TYPE string VALUE 'ali'.
*
*REPLACE ALL OCCURRENCES OF 'i' IN ali WITH 'İ'.
*
*WRITE :/ ali.
