Invoke-Command -ScriptBlock {
    $src = (Get-Location).Path
    $repoName = Split-Path -Leaf $src
    $junctionPath = Join-Path $env:USERPROFILE $repoName

    if (Test-Path $junctionPath) {
        (Get-Item $junctionPath -Force).Delete()
    }
    New-Item -Path $junctionPath -ItemType Junction -Value $src | Out-Null

    $vimrcPath = Join-Path $env:USERPROFILE '_vimrc'
    $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllText($vimrcPath, "source ~/$repoName/.vimrc`n", $utf8NoBom)
}