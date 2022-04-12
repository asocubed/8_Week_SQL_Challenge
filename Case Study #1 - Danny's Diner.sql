CREATE TABLE sales (
  "customer_id" VARCHAR(1),
  "order_date" DATE,
  "product_id" INTEGER
);

INSERT INTO sales
  ("customer_id", "order_date", "product_id")
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

CREATE TABLE menu (
  "product_id" INTEGER,
  "product_name" VARCHAR(5),
  "price" INTEGER
);

INSERT INTO menu
  ("product_id", "product_name", "price")
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
  "customer_id" VARCHAR(1),
  "join_date" DATE
);

INSERT INTO members
  ("customer_id", "join_date")
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');

  SELECT * FROM dbo.sales;
  SELECT * FROM dbo.members;
  SELECT * FROM dbo.menu;

-- Question 1: What is the total amount each customer spent at the restaurant?
  SELECT s.customer_id, SUM(m.price) as Amount
  FROM sales s
  INNER JOIN menu m
  ON s.product_id = m.product_id
  GROUP BY s.customer_id
  ORDER BY s.customer_id;

-- Question 2: How many days has each customer visited the restaurant?
SELECT customer_id, count(distinct order_date) AS Days_Visited
FROM sales
GROUP BY customer_id
ORDER BY customer_id;

-- Question 3: What was the first item from the menu purchased by each customer?
WITH ordered_item_CTE AS
	(SELECT s.customer_id, s.order_date, m.product_name,
		DENSE_RANK() OVER (PARTITION BY s.customer_id
		ORDER BY s.order_date) AS rank
		FROM sales s
		INNER JOIN menu m
		ON s.product_id = m.product_id)
		
SELECT customer_id, product_name
FROM ordered_item_CTE
WHERE rank = 1
GROUP BY customer_id, product_name;

/* Question 4: What is the most purchased item on the menu and 
				how many times was it purchased by all customers?*/
SELECT TOP 1 m.product_name, COUNT(s.product_id) most_purchased
FROM sales s
INNER JOIN menu m
ON s.product_id = m.product_id
GROUP BY s.product_id, product_name
ORDER BY most_purchased DESC;

-- Question 5: Which item was the most popular for each customer?
WITH popular_item_cte AS 
	(SELECT s.customer_id, m.product_name, count(m.product_id) as order_count,
			DENSE_RANK() OVER (PARTITION BY s.customer_id
			ORDER BY COUNT(s.customer_id) DESC) AS rank
	FROM menu m
	INNER JOIN sales s
	ON m.product_id = s.product_id
	GROUP BY s.customer_id, m.product_name)

SELECT customer_id, product_name, order_count
FROM popular_item_cte
WHERE rank = 1;

-- Question 6: Which item was purchased first by the customer after they became a member?
WITH purchased_item_cte AS
	(SELECT s.customer_id, m.join_date, s.order_date, s.product_id,
			DENSE_RANK() OVER (PARTITION BY s.customer_id
			ORDER BY s.order_date) as rank
	FROM sales s
	INNER JOIN members m
	ON s.customer_id = m.customer_id
	WHERE s.order_date >= m.join_date)

SELECT s.customer_id, s.order_date, me.product_name
FROM purchased_item_cte s
INNER JOIN menu me
ON s.product_id = me.product_id
WHERE rank = 1;

-- Question 7: Which item was purchased just before the customer became a member?
WITH prior_member_cte AS
	(SELECT s.customer_id, m.join_date, s.order_date, s.product_id,
			DENSE_RANK() OVER (PARTITION BY s.customer_id
			ORDER BY s.order_date DESC) as rank
	FROM sales s
	INNER JOIN members m
	ON s.customer_id = m.customer_id
	WHERE s.order_date < m.join_date)

SELECT s.customer_id, s.order_date, me.product_name
FROM prior_member_cte s
INNER JOIN menu me
ON s.product_id = me.product_id
WHERE rank = 1;

-- Question 8: What is the total items and amount spent for each member before they became a member?
SELECT s.customer_id, COUNT(DISTINCT s.product_id) unique_item, SUM(me.price) amount
FROM sales s
INNER JOIN members m
ON s.customer_id = m.customer_id
INNER JOIN menu me
ON s.product_id = me.product_id
WHERE s.order_date < m.join_date
GROUP BY s.customer_id;

/* Question 9: If each $1 spent quates 10 points and sushi has a 2x points multiplier, 
				how many points would each customer have? */
WITH price_points_cte AS
	(SELECT *,
			CASE WHEN product_id = 1
			THEN price * 20
			ELSE price * 10
			END AS points
	FROM menu)

SELECT s.customer_id, SUM(p.points) total_points
FROM price_points_cte p
INNER JOIN sales s
ON p.product_id = s.product_id
GROUP BY s.customer_id;

/* Question 10: In the first week after a customer joins the program (including their join date)
				they earn 2x points on all items, not just sushi, how many points do 
				customer A and B have at the end of January? */
WITH dates AS 
(
   SELECT *, 
      DATEADD(DAY, 6, join_date) AS valid_date, 
      EOMONTH('2021-01-31') AS last_date
   FROM members)

SELECT s.customer_id, 
       SUM(
	   CASE 
	  WHEN m.product_ID = 1 THEN m.price*20
	  WHEN s.order_date BETWEEN d.join_date and d.valid_date THEN m.price*20
	  ELSE m.price*10
	  END 
	  ) AS points
FROM dates d
JOIN sales s
ON d.customer_id = s.customer_id
JOIN menu m
ON m.product_id = s.product_id
WHERE s.order_date < d.last_date
GROUP BY s.customer_id