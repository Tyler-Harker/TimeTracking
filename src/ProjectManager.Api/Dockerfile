FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS base
RUN apt-get update && apt-get install -y libgssapi-krb5-2 && rm -rf /var/lib/apt/lists/*
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

COPY ["src/ProjectManager.Api/ProjectManager.Api.csproj", "src/ProjectManager.Api/"]
COPY ["src/ProjectManager.ServiceDefaults/ProjectManager.ServiceDefaults.csproj", "src/ProjectManager.ServiceDefaults/"]
RUN dotnet restore "src/ProjectManager.Api/ProjectManager.Api.csproj"

COPY . .
WORKDIR "/src/src/ProjectManager.Api"
RUN dotnet build "ProjectManager.Api.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "ProjectManager.Api.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ProjectManager.Api.dll"]
