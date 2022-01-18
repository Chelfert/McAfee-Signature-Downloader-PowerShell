#hide error from accessing newly created folder
#$ErrorActionPreference = "SilentlyContinue"


#source URL
$url = "https://www.mcafee.com/enterprise/en-us/downloads/security-updates.html"
$date = Get-Date -Format MM-dd-yyyy
#create folder
$folderName = (Get-Date).tostring("MM-dd-yyyy") 

#destination file
$dest = "C:\Users\helfertc.adm\Desktop\signatures"
$finalDest = "C:\Users\helfertc.adm\Desktop\signatures\$folderName\packages.zip"

#put folder in correct path
New-Item -ItemType Directory -Path $dest -Name $FolderName

#download the file
Invoke-WebRequest -URI $url 

Clear-Host

#scrape webpage
$content = @(Invoke-WebRequest -URI $url)

#create full links for each entry

$datPackages = $content.links | where {$_.href -like '*download.nai.com/products/datfiles/4.x/NAI/mediumepo*'} | select href
$v3dat = $content.links | where {$_.href -like '*download.nai.com/products/datfiles/V3DAT/epoV3*'} | select href


$env:Path += "$finalDest"
#create space to read what is downloading
$count = @(1..6)
foreach ($number in $count){
    write-host "`n"
}

#show current downloads
write-host "You are currently downloading:"
write-host $datPackages
write-host $v3dat

#download each file in the background
Start-BitsTransfer ($datPackages.href)
Start-BitsTransfer ($v3dat.href) 

#complete the bitstransfer
Get-BitsTransfer | Complete-BitsTransfer

#move files
Move-Item -Path "C:\Users\helfertc.adm\Desktop\*medium*" -Destination "C:\Users\helfertc.adm\Desktop\signatures\$folderName"
Move-Item -Path "C:\Users\helfertc.adm\Desktop\*v3*" -Destination "C:\Users\helfertc.adm\Desktop\signatures\$folderName" 



Read-Host -Prompt "Press Enter to exit"