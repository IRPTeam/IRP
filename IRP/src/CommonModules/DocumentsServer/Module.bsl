#Region FormEvents

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export	
	If Not Object.Ref.Metadata().TabularSections.Find("AddAttributes") = Undefined
		And Not Form.Items.Find("GroupOther") = Undefined Then
		AddAttributesAndPropertiesServer.OnCreateAtServer(Form, "GroupOther");
		ExtensionServer.AddAtributesFromExtensions(Form, Object.Ref, Form.Items.GroupOther);
	EndIf;
	// TODO: Cut If after fix all documents
	If Form.Items.Find("GroupTitleCollapsed") <> Undefined Then
		DocumentsClientServer.ChangeTitleCollapse(Object, Form, Not ValueIsFilled(Object.Ref));
	EndIf;	
	ExternalCommandsServer.CreateCommands(Form, Object.Ref.Metadata().Name, Catalogs.ConfigurationMetadata.Documents, Enums.FormTypes.ObjectForm);	
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	Return;
EndProcedure

Procedure OnWriteAtServer(Object, Form, Cancel, CurrentObject, WriteParameters) Export
	
	If Not Object.Ref.Metadata().TabularSections.Find("ItemList") = Undefined Then
		WriteSavedItems(Object, CurrentObject);
	EndIf;
	
EndProcedure

#EndRegion

#Region CommandGenerateDocument

Function SplitBasisDocuments(Refs) Export
	ReturnValue = New Array;
	SplitTable = New ValueTable();
	ArrayColumns = New Array;
	ArrayColumns.Add("Partner");
	ArrayColumns.Add("LegalName");
	ArrayColumns.Add("Agreement");
	ArrayColumns.Add("Company");
	SplitFilter = New Structure;
	For Each ArrayItem In ArrayColumns Do
		SplitTable.Columns.Add(ArrayItem);
		SplitFilter.Insert(ArrayItem, "");
	EndDo;
	SplitTable.Columns.Add("Refs", New TypeDescription("Array"));
	For Each Ref In Refs Do
		FillPropertyValues(SplitFilter, Ref);
		FoundedRows = SplitTable.FindRows(SplitFilter);
		If FoundedRows.Count() Then
			SplitTableRow = FoundedRows.Get(0);
		Else
			SplitTableRow = SplitTable.Add();
		EndIf;
		FillPropertyValues(SplitTableRow, Ref);
		SplitTableRow.Refs.Add(Ref);
	EndDo;
	For Each SplitRow In SplitTable Do
		ReturnValue.Add(SplitRow.Refs);
	EndDo;
	Return ReturnValue;
EndFunction
#EndRegion

Function SerializeArrayOfFilters(ArrayOfFilters) Export
	Return CommonFunctionsServer.SerializeXMLUseXDTO(ArrayOfFilters);
EndFunction

Procedure RecalculateQuantityInTable(Table,
		UnitQuantityName = "QuantityUnit") Export
	For Each Row In Table Do
		RecalculateQuantityInRow(Row, UnitQuantityName);
	EndDo;
EndProcedure

Procedure RecalculateQuantityInRow(Row,
		UnitQuantityName = "QuantityUnit") Export
	ItemKeyUnit = CatItemsServer.GetItemKeyUnit(Row.ItemKey);
	UnitFactorFrom = Catalogs.Units.GetUnitFactor(Row[UnitQuantityName], ItemKeyUnit);
	UnitFactorTo = Catalogs.Units.GetUnitFactor(Row.Unit, ItemKeyUnit);
	Row.Quantity = ?(UnitFactorTo = 0, 0, Row.Quantity * UnitFactorFrom
			/ UnitFactorTo);
EndProcedure

#Region Stores

