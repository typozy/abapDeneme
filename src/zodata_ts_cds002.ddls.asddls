@AbapCatalog.sqlViewName: 'ZODATA_TS_CDS002'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Örnek CDS'
@OData.publish: true
define view ZODATA_TS_DDL002 as select from acdoca {
    key rbukrs,
    key gjahr,
    key belnr,
    key docln,
        hsl,
        case
        when hsl < 0
        then '-'
        when hsl = 0
        then '0'
        when hsl > 0
        then '+'
        end as durum
} where rldnr = '0L'
 