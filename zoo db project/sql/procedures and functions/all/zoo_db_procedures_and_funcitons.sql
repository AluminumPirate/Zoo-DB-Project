--use Zoo_db
--Q1
--proc 1:
create or alter procedure InsertNewFood
          @FoodName nvarchar(20),
		  @FoodState nvarchar(6)
as 
begin
      insert into Food(foodName, foodMatterState) values (@FoodName, @FoodState)
end



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

/*declare @qAnswer nvarchar(100)
exec InsertAnimalToCage @animalID = 73, @cageID = 270, @Answer = @qAnswer output
print @qAnswer*/


--Q2
--פרוצדורה המקבלת פרטי עובד חדש ומספר כלוב
--ומעדכנת את טבלת העובדים בפרטי העובד ואת טבלת עובד מנקה כלוב 

create or alter proc AddNewEmployeeAndCleaningCage @EmployeeID char(9),
	                                     @FirstName nvarchar(20),
	                                     @LastName nvarchar(20),
	                                     @BirthDate date,
	                                     @PhoneNumber char(10),
	                                     @Gender char(1),
	                                     @Salary real,
										 @answer nvarchar(50) output
as
begin
     declare @BigestCage smallint
     set @BigestCage = (select top 1 cageID
                        from Cage
                        order by cageVolume Desc )
     
	 insert into Employee values (@EmployeeID, @FirstName, @LastName, @BirthDate, @PhoneNumber, @Gender, @Salary)
     
	 -- Check successful insert
     if (@@rowcount = 1)
		 begin
			 declare @EndCleanTime smalldatetime
			 declare @timeDiffInMinutes tinyint
			 set @timeDiffInMinutes = (select convert(tinyint, round(255*rand(),100)))
		 
			 set @EndCleanTime= cast(dateadd(minute, @timeDiffInMinutes, getdate())as smalldatetime)
			 insert into EmployeeCleanCage values (@EmployeeID, @BigestCage, cast(getdate() as smalldatetime), @EndCleanTime, convert(bit, round(1*rand(),0)))

			 set @answer = 'Employee inserted successfully'
		 end
	 else
		 begin
			set @answer = 'Employee did not insert successfully'
		 end

end


/*exec AddNewEmployeeAndCleningCage @EmployeeID='999999991', 
                                  @FirstName='Elizabeth', 
								  @LastName='Queen', 
								  @BirthDate='1988-09-05', 
								  @PhoneNumber='0529999999', 
								  @Gender='F', 
								  @Salary= 170000.85*/


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



--Q4
--triger 1:
create or alter trigger CheckVisitedExistingAnimal on VisitorMeetAnimal
        after insert,
		update as
		begin
		     declare @VisitorID int,
	                 @AnimalID smallint,
	                 @VisitDate date,
					 @AnimalBD date
			 select @VisitorID=I.visitorID, @AnimalID=I.animalID, @VisitDate=I.visitDate
			 from inserted as I

			 select @AnimalBD=A.animalBirthDate
			 from Animal as A

			 if (@AnimalBD>@VisitDate)
			 begin
			     print 'Animal was not born yet, try again.'
                 RAISERROR('Animal was not born yet, try again.', 16, 1)
			     rollback;
			 end			    			 
		end


--Q5
create or alter function AvgCleaningTimeAfterDateForGender (@Date smalldatetime, @EmployeeGender char(1)) returns int as
begin
	declare @avgCleaningTime int = 0


	select @avgCleaningTime = avg(datediff(minute, ECC.startCleaningTime, ECC.endCleaningTime))
	from EmployeeCleanCage as ECC
	where ECC.startCleaningTime > @Date and ECC.employeeID in (select E.employeeID from Employee as E where E.gender = @EmployeeGender)

	if @avgCleaningTime < 0
	begin
		set @avgCleaningTime = 0
	end

	return @avgCleaningTime
end


/*declare @avgTime int
exec @avgTime = avgCleaningTimeAfterDate 
		@Date = '2015-01-25', @EmployeeGender = 'M'

print 'average cleaning time is: ' + cast(@avgTime as nvarchar) + ' minutes.'*/



