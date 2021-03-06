/****** Skript für SelectTopNRows-Befehl aus SSMS ******/
--SELECT TOP 1000 *
--  FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Item Unit of Measure]

  with 
  dim2000 as
  (select 
  uom.[Item No_] as EAN
  ,uom.[Code] as Code
  ,it.[Description] as Beschreibung
  ,it.[Description 2] as Beschreibung2
  ,dv.[Code] as KategorieCode  
  ,dv.[Name] as KategorieName
  ,uom.[Length] as Länge
  ,uom.[Height] as Höhe
  ,uom.[Width] as Breite
  

  ,case
	when ((uom.[Length]>=uom.[Height]) and (uom.[Length]>=uom.[Width])) then uom.[Length]
	when ((uom.[Height]>=uom.[Length]) and (uom.[Height]>=uom.[Width])) then uom.[Height]
	when ((uom.[Width]>=uom.[Height]) and (uom.[Width]>=uom.[Length])) then uom.[Width]
	end as Längste_Dimension



FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Item Unit of Measure] uom with (nolock)
join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Item] it with (nolock)
	on uom.[Item No_]=it.[No_] collate Latin1_General_100_CS_AS
join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Dimension Value] dv with (nolock)
	on dv.[Code]=it.[Attribute 2] collate Latin1_General_100_CS_AS
)
Select 
dim2000.EAN
,dim2000.Code
,dim2000.Beschreibung
,dim2000.Beschreibung2
,dim2000.KategorieCode
,dim2000.KategorieName
,cast(dim2000.Länge as int) as Länge 
,cast(dim2000.Breite as int) as Breite
,cast(dim2000.Höhe as int) as Höhe
,cast(dim2000.Längste_Dimension as int) as Längste_Dimension
from dim2000
where dim2000.Längste_Dimension>2000