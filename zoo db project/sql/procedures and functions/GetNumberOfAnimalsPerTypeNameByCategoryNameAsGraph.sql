--Q8
create or alter proc GetNumberOfAnimalsPerTypeNameByCategoryNameAsGraph @CategoryName nvarchar(13)
as
begin
     select AnT.animalTypeName, COUNT(*) as numOfAnimalTypeName
     from AnimalType as AnT
     inner join Animal as A on A.animalTypeID = AnT.animalTypeID
     where AnT.animalCategory = @CategoryName
     group by AnT.animalTypeName
end

