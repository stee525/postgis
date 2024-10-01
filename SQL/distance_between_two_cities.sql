-- Dieser SQL-Code berechnet die Entfernung zwischen zwei geografischen Punkten in der Schweiz (St. Gallen und Genf) 
-- und gibt die Entfernung in Kilometern, gerundet auf eine Dezimalstelle, aus. 
-- Dieser SQL-Code berechnet die Entfernung zwischen den Städten St. Gallen und Genf in Kilometern, 
-- indem die geografischen Koordinaten dieser Städte verwendet werden. Die Entfernung wird in Metern berechnet, 
-- dann in Kilometer umgewandelt und auf eine Dezimalstelle gerundet. Das Ergebnis ist die Entfernung zwischen den beiden Städten in Kilometern.

SELECT ROUND(
    CAST(ST_Distance(
        -- St. Gallen (longitude, latitude)
        ST_GeographyFromText('SRID=4326;POINT(9.37624 47.42562)'),
        -- Genf (longitude, latitude)
        ST_GeographyFromText('SRID=4326;POINT(6.1466 46.20176)')
    ) / 1000 AS NUMERIC), -- Convert meters to kilometers
    1 -- Round to one decimal place
) AS distance_in_kilometers;