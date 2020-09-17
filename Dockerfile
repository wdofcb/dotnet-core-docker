FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY ["dockerDemo.csproj", "./"]
RUN dotnet restore "dockerDemo.csproj"
COPY . .
RUN dotnet build "dockerDemo.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "dockerDemo.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "dockerDemo.dll"]
