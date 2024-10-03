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
    MyCasts AS (
        SELECT
            c.hash,
            c.parent_hash,
            c.root_parent_url,
            c.timestamp,
            -- TODO: filter out a few more edge cases.
            -- TODO: find out why some channel names have a completely different format.
            CASE
                WHEN c.root_parent_url IS NOT NULL THEN
                    CASE
                        WHEN c.root_parent_url LIKE 'https://warpcast.com/~/channel/%' THEN SUBSTRING(c.root_parent_url, LENGTH('https://warpcast.com/~/channel') + 1)
                        WHEN c.root_parent_url LIKE 'https://farcaster.group/%' THEN SUBSTRING(c.root_parent_url, LENGTH('https://farcaster.group') + 1)
                        WHEN c.root_parent_url LIKE 'chain://eip155%' THEN 'unknown'
                        ELSE c.root_parent_url
                    END
                WHEN c.parent_hash IS NOT NULL THEN
                    CASE
                        WHEN p.root_parent_url LIKE 'https://warpcast.com/~/channel/%' THEN SUBSTRING(p.root_parent_url, LENGTH('https://warpcast.com/~/channel') + 1)
                        WHEN p.root_parent_url LIKE 'https://farcaster.group/%' THEN SUBSTRING(p.root_parent_url, LENGTH('https://farcaster.group') + 1)
                        WHEN p.root_parent_url LIKE 'chain://eip155%' THEN 'unknown'
                        ELSE COALESCE(p.root_parent_url, 'no_channel')
                    END
                ELSE 'no_channel'
            END AS channel
        FROM dune.neynar.dataset_farcaster_casts c
        LEFT JOIN dune.neynar.dataset_farcaster_casts p ON c.parent_hash = p.hash
        WHERE
            c.fid = (SELECT fid FROM ResolveFnameToFid)
    ),
    MyStats AS (
        SELECT
            mc.channel,
            COUNT(*) as casts_count
        FROM
            MyCasts mc
        WHERE 
            channel NOT IN ('unknown', 'no_channel')
        GROUP BY channel
        ORDER BY casts_count DESC
        LIMIT 20
    )
SELECT x.*
FROM MyStats x
ORDER BY x.casts_count DESC