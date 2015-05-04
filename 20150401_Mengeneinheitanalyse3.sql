
with
einheit as
(
  Select 
  ffpl.[No_] as EAN
  ,ffph.[No_] as Belegnummer
  ,cast(ffph.[Posting Date] as date) as Buchungsdatum
  ,ffpl.[Description] as Beschreibung
  ,ffpl.[Description 2] as Beschreibung2
  ,ffpl.[Unit of Measure] as Einheit
  ,ffpl.[Unit of Measure Code] as EinheitsCode
  ,Rank() 
  over (Partition by ffpl.[No_]
		order by ffph.[Posting Date] desc) as Rankordnung
  FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFPurchaseHeader] ffph with (nolock)
  join  [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFPurchaseLine] ffpl with (nolock)
	on ffpl.[Document No_]=ffph.[No_] and ffpl.[Document Entry No_]=ffph.[Entry No_]
	--join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$BOM Component] bc with (nolock)
	--	on ffpl.[No_]=bc.[Parent Item No_] 

	where ffph.[Location Code]='BER_FIEGE' and ffpl.[Location Code]='BER_FIEGE' 
	and ffpl.[Type]=2
	and ffph.[No_] like 'BEST%'
	)
	Select 
	einheit.EAN
	,einheit.Belegnummer
	,einheit.Buchungsdatum
	,einheit.Beschreibung
	,einheit.Beschreibung2
	,einheit.Einheit
	,einheit.EinheitsCode
	--,einheit.Rankordnung
	from einheit
	where einheit.Rankordnung=1
	--and einheit.Belegnummer like 'BEST%'
	group by einheit.EAN
	,einheit.Buchungsdatum
	,einheit.Beschreibung
	,einheit.Beschreibung2
	,einheit.EinheitsCode
	,einheit.Rankordnung
	,einheit.Belegnummer
	,einheit.Einheit
	order by einheit.Buchungsdatum
