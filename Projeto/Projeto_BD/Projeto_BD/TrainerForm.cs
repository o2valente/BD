using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Projeto_BD
{
    public partial class TrainerForm : Form
    {
        static SqlConnection CN = new SqlConnection("data source = localhost; integrated security = true; initial catalog = master");

        public TrainerForm()
        {
            InitializeComponent();
        }

        public ListBox GetListBox()
        {
            return listBox1;
        }
        private void GetTrainerHistory(String trainer)
        {
            string select_str = "SELECT PROJETO.GetNrFed('" + trainer + "')";
            Debug.WriteLine("Entrei");
             
            CN.Open();
            SqlCommand cmd_name = new SqlCommand(select_str, CN);
            SqlDataReader reader_name = cmd_name.ExecuteReader();
            int nr = 0;
            while(reader_name.Read())
            {
                nr = Int32.Parse(reader_name[0].ToString());
            }
            Debug.WriteLine(nr);
            CN.Close();
            CN.Open();
            SqlCommand cmd = new SqlCommand("PROJETO.ManagerHistory", CN);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@nrFed", nr));
            SqlDataReader reader = cmd.ExecuteReader();
            listBox2.Items.Clear();
            while (reader.Read())
            {
                listBox2.Items.Add(reader["Nome"] + ":" + " " + reader["Clube"] + " ");
            }
            CN.Close();
        }
        private void button1_Click(object sender, EventArgs e)
        {
            string sel = listBox1.SelectedItem.ToString();
            string trainer = sel.Split(':')[0];
            GetTrainerHistory(trainer);
        }
    }
}
