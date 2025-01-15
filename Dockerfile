# Use .NET SDK 8.0 to build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /source

# Copy solution and restore dependencies
COPY *.sln .
COPY BlitzDriftServer/*.csproj ./BlitzDriftServer/
RUN dotnet restore

# Copy the rest of the source code and build the application
COPY BlitzDriftServer/. ./BlitzDriftServer/
WORKDIR /source/BlitzDriftServer
RUN dotnet publish -c release -o /app --no-restore

# Final runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app .
ENTRYPOINT ["dotnet", "BlitzDriftServer.dll"]
