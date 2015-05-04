SELECT 
distinct i.[No_] as EAN
,i.[Description] as Bezeichnung
,i.[Description 2] as Bezeichnung2
,i.[Attribute 2] as Kategorie_Code
,dv.[Name] as Kategorie_Name
,cast(su.[Reorder Point] as int) as min_Bestandwert
,cast(su.[Maximum Inventory] as int) as max_Bestandwert
,su.[Klasse] as ArtikelKlasse
FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Item] i
  left outer join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$BOM Component] bc
	on i.[No_]=bc.[Parent Item No_]
	join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Dimension Value] dv
		on i.[Attribute 2]=dv.[Code]
	join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Stockkeeping Unit]su
		on i.[No_]=su.[Item No_]
where bc.[Parent Item No_] is null
and su.[Location Code]='BER_FIEGE'
and (i.[Attribute 2] between 'B00' and 'B43' or i.[Attribute 2] between '175' and '179') /*Spielzeugkaegorie*/



