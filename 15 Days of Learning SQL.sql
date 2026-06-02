SELECT
    sub.submission_date,
    (
        SELECT COUNT(DISTINCT s2.hacker_id)
        FROM Submissions s2
        WHERE s2.submission_date = sub.submission_date
        AND (
            SELECT COUNT(DISTINCT s3.submission_date)
            FROM Submissions s3
            WHERE s3.hacker_id = s2.hacker_id
            AND s3.submission_date < sub.submission_date
            AND s3.submission_date >= '2016-03-01'
        ) = DATEDIFF(sub.submission_date, '2016-03-01')
    ) AS unique_hackers,
    (
        SELECT s4.hacker_id
        FROM Submissions s4
        WHERE s4.submission_date = sub.submission_date
        GROUP BY s4.hacker_id
        ORDER BY COUNT(s4.submission_id) DESC, s4.hacker_id ASC
        LIMIT 1
    ) AS hacker_id,
    (
        SELECT h.name
        FROM Hackers h
        WHERE h.hacker_id = (
            SELECT s4.hacker_id
            FROM Submissions s4
            WHERE s4.submission_date = sub.submission_date
            GROUP BY s4.hacker_id
            ORDER BY COUNT(s4.submission_id) DESC, s4.hacker_id ASC
            LIMIT 1
        )
    ) AS name
FROM (
    SELECT DISTINCT submission_date
    FROM Submissions
    WHERE submission_date BETWEEN '2016-03-01' AND '2016-03-15'
) sub
ORDER BY sub.submission_date;
