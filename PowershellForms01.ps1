[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void] [System.Windows.Forms.Application]::EnableVisualStyles()

function GetPage() {
    $ua = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36 Edg/87.0.664.66"
    $usrCert = $usrCerts[0];
    #$response = Invoke-WebRequest -Uri $UriBox.Text -method "Get" -TimeoutSec 600 -UserAgent $ua -OutFile "./OutputTest.txt"
    $response = Invoke-WebRequest -Uri $UriBox.Text -method "Get" -Certificate $usrCert -TimeoutSec 600 -UserAgent $ua -OutFile "./OutputTest.txt"
    $Form.Close()
}

$Form = New-Object system.Windows.Forms.Form
$Form.Size = New-Object System.Drawing.Size(800,500)
$Form.MaximizeBox = $false
$Form.StartPosition = "CenterScreen"
$Form.FormBorderStyle = 'Fixed3D'
$Form.Text = "Test Application"

$CertBox = New-Object System.Windows.Forms.ComboBox
$CertBox.DropDownWidth = 500
$CertBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$CertBox.Size = New-Object System.Drawing.Size(300, 30)
$CertBox.Location = New-Object System.Drawing.Point(10, 10)
Get-ChildItem "Cert:\CurrentUser\My" | ForEach-Object {
    $CertBox.Items.Add($_.SerialNumber) | Out-Null
}
$CertBox.add_SelectionChangeCommitted({
    $usrCerts.Clear()
    $usrCert = Get-ChildItem "Cert:\CurrentUser\My" | Where-Object { $_.SerialNumber -eq $CertBox.SelectedItem }
    $usrCerts.Add($usrCert)
})
$Form.Controls.Add($CertBox)

$UriBox = New-Object System.Windows.Forms.TextBox
$UriBox.Size = New-Object System.Drawing.Size(300, 30)
$UriBox.Location = New-Object System.Drawing.Point(10, 50)
$UriBox.Text = "https://stackoverflow.com/"
$Form.Controls.Add($UriBox)

$buttonOk = New-Object System.Windows.Forms.Button
$buttonOk.Text = "Ok"
$buttonOk.add_Click({
    if($usrCerts.Count -eq 1) { GetPage }
    else {
        [System.Windows.Forms.MessageBox]::Show("You must choose a client-side certificate", "Certificate Selection")
    }
})
$buttonOk.Size = New-Object System.Drawing.Size(90, 30)
$buttonOk.Location = New-Object System.Drawing.Point(400, 10)
$Form.Controls.Add($buttonOk)


$Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
$Form.Font = $Font

$usrCerts = New-Object System.Security.Cryptography.X509Certificates.X509CertificateCollection

$Form.ShowDialog() | Out-Null
