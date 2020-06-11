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

namespace Projeto_BD
{
    public partial class InfoJogo : Form
    {
        static SqlConnection CN = new SqlConnection("Data Source = " + "tcp:mednat.ieeta.pt" + @"\" + "SQLSERVER,8101" + " ;" + "Initial Catalog = " + "p2g4" + "; uid = " + "p2g4" + ";" + "password = " + "RV{'a~SyES>8_gy[");
        //static SqlConnection CN = new SqlConnection("data source = localhost; integrated security = true; initial catalog = master");

        private int game_number;
        public InfoJogo()
        {
            InitializeComponent();
            FillDropDown();
            
        }

        public void setNumber(int _num)
        {
            game_number = _num;
        }
        public ListBox getList()
        {
            return this.listBox1;
        }

        public System.Windows.Forms.Label getLabel()
        {
            return this.label1;
        }

        private void InfoJogo_Load(object sender, EventArgs e)
        {

        }

        private void listBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void textBox2_TextChanged(object sender, EventArgs e)
        {

        }

        private void UpdateGame(int _spectators,int _arbitro,int _gol1, int _gol2)
        {
            CN.Open();
            SqlCommand cmd = new SqlCommand("PROJETO.FillGame", CN);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@nr", game_number));
            cmd.Parameters.Add(new SqlParameter("@espetadores", _spectators));
            cmd.Parameters.Add(new SqlParameter("@arbitragem", _arbitro));
            cmd.Parameters.Add(new SqlParameter("@res1", _gol1));
            cmd.Parameters.Add(new SqlParameter("@res2", _gol2));
            SqlDataReader reader = cmd.ExecuteReader();
            Form1 form = new Form1();
            form.GetInfoJogo(game_number,this);
            CN.Close();
        }
        private void button1_Click(object sender, EventArgs e)
        {
            if (this.comboBox1.SelectedItem == null || this.textBox2.Text == null || this.textBox3.Text == null || this.textBox4.Text == null)
            {
                return;
            }

            int spectators = Int32.Parse(this.textBox2.Text.ToString());
            int arbitro = Int32.Parse(this.comboBox1.SelectedItem.ToString());
            int gol1 = Int32.Parse(this.textBox3.Text.ToString());
            int gol2 = Int32.Parse(this.textBox4.Text.ToString());

            UpdateGame(spectators,arbitro,gol1,gol2);
        }

        private void FillDropDown()
        {
            CN.Open();
            SqlCommand cmd = new SqlCommand("select * from PROJETO.getIDea",CN);
            SqlDataReader reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                comboBox1.Items.Add(reader["ID"]);
            }
            CN.Close();
        }
    }
}