Function GetCurrentStore(ObjectData) Export
	
	CurrentStore = PredefinedValue("Catalog.Stores.EmptyRef");
	HaveAgreement = False;
	If TypeOf(ObjectData) = Type("Structure") And ObjectData.Property("Agreement") Then
		
		If Not ObjectData.Agreement = Undefined Then
			HaveAgreement = Not ObjectData.Agreement.isempty();
		EndIf;
		
	ElsIf (TypeOf(ObjectData) = Type("FormDataStructure") And ObjectData.Property("Agreement")) 
			OR ObjectData.Metadata().Attributes.Find("Agreement") <> Undefined Then
		HaveAgreement = True;
	Else 
		HaveAgreement = False;
	EndIf;
	If HaveAgreement Then
		AgreementInfo = CatAgreementsServer.GetAgreementInfo(ObjectData.Agreement);
		CurrentStore = AgreementInfo.Store;	
	EndIf;
	
	If Not ValueIsFilled(CurrentStore) Then
		
		UserSettings = UserSettingsServer.GetUserSettingsForClientModule(ObjectData.Ref);
		
		For Each Setting In UserSettings Do
			
			If Setting.AttributeName = "ItemList.Store" Then
				CurrentStore = Setting.Value;
				Break;
			EndIf;
			
		EndDo;
		
	EndIf;
	
	Return CurrentStore;
	
EndFunction

#EndRegion

#Region ItemList

Procedure SetNewTableUUID(Table, LinkedTables) Export
	For Each TableRow In Table Do
	
		CurrentKey = TableRow.Key;
		TableRow.Key = New UUID();	
	
		For Each LinkedTable In LinkedTables Do
			Rows = LinkedTable.FindRows(New Structure("Key", CurrentKey));
			For Each Row In Rows Do
				Row.Key = TableRow.Key;
			EndDo;
		EndDo;
		
	EndDo;
EndProcedure

Procedure FillItemList(Object, Form = Undefined) Export
	
	RowMap = New Map();
	
	For Each Row In Object.ItemList Do
		RowMap.Insert(Row.Key, Row);
		Row.Item = Row.ItemKey.Item;
		//
		If TypeOf(Object.Ref) = Type("DocumentRef.SalesOrder") Then
			Row.ItemType = Row.Item.ItemType.Type;
		EndIf;
	EndDo;
	
	Query = New Query;
	Query.Text =
		"SELECT
		|	SavedItems.Key,
		|	SavedItems.Item
		|FROM
		|	InformationRegister.SavedItems AS SavedItems
		|WHERE
		|	SavedItems.ObjectRef = &ObjectRef";
	
	Query.SetParameter("ObjectRef", Object.Ref);
	
	QueryResult = Query.Execute();
	
	SelectionDetailRecords = QueryResult.Select();
	
	While SelectionDetailRecords.Next() Do
		RowMap[SelectionDetailRecords.Key].Item = SelectionDetailRecords.Item;
		//
		If TypeOf(Object.Ref) = Type("DocumentRef.SalesOrder") Then
			RowMap[SelectionDetailRecords.Key].ItemType = RowMap[SelectionDetailRecords.Key].Item.ItemType.Type;
		EndIf;
	EndDo;
	
EndProcedure

Procedure WriteSavedItems(Object, CurrentObject)
	
	ObjectRef = CurrentObject.Ref;
	ItemList = Object.ItemList.Unload().Copy(New Structure("ItemKey", PredefinedValue("Catalog.ItemKeys.EmptyRef")));
	
	If ItemList.Count() = 0 Then
		RecordSet = InformationRegisters.SavedItems.CreateRecordSet();
		RecordSet.Filter.ObjectRef.Set(ObjectRef);
		RecordSet.Write(True);
		Return;
	EndIf;
	
	ItemList.Columns.Add("ObjectRef");
	ItemList.FillValues(ObjectRef, "ObjectRef");
	
	RecordSet = InformationRegisters.SavedItems.CreateRecordSet();
	RecordSet.Filter.ObjectRef.Set(ObjectRef);
	
	RecordSet.Load(ItemList);
	RecordSet.Write(True);
	
