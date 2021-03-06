 with
 dimension550 as
 (select 
 ofm.[EAN] as EAN
 ,it.[Description] as Beschreibung
 ,it.[Description 2] as Beschreibung2
 ,dv.[Code] as KategorieCode
 ,dv.[Name] as KategorieName
 ,ofm.[Laenge] as L�nge
 ,ofm.[Hoehe] as H�he
 ,ofm.[Breite] as Breite
 ,cast(ofm.[Gewicht] as decimal(10,2)) as Gewicht
 
 ,case
	when ((ofm.[Laenge]>=ofm.[Hoehe]) and (ofm.[Laenge]>=ofm.[Breite])) then ofm.[Laenge]
	when ((ofm.[Hoehe]>=ofm.[Laenge]) and (ofm.[Hoehe]>=ofm.[Breite])) then ofm.[Hoehe]
	when ((ofm.[Breite]>=ofm.[Hoehe]) and (ofm.[Breite]>=ofm.[Laenge])) then ofm.[Breite] end as L�ngste_Dimension
 

FROM [BI_Data].[dbo].[OPS_Fiege_Morphologie] ofm with (nolock)
join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Item] it with (nolock)
	on ofm.[EAN]=it.[No_] collate Latin1_General_100_CS_AS
join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Dimension Value] dv with (nolock)
	on dv.[Code]=it.[Attribute 2] collate Latin1_General_100_CS_AS
)
Select 
dimension550.EAN
,dimension550.Beschreibung
,dimension550.Beschreibung2
,dimension550.KategorieCode
,dimension550.KategorieName
,dimension550.L�nge
,dimension550.H�he
,dimension550.Breite
,dimension550.L�ngste_Dimension
,dimension550.Gewicht
from dimension550
where (dimension550.L�ngste_Dimension>550 and dimension550.Gewicht>3.5)
