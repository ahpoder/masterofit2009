using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Net;

namespace SystemCTLMFileGenerator
{
    class Program
    {
        const int FRAME_SIZE = 32;
        
        static void PrintUsage()
        {
            System.Console.WriteLine("Usage:");
            System.Console.WriteLine("  SystemCTLMFileGenerator <duration in ms>");
            System.Console.WriteLine("Example:");
            System.Console.WriteLine("  SystemCTLMFileGenerator 60");
            System.Console.WriteLine();
            System.Console.WriteLine("  Will generate files with a predefined pattern for 60 milli seconds at 44kHz:");
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
         * 10 x 32767
         * 10 x -32767
         * 
         * ISM input:
         * 5
         * -5
         * 15
         * -15
         * .
         * .
         * .
         * 32767
         * -32767
         */

        static void Main(string[] args)
        {
            if (args.Length < 1)
            {
                PrintUsage();
                return;
            }

            int duration = int.Parse(args[0]);

            int count = (duration * 8) / 10; // divided by 10 is due to encoding

            StreamWriter adcFile = new StreamWriter(File.OpenWrite("microphone_data.txt"));
            short value = 0;
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
                    value = (short)((value * -1) + 10);
                    positive = true;
                }
                if (i % 800 == 0)
                    System.Console.Write('.');
            }
            adcFile.Close();
            System.Console.WriteLine(Environment.NewLine + "Finished creating ADC File");

            value = 5;
            positive = true;
            StreamWriter ismFile = new StreamWriter(File.OpenWrite("ism_input_data.txt"));
            for (int i = 0; i < count; ++i)
            {
                ismFile.WriteLine(value);
                if (positive)
                {
                    value *= -1;
                    positive = false;
                }
                else
                {
                    value = (short)((value * -1) + 10);
                    positive = true;
                }
                if (i % 800 == 0)
                    System.Console.Write('.');
            }
            ismFile.Close();
            System.Console.WriteLine(Environment.NewLine + "Finished creating ISM File");
            System.Console.WriteLine("Generation completed succesfully");
        }
    }
}
