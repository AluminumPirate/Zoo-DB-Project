using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace zoo_db_connected
{
  class ZooQueries
  {
    public static void WaitForKeyStroke()
    {
      Console.WriteLine("Press any key to continue");
      Console.ReadKey();
    }

    //Q1
    public static void InsertAnimalToCage(SqlConnection con)
    {
      String queryAnswer = "";

      using (SqlCommand cmd = new SqlCommand("InsertAnimalToCage", con))
      {
        Console.Write("insert animal ID: ");
        Int16 animalID = Convert.ToInt16(Console.ReadLine());
        Console.Write("insert cage ID: ");
        Int16 cageID = Convert.ToInt16(Console.ReadLine());

        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@animalID", animalID);
        cmd.Parameters.AddWithValue("@cageID", cageID);
        cmd.Parameters.Add("@answer", SqlDbType.NVarChar, 100);
        cmd.Parameters["@answer"].Direction = ParameterDirection.Output;
        con.Open();
        try
        {
          cmd.ExecuteNonQuery();
        }
        catch (SqlException ex)
        {
          Console.WriteLine(ex.Message + '\n');
        }
        queryAnswer = Convert.ToString(cmd.Parameters["@answer"].Value);
        con.Close();
        Console.WriteLine("\n" + queryAnswer + "\n");
      }
      ZooQueries.WaitForKeyStroke();
    }

    //Q2
    public static void AddNewEmployeeAndCleaningCage(SqlConnection con)
    {
      String queryAnswer = "";

      using (SqlCommand cmd = new SqlCommand("AddNewEmployeeAndCleaningCage", con))
      {
        Console.Write("insert employee ID (9 characters): ");
        String employeeID = Console.ReadLine();

        Console.Write("insert employee first name: ");
        String employeeFirstName = Console.ReadLine();

        Console.Write("insert employee last name: ");
        String employeeLastName = Console.ReadLine();

        Console.Write("insert employee birth date (YYYY-MM-DD): ");
        DateTime employeeBirthDate;
        try
        {
          employeeBirthDate = Convert.ToDateTime(Console.ReadLine());
        }
        catch (InvalidCastException ex)
        {
          Console.WriteLine(ex.Message);
          return;
        }

        Console.Write("insert employee phone number (10 digits start with 05): ");
        String employeePhoneNumber = Console.ReadLine();

        Console.Write("insert employee gender (M/F): ");
        char employeeGender = Console.ReadLine()[0];

        Console.Write("insert employee salary: ");
        Single employeeSalary;
        try
        {
          employeeSalary = Convert.ToSingle(Console.ReadLine());
        }
        catch (InvalidCastException ex)
        {
          Console.WriteLine(ex.Message);
          return;
        }


        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@EmployeeID", employeeID);
        cmd.Parameters.AddWithValue("@FirstName", employeeFirstName);
        cmd.Parameters.AddWithValue("@LastName", employeeLastName);
        cmd.Parameters.AddWithValue("@BirthDate", employeeBirthDate);
        cmd.Parameters.AddWithValue("@PhoneNumber", employeePhoneNumber);
        cmd.Parameters.AddWithValue("@Gender", employeeGender);
        cmd.Parameters.AddWithValue("@Salary", employeeSalary);
        cmd.Parameters.Add("@answer", SqlDbType.NVarChar, 50);
        cmd.Parameters["@answer"].Direction = ParameterDirection.Output;

        con.Open();
        try
        {
          cmd.ExecuteNonQuery();
        }
        catch (SqlException ex)
        {
          Console.WriteLine(ex.Message + '\n');
        }

        queryAnswer = Convert.ToString(cmd.Parameters["@answer"].Value);
        con.Close();
        Console.WriteLine("\n" + queryAnswer + "\n");
      }
      ZooQueries.WaitForKeyStroke();
    }

    //Q6
    public static void GetDataForEmployeeOlderThanXAndCleaningTimeLowerThanAvgCleaningTime(SqlConnection con)
    {
      using (SqlCommand cmd = new SqlCommand("GetDataForEmployeeOlderThanXAndCleaningTimeLowerThanAvgCleaningTime", con))
      {
        Console.Write("insert date from which to check data: ");
        DateTime minDate;
        try
        {
          minDate = Convert.ToDateTime(Console.ReadLine());
        }
        catch (InvalidCastException ex)
        {
          Console.WriteLine(ex.Message);
          return;
        }

        Console.Write("insert employee minimum age: ");
        Int16 employeeMinAge;
        try
        {
          employeeMinAge = Convert.ToInt16(Console.ReadLine());
        }
        catch (InvalidCastException ex)
        {
          Console.WriteLine(ex.Message);
          return;
        }

        Console.Write("insert employee gender (M/F): ");
        char employeeGender = Console.ReadLine()[0];

        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@minDate", minDate);
        cmd.Parameters.AddWithValue("@minAge", employeeMinAge);
        cmd.Parameters.AddWithValue("@gender", employeeGender);

        con.Open();

        Console.WriteLine("\nDetails:\n============");
        using SqlDataReader rdr = cmd.ExecuteReader();
        while (rdr.Read())
        {
          //FullName nvarchar(41), Age int, Gender char(1), CleaningTime int, cageID smallint

          Console.WriteLine("Full Name: " + rdr["FullName"] + "\nAge: " + rdr["Age"] + "\nGender: " + rdr["Gender"]
              + "\nCleaning Time: " + rdr["CleaningTime"] + "\nCage ID: " + rdr["cageID"] + "\n---------------------------\n");
        }
      }
      con.Close();
      ZooQueries.WaitForKeyStroke();
    }

   //Q8
    public static void GetNumberOfAnimalsPerTypeNameByCategoryNameAsGraph(SqlConnection con)
    {
      con.Open();

      Console.Write("Insert animal category name (Mammal/Bird/Reptile/Fish/Amphibian/Bug/Invertebrate): ");
      String animalCategoryName = Console.ReadLine();


      using (SqlCommand cmd = new SqlCommand("GetNumberOfAnimalsPerTypeNameByCategoryNameAsGraph", con))
      {
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@CategoryName", animalCategoryName);

        using SqlDataReader rdr = cmd.ExecuteReader();

        Application.EnableVisualStyles();
        //Application.SetCompatibleTextRenderingDefault(false);
        Application.Run(new Form1(rdr));
      }
      con.Close();
    }


    //Q9 1
    public static void InsertIntoAnimalAndRandomAnimalEatsFoodAndRandomCage(SqlConnection con)
    {
      String queryAnswer = "";

      using (SqlCommand cmd = new SqlCommand("InsertIntoAnimalAndRandomAnimalEatsFoodAndRandomCage", con))
      {
        Console.Write("insert animal name: ");
        String animalName = Console.ReadLine();

       
        Console.Write("insert animal birth date: ");
        DateTime animalBirthDate;
        try
        {
          animalBirthDate = Convert.ToDateTime(Console.ReadLine());
        }
        catch (InvalidCastException ex)
        {
          Console.WriteLine(ex.Message);
          return;
        }

        Console.Write("insert animal weight: ");
        Decimal animalWeight;
        try
        {
          animalWeight = Convert.ToDecimal(Console.ReadLine());
        }
        catch (InvalidCastException ex)
        {
          Console.WriteLine(ex.Message);
          return;
        }

        Console.Write("insert animal height: ");
        Decimal animalHeight;
        try
        {
          animalHeight = Convert.ToDecimal(Console.ReadLine());
        }
        catch (InvalidCastException ex)
        {
          Console.WriteLine(ex.Message);
          return;
        }


        Console.Write("insert animal gender (M/F): ");
        char animalGender = Console.ReadLine()[0];


        Console.Write("insert animal dangerous level (1/0): ");
        String isDangerous = Console.ReadLine();
        Boolean animalIsDangerous = (isDangerous == "1");
        
        Console.Write("insert animal description (up to 255 characters): ");
        String animalDescription = Console.ReadLine();

        Console.Write("insert animal type id: ");
        Int16 animalTypeID;
        try
        {
          animalTypeID = Convert.ToInt16(Console.ReadLine());
        }
        catch (InvalidCastException ex)
        {
          Console.WriteLine(ex.Message);
          return;
        }

        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@animalName", animalName);
        cmd.Parameters.AddWithValue("@animalBD", animalBirthDate);
        cmd.Parameters.AddWithValue("@animalWeight", animalWeight);
        cmd.Parameters.AddWithValue("@animalHeight", animalHeight);
        cmd.Parameters.AddWithValue("@animalGender", animalGender);
        cmd.Parameters.AddWithValue("@animalIsDangerious", animalIsDangerous);
        cmd.Parameters.AddWithValue("@animalDescription", animalDescription);
        cmd.Parameters.AddWithValue("@animalTypeID", animalTypeID);

        cmd.Parameters.Add("@q9answer", SqlDbType.NVarChar, 100);
        cmd.Parameters["@q9answer"].Direction = ParameterDirection.Output;

        con.Open();
        try
        {
          cmd.ExecuteNonQuery();
        }
        catch (SqlException ex)
        {
          Console.WriteLine(ex.Message + '\n');
        }

        queryAnswer = Convert.ToString(cmd.Parameters["@q9answer"].Value);
        con.Close();
        Console.WriteLine("\n" + queryAnswer + "\n");
      }
      ZooQueries.WaitForKeyStroke();
    }


    //Q9 2
    public static void GetAvgAgePerVisitorsName(SqlConnection con)
    {
      using (SqlCommand cmd = new SqlCommand("GetAvgAgePerVisitorsName", con))
      {
        con.Open();

        Console.WriteLine("\nDetails:\n============");
        using SqlDataReader rdr = cmd.ExecuteReader();
        while (rdr.Read())
        {
          //FullName nvarchar(41), Age int, Gender char(1), CleaningTime int, cageID smallint

          Console.WriteLine("Visitor First Name: " + rdr["visitorFirstName"] + "\nAverage Age: "
                                                   + rdr["avgAge"] + "\n---------------------------\n");
        }
      }
      con.Close();
      ZooQueries.WaitForKeyStroke();
    }


    //Q9 3
    public static void GetAvgAgePerAnimalName(SqlConnection con)
    {
      int numOfAnimalFound = 0;
      using (SqlCommand cmd = new SqlCommand("GetAvgAgePerAnimalName", con))
      {
        con.Open();

        Console.Write("Insert word to find in description (up to 20 characters): ");
        String description = Console.ReadLine();
        
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@description", description);

        Console.WriteLine("\nDetails:\n============");
        using SqlDataReader rdr = cmd.ExecuteReader();
        while (rdr.Read())
        {
          numOfAnimalFound++;
          //FullName nvarchar(41), Age int, Gender char(1), CleaningTime int, cageID smallint

          Console.WriteLine("Animal Name: " + rdr["animalName"] + "\nAverage Age: "
                                                   + rdr["avgAge"] + "\n---------------------------\n");
        }

        Console.WriteLine($"{numOfAnimalFound} animals found matching the part description \'{description}\'");
      }
      con.Close();
      
      ZooQueries.WaitForKeyStroke();
    }


    //Q9 4
    public static void AnimalWasVisitedMoreThanXTimes(SqlConnection con)
    {
      int numOfAnimalFound = 0;
      using (SqlCommand cmd = new SqlCommand("AnimalWasVisitedMoreThanXTimes", con))
      {
        con.Open();

        Console.Write("Insert minimum number of visited times: ");
        Int32 visitedTimes;
        try
        {
          visitedTimes = Convert.ToInt32(Console.ReadLine());
        }
        catch (InvalidCastException ex)
        {
          Console.WriteLine(ex.Message);
          return;
        }

        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@XTimes", visitedTimes);

        Console.WriteLine("\nDetails:\n============");
        using SqlDataReader rdr = cmd.ExecuteReader();
        while (rdr.Read())
        {
          numOfAnimalFound++;
          //FullName nvarchar(41), Age int, Gender char(1), CleaningTime int, cageID smallint

          Console.WriteLine("Animal ID:" + rdr["animalID"] + "\nAnimal Name: " + rdr["animalName"] + "\nNumber of visits: "
                                                   + rdr["numOfVisits"] + "\n---------------------------\n");
        }

        Console.WriteLine($"{numOfAnimalFound} animals found");
      }
      con.Close();

      ZooQueries.WaitForKeyStroke();
    }

  }
}
