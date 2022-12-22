# Write your PowerShell commands here.
Write-Host ' - - - - - - - - - - - - - - - - - - - - - - - - -'
Write-Host ' reflect Azure Devops repo changes to GitHub repo'
Write-Host ' - - - - - - - - - - - - - - - - - - - - - - - - - '
$AzureRepoName = "Docker"
Write-Host 'AzureRepoName: $AzureRepoName'
$GitHubDestinationPAT = "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"
$ADOSourcePAT = "lwchver7hsb5ckqjc72edxglhg2eqp2ewwgmn3irywiwkasapaeq"
$GitHubUserName = "RekhuGopal"
$ADOCloneURL = "dev.azure.com/CloudQuickLabs/DockerImageAzureWebApp/_git/Docker"
$GitHubCloneURL = "github.com/RekhuGopal/Docker.git"
$stageDir = pwd | Split-Path
Write-Host 'stage Dir is : $stageDir'
$githubDir = $stageDir +"\"+"gitHub"
Write-Host 'github Dir : $githubDir'
$destination = $githubDir+"\"+ $AzureRepoName+".git"
Write-Host 'destination: $destination'
#please provide your username
$alias = $GitHubUserName+":"+ "$($GitHubDestinationPAT)"
write-host "Alias : $alias"
#Please make sure, you remove https from azure-repo-clone-url
$sourceURL = "https://$($ADOSourcePAT)"+"@"+"$($ADOCloneURL)"
write-host "source URL : $sourceURL"
#Please make sure, you remove https from github-repo-clone-url
$destURL = "https://" + $($GitHubDestinationPAT) +"@"+"$($GitHubCloneURL)"
$destURLSetURL = "https://" + $($alias) +"@"+"$($GitHubCloneURL)"
write-host "dest URL : $destURL"
#Check if the parent directory exists and delete
if((Test-Path -path $githubDir))
{
  Remove-Item -Path $githubDir -Recurse -force
}
if(!(Test-Path -path $githubDir))
{
  New-Item -ItemType directory -Path $githubDir
  Set-Location $githubDir
  git clone --mirror $sourceURL
}
else
{
  Write-Host "The given folder path $githubDir already exists";
}
Set-Location $destination
Write-Output '*****Git removing remote secondary****'
git remote rm secondary
Write-Output '*****Git remote add****'
git remote add --mirror=fetch secondary $destURL
Write-Output '*****Git fetch origin****'
git fetch $sourceURL
Write-Output '*****Git push secondary****'
#git remote set-url origin $destURLSetURL
git push secondary --all
Write-Output '**Azure Devops repo synced with Github repo**'
Set-Location $stageDir
if((Test-Path -path $githubDir))
{
 Remove-Item -Path $githubDir -Recurse -force
}
write-host "Job completed"
