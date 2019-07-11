FROM mcr.microsoft.com/dotnet/core/aspnet:2.2-stretch-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:2.2-stretch AS build
WORKDIR /src
COPY ["devopsSessionKubernetes.csproj", ""]
RUN dotnet restore "devopsSessionKubernetes.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "devopsSessionKubernetes.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "devopsSessionKubernetes.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "devopsSessionKubernetes.dll"]