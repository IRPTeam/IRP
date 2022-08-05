
Procedure OnCreateAtServer(Object, Form, TableNames) Export
	ArrayOfNewAttribute = New Array();
	If Not CommonFunctionsServer.FormHaveAttribute(Form, "CacheBeforeChange") Then
		ArrayOfNewAttribute.Add(New FormAttribute("CacheBeforeChange", New TypeDescription()));
	EndIf;
	If Not CommonFunctionsServer.FormHaveAttribute(Form, "IsCopyingInteractive") Then
		ArrayOfNewAttribute.Add(New FormAttribute("IsCopyingInteractive", New TypeDescription("Boolean")));
	EndIf;
	
	If ArrayOfNewAttribute.Count() Then
		Form.ChangeAttributes(ArrayOfNewAttribute);
	EndIf;
	// Copying document on client
	Form.IsCopyingInteractive =  Form.Parameters.Property("CopyingValue") And ValueIsFilled(Form.Parameters.CopyingValue);
	
	For Each TableName In StrSplit(TableNames, ",") Do
		FormParameters = ControllerClientServer_V2.GetFormParameters(Form);
		ServerParameters = ControllerClientServer_V2.GetServerParameters(Object);
		ServerParameters.TableName = TrimAll(TableName);
		Parameters = ControllerClientServer_V2.GetParameters(ServerParameters, FormParameters);
		ControllerClientServer_V2.FormOnCreateAtServer(Parameters);
	EndDo;
EndProcedure

#Region FORM_MODIFICATOR

Procedure FormModificator_CreateTaxesFormControls(Parameters) Export
	Parameters.Form.Taxes_CreateFormControls();
EndProcedure

#EndRegion

Procedure API_CallbackAtServer(Object, Form, TableName, ArrayOfDataPaths) Export
	FormParameters = ControllerClientServer_V2.GetFormParameters(Form);
	ServerParameters = ControllerClientServer_V2.GetServerParameters(Object);
	ServerParameters.TableName = TableName;
	ServerParameters.ReadOnlyProperties = StrConcat(ArrayOfDataPaths, ",");
	ServerParameters.StepEnableFlags.PriceChanged_AfterQuestionToUser = True;
	Parameters = ControllerClientServer_V2.GetParameters(ServerParameters, FormParameters);
	For Each PropertyName In StrSplit(ServerParameters.ReadOnlyProperties, ",") Do
		If StrStartsWith(TrimAll(PropertyName), TableName + "._") Then
			Continue;
		EndIf;
		If StrStartsWith(TrimAll(PropertyName), TableName) Then
			PropertyIsPresent = False;
			If Object[TableName].Count() Then
				Segments = StrSplit(PropertyName, ".");
				If Segments.Count() = 2 And CommonFunctionsClientServer.ObjectHasProperty(Object[TableName][0], TrimAll(Segments[1])) Then
					PropertyIsPresent = True;
				EndIf;
			EndIf;
			If PropertyIsPresent Then
				Property = New Structure("DataPath", TrimAll(PropertyName));
				ControllerClientServer_V2.API_SetProperty(Parameters, Property, Undefined);
			EndIf;
		EndIf;
	EndDo;
	If StrFind(Parameters.ReadOnlyProperties, ".TotalAmount") = 0 Then
		Property = New Structure("DataPath", "ItemList.<tax_rate>");
		ControllerClientServer_V2.API_SetProperty(Parameters, Property, Undefined);
	EndIf;
EndProcedure

Function GetObjectMetadataInfo(Val Object, ArrayOfTableNames) Export
	Result = New Structure();
	Result.Insert("MetadataName", Object.Ref.Metadata().Name);
	
	Tables = New Structure();
	For Each TableName In StrSplit(ArrayOfTableNames, ",") Do
		TableName = TrimAll(TableName);
		If Not ValueIsFilled(TableName) Then
			Continue;
		EndIf;
		If Not CommonFunctionsClientServer.ObjectHasProperty(Object, TableName) Then
			Continue;
		EndIf;
		ArrayOfColumns = New Array();
		Table = Object[TableName];
		If TypeOf(Table) = Type("ValueTable") Then
			Columns = Table.Columns;
		Else
			Columns = Table.Unload().Columns;
		EndIf;
		For Each Column In Columns Do
			ArrayOfColumns.Add(Column.Name);
		EndDo;
		Tables.Insert(TableName, New Structure ("Columns", StrConcat(ArrayOfColumns, ",")));
	EndDo;
	Result.Insert("Tables", Tables);
	
	AllDepTables = New Array();
	AllDepTables.Add("SpecialOffers");
	AllDepTables.Add("TaxList");
	AllDepTables.Add("Currencies");
	AllDepTables.Add("SerialLotNumbers");
	AllDepTables.Add("ShipmentConfirmations");
	AllDepTables.Add("GoodsReceipts");
	AllDepTables.Add("RowIDInfo");
	
	ArrayOfDepTables = New Array();
	For Each TableName In AllDepTables Do
		If CommonFunctionsClientServer.ObjectHasProperty(Object, TableName) Then
			ArrayOfDepTables.Add(TableName);
		EndIf;
	EndDo;
	Result.Insert("DependencyTables", ArrayOfDepTables);
	
	Return Result;
