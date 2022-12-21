
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.Item    = Parameters.Item;
	ThisObject.ItemKey = Parameters.ItemKey;
	If ValueIsFilled(Parameters.Item) Then
		ThisObject.ItemType = Parameters.Item.ItemType;
	EndIf;
	ThisObject.RowKey  = Parameters.RowKey;
	For Each Row In Parameters.SourceOfOrigins Do
		FillPropertyValues(ThisObject.SourceOfOrigins.Add(), Row);
	EndDo;
EndProcedure

&AtClient
Procedure Ok(Command)
	ArrayOfSourceOfOrigins = New Array();
	For Each Row In ThisObject.SourceOfOrigins Do
		NewRow = New Structure();
		NewRow.Insert("Key"             , Row.Key);
		NewRow.Insert("Quantity"        , Row.Quantity);
		NewRow.Insert("SerialLotNumber" , Row.SerialLotNumber);
		NewRow.Insert("SourceOfOrigin"  , Row.SourceOfOrigin);
		ArrayOfSourceOfOrigins.Add(NewRow);
	EndDo;
	Close(New Structure("RowKey, SourceOfOrigins", ThisObject.RowKey, ArrayOfSourceOfOrigins));
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close(Undefined);
EndProcedure

&AtClient
Procedure SourceOfOriginsBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure SourceOfOriginsBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure

&AtClient
Procedure SourceOfOriginsSourceOfOriginCreating(Item, StandardProcessing)
	StandardProcessing = False;
	FormParameters = New Structure();
	FormParameters.Insert("ItemType"    , Undefined);
	FormParameters.Insert("Item"        , ThisObject.Item);
	FormParameters.Insert("ItemKey"     , ThisObject.ItemKey);
	FormParameters.Insert("Description" , Item.EditText);
	OpenForm("Catalog.SourceOfOrigins.ObjectForm", FormParameters, ThisObject, , , , New NotifyDescription("AfterCreateNewSourceOfOrigin", ThisObject));	
EndProcedure

&AtClient
Procedure AfterCreateNewSourceOfOrigin(Result, AddInfo) Export
	Return;
EndProcedure

&AtClient
Procedure SourceOfOriginsSourceOfOriginStartChoice(Item, ChoiceData, StandardProcessing)
	FormParameters = New Structure();
	FormParameters.Insert("ItemType" , ThisObject.ItemType);
	FormParameters.Insert("Item"     , ThisObject.Item);
	FormParameters.Insert("ItemKey"  , ThisObject.ItemKey);
	SourceOfOriginClient.StartChoice(Item, ChoiceData, StandardProcessing, ThisObject, FormParameters);
EndProcedure

&AtClient
Procedure SourceOfOriginsSourceOfOriginEditTextChange(Item, Text, StandardProcessing)
	FormParameters = New Structure();
	FormParameters.Insert("ItemType", ThisObject.ItemType);
	FormParameters.Insert("Item"    , ThisObject.Item);
	FormParameters.Insert("ItemKey" , ThisObject.ItemKey);
	SourceOfOriginClient.EditTextChange(Item, Text, StandardProcessing, ThisObject, FormParameters);
EndProcedure

