{
    This script is part of the Conversion Utility made by erri120 found on the nexus: https://www.nexusmods.com/fallout4/mods/40097
    MIT License

    Copyright (c) 2019 erri120

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
}

unit ConversionUtilityScript;

const pathBatFile = DataPath + '..\' + 'bat.txt';

var batList : TStringList;

function Initialize : integer;
begin
    batList := TStringList.Create;
    //ARMOList.Add('FormID;EditorID;Name;MODL-ArmorAddon');
    //ARMAList.Add('FormID;EditorID;MOD3-ModelFileName');
end;

function Process(e : IInterface) : integer;
begin
    //only process if the elements have ARMO or ARMA signature
    if Signature(e) = 'ARMO' then
        //adding the ARMO element to the list
        batList.Add('player.additem '+IntToHex(GetLoadOrderFormID(e),8))
    else
        //exit if the element doesnt have the signature ARMO
        exit;
end;

function Finalize : integer;
begin
    //saving the lists to the output file
    batList.SaveToFile(pathBatFile);
    batList.Free;
end;

end.