--Q6
create or alter procedure GetDataForEmployeeOlderThanXAndCleaningTimeLowerThanAvgCleaningTime
@minDate smalldatetime, 
@minAge smallint,
@gender char(1)

as    
 begin
	declare @today smalldatetime = getdate()
	declare @avgCleanTime int

	declare @data table 
	(
		FullName nvarchar(41),
		Age int,
		Gender char(1),
		CleaningTime int,
		cageID smallint
	)

	exec @avgCleanTime = avgCleaningTimeAfterDateForGender @Date = @minDate, @EmployeeGender = @gender

	insert into  @data (FullName, Age, Gender, CleaningTime, cageID)

	select E.firstName + ' ' + E.lastName as FullName, datediff(year, E.birthDate, @today) as Age, E.gender, datediff(minute, ECC.startCleaningTime, ECC.endCleaningTime) cleaningTime, ECC.cageID
	from EmployeeCleanCage as ECC inner join Employee as E
	on ECC.employeeID = E.employeeID
	where datediff(minute, ECC.startCleaningTime, ECC.endCleaningTime) < @avgCleanTime
								and datediff(year, E.birthDate, @today) >= @minAge
	select * from @data

 end



/*exec GetDataForEmployeeOlderThanXAndCleaningTimeLowerThanAvgCleaningTime @minDate = '2018-01-01',
																		 @minAge = 35,
																		 @gender = 'M'*/


--Q7
-- פרוצדורה המקבלת תאריך ומחזירה עבור כל תאריך החל מהתאריך הנשלח ועד היום
-- את כמות המבקרים באותו יום
create or alter procedure GetInfoForEachDay @start date as
-- נייצר טבלה זמנית שתכיל את כל התאריכים הקיימים
begin
	create table #allDates
	(
		dateOfVisit date
	)
	declare @endDate date
	set @endDate = cast(getdate() as date)

	while @start < @endDate
		begin
			 insert into #allDates values(@start)
			 set @start = dateadd(day, 1, @start)
		end
	-- נעבור על טבלת התאריכים אל מול טבלת המבקרים ונספור כמה ביקרו בכל יום
	select D.dateOfVisit, count(VMA.visitorID) as numOfVisitors
		from #allDates as D left outer join 
		 VisitorMeetAnimal as VMA on D.dateOfVisit = VMA.visitDate
	group by D.dateOfVisit
end


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



--Q9
--proc 1
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



--proc 3:
--  פרוצדורה המחזירה ממוצע גיל המבקרים עבור כל שם פרטי מסוים ובדיוק של שתי ספרות אחרי הנקודה העשרונית
create or alter proc GetAvgAgePerVisitorsName as
begin 
      select V.visitorFirstName, convert(decimal(10,2),avg(datediff(day,V.visitorBirthDate,getdate())/365.00)) as avgAge
      from Visitor as V
      group by V.visitorFirstName
end


----DOES NOT WORK
----proc 3:
---- פרוצדורה המקבלת גיל ומחזירה את החיות שאף פעם לא ביקרו אותן וגילן גדול מהגיל הנתון
--create proc AnimalIsGreaterThanAgeX @AgeX tinyint as
--begin
--     select A.animalID, A.animalName, floor(datediff(day, A.animalBirthDate, getdate()) / 365.00) as 'AnimalAge'
--     from Animal as A
--     where not exists ( select *
--                        from VisitorMeetAnimal)
--             and floor(datediff(day, A.animalBirthDate, getdate()) / 365.00) > @AgeX
--end



--proc4
create or alter proc AnimalWasVisitedMoreThanXTimes @XTimes int as
begin
     select VMA.animalID, A.animalName, count(VMA.visitDate) as numOfVisits
     into #MeetingInfo
     from VisitorMeetAnimal as VMA inner join Animal as A
           on VMA.animalID=A.animalID
     group by VMA.animalID, A.animalName
	 having count(VMA.visitDate) > @XTimes

	 select * from #MeetingInfo order by numOfVisits
end
