function Build ($image) {
    if($successBuilds.Contains($image) -or $errorBuilds.Contains($image)) {
        Write-Host ('Skipping build {0}, already processed' -f $image.tag);
        return;
    }
    
    Write-Host ('Start build {0}' -f $image.tag);
    $process = Start-Process docker -ArgumentList 'build', '--rm', '-f', $image.file, '-t', $image.tag, $image.url -PassThru -Wait;
    if(0 -eq $process.ExitCode) {
        Write-Host 'Build success';
        $successBuilds.Add($image); 
    } else {
        Write-Error ('Build exited with error {0}' -f $process.ExitCode);
        $errorBuilds.Add($image);
    }
}
        
function BuildImage ($image) {
    GetDeps($image) | ForEach-Object {
        if($null -ne $_) {
            Build(GetImageByTag($_));
        }
    }
    Build($image);
}

function BuildImages ($images) {
    $images | ForEach-Object {
        BuildImage($_);
    }
}

function GetConfiguration () {
    return Get-Content $PSScriptRoot/configuration.json | ConvertFrom-Json;
}

function GetImages () {
    return (GetConfiguration).Images;
}

function GetImageByTag ($tag) {
    return $images | Where-Object {
        $_.tag -eq $tag
    }
}

function GetDeps ($image){
   if($null -ne $image.deps){
        Write-Host('Find dependencies for {0} from:' -f $image.tag);
        $image.deps | ForEach-Object {
            Write-Host("`t- {0}" -f $_);
        }
    }
    return $image.deps;
}

$successBuilds = New-Object System.Collections.Generic.List[System.Object];
$errorBuilds = New-Object System.Collections.Generic.List[System.Object];
$images = GetImages;

Write-Host "Start build process";
BuildImages($images);
Write-Host "End build process";