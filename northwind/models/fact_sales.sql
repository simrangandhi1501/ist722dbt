with stg_orders as (
    select
        OrderID,
        {{ dbt_utils.generate_surrogate_key(['CustomerID']) }} as customerkey,
        {{ dbt_utils.generate_surrogate_key(['EmployeeID']) }} as employeekey,
        replace(to_date(OrderDate)::varchar, '-', '')::int as datekey
    from {{ source('northwind', 'Orders') }}
),

stg_order_details as (
    select
        OrderID,
        {{ dbt_utils.generate_surrogate_key(['ProductID']) }} as productkey,
        UnitPrice,
        Quantity,
        Discount,
        (Quantity * UnitPrice) as costprice,
        (Quantity * UnitPrice * Discount) as discountamount,  -- ✅ renamed
        (Quantity * UnitPrice) - (Quantity * UnitPrice * Discount) as sellingprice
    from {{ source('northwind', 'Order_Details') }}
)

select
    o.OrderID,
    o.customerkey,
    o.employeekey,
    o.datekey,
    d.productkey,
    d.UnitPrice,
    d.Quantity,
    d.costprice,
    d.discountamount,  -- ✅ updated to match alias
    d.sellingprice
from stg_orders o
join stg_order_details d on o.OrderID = d.OrderID
