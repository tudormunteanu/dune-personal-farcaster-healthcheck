WITH dates AS (
  SELECT date AS date_
  FROM unnest(sequence(date '2023-09-01', date '2023-09-30', interval '1' day)) AS t(date)
),
random_data AS (
  SELECT 
    date_,
    greatest(cast(rand() * 9 + 1 AS INTEGER), 2) AS original_casts,
    cast(rand() * 20 + 10 AS INTEGER) AS likes,
    cast(rand() * 15 + 5 AS INTEGER) AS recasts
  FROM dates
)
SELECT 
  date_,
  original_casts,
  original_casts * 5 AS replies,
  likes,
  recasts
FROM random_data
ORDER BY date_