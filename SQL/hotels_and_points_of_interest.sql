-- Dieser SQL-Code extrahiert alle Hotels innerhalb der Stadtgrenzen von Zürich aus einer OpenStreetMap-Datenbank. 
-- Die Abfrage nutzt eine CTE (Common Table Expression) für die Definition der Stadtgrenzen von Zürich und 
-- sucht anschließend nach Objekten, die als Hotels klassifiziert sind und innerhalb dieser Grenzen liegen. 

-- Hotels
WITH zurich_boundary AS (
    SELECT way
    FROM planet_osm_polygon
    WHERE boundary = 'administrative'
    AND admin_level = '8'
    AND name = 'Zürich'
)
SELECT
    h.name AS hotel_name,
    h."addr:housenumber" AS house_number,
    h."addr:street" AS street,
    h."addr:postcode" AS postcode,
    h."addr:city" AS city,
    h."addr:country" AS country,
    ST_Transform(h.way, 4326) AS geom
FROM planet_osm_point h
WHERE h.tourism = 'hotel'
AND ST_Within(ST_Transform(h.way, 4326), (SELECT ST_Transform(way, 4326) FROM zurich_boundary));

-- Dieser SQL-Code extrahiert bestimmte Points of Interest (POIs), wie Bars, Restaurants, Cafés, Pubs, Kinos und Theater, 
-- innerhalb der Stadtgrenzen von Zürich aus einer OpenStreetMap-Datenbank. 
-- Der Code verwendet eine Common Table Expression (CTE), um die Stadtgrenzen von Zürich zu definieren und prüft dann, 
-- ob die ausgewählten POIs innerhalb dieser Grenzen liegen. 
-- Points-of-Interest
WITH zurich_boundary AS (
    SELECT way
    FROM planet_osm_polygon
    WHERE boundary = 'administrative'
    AND admin_level = '8'
    AND name = 'Zürich'
)
SELECT
    poi.name AS poi_name,
    poi."addr:housenumber" AS house_number,
    poi."addr:street" AS street,
    poi."addr:postcode" AS postcode,
    poi."addr:city" AS city,
    ST_Transform(poi.way, 4326) AS geom
FROM planet_osm_point poi
WHERE poi.amenity IN ('bar', 
					  'restaurant', 
					  'cafe', 
					  'pub', 
					  'cinema', 
					  'theatre')
AND ST_Within(ST_Transform(poi.way, 4326), (SELECT ST_Transform(way, 4326) FROM zurich_boundary));

--Dieser SQL-Code extrahiert eine Liste von Points of Interest (POIs) wie Bars, Restaurants, Cafés, Pubs, Kinos und Theatern, 
-- die sich in der Nähe von Hotels innerhalb der Stadtgrenzen von Zürich befinden. 
-- Dabei wird eine Pufferzone von 250 Metern um jedes Hotel erstellt, um herauszufinden, 
-- welche POIs innerhalb dieser Zone liegen.
-- Points-of-Interest in Buffer-Distance around hotels
WITH zurich_boundary AS (
  SELECT way
  FROM planet_osm_polygon
  WHERE boundary = 'administrative'
  AND admin_level = '8'
  AND name = 'Zürich'
),
hotels AS (
  SELECT
    name AS hotel_name,
    way AS hotel_geom,
	ST_TRANSFORM(way, 4326) AS geom
  FROM planet_osm_point
  WHERE tourism = 'hotel'
  AND ST_Within(way, (SELECT way FROM zurich_boundary))
),
buffered_hotels AS (
  SELECT 
    hotel_name,
    hotel_geom,
    ST_Buffer(hotel_geom, 250) AS hotel_buffer
  FROM hotels
)
SELECT DISTINCT
  bh.hotel_name,
  poi.amenity,
  poi.name AS poi_name
FROM planet_osm_point poi
JOIN buffered_hotels bh ON ST_Within(poi.way, bh.hotel_buffer)
WHERE poi.amenity IS NOT NULL 
AND poi.amenity IN ('bar', 
                    'restaurant', 
                    'cafe', 
                    'pub', 
                    'cinema', 
                    'theatre');

--Dieser SQL-Code berechnet die Anzahl von bestimmten Points of Interest (POIs) wie Bars, Restaurants, Cafés, Pubs, Kinos und Theatern 
-- in einem Umkreis von 250 Metern um Hotels, die innerhalb der Stadtgrenzen von Zürich liegen. 
-- Das Ergebnis ist eine Liste von Hotels, sortiert nach der Anzahl der POIs in der Nähe. 
-- Count POI per hotel
WITH zurich_boundary AS (
  SELECT way
  FROM planet_osm_polygon
  WHERE boundary = 'administrative'
  AND admin_level = '8'
  AND name = 'Zürich'
),
hotels AS (
  SELECT
    name AS hotel_name,
    way AS hotel_geom,
	ST_TRANSFORM(way, 4326) AS geom
  FROM planet_osm_point
  WHERE tourism = 'hotel'
  AND ST_Within(way, (SELECT way FROM zurich_boundary))
),
buffered_hotels AS (
  SELECT 
    hotel_name,
    hotel_geom,
    ST_Buffer(hotel_geom, 250) AS hotel_buffer
  FROM hotels
)
SELECT DISTINCT
  bh.hotel_name,
  COUNT(poi.name) AS poi_count
FROM planet_osm_point poi
JOIN buffered_hotels bh ON ST_Within(poi.way, bh.hotel_buffer)
WHERE poi.amenity IS NOT NULL 
AND poi.amenity IN ('bar', 
                    'restaurant', 
                    'cafe', 
                    'pub', 
                    'cinema', 
                    'theatre')
GROUP BY bh.hotel_name
ORDER BY poi_count DESC;
