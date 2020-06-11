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
        //static SqlConnection CN = new SqlConnection("data source = localhost; integrated security = true; initial catalog = master");
        static SqlConnection CN = new SqlConnection("Data Source = " + "tcp:mednat.ieeta.pt" + @"\" + "SQLSERVER,8101" + " ;" + "Initial Catalog = " + "p2g4" + "; uid = " + "p2g4" + ";" + "password = " + "RV{'a~SyES>8_gy[");
        //static SqlConnection CN = new SqlConnection("data source = localhost; integrated security = true; initial catalog = master");
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

        

        private void listBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void textBox2_TextChanged(object sender, EventArgs e)
        {

        }

        

        
    }
}
