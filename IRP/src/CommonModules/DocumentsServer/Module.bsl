#Region FormEvents

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	If Not Object.Ref.Metadata().TabularSections.Find("AddAttributes") = Undefined And Not Form.Items.Find(
		"GroupOther") = Undefined Then
		AddAttributesAndPropertiesServer.OnCreateAtServer(Form, "GroupOther");
		ExtensionServer.AddAttributesFromExtensions(Form, Object.Ref, Form.Items.GroupOther);
	EndIf;

	AddCommonAttributesToForm(Object, Form);

	If SessionParameters.isMobile Then
		DocumentServerMobile.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	Else
		If Form.Items.Find("GroupTitleCollapsed") <> Undefined Then
			DocumentsClientServer.ChangeTitleCollapse(Object, Form, Not ValueIsFilled(Object.Ref));
		EndIf;
	EndIf;

	ExternalCommandsServer.CreateCommands(Form, Object.Ref.Metadata().FullName(), Enums.FormTypes.ObjectForm);
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
	ReturnValue = New Array();
	SplitTable = New ValueTable();
	ArrayColumns = New Array();
	ArrayColumns.Add("Partner");
	ArrayColumns.Add("LegalName");
	ArrayColumns.Add("Agreement");
	ArrayColumns.Add("Company");
	SplitFilter = New Structure();
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

#Region Stores

Function GetCurrentStore(ObjectData) Export

	CurrentStore = PredefinedValue("Catalog.Stores.EmptyRef");
	HaveAgreement = False;
	If TypeOf(ObjectData) = Type("Structure") And ObjectData.Property("Agreement") Then

		If Not ObjectData.Agreement = Undefined Then
			HaveAgreement = Not ObjectData.Agreement.isempty();
		EndIf;

	ElsIf (TypeOf(ObjectData) = Type("FormDataStructure") And ObjectData.Property("Agreement"))
		Or ObjectData.Metadata().Attributes.Find("Agreement") <> Undefined Then
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

	Query = New Query();
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

Procedure FillPaymentList(Object) Export
	For Each Row In Object.PaymentList Do
		Row.ApArPostingDetail = Row.Agreement.ApArPostingDetail;
	EndDo;
EndProcedure

Function CheckItemListStores(Object) Export

	Query = New Query();
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
	|	ItemList.Store,
	|	ItemList.ItemKey
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
			"ItemList[" + Format((SelectionDetailRecords.LineNumber - 1), "NZ=0; NG=0;") + "].Store", Object);
	EndDo;

	Return True;
EndFunction

#EndRegion

#Region PaymentList

Procedure CheckPaymentList(Object, Cancel, CheckedAttributes) Export
	Query = New Query();
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
	|	PaymentList.Agreement.ApArPostingDetail,
	|	PaymentList.BasisDocument.Ref,
	|	PaymentList.BasisDocument
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
			"PaymentList[" + Format((SelectionDetailRecords.LineNumber - 1), "NZ=0; NG=0;") + "].BasisDocument", Object);
	EndDo;
EndProcedure

Procedure FillCheckBankCashDocuments(Object, CheckedAttributes) Export
	If Object.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.CurrencyExchange")
		Or Object.TransactionType = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.CurrencyExchange") Then

		CheckedAttributes.Add("PaymentList.PlaningTransactionBasis");
		CheckedAttributes.Add("CurrencyExchange");

	ElsIf Object.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.CashTransferOrder")
		Or Object.TransactionType = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.CashTransferOrder") Then

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
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type", AgreementParameters.AgreementType,
			ComparisonType.Equal));
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
		DocumentsServer.SerializeArrayOfFilters(ArrayOfFilters), DocumentsServer.SerializeArrayOfFilters(
		AdditionalParameters), AgreementParameters.Agreement);
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
			DocumentsServer.SerializeArrayOfFilters(ArrayOfFilters), DocumentsServer.SerializeArrayOfFilters(
			AdditionalParameters), LegalName);
		Return Catalogs.Companies.GetDefaultChoiceRef(Parameters);
	EndIf;
	Return Undefined;
