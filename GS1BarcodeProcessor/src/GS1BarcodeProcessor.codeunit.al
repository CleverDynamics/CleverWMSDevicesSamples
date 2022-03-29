codeunit 50100 "Sample Barcode Processor" implements "IBarcodeProcessor CHHFTMN"
{
    var
        SessionMgt: Codeunit "Session Mgt. CHHFTMN";

    procedure ProcessBase64DriverData(Base64DriverData: Text)
    begin
    end;

    procedure ProcessBase64TextData(TextData: Text)
    var
        Base64Convert: Codeunit "Base64 Convert";
    begin
        if StrLen(TextData) = 0 then
            exit;
        if SessionMgt.GetBarcodeAIMId() = ']d1' then
            ProcessRev00GS1Barcode(Base64Convert.FromBase64(TextData))
        else
            ProcessGS1Barcode(Base64Convert.FromBase64(TextData));
    end;

    local procedure ProcessRev00GS1Barcode(BarcodeData: Text)
    var
        LoopCount: Integer;
        AppIdent: Enum "GS1 Identifier CHHFTMN";
        AppIdentValue: Text;
    begin
        repeat
            AppIdent := GetNextGS1AI(BarcodeData);
            case AppIdent of
                AppIdent::SSC:
                    AppIdentValue := CopyStr(BarcodeData, 1, 14);
                AppIdent::BatchNumber:
                    AppIdentValue := CopyStr(BarcodeData, 1, 14);
                AppIdent::ProdDate:
                    AppIdentValue := CopyStr(BarcodeData, 1, 6);
                AppIdent::ExpirationDate:
                    AppIdentValue := CopyStr(BarcodeData, 1, 6);
                AppIdent::SerialNumber:
                    AppIdentValue := CopyStr(BarcodeData, 1, 3);
            end;
            SessionMgt.SetValidationDataItem(SessionMgt.GetDataItemByAppIdent(AppIdent), AppIdentValue);
            BarcodeData := CopyStr(BarcodeData, StrLen(AppIdentValue) + 1);
            LoopCount += 1;
        until (BarcodeData = '') or (LoopCount >= 5);
    end;

    local procedure ProcessGS1Barcode(BarcodeData: Text)
    var
        LoopCount: Integer;
        AppIdent: Enum "GS1 Identifier CHHFTMN";
        AppIdentValue: Text;
    begin
        repeat
            AppIdent := GetNextGS1AI(BarcodeData);
            case AppIdent of
                AppIdent::SSC:
                    begin
                        AppIdentValue := CopyStr(BarcodeData, 1, 14);
                        BarcodeData := CopyStr(BarcodeData, 15);
                    end;
                AppIdent::ProdDate, AppIdent::ExpirationDate:
                    begin
                        AppIdentValue := CopyStr(BarcodeData, 1, 6);
                        BarcodeData := CopyStr(BarcodeData, 7);
                    end;
                AppIdent::BatchNumber, AppIdent::AddlProduct, AppIdent::SerialNumber:
                    AppIdentValue := GetVariableAIValue(BarcodeData);
            end;
            SessionMgt.SetValidationDataItem(SessionMgt.GetDataItemByAppIdent(AppIdent), AppIdentValue);
            LoopCount += 1;
        until (BarcodeData = '') or (LoopCount >= 6);
    end;

    local procedure GetNextGS1AI(var BarcodeData: Text) AppIdent: Enum "GS1 Identifier CHHFTMN"
    begin
        case CopyStr(BarcodeData, 1, 2) of
            '01', '10', '11', '17', '21':
                begin
                    AppIdent := GetAIEnum(CopyStr(BarcodeData, 1, 2));
                    BarcodeData := CopyStr(BarcodeData, 3);
                end;
            else
                case CopyStr(BarcodeData, 1, 3) of
                    '240':
                        begin
                            AppIdent := GetAIEnum(CopyStr(BarcodeData, 1, 3));
                            BarcodeData := CopyStr(BarcodeData, 4);
                        end;
                end;
        end;
    end;

    local procedure GetAIEnum(AppIdentText: Text): Enum "GS1 Identifier CHHFTMN"
    begin
        case AppIdentText of
            '01':
                exit("GS1 Identifier CHHFTMN"::SSC);
            '10':
                exit("GS1 Identifier CHHFTMN"::BatchNumber);
            '11':
                exit("GS1 Identifier CHHFTMN"::ProdDate);
            '17':
                exit("GS1 Identifier CHHFTMN"::ExpirationDate);
            '21':
                exit("GS1 Identifier CHHFTMN"::SerialNumber);
            '240':
                exit("GS1 Identifier CHHFTMN"::AddlProduct);
        end
    end;

    local procedure GetVariableAIValue(var BarcodeData: Text) AppIdentValue: Text
    begin
        if not BarcodeData.Contains(GSChar()) then begin
            AppIdentValue := BarcodeData;
            BarcodeData := '';
        end else begin
            AppIdentValue := Copystr(BarcodeData, 1, BarcodeData.IndexOf(GSChar()) - 1);
            BarcodeData := CopyStr(BarcodeData, StrLen(AppIdentValue) + 2);
        end;
    end;

    local procedure GSChar(): Char
    begin
        exit(29);
    end;

}