# Proof of Concept for Deploying Containerized SDK-Style .sqlproj Project

This repo is a PoC for an MS SQL Server being built from a sql project (.sqlproj) using the [Microsoft.Build.Sql](https://www.nuget.org/packages/Microsoft.build.sql) package.

# What Concept is Being Tested Here?
With the powershell script within this repo, one can:
   1.  Run the script
   2.  See a sql server container on their local machine
   3.  Successfully connect to the containerized server
   4.  Verify that the schema of the sql server reflects the sql files within the repo.
   5.  Add, Modify, or Delete sql files within the project
   6.  Run the script again
   7.  Verify that the schema has changed according to the sql changes
   8.  Repeat steps 5 through 7

# Reasons for Spending Time on This
The new [SDK-Style Projects](https://techcommunity.microsoft.com/t5/azure-sql-blog/microsoft-build-sql-the-next-frontier-of-sql-projects/ba-p/3290628), based on the aforementioned nuget package, offers some benefits over the classic msbuild sql projects, in addition to being the shiny new thing and being further up on Microsoft's maintenance schedule.

For one, The package introduces full globbing, meaning the .sqlproj file won't have to be edited to include/delete a sql definition file each time one is added in the file system.

For two, the build tool can now be deployed cross-platform.

For three , as [this article](https://techcommunity.microsoft.com/t5/azure-sql-blog/preview-release-of-sdk-style-sql-projects-in-visual-studio-2022/ba-p/4240616) mentions, Code analysis extensibility is in the works!

With the business moving towards newer .NET versions and pushing for more CI/CD, this PoC should be a useful pattern to have in the business' repertoire. 

# Structure
There is roughly 3 parts to this repo
1. The sqlproj and sql file(s)
2. The Dockerfile defining the builder container
3. The `StartLocalContainer.ps1` script

The Powershell script:
1. Spins up a MS SQL Server container if it doesn't exist
2. Builds the .sqlproj into a DACPAC file via the build container
3. Deploys the DACPAC file onto the SQL Server container, also via the build container.

# Instructions
### Running The Script
To make sure that no chicanery happens during the script deployment, run `docker pull mcr.microsoft.com/mssql/server:2022-latest` to download the server image. Additionally, make sure no container/process is using the 1433 port

Afterwards, simply run `StartLocalContainer.ps1` in Powershell.

### Connecting to SQL Server
To verify that the SQL Server was correctly deployed, go to `localhost:1433` in SSMS or Azure Data Studio.

- User: `sa`
- Pass: `ECSd@shb0ard`

With just the TestTable.sql file, the table should show under `System Databases > master > dbo`


# Tooling
### Visual Studio
Starting with VS 17.12.x (VS 2022), the [SQL Server Data Tools, SDK-style](https://learn.microsoft.com/en-us/sql/ssdt/sql-server-data-tools-sdk-style?view=sql-server-ver16) becomes available to install.

With classic Visual Studio, opening a sdk-style sqlproj would add an .sln to the file system and the sql scripts won't show unless explicitly added in the sqlproj file.

# Limitations
[Here](https://learn.microsoft.com/en-us/sql/tools/sql-database-projects/sql-projects-tools?view=sql-server-ver16) is a MS docs article that compares SQL Project Tools for functionalities

Notable limitations:
- No Project/DacPac Reference Support

# References
- Overview For SQL Server Data Tools, SDK-style: https://learn.microsoft.com/en-us/sql/ssdt/sql-server-data-tools-sdk-style?view=sql-server-ver16
- Overview for SDK-Style SQL projects: https://learn.microsoft.com/en-us/azure-data-studio/extensions/sql-database-project-extension-sdk-style-projects
- Microsoft's DacFx repository, which includes SqlPackage and Microsoft.Build.Sql, on Github: https://github.com/microsoft/dacfx
