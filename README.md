# 8_Week_SQL_Challenge
This is an SQL Challenge by Data with Danny. The challenge is expected to help in dedicating myself to learning SQL.
Through this challenge, I was able to learn the use of CTE and joining tables.

![image](https://user-images.githubusercontent.com/41574873/162968569-9b83451e-e7ba-4e19-90d3-83dbd7fb689d.png =250x250)

#**Introduction**

Danny seriously loves Japanese food so in the beginning of 2021, he decides to embark upon a risky venture and opens up a cute little restaurant that sells his 3 favourite foods: sushi, curry and ramen.

Danny’s Diner is in need of your assistance to help the restaurant stay afloat - the restaurant has captured some very basic data from their few months of operation but have no idea how to use their data to help them run the business.


#Problem Statement

Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite. Having this deeper connection with his customers will help him deliver a better and more personalised experience for his loyal customers.

He plans on using these insights to help him decide whether he should expand the existing customer loyalty program - additionally he needs help to generate some basic datasets so his team can easily inspect the data without needing to use SQL.

Danny has provided you with a sample of his overall customer data due to privacy issues - but he hopes that these examples are enough for you to write fully functioning SQL queries to help him answer his questions!

Danny has shared with you 3 key datasets for this case study:
* *sales*
* *menu*
* *members*

#Entity Relationship Diagram
You can inspect the entity relationship diagram and example data below.

![image](https://user-images.githubusercontent.com/41574873/162980863-968f1ba2-0f1a-4112-a651-9fe51d5eaf37.png  =250x250)


##Example Datasets
All datasets exist within the *dannys_diner* database schema - be sure to include this reference within your SQL scripts as you start exploring the data and answering the case study questions.

##Table 1: sales
The *sales* table captures all *customer_id* level purchases with an corresponding *order_date* and *product_id* information for when and what menu items were ordered.

![image](https://user-images.githubusercontent.com/41574873/162981297-b736fe6a-c676-45ba-befb-17eaf2cc2355.png =250x250)


Table 2: menu
The menu table maps the product_id to the actual product_name and price of each menu item.

product_id	product_name	price
1	sushi	10
2	curry	15
3	ramen	12
Table 3: members
The final members table captures the join_date when a customer_id joined the beta version of the Danny’s Diner loyalty program.

customer_id	join_date
A	2021-01-07
B	2021-01-09
Interactive SQL Session
You can use the embedded DB Fiddle below to easily access these example datasets - this interactive session has everything you need to start solving these questions using SQL.

You can click on the Edit on DB Fiddle link on the top right hand corner of the embedded session below and it will take you to a fully functional SQL editor where you can write your own queries to analyse the data.

You can feel free to choose any SQL dialect you’d like to use, the existing Fiddle is using PostgreSQL 13 as default.

Serious SQL students have access to a dedicated SQL script in the 8 Week SQL Challenge section of the course which they can use to generate relevant temporary tables like we’ve done throughout the entire course!


Case Study Questions
Each of the following case study questions can be answered using a single SQL statement:

What is the total amount each customer spent at the restaurant?
How many days has each customer visited the restaurant?
What was the first item from the menu purchased by each customer?
What is the most purchased item on the menu and how many times was it purchased by all customers?
Which item was the most popular for each customer?
Which item was purchased first by the customer after they became a member?
Which item was purchased just before the customer became a member?
What is the total items and amount spent for each member before they became a member?
If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
