$Assem = ("System", "System.Net.Http", "System.Threading.Tasks")

$Source = @"
    using System;
    using System.Net.Http;
    using System.Threading.Tasks;
    namespace IDST {
        public class Program
        {
            public static void Main()
            {
                Console.WriteLine("Inside Main...");
                testIt();
            }
            
            public static async void testIt() {
                Console.WriteLine("Inside testIt...");
                Console.WriteLine("Downloading page...");
                Task<string> task = DownloadPageAsync();
                string something = await task;

                Console.WriteLine(something);
                Console.WriteLine("All Finished...");
                Console.ReadKey();
            }
            static async Task<string> DownloadPageAsync()
            {
                Console.WriteLine("Inside DownloadPageAsync...");
                string result = "";
                await Task.Run(async () => {
                    Console.WriteLine("Inside Download");
                    string page = "http://en.wikipedia.org/";
                    using (HttpClient client = new HttpClient())
                    using (HttpResponseMessage response = await client.GetAsync(page))
                    using (HttpContent content = response.Content)
                    {
                        Console.WriteLine("Inside Usings....");
                        result = await content.ReadAsStringAsync();
                        if (result != null && result.Length >= 50)
                        {
                            Console.WriteLine(result.Substring(0, 50) + "...");
                        }
                    }
                });
                return result;
            }
        }
    }
"@

Add-Type -ReferencedAssemblies $Assem -TypeDefinition $Source -Language CSharp

[IDST.Program]::Main()
Read-Host -Prompt "Press Enter to continue"
