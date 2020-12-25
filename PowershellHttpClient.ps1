$Assem = ("System", "System.Net", "System.Net.Http", "System.Net.Http.WebRequest", "System.Threading.Tasks", "System.Security.Cryptography.X509Certificates")

$Source = @"
using System;
using System.Threading.Tasks;
//using System.Collections.Generic;
//using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Net;
using System.Net.Http;

namespace IDST
{
    public class QlixHelper
    {
        public static X509Certificate2 GetCertWithThumb(string certThumbprint)
        {
            X509Certificate2 retCert = null;

            var store = new X509Store(StoreName.My, StoreLocation.CurrentUser);
            store.Open(OpenFlags.ReadOnly | OpenFlags.OpenExistingOnly);

            foreach (var x509 in store.Certificates)
            {
                Console.WriteLine(string.Format("Found Cert: {0}", x509.Thumbprint));
                if (x509.Thumbprint.ToLower() == certThumbprint.ToLower())
                {
                    retCert = x509;
                }
            }
            return retCert;
        }

        public static async Task<string> DownloadPageAsync(string downloadUrl) {
            string result = "";
            await Task.Run(async () =>
            {
                result = await DownloadPageAsync(downloadUrl, null);
            });
            return result;
        }

        public static async Task<string> DownloadPageAsync(string downloadUrl, X509Certificate2 clientCert)
        {
            string result = "";
            ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;

            await Task.Run(async () => {
                X509CertificateCollection certs = new X509CertificateCollection();
                System.Net.Http.WebRequestHandler handler = new System.Net.Http.WebRequestHandler();
                if (clientCert != null) { handler.ClientCertificates.Add(clientCert); }

                using (HttpClient client = new HttpClient(handler))
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

$cert = [IDST.QlixHelper]::GetCertWithThumb("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
Write-Output $cert

#$task = [IDST.QlixHelper]::DownloadPageAsync("http://en.wikipedia.org/")
#$task = [IDST.QlixHelper]::DownloadPageAsync("https://webmail.XXXXX.XXX/my.policy#", $cert)

while (-not $task.AsyncWaitHandle.WaitOne(200)) { }
$taskReturn = $task.GetAwaiter().GetResult()
Write-Output $taskReturn
