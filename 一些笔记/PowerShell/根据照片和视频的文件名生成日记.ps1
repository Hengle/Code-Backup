ls | Where-Object { ($_.Extension -eq '.jpg') -or ($_.Extension -eq '.png') -or ($_.Extension -eq '.mov') } | ForEach-Object{
echo $_.Name
$time = $_.Name.Substring(0,10)
$e = $_.Extension

if (-not (Test-Path .\$time)) {
New-Item -Path .\ -Name $time -type directory
}

mv $_ .\$time\
cd $time

if ((($e -eq ".jpg") -or ($e -eq ".png")) -and (-not (Test-Path .\photos))) {
New-Item -Path .\ -Name photos -type directory
}

if (($e -eq ".mov") -and (-not (Test-Path .\videos))) {
New-Item -Path .\ -Name videos -type directory
}

if (-not (Test-Path "$time.md")){
New-Item -Path .\ -Name "$time.md" -type file
}

mv *.jpg .\photos
mv *.mov .\videos
mv *.png .\photos

if (($e -eq ".jpg") -or ($e -eq ".png")) {
"![$_](photos/$_)" | Out-File -Append "$time.md" }
Else {
"<video src=`"videos/$_`"></video>" | Out-File -Append "$time.md"
}

cd ..

}