use Project

-- Selecting the whole table
select * from info
select * from finance
select * from review
select * from traffic
select * from brands

-- Counting the missing values
SELECT count(*) as total_rows,
    count(f.listing_price) as count_listing_price,
    count(t.last_visited) as count_last_visited
FROM info i 
JOIN finance f
ON i.product_id = f.product_id 
JOIN traffic t
ON i.product_id = t.product_id;

-- Top 10 best performing products(on basis of revenue) available. 
select top 10 i.product_name, f.revenue, f.sale_price, f.discount, r.rating
from finance f
join info i on f.product_id=i.product_id
join review r on f.product_id=r.product_id
order by f.revenue desc;

-- Brand Level Comparative Analysis for Revenue, Discounts, and Ratings
SELECT 
	b.brand,
	ROUND(avg(f.revenue),2) as avg_revenue,
	round(avg(f.discount),2) as avg_discount,
	round(avg(r.rating),2) as avg_rating
FROM finance f
JOIN brands b on f.product_id=b.product_id
JOIN review r on f.product_id=r.product_id
GROUP BY b.brand
HAVING brand is not null
ORDER BY avg_revenue DESC;

-- Trying to Establish if there exists a relationship begtween Discount and Revenue
SELECT
	ROUND(f.discount,1) as discount_level,
	ROUND(avg(revenue),2) as avg_revenue
FROM finance f
GROUP BY ROUND(f.discount,1)
HAVING ROUND(f.discount,1) is not null
ORDER BY discount_level

--Relationship Between Discounts and Products Sold
SELECT 
	round(discount,2) as discount_level,
	SUM(CAST(revenue/NULLIF(sale_price,0) as INT)) as total_units_sold
FROM finance
GROUP BY ROUND(discount,2)
HAVING ROUND(discount,2) is not null
ORDER BY discount_level

-- Price Comparison Across Brands
SELECT b.brand, 
	CAST(f.listing_price as INT) as price,
	count(*) as product_count
FROM brands b
JOIN finance f on b.product_id=f.product_id
WHERE f.listing_price>0
GROUP BY b.brand, CAST(f.listing_price as INT)
ORDER by price desc;

-- Revenue & Sales Volume Impact for Each Category 
SELECT 
    b.brand,
    COUNT(*) AS total_products,
    SUM(f.revenue) AS total_revenue,
    SUM(CAST(f.revenue / NULLIF(f.sale_price, 0) AS INT)) AS total_units_sold,
    CASE
        WHEN f.listing_price < 42 THEN 'Budget'
        WHEN f.listing_price BETWEEN 42 AND 74 THEN 'Average'
        WHEN f.listing_price BETWEEN 74 AND 129 THEN 'Expensive'
        ELSE 'Elite'
    END AS price_category
FROM brands b
JOIN finance f ON b.product_id = f.product_id
GROUP BY b.brand, 
         CASE
             WHEN f.listing_price < 42 THEN 'Budget'
             WHEN f.listing_price BETWEEN 42 AND 74 THEN 'Average'
             WHEN f.listing_price BETWEEN 74 AND 129 THEN 'Expensive'
             ELSE 'Elite'
         END
HAVING SUM(f.revenue)>0
ORDER BY b.brand ASC , price_category DESC;

--Reviews and Month distribution for both the brands
SELECT b.brand,
	MONTH(t.last_visited) as review_month,
	COUNT(r.rating) as monthly_reviews
FROM traffic t
JOIN brands b on t.product_id=b.product_id
JOIN review r on t.product_id=r.product_id
GROUP by b.brand, MONTH(t.last_visited)
HAVING brand is not null and MONTH(t.last_visited) is not null
ORDER by b.brand,review_month
