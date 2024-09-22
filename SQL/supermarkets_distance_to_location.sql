-- Select all supermarkets within defined distance around 'Hauptbahnhof Zürich' and calculate distance
SELECT
    p.osm_id,
    p."addr:street",
    p."addr:housenumber",
    p."addr:city",
    p."addr:postcode",
    p.shop,
    UPPER(p.name) AS brand,
    ST_Distance(
        ST_Transform(p.way, 4326)::geography,
        ST_SetSRID(ST_MakePoint(8.540192, 47.378177), 4326)::geography
    ) AS distance_meters,
	ST_TRANSFORM(p.way, 4326) AS geom
FROM
    public.planet_osm_point AS p
WHERE
    p.shop = 'supermarket'
    AND p."addr:street" IS NOT NULL
    AND p."addr:housenumber" IS NOT NULL
    AND p."addr:city" IS NOT NULL
    AND p."addr:postcode" IS NOT NULL
    AND ST_DWithin(
        ST_Transform(p.way, 4326)::geography,
        ST_SetSRID(ST_MakePoint(8.540192, 47.378177), 4326)::geography,
        2000
    )
ORDER BY distance_meters;