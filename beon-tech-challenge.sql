-- Question 1
WITH distinct_dest_ewr_count AS (
SELECT COUNT(DISTINCT dest) as qty
FROM `beontech.tb_flights` A
WHERE origin = "EWR"
)
-- Question 1 variation
, distinct_dest_ewr_list AS (
SELECT DISTINCT dest
FROM `beontech.tb_flights` A
WHERE origin = "EWR"
)
-- Question 2
, avg_dest_per_day AS (
  SELECT month, ROUND(AVG(qty),2) AS avg_dest FROM (
  SELECT month, day, COUNT(DISTINCT dest) AS qty
  FROM `beontech.tb_flights`
  GROUP BY 1, 2)
  GROUP BY 1
)
-- Question 7
, rank_airlines AS (
  SELECT B.name AS airline, COUNT(A.flight) AS qty_flights
  FROM `beontech.tb_flights` A
  LEFT JOIN `beontech.tb_airlines` B
  USING(carrier)
  GROUP BY 1 ORDER BY 2 DESC
)
-- Extra question
, cumulative_sum AS (
  SELECT DISTINCT DATE(year, month, day) AS date
  , SUM(dep_delay) OVER (ORDER BY DATE(year, month, day) ASC) AS cumulative_sum_delay 
  FROM `beontech.tb_flights`
)
SELECT * FROM cumulative_sum;

-- Extra question: View to use in Looker Studio
CREATE OR REPLACE VIEW beontech.vw_flight AS 
SELECT DATE(year, month, day) AS flight_date, * FROM `beontech.tb_flights`;