EndFunction

Function GetBankAccountByPartner(Partner, LegalName, Currency) Export
	If Not (ValueIsFilled(Partner) And ValueIsFilled(LegalName) And ValueIsFilled(Currency)) Then
		Return Undefined;
	EndIf;
	Query = New Query();
	Query.Text =
	"SELECT TOP 1
	|	PartnersBankAccounts.Ref
	|FROM
	|	Catalog.PartnersBankAccounts AS PartnersBankAccounts
	|WHERE
	|	PartnersBankAccounts.Currency = &Currency
	|	AND PartnersBankAccounts.Partner = &Partner
	|	AND PartnersBankAccounts.LegalEntity = &LegalName
	|	AND NOT PartnersBankAccounts.DeletionMark";
	Query.SetParameter("Currency", Currency);
	Query.SetParameter("Partner", Partner);
	Query.SetParameter("LegalName", LegalName);
	QuerySelection = Query.Execute().Select();
	If QuerySelection.Next() Then
		Return QuerySelection.Ref;
	Else
		Return Undefined;
	EndIf;
EndFunction

#EndRegion

#Region ListFormEvents

Procedure OnCreateAtServerListForm(Form, Cancel, StandardProcessing) Export
	FormNamesArray = StrSplit(Form.FormName, ".");
	DocumentFullName = FormNamesArray[0] + "." + FormNamesArray[1];
	ExternalCommandsServer.CreateCommands(Form, DocumentFullName, Enums.FormTypes.ListForm);
EndProcedure

#EndRegion

#Region ChoiceFormEvents

Procedure OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing) Export
	FormNamesArray = StrSplit(Form.FormName, ".");
	DocumentFullName = FormNamesArray[0] + "." + FormNamesArray[1];
	ExternalCommandsServer.CreateCommands(Form, DocumentFullName, Enums.FormTypes.ChoiceForm);
EndProcedure

#EndRegion

#Region TitleItems

Procedure DeleteUnavailableTitleItemNames(ItemNames) Export
	UnavailableNames = New Array();
	If Not CatCompaniesServer.isUseCompanies() Then
		UnavailableNames.Add("Company");
	EndIf;
	For Each Name In UnavailableNames Do
		FoundedName = ItemNames.Find(Name);
		If FoundedName <> Undefined Then
			ItemNames.Delete(FoundedName);
		EndIf;
	EndDo;
EndProcedure

#EndRegion

#Region PrepareServerData

