{
    This scripts is part of the guide 
    "Converting CBBE To Fusion Girl" by erri120 on the nexus:
    https://www.nexusmods.com/fallout4/mods/40555

    Basic usage:
    1) put the script inside your FO4Edit/Scripts folder
    2) start FO4Edit and select ALL plugins you want to load ingame
    3) select the plugin you want to test
    4) Right click -> Apply Script
    5) Select this script and press Start
    6) go in game, open the console and type "bat bat" or whatever you named the file
}

unit ConversionUtilityScript;

//name of the output file, replace bat.txt with whatever you want but keep the .txt file ending
const pathBatFile = DataPath + '..\' + 'bat.txt';

var batList : TStringList;

function Initialize : integer;
begin
    batList := TStringList.Create;
end;

function Process(e : IInterface) : integer;
begin
    //only process if the elements have the ARMO signature
    if Signature(e) = 'ARMO' then
        //adding the form id with the command to the string list
        batList.Add('player.additem '+IntToHex(GetLoadOrderFormID(e),8))
    else
        //exit if the elements doesnt have the ARMO signature
        exit;
end;

function Finalize : integer;
begin
    //saving the lists to the output file
    batList.SaveToFile(pathBatFile);
    //freeing memory cuz why not
    batList.Free;
end;

end.