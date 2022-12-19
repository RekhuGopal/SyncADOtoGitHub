# Write your PowerShell commands here.
Write-Host ' - - - - - - - - - - - - - - - - - - - - - - - - -'
Write-Host ' reflect Azure Devops repo changes to GitHub repo'
Write-Host ' - - - - - - - - - - - - - - - - - - - - - - - - - '
$AzureRepoName = "Docker"
$GitHubDestinationPAT = "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"
$ADOSourcePAT = "lwchver7hsb5ckqjc72edxglhg2eqp2ewwgmn3irywiwkasapaeq"
$GitHubUserName = "RekhuGopal"
$ADOCloneURL = "https://CloudQuickLabs@dev.azure.com/CloudQuickLabs/DockerImageAzureWebApp/_git/Docker"
$GitHubCloneURL = "https://github.com/RekhuGopal/SyncADOtoGitHub.git"
$stageDir = pwd | Split-Path
$destination = $stageDir+"\"+ $AzureRepoName+".git"
#please provide your username
$alias = $GitHubUserName+":"+ "$($GitHubDestinationPAT)"
#Please make sure, you remove https from azure-repo-clone-url
$sourceURL = "https://$($ADOSourcePAT)@$($ADOSourcePAT)"
#Please make sure, you remove https from github-repo-clone-url
$destURL = "https://" + $alias + "@$($GitHubCloneURL)"
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
git push secondary --all
Write-Output '**Azure Devops repo synced with Github repo**'
Set-Location $stageDir
if((Test-Path -path $githubDir))
{
 Remove-Item -Path $githubDir -Recurse -force
}
