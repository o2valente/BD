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
    public partial class AddGame : Form
    {
        private Form1 f1;
        static SqlConnection CN = new SqlConnection("data source = localhost; integrated security = true; initial catalog = master");

        public AddGame()
        {
            InitializeComponent();
            FillDropDowns();
        }
        
        public void setForm1(Form1 _f1)
        {
            f1 = _f1;
        }

        private void Add_Game(int _spectators,string _stadium,int _jornada, int _arbitro, int _gol1, int _gol2,string _club1,string _club2)
        {
            CN.Open();
            SqlCommand cmd = new SqlCommand("PROJETO.AddGame", CN);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@espetadores", _spectators));
            cmd.Parameters.Add(new SqlParameter("@estadio", _stadium));
            cmd.Parameters.Add(new SqlParameter("@jornada", _jornada));
            cmd.Parameters.Add(new SqlParameter("@arbitragem", _arbitro));
            cmd.Parameters.Add(new SqlParameter("@clube1", _club1));
            cmd.Parameters.Add(new SqlParameter("@clube2", _club2));
            cmd.Parameters.Add(new SqlParameter("@res1", _gol1));
            cmd.Parameters.Add(new SqlParameter("@res2", _gol2));
            SqlDataReader reader = cmd.ExecuteReader();
            f1.GetJornada(_jornada);
            CN.Close();
        }
        private void button1_Click(object sender, EventArgs e)
        {
            if (this.textBox1.Text == null || this.comboBox1.SelectedItem == null || this.comboBox2.SelectedItem == null || this.comboBox3.SelectedItem == null || this.comboBox4.SelectedItem == null || this.textBox6.Text == null || this.textBox7.Text == null )
            {
                return;
            }

            int spectators = Int32.Parse(this.textBox1.Text.ToString());
            int arbitro = Int32.Parse(this.comboBox5.SelectedItem.ToString());
            int gol1 = Int32.Parse(this.textBox6.Text.ToString());
            int gol2 = Int32.Parse(this.textBox7.Text.ToString());
            string stadium = this.comboBox1.SelectedItem.ToString();
            int jornada = Int32.Parse(this.comboBox2.SelectedItem.ToString());
            string club1 = this.comboBox3.SelectedItem.ToString();
            string club2 = this.comboBox4.SelectedItem.ToString();

            Add_Game(spectators,stadium,jornada, arbitro, gol1, gol2,club1,club2);
        }

        private void FillDropDowns()
        {

            //------------Estadios---------------
            CN.Open();
            SqlCommand estadioCmd = new SqlCommand("select * from PROJETO.getNomeEstadio", CN);
            SqlDataReader estadiosReader = estadioCmd.ExecuteReader();
            while (estadiosReader.Read())
            {
                comboBox1.Items.Add(estadiosReader["Nome"]);
            }
            CN.Close();
            //------------NrJornada---------------
            CN.Open();
            SqlCommand jornadaCmd = new SqlCommand("select * from PROJETO.getNrJornada", CN);
            SqlDataReader jornadaReader = jornadaCmd.ExecuteReader();
            while (jornadaReader.Read())
            {
                comboBox2.Items.Add(jornadaReader["NrJornada"]);
            }
            CN.Close();
            //-------------Nome Clubes--------------
            CN.Open();
            SqlCommand clubesCmd = new SqlCommand("select * from PROJETO.getNomesClube", CN);
            SqlDataReader clubesReader = clubesCmd.ExecuteReader();
            while (clubesReader.Read())
            {
                comboBox3.Items.Add(clubesReader["Nome"]);
                comboBox4.Items.Add(clubesReader["Nome"]);
            }
            CN.Close();
            //-------------Equipa Arbitragem--------------
            CN.Open();
            SqlCommand arbCmd = new SqlCommand("select * from PROJETO.getIDea", CN);
            SqlDataReader arbReader = arbCmd.ExecuteReader();
            while (arbReader.Read())
            {
                comboBox5.Items.Add(arbReader["ID"]);
            }
            CN.Close();

        }

        private void AddGame_Load(object sender, EventArgs e)
        {

        }
    }
}
