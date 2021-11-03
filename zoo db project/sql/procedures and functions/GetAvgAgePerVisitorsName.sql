--Q9
--proc 1:
--  פרוצדורה המחזירה ממוצע גיל המבקרים עבור כל שם פרטי מסוים ובדיוק של שתי ספרות אחרי הנקודה העשרונית
create or alter proc GetAvgAgePerVisitorsName as
begin 
      select V.visitorFirstName, convert(decimal(10,2),avg(datediff(day,V.visitorBirthDate,getdate())/365.00)) as avgAge
      from Visitor as V
      group by V.visitorFirstName
end

