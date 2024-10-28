$networkName = "sdk-sqlproj-test"
$sqlContainerName = "test-sqlserver"
$builderImageName = "sql-package-deployer"
$builderContainerName = "sql-deployer"
$sqlPass = "ECSd@shb0ard"
$sqlPort = 1433


$networkExists = docker network ls --format "{{.Name}}" | Where-Object { $_ -eq $networkName }

Write-Host "NETWORK: $networkExists"

if($networkExists) {
    Write-Host "Network $networkName already exists"
} else {
    Write-Host "Creating network $networkName"
    docker network create $networkName
}

Write-Host "Checking if SQL Server container $sqlContainerName is running"
$existingContainer = docker ps --filter "name=$sqlContainerName" --filter "status=running" --format "{{.Names}}"

if ($existingContainer -eq $sqlContainerName) {
    Write-Host "SQL Server container $sqlContainerName is already running"
} else {
    Write-Host "Starting SQL Server container: $sqlContainerName"
    docker run -d --network $networkName --name $sqlContainerName -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=$sqlPass" -p ${sqlPort}:1433 mcr.microsoft.com/mssql/server:2022-latest

    Write-Host "Waiting for SQL Server to start... "
    Start-Sleep -s 30
}

Write-Host "Building image $builderImageName"
docker build -t $builderImageName .

Write-Host "Starting builder container $builderContainerName"
$builderContainerId = docker run -d --rm -e "SQL_PASS=${sqlPass}" -e "SQL_CONTAINER_NAME=${sqlContainerName}" --network $networkName --name $builderContainerName $builderImageName
