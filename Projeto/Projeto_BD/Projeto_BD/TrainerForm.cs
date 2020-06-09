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
        private Form1 form1;
        static SqlConnection CN = new SqlConnection("data source = localhost; integrated security = true; initial catalog = master");

        public TrainerForm()
        {
            InitializeComponent();
            FillDropDowns();
        }
        public ListBox GetListBox()
        {
            return listBox1;
        }

        public void setForm(Form1 _form1)
        {
            form1 = _form1;
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
                
                if (reader["dataSub"] is null)
                {
                    
                    listBox2.Items.Add(reader["Nome"] + ":" + " " + reader["Clube"] + " ");
                }
                else
                {
                    string[] data =  reader["dataSub"].ToString().Split(' ');
                    listBox2.Items.Add(reader["Nome"] + ":" + " " + reader["Clube"] + " " + data[0]);
                }
                
            }

            CN.Close();
        }
        private void button1_Click(object sender, EventArgs e)
        {
            if(listBox1.SelectedItem is null)
            {
                MessageBox.Show("Chosse a Coach!");
            }
            else
            {
                string sel = listBox1.SelectedItem.ToString();
                string trainer = sel.Split('|')[0];
                GetTrainerHistory(trainer);
            }
            
        }

        private void FillDropDowns()
        {

            //------------Estadios---------------
            CN.Open();
            SqlCommand cmd = new SqlCommand("select * from PROJETO.getNomesClube", CN);
            SqlDataReader reader = cmd.ExecuteReader();
            comboBox1.Items.Add("");
            while (reader.Read())
            {
                comboBox1.Items.Add(reader["Nome"]);
            }
            CN.Close();
            //------------NrJornada---------------
            comboBox2.Items.Add("Principal");
            comboBox2.Items.Add("Adjunto");
            comboBox2.Items.Add("Guarda Redes");
        }

        private void TrainerForm_Load(object sender, EventArgs e)
        {

        }


        private void Add_Trainer(string _name,string _team,string _espec,string _tatica)
        {
            CN.Open();
            SqlCommand cmd = new SqlCommand("PROJETO.AddTrainer", CN);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@equipa", _team));
            cmd.Parameters.Add(new SqlParameter("@nome", _name));
            cmd.Parameters.Add(new SqlParameter("@especializacao", _espec));
            cmd.Parameters.Add(new SqlParameter("@tatica_pref", _tatica));
            SqlDataReader reader = cmd.ExecuteReader();
            form1.GetTrainers(this);
            CN.Close();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            if (this.textBox1.Text == null || this.comboBox2.Text == null)
            {
                return;
            }

            string name = this.textBox1.Text.ToString();
            string team = this.comboBox1.Text.ToString();
            string especializacao = this.comboBox2.Text.ToString();
            string tatica = this.textBox4.Text.ToString();

            Add_Trainer(name,team,especializacao,tatica);
        }
    }
}
