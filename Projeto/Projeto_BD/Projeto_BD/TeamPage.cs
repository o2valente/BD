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
        String team;
        public TeamPage()
        {
            InitializeComponent();
            
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
            if (this.textBox1.Text == null || this.textBox2.Text == null)
            {
                return;
            }
            string new_trainer = this.textBox1.Text;
            string old_trainer = this.textBox2.Text;

            changeTrainer(old_trainer,new_trainer);
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
            cmd.Parameters.Add(new SqlParameter("@new_trainer", new_trainer));
            cmd.Parameters.Add(new SqlParameter("@old_trainer", old_trainer));
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
            if (this.textBox3.Text == null || this.textBox4.Text == null || this.textBox5.Text == null)
            {
                return;
            }
            string name = this.textBox5.Text.ToString();
            int shirt_num = Int32.Parse(this.textBox3.Text.ToString());
            string role = this.textBox4.Text.ToString();

            addPlayer(name,shirt_num,role);
        }
    }
}
