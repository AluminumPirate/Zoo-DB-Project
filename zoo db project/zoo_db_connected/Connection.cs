using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Zoo_db_connection
{
  class Connection
  {
    static readonly string ZooConnectionString = //insert your DB StringConnection;
    public static string GetZooConnection()
    {
      return ZooConnectionString;
    }
  }
}
