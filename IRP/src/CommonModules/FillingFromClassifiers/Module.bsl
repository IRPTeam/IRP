
Procedure OnCreateAtServer(Form, Cancel, StandardProcessing) Export
	NewCommand = Form.Commands.Add("CreateFromClassifier");
	NewCommand.Action = "CreateFromClassifier";
	NewCommand.Title = R().Form_025;
	
	NewItem = Form.Items.Add("CreateFromClassifier",
	                                 Type("FormButton"),
									 Form.CommandBar);
	NewItem.CommandName = "CreateFromClassifier";
EndProcedure

Function GetClassifierData(MetadataName) Export
	ClassifierData = New Array;
	CurrentMetadata = Metadata.FindByFullName(MetadataName);
	If CurrentMetadata = Undefined Then
		Return ClassifierData;
	EndIf;
	For Each Template In CurrentMetadata.Templates Do
		If StrFind(Upper(Template.Name), Upper("Classifier_JSON")) <> 0 Then
			TemplateData = ServiceSystemServer.GetManagerByMetadata(CurrentMetadata).GetTemplate(Template.Name);
			CurrentClassifierData = CommonFunctionsServer.DeserializeJSON(TemplateData.GetText());
			If TypeOf(CurrentClassifierData) = Type("Array") Then
				For Each CurrentClassifierElement In CurrentClassifierData Do
					ClassifierData.Add(CurrentClassifierElement);
				EndDo;
			EndIf;
		EndIf;
	EndDo;
	Return ClassifierData;
EndFunction

Function GetElementFromClassifier(MetadataName, KeyName, KeyValue) Export
	ClassifierData = GetClassifierData(MetadataName);
	If ClassifierData <> Undefined Then
		For Each ClassifierElement In ClassifierData Do
			If Lower(ClassifierElement[KeyName]) = Lower(KeyValue) Then
				Return ClassifierElement;
			EndIf;
		EndDo;
	EndIf;
	Return Undefined;
EndFunction

Function CreateCatalogItemFromClassifier(MetadataName, KeyName, KeyValue) Export
	ClassifierElement = GetElementFromClassifier(MetadataName, KeyName, KeyValue);
	Return CheckExistingAndCreateCatalogItemFromClassifierElement(MetadataName, ClassifierElement);
EndFunction

Function CreateCatalogItemFromClassifierElement(MetadataName, ClassifierElement) Export
	CurrentManager = ServiceSystemServer.GetManagerByMetadataFullName(MetadataName);
	If CurrentManager = Undefined Then
		Return Undefined;
	EndIf;
	If ClassifierElement <> Undefined Then
		NewObject = CurrentManager.CreateItem();
		DisassembleClassifierElement_Structure(NewObject, ClassifierElement);
		
		// Fill descriptions
		DescriptionStr = DescriptionStructure();
		FillPropertyValues(DescriptionStr, NewObject);
		For Each KeyAndValue In DescriptionStr Do
			If IsBlankString(KeyAndValue.Value) Then
				DescriptionStr[KeyAndValue.Key] = DescriptionStr["Description_en"];
			EndIf;
		EndDo;
		FillPropertyValues(NewObject, DescriptionStr);
		
		NewObject.Write();
		Return NewObject.Ref;
	Else
		Return CurrentManager.EmptyRef();
	EndIf;
EndFunction

Procedure DisassembleClassifierElement_Structure(NewObject, ClassifierElement)
	For Each KeyAndValue In ClassifierElement Do
		DisassembleClassifierElement_KeyAndValue(NewObject, KeyAndValue);
	EndDo;
EndProcedure

