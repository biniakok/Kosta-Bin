/****** Skript f�r SelectTopNRows-Befehl aus SSMS ******/
--SELECT  *
--  FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Item Unit of Measure]

  with 
  dimension550 as
  (select 
  uom.[Item No_] as EAN
  ,uom.[Code] as Code
  ,it.[Description] as Beschreibung
  ,it.[Description 2] as Beschreibung2
  ,dv.[Code] as KategorieCode  
  ,dv.[Name] as KategorieName
  ,uom.[Length] as L�nge
  ,uom.[Height] as H�he
  ,uom.[Width] as Breite
  ,uom.[Weight] as Gewicht
  

  ,case
	when ((uom.[Length]>=uom.[Height]) and (uom.[Length]>=uom.[Width])) then uom.[Length]
	when ((uom.[Height]>=uom.[Length]) and (uom.[Height]>=uom.[Width])) then uom.[Height]
	when ((uom.[Width]>=uom.[Height]) and (uom.[Width]>=uom.[Length])) then uom.[Width]
	end as L�ngste_Dimension



FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Item Unit of Measure] uom with (nolock)
join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Item] it with (nolock)
	on uom.[Item No_]=it.[No_] collate Latin1_General_100_CS_AS
join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Dimension Value] dv with (nolock)
	on dv.[Code]=it.[Attribute 2] collate Latin1_General_100_CS_AS
)
Select 
dimension550.EAN
,dimension550.Code
,dimension550.Beschreibung
,dimension550.Beschreibung2
,dimension550.KategorieCode
,dimension550.KategorieName
,cast(dimension550.L�nge as int) as L�nge 
,cast(dimension550.Breite as int) as Breite
,cast(dimension550.H�he as int) as H�he
,cast(dimension550.Gewicht as int) as Gewicht
,cast(dimension550.L�ngste_Dimension as int) as L�ngste_Dimension
from dimension550
--where dimension550.L�ngste_Dimension>550 
where dimension550.Gewicht>3.5



SELECT  *
  FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Item Unit of Measure]
  where Weight>3.5
