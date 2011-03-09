using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Net;

namespace SystemCTLMFileGenerator
{
    class Program
    {
        static void PrintUsage()
        {
            System.Console.WriteLine("Usage:");
            System.Console.WriteLine("  SystemCTLMFileGenerator <duration>");
            System.Console.WriteLine("Example:");
            System.Console.WriteLine("  SystemCTLMFileGenerator 60");
            System.Console.WriteLine();
            System.Console.WriteLine("  Will generate files with a predefined pattern for 60 seconds at 44kHz:");
        }

        /*
         * Pattern:
         * 
         * ADC input: (10 times of everything is due to the encoding)
         * 10 x 0
         * 10 x 0
         * 10 x 10
         * 10 x -10
         * 10 x 20
         * 10 x -20
         * .
         * .
         * .
         * 10 x 2147483640
         * 10 x -2147483648
         * 
         * ISM input (with header and correct endian):
         * 5
         * -5
         * 15
         * -15
         * .
         * .
         * .
         * 2147483645
         * -2147483645
         */

        static void Main(string[] args)
        {
            if (args.Length < 1)
            {
                PrintUsage();
                return;
            }

            int duration = int.Parse(args[0]);

            int count = (duration * 44000) / 10; // divided by 10 is due to encoding

            StreamWriter adcFile = new StreamWriter(File.OpenWrite("microphone_data.txt"));
            int value = 0;
            bool positive = true;
            for (int i = 0; i < count; ++i)
            {
                for (int j = 0; j < 10; j++)
                {
                    adcFile.WriteLine(value);
                }
                if (positive)
                {
                    value *= -1;
                    positive = false;
                }
                else
                {
                    value = (value * -1) + 10;
                    positive = true;
                }
                if (i % 4400 == 0)
                    System.Console.Write('.');
            }
            adcFile.Close();
            System.Console.WriteLine(Environment.NewLine + "Finished creating ADC File");

            FileStream ismFile = File.OpenWrite("ism_input_data.txt");

            int packages = count / 128;

            ASCIIEncoding ae = new ASCIIEncoding();
            for (int i = 0; i < packages; ++i)
            {
                ismFile.WriteByte(ae.GetBytes(new char[] { 'a' })[0]);
                byte[] b = BitConverter.GetBytes(IPAddress.HostToNetworkOrder((short)128));
                ismFile.Write(b, 0, 2);
                value = 5;
                positive = true;
                for (int j = 0; j < 128; ++j)
                {
                    b = BitConverter.GetBytes(IPAddress.HostToNetworkOrder(value));
                    ismFile.Write(b, 0, 4);
                    if (positive)
                    {
                        value *= -1;
                        positive = false;
                    }
                    else
                    {
                        value = (value * -1) + 10;
                        positive = true;
                    }
                }
                System.Console.Write('.');
            }

            int remaining = count % 128;
            if (remaining != 0)
            {
                remaining = (remaining / 10) + 1;
                ismFile.WriteByte(ae.GetBytes(new char[] { 'a' })[0]);
                byte[] b = BitConverter.GetBytes(IPAddress.HostToNetworkOrder((short)remaining));
                ismFile.Write(b, 0, 2);
                for (int j = 0; j < remaining; ++j)
                {
                    b = BitConverter.GetBytes(IPAddress.HostToNetworkOrder(value));
                    ismFile.Write(b, 0, 4);
                    if (positive)
                    {
                        value *= -1;
                        positive = false;
                    }
                    else
                    {
                        value = (value * -1) + 10;
                        positive = true;
                    }
                }
            }
            ismFile.Close();
            System.Console.WriteLine(Environment.NewLine + "Finished creating ISM File");
            System.Console.WriteLine("Generation completed succesfully");
        }
    }
}
