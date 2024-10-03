WITH user_casts AS (
    SELECT 
        fid,
        hash,
        parent_hash,
        created_at
    FROM dune.neynar.dataset_farcaster_casts
    WHERE fid = (SELECT fid FROM dune.neynar.dataset_farcaster_fnames WHERE fname = '{{user_input_fname}}' LIMIT 1)
    -- TODO: ignore automated messages like microsub.
),
thread_roots AS (
    -- max reply depth hardcoded to 3
    SELECT 
        uc.hash,
        uc.parent_hash,
        COALESCE(c1.parent_hash, 
                 c2.parent_hash, 
                 uc.parent_hash, 
                 uc.hash) AS root_hash
    FROM user_casts uc
    LEFT JOIN dune.neynar.dataset_farcaster_casts c1 ON uc.parent_hash = c1.hash
    LEFT JOIN dune.neynar.dataset_farcaster_casts c2 ON c1.parent_hash = c2.hash
),
user_replies_per_thread AS (
    SELECT 
        tr.root_hash,
        COUNT(*) AS user_reply_count
    FROM thread_roots tr
    GROUP BY tr.root_hash
),
ranked_threads AS (
    SELECT 
        root_hash,
        user_reply_count,
        ROW_NUMBER() OVER (ORDER BY user_reply_count DESC) AS rank
    FROM user_replies_per_thread
)
SELECT 
    rt.user_reply_count AS max_replies,
    rt.root_hash,
    rc.fid AS root_cast_fid,
    f.fname AS root_cast_fname
FROM ranked_threads rt
JOIN dune.neynar.dataset_farcaster_casts rc ON rc.hash = rt.root_hash
JOIN dune.neynar.dataset_farcaster_fnames f ON rc.fid = f.fid
WHERE rt.rank = 1
LIMIT 1;