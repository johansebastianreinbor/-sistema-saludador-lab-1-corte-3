$ErrorActionPreference = 'Stop'
Set-Location -LiteralPath $PSScriptRoot

if (-not $env:JAVA_HOME) {
    $compiler = Get-Command javac -ErrorAction Stop
    $javaSettings = & java -XshowSettings:properties -version 2>&1 | Out-String
    if ($javaSettings -match 'java.home\s*=\s*([^\r\n]+)') {
        $env:JAVA_HOME = $Matches[1].Trim()
    }
}

$maven = Get-Command mvn -ErrorAction SilentlyContinue
if ($maven) {
    & $maven.Source javafx:run
} else {
    $toolsFolder = Join-Path $env:LOCALAPPDATA 'SistemaSaludador\tools'
    $mavenCommand = Join-Path $toolsFolder 'apache-maven-3.9.9\bin\mvn.cmd'
    if (-not (Test-Path -LiteralPath $mavenCommand)) {
        New-Item -ItemType Directory -Path $toolsFolder -Force | Out-Null
        $archive = Join-Path $toolsFolder 'apache-maven-3.9.9-bin.zip'
        Write-Host 'Descargando Maven para iniciar el prototipo...'
        Invoke-WebRequest -Uri 'https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/3.9.9/apache-maven-3.9.9-bin.zip' -OutFile $archive
        Expand-Archive -LiteralPath $archive -DestinationPath $toolsFolder -Force
    }
    & $mavenCommand javafx:run
}
exit $LASTEXITCODE
