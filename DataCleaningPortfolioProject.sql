SELECT *
FROM PortfolioProject.dbo.NashvilleHousing;

--Change the Date format
SELECT Saledate,CONVERT(Date,SaleDate)
FROM PortfolioProject.dbo.NashvilleHousing;


ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;


UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate);

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing
WHERE PropertyAddress is NULL;

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate;

----Populate PropertyAddress Data
--SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress
--FROM PortfolioProject.dbo.NashvilleHousing a
--INNER JOIN PortfolioProject.dbo.NashvilleHousing b
--ON a.ParcelID = b.ParcelID
--AND a.UniqueID <> b.UniqueID;

--UPDATE a
--SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
--FROM PortfolioProject.dbo.NashvilleHousing as a
--INNER JOIN PortfolioProject.dbo.NashvilleHousing as b
--ON a.ParcelID = b.ParcelID
--AND a.UniqueID <> b.UniqueID
--WHERE a.PropertyAddress is NULL;

SELECT PropertyAddress
FROM PortfolioProject.dbo.NashVilleHousing;

--Split the values using SUBSTRING for PropertyAddress
SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address ,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1,LEN(PropertyAddress)) as City 
FROM PortfolioProject.dbo.NashvilleHousing;

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress nvarchar(max);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1);

ALTER TABLE NashvilleHousing
ADD PropertySplitCity nvarchar(max);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1,LEN(PropertyAddress));

SELECT * 
FROM PortfolioProject.dbo.NashvilleHousing;

ALTER TABLE NashvilleHousing
DROP COLUMN PropertyAddress;

--USING PARSENAME() Function to Split string values form OwnerAddress Column
SELECT
 PARSENAME(REPLACE(OwnerAddress, ',','.'),3) as OwnerAddress
 ,PARSENAME(REPLACE(OwnerAddress, ',','.'),2)as OwnerCity
 ,PARSENAME(REPLACE(OwnerAddress, ',','.'),1) as OwnerState
 FROM PortfolioProject.dbo.NashvilleHousing;

 ALTER TABLE NashvilleHousing
 ADD OwnerSplitAddress nvarchar(255);

 UPDATE NashvilleHousing
 SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'),3);

 ALTER TABLE NashvilleHousing
 ADD OwnerSplitCity nvarchar(255);

 UPDATE NashvilleHousing
 SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'),2);

 ALTER TABLE NashvilleHousing
 ADD OwnerSplitState nvarchar(255);

 UPDATE NashvilleHousing
 SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'),1);

 SELECT * 
 FROM PortfolioProject.dbo.NashvilleHousing;
 
 --DROP THE COLUMN NAME OwnerAddress
 ALTER TABLE NashvilleHousing
 DROP COLUMN OwnerAddress;
 
 --Return the value of SoldAsVacant and change the Y and N to Yes and NO in Column SoldAsVacant
 SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
 FROM PortfolioProject.dbo.NashvilleHousing
 GROUP BY SoldAsVacant
 ORDER BY 2;

SELECT SoldAsVacant,
 CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
      WHEN SoldAsVacant = 'N' THEN 'No'
	  ELSE SoldAsVacant
	  END
FROM PortfolioProject.dbo.NashvilleHousing

--UPDATE THE Y and N to Yes and No as return value for SoldAsVacant
UPDATE NashvilleHousing
SET SoldAsVacant = 
CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
      WHEN SoldAsVacant = 'N' THEN 'No'
	  ELSE SoldAsVacant
	  END

--REMOVE DUPLICATES
 SELECT * 
 FROM PortfolioProject.dbo.NashvilleHousing;

 --Used the CTE function
 WITH RowNumCTE AS(
 SELECT *,
 ROW_NUMBER() OVER (
 PARTITION BY ParcelID,
	PropertySplitAddress,
	SalePrice,
	SaleDateConverted,
	LegalReference
	ORDER BY UniqueID) as row_num
 FROM PortfolioProject.dbo.NashvilleHousing
 --ORDER BY ParcelID;
 )
 -- OR DELETE
SELECT *
 FROM RowNumCTE
 ORDER BY 2;

 
SELECT * 
FROM PortfolioProject.dbo.NashvilleHousing;
--DROPPING Unused Columns
ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN TaxDistrict;