--Dieser SQL-Code führt eine Abfrage aus, die bestimmte Gebäude in Zürich auswählt 
--und die Entfernung dieser Gebäude zu einem bestimmten Punkt berechnet.
--Dieser Code sucht nach Gebäuden in Zürich (in den Postleitzahlgebieten 8055 und 8003), die eine Straßenadresse haben. 
--Für jedes dieser Gebäude wird die Entfernung zum Großmünster berechnet und ausgegeben.

-- Select buildings and get the distance of buildings to a selected location
SELECT 
  p.osm_id,
  p."addr:street",
  p."addr:housenumber",
  p."addr:city",
  p."addr:postcode",
  p.building,
  ST_Distance(
    ST_Transform(p.way, 4326)::geography,
  -- Zürich, Grossmünster
    ST_SetSRID(ST_MakePoint(8.54394, 47.37011), 4326)::geography
  ) AS distance,
  ST_Transform(p.way, 4326) AS way_transformed
FROM 
public.planet_osm_polygon AS p
WHERE 
p."addr:street" IS NOT NULL
AND p."addr:city" = 'Zürich'
AND p."addr:postcode" IN ('8055', '8003')
