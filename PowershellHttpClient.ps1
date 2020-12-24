$Assem = ("System", "System.Net.Http", "System.Threading.Tasks")

$Source = @"
using System;
using System.Threading.Tasks;
using System.Net.Http;
// using System.Collections.Generic;
// using System.Linq;
// using System.Text;

namespace IDST
{
    public class QlixHelper
    {
        public static async Task<string> DownloadPageAsync(string downloadUrl)
        {
            string result = "";
            await Task.Run(async () => {
                using (HttpClient client = new HttpClient())
                using (HttpResponseMessage response = await client.GetAsync(downloadUrl))
                using (HttpContent content = response.Content)
                {
                    result = await content.ReadAsStringAsync();
                }
            });
            return result;
        }
    }
}
"@

Add-Type -ReferencedAssemblies $Assem -TypeDefinition $Source -Language CSharp

$task = [IDST.QlixHelper]::DownloadPageAsync("http://en.wikipedia.org/")
while (-not $task.AsyncWaitHandle.WaitOne(200)) { }
$something = $task.GetAwaiter().GetResult()


Write-Output $something
Read-Host -Prompt "Press Enter to continue"