EndProcedure

Procedure FillPaymentList(Object)Export
	For Each Row In Object.PaymentList Do
		Row.ApArPostingDetail = Row.Agreement.ApArPostingDetail;
	EndDo;
EndProcedure

Function CheckItemListStores(Object) Export

	Query = New Query;
	Query.Text =
		"SELECT
		|	Table.LineNumber,
		|	Table.Store,
		|	Table.ItemKey
		|INTO ItemList
		|FROM
		|	&ItemList AS Table
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	ItemList.LineNumber,
		|ItemList.Store,
		|ItemList.ItemKey
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	Not ItemList.ItemKey.Item.ItemType.Type = Value(Enum.ItemTypes.Service)
		|	AND  ItemList.Store = Value(Catalog.Stores.EmptyRef)";
		
	Query.SetParameter("ItemList", Object.ItemList.Unload());
	QueryResult = Query.Execute();
	
	If QueryResult.IsEmpty() Then
		Return False;
	EndIf;
	
	SelectionDetailRecords = QueryResult.Select();
	
	While SelectionDetailRecords.Next() Do
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_072, SelectionDetailRecords.LineNumber), 
							"ItemList[" + Format((SelectionDetailRecords.LineNumber - 1), "NZ=0; NG=0;") + "].Store", 
							Object);
	EndDo;	
	
	Return True;
EndFunction

#EndRegion

#Region PaymentList

Procedure CheckPaymentList(Object, Cancel, CheckedAttributes) Export
	Query = New Query;
	Query.Text =
		"SELECT
		|	Table.LineNumber,
		|	Table.Agreement,
		|	Table.BasisDocument
		|INTO PaymentList
		|FROM
		|	&PaymentList AS Table
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	PaymentList.LineNumber,
		|PaymentList.Agreement.ApArPostingDetail,
		|PaymentList.BasisDocument.Ref,
		|PaymentList.BasisDocument
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|	AND  PaymentList.BasisDocument.Ref is Null
		|";
	
	Query.SetParameter("PaymentList", Object.PaymentList.Unload());
	QueryResult = Query.Execute();
	
	If QueryResult.IsEmpty() Then
		Return;
	EndIf;
	
	SelectionDetailRecords = QueryResult.Select();
	
	Cancel = True;
	While SelectionDetailRecords.Next() Do
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_020, SelectionDetailRecords.LineNumber), 
							"PaymentList[" + Format((SelectionDetailRecords.LineNumber - 1), "NZ=0; NG=0;") + "].BasisDocument", 
							Object);
	EndDo;
EndProcedure

Procedure FillCheckBankCashDocuments(Object, CheckedAttributes) Export
	If Object.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.CurrencyExchange") Or
		Object.TransactionType = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.CurrencyExchange") Then
	
		CheckedAttributes.Add("PaymentList.PlaningTransactionBasis");
		CheckedAttributes.Add("CurrencyExchange");	
			
	ElsIf Object.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.CashTransferOrder") Or
		Object.TransactionType = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.CashTransferOrder") Then
			
		CheckedAttributes.Add("PaymentList.PlaningTransactionBasis");	
		
	EndIf;		
EndProcedure

#EndRegion

#Region PartnerData

Function GetManagerSegmentByPartner(Partner) Export
	Return Partner.ManagerSegment;
EndFunction

