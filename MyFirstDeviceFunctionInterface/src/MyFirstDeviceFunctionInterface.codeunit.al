codeunit 50102 "My First Device Func Iface" implements "IFunction CHHFTMN"
{

    //Example function that accepts an item number, displays the description, and allows the user to enter a new description.
    //Before use, add 'MYFUNCTION' to the function codes table and add it to a device menu.

    var
        SessionMgt: Codeunit "Session Mgt. CHHFTMN";
        MyFirstDeviceFunctionCode: Label 'MYFUNCTIONIF', Locked = true;
        NewDescriptionCaption: Label 'New Desc';

    //Initialize - the first call from the device, intialise data items
    procedure Initialize(FunctionCode: Code[20])
    begin
        case FunctionCode of
            MyFirstDeviceFunctionCode:
                InitMyFunction();
        end;
    end;

    //Validate - validate data items received from device
    procedure Validate(FunctionCode: Code[20]; var ValidationItems: Record "Handheld Content CHHFTMN")
    begin
        case FunctionCode of
            MyFirstDeviceFunctionCode:
                ValidateMyFunction(ValidationItems);
        end;
    end;

    //Cancel - cancellation of data items on device
    procedure Cancel(FunctionCode: Code[20]; var ValidationItems: Record "Handheld Content CHHFTMN")
    begin
        case FunctionCode of
            MyFirstDeviceFunctionCode:
                CancelMyFunction(ValidationItems);
        end;
    end;

    //Post - called once all data items have been entered and all information gathered
    procedure Post(FunctionCode: Code[20])
    begin
        case FunctionCode of
            MyFirstDeviceFunctionCode:
                PostMyFunction();
        end;
    end;

    //Close - called when the device user closes the function
    procedure Close(FunctionCode: Code[20])
    begin
    end;

    local procedure InitMyFunction()
    var
        Item: Record Item;
    begin
        //Item No. data item that is linked to three standard GS1 application identifiers
        SessionMgt.InitResponseData('ITEMNO', Item.FieldCaption("No."), false);
        SessionMgt.AddGS1AppIdent('ITEMNO', "GS1 Identifier CHHFTMN"::AddlProduct);
        SessionMgt.AddGS1AppIdent('ITEMNO', "GS1 Identifier CHHFTMN"::SSC);
        SessionMgt.AddGS1AppIdent('ITEMNO', "GS1 Identifier CHHFTMN"::SSCTradeItems);

        //Current description
        SessionMgt.InitResponseData('ITEMDESC', Item.FieldCaption(Description), true);

        //New description
        SessionMgt.InitResponseData('NEWDESC', NewDescriptionCaption, false);

    end;

    local procedure ValidateMyFunction(var ValidationItems: Record "Handheld Content CHHFTMN")
    var
        Item: Record Item;
        DataItemName: Text;
        DataItemValue: Text;
    begin
        DataItemName := ValidationItems."Column Name";
        DataItemValue := ValidationItems.Text;

        case DataItemName of
            'ITEMNO':
                begin
                    //Get the item, lock "Item No." into the data item, set the current description.
                    Item.Get(DataItemValue);
                    SessionMgt.SetTransResponseData('ITEMNO', Item."No.", true);
                    SessionMgt.SetTransResponseData('ITEMDESC', Item.Description, true);
                end;
            'NEWDESC':
                begin
                    //Set the NEWDESC data item to the new description and 'lock' it.
                    SessionMgt.SetTransResponseData('NEWDESC', DataItemValue, true);
                end;
        end;
    end;

    local procedure CancelMyFunction(var ValidationItems: Record "Handheld Content CHHFTMN")
    var
        DataItemName: Text;
    begin
        DataItemName := ValidationItems."Column Name";
        case DataItemName of
            'ITEMNO':
                begin
                    //Reset all data items
                    SessionMgt.SetTransResponseData('ITEMNO', '', false);
                    SessionMgt.SetTransResponseData('ITEMDESC', '', true);
                    SessionMgt.SetTransResponseData('NEWDESC', '', false);
                end;
            'NEWDESC':
                SessionMgt.SetTransResponseData('NEWDESC', '', false);
        end;
    end;

    local procedure PostMyFunction()
    var
        Item: Record Item;
        ItemNo: Code[20];
        NewDescription: Text;
    begin
        ItemNo := SessionMgt.GetContent('ITEMNO');
        NewDescription := SessionMgt.GetContent('NEWDESC');
        Item.Get(ItemNo);
        Item.Validate(Description, NewDescription);
        Item.Modify(true);

        //Finish off by resetting the data items
        InitMyFunction();
    end;

}
