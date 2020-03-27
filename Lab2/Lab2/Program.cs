using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lab2
{
    public class License
    {
        public String Title { get; set; }
        public String PaymentDate { get; set; }
        public String ExpiryDate { get; set; }
        public int SoftwareId { get; set; }
        public int CustomerId { get; set; }
        public License(String title, String paymentDate, String expiryDate, int softwareId, int customerId)
        {
            this.Title = title;
            this.PaymentDate = paymentDate;
            this.ExpiryDate = expiryDate;
            this.SoftwareId = softwareId;
            this.CustomerId = customerId;
        }
    }
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Write command selectAll/selectLENM/insert/update/delete/function/getSetIntersection/getSetUnion/getSetDistance/getSetException");
            using (SqlConnection con = new SqlConnection("Data Source=.\\SQLEXPRESS;Initial Catalog=SoftLicenseManagement;Integrated Security = SSPI"))
            {
                con.Open();
                while (true)
                {
                    String statement = Console.ReadLine();
                    switch (statement)
                    {
                        case "insert":
                            Console.WriteLine("Insert procedure");
                            using (SqlCommand cmd = new SqlCommand("usp_AddLicense", con))
                            {
                                try
                                { 
                                    int outparam = 0;
                                    cmd.CommandType = CommandType.StoredProcedure;
                                    Console.WriteLine("\nEnter title");
                                    cmd.Parameters.AddWithValue("@title", Console.ReadLine());
                                    Console.WriteLine("\nEnter expiry date");
                                    cmd.Parameters.AddWithValue("@expirydate", Convert.ToDateTime(Console.ReadLine()));
                                    Console.WriteLine("\nEnter software ID");
                                    cmd.Parameters.AddWithValue("@softwareId", Convert.ToInt32(Console.ReadLine()));
                                    Console.WriteLine("\nEnter customer ID");
                                    cmd.Parameters.AddWithValue("@customerId", Convert.ToInt32(Console.ReadLine()));
                                    cmd.Parameters.AddWithValue("@licenseId", outparam);
                                    cmd.ExecuteNonQuery();
                                    Console.WriteLine("Insert complete!");
                                }
                                catch(Exception e)
                                {
                                    Console.WriteLine("ERROR! "+ e.Message);
                                }
                            }
                            break;
                        case "update":
                            Console.WriteLine("Update procedure");
                            using (SqlCommand cmd = new SqlCommand("usp_EditLicense", con))
                            {
                                try
                                { 
                                    cmd.CommandType = CommandType.StoredProcedure;
                                    Console.WriteLine("\nEnter id");
                                    cmd.Parameters.AddWithValue("@id", Convert.ToInt64(Console.ReadLine()));
                                    Console.WriteLine("\nEnter title");
                                    cmd.Parameters.AddWithValue("@title", Console.ReadLine());
                                    Console.WriteLine("\nEnter expiry date");
                                    cmd.Parameters.AddWithValue("@expirydate", Convert.ToDateTime(Console.ReadLine()));
                                    Console.WriteLine("\nEnter software ID");
                                    cmd.Parameters.AddWithValue("@softwareId", Convert.ToInt32(Console.ReadLine()));
                                    Console.WriteLine("\nEnter customer ID");
                                    cmd.Parameters.AddWithValue("@customerId", Convert.ToInt32(Console.ReadLine()));
                                    cmd.ExecuteNonQuery();
                                    Console.WriteLine("Update complete!");
                                }
                                catch (Exception e)
                                {
                                    Console.WriteLine("ERROR! "+ e.Message);
                                }
                            }
                            break;
                        case "delete":
                            Console.WriteLine("Delete procedure");
                            using (SqlCommand cmd = new SqlCommand("usp_DeleteLicense", con))
                            {
                                try
                                { 
                                    cmd.CommandType = CommandType.StoredProcedure;
                                    Console.WriteLine("\nEnter id");
                                    cmd.Parameters.AddWithValue("@id", Convert.ToInt64(Console.ReadLine()));
                                    cmd.ExecuteNonQuery();
                                    Console.WriteLine("Delete complete!");
                                }
                                catch(Exception e)
                                {
                                    Console.WriteLine("ERROR! "+ e.Message);
                                }
                            }
                            break;
                        case "selectAll":
                            Console.WriteLine("Select all licenses procedure");
                            using (SqlCommand cmd = new SqlCommand("usp_GetLicenses", con))
                            {
                                try
                                { 
                                    cmd.CommandType = CommandType.StoredProcedure;
                                    SqlDataReader reader = cmd.ExecuteReader();
                                    List<License> licenses = new List<License>();
                                    while(reader.Read())
                                    {
                                        License lic = new License(Convert.ToString(reader[1]), Convert.ToString(reader[2]),
                                            Convert.ToString(reader[3]), Convert.ToInt32(reader[4]), Convert.ToInt32(reader[5]));
                                        licenses.Add(lic);
                                    }
                                    foreach (License lic in licenses)
                                    {
                                        Console.WriteLine(lic.Title + ", " + lic.PaymentDate + ", " + lic.ExpiryDate + ", " + lic.SoftwareId + ", " + lic.CustomerId);
                                    }
                                    reader.Close();
                                }
                                catch (Exception e)
                                {
                                    Console.WriteLine("ERROR! "+ e.Message);
                                }
                            }
                            break;
                        case "selectLENM":
                            Console.WriteLine("Select licenses expire next month procedure");
                            using (SqlCommand cmd = new SqlCommand("usp_GetLicensesExpireNextMonth", con))
                            {
                                try
                                {
                                    cmd.CommandType = CommandType.StoredProcedure;
                                    SqlDataReader reader = cmd.ExecuteReader();
                                    List<License> licenses = new List<License>();
                                    while (reader.Read())
                                    {
                                        License lic = new License(Convert.ToString(reader[1]), Convert.ToString(reader[2]),
                                            Convert.ToString(reader[3]), Convert.ToInt32(reader[4]), Convert.ToInt32(reader[5]));
                                        licenses.Add(lic);
                                    }
                                    foreach (License lic in licenses)
                                    {
                                        Console.WriteLine(lic.Title + ", " + lic.PaymentDate + ", " + lic.ExpiryDate + ", " + lic.SoftwareId + ", " + lic.CustomerId);
                                    }
                                    reader.Close();
                                }
                                catch (Exception e)
                                {
                                    Console.WriteLine("ERROR! "+ e.Message);
                                }
                            }
                            break;
                        case "function":
                            Console.WriteLine("Function total cost of purchased licenses");
                            using (SqlCommand cmd = new SqlCommand("udf_TotalCostOfPurchasedLicenses", con))
                            {
                                try
                                { 
                                    cmd.CommandType = CommandType.StoredProcedure;
                                    SqlParameter returnValue = cmd.Parameters.Add("@sum", SqlDbType.Int);
                                    returnValue.Direction = ParameterDirection.ReturnValue;
                                    cmd.ExecuteNonQuery();
                                    Console.WriteLine(returnValue.Value);
                                }
                                catch (Exception e)
                                {
                                    Console.WriteLine("ERROR! "+ e.Message);
                                }

                            }
                            break;
                        case "getSetIntersection":
                            Console.WriteLine("You are choose Intersection procedure. Please enter two ids.");
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
                            Console.WriteLine("You are choose select procedure. Please enter Typography code.");
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
                            Console.WriteLine("You are choose select procedure. Please enter Typography code.");
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
                            Console.WriteLine("You are choose select procedure. Please enter Typography code.");
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
