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
