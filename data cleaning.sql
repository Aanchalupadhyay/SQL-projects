

--cleaning data in sql queries
select * from [dbo].['Nashville Housing Data for Data$']
--standardise date format
select SaleDateConverted,CONVERT(	Date,SaleDate)
from [dbo].['Nashville Housing Data for Data$']


update ['Nashville Housing Data for Data$']
SET SaleDate = CONVERT(Date,SaleDate)


ALTER TABLE ['Nashville Housing Data for Data$']
Add SaleDateConverted Date;



update ['Nashville Housing Data for Data$']
SET SaleDateConverted = CONVERT(Date,SaleDate)


--Populate Property Addressdata

select*
from.['Nashville Housing Data for Data$']
where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress ,ISNULL (a.PropertyAddress , b.PropertyAddress)
From ['Nashville Housing Data for Data$'] a
JOIN ['Nashville Housing Data for Data$'] b 
on  a.ParcelID = b.ParcelID
AND a.[UniqueID ] = B.[UniqueID ]
WHERE a.PropertyAddress is null

Update a
SET PropertyAddress=ISNULL (a.PropertyAddress , b.PropertyAddress)
From ['Nashville Housing Data for Data$'] a
JOIN ['Nashville Housing Data for Data$'] b 
on  a.ParcelID = b.ParcelID
AND a.[UniqueID ] = B.[UniqueID ]
WHERE a.PropertyAddress is null

--Breaking out Address into Individual columns (Address, City, States)

select PropertyAddress
from.['Nashville Housing Data for Data$']
--where PropertyAddress is   null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1,LEN(PropertyAddress)) as Address 
from.['Nashville Housing Data for Data$']



ALTER TABLE ['Nashville Housing Data for Data$']
Add PropertySplitAddress Nvarchar(255);


update ['Nashville Housing Data for Data$']
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1) 


ALTER TABLE ['Nashville Housing Data for Data$']
Add PropertySplitCity Nvarchar(255);


update ['Nashville Housing Data for Data$']
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))
select * 
from [dbo].['Nashville Housing Data for Data$']


select OwnerAddress
from [dbo].['Nashville Housing Data for Data$']


Select
PARSENAME(REPLACE(OwnerAddress,',','.'), 3)
,PARSENAME(REPLACE(OwnerAddress,',','.'), 2)
,PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
from [dbo].['Nashville Housing Data for Data$']


ALTER TABLE ['Nashville Housing Data for Data$']
Add OwnerSplitAddress Nvarchar(255);


update ['Nashville Housing Data for Data$']
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

ALTER TABLE ['Nashville Housing Data for Data$']
Add OwnerSplitCity Nvarchar(255);


update ['Nashville Housing Data for Data$']
SET OwnerSplitCity=PARSENAME(REPLACE(OwnerAddress,',','.'), 2) 



ALTER TABLE ['Nashville Housing Data for Data$']
Add OwnerSplitState Nvarchar(255);


update ['Nashville Housing Data for Data$']
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)

select * 
from [dbo].['Nashville Housing Data for Data$']

--Change and N  and NO in "Sold as Vacant" field 

Select Distinct(SoldAsVacant), count(SoldAsvacant)
From ['Nashville Housing Data for Data$']
Group by SoldAsVacant
order by 2

Select SoldAsVacant
,CASE When SoldAsVacant = 'Y' THEN 'Yes'
      When SoldAsVacant = 'N' THEN 'No'
	  Else SoldAsVacant
	  END
From ['Nashville Housing Data for Data$']

update ['Nashville Housing Data for Data$']
SET SoldAsVacant=CASE When SoldAsVacant = 'Y' THEN 'Yes'
      When SoldAsVacant = 'N' THEN 'No'
	  Else SoldAsVacant
	  END
	  
	--Remove Duplicates
WITH RowNumCTE AS(
select *,
      ROW_NUMBER()OVER (
	  PARTITION BY ParcelID,
	               PropertyAddress,
				   SalePrice,
				   SaleDate,
				   LegalReference
				   ORDER BY 
				    UniqueID 
				   ) row_num
	  From ['Nashville Housing Data for Data$']
	  --order by ParcelID
	  )
	  select*
	  From RowNumCTE 
	  Where  row_num>1
	 Order by PropertyAddress

	 --Delete unsued columns

	  Select*
	  From ['Nashville Housing Data for Data$']

	  ALTER TABLE ['Nashville Housing Data for Data$']
      DROP COLUMN OwnerAddress , Taxdistrict , PropertyAddress

      ALTER TABLE ['Nashville Housing Data for Data$']
      DROP COLUMN SaleDate

