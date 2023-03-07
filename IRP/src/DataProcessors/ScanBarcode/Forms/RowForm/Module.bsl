
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	FillPropertyValues(ThisObject, Parameters.FillingData);
	ParamsData = Parameters.FillingData;
	
	NeedSerialLotNumber = Not ValueIsFilled(ThisObject.SerialLotNumber) And ThisObject.Item.ItemType.UseSerialLotNumber;
	Items.GroupSerialLotNumber.Visible = NeedSerialLotNumber;
	Items.SerialLotNumberLabel.Visible = Not NeedSerialLotNumber;
EndProcedure

&AtClient
Procedure OK()
	ParamsData.Quantity = ScannedQuantity;
	Close(ParamsData);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	AttachIdleHandler("SetActiveField", 1, True);
EndProcedure

&AtClient
Procedure SetActiveField() Export
	
	If NeedSerialLotNumber Then
		ThisObject.CurrentItem = Items.SerialLotNumber;
	Else
		ThisObject.CurrentItem = Items.ScannedQuantity;
	EndIf;
	
#If MobileClient Then
	BeginEditingItem();
#EndIf

EndProcedure

&AtClient
Procedure ScannedQuantityOnChange(Item)
	OK();
EndProcedure

#Region SERIAL_LOT_NUMBERS

&AtClient
Procedure SerialLotNumberStartChoice(Item, ChoiceData, StandardProcessing) Export
	FormParameters = New Structure();
	FormParameters.Insert("ItemType", Undefined);
	FormParameters.Insert("Item", ThisObject.Item);
	FormParameters.Insert("ItemKey", ThisObject.ItemKey);
	SerialLotNumberClient.StartChoice(Item, ChoiceData, StandardProcessing, ThisObject, FormParameters);
EndProcedure

&AtClient
Procedure SerialLotNumberEditTextChange(Item, Text, StandardProcessing)
	FormParameters = New Structure();
	FormParameters.Insert("ItemType", Undefined);
	FormParameters.Insert("Item", ThisObject.Item);
	FormParameters.Insert("ItemKey", ThisObject.ItemKey);
	SerialLotNumberClient.EditTextChange(Item, Text, StandardProcessing, ThisObject, FormParameters);
EndProcedure

&AtClient
Procedure SerialLotNumberCreating(Item, StandardProcessing)
	StandardProcessing = False;
	
	FormParameters = New Structure();
	FormParameters.Insert("ItemType", Undefined);
	FormParameters.Insert("Item", ThisObject.Item);
	FormParameters.Insert("ItemKey", ThisObject.ItemKey);
	FormParameters.Insert("Description", Item.EditText);
	
	OpenForm("Catalog.SerialLotNumbers.ObjectForm", FormParameters, ThisObject, , , , New NotifyDescription("AfterCreateNewSerial", ThisObject));
EndProcedure

&AtClient
Procedure AfterCreateNewSerial(Result, AddInfo) Export
	If ValueIsFilled(Result) Then
		ThisObject.SerialLotNumber = Result;
	EndIf;
EndProcedure

#EndRegion