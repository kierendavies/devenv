[CmdletBinding()]

param ()

process {
    $dataDir = New-Item -Force -Path $env:APPDATA -Name 'devenv' -ItemType 'directory'
    $tempDir = New-Item -Force -Path ([System.IO.Path]::GetTempPath()) -Name 'devenv' -ItemType 'directory'

    $packages = @(
        'Alacritty.Alacritty',
        'Canonical.Ubuntu',
        'Git.Git',
        'Microsoft.PowerShell',
        'VSCodium.VSCodium'
    )
    foreach ($pkg in $packages) {
        $out = winget list --exact --id $pkg
        $exitCode = $LASTEXITCODE
        # https://github.com/microsoft/winget-cli/blob/de858f8531f5fc93bea63d159bdd685760e26d8f/src/AppInstallerCommonCore/Public/AppInstallerErrors.h#L35
        if ($exitCode -eq 0) {
            Write-Output "$pkg already installed"
        } elseif ($exitCode -eq 0x8A150014) {
            Write-Output "Installing $pkg"
            winget install --exact --id $pkg
        } else {
            Write-Output $out
            exit $exitCode
        }
    }

    $ubuntuLnkPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Ubuntu (Alacritty).lnk"
    if (-not (Test-Path $ubuntuLnkPath)) {
        Write-Output 'Creating shortcut for Ubuntu (Alacritty)'
        Copy-Item -Path "$PSScriptRoot\ubuntu.ico" -Destination "$dataDir\ubuntu.ico"
        $lnk = (New-Object -ComObject WScript.Shell).CreateShortcut($ubuntuLnkPath)
        $lnk.TargetPath = 'alacritty.exe'
        $lnk.Arguments = '--command "wsl --distribution Ubuntu --cd ~"'
        $lnk.IconLocation = '%APPDATA%\devenv\ubuntu.ico'
        $lnk.Save()
    }

    $shellApp = (New-Object -ComObject Shell.Application)
    $fonts = $shellApp.NameSpace(0x14)
    $hackFont = $fonts.ParseName('Hack NF')
    # Hack font family contains Regular, Bold, Italic, and Bold Italic
    if ($hackFont -and ($hackFont.GetFolder.Items().count -eq 4) -and $false) {
        Write-Output 'Hack Nerd Font already installed'
    } else {
        Write-Output 'Installing Hack Nerd Font'

        if (-not (Test-Path "$tempDir\Hack.zip")) {
            Invoke-WebRequest 'https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip' -OutFile "$tempDir\Hack.zip"
            Expand-Archive -Path "$tempDir\Hack.zip" -DestinationPath "$tempDir\Hack"
        }

        $hackWinCompat = Get-ChildItem "$tempDir\Hack" -File -Filter '* Windows Compatible.ttf' -Recurse
        foreach ($f in $hackWinCompat) {
            if (Test-Path "$env:LOCALAPPDATA\Microsoft\Windows\Fonts\$f") {
                Write-Output "$($f.BaseName) already installed"
            } else {
                Write-Output "Installing font $($f.BaseName)"
                # If we Copy-Item, the font doesn't seem to get registered :(
                # https://docs.microsoft.com/en-us/previous-versions/windows/desktop/sidebar/system-shell-folder-copyhere
                # https://stackoverflow.com/a/12170448
                $fonts.CopyHere($f.FullName, 4)
            }
        }
    }

    if (-not (Test-Path "$env:APPDATA\alacritty\alacritty.yml")) {
        Write-Output 'Writing alacritty.yml'
        New-Item -Force -Path $env:APPDATA -Name 'alacritty' -ItemType 'directory' | Out-Null
        Copy-Item -Path "$PSSourceRoot\alacritty.yml" -Destination "$env:APPDATA\alacritty\alacritty.yml"
    }
}

end {
}
