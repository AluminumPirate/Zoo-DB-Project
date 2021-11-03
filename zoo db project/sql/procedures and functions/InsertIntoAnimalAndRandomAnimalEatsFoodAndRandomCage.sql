--Q9
create or alter proc InsertIntoAnimalAndRandomAnimalEatsFoodAndRandomCage @animalName nvarchar(20), 
																 @animalBD date, 
																 @animalWeight decimal(5,1), 
																 @animalHeight decimal(3,2),
																 @animalGender char(1), 
																 @animalIsDangerious bit, 
																 @animalDescription nvarchar(255), 
																 @animalTypeID smallint,
																 @q9answer nvarchar(100) output
as
begin

declare @insertedAnimalID smallint, @randomFoodID tinyint, @randomCageID smallint, @randomFoodName nvarchar(20)

	if @animalWeight >= 1000 and @animalHeight >= 2.0
	begin
		set @randomFoodID = (select top 1 F.foodID from Food as F
									where F.foodMatterState = 'solid'
									order by NEWID())
		--print 'solid foodid: ' + cast(@randomFoodID as nvarchar)
	end
	else
	begin
		set @randomFoodID = (select top 1 F.foodID from Food as F			   
									where F.foodMatterState = 'liquid'
									order by NEWID()) 
		--print 'liquid foodid: ' + cast(@randomFoodID as nvarchar)
	end



	insert into Animal values (@animalName, @animalBD, @animalWeight, @animalHeight, @animalGender, @animalIsDangerious, @animalDescription, @animalTypeID)
	
	if @@ROWCOUNT = 0
	begin
		set @q9answer = 'could not insert animal'
		print @q9answer
		RETURN
	end

	else
	begin
		print 'Animal inserted.'
		set @insertedAnimalID = (select SCOPE_IDENTITY())

		print 'insertedAnimalID: ' + cast(@insertedAnimalID as nvarchar)

		insert into AnimalEatsFood values (@insertedAnimalID, @randomFoodID)
		print 'Animal Food inserted.'

		set @randomCageID = (select top 1 C.cageID from Cage as C
								where C.cageForDangerousAnimal = @animalIsDangerious
								order by NEWID())
		print 'randomCageID: ' + cast(@randomCageID as nvarchar)
		insert into AnimalInCage values (@insertedAnimalID, @randomCageID)
		print 'Animal cage inserted.'

		set @randomFoodName = (select foodName from Food where foodID = @randomFoodID)

		set @q9answer = 'animal id ' + cast(@insertedAnimalID as nvarchar) + ' eats ' + @randomFoodName + ' inserted into cage id ' + cast(@randomCageID as nvarchar)
		
	end
end

/*declare @q9output nvarchar(100)
exec InsertIntoAnimalAndRandomAnimalEatsFoodAndRandomCage @animalName = 'NAme', @animalBD = '9999-05-01', 
														  @animalWeight = 1200.5, @animalHeight = 3.7,
														  @animalGender = 'F', @animalIsDangerious = 1, 
														  @animalDescription = 'NAme is awesome', @animalTypeID = 1,
														  @q9answer = @q9output output
print @q9output*/

