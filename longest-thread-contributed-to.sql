WITH RECURSIVE thread_hierarchy(hash, parent_hash, depth) AS (
  SELECT
    hash,
    parent_hash,
    1 AS depth
  FROM dune.neynar.dataset_farcaster_casts
  WHERE
    parent_hash IS NULL
    AND created_at > (current_date - INTERVAL '1' MONTH)

  UNION ALL

  SELECT
    m.hash,
    m.parent_hash,
    th.depth + 1
  FROM 
    dune.neynar.dataset_farcaster_casts AS m
  JOIN thread_hierarchy AS th
    ON m.parent_hash = th.hash
  WHERE
    m.fid = (SELECT fid FROM dune.neynar.dataset_farcaster_fnames WHERE fname = '{{user_input_fname}}' LIMIT 1) AND 
    created_at > (current_date - INTERVAL '1' MONTH)
)
SELECT
  MAX(depth) AS thread_length
FROM thread_hierarchy
ORDER BY
  thread_length DESC
LIMIT 1