Function PrepareServerData(Parameters) Export
	Result = New Structure();

	If Parameters.Property("ArrayOfMovementsTypes") Then
		Result.Insert("ArrayOfCurrenciesByMovementTypes", GetCurrencyByMovementType(Parameters.ArrayOfMovementsTypes));
	EndIf;

	If Parameters.Property("TaxesCache") Then
		ArrayOfTaxInfo = New Array();
		RequireCallCreateTaxesFormControls = True;

		If ValueIsFilled(Parameters.TaxesCache.Cache) Then

			ArrayOfTaxesInCache = New Array();

			SavedData = CommonFunctionsServer.DeserializeXMLUseXDTO(Parameters.TaxesCache.Cache);
			If SavedData.Property("ArrayOfColumnsInfo") Then
				ArrayOfTaxInfo = SavedData.ArrayOfColumnsInfo;
				For Each ItemOfTaxInfo In ArrayOfTaxInfo Do
					ItemOfTaxInfo.Insert("TaxTypeIsRate", ItemOfTaxInfo.Type = Enums.TaxType.Rate);
					If Parameters.TaxesCache.Property("GetArrayOfTaxRates") Then

						StructureOfTaxRates = GetStructureOfTaxRates(ItemOfTaxInfo.Tax, Parameters.TaxesCache.Date,
							Parameters.TaxesCache.Company, Parameters.TaxesCache.GetArrayOfTaxRates);

						ItemOfTaxInfo.Insert("ArrayOfTaxRates", StructureOfTaxRates.ArrayOfTaxRates);
						ItemOfTaxInfo.Insert("ArrayOfTaxRatesForAgreement",
							StructureOfTaxRates.ArrayOfTaxRatesForAgreement);
						ItemOfTaxInfo.Insert("ArrayOfTaxRatesForItemKey", StructureOfTaxRates.ArrayOfTaxRatesForItemKey);
						ItemOfTaxInfo.Insert("ArrayOfTaxRatesForCompany", StructureOfTaxRates.ArrayOfTaxRatesForCompany);
					EndIf;
					ArrayOfTaxesInCache.Add(ItemOfTaxInfo.Tax);
				EndDo;
			EndIf;

			ArrayOfTaxes = New Array();

			DocumentName = Parameters.TaxesCache.Ref.Metadata().Name;
			ArrayOfAllTaxes = TaxesServer.GetTaxesByCompany(Parameters.TaxesCache.Date, Parameters.TaxesCache.Company);
			For Each ItemOfAllTaxes In ArrayOfAllTaxes Do
				If ItemOfAllTaxes.UseDocuments.FindRows(New Structure("DocumentName", DocumentName)).Count() Then
					ArrayOfTaxes.Add(ItemOfAllTaxes.Tax);
				EndIf;
			EndDo;

			AllTaxesInCache = True;
			For Each ItemOfTaxes In ArrayOfTaxes Do
				If ArrayOfTaxesInCache.Find(ItemOfTaxes) = Undefined Then
					AllTaxesInCache = False;
					Break;
				EndIf;
			EndDo;
			If AllTaxesInCache Then
				For Each ItemOfTaxesInCache In ArrayOfTaxesInCache Do
					If ArrayOfTaxes.Find(ItemOfTaxesInCache) = Undefined Then
						AllTaxesInCache = False;
						Break;
					EndIf;
				EndDo;
			EndIf;

			If AllTaxesInCache Then
				RequireCallCreateTaxesFormControls = False;
			EndIf;

		EndIf;

		Result.Insert("RequireCallCreateTaxesFormControls", RequireCallCreateTaxesFormControls);
		Result.Insert("ArrayOfTaxInfo", ArrayOfTaxInfo);
	EndIf;

	If Parameters.Property("GetManagerSegmentByPartner") Then
		Result.Insert("ManagerSegmentByPartner", DocumentsServer.GetManagerSegmentByPartner(
			Parameters.GetManagerSegmentByPartner.Partner));
	EndIf;

	If Parameters.Property("GetLegalNameByPartner") Then
		Result.Insert("LegalNameByPartner", DocumentsServer.GetLegalNameByPartner(
			Parameters.GetLegalNameByPartner.Partner, Parameters.GetLegalNameByPartner.LegalName));
	EndIf;

	If Parameters.Property("GetAgreementByPartner") Then
		AgreementParameters = New Structure();
		AgreementParameters.Insert("Partner", Parameters.GetAgreementByPartner.Partner);
		AgreementParameters.Insert("Agreement", Parameters.GetAgreementByPartner.Agreement);
		AgreementParameters.Insert("CurrentDate", Parameters.GetAgreementByPartner.Date);
		AgreementParameters.Insert("AgreementType", Enums.AgreementTypes.EmptyRef());

		AgreementParameters.AgreementType = Enums.AgreementTypes.Vendor;
		Result.Insert("AgreementByPartner_Vendor", DocumentsServer.GetAgreementByPartner(AgreementParameters));

		If Parameters.GetAgreementByPartner.Property("WithAgreementInfo") Then
			Result.Insert("AgreementInfoByPartner_Vendor", CatAgreementsServer.GetAgreementInfo(
				Result.AgreementByPartner_Vendor));
		EndIf;

		AgreementParameters.AgreementType = Enums.AgreementTypes.Customer;
		Result.Insert("AgreementByPartner_Customer", DocumentsServer.GetAgreementByPartner(AgreementParameters));

		If Parameters.GetAgreementByPartner.Property("WithAgreementInfo") Then
			Result.Insert("AgreementInfoByPartner_Customer", CatAgreementsServer.GetAgreementInfo(
				Result.AgreementByPartner_Customer));
		EndIf;
	EndIf;

	If Parameters.Property("GetAgreementInfo") Then
		AgreementInfo = CatAgreementsServer.GetAgreementInfo(Parameters.GetAgreementInfo.Agreement);
		Result.Insert("AgreementInfo", AgreementInfo);
		Result.Insert("AgreementInfo_PriceType_Presentation", String(AgreementInfo.PriceType));
	EndIf;

	If Parameters.Property("GetArrayOfCurrenciesRows") Then
		If Result.Property("AgreementInfo") Then
			AgreementInfo = Result.AgreementInfo;
		Else
			AgreementInfo = CatAgreementsServer.GetAgreementInfo(Parameters.GetArrayOfCurrenciesRows.Agreement);
		EndIf;
		Result.Insert("ArrayOfCurrenciesRows", GetArrayOfCurrenciesRows(AgreementInfo,
			Parameters.GetArrayOfCurrenciesRows));
	EndIf;

	If Parameters.Property("GetArrayOfCurrenciesRowsForAllTable") Then
		ArrayOfCurrenciesRows = New Array();
		For Each Row In Parameters.GetArrayOfCurrenciesRowsForAllTable Do
			PartOfArrayOfCurrenciesRows = GetArrayOfCurrenciesRows(CatAgreementsServer.GetAgreementInfo(Row.Agreement),
				Row);
			For Each ItemOfPart In PartOfArrayOfCurrenciesRows Do
				ArrayOfCurrenciesRows.Add(ItemOfPart);
			EndDo;
		EndDo;
		Result.Insert("ArrayOfCurrenciesRows", ArrayOfCurrenciesRows);
	EndIf;

	If Parameters.Property("GetMetaDataStructure") Then
		Result.Insert("MetaDataStructure", ServiceSystemServer.GetMetaDataStructure(
			Parameters.GetMetaDataStructure.Ref));
	EndIf;

	If Parameters.Property("GetItemKeyByItem") Then
		Result.Insert("ItemKeyByItem", CatItemsServer.GetItemKeyByItem(Parameters.GetItemKeyByItem.Item));
	EndIf;

	If Parameters.Property("GetAgreementTypes_Vendor") Then
		Result.Insert("AgreementTypes_Vendor", PredefinedValue("Enum.AgreementTypes.Vendor"));
	EndIf;

	If Parameters.Property("GetAgreementTypes_Customer") Then
		Result.Insert("AgreementTypes_Customer", PredefinedValue("Enum.AgreementTypes.Customer"));
	EndIf;

	If Parameters.Property("GetPurchaseOrder_EmptyRef") Then
		Result.Insert("PurchaseOrder_EmptyRef", PredefinedValue("Document.PurchaseOrder.EmptyRef"));
	EndIf;

	If Parameters.Property("GetSalesOrder_EmptyRef") Then
		Result.Insert("SalesOrder_EmptyRef", PredefinedValue("Document.SalesOrder.EmptyRef"));
	EndIf;

	If Parameters.Property("GetPurchaseReturnOrder_EmptyRef") Then
		Result.Insert("PurchaseReturnOrder_EmptyRef", PredefinedValue("Document.PurchaseReturnOrder.EmptyRef"));
	EndIf;

	If Parameters.Property("GetSalesReturnOrder_EmptyRef") Then
		Result.Insert("SalesReturnOrder_EmptyRef", PredefinedValue("Document.SalesReturnOrder.EmptyRef"));
	EndIf;

	If Parameters.Property("GetPriceTypes_ManualPriceType") Then
		Result.Insert("PriceTypes_ManualPriceType", PredefinedValue("Catalog.PriceTypes.ManualPriceType"));
	EndIf;

	If Parameters.Property("GetTaxes_EmptyRef") Then
		Result.Insert("Taxes_EmptyRef", PredefinedValue("Catalog.Taxes.EmptyRef"));
	EndIf;

	If Parameters.Property("GetTaxAnalytics_EmptyRef") Then
		Result.Insert("TaxAnalytics_EmptyRef", PredefinedValue("Catalog.TaxAnalytics.EmptyRef"));
	EndIf;

	If Parameters.Property("GetTaxRates_EmptyRef") Then
		Result.Insert("TaxRates_EmptyRef", PredefinedValue("Catalog.TaxRates.EmptyRef"));
	EndIf;

	If Parameters.Property("GetItemUnitInfo") Then
		Result.Insert("ItemUnitInfo", GetItemInfo.ItemUnitInfo(Parameters.GetItemUnitInfo.ItemKey));
	EndIf;

	If Parameters.Property("GetItemKeysWithSerialLotNumbers") Then
		Query = New Query();
		Query.Text =
		"SELECT
		|	ItemKeys.Ref AS ItemKey
		|FROM
		|	Catalog.ItemKeys AS ItemKeys
		|WHERE
		|	ItemKeys.Item.ItemType.UseSerialLotNumber
		|	AND ItemKeys.Ref IN (&Refs)";
		Query.SetParameter("Refs", Parameters.GetItemKeysWithSerialLotNumbers);
		QueryResult = Query.Execute();
		ArrayOfItemKeysWithSerialLotNumbers = QueryResult.Unload().UnloadColumn("ItemKey");
		Result.Insert("ItemKeysWithSerialLotNumbers", ArrayOfItemKeysWithSerialLotNumbers);
	EndIf;

	If Parameters.Property("GetPaymentTerms") Then
		Agreement = Parameters.GetPaymentTerms.Agreement;
		ArrayOfPaymentTerms = New Array();
		If ValueIsFilled(Agreement) And ValueIsFilled(Agreement.PaymentTerm) Then
			For Each Stage In Agreement.PaymentTerm.StagesOfPayment Do
				NewRow = New Structure();
				NewRow.Insert("CalculationType", Stage.CalculationType);
				NewRow.Insert("ProportionOfPayment", Stage.ProportionOfPayment);
				NewRow.Insert("DuePeriod", Stage.DuePeriod);
				ArrayOfPaymentTerms.Add(NewRow);
			EndDo;
		EndIf;
		Result.Insert("PaymentTerms", ArrayOfPaymentTerms);
	EndIf;

	If Parameters.Property("GetRetailCustomerInfo") Then
		Result.Insert("RetailCustomerInfo", CatRetailCustomersServer.GetRetailCustomerInfo(
			Parameters.GetRetailCustomerInfo.RetailCustomer));
	EndIf;

	Return Result;
