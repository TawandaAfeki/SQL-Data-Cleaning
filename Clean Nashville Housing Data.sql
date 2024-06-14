Select *
from [Portfolio Project]..NashvilleHousing


-- Standardizing Data Format


Select SaleDateConverted, convert(Date, SaleDate)
from [Portfolio Project]..NashvilleHousing

Update NashvilleHousing
Set SaleDate = convert(Date,SaleDate)

alter table NashvilleHousing 
add SaleDateConverted Date

update NashvilleHousing
set SaleDateConverted = convert(Date, SaleDate)


-- Populate Propert Address data


Select *
from [Portfolio Project]..NashvilleHousing
--where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from [Portfolio Project]..NashvilleHousing a
join [Portfolio Project]..NashvilleHousing b 
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from [Portfolio Project]..NashvilleHousing a
join [Portfolio Project]..NashvilleHousing b 
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]


--Breaking out Address into Individual columns


Select PropertyAddress
from [Portfolio Project]..NashvilleHousing

select
substring(PropertyAddress,1,charindex(',',PropertyAddress)-1) as Address
, substring(PropertyAddress,charindex(',',PropertyAddress)+1, len(PropertyAddress)) as Address
from [Portfolio Project]..NashvilleHousing

alter table NashvilleHousing 
add PropertySplitAddress nvarchar(255);

update NashvilleHousing
set PropertySplitAddress = substring(PropertyAddress,1,charindex(',',PropertyAddress)-1)

alter table NashvilleHousing 
add PropertySplitCity nvarchar(255);

update NashvilleHousing
set PropertySplitCity = substring(PropertyAddress,charindex(',',PropertyAddress)+1, len(PropertyAddress))

Select *
from [Portfolio Project]..NashvilleHousing



Select OwnerAddress
from [Portfolio Project]..NashvilleHousing


select
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from [Portfolio Project]..NashvilleHousing


alter table NashvilleHousing 
add OwnerSplitAddress nvarchar(255);

update NashvilleHousing
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

alter table NashvilleHousing 
add OwnerSplitCity nvarchar(255);

update NashvilleHousing
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

alter table NashvilleHousing 
add OwnerSplitState nvarchar(255);

update NashvilleHousing
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


--Change Y and N to Yes and No


Select Distinct(SoldAsVacant), count(SoldAsVacant)
from [Portfolio Project]..NashvilleHousing
group by SoldAsVacant
order by 2


Select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end
from [Portfolio Project]..NashvilleHousing

update NashvilleHousing
set SoldAsVacant =  case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end


--Removing Duplicates


with RowNumCTE AS(
select *,
row_number() over (
partition by ParcelID,
PropertyAddress,
SalePrice,
SaleDate,
LegalReference
order by UniqueID ) row_num

from [Portfolio Project]..NashvilleHousing
)
Select *
from RowNumCTE
where row_num > 1


--Delete Unused columns


Select *
from [Portfolio Project]..NashvilleHousing

alter table [Portfolio Project]..NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress

alter table [Portfolio Project]..NashvilleHousing
drop column SaleDate
