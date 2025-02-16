Set-Location $PSScriptRoot
Clear-Host

$PATH_TOCHECKOUT = "pathToCheckItOut.txt"
$PATH_IGNORE = "ignore.txt"
$OUT_FILE = "fold_content.txt"

function Write-List
{
    param
    (
        [Array]$list
    )
    for($i = 0; $i -lt $list.Count; $i += 1)
    {
        Write-Host "$($i)`t: $($list[$i])"
    }
}

function Check-AdditionalDirectories
{
    param
    (
        [System.IO.FileInfo]$currentPath,
        [System.IO.FileInfo]$filePath
    )

    $checkItOut = Get-Content $filePath -Encoding UTF8
    $filePathlist = $checkItOut.Split("`n")
    $allFiles = @()

    Write-List $filePathlist

    foreach($path in $filePathlist)
    {
        Set-Location -LiteralPath $path
        Write-Host "Import from`t: $($path)"
        $allFilesLocal = Get-ChildItem $Directory -File -Name -Recurse
        for($i = 0; $i -lt $allFilesLocal.Count; $i++)
		{
			$allFilesLocal[$i] = "$($path)$($allFilesLocal[$i])"
		}
        Write-Host "Fetched     : $($allFilesLocal.Count)"
        $allFiles += $allFilesLocal
        Set-Location $currentPath
    }
    Set-Location $currentPath
    return $allFiles
}

function Test-StringAgainstRegexList {
    param(
        [string]$inputString,
        [string[]]$regexList
    )

    $matchFound = $false

    foreach ($regex in $regexList) {
        if ($inputString -cmatch $regex) {
            $matchFound = $true
            Write-Host "Not mathced by `"$($regex)`": $($file)"
            break
        }
    }

    return -not $matchFound
}

function Parse-Ignore
{
    param
    (
        [System.IO.FileInfo]$IgnoreFilePath,
        [string[]]$allFiles
    )

    $ignorePatterns = Get-Content -LiteralPath $IgnoreFilePath -Encoding UTF8
    $ignorePatternList = $ignorePatterns.Split("`n")
    Write-List $ignorePatternList

    $filteredFiles = @()

    foreach ($file in $allFiles)
    {
        if(Test-StringAgainstRegexList -inputString $file -regexList $ignorePatternList)
        {
            $filteredFiles += $file
        }
    }

    return $filteredFiles
}

# 0 \t ../../music
# 1 \t ../../music/pl
# 2 \t ../../music/pl/core
# 3 \t ../../music/sp
# 
# 0 \t soc.mp3
# 0 \t cl.mp3
# 1 \t folk.opus
# 2 \t cap.wav
# 3 \t ey.mp3
function Write-Shrinked {
  param(
    [string[]]$filePaths
  )
  
  $dirs = @()
  $itmRes = ""
  $mus = ""
  $dirLay = ""
  $isDirLayUsed = $false
  
  foreach($file in $files)
  {
    $mus = $file -replace ".*(/|\\)"
    $dirLay = $file.substring(0, $file.Length - $mus.Length)
    $isDirLayUsed = $false
  
    for($i = 0; $i -lt $dirs.Length; $i += 1) {
      $dir = $dirs[$i]
      
      if($dirLay -contains $dir) {
        $isDirLayUsed = $true
        $itmRes += "$i`t$mus`n"
        break
      }
    }
    
    if($isDirLayUsed) { continue }
    
    $dirs += $dirLay
    $itmRes += "$($dirs.Length - 1)`t$mus`n"
  }
  
  $dirRes = ""
  
  for($i = 0; $i -lt $dirs.Length; $i += 1) {
    $dirRes += "$($dirs[$i])`n"
  }
  
  return "$dirRes`n$itmRes"
}

$location = Get-Location
$allFiles = Check-AdditionalDirectories $location.Path $PATH_TOCHECKOUT
$files = Parse-Ignore $PATH_IGNORE $allFiles

$filePaths = (Write-Shrinked $files) -replace "\\", "/"

if(Test-Path $OUT_FILE) {
  Out-File -FilePath $OUT_FILE -InputObject $filePaths
}
else {
  New-Item $OUT_FILE -Type File -Value $filePaths -Force
}
Write-Host "Count of file(s): $($files.Length)"
Pause