FROM mcr.microsoft.com/dotnet/aspnet:2.1 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:2.1 AS build
WORKDIR /src
COPY ["ProtobufPOC/ProtobufPOC.csproj", "ProtobufPOC/"]
RUN dotnet restore "ProtobufPOC/ProtobufPOC.csproj"
COPY . .
WORKDIR "/src/ProtobufPOC"
RUN dotnet build "ProtobufPOC.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ProtobufPOC.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ProtobufPOC.dll"]

