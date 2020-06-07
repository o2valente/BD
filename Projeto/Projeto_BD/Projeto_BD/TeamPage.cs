using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls;
using System.Windows.Forms;

namespace Projeto_BD
{
    public partial class TeamPage : Form
    {
        static SqlConnection CN = new SqlConnection("data source = localhost; integrated security = true; initial catalog = master");
        //static SqlConnection CN = new SqlConnection("Data Source = " + "tcp:mednat.ieeta.pt" + @"\" + "SQLSERVER,8101" + " ;" + "Initial Catalog = " + "p2g4" + "; uid = " + "p2g4" + ";" + "password = " + "RV{'a~SyES>8_gy[");
        //static SqlConnection CN = new SqlConnection("data source = localhost; integrated security = true; initial catalog = master");
        String team;
        public TeamPage()
        {
            InitializeComponent();
            FillDropDownList();


        }
       
        public void setTeam(String _team)
        {
            team = _team;
        }
        public DataGridView getGrid()
        {
            return this.dataGridView1;
        }

        public System.Windows.Forms.Label GetLabelNomeClube()
        {
            return this.nomeClube;
        }

        public System.Windows.Forms.Label getlabelEstadio()
        {
            return this.labelEstadio;
        }

        public System.Windows.Forms.ListBox getDirecao()
        {
            return this.listBox1;
        }

        public System.Windows.Forms.ListBox getTrofeu()
        {
            return this.listBox2;
        }

        public void gridInnit()
        {
            //this.dataGridView1.Rows.Clear();
            //this.dataGridView1.Columns.Clear();
            this.dataGridView1.AllowUserToResizeColumns = false;
            this.dataGridView1.AllowUserToResizeRows = false;
            //this.dataGridView1.MultiSelect = false;
            this.dataGridView1.ColumnCount = 3;
            this.dataGridView1.Columns[0].Width = 130;
            this.dataGridView1.Columns[1].Width = 50;
            this.dataGridView1.Columns[2].Width = 80;
            this.dataGridView1.Columns[0].Name = "Nome";
            this.dataGridView1.Columns["Nome"].ReadOnly = true;
            this.dataGridView1.Columns[1].Name = "Camisola";
            this.dataGridView1.Columns["Camisola"].ReadOnly = true;
            this.dataGridView1.Columns[2].Name = "Posição";
            this.dataGridView1.Columns["Posição"].ReadOnly = true;
        }

        private void TeamPage_Load(object sender, EventArgs e)
        {
            

        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (this.comboBox2.SelectedItem == null && this.comboBox1.SelectedItem == null)
            {
                return;
            }
            string old_trainer = null;
            string new_trainer = null;

            if (this.comboBox1.SelectedItem != null)
            {
                old_trainer = this.comboBox1.SelectedItem.ToString();
            }
            if (this.comboBox2.SelectedItem != null)
            {
                new_trainer = this.comboBox2.SelectedItem.ToString();
            }
            
            changeTrainer(old_trainer,new_trainer);
            Form1 form = new Form1();
            form.GetTeam(team,this);
        }

        private void changeTrainer(string old_trainer,string new_trainer)
        {
            Debug.WriteLine(team);
            Debug.WriteLine(old_trainer);
            Debug.WriteLine(new_trainer);
            CN.Open();
            SqlCommand cmd = new SqlCommand("PROJETO.Change_Trainer", CN);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@equipa", team));
            
            if (new_trainer == null)
            {
                cmd.Parameters.Add(new SqlParameter("@new_trainer", "NULL"));
            }
            else
            {
                cmd.Parameters.Add(new SqlParameter("@new_trainer", new_trainer));
            }

            if (old_trainer == null)
            {
                cmd.Parameters.Add(new SqlParameter("@old_trainer", "NULL"));
            }
            else
            {
                cmd.Parameters.Add(new SqlParameter("@old_trainer", old_trainer));
            }
            
            SqlDataReader reader = cmd.ExecuteReader();
            CN.Close();
        }

        private void addPlayer(string name,int num,string role)
        {
            CN.Open();
            SqlCommand cmd = new SqlCommand("PROJETO.AddPlayer", CN);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@nome", name));
            cmd.Parameters.Add(new SqlParameter("@camisola", num));
            cmd.Parameters.Add(new SqlParameter("@posicao", role));
            cmd.Parameters.Add(new SqlParameter("@equipa", team));
            SqlDataReader reader = cmd.ExecuteReader();
            CN.Close();
        }

        private void listBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void textBox2_TextChanged(object sender, EventArgs e)
        {

        }

        private void button2_Click(object sender, EventArgs e)
        {
            if (this.textBox3.Text == null || this.comboBox3.SelectedItem == null || this.textBox5.Text == null)
            {
                return;
            }
            string name = this.textBox5.Text.ToString();
            int shirt_num = Int32.Parse(this.textBox3.Text.ToString());
            string role = this.comboBox3.SelectedItem.ToString();

            addPlayer(name,shirt_num,role);
            Form1 form = new Form1();
            form.GetTeam(team, this);
        }

        private void FillDropDownList()
        {
            CN.Open();
            SqlCommand cmd = new SqlCommand("PROJETO.NomeTreinadores",CN);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataReader reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                //------------Antigo Treinador--------
                comboBox1.Items.Add(reader["Nome"]);
                //------------Novo treinador----------
                comboBox2.Items.Add(reader["Nome"]);
            }
            CN.Close();

            //----------------Posição------------------
            string[] posicao = { "Atacante", "Medio","Defesa","Guarda-Redes" };
            comboBox3.Items.AddRange(posicao);


        }
    }
}
