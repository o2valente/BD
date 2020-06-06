using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
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
        public TeamPage()
        {
            InitializeComponent();
            
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
    }
}
