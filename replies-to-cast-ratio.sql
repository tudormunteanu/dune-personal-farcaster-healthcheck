WITH
    ResolveFnameToFid AS (
        SELECT
            fid
        FROM
            dune.neynar.dataset_farcaster_profile_with_addresses
        WHERE
            LOWER(fname) = LOWER('{{user_input_fname}}')
        LIMIT
            1
    ),
    OriginalCasts AS (
        SELECT
            'original_casts' AS data,
            COUNT(*) AS total_original_casts
        FROM
            dune.neynar.dataset_farcaster_casts
        WHERE
            fid = (SELECT fid FROM ResolveFnameToFid)
            AND parent_hash IS NULL
            AND created_at > (current_date - INTERVAL '1' MONTH)
    ),
    Replies AS (
        SELECT
            'replies' AS data,
            COUNT(*) AS total_replies
        FROM
            dune.neynar.dataset_farcaster_casts
        WHERE
            fid = (SELECT fid FROM ResolveFnameToFid)
            AND parent_hash IS NOT NULL
            AND created_at > (current_date - INTERVAL '1' MONTH)
    )
SELECT
    total_original_casts,
    total_replies,
    CASE
        WHEN total_replies = 0 THEN NULL
        ELSE CAST(total_replies AS DOUBLE) / CAST(total_original_casts AS DOUBLE)
    END AS replies_to_cast_ratio,
    CASE
        WHEN total_replies = 0 THEN NULL
        WHEN CAST(total_replies AS DOUBLE) / CAST(total_original_casts AS DOUBLE) < 5 THEN 'cast more'
        WHEN CAST(total_replies AS DOUBLE) / CAST(total_original_casts AS DOUBLE) = 5 THEN 'the ratio is just right'
        WHEN CAST(total_replies AS DOUBLE) / CAST(total_original_casts AS DOUBLE) > 5 THEN 'reply more'
    END AS outcome
FROM
    OriginalCasts, Replies

