
    
    

select
    inventory_snapshot_sk as unique_field,
    count(*) as n_records

from "RetailDB"."bronze"."stg_inventory"
where inventory_snapshot_sk is not null
group by inventory_snapshot_sk
having count(*) > 1


