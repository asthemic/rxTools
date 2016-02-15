# To run this script you will need to have at least Powershell 2.0 installed and scripts enabled
# Run the below line in powershell console to enable sripts, you will need Admin to do this (take out the # symbol at the beginning of Start-Process)
#
# Enable PSscripts: 
# Start-Process powershell -Verb runAs -argument "Set-ExecutionPolicy RemoteSigned -Force"
#
# Highly recommend disabling scripts after you have run this (take out the # symbol at the beginning of Start-Process)
# Disable PSscripts: 
# Start-Process powershell -Verb runAs -argument "Set-ExecutionPolicy Default -Force"

# Firmware
$colArray = @(,("0x0004013820000002","0x00000018"))

# File Extension
$firmext = "bin"

# Nintendo firmware location
$url = "http://nus.cdn.c.shop.nintendowifi.net/ccs/download"
$destpath = "$((Get-Item -Path ".\" -Verbose).FullName)\firm"
if( -not (test-path $destpath)) {md $destpath}

function Download
{
	param( [string]$url, [string]$outputdest )
	$webclient = new-object System.Net.WebClient
	$webclient.DownloadFile( $url, $outputdest )
}

Write-Host "Fetching files..." $colArray.Count
foreach ($Array in $colArray) {
	$firmwarename,$elementname = $Array;
	$firmwarename = $firmwarename.substring(2) # chop off first 2 characters as hex part
	$elementname = $elementname.substring(2) # chop off first 2 characters as hex part

	# Create full url string
	$fullurl = "{0}/{1}/{2}" -f $url,$firmwarename,$elementname

	# Create full download path
	$fullpath = "{0}\{1}.{2}" -f $destpath,$firmwarename,$firmext
	Try
	{
		Download -url $fullurl -outputdest $fullpath -ErrorAction Stop
		Write-Host "Downloaded..." $fullpath
	}
	Catch
	{
		Write-Host $_.Exception
		Break
	}
}

Write-Host "Done"
Write-Host "Press any key to continue..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")