EndFunction

Procedure AddNewRowAtServer(TableName, Parameters, OnAddViewNotify, FillingValues) Export
	ControllerClientServer_V2.AddNewRow(TableName, Parameters, OnAddViewNotify);
	
	If FillingValues = Undefined Then
		Return;
	EndIf;
	Row = Parameters.Rows[0];
	
	
	ItemIsPresent      = CommonFunctionsClientServer.ObjectHasProperty(Row, "Item");
	ItemKeyIsPresent   = CommonFunctionsClientServer.ObjectHasProperty(Row, "ItemKey");
	UnitIsPresent      = CommonFunctionsClientServer.ObjectHasProperty(Row, "Unit");
	QuantityIsPresent  = CommonFunctionsClientServer.ObjectHasProperty(Row, "Quantity");
	PriceIsPresent     = CommonFunctionsClientServer.ObjectHasProperty(Row, "Price");
	PhysCountIsPresent = CommonFunctionsClientServer.ObjectHasProperty(Row, "PhysCount");
	SerialLotNumberIsPresent = CommonFunctionsClientServer.ObjectHasProperty(Row, "SerialLotNumber");
	BarcodeIsPresent  = CommonFunctionsClientServer.ObjectHasProperty(Row, "Barcode");
	DateIsPresent     = CommonFunctionsClientServer.ObjectHasProperty(Row, "Date");
	ChequeIsPresent   = CommonFunctionsClientServer.ObjectHasProperty(Row, "Cheque");
	
	If FillingValues.Property("Item") And ItemIsPresent Then
		ControllerClientServer_V2.SetItemListItem(Parameters, PrepareValue(FillingValues.Item, Row.Key));
	EndIf;
	
	If FillingValues.Property("ItemKey") And ItemKeyIsPresent Then
		ControllerClientServer_V2.SetItemListItemKey(Parameters, PrepareValue(FillingValues.ItemKey, Row.Key));
	EndIf;
	
	If FillingValues.Property("Unit") And UnitIsPresent Then
		ControllerClientServer_V2.SetItemListUnit(Parameters, PrepareValue(FillingValues.Unit, Row.Key));
	EndIf;
	
	If FillingValues.Property("Quantity") And QuantityIsPresent Then
		ControllerClientServer_V2.SetItemListQuantity(Parameters, PrepareValue(FillingValues.Quantity, Row.Key));
	EndIf;
	
	If FillingValues.Property("Quantity") And PhysCountIsPresent Then
		ControllerClientServer_V2.SetItemListPhysCount(Parameters, PrepareValue(FillingValues.Quantity, Row.Key));
	EndIf;
	
	If FillingValues.Property("Price") And PriceIsPresent Then
		ControllerClientServer_V2.SetItemListPrice(Parameters, PrepareValue(FillingValues.Price, Row.Key));
	EndIf;
	
	If FillingValues.Property("SerialLotNumber") And SerialLotNumberIsPresent Then
		ControllerClientServer_V2.SetItemListSerialLotNumber(Parameters, PrepareValue(FillingValues.SerialLotNumber, Row.Key));
	EndIf;
	
	If FillingValues.Property("Barcode") And BarcodeIsPresent Then
		ControllerClientServer_V2.SetItemListBarcode(Parameters, PrepareValue(FillingValues.Barcode, Row.Key));
	EndIf;
		
	If FillingValues.Property("Date") And DateIsPresent Then
		ControllerClientServer_V2.SetItemListDate(Parameters, PrepareValue(FillingValues.Date, Row.Key));
	EndIf;
	
	If FillingValues.Property("Cheque") And ChequeIsPresent Then
		ControllerClientServer_V2.SetChequeBondsCheque(Parameters, PrepareValue(FillingValues.Cheque, Row.Key));
	EndIf;
		
EndProcedure

Function PrepareValue(Value, Key)
	Result = New Array();
	Data = New Structure();
	Data.Insert("Value", Value);
	Data.Insert("Options", New Structure("Key", Key));
	Result.Add(Data);
	Return Result;
EndFunction

