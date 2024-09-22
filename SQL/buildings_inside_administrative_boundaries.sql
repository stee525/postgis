-- All buildings inside the administrative boundaries of the city of Zuerich
WITH zurich_boundary AS (
    SELECT way
    FROM planet_osm_polygon
    WHERE boundary = 'administrative'
    AND admin_level = '8'
    AND name = 'Zürich'
)
SELECT
    b.osm_id,
    b."addr:housenumber" AS house_number,
    b."addr:street" AS street,
    b."addr:postcode" AS postcode,
    b."addr:city" AS city,
    b."addr:country" AS country,
    b.building AS building_type,
    ST_Transform(b.way, 4326) AS geom
FROM planet_osm_polygon b
WHERE b.building IS NOT NULL
AND ST_Within(ST_Transform(b.way, 4326), (SELECT ST_Transform(way, 4326) FROM zurich_boundary));