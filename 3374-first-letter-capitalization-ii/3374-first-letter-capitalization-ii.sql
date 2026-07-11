# Write your MySQL query statement below

-- WITH RECURSIVE content_pos AS(                          -- Recurive CTE

--     SELECT content_id,                                  -- Anchor Query
--            content_text,
--            1 AS pos,
--            LOWER(content_text) AS converted_text
--     FROM user_content

--     UNION ALL

--     SELECT content_id,                                  -- Recursive query
--            content_text,
--            pos + 1,
--            (
--             CASE
--                 WHEN(
--                      pos = 1 OR SUBSTRING(converted_text, pos - 1, 1) = ' ' 
--                      AND SUBSTRING(content_text, pos, 1) REGEXP '[A-Za-z]'
--                 )
--                 THEN
--                     CONCAT(
--                         LEFT(converted_text, pos - 1),
--                         UPPER(SUBSTRING(converted_text, pos, 1)),
--                         SUBSTRING(converted_text, pos + 1)
--                     )

--                 WHEN(
--                      SUBSTRING(content_text, pos - 2, 1) REGEXP '[A-Za-z]' 
--                      AND SUBSTRING(converted_text, pos - 1, 1) = '-' 
--                      AND SUBSTRING(content_text, pos, 1) REGEXP '[A-Za-z]'
--                 )
--                 THEN
--                     CONCAT(
--                         LEFT(converted_text, pos - 1),
--                         UPPER(SUBSTRING(converted_text, pos, 1)),
--                         SUBSTRING(converted_text, pos + 1)
--                     )

--                 WHEN(
--                      SUBSTRING_INDEX(converted_text, '-', -1)
--                 )    
--                 ELSE converted_text
--             END
--            )
--     FROM content_pos
--     WHERE pos <= CHAR_LENGTH(content_text)

-- ),


-- converted_text_rank AS(                                 -- Normal CTE
--     SELECT content_id,
--            content_text AS original_text,
--            converted_text,
--            ROW_NUMBER() OVER(PARTITION BY content_id ORDER BY pos DESC) AS pos_rank
--     FROM content_pos
-- )


-- SELECT content_id,
--        original_text,
--        converted_text
-- FROM converted_text_rank
-- WHERE pos_rank =1


WITH RECURSIVE content_pos AS (

    -- Anchor Query
    SELECT
        content_id,
        content_text,
        1 AS pos,
        LOWER(content_text) AS converted_text
    FROM user_content

    UNION ALL

    -- Recursive Query
    SELECT
        content_id,
        content_text,
        pos + 1,

        CASE
            -- First letter of each word
            WHEN (
                    pos = 1
                    OR SUBSTRING(content_text, pos - 1, 1) = ' '
                 )
                 AND SUBSTRING(content_text, pos, 1) REGEXP '[A-Za-z]'

            THEN CONCAT(
                    LEFT(converted_text, pos - 1),
                    UPPER(SUBSTRING(converted_text, pos, 1)),
                    SUBSTRING(converted_text, pos + 1)
                 )

            WHEN(
                 SUBSTRING(content_text, pos - 1, 1) = '-'
                 AND SUBSTRING(content_text, pos, 1) REGEXP '[A-Za-z]'

                 AND SUBSTRING_INDEX(
                        SUBSTRING_INDEX(
                            content_text, ' ', 1 + (
                                                        CHAR_LENGTH(LEFT(content_text, pos - 1))
                                                        -
                                                        CHAR_LENGTH(
                                                            REPLACE(LEFT(content_text, pos - 1), ' ', '')
                                                        )
                                                   )
                        ),
                         ' ', -1    
                     ) REGEXP '^[A-Za-z]+(-[A-Za-z]+)+$'
                )
            THEN CONCAT(
                    LEFT(converted_text, pos - 1),
                    UPPER(SUBSTRING(converted_text, pos, 1)),
                    SUBSTRING(converted_text, pos + 1)
                 )

            ELSE converted_text
        END

    FROM content_pos
    WHERE pos <= CHAR_LENGTH(content_text)
),

converted_text_rank AS (

    SELECT
        content_id,
        content_text AS original_text,
        converted_text,

        ROW_NUMBER() OVER (
            PARTITION BY content_id
            ORDER BY pos DESC
        ) AS pos_rank

    FROM content_pos
)

SELECT
    content_id,
    original_text,
    converted_text
FROM converted_text_rank
WHERE pos_rank = 1
ORDER BY content_id;





























