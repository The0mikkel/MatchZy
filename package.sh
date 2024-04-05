#!/usr/bin/env bash

VERSION_FILE=artifacts/version.txt

# Get the version from the version file
nextRelease=$(cat $VERSION_FILE)

# Create base package
echo "Creating base package"
dotnet publish -o artifacts/package/addons/counterstrikesharp/plugins/MatchZy
cp -r cfg artifacts/package 
zip -r artifacts/MatchZy-${nextRelease}.zip artifacts/package

# Install CSSharp
echo "Creating package with CounterStrikeSharp (CSSharp)"
cd artifacts/package/
echo "Installing CounterStrikeSharp (CSSharp)"
[ -e addons/counterstrikesharp ] && rm -rf addons/counterstrikesharp && echo "CounterStrikeSharp removed" || echo "old CounterStrikeSharp not found"
curl -s https://api.github.com/repos/roflmuffin/CounterStrikeSharp/releases/latest |
    grep "/counterstrikesharp-with-runtime-build-" |
    cut -d : -f 2,3 |
    tr -d \" |
    head -n 1 |
    wget -O cssharp.zip -qi -
unzip -o cssharp.zip -d .
rm cssharp.zip
cd ../../

dotnet publish -o artifacts/package/addons/counterstrikesharp/plugins/MatchZy

zip -r artifacts/MatchZy-${nextRelease}-with-cssharp.zip artifacts/package