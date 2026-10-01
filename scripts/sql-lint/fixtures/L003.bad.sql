SELECT CASE WHEN utm LIKE '%brand%' THEN 'Brand' ELSE 'Other' END AS grp FROM sessions
