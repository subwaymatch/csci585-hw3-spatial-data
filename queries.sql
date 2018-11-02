/* =====================================
	Creating table and inserting values
========================================*/
/* Create coordinates table */
CREATE TABLE coordinates
(
	id serial NOT NULL,
	name character varying(100),
	lat numeric,
	lon numeric
);

/* Insert the 9 locations with lat, lng values */
INSERT INTO coordinates(name, lat, lng) VALUES ('Apartment', 34.052222, -118.301944);
INSERT INTO coordinates(name, lat, lng) VALUES ('Young King Restaurant', 34.0525, -118.303056);
INSERT INTO coordinates(name, lat, lng) VALUES ('Yeop Dduk', 34.0525, -118.304167);
INSERT INTO coordinates(name, lat, lng) VALUES ('Hite Lounge', 34.053056, -118.30375);
INSERT INTO coordinates(name, lat, lng) VALUES ('Homeshopping World', 34.052778, -118.301944);
INSERT INTO coordinates(name, lat, lng) VALUES ('SleepEZ', 34.053139, -118.301611);
INSERT INTO coordinates(name, lat, lng) VALUES ('Papas Chicken', 34.052778, -118.300556);
INSERT INTO coordinates(name, lat, lng) VALUES ('Chase Bank', 34.052222, -118.299722);
INSERT INTO coordinates(name, lat, lng) VALUES ('Guelaguetza Restaurant', 34.052222, -118.300833);

/* Create a geometry type column */
ALTER TABLE coordinates ADD COLUMN geom geometry(POINT, 4326);

/* Derive geometry values (in WGS84/SRID4326 format) from lat, lng values */
/* Note that this command should be run after "INSERT INTO" commands */
UPDATE coordinates SET geom = ST_SetSRID(ST_MakePoint(lat, lng), 4326);


/* =====================================
	Find Convex Hull Coordinates
========================================*/
SELECT ST_AsText(ST_ConvexHull(ST_Collect(geom)))
FROM coordinates;


/* =====================================
	Find 3 Nearest Neighbors
========================================*/
SELECT c2.name as name, c1.lat as originLat, c1.lng as originLng, c2.lat as destLat, c2.lng as destLng, ST_DISTANCE(c1.geom, c2.geom) as distance
FROM coordinates c1
JOIN coordinates c2 on c1.id != c2.id
WHERE c1.name = 'Apartment'
ORDER BY distance
LIMIT 3;