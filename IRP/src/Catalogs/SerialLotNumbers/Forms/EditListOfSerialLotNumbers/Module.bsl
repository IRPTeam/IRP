
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.RowKey = Parameters.RowKey;
	ThisObject.Item = Parameters.Item;
	ThisObject.ItemKey = Parameters.ItemKey;
	ThisObject.ItemType = Parameters.Item.ItemType;
	ThisObject.ItemQuantity = Parameters.Quantity;
	For Each Row In Parameters.SerialLotNumbers Do
		NewRow = ThisObject.SerialLotNumbers.Add();
		NewRow.SerialLotNumber = Row.SerialLotNumber;
		NewRow.Quantity = Row.Quantity;
	EndDo;	
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	UpdateFooter();
EndProcedure

&AtClient
Procedure SerialLotNumbersOnChange(Item)
	UpdateFooter();
	Modified = True;
EndProcedure

&AtClient
Procedure SerialLotNumbersSerialLotNumberStartChoice(Item, ChoiceData, StandardProcessing)
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(
	DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(
	DocumentsClientServer.CreateFilterItem("Inactive", True, DataCompositionComparisonType.NotEqual));
	
	OpenSettings.FormParameters = New Structure();
	OpenSettings.FormParameters.Insert("ItemType"    , ThisObject.ItemType);
	OpenSettings.FormParameters.Insert("Item"        , ThisObject.Item);
	OpenSettings.FormParameters.Insert("ItemKey"     , ThisObject.ItemKey);	
	
	OpenSettings.FormParameters.Insert("FillingData" , 
	New Structure("SerialLotNumberOwner", ThisObject.ItemKey));
	
	DocumentsClient.SerialLotNumberStartChoice(Undefined, ThisObject, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

&AtClient
Procedure SerialLotNumbersSerialLotNumberEditTextChange(Item, Text, StandardProcessing)
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(
	DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(
	DocumentsClientServer.CreateFilterItem("Inactive", True, ComparisonType.NotEqual));
	
	AdditionalParameters = New Structure();
	AdditionalParameters.Insert("ItemType"    , ThisObject.ItemType);
	AdditionalParameters.Insert("Item"        , ThisObject.Item);
	AdditionalParameters.Insert("ItemKey"     , ThisObject.ItemKey);	
	
	DocumentsClient.SerialLotNumbersEditTextChange(Undefined, ThisObject, Item, Text, StandardProcessing, ArrayOfFilters, AdditionalParameters);
EndProcedure

&AtClient
Procedure Ok(Command)
	If Not CheckFilling() Then
		Return;
	EndIf;
	Result = New Structure();
	Result.Insert("RowKey", ThisObject.RowKey);
	Result.Insert("Item", ThisObject.Item);
	Result.Insert("ItemKey", ThisObject.ItemKey);
	Result.Insert("SerialLotNumbers", New Array());
	For Each Row In ThisObject.SerialLotNumbers Do
		Result.SerialLotNumbers.Add(
		New Structure("SerialLotNumber, Quantity", Row.SerialLotNumber, Row.Quantity));
	EndDo;
	Close(Result);
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close(Undefined);
EndProcedure

&AtServer
Procedure FillCheckProcessingAtServer(Cancel, CheckedAttributes)
	RowIndex = 0;
	For Each Row In SerialLotNumbers Do
		If Not ValueIsFilled(Row.SerialLotNumber) Then
			Cancel = True; 
			CommonFunctionsClientServer.ShowUsersMessage(
				StrTemplate(R().Error_010, "Serial lot number"), 
				"SerialLotNumbers[" + Format(RowIndex, "NZ=0; NG=0;") + "].SerialLotNumber", 
				ThisObject);
		EndIf;
		If Not ValueIsFilled(Row.Quantity) Then
			Cancel = True; 
			CommonFunctionsClientServer.ShowUsersMessage(
				StrTemplate(R().Error_010, "Quantity"), 
				"SerialLotNumbers[" + Format(RowIndex, "NZ=0; NG=0;") + "].Quantity", 
				ThisObject);
		EndIf;		
		RowIndex = RowIndex + 1;
	EndDo;	
EndProcedure

&AtClient
Procedure UpdateFooter()
	SelectedCount = SerialLotNumbers.Total("Quantity");
EndProcedure
