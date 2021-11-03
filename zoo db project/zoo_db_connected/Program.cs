using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;
using Zoo_db_connection;

namespace zoo_db_connected
{
  static class Program
  {
    static Byte Counter = 0;

    [STAThread]
    static void Main(string[] args)
    {
      using SqlConnection con = new SqlConnection(Connection.GetZooConnection());
      bool showMenu = true;
      while (showMenu)
      {
        showMenu = ZooDbMethodsMenu(con);
      }
    }

    public static bool ZooDbMethodsMenu(SqlConnection con)
    {
      Counter = 0;
      Console.Clear();
      Console.WriteLine("Choose an option:");
      Console.WriteLine($"{++Counter}) Insert animal to cage");
      Console.WriteLine($"{++Counter}) Add new employee and cleaning cage");
      Console.WriteLine($"{++Counter}) Data for employee older than X and cleaning time lower than average cleaning time");
      Console.WriteLine($"{++Counter}) View number of animals per type by category pie graph");
      Console.WriteLine($"{++Counter}) Insert new Animal (inserts and automatically assign random food and random cage)");
      Console.WriteLine($"{++Counter}) Get average age per visitor name");
      Console.WriteLine($"{++Counter}) Get average age per animal containing part description");
      Console.WriteLine($"{++Counter}) Get animals that was visited more than X times: ");

      Console.WriteLine();
      Console.WriteLine("q) Exit");
      Console.Write("\r\nSelect an option: ");

      switch (Console.ReadLine())
      {
        case "1":
          ZooQueries.InsertAnimalToCage(con);
          return true;
        case "2":
          ZooQueries.AddNewEmployeeAndCleaningCage(con);
          return true;
        case "3":
          ZooQueries.GetDataForEmployeeOlderThanXAndCleaningTimeLowerThanAvgCleaningTime(con);
          return true;
        case "4":
          ZooQueries.GetNumberOfAnimalsPerTypeNameByCategoryNameAsGraph(con);
          return true;
        case "5":
          ZooQueries.InsertIntoAnimalAndRandomAnimalEatsFoodAndRandomCage(con);
          return true;
        case "6":
          ZooQueries.GetAvgAgePerVisitorsName(con);
          return true;
        case "7":
          ZooQueries.GetAvgAgePerAnimalName(con);
          return true;
        case "8":
          ZooQueries.AnimalWasVisitedMoreThanXTimes(con);
          return true;
        case "q":
          return false;
        default:
          return true;
      }

    }
  }
}
