$package = 'SQL2008.SMO'

try {
  $params = @{
    packageName = $package;
    fileType = 'msi';
    silentArgs = '/quiet';
    url = 'http://download.microsoft.com/download/0/E/6/0E67502A-22B4-4C47-92D3-0D223F117190/SharedManagementObjects.msi';
    url64bit = 'http://download.microsoft.com/download/A/D/0/AD021EF1-9CBC-4D11-AB51-6A65019D4706/SharedManagementObjects.msi';
  }

  Install-ChocolateyPackage @params

  # install both x86 and x64 editions of SMO since x64 supports both
  # to install both variants of powershell, both variants of SMO must be present
  $IsSytem32Bit = (($Env:PROCESSOR_ARCHITECTURE -eq 'x86') -and `
    ($Env:PROCESSOR_ARCHITEW6432 -eq $null))
  if (!$IsSytem32Bit)
  {
    $params.url64bit = $params.url
    Install-ChocolateyPackage @params
  }

  Write-ChocolateySuccess $package
} catch {
  Write-ChocolateyFailure $package "$($_.Exception.Message)"
  throw
}
