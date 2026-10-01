SELECT CASE WHEN utm LIKE '%brand%' THEN 'Brand' WHEN utm LIKE '%promo%' THEN 'Promo' END AS grp FROM sessions
