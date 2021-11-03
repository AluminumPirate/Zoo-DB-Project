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
