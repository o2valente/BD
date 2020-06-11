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
using System.Windows.Forms;

namespace Projeto_BD
{
    public partial class MercadoTransf : Form
    {
        static SqlConnection CN = new SqlConnection("Data Source = " + "tcp:mednat.ieeta.pt" + @"\" + "SQLSERVER,8101" + " ;" + "Initial Catalog = " + "p2g4" + "; uid = " + "p2g4" + ";" + "password = " + "RV{'a~SyES>8_gy[");
        //static SqlConnection CN = new SqlConnection("data source = localhost; integrated security = true; initial catalog = master");
        String team;
        private Form1 f1;

        public MercadoTransf()
        {
            InitializeComponent();
            FillDropDownList();
            //---------------Clubes-----------------
            CN.Open();
            SqlCommand clubesCmd = new SqlCommand("select * from PROJETO.getNomesClube", CN);
            SqlDataReader clubesReader = clubesCmd.ExecuteReader();
            while (clubesReader.Read())
            {
                comboBox4.Items.Add(clubesReader["Nome"]);
            }
            CN.Close();
        }

        
        public void setForm1(Form1 _f1)
        {
            f1 = _f1;
        }

        public void setTeam()
        {
            if (comboBox4.SelectedItem == null)
            {
                return;
            }
            else
            {
                team = comboBox4.SelectedItem.ToString();
            }
            FillSelectedTeamDownList();
        }

        private void MercadoTransf_Load(object sender, EventArgs e)
        {

        }


        private void button1_Click_1(object sender, EventArgs e)
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

            changeTrainer(old_trainer, new_trainer);
            //Form1 form = new Form1();
            //TeamPage tp = new TeamPage();
            //form.GetTeam(team, tp);
        }



        private void changeTrainer(string old_trainer, string new_trainer)
        {
            comboBox1.Text = "";
            comboBox2.Text = "";
            //Debug.WriteLine(team);
            //Debug.WriteLine(old_trainer);
            //Debug.WriteLine(new_trainer);
            
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
            setTeam(); //define a equipa
        }

        private void addPlayer(string name, int num, string role)
        {
            setTeam(); //define a equipa
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

        private void FillSelectedTeamDownList()
        {
            //-------------------Old trainer------------
            CN.Open();
            SqlCommand cmd_2 = new SqlCommand("PROJETO.GetTeamTrainer", CN);
            cmd_2.CommandType = CommandType.StoredProcedure;
            cmd_2.Parameters.Add(new SqlParameter("@equipa", team));
            SqlDataReader reader_2 = cmd_2.ExecuteReader();
            comboBox1.Items.Clear();
            while (reader_2.Read())
            {

                //------------Novo treinador----------
                comboBox1.Items.Add(reader_2["Nome"]);
                comboBox6.Items.Add(reader_2["Especializacao"] + "-" + reader_2["Nome"]);
            }
            CN.Close();

            //------------Jogadores para Remover---------------
            CN.Open();
            SqlCommand jogadoresCmd = new SqlCommand("PROJETO.GetEquipa", CN);
            jogadoresCmd.CommandType = CommandType.StoredProcedure;
            jogadoresCmd.Parameters.Add(new SqlParameter("@Clube", team));
            SqlDataReader jogadoresReader = jogadoresCmd.ExecuteReader();
            while (jogadoresReader.Read())
            {
                comboBox5.Items.Add("Nr: " + jogadoresReader["NrCamisola"] + "-" + jogadoresReader["Nome"] + "-" + jogadoresReader["Posicao"]);
            }
            CN.Close();


        }

        private void FillDropDownList()
        {
            //------------DropDowns Não Editaveis e com Elemento Null--------
            comboBox1.DropDownStyle = ComboBoxStyle.DropDownList;
            comboBox2.DropDownStyle = ComboBoxStyle.DropDownList;
            comboBox3.DropDownStyle = ComboBoxStyle.DropDownList;
            comboBox4.DropDownStyle = ComboBoxStyle.DropDownList;
            comboBox5.DropDownStyle = ComboBoxStyle.DropDownList;
            comboBox6.DropDownStyle = ComboBoxStyle.DropDownList;
            comboBox1.Items.Add("");
            comboBox2.Items.Add("");

            CN.Open();
            SqlCommand cmd = new SqlCommand("PROJETO.NomeTreinadores", CN);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataReader reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                //------------Antigo Treinador--------
                comboBox2.Items.Add(reader["Nome"]);
            }
            CN.Close();

            //----------------Posição------------------
            string[] posicao = { "Atacante", "Medio", "Defesa", "GuardaRedes" };
            comboBox3.Items.AddRange(posicao);

            

            

            
        }

        private void button2_Click_1(object sender, EventArgs e)
        {
            if (this.textBox3.Text == null || this.comboBox3.SelectedItem == null || this.textBox5.Text == null)
            {
                Debug.WriteLine("NULL");
                return;
            }
            string name = this.textBox5.Text.ToString();
            int shirt_num = Int32.Parse(this.textBox3.Text.ToString());
            string role = this.comboBox3.SelectedItem.ToString();
            Debug.WriteLine(team);
            addPlayer(name, shirt_num, role);
            //Form1 form = new Form1();
            //TeamPage tp = new TeamPage();
            //form.GetTeam(team, tp);
        }

        private void comboBox4_SelectedIndexChanged(object sender, EventArgs e)
        {
            
        }

        private void comboBox4_SelectionChangeCommitted(object sender, EventArgs e)
        {
            setTeam();
            ResetComboBox();
            
        }

        private void ReformarJogador(string nome,string team)
        {
            //
            //setTeam(); //define a equipa
            
            CN.Open();
            SqlCommand cmd = new SqlCommand("PROJETO.ReformarJogador", CN);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@nome", nome));
            cmd.Parameters.Add(new SqlParameter("@clube", team));
            cmd.ExecuteReader();
            CN.Close();

        }

        private void ReformarTreinador(string nome,string team)
        {
            CN.Open();
            SqlCommand cmd = new SqlCommand("PROJETO.ReformarTreinador", CN);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@nome",nome));
            cmd.Parameters.Add(new SqlParameter("@equipa",team));
            cmd.ExecuteReader();
            CN.Close();
        }

        private void ResetComboBox()
        {
            comboBox1.Items.Clear();
            comboBox2.Items.Clear();
            comboBox3.Items.Clear();
            //comboBox4.Items.Clear();
            comboBox5.Items.Clear();
            comboBox6.Items.Clear();
            FillSelectedTeamDownList();
            FillDropDownList();
        }

        //remover jogador
        private void button3_Click(object sender, EventArgs e)
        {
            string[] vals = comboBox5.SelectedItem.ToString().Split('-');
            string jogador = vals[1];
            ReformarJogador(jogador,team);
            ResetComboBox();
        }

        //remover treinador
        private void button4_Click(object sender, EventArgs e)
        {
            string[] vals = comboBox6.SelectedItem.ToString().Split('-');
            string treinador = vals[1];
            ReformarTreinador(treinador,team);
            ResetComboBox();
        }
    }
}
