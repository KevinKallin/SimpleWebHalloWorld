# Hämtar en image from microsfts miljö, där en server körs i molnet. 
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build-env 
# Betämmer att nuvarande app ska köras
WORKDIR /app
# Kopierar min projektfil, som skapas upp när man skapar programmet
COPY *.csproj ./
# När man kör programmet så återställen den dependencies / nuget paket för projektet
RUN dotnet restore

COPY . ./
# Kompilerar applikationen och kollar igenom dependencies som är specifierade i projektfilen
RUN dotnet publish -c Release -o out
# Väljer vilken asp.net version som körs
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
WORKDIR /app
COPY --from=build-env /app/out . 
# Är en instruktion för att kunna konfiguera vilken container som ska köras
ENTRYPOINT ["dotnet", "SimpleWebHalloWorld.dll"]