--Q1
--proc 3
create or alter procedure InsertAnimalToCage
	@animalID smallint,
	@cageID smallint,
	@answer nvarchar(100) output
as
begin
	declare @animalIsDangerous bit
	declare @cageforDangerousAnimal bit

	set @animalIsDangerous = (select animalIsDangerous from Animal where animalID = @animalID)
	set @cageforDangerousAnimal = (select cageForDangerousAnimal from Cage where cageID = @cageID)

	if @animalIsDangerous = @cageforDangerousAnimal
		begin
			if exists (select 1 from AnimalInCage where animalID = @animalID)
			begin
				delete from AnimalInCage where animalID = @animalID
				print 'deleted from previous cage'
			end

			insert into [dbo].[AnimalInCage] (animalID, cageID) values (@animalID, @cageID)
			print 'inserted into new cage'
			set @answer = N'Animal ' + cast(@animalID as nvarchar) + ' inserted into cage ' + cast(@cageID as nvarchar)
		end
	else
	begin
		set @answer = N'Animal ' + cast(@animalID as nvarchar) + ' could not be inserted into cage ' + cast(@cageID as nvarchar)
	end
end