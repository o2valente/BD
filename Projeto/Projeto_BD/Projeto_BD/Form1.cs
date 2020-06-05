﻿using System;
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
using System.Windows.Navigation;

namespace Projeto_BD
{
    public partial class Form1 : Form
    {
        //static SqlConnection CN = new SqlConnection("Data Source = " + "tcp:mednat.ieeta.pt" + @"\" + "SQLSERVER,8101" + " ;" + "Initial Catalog = " + "p2g4" + "; uid = " + "p2g4" + ";" + "password = " + "RV{'a~SyES>8_gy[");
        static SqlConnection CN = new SqlConnection("data source = localhost; integrated security = true; initial catalog = master");
        private int j_nr;
        private System.Data.DataSet dataSet;

        public Form1()
        {
            InitializeComponent();
        }

        public void GetJornada(int nr)
        {
            CN.Open();
            //SqlCommand sqlcmd = new SqlCommand("Select * from PROJETO.Jogo where NrJornada=@NrJornada", CN);
            //sqlcmd.Parameters.AddWithValue("@NrJornada", nr);
            SqlCommand sqlcmd = new SqlCommand("PROJETO.GetJornada", CN);
            sqlcmd.CommandType = CommandType.StoredProcedure;
            sqlcmd.Parameters.Add(new SqlParameter("@nr", nr));
            SqlDataReader reader = sqlcmd.ExecuteReader();
            listBox1.Items.Clear();
            while (reader.Read())
            {
                listBox1.Items.Add(reader["NrJogo"]+":" + " "+ reader["Clube1"] + " " + reader["Resultado1"] + " - " + reader["Resultado2"] + " " + reader["Clube2"]);
            }
            CN.Close();
        }

        private void listBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            string sel = listBox1.SelectedItem.ToString();
            string[] vals = sel.Split(':');
            int nrJogo=Int32.Parse(vals[0]);
            CN.Open();
            SqlCommand cmd = new SqlCommand("PROJETO.infoJogo", CN);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@nr",nrJogo));
            CN.Close();
            InfoJogo info = new InfoJogo();
            GetInfoJogo(nrJogo,info);
            info.Show();
        }

        private void GetInfoJogo(int nrJogo,InfoJogo form)
        {
            CN.Open();
            SqlCommand cmd = new SqlCommand("PROJETO.infoJogo",CN);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@nr",nrJogo));
            SqlDataReader reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                form.getList().Items.Add("Arbitro Principal: "+reader["a"]);
                form.getList().Items.Add("Arbitro Linha: " + reader["al1"]);
                form.getList().Items.Add("Arbitro Linha: " + reader["al2"]);
                form.getList().Items.Add("Quarto Arbitro: " + reader["qa"]);
                form.getList().Items.Add("Estadio: " + reader["estadio"]);
                form.getList().Items.Add("Numero Espetadores: " + reader["espetadores"]);
            }
            CN.Close();
        }

        private void GetTeam(string teamName, TeamPage form)
        {
            CN.Open();
            SqlCommand sqlcmd = new SqlCommand("PROJETO.GetEquipa", CN);
            sqlcmd.CommandType = CommandType.StoredProcedure;
            sqlcmd.Parameters.Add(new SqlParameter("@Clube", teamName));
            SqlDataReader reader = sqlcmd.ExecuteReader();
            form.getList().Items.Clear();
            while (reader.Read())
            {
                form.getList().Items.Add(reader["Nome"] + " - " + reader["NrCamisola"] + " " + reader["Posicao"] + " " + reader["clube"]);
            }
            CN.Close();
        }

        //private void GetTeamGrid(string team/*, TeamGrid tgrid*/)
        //{
        //    DataSet ds = new DataSet();
        //    try
        //    {
        //        CN.Open();
        //        SqlCommand cmd = new SqlCommand("GetEquipa", CN);
        //        cmd.CommandType = CommandType.StoredProcedure;
        //        cmd.Parameters.AddWithValue("@Clube", team);
        //        SqlDataAdapter da = new SqlDataAdapter(cmd);
        //        da.Fill(ds);
        //        //tgrid.getGrid().DataSource = ds;
        //    }
        //    catch (Exception ex)
        //    {
        //    }
        //    finally
        //    {
        //        CN.Close();
        //    }
        //}


        private void button1_Click(object sender, EventArgs e)
        {
            if(this.textBox1.Text == null)
            {
                return;
            }
            j_nr = Int32.Parse(this.textBox1.Text);
            
            GetJornada(j_nr);
        }

        private void button2_Click(object sender, EventArgs e)
        {
            //this.Hide();
            //Form goTabela = new TabelaClassificacao();
            //goTabela.Show();
            this.dataGridView1.Rows.Clear();
            this.dataGridView1.Columns.Clear();
            this.dataGridView1.AllowUserToResizeColumns = false;
            this.dataGridView1.AllowUserToResizeRows = false;
            this.dataGridView1.MultiSelect = false;
            this.dataGridView1.ColumnCount = 5;
            this.dataGridView1.Columns[0].Width = 130;
            this.dataGridView1.Columns[1].Width = 50;
            this.dataGridView1.Columns[2].Width = 50;
            this.dataGridView1.Columns[3].Width = 50;
            this.dataGridView1.Columns[4].Width = 50;
            this.dataGridView1.Columns[0].Name = "Equipa";
            this.dataGridView1.Columns["Equipa"].ReadOnly = true;
            this.dataGridView1.Columns[1].Name = "Pontos";
            this.dataGridView1.Columns["Pontos"].ReadOnly = true;
            this.dataGridView1.Columns[2].Name = "Vitórias";
            this.dataGridView1.Columns["Vitórias"].ReadOnly = true;
            this.dataGridView1.Columns[3].Name = "Derrotas";
            this.dataGridView1.Columns["Derrotas"].ReadOnly = true;
            this.dataGridView1.Columns[4].Name = "Empates";
            this.dataGridView1.Columns["Empates"].ReadOnly = true;
            

            this.dataGridView1.Rows.Clear();

            CN.Open();
            SqlCommand cmd = new SqlCommand("PROJETO.TabelaClass",CN);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataReader reader = cmd.ExecuteReader();

            List<string[]> rows = new List<string[]>();

            while (reader.Read())
            {
                string[] row = { reader["nome"].ToString(), reader["pontos"].ToString(), reader["vitorias"].ToString(), reader["derrotas"].ToString(), reader["empates"].ToString() };
                rows.Add(row);
            }

            CN.Close();
            for (int i = 0; i < 18; i++)
            {
                //dtbl.NewRow. = "Sporting Clube de Portugal " + i + " vitórias";
                this.dataGridView1.RowHeadersVisible = false;
                string[] row = rows.ElementAt(i);
                int drow = this.dataGridView1.Rows.Add(row);
                Debug.WriteLine(drow);
            }
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            Debug.WriteLine("ola");
            DataGridView dview = (DataGridView)sender;
            TeamPage Teamform = new TeamPage();
            GetTeam(dview.SelectedCells[0].Value.ToString(), Teamform);
            Teamform.ShowDialog();
        }

        private void dataGridView1_CellClick(object sender, DataGridViewCellEventArgs e)
        {
           
        }

        private void False(object sender, EventArgs e)
        {

        }

        private void dataGridView1_DoubleClick(object sender, EventArgs e)
        {
            

            // StoredProcedure
            //TeamGrid tGrid = new TeamGrid();
            //GetTeamGrid(dview.SelectedCells[0].Value.ToString(), tGrid);
            //tGrid.ShowDialog();

        }

        
    }
}