class ZCL_ZODATA_TS_DDL002 definition
  public
  inheriting from CL_SADL_GTK_EXPOSURE_MPC
  final
  create public .

public section.
protected section.

  methods GET_PATHS
    redefinition .
  methods GET_TIMESTAMP
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZODATA_TS_DDL002 IMPLEMENTATION.


  method GET_PATHS.
et_paths = VALUE #(
( |CDS~ZODATA_TS_DDL002| )
).
  endmethod.


  method GET_TIMESTAMP.
RV_TIMESTAMP = 20220418120639.
  endmethod.
ENDCLASS.
