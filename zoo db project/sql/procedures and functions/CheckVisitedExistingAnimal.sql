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