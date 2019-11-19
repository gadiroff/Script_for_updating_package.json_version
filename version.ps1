# These are project build parameters in TeamCity
# Depending on the branch, we will use different major/minor versions
[System.Reflection.Assembly]::LoadWithPartialName("System.Web.Extensions")
$ser = New-Object System.Web.Script.Serialization.JavaScriptSerializer
$json = Get-Content "package.json" | Out-String
$obj = $ser.DeserializeObject($json)
$majorVerion = ($obj['version'] -split "\.")[0]
$minorVerion = ($obj['version'] -split "\.")[1]
$buildCounter = "%teamcity.build.counter%" 
$buildNumber = "$majorVerion.$minorVerion.$buildCounter"

# This gets the name of the current Git branch. 
$branch = "%teamcity.build.branch%"
$buildMetadata = "";

# Sometimes the branch will be a full path, e.g., 'refs/heads/master'. 
# If so we'll base our logic just on the last part.
if ($branch.Contains("/")) 
{
  $branch = $branch.substring($branch.lastIndexOf("/")).trim("/")
}

Write-Host "Branch: $branch"

if ($branch -eq "master") 
{
 $buildMetadata = ""
}
elseif ($branch -match "feature_.*") 
{
 $branch = $branch.replace("feature_", "")
 $buildMetadata = "-${branch}"
}
elseif ($branch -match "feature-.*")
{
 # If the branch starts with "feature-", just use the feature name
 $branch = $branch.replace("feature-", "")
 $buildMetadata = "-${branch}"
}
elseif ($branch -match "fix_.*") 
{
 $branch = $branch.replace("fix_", "")
 $buildMetadata = "-${branch}"
}
else
{
 $buildMetadata = "-${branch}"
}

$buildNumber = "$buildNumber$buildMetadata"
Write-Host "##teamcity[buildNumber '$buildNumber']"
