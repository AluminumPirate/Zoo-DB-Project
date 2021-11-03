using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace zoo_db_connected
{
  public partial class Form1 : Form
  {
    public Form1(SqlDataReader rdr)
    {

      InitializeComponent();
      chart1.Series["columns"].IsValueShownAsLabel = true;
      chart1.Titles.Add("Animal By Category Pie Chart");
      
      while (rdr.Read())
      {
        chart1.Series["columns"].Points.AddXY(rdr[0], rdr[1]);
      }
    }

    private void Form1_Load(object sender, EventArgs e)
    {
    }

    private void chart1_Click(object sender, EventArgs e)
    {

    }
  }
}