// Description
// 
// Parameters:
// 	AgreementParameters Structure
//		Keys:
//		- Partner
//		- Agreement
//		- CurrentDate
//		- ArrayOfFilters
// Returns:
// 	CatalogRef.Agreements - Description
Function GetAgreementByPartner(AgreementParameters) Export
	
	Partner = AgreementParameters.Partner;
	
	If Partner.IsEmpty() Then
		Return Catalogs.Agreements.EmptyRef();
	EndIf;
	
	ArrayOfFilters = New Array();
	If AgreementParameters.Property("ArrayOfFilters") Then
		ArrayOfFilters = AgreementParameters.ArrayOfFilters;
	Else
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type", AgreementParameters.AgreementType, ComparisonType.Equal));
	EndIf;
		
	AdditionalParameters = New Structure();
	AdditionalParameters.Insert("IncludeFilterByEndOfUseDate", True);
	AdditionalParameters.Insert("IncludeFilterByPartner", True);
	AdditionalParameters.Insert("IncludePartnerSegments", True);
				
	If AgreementParameters.Property("CurrentDate") Then
		CurrentDate = AgreementParameters.CurrentDate;
	Else
		CurrentDate = CurrentDate();
	EndIf; 
		
	AdditionalParameters.Insert("EndOfUseDate", CurrentDate);
	AdditionalParameters.Insert("Partner", Partner);
	Parameters = New Structure("CustomSearchFilter, AdditionalParameters, Agreement",
			DocumentsServer.SerializeArrayOfFilters(ArrayOfFilters),
			DocumentsServer.SerializeArrayOfFilters(AdditionalParameters),
			AgreementParameters.Agreement);
	Return Catalogs.Agreements.GetDefaultChoiceRef(Parameters);
	
EndFunction

Function GetLegalNameByPartner(Partner, LegalName) Export
	If Not Partner.IsEmpty() Then
		ArrayOfFilters = New Array();
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
		AdditionalParameters = New Structure();
		If ValueIsFilled(Partner) Then
			AdditionalParameters.Insert("Partner", Partner);
			AdditionalParameters.Insert("FilterByPartnerHierarchy", True);
		EndIf;
		Parameters = New Structure("CustomSearchFilter, AdditionalParameters, LegalName",
				DocumentsServer.SerializeArrayOfFilters(ArrayOfFilters),
				DocumentsServer.SerializeArrayOfFilters(AdditionalParameters),
				LegalName);
		Return Catalogs.Companies.GetDefaultChoiceRef(Parameters);
	EndIf;
	Return Undefined;
EndFunction

#EndRegion

Procedure ShowUserMessageOnCreateAtServer(Form) Export
    If Form.Parameters.Property("InfoMessage") Then
        CommonFunctionsClientServer.ShowUsersMessage(Form.Parameters.InfoMessage);    
    EndIf;
EndProcedure

#Region ListFormEvents

Procedure OnCreateAtServerListForm(Form, Cancel, StandardProcessing) Export	
	FormNamesArray = StrSplit(Form.FormName, ".");
	DocumentName = FormNamesArray[1];
	ExternalCommandsServer.CreateCommands(Form, DocumentName, Catalogs.ConfigurationMetadata.Documents, Enums.FormTypes.ListForm);	
EndProcedure

#EndRegion

#Region ChoiceFormEvents

Procedure OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing) Export	
	FormNamesArray = StrSplit(Form.FormName, ".");
	DocumentName = FormNamesArray[1];
	ExternalCommandsServer.CreateCommands(Form, DocumentName, Catalogs.ConfigurationMetadata.Documents, Enums.FormTypes.ChoiceForm);	
EndProcedure

#EndRegion

#Region TitleItems

Procedure DeleteUnavailableTitleItemNames(ItemNames) Export
	UnavailableNames = New Array;
	ShowAlphaTestingSaas = GetFunctionalOption("ShowAlphaTestingSaas");
	If Not CatCompaniesServer.isUseCompanies() Then
		UnavailableNames.Add("Company");
	EndIf;
	If Not ShowAlphaTestingSaas Then		
		UnavailableNames.Add("Store");
		UnavailableNames.Add("LegalName");
		UnavailableNames.Add("Agreement");
	EndIf;
	For Each Name In UnavailableNames Do
		FoundedName = ItemNames.Find(Name);
		If FoundedName <> Undefined Then
			ItemNames.Delete(FoundedName);
		EndIf;
	EndDo;
EndProcedure

#EndRegion
