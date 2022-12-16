
Procedure PresentationStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	StandardProcessing = False;
	CurrentData = Form.Items.ItemList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;

	Notify = New NotifyDescription("OnFinishEditSourceOfOrigins", ThisObject, New Structure("Object, Form", Object, Form));
	OpeningParameters = New Structure();
	OpeningParameters.Insert("Item"    , CurrentData.Item);
	OpeningParameters.Insert("ItemKey" , CurrentData.ItemKey);
	OpeningParameters.Insert("RowKey"  , CurrentData.Key);
	OpeningParameters.Insert("SourceOfOrigins", New Array());
	
	SerialLotNumbers = Object.SerialLotNumbers.FindRows(New Structure("Key", CurrentData.Key));
	
	If SerialLotNumbers.Count() Then
	
		For Each Row_SerialLotNumbers In SerialLotNumbers Do
			Filter = New Structure();
			Filter.Insert("Key"             , CurrentData.Key);
			Filter.Insert("SerialLotNumber" , Row_SerialLotNumbers.SerialLotNumber);
			SourceOfOrigins = Object.SourceOfOrigins.FindRows(Filter);
			If SourceOfOrigins.Count() Then
				For Each Row_SourceOfOrigins In SourceOfOrigins Do
					NewRow = New Structure();
					NewRow.Insert("Key"            , CurrentData.Key);
					NewRow.Insert("SerialLotNumber", Row_SourceOfOrigins.SerialLotNumber);
					NewRow.Insert("SourceOfOrigin" , Row_SourceOfOrigins.SourceOfOrigin);
					NewRow.Insert("Quantity"       , Row_SourceOfOrigins.Quantity);
					OpeningParameters.SourceOfOrigins.Add(NewRow);
				EndDo;
			Else
				NewRow = New Structure();
				NewRow.Insert("Key"            , CurrentData.Key);
				NewRow.Insert("SerialLotNumber", Row_SerialLotNumbers.SerialLotNumber);
				NewRow.Insert("Quantity"       , Row_SerialLotNumbers.Quantity);
				OpeningParameters.SourceOfOrigins.Add(NewRow);
			EndIf;
		EndDo;
	
	Else
		Filter = New Structure();
		Filter.Insert("Key", CurrentData.Key);
		SourceOfOrigins = Object.SourceOfOrigins.FindRows(Filter);
		If SourceOfOrigins.Count() Then
			For Each Row_SourceOfOrigins In SourceOfOrigins Do
				NewRow = New Structure();
				NewRow.Insert("Key"            , CurrentData.Key);
				NewRow.Insert("SourceOfOrigin" , Row_SourceOfOrigins.SourceOfOrigin);
				NewRow.Insert("Quantity"       , Row_SourceOfOrigins.Quantity);
				OpeningParameters.SourceOfOrigins.Add(NewRow);
			EndDo;
		Else
			NewRow = New Structure();
			NewRow.Insert("Key"      , CurrentData.Key);
			NewRow.Insert("Quantity" , CurrentData.QuantityInBaseUnit);
			OpeningParameters.SourceOfOrigins.Add(NewRow);
		EndIf;	
	EndIf;

	OpenForm("Catalog.SourceOfOrigins.Form.EditSourceOfOrigins", OpeningParameters, ThisObject, , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

Procedure AddNewSourceOfOrigins(Result, Parameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	
	ArrayForDelete = Parameters.Object.SourceOfOrigins.FindRows(New Structure("Key", Result.RowKey));
	
	For Each Row In ArrayForDelete Do
		Parameters.Object.SourceOfOrigins.Delete(Row);
	EndDo;
	
	For Each Row In Result.SourceOfOrigins Do
		NewRow = Parameters.Object.SourceOfOrigins.Add();
		FillPropertyValues(NewRow, Row);
		NewRow.Key = Result.RowKey;
	EndDo;
	
	RecalculateConsignorBatches(Parameters.Object, Parameters.Form);
	UpdateSourceOfOriginsPresentation(Parameters.Object);
EndProcedure

Procedure OnFinishEditSourceOfOrigins(Result, Parameters) Export
	AddNewSourceOfOrigins(Result, Parameters);
EndProcedure

Procedure PresentationClearing(Object, Form, Item, AddInfo = Undefined) Export
	CurrentData = Form.Items.ItemList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	DeleteUnusedSourceOfOrigins(Object, Form, CurrentData.Key);
EndProcedure

Procedure UpdateSourceOfOriginsQuantity(Object, Form) Export
	If Not CommonFunctionsClientServer.ObjectHasProperty(Object, "SourceOfOrigins") Then
		Return;
	EndIf;
	For Each Row_ItemList In Object.ItemList Do
		SerialLotNumbers = Object.SerialLotNumbers.FindRows(New Structure("Key", Row_ItemList.Key));
		If SerialLotNumbers.Count() Then
			
			SerialLotNumbersGrouped = New Array();
			For Each Row0 In SerialLotNumbers Do
				FoundRow = Undefined;
				For Each Row1 In SerialLotNumbersGrouped Do
					If Row0.Key = Row1.Key And Row0.SerialLotNumber = Row1.SerialLotNumber Then
						FoundRow = Row1;
						Break;
					EndIf;
				EndDo;
				If FoundRow <> Undefined Then
					FoundRow.Quantity = FoundRow.Quantity + Row0.Quantity;
				Else
					SerialLotNumbersGrouped.Add(New Structure("Key, SerialLotNumber, Quantity", Row0.Key, Row0.SerialLotNumber, Row0.Quantity));
				EndIf;
			EndDo;
			
			For Each Row_SerialLotNumbers In SerialLotNumbersGrouped Do // SerialLotNumbers
				SourceOfOrigins = Object.SourceOfOrigins.FindRows(New Structure("Key, SerialLotNumber", 
					Row_ItemList.Key, Row_SerialLotNumbers.SerialLotNumber));
					
				If SourceOfOrigins.Count() = 1 Then
					SourceOfOrigins[0].Quantity = Row_SerialLotNumbers.Quantity;
				ElsIf SourceOfOrigins.Count() > 1 Then
					For Each Row_SourceOfOrigins In SourceOfOrigins Do
						Object.SourceOfOrigins.Delete(Row_SourceOfOrigins);
					EndDo;
					NewRow = Object.SourceOfOrigins.Add();
					NewRow.Key = Row_ItemList.Key; 
					NewRow.SerialLotNumber = Row_SerialLotNumbers.SerialLotNumber;
					NewRow.Quantity = Row_SerialLotNumbers.Quantity;				
				Else // SourceOfOrigins.Count() = 0
					NewRow = Object.SourceOfOrigins.Add();
					NewRow.Key = Row_ItemList.Key; 
					NewRow.SerialLotNumber = Row_SerialLotNumbers.SerialLotNumber;
					NewRow.Quantity = Row_SerialLotNumbers.Quantity;				
				EndIf;
			EndDo; // SerialLotNumbers
			
		Else // Not SerialLotNumbers.Count()
			
			SourceOfOrigins = Object.SourceOfOrigins.FindRows(New Structure("Key", Row_ItemList.Key));
			If SourceOfOrigins.Count() = 1 Then
				SourceOfOrigins[0].SerialLotNumber = Undefined;
				SourceOfOrigins[0].Quantity = Row_ItemList.QuantityInBaseUnit;
			ElsIf SourceOfOrigins.Count() > 1 Then
				For Each Row_SourceOfOrigins In SourceOfOrigins Do
					Object.SourceOfOrigins.Delete(Row_SourceOfOrigins);
				EndDo;
				NewRow = Object.SourceOfOrigins.Add();
				NewRow.Key = Row_ItemList.Key; 
				NewRow.Quantity = Row_ItemList.QuantityInBaseUnit; 				
			Else // SourceOfOrigins.Count() = 0
				NewRow = Object.SourceOfOrigins.Add();
				NewRow.Key = Row_ItemList.Key; 
				NewRow.Quantity = Row_ItemList.QuantityInBaseUnit; 
			EndIf;
			
		EndIf; // SerialLotNumbers.Count()
	EndDo;
	DeleteUnusedSourceOfOrigins(Object, Form);
	UpdateSourceOfOriginsPresentation(Object);
EndProcedure

Procedure DeleteUnusedSourceOfOrigins(Object, Form, KeyForDelete = Undefined) Export
	If KeyForDelete = Undefined Then
		ArrayForDelete = New Array();
		For Each Row In Object.SourceOfOrigins Do
			If Not Object.ItemList.FindRows(New Structure("Key", Row.Key)).Count() Then
				ArrayForDelete.Add(Row);
			EndIf;
		EndDo;
		For Each Row In ArrayForDelete Do
			Object.SourceOfOrigins.Delete(Row);
		EndDo;
	Else
		ArrayForDelete = Object.SourceOfOrigins.FindRows(New Structure("Key", KeyForDelete));
		For Each Row In ArrayForDelete Do
			Object.SourceOfOrigins.Delete(Row);
		EndDo;
	EndIf;
	
	If Object.Property("SerialLotNumbers") Then
		ArrayForDelete = New Array();
		For Each Row In Object.SourceOfOrigins Do
			If Not ValueIsFilled(Row.SerialLotNumber) And Not Object.SerialLotNumbers.FindRows(New Structure("Key", Row.Key)).Count() Then
				Continue;
			EndIf;
			
			Filter = New Structure();
			Filter.Insert("Key", Row.Key);
			Filter.Insert("SerialLotNumber", Row.SerialLotNumber);
			If Not Object.SerialLotNumbers.FindRows(Filter).Count() Then
				ArrayForDelete.Add(Row);
			EndIf;
		EndDo;
		
		For Each Row In ArrayForDelete Do
			Object.SourceOfOrigins.Delete(Row);
		EndDo;
	EndIf;
	
	RecalculateConsignorBatches(Object, Form);
EndProcedure

Procedure RecalculateConsignorBatches(Object, Form)
	If Not Object.Property("ConsignorBatches") Then
		Return;
	EndIf;
	
	FormParameters = ControllerClientServer_V2.GetFormParameters(Form);
	ServerParameters = ControllerClientServer_V2.GetServerParameters(Object);
	ServerParameters.TableName = "ItemList";		
	
	Rows = New Array();          
	ConsignorStocks = PredefinedValue("Enum.InventoryOrigingTypes.ConsignorStocks");
	For Each Row In Object.ItemList Do
		If Row.InventoryOrigin = ConsignorStocks Then
			Rows.Add(Rows);
		EndIf;
	EndDo;
	
	Parameters = ControllerClientServer_V2.GetParameters(ServerParameters, FormParameters);
	Parameters.Rows = Rows;
	
	Property = New Structure("DataPath", "Command_UpdateConsignorBatches");
	ControllerClientServer_V2.API_SetProperty(Parameters, Property, Undefined);	
EndProcedure

Procedure UpdateSourceOfOriginsPresentation(Object) Export
	For Each RowItemList In Object.ItemList Do
		ArrayOfSourceOfOrigins = Object.SourceOfOrigins.FindRows(New Structure("Key", RowItemList.Key));
		RowItemList.SourceOfOriginsPresentation.Clear();		
		For Each RowSourceOfOrigins In ArrayOfSourceOfOrigins Do
			If ValueIsFilled(RowSourceOfOrigins.SourceOfOrigin) Then
				RowItemList.SourceOfOriginsPresentation.Add(RowSourceOfOrigins.SourceOfOrigin);
			EndIf;
		EndDo;
	EndDo;
EndProcedure

Procedure StartChoice(Item, ChoiceData, StandardProcessing, Object, Params) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Inactive", True, DataCompositionComparisonType.NotEqual));

	OpenSettings.FormParameters = New Structure();
	OpenSettings.FormParameters.Insert("ItemType" , Params.ItemType);
	OpenSettings.FormParameters.Insert("Item"     , Params.Item);
	OpenSettings.FormParameters.Insert("ItemKey"  , Params.ItemKey);

	OpenSettings.FormParameters.Insert("FillingData", New Structure("SourceOfOriginOwner", Params.ItemKey));

	DocumentsClient.SourceOfOriginsStartChoice(Undefined, Object, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure EditTextChange(Item, Text, StandardProcessing, Object, Params) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Inactive", True, ComparisonType.NotEqual));

	AdditionalParameters = New Structure();
	AdditionalParameters.Insert("ItemType" , Params.ItemType);
	AdditionalParameters.Insert("Item"     , Params.Item);
	AdditionalParameters.Insert("ItemKey"  , Params.ItemKey);

	DocumentsClient.SourceOfOriginsEditTextChange(Undefined, Object, Item, Text, StandardProcessing, ArrayOfFilters, AdditionalParameters);
EndProcedure
