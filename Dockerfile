Use the official .NET SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copy the project file and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the code and build
COPY . ./
RUN dotnet publish -c Release -o out

# Use the runtime image for the final container
FROM mcr.microsoft.com/dotnet/runtime:8.0
WORKDIR /app
COPY --from=build /app/out ./
ENTRYPOINT ["dotnet", "MyConsoleApp.dll"]