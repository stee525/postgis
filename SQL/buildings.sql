-- Dieser SQL-Code sucht nach Gebäuden in der Stadt Zürich mit der Postleitzahl 8001, die eine Straßenadresse haben. 
-- Es werden einige Attribute der Gebäude ausgewählt und die geometrische Form in das WGS 84-Koordinatensystem (EPSG:4326) transformiert. 
-- Dieser Code sucht nach Gebäuden in Zürich, die eine Postleitzahl von 8001 haben (was auf die Altstadt hindeutet) und eine gültige Straßenadresse besitzen. 
-- Für jedes Gebäude werden relevante Informationen wie Straße, Hausnummer, Postleitzahl und die Geometrie (als umgewandeltes Polygon) zurückgegeben.

-- All buildings for which the city name is 'Zürich' and the postal code is '8001'.
SELECT
    p.osm_id,
    p."addr:street",
    p."addr:housenumber",
    p."addr:city",
    p."addr:postcode",
    p.building,
    st_transform(p.way, 4326) AS geom
FROM
    public.planet_osm_polygon AS p
WHERE 
    p."addr:street" IS NOT NULL
    AND p."addr:city" = 'Zürich'
    AND p."addr:postcode" IN ('8001')
