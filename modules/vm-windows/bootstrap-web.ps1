$ErrorActionPreference = 'Stop'
$result = Install-WindowsFeature -Name Web-Server -IncludeManagementTools
if (-not $result.Success) { throw 'IIS feature installation failed.' }
Set-Content -LiteralPath 'C:\inetpub\wwwroot\index.html' -Encoding UTF8 -Value "<html><body><h1>AZ-700 lab</h1><p>$env:COMPUTERNAME</p></body></html>"
Set-Content -LiteralPath 'C:\inetpub\wwwroot\health.html' -Encoding UTF8 -Value 'healthy'
Set-Service -Name W3SVC -StartupType Automatic
Start-Service -Name W3SVC
$response = Invoke-WebRequest -Uri 'http://localhost/health.html' -UseBasicParsing
if ($response.StatusCode -ne 200) { throw 'Local IIS health check failed.' }