EndFunction

Function GetArrayOfCurrenciesRows(AgreementInfo, Parameters)
	CurrenciesColumns = Metadata.Documents.PurchaseInvoice.TabularSections.Currencies.Attributes;
	CurrenciesTable = New ValueTable();
	CurrenciesTable.Columns.Add("Key", CurrenciesColumns.Key.Type);
	CurrenciesTable.Columns.Add("CurrencyFrom", CurrenciesColumns.CurrencyFrom.Type);
	CurrenciesTable.Columns.Add("Rate", CurrenciesColumns.Rate.Type);
	CurrenciesTable.Columns.Add("ReverseRate", CurrenciesColumns.ReverseRate.Type);
	CurrenciesTable.Columns.Add("ShowReverseRate", CurrenciesColumns.ShowReverseRate.Type);
	CurrenciesTable.Columns.Add("Multiplicity", CurrenciesColumns.Multiplicity.Type);
	CurrenciesTable.Columns.Add("MovementType", CurrenciesColumns.MovementType.Type);
	CurrenciesTable.Columns.Add("Amount", CurrenciesColumns.Amount.Type);

	CurrenciesServer.FillCurrencyTable(New Structure("Currencies", CurrenciesTable), Parameters.Date, Parameters.Company,
		Parameters.Currency, Parameters.UUID, AgreementInfo);

	ArrayOfCurrenciesRows = New Array();
	For Each RowCurrenciesTable In CurrenciesTable Do
		NewRow = New Structure("Key, CurrencyFrom, Rate, ReverseRate, ShowReverseRate, Multiplicity, MovementType, Amount");
		FillPropertyValues(NewRow, RowCurrenciesTable);
		ArrayOfCurrenciesRows.Add(NewRow);
	EndDo;

	Return ArrayOfCurrenciesRows;
