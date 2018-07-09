--Q1
SELECT *
FROM survey
LIMIT 10;

--Q2
SELECT question,
   COUNT(DISTINCT user_id)
FROM survey
GROUP BY 1;

--Q4
SELECT *
FROM quiz
LIMIT 5;

SELECT *
FROM home_try_on
LIMIT 5;

SELECT *
FROM purchase
LIMIT 5;

--Q5
SELECT DISTINCT q.user_id,
       h.user_id IS NOT NULL 'is_home_try_on',
   h.number_of_pairs,
   p.user_id IS NOT NULL 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'h'
  ON q.user_id = h.user_id
LEFT JOIN purchase AS 'p'
  ON p.user_id = q.user_id
LIMIT 10;

--Q6
--subquestion 1 and 2
WITH funnels AS (SELECT DISTINCT q.user_id,
       h.user_id IS NOT NULL 'is_home_try_on',
   h.number_of_pairs,
   p.user_id IS NOT NULL 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'h'
  ON q.user_id = h.user_id
LEFT JOIN purchase AS 'p'
  ON p.user_id = q.user_id)
SELECT COUNT(*) AS 'num_quiz',
 SUM(is_home_try_on) AS 'num_home_try_on',
 SUM(is_purchase) AS 'num_purchase',
 1.0 * SUM(is_purchase) / COUNT(user_id) AS 'overall_conv_rate',
 1.0 * SUM(is_home_try_on) / COUNT(user_id) AS 'quiz_to_home_try_on',
 1.0 * SUM(is_purchase) / SUM(is_home_try_on) AS 'home_try_on_to_purchase'
FROM funnels;

--Q6
--subquestion 3
WITH funnels AS (SELECT DISTINCT q.user_id,
       h.user_id IS NOT NULL 'is_home_try_on',
   h.number_of_pairs,
   p.user_id IS NOT NULL 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'h'
  ON q.user_id = h.user_id
LEFT JOIN purchase AS 'p'
  ON p.user_id = q.user_id)
SELECT number_of_pairs,
 COUNT(*) AS 'num_quiz',
 SUM(is_home_try_on) AS 'num_home_try_on',
 SUM(is_purchase) AS 'num_purchase',
 1.0 * SUM(is_home_try_on) / COUNT(user_id) AS 'quiz_to_home_try_on',
 1.0 * SUM(is_purchase) / SUM(is_home_try_on) AS 'home_try_on_to_purchase'
FROM funnels
GROUP BY number_of_pairs
ORDER BY number_of_pairs;

--subquestion 4
-- most common answers
SELECT response,
   question,
   COUNT(DISTINCT user_id)
FROM survey
GROUP BY 1
ORDER BY 3 DESC;

--subquestion 5
-- most common purchases
  SELECT product_id,
   style,
   model_name,
   color,
   price,
   COUNT(DISTINCT user_id) AS 'tot_num_purchases'
FROM purchase
GROUP BY 1
ORDER BY 6 DESC;

--Q6 - extra questions
--most popular style
SELECT style,
   COUNT(DISTINCT user_id) AS 'tot_num_purchases'
FROM purchase
GROUP BY 1
ORDER BY 2 DESC;

--most popular model
SELECT model_name,
   style,
   COUNT(DISTINCT user_id) AS 'tot_num_purchases'
FROM purchase
GROUP BY 1
ORDER BY 3 DESC;

--most popular color
SELECT color,
   style,
   COUNT(DISTINCT user_id) AS 'tot_num_purchases'
FROM purchase
GROUP BY 1
ORDER BY 3 DESC;

 --calculate average model price of sold glasses
 SELECT AVG(price),
   COUNT(DISTINCT user_id) AS 'tot_num_purchases'
FROM purchase
ORDER BY 1 DESC;

--calculate average model price of sold glasses grouped by style
 SELECT AVG(price),
   style,
   COUNT(DISTINCT user_id) AS 'tot_num_purchases'
FROM purchase
GROUP BY 2
ORDER BY 1 DESC;
