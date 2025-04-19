with f_sales as (
    select * from {{ ref('fact_sales') }}
),

d_customer as (
    select * from {{ ref('dim_customer') }}
),

d_employee as (
    select * from {{ ref('dim_employee') }}
),

d_date as (
    select * from {{ ref('dim_date') }}
),

d_product as (
    select * from {{ ref('dim_product') }}
)

select
    d_customer.*,
    d_employee.*,
    d_date.*,
    d_product.*,
    f.orderid,
    -- f.datekey,         -- Already in d_date.*
    -- f.productkey,      -- ❌ Remove this line
    f.unitprice,
    f.quantity,
    f.costprice,
    f.discountamount,
    f.sellingprice
from f_sales f
left join d_customer on f.customerkey = d_customer.customerkey
left join d_employee on f.employeekey = d_employee.employeekey
left join d_date on f.datekey = d_date.datekey
left join d_product on f.productkey = d_product.productkey
