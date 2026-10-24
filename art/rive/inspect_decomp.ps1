$ErrorActionPreference = 'Stop'
$path = 'c:\projects\crumbo\art\rive\owl_decomp.scene.json'
# Stream keys only — file is ~1.7MB
$reader = [System.IO.StreamReader]::new($path)
$buf = New-Object char[] 2000
$null = $reader.Read($buf, 0, 2000)
$reader.Close()
$head = -join $buf
Write-Output '--- head ---'
Write-Output $head.Substring(0, [Math]::Min(1500, $head.Length))
