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
using System.Windows.Navigation;

namespace Projeto_BD
{
    public partial class Form1 : Form
    {
        static SqlConnection CN = new SqlConnection("Data Source = " + "tcp:mednat.ieeta.pt" + @"\" + "SQLSERVER,8101" + " ;" + "Initial Catalog = " + "p2g4" + "; uid = " + "p2g4" + ";" + "password = " + "RV{'a~SyES>8_gy[");
        private int j_nr;
        private System.Data.DataSet dataSet;

        public Form1()
        {
            InitializeComponent();
        }

        public void GetJornada(int nr)
        {
            CN.Open();
            SqlCommand sqlcmd = new SqlCommand("Select * from PROJETO.Jogo where NrJornada=@NrJornada", CN);
            sqlcmd.Parameters.AddWithValue("@NrJornada", nr);
            SqlDataReader reader = sqlcmd.ExecuteReader();
            while (reader.Read())
            {
                listBox1.Items.Add(reader["Clube1"] + " " + reader["Resultado1"] + " - " + reader["Resultado2"] + " " + reader["Clube2"]);
            }
            CN.Close();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            //j_nr = Int32.Parse(this.textBox1.Text);
            
            //GetJornada(j_nr);
        }

        private void button2_Click(object sender, EventArgs e)
        {
            //this.Hide();
            //Form goTabela = new TabelaClassificacao();
            //goTabela.Show();
            this.dataGridView1.Rows.Clear();
            this.dataGridView1.Columns.Clear();
            this.dataGridView1.ColumnCount = 5;
            this.dataGridView1.Columns[0].Width = 100;
            this.dataGridView1.Columns[1].Width = 30;
            this.dataGridView1.Columns[2].Width = 30;
            this.dataGridView1.Columns[3].Width = 30;
            this.dataGridView1.Columns[4].Width = 30;
            this.dataGridView1.Columns[0].Name = "Equipa";
            this.dataGridView1.Columns[1].Name = "Vitórias";
            this.dataGridView1.Columns[2].Name = "Derrotas";
            this.dataGridView1.Columns[3].Name = "Empates";
            this.dataGridView1.Columns[4].Name = "Pontos";

            for (int i = 0; i < 26; i++)
            {
                //dtbl.NewRow. = "Sporting Clube de Portugal " + i + " vitórias";
                string[] row = { "Sporting Clube de Portugal", "23", "2", "6", "87" };
                this.dataGridView1.Rows.Add(row);
            }
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

    }
}
