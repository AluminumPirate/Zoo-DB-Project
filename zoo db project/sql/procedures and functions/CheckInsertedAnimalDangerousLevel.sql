--Q3
create or alter trigger CheckInsertedAnimalDangerousLevel on AnimalInCage after insert, update as
begin
	declare @animalID smallint,
			@cageID smallint,
			@animalIsDangerous bit, 
			@cageForDangerousAnimal bit


		select @animalID = I.animalID, @cageID = I.cageID
		from inserted as I
		
		set @animalIsDangerous = (select animalIsDangerous from Animal as A where A.animalID = @animalID)
		set @cageForDangerousAnimal = (select cageForDangerousAnimal from Cage as C where C.cageID = @cageID)
		
		if @animalIsDangerous <> @cageForDangerousAnimal
			begin
				print 'Animal and Cage strength does not match. try again.'
				RAISERROR('Animal and Cage strength does not match. try again.', 16, 1)
				rollback
			end
		else
			begin
				print 'Inserted successfuly'
			end
end