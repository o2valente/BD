using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;

namespace Projeto_BD
{
    class Club
    {
        static SqlConnection CN = new SqlConnection("data source = localhost; integrated security = true; initial catalog = master");
        private string name;
        private int victories;
        private int losses;
        private int draws;
        private string stadium;

        public Club(string _name, int _victories, int _losses, int _draws, string _stadium)
        {
            name = _name;
            victories = _victories;
            losses = _losses;
            draws = _draws;
            stadium = _stadium;
        }
        public Club(string _name)
        {
            CN.Open();
            SqlCommand sqlcmd = new SqlCommand("PROJETO.GetClub", CN);
            sqlcmd.CommandType = CommandType.StoredProcedure;
            sqlcmd.Parameters.Add(new SqlParameter("@name", _name));
            SqlDataReader reader = sqlcmd.ExecuteReader();
            while (reader.Read())
            {
                victories = Int32.Parse(reader["Victorias"].ToString());
                losses = Int32.Parse(reader["Derrotas"].ToString());
                draws = Int32.Parse(reader["Empates"].ToString());
                stadium = reader["Estadio"].ToString();
            }
            CN.Close();
        }
    }
}
