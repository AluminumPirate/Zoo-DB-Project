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

