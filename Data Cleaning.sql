--Data Cleaning

SELECT * 
FROM
dbo.NashvilleHousing;

--Standardizing the Date format

SELECT SaleDate, CONVERT(date,SaleDate)
FROM
dbo.NashvilleHousing;



ALTER TABLE NashvilleHousing
add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(date,SaleDate)

SELECT SaleDateConverted
FROM
dbo.NashvilleHousing;


--Populating the Property Address Data which has NULL values

SELECT PropertyAddress
FROM
dbo.NashvilleHousing
WHERE PropertyAddress is null;

SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) as PropertyAddressUpdated
FROM
dbo.NashvilleHousing a JOIN dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null;

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM
dbo.NashvilleHousing a JOIN dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null;

--Breaking Property Adrress Column into seperate columns(Address & City)

SELECT PropertyAddress
FROM
dbo.NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as city
FROM
dbo.NashvilleHousing;

ALTER TABLE NashvilleHousing
add Upd_Address NVARCHAR(255);

Update NashvilleHousing
SET Upd_Address= SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1);

ALTER TABLE NashvilleHousing
add Upd_city NVARCHAR(255);

Update NashvilleHousing
SET Upd_city = SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

-- --Breaking Property Adrress Column into seperate columns(Address, City & State)

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From
dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
add Upd_owner_Address NVARCHAR(255);

Update NashvilleHousing
SET Upd_owner_Address = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE NashvilleHousing
add Upd_owner_city NVARCHAR(255);

Update NashvilleHousing
SET Upd_owner_city = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE NashvilleHousing
add Upd_owner_state NVARCHAR(255);

Update NashvilleHousing
SET Upd_owner_state = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant)
From dbo.NashvilleHousing;


Select SoldAsVacant,
	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
		 else SoldAsVacant
	END
From dbo.NashvilleHousing;


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

--Removing Duplicate Values

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From PortfolioProject.dbo.NashvilleHousing


-- Deleting Modified Columns




ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate







