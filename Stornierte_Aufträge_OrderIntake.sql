/****** Skript für SelectTopNRows-Befehl aus SSMS ******/
--SELECT TOP 1000 *
--  FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayNavCSalesHeader]

--  SELECT TOP 1000 *
--  FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFSalesHeader]

  with
  storno as
  (
     Select 
  distinct ncsh.[Sales Document No_] as ANR_NavCSales
 ,ncsh.[External Document No_] as Ext_Belegnummer
  ,case when ncsh.[Status]=3    then 1 else 0 end as Storno_NavCSales
 ,case when  ffsh.[Type]=2 then 1 else 0 end as Storno_FFSalesHeader

  FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayNavCSalesHeader] ncsh
   left join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFSalesHeader] ffsh
   on (ncsh.[Sales Document No_]=ffsh.[No_] and ncsh.[External Document No_]=ffsh.[External Document No_])
   where ncsh.[Order Date]>='2014-10-01'
   and ncsh.[Order Date]<='2014-12-31'
  and ncsh.[Status]=3 
  and ffsh.[Type]=1
  and ffsh.[Reason Code]='WINDELN_DE'
   
  )
  Select 
  storno.ANR_NavCSales
  ,storno.Ext_Belegnummer
  ,storno.Storno_NavCSales
  ,storno.Storno_FFSalesHeader
  from storno 
  
   