[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")  
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 
[void] [System.Windows.Forms.Application]::EnableVisualStyles()

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

});
$Form.Controls.Add($CertBox)


$buttonOk = New-Object System.Windows.Forms.Button
$buttonOk.Text = "Ok"
$buttonOk.add_Click({
    if($usrCerts.Count -eq 1) { $Form.Close() }
    else {
        [System.Windows.Forms.MessageBox]::Show("You must choose a client-side certificate", "Certificate Selection")
    }
})
$buttonOk.Size = New-Object System.Drawing.Size(90, 50)
$buttonOk.Location = New-Object System.Drawing.Point(400, 10)
$Form.Controls.Add($buttonOk)


$Font = New-Object System.Drawing.Font("Arial",10,[System.Drawing.FontStyle]::Bold) 
$Form.Font = $Font 

$usrCerts = New-Object System.Security.Cryptography.X509Certificates.X509CertificateCollection

$Form.ShowDialog() | Out-Null
