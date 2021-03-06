
with
einheit as
(
  Select 
  pl.[No_] as EAN
  ,ph.[No_] as Belegnummer
  ,cast(ph.[Posting Date] as date) as Buchungsdatum
  ,pl.[Description] as Beschreibung
  ,pl.[Description 2] as Beschreibung2
  ,pl.[Unit of Measure] as Einheit
  ,pl.[Unit of Measure Code] as EinheitsCode
  ,Rank() 
  over (Partition by pl.[No_]
		order by ph.[Posting Date] desc) as Rankordnung
  FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Purchase Header] ph with (nolock)
  join  [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Purchase Line] pl with (nolock)
	on pl.[Document No_]=ph.[No_]
	--where ph.[Location Code]='BER_FIEGE' and pl.[Location Code]='BER_FIEGE' 
	where pl.[Type]=2
	--and ph.[Posting Date] >'2013-01-01'
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
	and einheit.Belegnummer like 'BEST%'
	group by einheit.EAN
	,einheit.Buchungsdatum
	,einheit.Beschreibung
	,einheit.Beschreibung2
	,einheit.EinheitsCode
	,einheit.Rankordnung
	,einheit.Belegnummer
	,einheit.Einheit
	order by einheit.Buchungsdatum
