using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace lab4
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Write command getSetIntersection/getSetUnion/getSetDistance/getSetException");
            using (SqlConnection con = new SqlConnection("Data Source=.\\SQLEXPRESS;Initial Catalog=Lab4db;Integrated Security = SSPI"))
            {
                con.Open();
                while (true)
                {
                    String statement = Console.ReadLine();
                    switch (statement)
                    {
                        case "getSetIntersection":
                            using (var comman = con.CreateCommand())
                            {
                                comman.CommandType = CommandType.StoredProcedure;
                                comman.CommandText = "getSetIntersection";
                                comman.Parameters.AddWithValue("@firstRectangle", Console.ReadLine());
                                comman.Parameters.AddWithValue("@secondRectangle", Console.ReadLine());

                                SqlParameter returnValue = comman.Parameters.Add("@ans", SqlDbType.NVarChar);

                                returnValue.Direction = ParameterDirection.ReturnValue;

                                comman.ExecuteNonQuery();
                                Object email = comman.Parameters["@ans"].Value;
                                Console.WriteLine(email.ToString());

                            }
                            Console.WriteLine("Func executed!");
                            break;
                        case "getSetUnion":
                            using (var comman = con.CreateCommand())
                            {
                                comman.CommandType = CommandType.StoredProcedure;
                                comman.CommandText = "getSetUnion";
                                comman.Parameters.AddWithValue("@firstRectangle", Console.ReadLine());
                                comman.Parameters.AddWithValue("@secondRectangle", Console.ReadLine());


                                SqlParameter returnValue = comman.Parameters.Add("@ans", SqlDbType.NVarChar);

                                returnValue.Direction = ParameterDirection.ReturnValue;

                                comman.ExecuteNonQuery();
                                Object email = comman.Parameters["@ans"].Value;
                                Console.WriteLine(email.ToString());
                            }
                            Console.WriteLine("Func executed!");
                            break;
                        case "getSetDistance":
                            using (var comman = con.CreateCommand())
                            {
                                comman.CommandType = CommandType.StoredProcedure;
                                comman.CommandText = "getSetDistance";
                                comman.Parameters.AddWithValue("@firstRectangle", Console.ReadLine());
                                comman.Parameters.AddWithValue("@secondRectangle", Console.ReadLine());


                                SqlParameter returnValue = comman.Parameters.Add("@ans", SqlDbType.Float);

                                returnValue.Direction = ParameterDirection.ReturnValue;

                                comman.ExecuteNonQuery();
                                Object email = comman.Parameters["@ans"].Value;
                                Console.WriteLine(email.ToString());
                            }
                            Console.WriteLine("Func executed!");
                            break;
                        case "getSetException":
                            using (var comman = con.CreateCommand())
                            {
                                comman.CommandType = CommandType.StoredProcedure;
                                comman.CommandText = "getSetException";
                                comman.Parameters.AddWithValue("@firstRectangle", Console.ReadLine());
                                comman.Parameters.AddWithValue("@secondRectangle", Console.ReadLine());


                                SqlParameter returnValue = comman.Parameters.Add("@ans", SqlDbType.Float);

                                returnValue.Direction = ParameterDirection.ReturnValue;

                                comman.ExecuteNonQuery();
                                Object email = comman.Parameters["@ans"].Value;
                                Console.WriteLine(email.ToString());
                            }
                            Console.WriteLine("Func executed!");
                            break;
                        default:
                            Console.WriteLine("Enter correct statement");
                            break;
                    }
                }
            }
        }
    }
}
