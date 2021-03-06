\echo -- q1
SELECT *
FROM vrp_vroomJobs(
  $jobs$
    SELECT * FROM (
      VALUES (1414, 5), (1515, 10)
    ) AS C(id, location_index)
  $jobs$,
  $vehicles$
    SELECT * FROM (
      VALUES (500, 1, 30)
    ) AS C(id, start_index, end_index)
  $vehicles$,
  $matrix$
    SELECT * FROM (
      VALUES (1, 5, 2104), (1, 10, 197), (1, 30, 1299),
             (5, 1, 2103), (5, 10, 2255), (5, 30, 3152),
             (10, 1, 197), (10, 5, 2256), (10, 30, 1102),
             (30, 1, 1299), (30, 5, 3153), (30, 10, 1102)
    ) AS C(start_vid, end_vid, agg_cost)
  $matrix$
);
\echo -- q2