EndFunction

Function GetCurrencyByMovementType(ArrayOfMovementsTypes)
	ArrayOfCurrenciesByMovementTypes = New Array();
	For Each MovementType In ArrayOfMovementsTypes Do
		ArrayOfCurrenciesByMovementTypes.Add(New Structure("MovementType, Currency", MovementType,
			MovementType.Currency));
	EndDo;
	Return ArrayOfCurrenciesByMovementTypes;
EndFunction

Function GetStructureOfTaxRates(Tax, Date, Company, Parameters)
	Result = New Structure();
	Result.Insert("ArrayOfTaxRates", New Array());
	Result.Insert("ArrayOfTaxRatesForItemKey", New Array());
	Result.Insert("ArrayOfTaxRatesForAgreement", New Array());
	Result.Insert("ArrayOfTaxRatesForCompany", New Array());

	Result.ArrayOfTaxRatesForCompany = TaxesServer.GetTaxRatesForCompany(New Structure("Date, Company, Tax", Date,
		Company, Tax));
	If Parameters.Property("Agreement") Then
		Result.ArrayOfTaxRatesForAgreement = TaxesServer.GetTaxRatesForAgreement(
			New Structure("Date, Company, Tax, Agreement", Date, Company, Tax, Parameters.Agreement));
	EndIf;

	If Not Result.ArrayOfTaxRatesForAgreement.Count() Then
		ItemKey = ?(Parameters.Property("ItemKey"), Parameters.ItemKey, Catalogs.ItemKeys.EmptyRef());

		Result.ArrayOfTaxRatesForItemKey = TaxesServer.GetTaxRatesForItemKey(New Structure("Date, Company, Tax, ItemKey",
			Date, Company, Tax, ItemKey));
	EndIf;

	If Result.ArrayOfTaxRatesForAgreement.Count() Then
		Result.ArrayOfTaxRates = Result.ArrayOfTaxRatesForAgreement;
	Else
		Result.ArrayOfTaxRates = Result.ArrayOfTaxRatesForItemKey;
	EndIf;

	Return Result;
