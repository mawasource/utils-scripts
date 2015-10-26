$ProjectFile = "projectname.csproj"
$scriptPath = "Properties/PublishProfiles"

$websiteNames = @("websitename1", "websitename2")
$websiteUrls = @("http://url1.com", "http://url2.com")

foreach ($websiteName in $websiteNames) {

	$publishXmlFile = Join-Path $scriptPath -ChildPath ($websiteName + ".pubxml")
	[Xml]$xml = Get-Content $scriptPath\$websiteName.publishsettings 
	$password = $xml.publishData.publishProfile.userPWD[0]

	& "$env:windir\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe" $ProjectFile `
		/p:VisualStudioVersion=14.0 `
		/p:DeployOnBuild=true `
		/p:Configuration=Release `
		/p:PublishProfile=$publishXmlFile `
		/p:Password=$password

}


foreach ($url in $websiteUrls) {
	$HTTP_Request = [System.Net.WebRequest]::Create($url)
	$HTTP_Response = $HTTP_Request.GetResponse()
	$HTTP_Status = [int]$HTTP_Response.StatusCode
	If ($HTTP_Status -eq 200) { 
		"Site is OK: " + $url
	}
	Else {
		"The Site may be down, please check: " + $url
	}
	$HTTP_Response.Close()
}
