SELECT 
  cast(sh.[Order Date] as date) as AuftragsDatum 
  ,sh.[No_] as AuftragsNr
  ,sh.[External Document No_] as Externe_Belegnummer
  ,sh.[Sell-to Customer No_] as KundenNr
  , sh.[Sell-to Customer Name] as KundenName
,cast(datediff(day,sh.[Order Date],getdate()) as decimal(10,2))/30 as Anzahl_Monate
FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Sales Header] sh
 	
where sh.[Location Code]='BER_FIEGE'
and cast(datediff(day,sh.[Order Date],getdate()) as decimal(10,2))/30>1
and sh.[Status]=1 /* Status Freigegeben*/
order by cast(datediff(day,sh.[Order Date],getdate()) as decimal(10,2))/30 desc



