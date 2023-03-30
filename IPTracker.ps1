<#
    ===========================================================================
    .NOTES
    ===========================================================================
    Created on:   	29/03/2023 12:03 PM
    Created by:   	Bobby (InterestedInCyber)
    Uploaded on:        30/03/2023 20:42
    Edited on:          30/03/2023 20:44
    Organization: 	N/A
    Filename:     	IPTracker.ps1
    ===========================================================================
    .DESCRIPTION
    =================================================================================
    Purpose: IP Address Information (http://ip-api.com/json/) (https://api.shodan.io)
    =================================================================================
#>

$ErrorActionPreference = 'SilentlyContinue'
Clear-Host

function AskForIPAddress {

    $IPStandards = "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}"
    Write-Host "(" -NoNewline; Write-Host "ipt" -ForegroundColor Red -NoNewline; Write-Host ") " -NoNewline; Write-Host "> " -NoNewline
    $IPAddress = $Host.UI.ReadLine()

    while ($IPAddress -eq "") {
        AskForIPAddress
    }

    if ($IPAddress -eq "q") {
        Exit(1)
    }

    if ($IPAddress -eq "clear") {
        Clear-Host
        AskForIPAddress
    }
    
    if ($IPAddress -notmatch $IPStandards) {
        Write-Host "[" -NoNewline; Write-Host "!" -ForegroundColor Red -NoNewline; Write-Host "] " -NoNewline; Write-Host "Please Enter a Valid IP Address."
        AskForIPAddress
    }

    $ShodanResponse = Invoke-RestMethod -Method GET -Uri "https://api.shodan.io/shodan/host/$IPAddress`?key=xxxxxxxxxxxxxxxxxxxx"
    $IPDetails = Invoke-RestMethod -Method POST -Uri "http://ip-api.com/json/$IPAddress`?fields=status,message,continent,continentCode,country,countryCode,region,regionName,city,district,zip,lat,lon,timezone,offset,currency,isp,org,as,asname,reverse,mobile,proxy,hosting,query"
    $countryCode = $IPDetails.countryCode
    $region = $IPDetails.region
    $asname = $IPDetails.asname

    Write-Host ""
    Write-Host "IP Address          : " -NoNewline; Write-Host ($IPDetails.query) -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Country             : " -NoNewline; Write-Host ($IPDetails.country) "($countryCode)"
    Write-Host "Region              : " -NoNewline; Write-Host ($IPDetails.regionName) "($region)"
    Write-Host "Time Zone           : " -NoNewline; Write-Host ($IPDetails.timezone)
    Write-Host "City                : " -NoNewline; Write-Host ($IPDetails.city)
    Write-Host "Zip Code            : " -NoNewline; Write-Host ($IPDetails.zip)
    Write-Host "Latitude            : " -NoNewline; Write-Host ($IPDetails.lat)
    Write-Host "Longtitude          : " -NoNewline; Write-Host ($IPDetails.lon)
    Write-Host "Location            : " -NoNewline; Write-Host ($IPDetails.lat) "," ($IPDetails.lon)
    Write-Host "Organisation        : " -NoNewline; Write-Host ($IPDetails.org)
    Write-Host "ISP                 : " -NoNewline; Write-Host ($IPDetails.isp)
    Write-Host "ASN                 : " -NoNewline; Write-Host ($IPDetails.as) "($asname)"
    Write-Host "Reverse DNS         : " -NoNewline; Write-Host ($IPDetails.reverse)
    Write-Host "Operating System    : " -NoNewline; Write-Host ($ShodanResponse.os)
    Write-Host "Open Ports          : " -NoNewline; Write-Host ($ShodanResponse.ports)
    Write-Host ""
    AskForIPAddress
}
AskForIPAddress
