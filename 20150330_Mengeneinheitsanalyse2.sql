
with 
einkauf as
(
  Select 
  distinct ile.[Item No_] as EAN
 ,prl.[Description] as Beschreibung
 ,prl.[Description 2] as Beschreibung2
 ,ile.[Document No_] as Belegnummer
   ,prl.[Unit of Measure Code] as EinheitsCode
  ,prl.[Unit of Measure] as Einheit
  --,cast(ile.[Quantity] as int) as Menge
  ,cast(prl.[Unit Cost (LCY)] as decimal(10,2)) as EK_Preis_Unit
  ,sum(prl.[Quantity]) as Qty_prl
  ,sum(ile.[Quantity]) as Qty_ile
  ,sum(prl.[Quantity])/sum(ile.[Quantity])
  --,cast(prl.[Quantity]*prl.[Unit Cost (LCY)]) as EK_Preis_Gesamt
   --,case when prl.[Unit of Measure Code]='ST' or prl.[Unit of Measure Code]='1ER' then 1 else 0 end as vergleich
     FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Item Ledger Entry] ile with (nolock)
 	join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Purch_ Rcpt_ Line] prl  with (nolock)
		on prl.[Document No_]=ile.[Document No_] and ile.[Item No_]=prl.[No_]
  where ile.[Location Code]='BER_FIEGE'
  and ile.[Entry Type]=0
  and left(ile.[Document No_],3)='EKL'
  and prl.[Type]=2
  and ile.[Posting Date]>='2015-03-01'
  --and prl.[Unit of Measure] not like 'VKE'
  --and ile.[Item No_]like'40089762%'
  and prl.[Description 2] like '%Kinder-Milch 1 plus 600 g%'
  
  --and prl.[Unit of Measure Code]<>'1ER' or prl.[Unit of Measure Code]<>'ST'
  group by ile.[Item No_],prl.[Description],prl.[Description 2],ile.[Document No_],prl.[Unit of Measure Code],prl.[Unit of Measure],prl.[Unit Cost (LCY)]
  having sum(prl.[Quantity])<sum(ile.[Quantity])
),
verkauf as
(
 Select 
  distinct ile.[Item No_] as EAN
  ,sl.[Description] as Beschreibung
  ,sl.[Description 2] as Beschreibung2
  ,ile.[Document No_] as Belegnummer
  ,sl.[Unit of Measure Code] as VerkaufsCode
  ,sl.[Unit of Measure] as Einheit
  ,cast(sl.[Unit Price] as decimal(10,2)) as VK_Preis_Unit
  
   FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Item Ledger Entry] ile
	join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Sales Shipment Line] sl
		on sl.[Document No_]=ile.[Document No_] and ile.[Item No_]=sl.[No_] 
   
  where ile.[Location Code]='BER_FIEGE'
  and ile.[Entry Type]=1
  and left(ile.[Document No_],3)='VKL'
  and sl.[Type]=2
  and sl.[Unit of Measure]='ST' or sl.[Unit of Measure]='1ER'
   )
   Select 
   distinct einkauf.EAN as EAN
   ,einkauf.Beschreibung
   ,einkauf.Beschreibung2
   --,einkauf.menge as Einkauf_Menge
   ,einkauf.EinheitsCode as EinheitsCode_Bestellung
  ,einkauf.EK_Preis_Unit
   ,verkauf.VerkaufsCode as VerkaufsCode_Verkauf
   ,verkauf.VK_Preis_Unit
   from einkauf
   left join verkauf
   on einkauf.Belegnummer=verkauf.Belegnummer and einkauf.EAN=verkauf.EAN
   
