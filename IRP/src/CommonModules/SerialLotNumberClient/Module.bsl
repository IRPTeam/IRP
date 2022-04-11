Procedure PresentationStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, AddInfo = Undefined) Export
	StandardProcessing = False;
	CurrentData = Form.Items.ItemList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;

	Notify = New NotifyDescription("OnFinishEditSerialLotNumbers", ThisObject, New Structure("Object, Form, AddInfo",
		Object, Form, AddInfo));
	OpeningParameters = New Structure();
	OpeningParameters.Insert("Item", CurrentData.Item);
	OpeningParameters.Insert("ItemKey", CurrentData.ItemKey);
	OpeningParameters.Insert("RowKey", CurrentData.Key);
	OpeningParameters.Insert("SerialLotNumbers", New Array());
	OpeningParameters.Insert("Quantity", CurrentData.Quantity);
	ArrayOfSelectedSerialLotNumbers = Object.SerialLotNumbers.FindRows(New Structure("Key", CurrentData.Key));
	For Each Row In ArrayOfSelectedSerialLotNumbers Do
		OpeningParameters.SerialLotNumbers.Add(
		New Structure("SerialLotNumber, Quantity", Row.SerialLotNumber, Row.Quantity));
	EndDo;

	OpenForm("Catalog.SerialLotNumbers.Form.EditListOfSerialLotNumbers", OpeningParameters, ThisObject, , , , Notify,
		FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

Procedure AddNewSerialLotNumbers(Result, Parameters, AddNewLot = False, AddInfo = Undefined) Export
	If TypeOf(Result) <> Type("Structure") Then
		Return;
	EndIf;
	If Not AddNewLot Then
		ArrayOfSerialLotNumbers = Parameters.Object.SerialLotNumbers.FindRows(New Structure("Key", Result.RowKey));
		For Each Row In ArrayOfSerialLotNumbers Do
			Parameters.Object.SerialLotNumbers.Delete(Row);
		EndDo;
	EndIf;
	For Each Row In Result.SerialLotNumbers Do
		NewRow = Parameters.Object.SerialLotNumbers.Add();
		NewRow.Key = Result.RowKey;
		NewRow.SerialLotNumber = Row.SerialLotNumber;
		NewRow.Quantity = Row.Quantity;
	EndDo;
	UpdateSerialLotNumbersPresentation(Parameters.Object, AddInfo);
	UpdateSerialLotNumbersTree(Parameters.Object, Parameters.Form);
EndProcedure

Procedure OnFinishEditSerialLotNumbers(Result, Parameters) Export
	AddNewSerialLotNumbers(Result, Parameters, False, Parameters.AddInfo);
EndProcedure

Procedure PresentationClearing(Object, Form, Item, AddInfo = Undefined) Export
	CurrentData = Form.Items.ItemList.CurrentData;
	If CurrentData = Undefined Or Not CurrentData.Property("SerialLotNumberIsFilling") Then
		Return;
	EndIf;
	CurrentData.SerialLotNumberIsFilling = False;
	DeleteUnusedSerialLotNumbers(Object, CurrentData.Key);
	UpdateSerialLotNumbersTree(Object, Form);
EndProcedure

Procedure PresentationClearingOnCopy(Object, Form, Item, AddInfo = Undefined) Export
	CurrentData = Form.Items.ItemList.CurrentData;
	If CurrentData = Undefined Or Not CurrentData.Property("SerialLotNumberIsFilling") Then
		Return;
	EndIf;
	CurrentData.SerialLotNumberIsFilling = False;
	CurrentData.SerialLotNumbersPresentation.Clear();
EndProcedure

Procedure UpdateSerialLotNumbersPresentation(Object, AddInfo = Undefined) Export
	ServerData = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "ServerData");
	For Each RowItemList In Object.ItemList Do
		ArrayOfSerialLotNumbers = Object.SerialLotNumbers.FindRows(New Structure("Key", RowItemList.Key));
		RowItemList.SerialLotNumbersPresentation.Clear();
		RowItemList.SerialLotNumberIsFilling = False;
		For Each RowSerialLotNumber In ArrayOfSerialLotNumbers Do
			RowItemList.SerialLotNumbersPresentation.Add(RowSerialLotNumber.SerialLotNumber);
			RowItemList.SerialLotNumberIsFilling = True;
		EndDo;
		If ServerData = Undefined Then
			RowItemList.UseSerialLotNumber = 
				SerialLotNumbersServer.IsItemKeyWithSerialLotNumbers(RowItemList.ItemKey);
		Else
			RowItemList.UseSerialLotNumber = 
				ServerData.ItemKeysWithSerialLotNumbers.Find(RowItemList.ItemKey) <> Undefined;
		EndIf;
	EndDo;