EndFunction

#EndRegion

#Region SpecialOffersInReturns

Procedure FillSpecialOffersCache(Object, Form, BasisDocumentName, AddInfo = Undefined) Export
	Form.SpecialOffersCache.Clear();
	Query = New Query();
	Query.TempTablesManager = New TempTablesManager();
	Query.Text =
	"SELECT
	|	ItemList.Key,
	|	ItemList.%1
	|INTO _tmpItemList
	|FROM
	|	&ItemList AS ItemList
	|;
	|Select
	|	RowIDInfo.Key AS Key,
	|	RowIDInfo.Basis AS Basis,
	|	RowIDInfo.BasisKey AS BasisKey
	|INTO tmpRowIDInfo
	|FROM
	|	&RowIDInfo AS RowIDInfo
	|;
	|Select
	|	RowIDInfo.BasisKey AS BasisKey,
	|	_tmpItemList.Key AS Key,
	|	_tmpItemList.%1
	|INTO tmpItemList
	|from _tmpItemList AS _tmpItemList
	|inner join tmpRowIDInfo AS RowIDInfo 
	|	ON _tmpItemList.%1 = RowIDInfo.Basis
	|	AND _tmpItemList.Key = RowIDInfo.Key
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmpItemList.Key,
	|	BasisDocumentSpecialOffers.Offer,
	|	BasisDocumentSpecialOffers.Amount,
	|	BasisDocumentItemList.Quantity
	|FROM
	|	tmpItemList AS tmpItemList
	|		INNER JOIN Document.%1.SpecialOffers AS BasisDocumentSpecialOffers
	|		ON BasisDocumentSpecialOffers.Ref = tmpItemList.%1
	|		AND BasisDocumentSpecialOffers.Key = tmpItemList.BasisKey
	|		INNER JOIN Document.%1.ItemList AS BasisDocumentItemList
	|		ON BasisDocumentItemList.Ref = tmpItemList.%1
	|		AND BasisDocumentItemList.Key = tmpItemList.BasisKey";
	Query.Text = StrTemplate(Query.Text, BasisDocumentName);
	Query.SetParameter("ItemList", Object.ItemList.Unload());
	Query.SetParameter("RowIDInfo", Object.RowIDInfo.Unload());
	QueryResult = Query.Execute();
	Form.SpecialOffersCache.Load(QueryResult.Unload());
