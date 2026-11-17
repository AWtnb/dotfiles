Invoke-Command -ScriptBlock {
    $name = "dotfiles"
    $src = (Get-Location).Path | Join-Path -ChildPath $name
    $junctionPath = Join-Path $env:USERPROFILE $name

    if (Test-Path $junctionPath) {
        (Get-Item $junctionPath -Force).Delete()
    }
    New-Item -Path $junctionPath -ItemType Junction -Value $src | Out-Null

    $vimrcPath = Join-Path $env:USERPROFILE '_vimrc'
    $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllText($vimrcPath, "source ~/$name/.vimrc`n", $utf8NoBom)
}