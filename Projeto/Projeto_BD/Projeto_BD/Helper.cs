using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Projeto_BD
{
    public class Helper
    {
        private string _initcat;
        private string _uid;
        private string _pass;


        public string Initcat
        {
            get { return _initcat; }
            set { _initcat = "p2g4"; } //alterar aqui
        }



        public string Uid
        {

            get { return _uid; }
            set { _uid = "p2g4"; } //alterar aqui
        }

        public string Pass
        {
            get { return _pass; }
            set { _pass = "RV{'a~SyES>8_gy["; } //alterar aqui
        }

        public Helper()
        {
            Initcat = _initcat;
            Uid = _uid;
            Pass = _pass;
        }
    }
}
