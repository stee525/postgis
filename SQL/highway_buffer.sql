-- Dieser SQL-Code verwendet PostGIS-Funktionen, um Pufferzonen um Autobahnen in einer OpenStreetMap-Datenbank zu erstellen 
-- und diese Pufferzonen entweder einzeln oder als kombinierte Fläche zu berechnen. 
-- Die Geometrien werden dabei in das WGS 84-Koordinatensystem (SRID 4326) transformiert.
-- Die erste Abfrage erstellt einen separaten 1000-Meter-Puffer um jede Autobahn in der Datenbank und gibt die Puffer einzeln zurück.
-- Die zweite Abfrage kombiniert alle 1000-Meter-Puffer zu einer einzigen geometrischen Fläche, die den gepufferten Bereich um alle Autobahnen umfasst.


-- Create buffers around major roads
SELECT 
    osm_id,
    ST_TRANSFORM(ST_Buffer(p.way::geometry, 1000), 4326) AS buffer_geom
FROM public.planet_osm_roads AS p
WHERE
    -- highway IN ('motorway', 'trunk', 'primary')
    highway IN ('motorway');

-- Create buffers around major roads and combine these buffers to one single buffer
SELECT 
    1 as group_id,
    ST_TRANSFORM(ST_UNION(ST_Buffer(p.way::geometry, 1000)), 4326) AS combined_buffer_geom
FROM public.planet_osm_roads AS p
WHERE
    --highway IN ('motorway', 'trunk', 'primary')
    highway IN ('motorway');