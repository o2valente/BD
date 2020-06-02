using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Projeto_BD
{
    public partial class TabelaClassificacao : Form
    {
        static SqlConnection CN = new SqlConnection("Data Source = " + "tcp:mednat.ieeta.pt" + @"\" + "SQLSERVER,8101" + " ;" + "Initial Catalog = " + "p2g4" + "; uid = " + "p2g4" + ";" + "password = " + "RV{'a~SyES>8_gy[");
       

        public TabelaClassificacao()
        {
            InitializeComponent();
            initTable();

        }

        private void initTable()
        {
            List<Label> posicao = new List<Label>();
            CN.Open();
            SqlCommand clubes = new SqlCommand("select * from PROJETO.Clube",CN);
            SqlDataReader reader = clubes.ExecuteReader();
            while (reader.Read())
            {
                for (int i = 0; i< tableLayoutPanel1.RowCount;i++)
                {
                    posicao[i] = new Label
                    {
                        Text = i.ToString()
                    };
                    tableLayoutPanel1.Controls.Add(posicao[i],0,i);
                }
            }
            CN.Close();
        }

        

        public void Clube()
        {
            CN.Open();
            SqlCommand getClube = new SqlCommand("Select * from PROJETO.Clube");
            SqlDataReader reader = getClube.ExecuteReader();
            while (reader.Read())
            {
               
            }
            CN.Close();
        }

       
    }
}