Procedure DisassembleClassifierElement_KeyAndValue(NewObject, KeyAndValue)
	If TypeOf(KeyAndValue.Value) = Type("Structure") Then
		If KeyAndValue.Key = "TabularSection" Then
			For Each TabularSection In KeyAndValue.Value Do
				DisassembleClassifierElement_TabularSection(NewObject, TabularSection);
			EndDo;
		Else
			MetadataType = Undefined;
			If KeyAndValue.Value.Property("MetadataType", MetadataType) Then
				If StrFind(MetadataType, "Catalog") <> 0 Then
					NewObject[KeyAndValue.Key] = CheckExistingAndCreateCatalogItemFromClassifierElement(
									MetadataType, KeyAndValue.Value, False);
				EndIf;
				If StrFind(MetadataType, "Enum") <> 0 Then
					EnumManager = ServiceSystemServer.GetManagerByMetadataFullName(MetadataType);
					If EnumManager <> Undefined Then
						NewObject[KeyAndValue.Key] = EnumManager[KeyAndValue.Value.Value];
					EndIf;
				EndIf;
				If StrFind(MetadataType, "ValueStorage_Structure") <> 0 Then
					ValueStorage_Structure = New Structure(); 
					For Each ValueStorage_KeyAndValue In KeyAndValue.Value Do
						If ValueStorage_KeyAndValue.Key <> "MetadataType" Then
							ValueStorage_Structure.Insert(ValueStorage_KeyAndValue.Key);
						EndIf;
					EndDo;
					DisassembleClassifierElement_Structure(ValueStorage_Structure, KeyAndValue.Value);
					NewObject[KeyAndValue.Key] = New ValueStorage(ValueStorage_Structure, New Deflation(9));	
				EndIf;
				If StrFind(MetadataType, "ValueStorage_ExtData") <> 0 Then
					NewObject[KeyAndValue.Key] = GetBinaryDataFromTemplate(KeyAndValue.Value);		
				EndIf;
			EndIf;
		EndIf;
	Else
		// primitive type
		FillingStructure = New Structure(KeyAndValue.Key, KeyAndValue.Value);
		FillPropertyValues(NewObject, FillingStructure);
	EndIf;
EndProcedure

Procedure DisassembleClassifierElement_TabularSection(NewObject, TabularSection)
	For Each TabularSectionRow In TabularSection.Value Do
		NewRow = NewObject[TabularSection.Key].Add();
		 DisassembleClassifierElement_Structure(NewRow, TabularSectionRow);
	EndDo;
EndProcedure

