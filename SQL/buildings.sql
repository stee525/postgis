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
