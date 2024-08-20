SELECT ROUND(
    CAST(ST_Distance(
        -- St. Gallen (longitude, latitude)
        ST_GeographyFromText('SRID=4326;POINT(9.37624, 47.42562)'),
        -- Genf (longitude, latitude)
        ST_GeographyFromText('SRID=4326;POINT(6.1466, 46.20176)')
    ) / 1000 AS NUMERIC), -- Convert meters to kilometers
    1 -- Round to two decimal places
) AS distance_in_kilometers;