FROM mcr.microsoft.com/dotnet/core/sdk:3.0-alpine AS builder
WORKDIR /app

COPY *.sln .
COPY HTTPClient/*.csproj ./HTTPClient/
COPY ProtobufPOC/*.csproj ./ProtobufPOC/
RUN dotnet restore

COPY . .
RUN dotnet build

FROM build AS published
WORKDIR /app/ProtobufPOC
RUN dotnet publish -c Release -o out
FROM mcr.microsoft.com/dotnet/core/aspnet:3.0-alpine AS runtime
WORKDIR /app
COPY --from=publish /app/ProtobufPOC/out ./
RUN dotnet --project ./ProtobufPOC
EXPOSE 80

ENTRYPOINT ["dotnet", "ProtobufPOC.dll" ]