Function CheckExistingAndCreateCatalogItemFromClassifierElement(MetadataName, ClassifierElement, OwnClassifier = True) Export
	If TypeOf(ClassifierElement) <> Type("Structure") OR Not ClassifierElement.Count() Then
		CurrentManager = ServiceSystemServer.GetManagerByMetadataFullName(MetadataName);
		If CurrentManager = Undefined Then
			Return Undefined;
		EndIf;
		Return CurrentManager.EmptyRef();
	EndIf;
	
	For Each KeyAndValue In ClassifierElement Do
		SearchingKeyAndValue = KeyAndValue;
		Break;
	EndDo;
	
	// Step1: Check existing item
	Query = New Query(
	"SELECT TOP 1
	|	Table.Ref
	|FROM
	|	Catalog.%1 AS Table
	|WHERE
	|	Table.%2 = &%2");
	Query.Text = StrTemplate(Query.Text, Mid(MetadataName, 9), SearchingKeyAndValue.Key);
	Query.SetParameter(SearchingKeyAndValue.Key, SearchingKeyAndValue.Value);
	
	Selection = Query.Execute().Select();
	If Selection.Next() Then
		Return Selection.Ref;
	EndIf;
	
	// Step2: Try create from Metadata own classifier
	If Not OwnClassifier Then
		ItemFromMetadataClassifier = CreateCatalogItemFromClassifier(
					MetadataName, SearchingKeyAndValue.Key, SearchingKeyAndValue.Value);
		If ValueIsFilled(ItemFromMetadataClassifier) Then
			Return ItemFromMetadataClassifier;
		EndIf;
	EndIf;
	
	// Step3: Create from this ClassifierElement
	Return CreateCatalogItemFromClassifierElement(MetadataName, ClassifierElement);
EndFunction

Function GetBinaryDataFromTemplate(ClassifierElement) Export
	Var TemplatePath, TemplateName;
	
	If Not ClassifierElement.Property("TemplateName", TemplateName) 
			OR Not ClassifierElement.Property("TemplatePath", TemplatePath) Then
		Return Undefined;
	EndIf;
	
	CurrentMetadata = Metadata.FindByFullName(TemplatePath);
	If CurrentMetadata = Undefined Then
		Return Undefined;
	EndIf;
		
	For Each Template In CurrentMetadata.Templates Do
		If Upper(Template.Name) = Upper(TemplateName) Then
			TemplateData = ServiceSystemServer.GetManagerByMetadata(CurrentMetadata).GetTemplate(Template.Name);
			Return New ValueStorage(TemplateData, New Deflation(9));
		EndIf;	
	EndDo;
	
	Return Undefined;
EndFunction
	
Function DescriptionStructure(Description = "") Export
	Str = New Structure();
	Str.Insert("Description_" + LocalizationReuse.GetLocalizationCode()	, Description);
	Str.Insert("Description_en"											, Description);
	Str.Insert("Description"											, Description);
	Return Str;
EndFunction

Procedure FillDescriptionOfPredefinedCatalogs() Export
    
    LocalCodes = LocalizationCodesList();

	ValueTable = New ValueTable;
	ValueTable.Columns.Add("Ref");
	ValueTable.Columns.Add("DescriptionMap");

	Obj = Catalogs.AddAttributeAndPropertySets;
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Catalog_Agreements, 					"Description_A001");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Catalog_BusinessUnits, 				"Description_A003");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Catalog_CashAccounts, 					"Description_A004");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Catalog_ChequeBonds, 					"Description_A005");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Catalog_Companies, 					"Description_A006");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Catalog_CompanyTypes, 					"Description_A007");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Catalog_Countries, 					"Description_A008");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Catalog_Currencies, 					"Description_A009");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Catalog_ExpenseAndRevenueTypes, 		"Description_A010");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Catalog_ItemKeys, 						"Description_A011");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Catalog_Items, 						"Description_A012");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Catalog_ItemTypes, 					"Description_A013");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Catalog_Partners, 						"Description_A014");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Catalog_PriceKeys, 					"Description_A015");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Catalog_PriceTypes, 					"Description_A016");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Catalog_SerialLotNumbers, 				"Description_A017");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Catalog_Specifications, 				"Description_A018");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Catalog_Stores, 						"Description_A019");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Catalog_Taxes, 						"Description_A020");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Catalog_Units, 						"Description_A021");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Catalog_Users, 						"Description_A022");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_BankPayment, 					"Description_A023");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_BankReceipt, 					"Description_A024");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_Bundling, 					"Description_A025");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_CashExpense, 					"Description_A026");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_CashPayment, 					"Description_A027");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_CashReceipt, 					"Description_A028");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_CashRevenue, 					"Description_A029");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_CashTransferOrder, 			"Description_A030");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_ChequeBondTransaction, 		"Description_A031");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_GoodsReceipt, 				"Description_A032");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_IncomingPaymentOrder, 		"Description_A033");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_InventoryTransfer, 			"Description_A034");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_InventoryTransferOrder, 		"Description_A035");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_InvoiceMatch, 				"Description_A036");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_Labeling, 					"Description_A037");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_OpeningEntry, 				"Description_A038");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_OutgoingPaymentOrder, 		"Description_A039");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_PhysicalCountByLocation, 		"Description_A040");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_PhysicalInventory, 			"Description_A041");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_PriceList, 					"Description_A042");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_PurchaseInvoice, 				"Description_A043");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_PurchaseOrder, 				"Description_A044");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_PurchaseReturn, 				"Description_A045");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_PurchaseReturnOrder, 			"Description_A046");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_ReconciliationStatement, 		"Description_A047");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_SalesInvoice, 				"Description_A048");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_SalesOrder, 					"Description_A049");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_SalesReturn, 					"Description_A050");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_SalesReturnOrder, 			"Description_A051");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_ShipmentConfirmation, 		"Description_A052");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_StockAdjustmentAsSurplus, 	"Description_A053");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_StockAdjustmentAsWriteOff, 	"Description_A054");
    AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_Unbundling, 					"Description_A056");

	AddRowToDescriptionList (ValueTable, LocalCodes, Catalogs.PriceTypes.ManualPriceType, "Description_A057");
	
	Obj = Catalogs.ObjectStatuses;
	AddRowToDescriptionList (ValueTable, LocalCodes, Obj.ChequeBondTransaction, 	"Description_A031"); 
	AddRowToDescriptionList (ValueTable, LocalCodes, Obj.ChequeBondIncoming, 		"Description_A058"); 
	AddRowToDescriptionList (ValueTable, LocalCodes, Obj.ChequeBondOutgoing, 		"Description_A059"); 
	AddRowToDescriptionList (ValueTable, LocalCodes, Obj.InventoryTransferOrder, 	"Description_A035");
	AddRowToDescriptionList (ValueTable, LocalCodes, Obj.OutgoingPaymentOrder, 		"Description_A039");
	AddRowToDescriptionList (ValueTable, LocalCodes, Obj.PhysicalCountByLocation, 	"Description_A040");
	AddRowToDescriptionList (ValueTable, LocalCodes, Obj.PhysicalInventory, 		"Description_A041");
	AddRowToDescriptionList (ValueTable, LocalCodes, Obj.PurchaseOrder, 			"Description_A044");
	AddRowToDescriptionList (ValueTable, LocalCodes, Obj.PurchaseReturnOrder, 		"Description_A046");
	AddRowToDescriptionList (ValueTable, LocalCodes, Obj.ReconciliationStatement, 	"Description_A047");
	AddRowToDescriptionList (ValueTable, LocalCodes, Obj.SalesOrder, 				"Description_A049");
	AddRowToDescriptionList (ValueTable, LocalCodes, Obj.SalesReturnOrder, 			"Description_A051");

	Obj = Catalogs.CurrencyMovementSets;
	AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_PurchaseReturnOrder, 	"Description_A046");
	AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_BankPayment, 			"Description_A023");
	AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_BankReceipt, 			"Description_A024");
	AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_CashExpense, 			"Description_A026");
	AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_CashPayment, 			"Description_A027");
	AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_CashReceipt, 			"Description_A028");
	AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_CashRevenue, 			"Description_A029");
	AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_CashTransferOrder, 	"Description_A030"); 
	AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_IncomingPaymentOrder, "Description_A033");
	AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_InvoiceMatch, 		"Description_A036");
	AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_OutgoingPaymentOrder, "Description_A039");
	AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_PurchaseInvoice, 		"Description_A043"); 
	AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_PurchaseOrder, 		"Description_A044");
	AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_PurchaseReturn, 		"Description_A045");
	AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_SalesInvoice, 		"Description_A048");
	AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_SalesOrder, 			"Description_A049");
	AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_SalesReturn, 			"Description_A050");
	AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_SalesReturnOrder, 	"Description_A051");
	AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_CreditNote, 		    "Description_A062");
	AddRowToDescriptionList (ValueTable, LocalCodes, Obj.Document_DebitNote, 		    "Description_A063");
	Obj = ChartsOfCharacteristicTypes.CurrencyMovementType;
	AddRowToDescriptionList (ValueTable, LocalCodes, Obj.SettlementCurrency, "Description_A061");
	
	FillAndWriteDescriptions (ValueTable);

EndProcedure

Function LocalizationCodesList()
    
    LocalizationCodes = New Array;
    LocalizationCodes.Add("en");
    Return LocalizationCodes;
    
EndFunction

Procedure AddRowToDescriptionList (CatalogList, LocalizationCodes,  Ref, R_StringName)

    NewRow = CatalogList.Add();
    NewRow.Ref = Ref;
    Map = New Map;
    For Each LocalCodeRow In LocalizationCodes Do
        Map.Insert("Description_" + LocalCodeRow, R(LocalCodeRow)[R_StringName]);
    EndDo;
    NewRow.DescriptionMap = Map;
    
EndProcedure

Procedure FillAndWriteDescriptions(ObjectTable)

	For Each CurRow In ObjectTable Do
		Object = CurRow.Ref.GetObject();
		ObjectChanged = False;
		For Each Description In CurRow.DescriptionMap Do
			If Not Object[Description.Key] = Description.Value Then
				Object[Description.Key] = Description.Value;
				ObjectChanged = True;
			EndIf;
		EndDo;
		If ObjectChanged Then
			Object.Write();
		EndIf;
	EndDo;

EndProcedure
