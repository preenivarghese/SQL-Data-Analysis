--Selecting all the rows from imported dataset
select * from nashville_housing_data

--Standardised data format
select saledate from nashville_housing_data;
alter table nashville_housing_data add column saledate_updated date
update nashville_housing_data set saledate_updated = cast(saledate as date)

--Populate missing Property Address data
select a.propertyaddress, a.parcelid, b.propertyaddress, b.parcelid
from nashville_housing_data a, nashville_housing_data b
where a.parcelid = b.parcelid
and a.uniqueid <> b.uniqueid
and a.propertyaddress isnull

drop view propertyaddress_view

create view propertyaddress_view as select b.propertyaddress,b.parcelid
from nashville_housing_data a, nashville_housing_data b
where a.parcelid = b.parcelid
and a.uniqueid <> b.uniqueid
and a.propertyaddress isnull 

select * from propertyaddress_view

UPDATE nashville_housing_data
SET propertyaddress = propertyaddress_view.propertyaddress
FROM propertyaddress_view
WHERE nashville_housing_data.parcelid = propertyaddress_view.parcelid;

--Breaking out property address column nto individual columns (Address, City)
select propertyaddress from nashville_housing_data;

select substring(propertyaddress,1,strpos(propertyaddress,',')-1),
substring(propertyaddress,strpos(propertyaddress,',')+1,length(propertyaddress))
from nashville_housing_data;

select * from nashville_housing_data;
alter table nashville_housing_data add column PropertySplitAddress character varying
alter table nashville_housing_data add column PropertySplitCity character varying
update nashville_housing_data set PropertySplitAddress = substring(propertyaddress,1,strpos(propertyaddress,',')-1)
update nashville_housing_data set PropertySplitCity = substring(propertyaddress,strpos(propertyaddress,',')+1,length(propertyaddress))

--Breaking out owner address column nto individual columns (Address, City, State)
select split_part(owneraddress,',',1),split_part(owneraddress,',',2),split_part(owneraddress,',',3) from nashville_housing_data;
select * from nashville_housing_data;
alter table nashville_housing_data add column OwnerSplitAddress character varying
alter table nashville_housing_data add column OwnerSplitCity character varying
alter table nashville_housing_data add column OwnerSplitState character varying
update nashville_housing_data set OwnerSplitAddress = split_part(owneraddress,',',1)
update nashville_housing_data set OwnerSplitCity = split_part(owneraddress,',',2)
update nashville_housing_data set OwnerSplitState = split_part(owneraddress,',',3)

--Updating SoldAsVacant coloumn to have only Yes/No values.
select distinct(soldasvacant) from nashville_housing_data

select soldasvacant, case when soldasvacant = 'Y' then 'Yes'
                          when soldasvacant = 'N' then 'No'
		          else soldasvacant
			  end
from nashville_housing_data

select distinct(soldasvacant), count(soldasvacant) 
from nashville_housing_data
group by soldasvacant
order by 2

update nashville_housing_data set soldasvacant = case when soldasvacant = 'Y' then 'Yes'
                                                      when soldasvacant = 'N' then 'No'
				                      else soldasvacant
						      end

--Deleting Duplicates
select * from nashville_housing_data

with rownumcte as(
select *,row_number() over (
partition by parcelid,propertyaddress,saleprice,saledate,legalreference
order by uniqueid) rownum
from nashville_housing_data
)
select * from rownumcte
where rownum>1
order by propertyaddress

--delete query for removing duplicates which have rownum > 1
with rownumcte as(select rownum,uniqueid from
(select *,row_number() over (
partition by parcelid,propertyaddress,saleprice,saledate,legalreference
order by uniqueid) rownum
from nashville_housing_data
) alias1
where rownum>1)
delete from nashville_housing_data where uniqueid in (select uniqueid from rownumcte) 


--Deleting unused columns to clean up finala data
select * from nashville_housing_data

alter table nashville_housing_data drop column owneraddress, drop column propertyaddress, drop column saledate, dropcolumn taxdistrict

