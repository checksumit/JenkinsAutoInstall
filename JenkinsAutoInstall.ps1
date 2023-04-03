<# Jenkins Auto Installation Script

This script is for the installtion of Jenkins WAR file, Java Development Kit version 11
Set Varibles for application
Create directory
Download Java and Unzip
Download Jenkins - WAR file download
Run Jenkins on Port 8000

Supported OS - Tested on Windows server 2019 / per user script

#>

# Varibles for Folder,file and App

$UserProfile = "$env:USERPROFILE\JenkinsAutoInstall" # Application working directory
$JDKfileUrl = "https://download.oracle.com/java/17/archive/jdk-17_windows-x64_bin.zip" # URL for Java 17
$JenkinsfileUrl = "https://get.jenkins.io/war-stable/2.387.1/jenkins.war" # URL for Jenkins WAR file
$LogFiles = "$env:USERPROFILE\JenkinsAutoInstall\logs" # Log directory for application
$JAVA_HOME = "$env:USERPROFILE\Java\jdk-17\bin\" # Java home location   --- C:\Users\****\JenkinsAutoInstall\Java\jdk-17\bin
$Prefix ="$env:USERNAME" # Varible for username



# JenkinsAutoInstall Directory creation
if (-not (Test-Path $UserProfile -PathType Container)) {
    New-Item -ItemType Directory -Path $UserProfile
    Write-Host "The directory $UserProfile has been created."
} else {
    Write-Host "The directory $UserProfile already exists."
}

#Log File Directory Creation
if (-not (Test-Path $UserProfile\Logs -PathType Container)) {
    New-Item -ItemType Directory -Path $UserProfile\Logs
    Write-Host "The directory $UserProfile\Logs has been created."
} else {
    Write-Host "The directory $UserProfile\Logs already exists."
}

# JDK download and Install
if (-not (Test-Path "$UserProfile\jdk-17_windows-x64_bin.zip" -PathType Leaf)) {
    Write-Host "Downloading $fileUrl to $UserProfile"
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($JDKfileUrl, "$UserProfile\jdk-17_windows-x64_bin.zip")
    Write-Host "Download complete."
    #Expand if not already
    Expand-Archive -Path $UserProfile\jdk-17_windows-x64_bin.zip -DestinationPath $UserProfile\Java
} else {
    Write-Host "The file jdk-17_windows-x64_bin.zip already exists in $UserProfile."
}
# Jenkins download
if (-not (Test-Path "$UserProfile\jenkins.war" -PathType Leaf)) {
    Write-Host "Downloading $JenkinsfileUrl to $UserProfile"
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($JenkinsfileUrl, "$UserProfile\jenkins.war")
    Write-Host "Download complete."
} else {
    Write-Host "The file jenkins.war already exists in $UserProfile\Jenkins."
}


# Run Jenkins
$Env:JENKINS_HOME = "$UserProfile\Jenkins\ConfigData"
cd $UserProfile\Java\jdk-17\bin\
.\java -jar $UserProfile\jenkins.war --prefix=/$Prefix --javaHome=$JAVA_HOME --webroot=$UserProfile\Jenkins --httpPort=8000 --logfile="$LogFiles\JenkinsLog.log"