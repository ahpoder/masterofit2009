using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace DatabaseContentGenerator
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void buttonGenerate_Click(object sender, EventArgs e)
        {
            if (saveFileDialog1.ShowDialog() == DialogResult.OK)
            {
                int startID = string.IsNullOrEmpty(textBox1.Text) ? 1000 : int.Parse(textBox1.Text);

                var r = new Random();

                var productsQuery = new StringBuilder();

                FileStream fs = File.Open(saveFileDialog1.FileName, FileMode.Create, FileAccess.Write, FileShare.None);
                var sw = new StreamWriter(fs);
                sw.WriteLine("\\c webshoptest1");

                sw.WriteLine("-- We do not use temp tables, but rather directly insert the SERIAL number directly - higher performance");

                sw.WriteLine("-- Create products");
                sw.WriteLine("SELECT setval('products_pid_seq', " + (startID - 1) + ");");
                sw.Write("INSERT INTO products (name,weight) VALUES ");
                for (int i = 0; i < 100000; ++i)
                {
                    sw.Write("('Product " + i + "'," + r.Next(10,100)*10 + "),");
                }
                sw.WriteLine("('Product " + 100000 + "'," + r.Next(10, 100) * 10 + ");");

                sw.WriteLine("-- Create product attributes");
                sw.WriteLine("INSERT INTO productattributes VALUES ('productline','string'),('brand','string'),('subbrand','string'),('size','string'),('sizemeasurement','integer'),('colour','string');");

                var colours = new string[] { "red", "white", "green", "blue", "lightblue", "baige", "black", "multicoloured" };

                var productLines = new string[5000];
                for (int i = 0; i < 5000; ++i)
                {
                    productLines[i] = "'Product line " + i + "'";
                }

                var brands = new string[20];
                for (int i = 0; i < 20; ++i)
                {
                    brands[i] = "'Brand " + i + "'";
                }

                sw.Write("INSERT INTO productattributerelations VALUES ");
                for (int i = 0; i < 100000; ++i)
                {
                    int productlineid = r.Next(5001);
                    if (productlineid < 5000)
                        sw.Write("(" + (i + startID) + ", 'productline'," + productLines[productlineid] + "),");
                    int brandid = r.Next(21);
                    if (brandid < 20)
                        sw.Write("(" + (i + startID) + ", 'brand'," + brands[brandid] + "),");
                    int size = r.Next(80);
                    if (size < 10)
                        sw.Write("(" + (i + startID) + ", 'size','XXS'),");
                    else if (size < 20)
                        sw.Write("(" + (i + startID) + ", 'size','XS'),");
                    else if (size < 30)
                        sw.Write("(" + (i + startID) + ", 'size','S'),");
                    else if (size < 40)
                        sw.Write("(" + (i + startID) + ", 'size','M'),");
                    else if (size < 50)
                        sw.Write("(" + (i + startID) + ", 'size','L'),");
                    else if (size < 60)
                        sw.Write("(" + (i + startID) + ", 'size','XL'),");
                    else if (size < 70)
                        sw.Write("(" + (i + startID) + ", 'size','XXL'),");
                    else
                        sw.Write("(" + (i + startID) + ", 'size','XXXL'),");
                    sw.Write("(" + (i + startID) + ", 'sizemeasurement'," + size + "),");
                    sw.Write("(" + (i + startID) + ", 'colour','" + colours[r.Next(colours.Length)] + "'),");
                }
                sw.WriteLine("(" + (100000 + startID) + ", 'colour','" + colours[r.Next(colours.Length)] + "');");

                var currency = new string[] { "DKK", "EUR", "USD", "GBP", "AUD", "INR", "AED", "CAD", "CHF", "CNY" };

                sw.WriteLine("-- Create manufactorers");
                sw.Write("INSERT INTO manufactorer VALUES ");

                for (int i = 1; i < 10; ++i)
                {
                    sw.Write("('MA010203" + i.ToString("00") + "','My manufactorer " + i + "','" + currency[r.Next(currency.Length)] + "'),");
                }
                sw.WriteLine("('MA01020310','Last manufactorer inc.','" + currency[r.Next(currency.Length)] + "');");

                sw.WriteLine("-- Create pricing plan");

                var termsofdelivery = new string[] { "abLager", "SideOfShip", "3month", "14dg", "7dg", "1dg" };

                sw.WriteLine("SELECT setval('pricingplans_id_seq', " + (startID + 1) + ");");
                sw.Write("INSERT INTO pricingplans (price,discount,deliveryconditions) VALUES ");
                for (int i = 0; i < 10000; ++i)
                {
                    sw.Write("(" + (r.NextDouble() * 1000 + 100).ToString("F", CultureInfo.InvariantCulture) +
                                 ",0.0,'" + termsofdelivery[r.Next(termsofdelivery.Length)] + "'),");
                }

                for (int i = 0; i < 9999; ++i)
                {
                    sw.Write("(" + (r.NextDouble() * 1000 + 100).ToString("F", CultureInfo.InvariantCulture) +
                                 "," + (r.NextDouble() * 20).ToString("F", CultureInfo.InvariantCulture) + ",'" + termsofdelivery[r.Next(termsofdelivery.Length)] + "'),");
                }
                sw.WriteLine("(129.56,0.0,'SideOfShip');");

                sw.Write("INSERT INTO quantitydiscounts VALUES ");
                for (int i = 0; i < 2000; ++i)
                {
                    sw.Write("(" + ((i * 10) + startID) + ",10,0.1),");
                    sw.Write("(" + ((i * 10) + startID) + ",50,0.2),");
                    sw.Write("(" + ((i * 10) + startID) + ",100,0.3),");
                    sw.Write("(" + ((i * 10) + startID) + ",500,0.4),");
                    sw.Write("(" + ((i * 10) + startID) + ",1000,0.5),");
                }
                sw.WriteLine("(" + (startID + 1) + ",10,0.1);");

                sw.WriteLine("-- Create manufactorer products");

                var mp = new Dictionary<string, List<int>>();

                sw.Write("INSERT INTO manufactorerproducts VALUES ");
                for (int i = startID; i < (100000 + startID - 1); ++i)
                {
                    int id = r.Next(11);
                    string m1 = "MA010203" + id.ToString("00");
                    sw.Write("('" + m1 + "'," + i + "," + r.Next(startID, 20000 + startID) + "),");
                    List<int> pids;
                    if (!mp.TryGetValue(m1, out pids))
                    {
                        pids = new List<int>();
                        mp.Add(m1, pids);
                    }
                    pids.Add(i);
                    if (r.Next(100) < 10)
                    {
                        int id2 = r.Next(10);
                        if (id != id2)
                        {
                            string m2 = "MA010203" + id2.ToString("00");
                            sw.Write("('" + m2 + "'," + i + "," + r.Next(startID, 20000 + startID) + "),");
                            if (!mp.TryGetValue(m2, out pids))
                            {
                                pids = new List<int>();
                                mp.Add(m2, pids);
                            }
                            pids.Add(i);
                        }
                    }
                }
                sw.WriteLine("('MA01020310'," + (100000 + startID - 1) + "," +
                            r.Next(startID, 20000 + startID) + ");");
                List<int> pidsX;
                if (!mp.TryGetValue("MA01020310", out pidsX))
                {
                    pidsX = new List<int>();
                    mp.Add("MA01020310", pidsX);
                }

                sw.WriteLine("-- We cheat and create the orders in reverse order to be able to create the order in one go");

                sw.WriteLine("-- Create manufactorer orders"); // This should match the producted products

                sw.WriteLine("SELECT setval('manufactorerorders_orderid_seq', " + (startID - 1) + ");");
                var oids = new Dictionary<int, List<int>>();
                sw.Write("INSERT INTO manufactorerorders VALUES ");
                var manufactorerOrderProducts = new StringBuilder("INSERT INTO manufactorerorderedproducts VALUES ");
                var manufactorerCOC = new StringBuilder("INSERT INTO manufactorerorderconfirmations VALUES ");
                var manufactorerInvoice = new StringBuilder("INSERT INTO manufactorerinvoices VALUES ");
                var manufactorerDelivery = new StringBuilder("INSERT INTO manufactorerdeliveries VALUES ");
                int orderid = startID;
                foreach (KeyValuePair<string,List<int>> mm in mp)
                {
                    int ordercount = r.Next(15) + 1;
                    for (int j = 0; j < ordercount; ++j)
                    {
                        int productcount = r.Next(10) + 1;
                        sw.Write("(" + );
                        foreach (int pid in mm.Value)
                        {
                            
                        }
                    }
                }

                // Product updates will be very slow.

INSERT INTO manufactorerorders (manufactorerid,orderdate) VALUES ('CN34554345',CURRENT_DATE); 
-- This is a trick to the code can be executed in sequence, but in reality it would be an insert with a select of the id followed by another INSERT controlled by the application
UPDATE tempidcollection SET morderid=LASTVAL();
INSERT INTO manufactorerorderedproducts (orderid,productid,priceingplanid,count) SELECT morderid, productid, mpricingplanid, 1200 FROM tempidcollection;


                sw.Write("INSERT INTO manufactorerorderedproducts VALUES ");

                sw.Close();
                MessageBox.Show("Database population file generated");
            }
        }

        private void oldGenerateWithTempTables(object sender, EventArgs e)
        {
            if (saveFileDialog1.ShowDialog() == DialogResult.OK)
            {
                var r = new Random();
                FileStream fs = File.Open(saveFileDialog1.FileName, FileMode.Create, FileAccess.Write, FileShare.None);
                var sw = new StreamWriter(fs);
                sw.WriteLine("\\c webshoptest1");
                sw.WriteLine("-- Create reference tables");
                sw.WriteLine("CREATE TEMPORARY TABLE tempproductidrefs (refid INTEGER PRIMARY KEY, productid INTEGER NOT NULL);");
                sw.WriteLine("CREATE TEMPORARY TABLE temppricingplanidrefs (refid INTEGER PRIMARY KEY, pricingplanid INTEGER NOT NULL);");

                sw.WriteLine("-- Create products");
                var productrefids = new List<int>();
                for (int i = 0; i < 100000; ++i)
                {
                    sw.WriteLine("INSERT INTO products (name,weight) VALUES ('Product " + i + "'," + r.Next(10, 100) * 10 + ");");
                    sw.WriteLine("INSERT INTO tempproductidrefs VALUES (" + i + ", LASTVAL());");
                    productrefids.Add(i);
                }

                sw.WriteLine("-- Create product attributes");
                sw.WriteLine("INSERT INTO productattributes VALUES ('productline','string');");
                sw.WriteLine("INSERT INTO productattributes VALUES ('brand','string');");
                sw.WriteLine("INSERT INTO productattributes VALUES ('subbrand','string');");
                sw.WriteLine("INSERT INTO productattributes VALUES ('size','string');");
                sw.WriteLine("INSERT INTO productattributes VALUES ('sizemeasurement','integer');");
                sw.WriteLine("INSERT INTO productattributes VALUES ('colour','string');");

                var colours = new string[] { "red", "white", "green", "blue", "lightblue", "baige", "black", "multicoloured" };

                var productLines = new string[5000];
                for (int i = 0; i < 5000; ++i)
                {
                    productLines[i] = "'Product line " + i + "'";
                }

                var brands = new string[20];
                for (int i = 0; i < 20; ++i)
                {
                    brands[i] = "'Brand " + i + "'";
                }

                for (int i = 0; i < 100000; ++i)
                {
                    int productlineid = r.Next(5001);
                    if (productlineid < 5000)
                        sw.WriteLine("INSERT INTO productattributerelations SELECT productid, 'productline'," +
                                 productLines[productlineid] + " FROM tempproductidrefs WHERE refid=" + i + ";");
                    int brandid = r.Next(21);
                    if (brandid < 20)
                        sw.WriteLine("INSERT INTO productattributerelations SELECT productid, 'brand'," +
                                 brands[brandid] + " FROM tempproductidrefs WHERE refid=" + i + ";");
                    int size = r.Next(80);
                    if (size < 10)
                        sw.WriteLine("INSERT INTO productattributerelations SELECT productid, 'size','XXS' FROM tempproductidrefs WHERE refid=" + i + ";");
                    else if (size < 20)
                        sw.WriteLine("INSERT INTO productattributerelations SELECT productid, 'size','XS' FROM tempproductidrefs WHERE refid=" + i + ";");
                    else if (size < 30)
                        sw.WriteLine("INSERT INTO productattributerelations SELECT productid, 'size','S' FROM tempproductidrefs WHERE refid=" + i + ";");
                    else if (size < 40)
                        sw.WriteLine("INSERT INTO productattributerelations SELECT productid, 'size','M' FROM tempproductidrefs WHERE refid=" + i + ";");
                    else if (size < 50)
                        sw.WriteLine("INSERT INTO productattributerelations SELECT productid, 'size','L' FROM tempproductidrefs WHERE refid=" + i + ";");
                    else if (size < 60)
                        sw.WriteLine("INSERT INTO productattributerelations SELECT productid, 'size','XL' FROM tempproductidrefs WHERE refid=" + i + ";");
                    else if (size < 70)
                        sw.WriteLine("INSERT INTO productattributerelations SELECT productid, 'size','XXL' FROM tempproductidrefs WHERE refid=" + i + ";");
                    else
                        sw.WriteLine("INSERT INTO productattributerelations SELECT productid, 'size','XXXL' FROM tempproductidrefs WHERE refid=" + i + ";");
                    sw.WriteLine("INSERT INTO productattributerelations SELECT productid, 'sizemeasurement'," +
                                 size + " FROM tempproductidrefs WHERE refid=" + i + ";");
                    sw.WriteLine("INSERT INTO productattributerelations SELECT productid, 'colour','" +
                                 colours[r.Next(colours.Length)] + "' FROM tempproductidrefs WHERE refid=" + i + ";");
                }

                var currency = new string[] { "DKK", "EUR", "USD", "GBP", "AUD", "INR", "AED", "CAD", "CHF", "CNY" };

                sw.WriteLine("-- Create manufactorers");
                sw.Write("INSERT INTO manufactorer VALUES ");

                for (int i = 1; i < 10; ++i)
                {
                    sw.Write("('MA010203" + i.ToString("00") + "','My manufactorer " + i + "','" + currency[r.Next(currency.Length)] + "'),");
                }
                sw.WriteLine("('MA01020310','Last manufactorer inc.','" + currency[r.Next(currency.Length)] + "');");

                sw.WriteLine("-- Create pricing plan");

                var termsofdelivery = new string[] { "abLager", "SideOfShip", "3month", "14dg", "7dg", "1dg" };

                for (int i = 0; i < 10000; ++i)
                {
                    sw.WriteLine("INSERT INTO pricingplans (price,discount,deliveryconditions) VALUES (" + 100 + i % 3001 +
                                 ",0.0,'" + termsofdelivery[r.Next(termsofdelivery.Length)] + "');");
                    sw.WriteLine("INSERT INTO temppricingplanidrefs VALUES (" + i + ",LASTVAL());");
                }
                sw.WriteLine("INSERT INTO pricingplans (price,discount,deliveryconditions) VALUES (129.56,0.0,'SideOfShip');");
                sw.WriteLine("INSERT INTO quantitydiscounts SELECT pricingplanid,10,0.1 FROM temppricingplanidrefs WHERE refid>100 AND refid<200");
                sw.WriteLine("INSERT INTO quantitydiscounts SELECT pricingplanid,50,0.2 FROM temppricingplanidrefs WHERE refid>100 AND refid<200");
                sw.WriteLine("INSERT INTO quantitydiscounts SELECT pricingplanid,100,0.3 FROM temppricingplanidrefs WHERE refid>100 AND refid<200");
                sw.WriteLine("INSERT INTO quantitydiscounts SELECT pricingplanid,500,0.4 FROM temppricingplanidrefs WHERE refid>100 AND refid<200");
                sw.WriteLine("INSERT INTO quantitydiscounts SELECT pricingplanid,1000,0.5 FROM temppricingplanidrefs WHERE refid>100 AND refid<200");

                sw.WriteLine("-- Create manufactorer products");

                sw.WriteLine("-- Drop reference tables");
                sw.WriteLine("DROP TABLE tempproductidrefs;");

                sw.Close();
                MessageBox.Show("Database population file generated");
            }
        }


    }
}
