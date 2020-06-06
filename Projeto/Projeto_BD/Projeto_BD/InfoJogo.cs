using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Projeto_BD
{
    public partial class InfoJogo : Form
    {
        public InfoJogo()
        {
            InitializeComponent();
        }

        public ListBox getList()
        {
            return this.listBox1;
        }

        private void InfoJogo_Load(object sender, EventArgs e)
        {

        }

        private void listBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}
