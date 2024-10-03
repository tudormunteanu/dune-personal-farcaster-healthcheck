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
            DATE(created_at) as created_date,
            COUNT(*) AS total_original_casts
        FROM
            dune.neynar.dataset_farcaster_casts
        WHERE
            fid = (SELECT fid FROM ResolveFnameToFid)
            AND created_at > (current_date - INTERVAL '{{number_of_months}}' MONTH)
            AND parent_hash IS NULL
        GROUP BY
            DATE(created_at)
        ORDER BY
            DATE(created_at) DESC
    ),
    Replies AS (
        SELECT
            DATE(created_at) as created_date,
            COUNT(*) AS total_replies
        FROM
            dune.neynar.dataset_farcaster_casts
        WHERE
            fid = (SELECT fid FROM ResolveFnameToFid)
            AND created_at > (current_date - INTERVAL '{{number_of_months}}' MONTH)
            AND parent_hash IS NOT NULL
        GROUP BY
            DATE(created_at)
        ORDER BY
            DATE(created_at) DESC
    ),
    Likes AS (
        SELECT
            DATE(created_at) as created_date,
            COUNT(*) AS total_likes
        FROM
            dune.neynar.dataset_farcaster_reactions
        WHERE
            fid = (SELECT fid FROM ResolveFnameToFid)
            AND created_at > (current_date - INTERVAL '{{number_of_months}}' MONTH)
            AND reaction_type = 1
        GROUP BY
            DATE(created_at)
        ORDER BY
            DATE(created_at) DESC
    ),
    Recasts AS (
        SELECT
            DATE(created_at) as created_date,
            COUNT(*) AS total_recasts
        FROM
            dune.neynar.dataset_farcaster_reactions as re
        WHERE
            re.fid = (SELECT fid FROM ResolveFnameToFid)
            AND created_at > (current_date - INTERVAL '{{number_of_months}}' MONTH)
            AND reaction_type = 2
        GROUP BY
            DATE(created_at)
        ORDER BY
            DATE(created_at) DESC
    )    
SELECT
    COALESCE(o.created_date, r.created_date) AS created_date,
    COALESCE(o.total_original_casts, 0) AS original_casts,
    COALESCE(r.total_replies, 0) AS replies,
    COALESCE(l.total_likes, 0) AS likes,
    COALESCE(re.total_recasts, 0) AS recasts
FROM
    OriginalCasts o
FULL OUTER JOIN
    Replies r ON o.created_date = r.created_date
FULL OUTER JOIN
    Likes l ON o.created_date = l.created_date
FULL OUTER JOIN
    Recasts re ON o.created_date = re.created_date
ORDER BY
    created_date DESC