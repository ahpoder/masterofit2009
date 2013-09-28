using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
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
                sw.WriteLine("-- Create reference tables");
                sw.WriteLine("CREATE TEMPORARY TABLE tempproductidrefs (refid INTEGER PRIMARY KEY, productid INTEGER NOT NULL);");
                sw.WriteLine("-- Create products");
                var productrefids = new List<int>();
                for (int i = 0; i < 100000; ++i)
                {
                    sw.WriteLine("INSERT INTO products (name,weight) VALUES ('Product " + i + "'," + r.Next(10,100)*10 + ");");
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

                sw.WriteLine("-- Drop reference tables");
                sw.WriteLine("DROP TABLE tempproductidrefs;");

                sw.Close();
                MessageBox.Show("Database population file generated");
            }
        }
    }
}
