using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using System.Runtime.InteropServices;
using System.IO;

public partial class StoredProcedures
    {
        [SqlProcedure]
        public static void GetLicenses(SqlDateTime dateStart, SqlDateTime dateEnd)
        {
            SqlConnection conn = new SqlConnection("Context Connection=true");
            conn.Open();
            SqlCommand sqlCmd = conn.CreateCommand();
            sqlCmd.Parameters.AddWithValue("@dateStart", dateStart);
            sqlCmd.Parameters.AddWithValue("@dateEnd", dateEnd);

            sqlCmd.CommandText = @"select [TotalSum], [The Witcher], [Sims 4], [GTA], [God Of War] FROM
              (select 'sum' as 'TotalSum', name, price from software s inner join Licenses l on s.Id=l.SoftwareId 
                where l.PaymentDate between @dateStart AND @dateEnd) x
              PIVOT
              (SUM(price)
              FOR name 
              IN  ([The Witcher], [Sims 4], [GTA], [God Of War])) y;";

            SqlContext.Pipe.ExecuteAndSend(sqlCmd);
            conn.Close();
        }
    }
