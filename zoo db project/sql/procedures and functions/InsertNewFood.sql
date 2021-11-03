--Q1
--proc 1:
create or alter procedure InsertNewFood
          @FoodName nvarchar(20),
		  @FoodState nvarchar(6)
as 
begin
      insert into Food(foodName, foodMatterState) values (@FoodName, @FoodState)
end