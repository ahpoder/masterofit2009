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
using System.Security.Cryptography;

namespace DatabaseContentGenerator
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private string GetRandomString(Random r)
        {
            var randBuffer = new byte[128];
            RandomNumberGenerator.Create().GetBytes(randBuffer);
//            return Convert.ToBase64String(randBuffer).Remove(512);
            return Convert.ToBase64String(randBuffer);
        }

        private void buttonGenerate_Click(object sender, EventArgs e)
        {
            if (saveFileDialog1.ShowDialog() == DialogResult.OK)
            {
                int startID = string.IsNullOrEmpty(textBox1.Text) ? 1000 : int.Parse(textBox1.Text);

                var r = new Random();

                // Products cannot be added until later as we need to calculate the count

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

                // Create product attribute relations
                var productattributerelations = new StringBuilder("INSERT INTO productattributerelations VALUES ");
                for (int i = 0; i < 100000; ++i)
                {
                    int productlineid = r.Next(5001);
                    if (productlineid < 5000)
                        productattributerelations.Append("(" + (i + startID) + ", 'productline'," + productLines[productlineid] + "),");
                    int brandid = r.Next(21);
                    if (brandid < 20)
                        productattributerelations.Append("(" + (i + startID) + ", 'brand'," + brands[brandid] + "),");
                    int size = r.Next(80);
                    if (size < 10)
                        productattributerelations.Append("(" + (i + startID) + ", 'size','XXS'),");
                    else if (size < 20)
                        productattributerelations.Append("(" + (i + startID) + ", 'size','XS'),");
                    else if (size < 30)
                        productattributerelations.Append("(" + (i + startID) + ", 'size','S'),");
                    else if (size < 40)
                        productattributerelations.Append("(" + (i + startID) + ", 'size','M'),");
                    else if (size < 50)
                        productattributerelations.Append("(" + (i + startID) + ", 'size','L'),");
                    else if (size < 60)
                        productattributerelations.Append("(" + (i + startID) + ", 'size','XL'),");
                    else if (size < 70)
                        productattributerelations.Append("(" + (i + startID) + ", 'size','XXL'),");
                    else
                        productattributerelations.Append("(" + (i + startID) + ", 'size','XXXL'),");
                    productattributerelations.Append("(" + (i + startID) + ", 'sizemeasurement'," + size + "),");
                    productattributerelations.Append("(" + (i + startID) + ", 'colour','" + colours[r.Next(colours.Length)] + "'),");
                }
                productattributerelations.Length -= 1;

                var currency = new string[] { "DKK", "EUR", "USD", "GBP", "AUD", "INR", "AED", "CAD", "CHF", "CNY" };

                // Create manufactorers
                var manufactorer = new StringBuilder("INSERT INTO manufactorer VALUES ");

                for (int i = 0; i < 10; ++i)
                {
                    manufactorer.Append("('MA010203" + i.ToString("00") + "','My manufactorer " + i + "','" + currency[r.Next(currency.Length)] + "'),");
                }
                manufactorer.Length -= 1;

                var termsofdelivery = new string[] { "abLager", "SideOfShip", "3month", "14dg", "7dg", "1dg" };

                // Create pricing plans
                var pricingplans = new StringBuilder("SELECT setval('pricingplans_id_seq', " + (startID - 1) + ");" + Environment.NewLine);

                pricingplans.Append("INSERT INTO pricingplans (price,discount,deliveryconditions) VALUES ");
                for (int i = 0; i < 10000; ++i)
                {
                    pricingplans.Append("(" + (r.NextDouble() * 1000 + 100).ToString("F", CultureInfo.InvariantCulture) +
                                 ",0.0,'" + termsofdelivery[r.Next(termsofdelivery.Length)] + "'),");
                }

                for (int i = 0; i < 10000; ++i)
                {
                    pricingplans.Append("(" + (r.NextDouble() * 1000 + 100).ToString("F", CultureInfo.InvariantCulture) +
                                 "," + (r.NextDouble() * 20).ToString("F", CultureInfo.InvariantCulture) + ",'" + termsofdelivery[r.Next(termsofdelivery.Length)] + "'),");
                }
                pricingplans.Length -= 1;

                var quantitydiscounts = new StringBuilder("INSERT INTO quantitydiscounts VALUES ");

                for (int i = 0; i < 2000; ++i)
                {
                    quantitydiscounts.Append("(" + ((i * 10) + startID) + ",10,0.1),");
                    quantitydiscounts.Append("(" + ((i * 10) + startID) + ",50,0.2),");
                    quantitydiscounts.Append("(" + ((i * 10) + startID) + ",100,0.3),");
                    quantitydiscounts.Append("(" + ((i * 10) + startID) + ",500,0.4),");
                    quantitydiscounts.Append("(" + ((i * 10) + startID) + ",1000,0.5),");
                }

                var manuprod = new Dictionary<string, List<int>>();

                // Create manufactorer products
                var manufactorerproducts = new StringBuilder("INSERT INTO manufactorerproducts VALUES ");
                for (int i = startID; i < (100000 + startID); ++i)
                {
                    int id = r.Next(10);
                    string m1 = "MA010203" + id.ToString("00");
                    manufactorerproducts.Append("('" + m1 + "'," + i + "," + r.Next(startID, 20000 + startID) + "),");
                    List<int> pids;
                    if (!manuprod.TryGetValue(m1, out pids))
                    {
                        pids = new List<int>();
                        manuprod.Add(m1, pids);
                    }
                    pids.Add(i);
                    if (r.Next(100) < 10)
                    {
                        int id2 = r.Next(10);
                        if (id != id2)
                        {
                            string m2 = "MA010203" + id2.ToString("00");
                            manufactorerproducts.Append("('" + m2 + "'," + i + "," + r.Next(startID, 20000 + startID) + "),");
                            if (!manuprod.TryGetValue(m2, out pids))
                            {
                                pids = new List<int>();
                                manuprod.Add(m2, pids);
                            }
                            pids.Add(i);
                        }
                    }
                }
                manufactorerproducts.Length -= 1;

                // Create manufactorer orders
                var productToPurchased = new Dictionary<int, int>();

                var manufactorerorders = new StringBuilder("SELECT setval('manufactorerorders_orderid_seq', " + (startID - 1) + ");INSERT INTO manufactorerorders (manufactorerid,orderdate,cocid,invoiceid,freightno) VALUES ");
                var manufactorerOrderProducts = new StringBuilder("INSERT INTO manufactorerorderedproducts VALUES ");
                var manufactorerCoc = new StringBuilder("INSERT INTO manufactorerorderconfirmations VALUES ");
                var manufactorerInvoice = new StringBuilder("INSERT INTO manufactorerinvoices VALUES ");
                var manufactorerDelivery = new StringBuilder("INSERT INTO manufactorerdeliveries VALUES ");
                int manorderid = startID - 1; // Allow for the first ++
                foreach (KeyValuePair<string, List<int>> mm in manuprod)
                {
                    int ordercount = r.Next(15) + 1;
                    int mno = 0;
                    for (int oc = 0; oc < ordercount; ++oc)
                    {
                        int productcount = r.Next(10) + 1;
                        int count = productcount;
                        foreach (int pid in mm.Value)
                        {
                            if (count == productcount)
                            {
                                ++manorderid;
                                DateTime orderDate = DateTime.Now.Date.AddDays(-1 * r.Next(365 * 2));
                                string mcocid = "COC" + mm.Key + "_" + mno;
                                DateTime cocDate = orderDate.AddDays(r.Next(2));
                                string invId = "INV" + mm.Key + "_" + mno;
                                DateTime invDate = cocDate.AddDays(r.Next(10));
                                DateTime paybeforeDate = invDate.AddDays(30);
                                string freightno = "UPS" + mm.Key + "_" + mno;
                                DateTime deliveryDate = invDate.AddDays(2);
                                manufactorerorders.Append("('" + mm.Key + "','" + orderDate.ToShortDateString() + "','" +
                                                          mcocid + "','" + invId + "','" + freightno + "'),");
                                manufactorerCoc.Append("('" + mm.Key + "','" + mcocid + "','" + cocDate.ToShortDateString() + "'),");

                                manufactorerInvoice.Append("('" + mm.Key + "','" + invId + "','" +
                                                           invDate.ToShortDateString() + "','" +
                                                           paybeforeDate.ToShortDateString() + "'," + 
                                                           (paybeforeDate > DateTime.Now ? "true" : "false") + "),");
                                manufactorerDelivery.Append("('" + mm.Key + "','" + freightno + "','" +
                                                            deliveryDate.ToShortDateString() + "'),");

                                count = 0;
                                ++mno;
                            }

                            int purchasecount = r.Next(200,1000);
                            manufactorerOrderProducts.Append("(" + manorderid + "," + pid + "," +
                                                             r.Next(startID, 20000 + startID) + "," + purchasecount + "),");
                            int oldCount = 0;
                            productToPurchased.TryGetValue(pid, out oldCount);
                            productToPurchased[pid] = oldCount + purchasecount;
                        }
                    }
                }
    
                manufactorerCoc.Length -= 1;
                manufactorerInvoice.Length -= 1;
                manufactorerDelivery.Length -= 1;
                manufactorerorders.Length -= 1;
                manufactorerOrderProducts.Length -= 1;

                var termsofpayment = new string[] {"prepay", "10dgNet", "14dgNet", "30dgNet", "LbMntPlus15dg"};

                // Create web-shops
                var webshops = new StringBuilder("SELECT setval('webshops_id_seq', " + (startID - 1) + ");INSERT INTO webshops (vatno, name, paymentcurrency, invoiceaddress, paymentconditions) VALUES ");
                for (int i = 0; i < 60; ++i)
                {
                    webshops.Append("('DK12345678" + i.ToString("00") + "','My webshops " + i.ToString("00") + "','" +
                                    currency[r.Next(currency.Length)] + "','Webshops invoice address " + i +
                                    " 8900 Sonderborg Denmark" + "','" + termsofpayment[r.Next(termsofpayment.Length)] +
                                    "'),");
                }
                webshops.Length -= 1;

                // Create webshop products
                var webshopproducts = new Dictionary<int, HashSet<int>>();
                var webshopcarries = new StringBuilder("INSERT INTO webshopcarries VALUES ");
                for (int i = startID; i < (startID + 60); ++i)
                {
                    int nmbOfProducts = r.Next(100, 10000);
                    var productscarried = new HashSet<int>();
                    for (int j = 0; j < nmbOfProducts; ++j)
                    {
                        int product = r.Next(startID, 100000);
                        if (!productscarried.Contains(product))
                        {
                            productscarried.Add(product);
                            webshopcarries.Append("(" + i + "," + product + "," + r.Next(startID, 20000 + startID) + "," +
                                                  r.Next(startID, 20000 + startID) + "),");
                        }
                        else
                        {
                            --j;
                        }
                    }
                    webshopproducts.Add(i, productscarried);
                }
                webshopcarries.Length -= 1;

                // Create customers
                var customers = new StringBuilder("SELECT setval('customers_id_seq', " + (startID - 1) + ");INSERT INTO customers (webshopid, firstname, middlename, sirname, tvmfth, floor, streetletter, streetnumber, streetname, postalcode, region, country, paymentconditions) VALUES ");
                var customerphones = new StringBuilder("SELECT setval('customers_id_seq', " + (startID - 1) + ");INSERT INTO customerphones VALUES ");
                var webshopcustomers = new Dictionary<int, List<int>>();

                var apartmentlocations = new string[] { "NULL", "'left'", "'middle'", "'right'"};

                var countries = new string[] { "Denmark", "England", "USA" };

                for (int i = startID; i < (startID + 60); ++i)
                {
                    var customerids = new List<int>();
                    int customerid = startID;
                    int customercount = r.Next(50, 1000);
                    for (int j = 0; j < customercount; ++j)
                    {
                        string middlename = r.Next(2) < 1 ? ("'Bert_" + customerid + "'") : "NULL";
                        int floor = r.Next(12) - 1;
                        char streetletter = (char)('A' + r.Next(7) - 1);
                        string region = r.Next(2) < 1 ? ("'Region " + streetletter + "'") : "NULL";

                        customers.Append("(" + i + 
                                         ",'Pete_" + customerid +
                                         "'," + middlename +
                                         ",'Johanson_" + customerid +
                                         "'," + apartmentlocations[r.Next(apartmentlocations.Length)] +
                                         "," + (floor >= 0
                                             ? floor.ToString(CultureInfo.InvariantCulture)
                                             : "null") +
                                         "," + (streetletter < 'A'
                                                   ? "NULL"
                                                   : ("'" + streetletter.ToString(CultureInfo.InvariantCulture) + "'")) + 
                                         "," + (r.Next(287) + 1) + 
                                         ",'My customer street_" + customerid +
                                         "','" + (r.Next(100,999) * 10) + 
                                         "'," + region + 
                                         ",'" + countries[r.Next(countries.Length)] + 
                                         "','" + termsofpayment[r.Next(termsofpayment.Length)] +
                                         "'),");

                        int phonecount = r.Next(3);
                        for (int k = 0; k < phonecount; ++k)
                        {
                            customerphones.Append("(" + customerid + ",'+45" + r.Next(30000000, 99999999) + "'),");
                        }
                        
                        customerids.Add(customerid++);
                    }
                    webshopcustomers.Add(i, customerids);
                }
                customers.Length -= 1;
                customerphones.Length -= 1;

                // Create customer orders
                var customerorders = new StringBuilder("SELECT setval('customerorders_orderid_seq', " + (startID - 1) + ");INSERT INTO customerorders (customerid,orderdate,netsid,cocid,invoiceid,deliveryid) VALUES ");
                var customerOrderProducts = new StringBuilder("INSERT INTO customerorderproducts VALUES ");
                var customerNets = new StringBuilder("INSERT INTO netspayments VALUES ");
                var customerCoc = new StringBuilder("SELECT setval('customerorderconfirmations_cocno_seq', " + (startID - 1) + ");INSERT INTO customerorderconfirmations (cocdate) VALUES ");
                var customerInvoice = new StringBuilder("SELECT setval('customerinvoices_invoiceno_seq', " + (startID - 1) + ");INSERT INTO customerinvoices (invoicedate, paybefore, paid) VALUES ");
                var customerDelivery = new StringBuilder("SELECT setval('customerdeliveries_deliveryid_seq', " + (startID - 1) + ");INSERT INTO customerdeliveries (deliverydate, freightno) VALUES ");
                int cus_order_coc_inv_del_id = startID - 1; // Allow for the first ++
                long nextNETSIdMax = 123456789;

                foreach (KeyValuePair<int, List<int>> wc in webshopcustomers)
                {
                    int[] webshopProducts = webshopproducts[wc.Key].ToArray();
                    int webshopProductsCount = webshopProducts.Length;

                    List<int> webshopCustomers = wc.Value;
                    foreach (int cusid in webshopCustomers)
                    {
                        int purchasedProducts = r.Next(90); // Possibly we could get 90 and then the products in order goes 9 over = 99
                        for (int i = 0; i < purchasedProducts; )
                        {
                            ++cus_order_coc_inv_del_id;
                            // NOTE It is possibel that we sell and deliver a product before it is purchased, but this inconsistency is not checked in the DB
                            DateTime orderDate = DateTime.Now.Date.AddDays(-1 * r.Next(365 * 2));
                            string netsid = "NULL";
                            if (r.Next(2) == 0)
                            {
                                netsid = (nextNETSIdMax++).ToString(CultureInfo.InvariantCulture);
                            }
                            DateTime cocDate = orderDate.AddDays(r.Next(1));
                            DateTime invDate = cocDate.AddDays(r.Next(10));
                            DateTime paybeforeDate = invDate.AddDays(r.Next(30));
                            DateTime deliveryDate = cocDate.AddDays(2);

                            customerorders.Append("(" + cusid + ",'" + orderDate.ToShortDateString() + "'," +
                                                  netsid + "," + cus_order_coc_inv_del_id + "," + cus_order_coc_inv_del_id + "," + cus_order_coc_inv_del_id + "),");
                            if (netsid != "NULL")
                                customerNets.Append("(" + netsid + ",'" + GetRandomString(r) + "'),");
                            customerCoc.Append("('" + cocDate.ToShortDateString() + "'),");
                            customerInvoice.Append("('" + invDate.ToShortDateString() + "','" +
                                                   paybeforeDate.ToShortDateString() + "'," +
                                                   (paybeforeDate > DateTime.Now ? "false" : "true") + "),");
                            customerDelivery.Append("('" + deliveryDate.ToShortDateString() + "','UPS1234" +
                                                    cus_order_coc_inv_del_id + "'),");

                            int productsinorder = r.Next(10) + 1;
                            var productids = new HashSet<int>();
                            for (int j = 0; j < productsinorder; ++j)
                            {
                                productids.Add(webshopProducts[r.Next(webshopProductsCount)]);
                            }
                            foreach (int p in productids)
                            {
                                int pcount = r.Next(3) + 1;
                                customerOrderProducts.Append("(" + cus_order_coc_inv_del_id + "," + p + "," +
                                                             r.Next(startID, 20000 + startID) + "," + pcount + "),");

                                int oldCount = 0;
                                productToPurchased.TryGetValue(p, out oldCount);
                                int resc = oldCount - pcount;
                                productToPurchased[p] = resc;
                                if (resc < 0)
                                {
                                    MessageBox.Show("Impossible count in pid=" + p + ". Please try again");
                                    return;
                                }
                            }

                            i += productids.Count;
                        }
                    }
                }

                customerNets.Length -= 1;
                customerCoc.Length -= 1;
                customerInvoice.Length -= 1;
                customerDelivery.Length -= 1;
                customerorders.Length -= 1;
                customerOrderProducts.Length -= 1;

                var products = new StringBuilder();
                products.AppendLine("SELECT setval('products_pid_seq', " + (startID - 1) + ");");
                products.Append("INSERT INTO products (name,instock,weight) VALUES ");
                for (int i = 0; i < 100000; ++i)
                {
                    int finalcount = productToPurchased[i + startID];
                    products.Append("('Product " + i + "'," + finalcount + "," + r.Next(10, 100) * 10 + "),");
                }
                products.Length -= 1;

                FileStream fs = File.Open(saveFileDialog1.FileName, FileMode.Create, FileAccess.Write, FileShare.None);
                var sw = new StreamWriter(fs);
                sw.WriteLine("\\c webshoptest1");
                sw.WriteLine("-- We do not use temp tables, but rather directly insert the SERIAL number directly - higher performance");
                sw.WriteLine("-- We also cheat and insert the orders in such a way that we avoid the update, thereby avoiding the trigger");

                sw.WriteLine("-- Create products");
                sw.Write(products.ToString());
                sw.WriteLine(";");

                sw.WriteLine("-- Create product attributes");
                sw.WriteLine("INSERT INTO productattributes VALUES ('productline','string'),('brand','string'),('subbrand','string'),('size','string'),('sizemeasurement','integer'),('colour','string');");

                sw.WriteLine("-- Create product attribute relations");
                sw.Write(productattributerelations.ToString());
                sw.WriteLine(";");

                sw.WriteLine("-- Create manufactorers");
                sw.Write(manufactorer.ToString());
                sw.WriteLine(";");

                sw.WriteLine("-- Create pricing plan");
                sw.Write(pricingplans.ToString());
                sw.WriteLine(";");

                sw.WriteLine("-- Create manufactorer products");
                sw.Write(manufactorerproducts.ToString());
                sw.WriteLine(";");

                sw.WriteLine("-- We cheat and create the orders in reverse order to be able to create the order, except the delivery - it must be done with an update due to key constraints");
                sw.WriteLine("-- Create manufactorer orders"); // This should match the producted products
                sw.Write(manufactorerCoc.ToString());
                sw.WriteLine(";");
                sw.Write(manufactorerInvoice.ToString());
                sw.WriteLine(";");
                sw.Write(manufactorerDelivery.ToString());
                sw.WriteLine(";");
                sw.Write(manufactorerorders.ToString());
                sw.WriteLine(";");
                sw.Write(manufactorerOrderProducts.ToString());
                sw.WriteLine(";");

                sw.WriteLine("-- Create web-shops");
                sw.Write(webshops.ToString());
                sw.WriteLine(";");

                sw.WriteLine("-- Create web-shop products");
                sw.WriteLine(webshopcarries.ToString());
                sw.WriteLine(";");

                sw.WriteLine("-- Create customers");
                sw.Write(customers.ToString());
                sw.WriteLine(";");
                sw.Write(customerphones.ToString());
                sw.WriteLine(";");

                sw.WriteLine("-- Create customer orders");
                sw.Write(customerNets.ToString());
                sw.WriteLine(";");
                sw.Write(customerCoc.ToString());
                sw.WriteLine(";");
                sw.Write(customerInvoice.ToString());
                sw.WriteLine(";");
                sw.Write(customerDelivery.ToString());
                sw.WriteLine(";");
                sw.Write(customerorders.ToString());
                sw.WriteLine(";");
                sw.Write(customerOrderProducts.ToString());
                sw.WriteLine(";");

                sw.Close();
                MessageBox.Show("Database population file generated");
            }
        }

        private void buttonGenerate_Click_Old(object sender, EventArgs e)
        {
            if (saveFileDialog1.ShowDialog() == DialogResult.OK)
            {
                int startID = string.IsNullOrEmpty(textBox1.Text) ? 1000 : int.Parse(textBox1.Text);

                var r = new Random();

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

                sw.WriteLine("SELECT setval('pricingplans_id_seq', " + (startID - 1) + ");");
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
                    int id = r.Next(10) + 1;
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
                        int id2 = r.Next(10) + 1;
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
                pidsX.Add(100000 + startID - 1);

                sw.WriteLine("-- We cheat and create the orders in reverse order to be able to create the order, except the delivery - it must be done with an update due to key constraints");

                sw.WriteLine("-- Create manufactorer orders"); // This should match the producted products

                sw.WriteLine("SELECT setval('manufactorerorders_orderid_seq', " + (startID - 1) + ");");
                var oids = new Dictionary<int, List<int>>();

                var manufactorerorders = new StringBuilder("INSERT INTO manufactorerorders (manufactorerid,orderdate,cocid,invoiceid) VALUES ");
                var manufactorerOrderProducts = new StringBuilder("INSERT INTO manufactorerorderedproducts VALUES ");
                var manufactorerCOC = new StringBuilder("INSERT INTO manufactorerorderconfirmations VALUES ");
                var manufactorerInvoice = new StringBuilder("INSERT INTO manufactorerinvoices VALUES ");
                var manufactorerDelivery = new StringBuilder("INSERT INTO manufactorerdeliveries VALUES ");
                var tempfreightNoTable = new StringBuilder("CREATE TEMPORARY TABLE tempfreightNoTable (orderid INTEGER, freightno VARCHAR(128));INSERT INTO tempfreightNoTable VALUES ");
                int orderid = startID - 1; // Allow for the first ++
                foreach (KeyValuePair<string,List<int>> mm in mp)
                {
                    int productcount = r.Next(10) + 1;
                    int count = productcount;
                    int mno = 0;
                    foreach (int pid in mm.Value)
                    {
                        if (count == productcount)
                        {
                            ++orderid;
                            DateTime orderDate = DateTime.Now.Date.AddDays(-1*r.Next(365*2));
                            string mcocid = "COC" + mm.Key + "_" + mno;
                            DateTime cocDate = orderDate.AddDays(r.Next(2));
                            string invId = "INV" + mm.Key + "_" + mno;
                            DateTime invDate = cocDate.AddDays(r.Next(10));
                            DateTime paybeforeDate = invDate.AddDays(30);
                            string freightno = "UPS" + mm.Key + "_" + mno;
                            DateTime deliveryDate = invDate.AddDays(2);
                            manufactorerorders.Append("('" + mm.Key + "','" + orderDate.ToShortDateString() + "','" +
                                                      mcocid + "','" + invId + "'),");
                            manufactorerCOC.Append("('" + mm.Key + "','" + mcocid + "','" + cocDate.ToShortDateString() + "'),");

                            manufactorerInvoice.Append("('" + mm.Key + "','" + invId + "','" +
                                                       invDate.ToShortDateString() + "','" +
                                                       paybeforeDate.ToShortDateString() + "'),");
                            manufactorerDelivery.Append("('" + mm.Key + "','" + freightno + "','" +
                                                        deliveryDate.ToShortDateString() + "'),");

                            tempfreightNoTable.Append("(" + orderid + ",'" + freightno + "'),");

                            count = 0;
                            ++mno;
                        }

                        manufactorerOrderProducts.Append("(" + orderid + "," + pid + "," +
                                                         r.Next(startID, 20000 + startID) + "," + (r.Next(1000) + 1) + "),");
                    }
                }

                manufactorerCOC.Length -= 1;
                manufactorerInvoice.Length -= 1;
                manufactorerDelivery.Length -= 1;
                manufactorerorders.Length -= 1;
                manufactorerOrderProducts.Length -= 1;
                tempfreightNoTable.Length -= 1;
                sw.Write(manufactorerCOC.ToString());
                sw.WriteLine(";");
                sw.Write(manufactorerInvoice.ToString());
                sw.WriteLine(";");
                sw.Write(manufactorerDelivery.ToString());
                sw.WriteLine(";");
                sw.Write(manufactorerorders.ToString());
                sw.WriteLine(";");
                sw.Write(manufactorerOrderProducts.ToString());
                sw.WriteLine(";");
                sw.Write(tempfreightNoTable.ToString());
                sw.WriteLine(";");
                sw.WriteLine("-- Bulk update to set the freightno. This will trigger a lot of update triggers");
                sw.WriteLine(
                    "UPDATE manufactorerorders SET freightno=md.freightno FROM manufactorerorders mo INNER JOIN tempfreightNoTable md ON mo.orderid=md.orderid;");

                sw.Close();
                MessageBox.Show("Database population file generated");
            }
        }
    }
}
