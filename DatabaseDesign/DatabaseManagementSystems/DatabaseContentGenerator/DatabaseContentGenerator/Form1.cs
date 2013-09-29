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
                var r = new Random();
                FileStream fs = File.Open(saveFileDialog1.FileName, FileMode.Create, FileAccess.Write, FileShare.None);
                var sw = new StreamWriter(fs);
                sw.WriteLine("\\c webshoptest1");

                sw.WriteLine("-- We do not use temp tables, but rather directly insert the SERIAL number directly - higher performance");

                sw.WriteLine("-- Create products");
                sw.WriteLine("SELECT setval('products_pid_seq', 999);");
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
                        sw.Write("(" + (i + 1000) + ", 'productline'," + productLines[productlineid] + "),");
                    int brandid = r.Next(21);
                    if (brandid < 20)
                        sw.Write("(" + (i + 1000) + ", 'brand'," + brands[brandid] + "),");
                    int size = r.Next(80);
                    if (size < 10)
                        sw.Write("(" + (i + 1000) + ", 'size','XXS'),");
                    else if (size < 20)
                        sw.Write("(" + (i + 1000) + ", 'size','XS'),");
                    else if (size < 30)
                        sw.Write("(" + (i + 1000) + ", 'size','S'),");
                    else if (size < 40)
                        sw.Write("(" + (i + 1000) + ", 'size','M'),");
                    else if (size < 50)
                        sw.Write("(" + (i + 1000) + ", 'size','L'),");
                    else if (size < 60)
                        sw.Write("(" + (i + 1000) + ", 'size','XL'),");
                    else if (size < 70)
                        sw.Write("(" + (i + 1000) + ", 'size','XXL'),");
                    else
                        sw.Write("(" + (i + 1000) + ", 'size','XXXL'),");
                    sw.Write("(" + (i + 1000) + ", 'sizemeasurement'," + size + "),");
                    sw.Write("(" + (i + 1000) + ", 'colour','" + colours[r.Next(colours.Length)] + "'),");
                }
                sw.WriteLine("(" + (100000 + 1000) + ", 'colour','" + colours[r.Next(colours.Length)] + "');");

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

                sw.WriteLine("SELECT setval('pricingplans_id_seq', 999);");
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
                    sw.Write("(" + ((i * 10) + 1000) + ",10,0.1),");
                    sw.Write("(" + ((i * 10) + 1000) + ",50,0.2),");
                    sw.Write("(" + ((i * 10) + 1000) + ",100,0.3),");
                    sw.Write("(" + ((i * 10) + 1000) + ",500,0.4),");
                    sw.Write("(" + ((i * 10) + 1000) + ",1000,0.5),");
                }
                sw.Write("(1001,10,0.1);");

                sw.WriteLine("-- Create manufactorer products");

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
