# Creating User Asset Table

> Creating a table having relation with assets. Allocating user asset on basis of some rules
> 
- Allocate laptop to each employee on basis of the grade level and department like higher grade level better latop and developer laptop to certain departments on basis of latop cost
- Also allocate rest of the assets to users
- Wireless headset to only above grade level 6
- For asset allocation use request number to allocate (should be 10 digit with REQ followed by digits it should be unique for one user and in one request multiple assets can be raised.
- It should take different row in product_name column even if the request_id is same
- serial number will only be for laptop and wireless headset

> Column should be
> 
- product_id
- staff_id
- product_name
- req_id
- issued_date
- asset_collection_status
- product_cost
- cost_center
- serial_number

[user_asset_allocation.csv](attachment:1b16c980-ab78-44f6-bc85-5fd79286f1fd:user_asset_allocation.csv)