EndProcedure
#EndRegion

#Region CommonAttributes

Procedure AddCommonAttributesToForm(Object, Form)
	GroupOther = Form.Items.Find("GroupOther");
	If GroupOther <> Undefined Then
		AddCommonAttributesDimensions(Object, Form, GroupOther);
		AddCommonAttributesWeight(Object, Form, GroupOther);
	EndIf;
EndProcedure

Procedure AddCommonAttributesDimensions(Object, Form, ParentGroup)
	AddedAttributes = New Array();
	If ServiceSystemServer.ObjectHasAttribute(Metadata.CommonAttributes.Length.Name, Object) Then
		AddedAttributes.Add(Metadata.CommonAttributes.Length);
	EndIf;
	If ServiceSystemServer.ObjectHasAttribute(Metadata.CommonAttributes.Width.Name, Object) Then
		AddedAttributes.Add(Metadata.CommonAttributes.Width);
	EndIf;
	If ServiceSystemServer.ObjectHasAttribute(Metadata.CommonAttributes.Height.Name, Object) Then
		AddedAttributes.Add(Metadata.CommonAttributes.Height);
	EndIf;
	If ServiceSystemServer.ObjectHasAttribute(Metadata.CommonAttributes.Volume.Name, Object) Then
		AddedAttributes.Add(Metadata.CommonAttributes.Volume);
	EndIf;
	If Not AddedAttributes.Count() Then
		Return;
	EndIf;

	ItemsParent = Form.Items.Add("GroupDimensions", Type("FormGroup"), ParentGroup);
	ItemsParent.Type = FormGroupType.UsualGroup;
	ItemsParent.Group = ChildFormItemsGroup.Vertical;
	ItemsParent.Behavior = UsualGroupBehavior.Collapsible;
	ItemsParent.Title = R().Form_030;
	For Each Attribute In AddedAttributes Do
		NewAttribute = Form.Items.Add(Attribute.Name, Type("FormField"), ItemsParent);
		NewAttribute.Type = FormFieldType.InputField;
		NewAttribute.DataPath = "Object." + Attribute.Name;
	EndDo;
EndProcedure

Procedure AddCommonAttributesWeight(Object, Form, ParentGroup)
	AddedAttributes = New Array();
	If ServiceSystemServer.ObjectHasAttribute(Metadata.CommonAttributes.Weight.Name, Object) Then
		AddedAttributes.Add(Metadata.CommonAttributes.Weight);
	EndIf;
	If Not AddedAttributes.Count() Then
		Return;
	EndIf;

	ItemsParent = Form.Items.Add("GroupWeights", Type("FormGroup"), ParentGroup);
	ItemsParent.Type = FormGroupType.UsualGroup;
	ItemsParent.Group = ChildFormItemsGroup.Vertical;
	ItemsParent.Behavior = UsualGroupBehavior.Collapsible;
	ItemsParent.Title = R().Form_031;
	For Each Attribute In AddedAttributes Do
		NewAttribute = Form.Items.Add(Attribute.Name, Type("FormField"), ItemsParent);
		NewAttribute.Type = FormFieldType.InputField;
		NewAttribute.DataPath = "Object." + Attribute.Name;
	EndDo;
