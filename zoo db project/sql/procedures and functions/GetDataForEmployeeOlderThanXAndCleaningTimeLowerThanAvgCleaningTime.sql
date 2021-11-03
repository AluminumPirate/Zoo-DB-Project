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

