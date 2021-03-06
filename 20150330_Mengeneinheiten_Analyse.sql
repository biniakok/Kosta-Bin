/****** Skript für SelectTopNRows-Befehl aus SSMS ******/
--SELECT top 1000 *
--  FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Purch_ Rcpt_ Line]


--select top 1000 *
--   FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFPurchaseLine]

with
einheiten as
(
Select 
distinct prl.[No_] as EAN
,prl.[Description] as Beschreibung
,prl.[Description 2] as Beschreibung2
--,cast([Quantity] as decimal(10,2)) as Menge
,prl.[Unit of Measure] as Einheit 
--,cast(prl.[Unit Cost (LCY)] as decimal(10,2)) as EK_Preis_Bestellung
,prl.[Unit of Measure Code] as EinheitsCode_Bestellung
,ffprl.[Unit of Measure] as Einheit_Verkauf
--,cast(ffprl.[Unit Cost (LCY)] as decimal(10,2)) as EK_Preis_Verkauf
,ffprl.[Unit of Measure Code] as EinheitsCode_Verkauf
, case when (prl.[Unit of Measure Code]='1ER' and ffprl.[Unit of Measure Code]='ST') or (prl.[Unit of Measure Code]='ST' and ffprl.[Unit of Measure Code]='1ER') then 1 else 0 end as Vergleich 

FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Purch_ Rcpt_ Line] prl
join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFPurchaseLine] ffprl
	on prl.[No_]=ffprl.[No_]
where prl.[Location Code]='BER_FIEGE'
--and ffprl.[Location Code]='BER_FIEGE'
--and prl.[Posting Date] between '2015-01-01' and getdate()
--and ffprl.[Shipment Date] between '2015-01-01' and getdate()
and prl.[Unit of Measure Code]<>ffprl.[Unit of Measure Code]
--and prl.[Type]=2
and ffprl.[Type]=2
--and (prl.[Unit of Measure Code]='1ER' is null  and ffprl.[Unit of Measure Code]='ST' is null) is null or (prl.[Unit of Measure Code]='ST' and ffprl.[Unit of Measure Code]='1ER') is null
group by prl.[No_],prl.[Description],prl.[Description 2],prl.[Unit of Measure],prl.[Unit of Measure Code],ffprl.[Unit of Measure],ffprl.[Unit of Measure Code]
--,prl.[Unit Cost (LCY)],ffprl.[Unit Cost (LCY)] 
)
Select 
einheiten.EAN
,einheiten.Beschreibung
,einheiten.Beschreibung2
,einheiten.Einheit
--,einheiten.EK_Preis_Bestellung
,einheiten.EinheitsCode_Bestellung
,einheiten.Einheit_Verkauf
--,einheiten.EK_Preis_Verkauf
,einheiten.EinheitsCode_Verkauf
,einheiten.Vergleich 
from einheiten
where einheiten.Vergleich<>1