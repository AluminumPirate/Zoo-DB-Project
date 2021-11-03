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
