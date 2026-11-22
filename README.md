# Restaurant Database Management System

A relational database in MySQL for restaurant operations and customer orders, with SQL queries that report on member spending, order activity, and the meal menu.

<img width="1201" height="445" alt="Screenshot 2026-04-26 015547" src="https://github.com/user-attachments/assets/0a6aca9e-5640-401a-802f-f8f0fee4d9e1" />
<img width="1062" height="442" alt="Screenshot 2026-04-26 015513" src="https://github.com/user-attachments/assets/9c67c32a-b776-4d8e-9b89-250001ebce13" />
<img width="1121" height="585" alt="Screenshot 2026-04-26 015712" src="https://github.com/user-attachments/assets/ab9b6868-376a-4f08-9453-36be55f39e4d" />
<img width="1310" height="617" alt="Screenshot 2026-04-26 015631" src="https://github.com/user-attachments/assets/f55991f2-c0a1-4086-884b-d011003987e8" />
<img width="937" height="467" alt="Screenshot 2026-04-26 015330" src="https://github.com/user-attachments/assets/7f2db404-7e66-415c-a317-d01be6439361" />
<img width="988" height="551" alt="Screenshot 2026-04-26 015249" src="https://github.com/user-attachments/assets/5e59cee7-11f7-47a9-9385-a0d0bda72c4f" />
<img width="978" height="510" alt="Screenshot 2026-04-26 015440" src="https://github.com/user-attachments/assets/1eb00631-a07f-42e8-a3bd-dd0f81d40486" />
<img width="897" height="428" alt="Screenshot 2026-04-26 015406" src="https://github.com/user-attachments/assets/c957cb1d-94d6-4744-9e0b-e3dab77a136e" />

## Project Overview

The database stores members (customers), restaurants, meals, and the orders placed, and keeps a monthly spending summary for every member. I designed the schema, linked the tables with primary and foreign keys, loaded the monthly summary through a staging table, and wrote SQL queries to answer business questions.

## Database Schema

The database `RestaurantDB` contains 10 tables:

| Table | Purpose |
|---|---|
| `cities` | Lookup table of cities |
| `meal_types` | Lookup table of meal categories |
| `restaurant_types` | Lookup table of restaurant types |
| `serve_types` | Lookup table of serving types (starter, main, dessert, ...) |
| `members` | Customer details: name, gender, city, monthly budget |
| `restaurants` | Restaurants with their city and type |
| `meals` | Menu items with meal type, serve type, and price |
| `orders` | Orders placed by members at restaurants, with date and total |
| `order_details` | The meals and quantities inside each order |
| `monthly_member_totals` | Total orders and total spending per member per month |

Design choices:

- **Normalization:** repeated values such as city, meal type, restaurant type, and serve type are stored in lookup tables and referenced by foreign keys, which avoids duplicated text and inconsistent values.
- **Relationships:** every relationship is enforced with a foreign key (for example `orders.member_id` references `members.member_id`).
- **Staging table:** monthly spending data is first loaded into `monthly_member_totals_temp`, then inserted into `monthly_member_totals` with the year and month columns converted into a date using `STR_TO_DATE`. The staging table is dropped afterward.

## Business Questions and Queries

All queries are in [`ProjectSQL.sql`](ProjectSQL.sql).

| # | Question | Techniques |
|---|---|---|
| 1 | How much does each member spend, with their city and monthly figures? | LEFT JOIN across 3 tables |
| 2 | How many members are there by gender? | GROUP BY, COUNT |
| 3 | What are the spending details of each member with their budget? | JOIN |
| 4 | Which meals are of type cheese and served as main? | JOIN across 3 tables, WHERE with AND |
| 5 | Which members live in specific cities? | JOIN, IN |
| 6 | Which members have a last name starting with C? | LIKE |
| 7 | Which meals are starters or desserts? | JOIN across 3 tables, IN |
| 8 | At which hours are most orders placed? | GROUP BY, COUNT, HOUR(), ORDER BY |
| 9 | What is a short code for each serve type? | SUBSTRING |
| 10 | Which members have the most orders? | Subquery with DISTINCT, JOIN |
| 11 | Which orders were placed in a given period, with member details? | JOIN, date range filter |

## Tools

- MySQL
- MySQL Workbench

## Skills Demonstrated

- Relational database design and normalization
- Primary keys, foreign keys, and table relationships
- Data loading with a staging table and date conversion
- SQL: JOINs, GROUP BY, aggregate functions, subqueries, filtering, and date and string functions