EndProcedure

Procedure UpdateSerialLotNumbersTree(Object, Form) Export
	Form.SerialLotNumbersTree.GetItems().Clear();
	For Each RowItemList In Object.ItemList Do
		ArrayOfSerialLotNumbers = Object.SerialLotNumbers.FindRows(New Structure("Key", RowItemList.Key));
		If ArrayOfSerialLotNumbers.Count() Then
			NewRow0 = Form.SerialLotNumbersTree.GetItems().Add();
			NewRow0.Level = 1;
			NewRow0.Key = RowItemList.Key;
			NewRow0.Item = RowItemList.Item;
			NewRow0.ItemKey = RowItemList.ItemKey;
			NewRow0.ItemKeyQuantity = RowItemList.Quantity;

			For Each RowSerialLotNumber In ArrayOfSerialLotNumbers Do
				NewRow1 = NewRow0.GetItems().Add();
				NewRow1.Level = 2;
				NewRow1.Key = RowItemList.Key;
				NewRow1.SerialLotNumber = RowSerialLotNumber.SerialLotNumber;
				NewRow1.Quantity = RowSerialLotNumber.Quantity;
				NewRow0.Quantity = NewRow0.Quantity + RowSerialLotNumber.Quantity;
			EndDo;
		EndIf;
	EndDo;

	If Form.Items.SerialLotNumbersTree.Visible Then
		For Each ItemTreeRows In Form.SerialLotNumbersTree.GetItems() Do
			Form.Items.SerialLotNumbersTree.Expand(ItemTreeRows.GetID());
		EndDo;
	EndIf;
EndProcedure

Procedure UpdateUseSerialLotNumber(Object, Form, AddInfo = Undefined) Export
	
	ServerData = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "ServerData");
	
	CurrentData = Form.Items.ItemList.CurrentData;
	If CurrentData = Undefined And ServerData = Undefined Then
		Return;
	EndIf;

	If Not CurrentData = Undefined Then
		CurrentData.UseSerialLotNumber = 
			SerialLotNumbersServer.IsItemKeyWithSerialLotNumbers(CurrentData.ItemKey);
		If Not CurrentData.UseSerialLotNumber Then
			DeleteUnusedSerialLotNumbers(Object, CurrentData.Key);
		EndIf;
	ElsIf Not ServerData = Undefined Then
		For Each Row In Object.ItemList Do
			Row.UseSerialLotNumber = 
				ServerData.ItemKeysWithSerialLotNumbers.Find(Row.ItemKey) <> Undefined;
			
			If Not Row.UseSerialLotNumber Then
				DeleteUnusedSerialLotNumbers(Object, Row.Key);
			EndIf;
		EndDo;
	Else
		Return;
	EndIf;
	
	UpdateSerialLotNumbersPresentation(Object, AddInfo);
	UpdateSerialLotNumbersTree(Object, Form);
	
EndProcedure

Procedure DeleteUnusedSerialLotNumbers(Object, KeyForDelete = Undefined) Export
	If KeyForDelete = Undefined Then
		ArrayOfUnusedRows = New Array();
		For Each Row In Object.SerialLotNumbers Do
			If Not Object.ItemList.FindRows(New Structure("Key", Row.Key)).Count() Then
				ArrayOfUnusedRows.Add(Row);
			EndIf;
		EndDo;
		For Each Row In ArrayOfUnusedRows Do
			Object.SerialLotNumbers.Delete(Row);
		EndDo;
	Else
		ArrayRowsForDelete = Object.SerialLotNumbers.FindRows(New Structure("Key", KeyForDelete));
		For Each Row In ArrayRowsForDelete Do
			Object.SerialLotNumbers.Delete(Row);
		EndDo;
	EndIf;
EndProcedure
