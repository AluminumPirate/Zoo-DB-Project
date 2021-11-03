--proc 2:
--המספקת גיל ממוצע של החיות בעלות אותו שם אשר התיאור שלהם מכיל את הביטוי מהמשתמש
create or alter proc GetAvgAgePerAnimalName @description nvarchar(20) as
begin
      select A.animalName, convert(decimal(10,2),avg(datediff(day,A.animalBirthDate,getdate())/365.00)) as avgAge
      from Animal as A
	  where A.animalID in (select A1.animalID
	                       from Animal as A1 
						   where A1.animalDescription like ('%' + @description + '%'))
      group by A.animalName
end

--exec GetAvgAgePerAnimalName @description = 'ocean'

