select
  {{ dbt_utils.generate_surrogate_key(['ProductID']) }} as productkey,
  ProductID,
  ProductName,
  SupplierID,
  CategoryID
from {{ source('northwind', 'Products') }}
