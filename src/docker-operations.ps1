function Build {
    param (
        [Parameter(
            ParameterSetName='ImageList',
            Mandatory=$false)]
        [String]$imageList = $null
    )

    begin {
        Write-Host "Start build process";
        if([String]::IsNullOrWhiteSpace($imageList)) {
            $images = GetImages;
        }
    }

    process {
        $images | ForEach-Object {
            BuildImage ($_);
        }
    }

    end {
        Write-Host "End process";
    }
}

function Push {
    param (
        [Parameter(
            ParameterSetName='ImageList',
            Mandatory=$false)]
        [String]$imageList = $null
    )

    begin {
        Write-Host "Start push process";
        if([String]::IsNullOrWhiteSpace($imageList)) {
            $images = GetImages;
        }
    }

    process {
        $images | ForEach-Object {
            PushProcess ($_);
        }
    }

    end {
        Write-Host "End process";
    }
}

function BuildAndPush {
    param (
        [Parameter(
            ParameterSetName='ImageList',
            Mandatory=$false)]
        [String]$imageList = $null
    )

    begin {
        Write-Host "Start build and push process";
        if([String]::IsNullOrWhiteSpace($imageList)) {
            $images = GetImages;
        }
    }

    process {  
        $images | ForEach-Object {
            BuildProcess ($_);
            PushProcess ($_);
        }   
    }

    end {
        Write-Host "End process";
    }
}

# --------------------------------------------------------
# Implementations
# --------------------------------------------------------

function PushProcess ($image) {
    if(IsAlreadyPushed($image)) {
        Write-Host ('Skipping push {0}, already pushed' -f $image.tag);
        return;
    }
    
    Write-Host ('Start push {0}' -f $image.tag);
    $process = Start-Process docker -ArgumentList 'push', $image.tag -PassThru -Wait;
    if(0 -eq $process.ExitCode) {
        Write-Host 'Push success';
        $successPushes.Add($image); 
    } else {
        Write-Error ('Push exited with error {0}' -f $process.ExitCode);
        $errorPushes.Add($image);
    }
}

function BuildProcess ($image) {
    if(IsAlreadyBuilded($image)) {
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

function IsAlreadyBuilded ($image) {
    return ($successBuilds.Contains($image) -or $errorBuilds.Contains($image));
}

function IsAlreadyPushed ($image) {
    return ($successPushes.Contains($image) -or $errorPushes.Contains($image));
}
        
function BuildImage ($image) {
    GetDeps($image) | ForEach-Object {
        if($null -ne $_) {
            BuildProcess(GetImageByTag($_));
        }
    }
    BuildProcess($image);
}

function PushImages ($images) {
    $images | ForEach-Object {
        PushProcess ($_);
    }
}

function BuildImages ($images) {
    $images | ForEach-Object {
        BuildImage ($_);
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
$successPushes = New-Object System.Collections.Generic.List[System.Object];
$errorPushes = New-Object System.Collections.Generic.List[System.Object];