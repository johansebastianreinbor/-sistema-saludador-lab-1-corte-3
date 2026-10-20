param([string]$OutputDirectory = 'dist')

$ErrorActionPreference = 'Stop'
Set-Location -LiteralPath $PSScriptRoot

if (-not $env:JAVA_HOME) {
    $ErrorActionPreference = 'Continue'
    $settings = & java -XshowSettings:properties -version 2>&1 | Out-String
    $ErrorActionPreference = 'Stop'
    if ($settings -match 'java.home\s*=\s*([^\r\n]+)') {
        $env:JAVA_HOME = $Matches[1].Trim()
    }
}
$jpackage = Join-Path $env:JAVA_HOME 'bin\jpackage.exe'
if (-not (Test-Path -LiteralPath $jpackage)) {
    throw 'Se necesita un JDK 17 o superior con jpackage. Configura JAVA_HOME.'
}

$destination = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot $OutputDirectory))
if (Test-Path -LiteralPath (Join-Path $destination 'SistemaSaludador')) {
    throw 'El destino ya contiene un build. Usa -OutputDirectory con otra carpeta.'
}
$maven = Get-Command mvn -ErrorAction SilentlyContinue
if ($maven) {
    $mavenCommand = $maven.Source
} else {
    $toolsFolder = Join-Path $env:LOCALAPPDATA 'SistemaSaludador\tools'
    $mavenCommand = Join-Path $toolsFolder 'apache-maven-3.9.9\bin\mvn.cmd'
    if (-not (Test-Path -LiteralPath $mavenCommand)) {
        New-Item -ItemType Directory -Path $toolsFolder -Force | Out-Null
        $archive = Join-Path $toolsFolder 'apache-maven-3.9.9-bin.zip'
        Invoke-WebRequest -Uri 'https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/3.9.9/apache-maven-3.9.9-bin.zip' -OutFile $archive
        Expand-Archive -LiteralPath $archive -DestinationPath $toolsFolder -Force
    }
}

$staging = Join-Path $PSScriptRoot ('target\package-' + [guid]::NewGuid().ToString('N'))
$inputFolder = Join-Path $staging 'input'
$modulesFolder = Join-Path $staging 'modules'
& $mavenCommand -B package 'org.apache.maven.plugins:maven-dependency-plugin:3.8.1:copy-dependencies' "-DoutputDirectory=$modulesFolder" '-DincludeScope=runtime' '-DincludeClassifiers=win'
if ($LASTEXITCODE -ne 0) { throw 'La compilacion o la descarga de dependencias fallo.' }
New-Item -ItemType Directory -Path $inputFolder -Force | Out-Null
Copy-Item -LiteralPath 'target\sistema-saludador-1.0-SNAPSHOT.jar' -Destination $inputFolder
& $jpackage --type app-image --name SistemaSaludador --app-version 1.0.0 --vendor 'Sistema Saludador' --description 'Prototipo de saludos para estudiantes' --input $inputFolder --main-jar sistema-saludador-1.0-SNAPSHOT.jar --main-class com.saludador.SistemaSaludador --module-path $modulesFolder --add-modules javafx.controls --java-options '--add-modules=javafx.controls' --java-options '--enable-native-access=javafx.graphics' --dest $destination
if ($LASTEXITCODE -ne 0) { throw 'No se pudo generar el ejecutable con jpackage.' }
$appFolder = Join-Path $destination 'SistemaSaludador'
Compress-Archive -LiteralPath $appFolder -DestinationPath (Join-Path $destination 'SistemaSaludador-Windows.zip')
Write-Host "Build creado: $appFolder\SistemaSaludador.exe"
