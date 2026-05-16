-- al database
CREATE DATABASE RestaurantDB;
USE RestaurantDB;

-- da table el modon (cities)
create table cities (
    city_id int auto_increment primary key,
    city_name varchar(100) not null
);  

-- da by5azen anwa3 el akl (meal_types)
create table meal_types (
    meal_type_id int auto_increment primary key,
    meal_type varchar(100) not null
);

-- table by7aded no3 el restaurant (restaurant_type)
create table restaurant_types (
    restaurant_type_id int auto_increment primary key,
    restaurant_type varchar(100) not null
);

-- table bu3aber 3an no3 el serving (serve_types)
create table serve_types (
    serve_type_id int auto_increment primary key,
    serve_type varchar(100) not null
);

-- da table feh el customer data (Members)
create table members (
    member_id int auto_increment primary key,
    first_name varchar(100),
    last_name varchar(100),
    gender char(1),
    city_id int,
    monthly_budget decimal(10,2),
    
    -- da link ben el member w city
    foreign key (city_id) references cities(city_id)
);

-- da table feh kol el restaurants
create table restaurants (
    restaurant_id int auto_increment primary key,
    restaurant_name varchar(100),
    city_id int,
    restaurant_type_id int,
    
    -- dah el relation ben el tables
    foreign key (city_id) references cities(city_id),
    foreign key (restaurant_type_id) references 
    restaurant_types(restaurant_type_id)
);

-- dah table feh tfasel el meals
create table meals (
    meal_id int auto_increment primary key,
    meal_name varchar(100),
    meal_type_id int,
    serve_type_id int,
    price decimal(10,2),
    
    -- el relation ben el tabels
    foreign key (meal_type_id) references meal_types(meal_type_id),
    foreign key (serve_type_id) references serve_types(serve_type_id)
);

-- da table feh kol el orders 
create table orders (
    order_id int auto_increment primary key,
    member_id int,
    restaurant_id int,
    order_date datetime,
    total decimal(10,2),
    
    -- el relation ben el tabels
    foreign key (member_id) references members(member_id),
    foreign key (restaurant_id) references restaurants(restaurant_id)
);

-- dah table byrpot kol elorders bl meals eli gwaha(orders_details)
create table order_details (
    order_detail_id int auto_increment primary key,
    order_id int,
    meal_id int,
    quantity int,
    
    -- el relation ben el tables
    foreign key (order_id) references orders(order_id),
    foreign key (meal_id) references meals(meal_id)
);

-- da by7seb kol member saraf kam w talab kam fel shahr
create table monthly_member_totals (
    id int auto_increment primary key,
    member_id int,
    total_orders int,
    total_spending decimal(10,2),
    month date,

    -- relation ben el table
    foreign key (member_id) references members(member_id)
);

create table monthly_member_totals_temp (
    member_id int,
    first_name varchar(100),
    surname varchar(100),
    sex char(1),
    email varchar(100),
    city varchar(100),
    year int,
    month int,
    order_count int,
    meals_count int,
    monthly_budget decimal(10,2),
    total_expense decimal(10,2),
    balance decimal(10,2),
    commission decimal(10,2)
);

insert into monthly_member_totals (member_id, total_orders, total_spending, month)
select 
    member_id,
    order_count,
    total_expense,
    str_to_date(concat(year,'-',month,'-01'), '%Y-%m-%d')
from monthly_member_totals_temp;

drop table monthly_member_totals_temp;

-- 1- bygeb total spending kol member ma3a el personal details bta3o 
select 
    m.member_id, m.first_name, m.last_name,
    c.city_name,mt.total_orders,mt.total_spending,
    mt.month
from members m
left join cities c 
    on m.city_id = c.city_id
left join monthly_member_totals mt 
    on m.member_id = mt.member_id;
    
-- 2-by3mel count lel members 7asab el gender
select 
    gender,
    count(member_id) as members_count
from members
group by gender;

-- 3- bygeb el total spending kol member ma3a el info bta3o
select 
    m.member_id,m.first_name,m.last_name,
    m.gender,m.monthly_budget,
    mt.total_spending,mt.total_orders,mt.month
from members m
join monthly_member_totals mt on m.member_id = mt.member_id;

-- 4- bygeb kol meals elly no3ha cheese we serve_type main
select 
    m.meal_id,m.meal_name,
    mt.meal_type,st.serve_type,m.price
from meals m
join meal_types mt on m.meal_type_id = mt.meal_type_id
join serve_types st on m.serve_type_id = st.serve_type_id
where mt.meal_type = 'cheese' and st.serve_type = 'main';

-- 5- bygeb kol members elly 3ayseen fe el madinat dol
select 
    m.member_id,m.first_name,m.last_name,c.city_name
from members m
join cities c on m.city_id = c.city_id
where c.city_name in ('Givatayim', 'Ramat Hasharon');

-- 6- bygeb kol members elly lastname beyebda b 'C'
select 
    member_id,first_name,last_name,gender,
    monthly_budget,city_id
from members
where last_name like 'C%';

-- 7- bygeb kol meals elly serve_type starter aw dessert
select 
    m.meal_id,m.meal_name,mt.meal_type,
    st.serve_type,m.price
from meals m
join meal_types mt on m.meal_type_id = mt.meal_type_id
join serve_types st on m.serve_type_id = st.serve_type_id
where st.serve_type in ('starter', 'dessert');

-- 8- by3mel count lel orders kol sa3a we yeratibhom descending
select 
    hour(order_date) as order_hour,
    count(order_id) as orders_count
from orders
group by hour(order_date)
order by orders_count desc;

-- 9- bygeb awel kam 7arf men kol serve_type we y7otaha fe column gdeda
select 
    serve_type,
    substring(serve_type, 1, 3) as shortservetype
from serve_types
order by serve_type asc;

-- 10- bygeb el total_orders el unique lel members we yeratibhom descending
select 
    mt.member_id,m.first_name,
    m.last_name,mt.total_orders
from (
    select distinct member_id, total_orders
    from monthly_member_totals
) mt
join members m on mt.member_id = m.member_id
order by mt.total_orders desc;

-- 11- bygeb kol orders fe el period di ma3a el member details
select 
    o.order_id,o.order_date,
    o.member_id,m.first_name,
    m.last_name,m.gender,m.city_id
from orders o
join members m on o.member_id = m.member_id
where o.order_date between '2020-04-01' and '2020-07-01'
order by o.order_date;