EndProcedure

#EndRegion

#Region Service

Procedure ShowUserMessageOnCreateAtServer(Form) Export
	If Form.Parameters.Property("InfoMessage") Then
		CommonFunctionsClientServer.ShowUsersMessage(Form.Parameters.InfoMessage);
	EndIf;
EndProcedure

Function SerializeArrayOfFilters(ArrayOfFilters) Export
	Return CommonFunctionsServer.SerializeXMLUseXDTO(ArrayOfFilters);
EndFunction

Procedure RecalculateQuantityInTable(Table, UnitQuantityName = "QuantityUnit") Export
	For Each Row In Table Do
		RecalculateQuantityInRow(Row, UnitQuantityName);
	EndDo;
EndProcedure

Procedure RecalculateQuantityInRow(Row, UnitQuantityName = "QuantityUnit") Export
	ItemKeyUnit = CatItemsServer.GetItemKeyUnit(Row.ItemKey);
	UnitFactorFrom = Catalogs.Units.GetUnitFactor(Row[UnitQuantityName], ItemKeyUnit);
	UnitFactorTo = Catalogs.Units.GetUnitFactor(Row.Unit, ItemKeyUnit);
	Row.Quantity = ?(UnitFactorTo = 0, 0, Row.Quantity * UnitFactorFrom / UnitFactorTo);
EndProcedure

#EndRegion

#Region Subscriptions

Procedure OnCopyDocumentProcessingOnCopy(Source, CopiedObject, AddInfo = Undefined) Export
	If Metadata.CommonAttributes.Author.Content.Contains(Source.Metadata()) Then
		FillingStructure = New Structure();
		FillingStructure.Insert("Author", SessionParameters.CurrentUser);

		FillPropertyValues(Source, FillingStructure);
	EndIf;
EndProcedure

#EndRegion

#Region ShipmentConfirationsGoodsReceiptd

Procedure RecalculateInvoiceQuantity(ArrayOfRows) Export
	For Each Row In ArrayOfRows Do
		Row.Unit = ?(ValueIsFilled(Row.ItemKey.Unit), Row.ItemKey.Unit, Row.ItemKey.Item.Unit);
		RecalculateQuantityInRow(Row);
	EndDo;
EndProcedure

#EndRegion

Function GetPartnerByLegalName(LegalName, Partner) Export
	If Not LegalName.IsEmpty() Then
		ArrayOfFilters = New Array();
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
		If ValueIsFilled(Partner) Then
			ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Ref", Partner, ComparisonType.Equal));
		EndIf;
		AdditionalParameters = New Structure();
		If ValueIsFilled(LegalName) Then
			AdditionalParameters.Insert("Company", LegalName);
			AdditionalParameters.Insert("FilterPartnersByCompanies", True);
		EndIf;
		Parameters = New Structure("CustomSearchFilter, AdditionalParameters", SerializeArrayOfFilters(ArrayOfFilters),
			SerializeArrayOfFilters(AdditionalParameters));
		Return Catalogs.Partners.GetDefaultChoiceRef(Parameters);
	EndIf;
	Return Undefined;
EndFunction

Function GetItemAndItemKeyByPartnerItem(PartnerItem) Export
	Result = New Structure("Item, ItemKey");
	If Not ValueIsFilled(PartnerItem) Then
		Return Result;
	EndIf;
	Result.Item = PartnerItem.Item;
	Result.ItemKey = PartnerItem.ItemKey;
	Return Result;
EndFunction