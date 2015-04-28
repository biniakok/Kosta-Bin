 with
 dim2000 as
 (select 
 ofm.[EAN] as EAN
 ,ofm.[Description] as Beschreibung
 ,dv.[Code] as KategorieCode
 ,dv.[Name] as KategorieName
 ,ofm.[Laenge] as Länge
 ,ofm.[Hoehe] as Höhe
 ,ofm.[Breite] as Breite
 
 ,case
	when ((ofm.[Laenge]>=ofm.[Hoehe]) and (ofm.[Laenge]>=ofm.[Breite])) then ofm.[Laenge]
	when ((ofm.[Hoehe]>=ofm.[Laenge]) and (ofm.[Hoehe]>=ofm.[Breite])) then ofm.[Hoehe]
	when ((ofm.[Breite]>=ofm.[Hoehe]) and (ofm.[Breite]>=ofm.[Laenge])) then ofm.[Breite] end as Längste_Dimension
 

FROM [BI_Data].[dbo].[OPS_Fiege_Morphologie] ofm with (nolock)
join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Item] it with (nolock)
	on ofm.[EAN]=it.[No_] collate Latin1_General_100_CS_AS
join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Dimension Value] dv with (nolock)
	on dv.[Code]=it.[Attribute 2] collate Latin1_General_100_CS_AS
)
Select 
dim2000.EAN
,dim2000.Beschreibung
,dim2000.KategorieCode
,dim2000.KategorieName
,dim2000.Länge
,dim2000.Höhe
,dim2000.Breite
,dim2000.Längste_Dimension
from dim2000
where dim2000.Längste_Dimension>2000
