



select
    1
from "RetailDB"."bronze"."int_transaction_financial"

where not(quantity_ordered quantity_ordered >= 1 and quantity_ordered <= 30)

