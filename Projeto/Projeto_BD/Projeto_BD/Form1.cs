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
    public partial class Form1 : Form
    {
        static SqlConnection CN = new SqlConnection("Data Source = " + "tcp:mednat.ieeta.pt" + @"\" + "SQLSERVER,8101" + " ;" + "Initial Catalog = " + "p2g4" + "; uid = " + "p2g4" + ";" + "password = " + "RV{'a~SyES>8_gy[");
        
        public Form1()
        {
            InitializeComponent();
            
            
        }

        public void GetJornada(String nr)
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
            var nr = textBox1.Text;
            listBox1.Items.Clear();
            GetJornada(nr);
        }

       
        private void textBox1_TextChanged(object sender, EventArgs e)
        {
            if (System.Text.RegularExpressions.Regex.IsMatch(textBox1.Text, "[^0-9]"))
            {
                MessageBox.Show("Please enter only numbers.");
                textBox1.Text = textBox1.Text.Remove(textBox1.Text.Length - 1);


            }
            
           
        }

        
    }
}
