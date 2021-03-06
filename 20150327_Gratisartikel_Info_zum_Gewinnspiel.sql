/****** Skript für SelectTopNRows-Befehl aus SSMS ******/
--SELECT top 1000 *
--  FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFSalesHeader]


--SELECT top 1000 *
--  FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFSalesLine]



 
 select
 distinct ffsh.[No_] as AuftragsNr
 ,ffsl.[No_] as EAN
 ,ffsl.[Description] as Beschreibung
 --,ffsl.[Description 2] 
 ,ffsl.[Quantity Response] as Menge_Rückmeldung
 ,ffsl.[Quantity] as Menge 

  From [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFSalesHeader] ffsh
   join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFSalesLine]  ffsl
		on (ffsh.[No_]=ffsl.[Document No_] and ffsh.[Entry No_]=ffsl.[Document Entry No_])
	where ffsh.[Type]=1
	and ffsh.[Processing Status]=0 /*Status Offen*/
	and ffsl.[Quantity Response] <> ffsl.[Quantity] 
	and ffsl.[Description]  like '%Gewinnspiel%'
	and ffsl.[Type]=2