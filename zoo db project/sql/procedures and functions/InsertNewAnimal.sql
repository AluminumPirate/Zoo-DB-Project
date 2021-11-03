--Q1
--proc 2:
create or alter procedure InsertNewAnimal
          @AnimalName nvarchar(20),
		  @AnimalBirthDate nvarchar(6),
		  @AnimalWeight decimal(5,1),
	      @AnimalHeight decimal(3,2),
	      @AnimalGender char(1),
	      @AnimalIsDangerous BIT,
	      @AnimalDescription nvarchar(255)
as 
begin
      insert into Animal(animalName, animalBirthDate, animalWeight, animalHeight, animalGender, animalIsDangerous, animalDescription) values (@AnimalName, @AnimalBirthDate, @AnimalWeight, @AnimalHeight,@AnimalGender, @AnimalIsDangerous, @AnimalDescription)
end