#Region FormEvents

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	
	If Form.Parameters.Key.IsEmpty() Then
		SourceOfOriginClientServer.UpdateSourceOfOriginsQuantity(Object);
	EndIf;
	
	If Not Object.Ref.Metadata().TabularSections.Find("AddAttributes") = Undefined 
		And Not Form.Items.Find("GroupOther") = Undefined Then
		AddAttributesAndPropertiesServer.OnCreateAtServer(Form, "GroupOther");
		ExtensionServer.AddAttributesFromExtensions(Form, Object.Ref, Form.Items.GroupOther);
	EndIf;

	AddCommonAttributesToForm(Object, Form);

	If SessionParameters.isMobile Then
		DocumentsServerMobile.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	Else
		If Form.Items.Find("GroupTitleCollapsed") <> Undefined Then
			DocumentsClientServer.ChangeTitleCollapse(Object, Form, Not ValueIsFilled(Object.Ref));
		EndIf;
	EndIf;
	
	SetMarkNegativesItemList(Object, Form);
	
	ArrayOfExcludingDocuments = New Array();
	ArrayOfExcludingDocuments.Add(Metadata.Documents.SalesOrderClosing);
	ArrayOfExcludingDocuments.Add(Metadata.Documents.PurchaseOrderClosing);
	
	ObjectMetdata = Object.Ref.Metadata();
	
	ExternalCommandsServer.CreateCommands(Form, ObjectMetdata.FullName(), Enums.FormTypes.ObjectForm);
	If ArrayOfExcludingDocuments.Find(ObjectMetdata) = Undefined Then
		CopyPasteServer.CreateCommands(Form, ObjectMetdata.FullName(), Enums.FormTypes.ObjectForm);
	EndIf;
	SerialLotNumbersServer.CreateCommands(Form, ObjectMetdata, Enums.FormTypes.ObjectForm);
	
	InternalCommandsServer.CreateCommands(Form, Object, ObjectMetdata.FullName(), Enums.FormTypes.ObjectForm);
	
	If CommonFunctionsClientServer.ObjectHasProperty(Form.Items, "Author") Then
		Form.Items.Author.ReadOnly = UserSettingsServer.AllDocuments_AdditionalSettings_DisableChangeAuthor();
	EndIf;
	
	If Form.Items.Find("Number") <> Undefined Then
		NumberEditingAvailable = SessionParametersServer.GetSessionParameter("NumberEditingAvailable");
		Form.Items.Number.ReadOnly = Not NumberEditingAvailable;
	EndIf;	
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	Return;
EndProcedure

Procedure OnWriteAtServer(Object, Form, Cancel, CurrentObject, WriteParameters) Export
	Return;
EndProcedure

#EndRegion

#Region ItemList

Procedure SetNewTableUUID(Table, LinkedTables) Export
	For Each TableRow In Table Do

		CurrentKey = TableRow.Key;
		TableRow.Key = New UUID();

		For Each LinkedTable In LinkedTables Do
			KeyOwnerIsPresent = False;
			If LinkedTable.Count() Then
				KeyOwnerIsPresent = CommonFunctionsClientServer.ObjectHasProperty(LinkedTable[0], "KeyOwner");
			EndIf;
			
			If KeyOwnerIsPresent Then
				Rows = LinkedTable.FindRows(New Structure("KeyOwner", CurrentKey));
				For Each Row In Rows Do
					Row.KeyOwner = TableRow.Key;
					Row.Key = New UUID();
				EndDo;
			Else
				Rows = LinkedTable.FindRows(New Structure("Key", CurrentKey));
				For Each Row In Rows Do
					Row.Key = TableRow.Key;
				EndDo;
			EndIf;
		EndDo;
	EndDo;
EndProcedure

Function CheckItemListStores(Object) Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	Table.LineNumber,
	|	Table.Store,
	|	Table.ItemKey,
	|	Table.IsServiceNotSet,
	|	Table.IsService
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
	|	CASE WHEN ItemList.IsServiceNotSet THEN
	|		Not ItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service)
	|	WHEN NOT ItemList.IsServiceNotSet THEN
	|		Not ItemList.IsService
	|	END
	|	AND  ItemList.Store = Value(Catalog.Stores.EmptyRef)";
	ItemList = Object.ItemList.Unload(); // ValueTable
	If ItemList.Columns.Find("IsService") = Undefined Then
		ItemList.Columns.Add("IsService", New TypeDescription("Boolean"));
		ItemList.Columns.Add("IsServiceNotSet", New TypeDescription("Boolean"));
		ItemList.FillValues(True, "IsServiceNotSet");
	Else
		ItemList.Columns.Add("IsServiceNotSet", New TypeDescription("Boolean"));
	EndIf;
	
	Query.SetParameter("ItemList", ItemList);
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

// Set mark negatives item list.
// 
// Parameters:
//  Object - FormDataStructure - Object
//  Form - ClientApplicationForm - Form
Procedure SetMarkNegativesItemList(Object, Form) Export
	
	If Object.Property("ItemList") Then
		FormItemList = Form.Items.Find("ItemList");
		If FormItemList = Undefined Then
			For Each FormItem In Form.Items Do
				If TypeOf(FormItem) = Type("FormTable") And StrEndsWith(FormItem.DataPath, ".ItemList") Then
					FormItemList = FormItem;
					Break;
				EndIf;
			EndDo; 
		EndIf;
		If FormItemList = Undefined Then
			Return;
		EndIf;
		
		ConditionalAppearanceItem = Form.ConditionalAppearance.Items.Add();
		ConditionalAppearanceItem.Appearance.SetParameterValue("MarkNegatives", True);
		For Each FormItem In FormItemList.ChildItems Do
			If FormItem.Type = FormGroupType.ColumnGroup Then
				For Each FormChildItem In FormItem.ChildItems Do
					AppearanceField = ConditionalAppearanceItem.Fields.Items.Add();
					AppearanceField.Field = New DataCompositionField(FormChildItem.Name);
					AppearanceField.Use = True;
				EndDo;
			Else
				AppearanceField = ConditionalAppearanceItem.Fields.Items.Add();
				AppearanceField.Field = New DataCompositionField(FormItem.Name);
				AppearanceField.Use = True;
			EndIf;
		EndDo;
	EndIf;
	
EndProcedure

#EndRegion

#Region PaymentList

Procedure FillCheckBankCashDocuments(Object, CheckedAttributes) Export
	If Object.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.CurrencyExchange")
		Or Object.TransactionType = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.CurrencyExchange") Then
		CheckedAttributes.Add("PaymentList.PlaningTransactionBasis");
		CheckedAttributes.Add("CurrencyExchange");
	EndIf;
EndProcedure

// Check matching to basis document.
// 
// Parameters:
//  Object - DocumentObject.BankPayment, DocumentObject.BankReceipt, DocumentObject.CashPayment, DocumentObject.CashReceipt - document for checking
//  BasisAttribute - String - attribute for checking in basis document
//  Cancel - Boolean - check failed
Procedure CheckMatchingToBasisDocument(Object, ObjectAttribute, BasisAttribute, Cancel) Export
	
	Query = New Query;
	Query.SetParameter("Account", Object[ObjectAttribute]);
	Query.SetParameter("PaymentList", Object.PaymentList.Unload());
	Query.Text = StrTemplate(
	"SELECT
	|	PaymentList.LineNumber,
	|	PaymentList.PlaningTransactionBasis,
	|	&Account as Account
	|INTO tmpPaymentList
	|FROM
	|	&PaymentList AS PaymentList
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmpPaymentList.LineNumber,
	|	tmpPaymentList.PlaningTransactionBasis as Basis,
	|	CashTransferOrder.%1 as Account
	|FROM
	|	tmpPaymentList AS tmpPaymentList
	|		INNER JOIN Document.CashTransferOrder AS CashTransferOrder
	|		ON tmpPaymentList.PlaningTransactionBasis = CashTransferOrder.Ref
	|		AND NOT tmpPaymentList.Account = CashTransferOrder.%1", BasisAttribute);
	SetPrivilegedMode(True);
	SelectionRecords = Query.Execute().Select();
	SetPrivilegedMode(False);
	While SelectionRecords.Next() Do
		Cancel = True;
		CommonFunctionsClientServer.ShowUsersMessage(
				StrTemplate(R().Error_AttributeDontMatchValueFromBasisDoc_Row, 
					ObjectAttribute, SelectionRecords.Account, SelectionRecords.Basis, SelectionRecords.LineNumber), 
				ObjectAttribute, 
				Object);
	EndDo;
	
EndProcedure	

#EndRegion

#Region PartnerData

Function GetManagerSegmentByPartner(Partner) Export
	If Not ValueIsFilled(Partner) Then
		Return Undefined;
	EndIf;
	
	Return Partner.ManagerSegment;
EndFunction

// Description
// 
// Parameters:
// 	AgreementParameters - Structure:
//		* Partner - CatalogRef.Partners
//		* Agreement - CatalogRef.Agreements
//		* CurrentDate - Date
//		* ArrayOfFilters - Array of Filter
//		* Company - CatalogRef.Companies
// Returns:
// 	CatalogRef.Agreements - Description
Function GetAgreementByPartner(AgreementParameters) Export

	Partner = AgreementParameters.Partner;

	If Not ValueIsFilled(Partner) Then
		Return Catalogs.Agreements.EmptyRef();
	EndIf;

	ArrayOfFilters = New Array();
	If AgreementParameters.Property("ArrayOfFilters") Then
		ArrayOfFilters = AgreementParameters.ArrayOfFilters;
	Else
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
		If AgreementParameters.Property("AgreementType") And ValueIsFilled(AgreementParameters.AgreementType) Then
			ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type", AgreementParameters.AgreementType, ComparisonType.Equal));
		EndIf;
	EndIf;

	AdditionalParameters = New Structure();
	AdditionalParameters.Insert("IncludeFilterByEndOfUseDate", True);
	AdditionalParameters.Insert("IncludeFilterByPartner", True);
	AdditionalParameters.Insert("IncludePartnerSegments", True);

	If AgreementParameters.Property("CurrentDate") Then
		CurrentDate = AgreementParameters.CurrentDate;
	Else
		CurrentDate = CommonFunctionsServer.GetCurrentSessionDate();
	EndIf;
	
	If AgreementParameters.Property("AllAgreements") Then
		AllAgreements = AgreementParameters.AllAgreements;
	Else
		AllAgreements = False;
	EndIf;
	
	AdditionalParameters.Insert("AllAgreements" , AllAgreements);
	AdditionalParameters.Insert("EndOfUseDate", CurrentDate);
	AdditionalParameters.Insert("Partner", Partner);
	
	Parameters = New Structure();
	Parameters.Insert("CustomSearchFilter"   , SerializeArrayOfFilters(ArrayOfFilters));
	Parameters.Insert("AdditionalParameters" , SerializeArrayOfFilters(AdditionalParameters));
	Parameters.Insert("Agreement"            , AgreementParameters.Agreement);
	
	Return Catalogs.Agreements.GetDefaultChoiceRef(Parameters, AgreementParameters);
EndFunction

Function GetLegalNameByPartner(Partner, LegalName) Export
	If Not ValueIsFilled(Partner) Then
		Return Undefined;
	EndIf;
	
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	
	AdditionalParameters = New Structure();
	If ValueIsFilled(Partner) Then
		AdditionalParameters.Insert("Partner", Partner);
		AdditionalParameters.Insert("FilterByPartnerHierarchy", True);
	EndIf;
		
	Parameters = New Structure();
	Parameters.Insert("CustomSearchFilter"   , SerializeArrayOfFilters(ArrayOfFilters));
	Parameters.Insert("AdditionalParameters" , SerializeArrayOfFilters(AdditionalParameters));
	Parameters.Insert("LegalName"            , LegalName);
		
	Return Catalogs.Companies.GetDefaultChoiceRef(Parameters);
EndFunction

Function GetCashAccountByCompany(Company, CashAccount, CashAccountType) Export
	If Not ValueIsFilled(Company) Then
		Return Undefined;
	EndIf;
	
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True    , ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Company"     , Company , ComparisonType.Equal));
		
	If ValueIsFilled(CashAccountType) Then
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type", CashAccountType, ComparisonType.Equal));
	Else
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type", PredefinedValue("Enum.CashAccountTypes.Transit"), ComparisonType.NotEqual));
	EndIf;
	
	AdditionalParameters = New Structure();
	
	Parameters = New Structure();
	Parameters.Insert("CustomSearchFilter"   , SerializeArrayOfFilters(ArrayOfFilters));
	Parameters.Insert("AdditionalParameters" , SerializeArrayOfFilters(AdditionalParameters));
	Parameters.Insert("CashAccount"          , CashAccount);
		
	Return Catalogs.CashAccounts.GetDefaultChoiceRef(Parameters);
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
	InternalCommandsServer.CreateCommands(Form, Form.List, DocumentFullName, Enums.FormTypes.ListForm);
EndProcedure

#EndRegion

#Region ChoiceFormEvents

Procedure OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing) Export
	FormNamesArray = StrSplit(Form.FormName, ".");
	DocumentFullName = FormNamesArray[0] + "." + FormNamesArray[1];
	ExternalCommandsServer.CreateCommands(Form, DocumentFullName, Enums.FormTypes.ChoiceForm);
	InternalCommandsServer.CreateCommands(Form, Form.List, DocumentFullName, Enums.FormTypes.ChoiceForm);
EndProcedure

#EndRegion

#Region TitleItems

Procedure DeleteUnavailableTitleItemNames(ItemNames) Export
	UnavailableNames = New Array();
	If Not FOServer.IsUseCompanies() Then
		UnavailableNames.Add("Company");
		UnavailableNames.Add("LegalName");
	EndIf;
	If Not FOServer.IsUsePartnerTerms() Then
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
	|	BasisDocumentSpecialOffers.Bonus,
	|	BasisDocumentSpecialOffers.AddInfo,
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
	If ValueIsFilled(LegalName) Then
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

Function GetStoreInfo(Store, ItemKey) Export
	Result = New Structure();
	Result.Insert("IsService", True);
	If ValueIsFilled(ItemKey) Then
		Result.IsService = GetItemInfo.GetInfoByItemsKey(ItemKey)[0].isService;
	EndIf;
	Result.Insert("UseGoodsReceipt", Store.UseGoodsReceipt);
	Result.Insert("UseShipmentConfirmation", Store.UseShipmentConfirmation);
	Return Result;
EndFunction

Function GetArrayOfPurchaseOrdersByPurchaseInvoice(PurchaseInvoice) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	PurchaseInvoiceItemList.PurchaseOrder
	|FROM
	|	Document.PurchaseInvoice.ItemList AS PurchaseInvoiceItemList
	|WHERE
	|	PurchaseInvoiceItemList.Ref = &Ref
	|	AND NOT PurchaseInvoiceItemList.PurchaseOrder.Ref IS NULL";
	Query.SetParameter("Ref", PurchaseInvoice);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	ArrayOfOrders = QueryTable.UnloadColumn("PurchaseOrder");
	Return ArrayOfOrders;
EndFunction

Function GetArrayOfSalesOrdersBySalesInvoice(SalesInvoice) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	SalesInvoiceItemList.SalesOrder
	|FROM
	|	Document.SalesInvoice.ItemList AS SalesInvoiceItemList
	|WHERE
	|	SalesInvoiceItemList.Ref = &Ref
	|	AND NOT SalesInvoiceItemList.SalesOrder.Ref IS NULL";
	Query.SetParameter("Ref", SalesInvoice);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	ArrayOfOrders = QueryTable.UnloadColumn("SalesOrder");
	Return ArrayOfOrders;
EndFunction

// Pickup item end.
// 
// Parameters:
//  Parameters - Structure -
//  ScanData - Array Of See BarcodeServer.FillFoundedItems
// 
// Returns:
//  Structure - Pickup item end:
// * UserMessages - Array -
// * NewRows - Array -
// * UpdatedRows - Array -
// * ChoiceForms - Structure -:
// ** PresentationStartChoice_Counter - Number -
// ** StartChoice_Counter - Number -
// ** PresentationStartChoice_Key - String -
// ** StartChoice_Key - String -
// * ArrayOfTableNames - Array of String -
Function PickupItemEnd(Val Parameters, Val ScanData) Export
	Result = New Structure();
	Result.Insert("UserMessages" , New Array());
	Result.Insert("NewRows"      , New Array());
	Result.Insert("UpdatedRows"  , New Array());
	
	ArrayOfTableNames = New Array();
	ArrayOfTableNames.Add("SerialLotNumbers");
	ArrayOfTableNames.Add("SourceOfOrigins");
	
	Result.Insert("ChoiceForms",
		New Structure("PresentationStartChoice_Counter, 
					  |StartChoice_Counter, 
					  |ControlStringStartChoice_Counter,
					  |PresentationStartChoice_Key, 
					  |StartChoice_Key,
					  |ControlStringStartChoice_Key", 0, 0, 0));
	
	Object = Parameters.ServerSideParameters.ServerParameters.Object; // See Document.PhysicalCountByLocation.Form.DocumentForm.Object
	
	For Each ScanDataItem In ScanData Do // See BarcodeServer.FillFoundedItems
		
		If ScanDataItem.isService And Parameters.Filter.DisableIfIsService Then
			Result.UserMessages.Add(StrTemplate(R().InfoMessage_026, ScanDataItem.Item));
			Continue;
		EndIf;
		
		If (Parameters.UseSerialLotNumbers OR Parameters.isSerialLotNumberAtRow) And ValueIsFilled(ScanDataItem.SerialLotNumber) And ScanDataItem.SerialLotNumber.EachSerialLotNumberIsUnique Then
			
			If Parameters.UseSerialLotNumbers Then
				If Object.SerialLotNumbers.FindRows(New Structure("SerialLotNumber", ScanDataItem.SerialLotNumber)).Count() > 0 Then
					Result.UserMessages.Add(StrTemplate(R().Error_113, ScanDataItem.SerialLotNumber));
					Continue;
				EndIf;
			ElsIf Parameters.isSerialLotNumberAtRow Then
				If Object.ItemList.FindRows(New Structure("SerialLotNumber", ScanDataItem.SerialLotNumber)).Count() > 0 Then
					Result.UserMessages.Add(StrTemplate(R().Error_113, ScanDataItem.SerialLotNumber));
					Continue;
				EndIf;
			EndIf;
		EndIf;
		
		FoundedRows = FindRows(Object, Parameters, ScanDataItem);
				
		If FoundedRows.AddNewRow Then
			ResultName = "NewRows";
			RowKey = String(New UUID());
			ProcessRow = Object.ItemList.Add();
			ProcessRow.Key = RowKey;
			
			FillingValues = New Structure();
			FillingValues.Insert("Item"     		  , ScanDataItem.Item);
			FillingValues.Insert("ItemKey"  		  , ScanDataItem.ItemKey);
			FillingValues.Insert("Unit"     		  , ScanDataItem.Unit);
			FillingValues.Insert("Quantity" 		  , ScanDataItem.Quantity);
			FillingValues.Insert("SerialLotNumber"    , ScanDataItem.SerialLotNumber);
			FillingValues.Insert("Barcode"  		  , ?(ScanDataItem.Property("Barcode"), ScanDataItem.Barcode, ""));
			FillingValues.Insert("Date"     		  , CommonFunctionsServer.GetCurrentSessionDate());
			FillingValues.Insert("isControlCodeString", ScanDataItem.ControlCodeString);
			
			If ScanDataItem.Property("PriceType") Then
				FillingValues.Insert("PriceType", ScanDataItem.PriceType);
			EndIf;
			
			If ValueIsFilled(Parameters.StoreRef) Then
				FillingValues.Insert("Store", Parameters.StoreRef);
			EndIf;
			
			If ValueIsFilled(FoundedRows.InventoryOrigin) Then
				FillingValues.Insert("InventoryOrigin", FoundedRows.InventoryOrigin);
			EndIf;	
				
			If ValueIsFilled(FoundedRows.Consignor) Then
				FillingValues.Insert("Consignor", FoundedRows.Consignor);
			EndIf;	
				
		Else // Update row + Quantity
			ResultName = "UpdatedRows";
			RowKey = FoundedRows.Row.Key;
			ProcessRow = FoundedRows.Row;
			
			FillingValues = New Structure();
			If Parameters.QuantityColumnName = "PhysCount" Then
				FillingValues.Insert("Quantity", ProcessRow.PhysCount + ScanDataItem.Quantity);
			Else
				FillingValues.Insert("Quantity", ProcessRow.Quantity + ScanDataItem.Quantity);
			EndIf;
		EndIf;
		
		RowInfo = FillRow(Object, Parameters, ProcessRow, FillingValues);
		ResultRow = New Structure("Key, Cache, ViewNotify", RowKey, 
			CleanCache(Object, RowInfo.Cache, ArrayOfTableNames), 
			RowInfo.ViewNotify);
		Result[ResultName].Add(ResultRow);
		
		If Parameters.UseSerialLotNumbers Then
			If ValueIsFilled(ScanDataItem.SerialLotNumber) Then
				SerialLotNumberInfo = AddNewSerialLotNumber(Object, RowKey, ScanDataItem);
				
				// TODO: Refact
				If SerialLotNumberInfo.Cache <> Undefined And SerialLotNumberInfo.Cache.Property("ItemList") Then
					For Each InfoRow In SerialLotNumberInfo.Cache.ItemList Do
						For Each ResultRow In Result.NewRows Do
							If ResultRow.Cache.Property("ItemList") Then
								For Each ItemListRow In ResultRow.Cache.ItemList Do
									If ItemListRow.Key = InfoRow.Key Then
										For Each KeyValue In InfoRow Do
											ItemListRow.Insert(KeyValue.Key, InfoRow[KeyValue.Key])
										EndDo;
									EndIf;
								EndDo;
							EndIf;
						EndDo;
					EndDo;
				EndIf;
			ElsIf ScanDataItem.UseSerialLotNumber Then
				Result.ChoiceForms.PresentationStartChoice_Counter = Result.ChoiceForms.PresentationStartChoice_Counter + 1;
				Result.ChoiceForms.PresentationStartChoice_Key = RowKey;
			EndIf;
		ElsIf Parameters.isSerialLotNumberAtRow Then
			If Object.UseSerialLot And ScanDataItem.UseSerialLotNumber And Not ValueIsFilled(ScanDataItem.SerialLotNumber) Then
				Result.ChoiceForms.StartChoice_Counter = Result.ChoiceForms.StartChoice_Counter + 1;
				Result.ChoiceForms.StartChoice_Key = RowKey;
			EndIf;
		EndIf;

		If Parameters.UseControlString Then
			Result.ChoiceForms.ControlStringStartChoice_Counter = Result.ChoiceForms.ControlStringStartChoice_Counter + 1;
			Result.ChoiceForms.ControlStringStartChoice_Key = RowKey;
		EndIf;

		If Parameters.UseSourceOfOrigins Then
			If ValueIsFilled(ScanDataItem.SourceOfOrigin) Then
				AddNewSourceOfOrigin(Object, RowKey, ScanDataItem);
			EndIf;
		EndIf;
	EndDo; // ScanData
	
	Return FillCache(Object, ArrayOfTableNames, Result);
EndFunction

Function FindRows(Object, Parameters, ScanDataItem)
	Result = New Structure("AddNewRow, Row, InventoryOrigin, Consignor", 
		True, Undefined, Undefined, Undefined);
	
	AlwaysAddNew = False;
	
	If Parameters.UseSerialLotNumbers Or Parameters.isSerialLotNumberAtRow Then
		If ScanDataItem.AlwaysAddNewRowAfterScan Then
			AlwaysAddNew = True;
		EndIf;
	EndIf;
			
	If AlwaysAddNew Then
		Return Result;
	EndIf;	
		
	ExistingRowsInfo = GetExistingRows_NotUseInventoryOrigin(Object, Parameters, ScanDataItem);
	
	// row exists increase quantity
	If ExistingRowsInfo.ExistingRows.Count() Then
		Result.AddNewRow = False;
		Result.Row = ExistingRowsInfo.ExistingRows[0];
	EndIf;
	Return Result;
EndFunction	

Function GetExistingRows_NotUseInventoryOrigin(Object, Parameters, ScanDataItem)
	Result = New Structure("ExistingRows", New Array());
	FilledFilter = New Structure();
	For Each KeyValue In Parameters.FilterStructure Do
		If ScanDataItem.Property(KeyValue.Key) And ValueIsFilled(ScanDataItem[KeyValue.Key]) Then
			FilledFilter.Insert(KeyValue.Key, ScanDataItem[KeyValue.Key]);
		EndIf;
	EndDo;
	Result.ExistingRows = Object.ItemList.FindRows(FilledFilter);	
	Return Result;
EndFunction

Function FillRow(Object, Parameters, Row, FillingValues)
	Parameters.ServerSideParameters.ServerParameters.Rows = New Array();
	Parameters.ServerSideParameters.ServerParameters.Rows.Add(Row);
			
	TmpParameters = ControllerClientServer_V2.GetParameters(
		Parameters.ServerSideParameters.ServerParameters, 
		Parameters.ServerSideParameters.FormParameters);
			
	ViewServer_V2.AddNewRowAtServer("ItemList", TmpParameters, ,FillingValues);
	
	Return New Structure("Cache, ViewNotify", TmpParameters.Cache, TmpParameters.ViewNotify);
EndFunction	

Function CleanCache(Object, Cache, ArrayOfTableNames)
	For Each TableName In ArrayOfTableNames Do
		If CommonFunctionsClientServer.ObjectHasProperty(Object, TableName) Then
			Cache.Insert(TableName, New Array());
		EndIf;
	EndDo;
	Return Cache;
EndFunction
	
Function FillCache(Object, ArrayOfTableNames, Result)
	ArrayOfExistsTables = New Array();
	For Each TableName In ArrayOfTableNames Do
		If Not CommonFunctionsClientServer.ObjectHasProperty(Object, TableName) Then
			Continue;
		EndIf;
		ArrayOfExistsTables.Add(TableName);
		
		Result.Insert(TableName, New Structure(TableName, New Array()));
		
		For Each Row In Object[TableName] Do
			NewRow = New Structure();
			For Each Column In Object.Ref.Metadata().TabularSections.Find(TableName).Attributes Do
				NewRow.Insert(Column.Name, Row[Column.Name]);
			EndDo;
						
			Result[TableName][TableName].Add(NewRow);
		EndDo;
	EndDo;	
	Result.Insert("ArrayOfTableNames", ArrayOfExistsTables);
	Return Result;
EndFunction

Function AddNewSerialLotNumber(Object, RowKey, ScanDataItem)	
	_SerialLotNumbers = New Array();
	_SerialLotNumbers.Add(New Structure("SerialLotNumber, Quantity", 
		ScanDataItem.SerialLotNumber, ScanDataItem.Quantity));
	SerialLotNumberInfo = SerialLotNumberClientServer.AddNewSerialLotNumbers(Object, RowKey, _SerialLotNumbers, True);
	
	SourceOfOriginClientServer.UpdateSourceOfOriginsQuantity(Object);
	SourceOfOriginClientServer.DeleteUnusedSourceOfOrigins(Object);
	Return SerialLotNumberInfo;
EndFunction

Procedure AddNewSourceOfOrigin(Object, RowKey, ScanDataItem)
	_SourceOfOrigins = New Array();
	SerialLotNumber = Catalogs.SerialLotNumbers.EmptyRef();
	If ValueIsFilled(ScanDataItem.SerialLotNumber) Then
		SerialLotNumber = ScanDataItem.SerialLotNumber;
	EndIf;
	_SourceOfOrigins.Add(New Structure("SourceOfOrigin, SerialLotNumber",
		ScanDataItem.SourceOfOrigin, SerialLotNumber));
	
	SourceOfOriginClientServer.AddNewSourceOfOrigins(Object, RowKey, _SourceOfOrigins);
EndProcedure

Procedure BeforeWrite_CheckFillingRowKeyBeforeWrite(Source, Cancel, WriteMode, PostingMode) Export
	If Source.DataExchange.Load Then
		Return;
	EndIf;
	
	If Cancel Then
		Return;
	EndIf;
	
	ArrayOfExcludedTabularSectionNames = New Array();
	ArrayOfExcludedTabularSectionNames.Add("Currencies");
	
	For Each TabularSection In Source.Ref.Metadata().TabularSections Do
		If ArrayOfExcludedTabularSectionNames.Find(TabularSection.Name) <> Undefined Then
			Continue;
		EndIf;
		
		If TabularSection.Attributes.Find("Key") = Undefined Then
			Continue;
		EndIf;
		
		For Each Row In Source[TabularSection.Name] Do
			If Not ValueIsFilled(Row.Key) Then
				CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_137, TabularSection.Name, Row.LineNumber));
				Cancel = True;
			EndIf;
		EndDo;
	EndDo;
EndProcedure

Procedure SalesBySerialLotNumbers(Parameters) Export
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text = 
		"SELECT
		|	ItemList.Key AS Key,
		|	ItemList.Quantity,
		|	ItemList.Amount AS Amount,
		|	ItemList.NetAmount AS NetAmount,
		|	ItemList.OffersAmount AS OffersAmount,
		|	SerialLotNumbers.SerialLotNumber,
		|	SerialLotNumbers.Quantity AS SLNQuantity
		|FROM
		|	ItemList AS ItemList
		|		LEFT JOIN SerialLotNumbers as SerialLotNumbers
		|		ON ItemList.Key = SerialLotNumbers.Key
		|TOTALS
		|	MAX(Amount) AS Amount,
		|	MAX(NetAmount) AS NetAmount,
		|	MAX(OffersAmount) AS OffersAmount
		|BY
		|	Key";
	
	QueryResult = Query.Execute();
	Tree = QueryResult.Unload(QueryResultIteration.ByGroups);	
	
	AccMetadata = Metadata.AccumulationRegisters.R2001T_Sales;
	ResultTable = New ValueTable();
	ResultTable.Columns.Add("Key"          , AccMetadata.Dimensions.RowKey.Type);
	ResultTable.Columns.Add("SerialLotNumber" , AccMetadata.Dimensions.SerialLotNumber.Type);
	ResultTable.Columns.Add("Quantity"     , AccMetadata.Resources.Quantity.Type);
	ResultTable.Columns.Add("Amount"       , AccMetadata.Resources.Amount.Type);
	ResultTable.Columns.Add("NetAmount"    , AccMetadata.Resources.NetAmount.Type);
	ResultTable.Columns.Add("OffersAmount" , AccMetadata.Resources.OffersAmount.Type);
	
	For Each Row In Tree.Rows Do
		If Row.Rows.Count() = 1 Then
			FillPropertyValues(ResultTable.Add(), Row.Rows[0]);
			Continue;
		EndIf;
		
		Total_Amount = Row.Amount;
		Total_NetAmount = Row.NetAmount;
		Total_OffersAmount = Row.OffersAmount;
		
		MaxRow = Undefined;
		
		For Each Row2 In Row.Rows Do
			If Not ValueIsFilled(Row2.SLNQuantity) Then
				Continue;
			EndIf;
			
			NewRow = ResultTable.Add();
			FillPropertyValues(NewRow, Row2);
			NewRow.Quantity	= Row2.SLNQuantity;
			
			If MaxRow = Undefined Then
				MaxRow = NewRow;
			Else
				If MaxRow.Quantity < NewRow.Quantity Then
					MaxRow = NewRow;
				EndIf;
			EndIf;
			proportion = Row2.Quantity / Row2.SLNQuantity;
			If proportion <> 0 Then
				NewRow.Amount = Round(Row2.Amount / proportion, 2);
				Total_Amount = Total_Amount - NewRow.Amount;
			
				NewRow.NetAmount = Round(Row2.NetAmount / proportion, 2);
				Total_NetAmount = Total_NetAmount - NewRow.NetAmount;
				
				NewRow.OffersAmount = Round(Row2.OffersAmount / proportion, 2);
				Total_OffersAmount = Total_OffersAmount - NewRow.OffersAmount;
			EndIf;
		EndDo;
		
		If MaxRow <> Undefined Then
			If Total_Amount <> 0 Then
				MaxRow.Amount = MaxRow.Amount + Total_Amount;
			EndIf;
				
			If Total_NetAmount <> 0 Then
				MaxRow.NetAmount = MaxRow.NetAmount + Total_NetAmount;
			EndIf;
				
			If Total_OffersAmount <> 0 Then
				MaxRow.OffersAmount = MaxRow.OffersAmount + Total_OffersAmount;
			EndIf;
		EndIf;
		
	EndDo;
			
	Query.Text = "SELECT * INTO SalesBySerialLotNumbers  FROM &ResultTable AS SalesBySerialLotNumbers";
	Query.SetParameter("ResultTable", ResultTable);
	Query.Execute();
		
EndProcedure

Procedure PurchasesBySerialLotNumbers(Parameters) Export
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text = 
		"SELECT
		|	ItemList.Key AS Key,
		|	ItemList.Quantity,
		|	ItemList.Amount AS Amount,
		|	ItemList.NetAmount AS NetAmount,
		|	ItemList.OffersAmount AS OffersAmount,
		|	SerialLotNumbers.SerialLotNumber,
		|	SerialLotNumbers.Quantity AS SLNQuantity
		|FROM
		|	ItemList AS ItemList
		|		LEFT JOIN SerialLotNumbers as SerialLotNumbers
		|		ON ItemList.Key = SerialLotNumbers.Key
		|TOTALS
		|	MAX(Amount) AS Amount,
		|	MAX(NetAmount) AS NetAmount,
		|	MAX(OffersAmount) AS OffersAmount
		|BY
		|	Key";
	
	QueryResult = Query.Execute();
	Tree = QueryResult.Unload(QueryResultIteration.ByGroups);	
	
	AccMetadata = Metadata.AccumulationRegisters.R1001T_Purchases;
	ResultTable = New ValueTable();
	ResultTable.Columns.Add("Key"             , AccMetadata.Dimensions.RowKey.Type);
	ResultTable.Columns.Add("SerialLotNumber" , AccMetadata.Dimensions.SerialLotNumber.Type);
	ResultTable.Columns.Add("Quantity"        , AccMetadata.Resources.Quantity.Type);
	ResultTable.Columns.Add("Amount"          , AccMetadata.Resources.Amount.Type);
	ResultTable.Columns.Add("NetAmount"       , AccMetadata.Resources.NetAmount.Type);
	ResultTable.Columns.Add("OffersAmount"    , AccMetadata.Resources.OffersAmount.Type);
	
	For Each Row In Tree.Rows Do
		If Row.Rows.Count() = 1 Then
			FillPropertyValues(ResultTable.Add(), Row.Rows[0]);
			Continue;
		EndIf;
		
		Total_Amount = Row.Amount;
		Total_NetAmount = Row.NetAmount;
		Total_OffersAmount = Row.OffersAmount;
		
		MaxRow = Undefined;
		
		For Each Row2 In Row.Rows Do
			If Not ValueIsFilled(Row2.SLNQuantity) Then
				Continue;
			EndIf;
			
			NewRow = ResultTable.Add();
			FillPropertyValues(NewRow, Row2);
			NewRow.Quantity	= Row2.SLNQuantity;
			
			If MaxRow = Undefined Then
				MaxRow = NewRow;
			Else
				If MaxRow.Quantity < NewRow.Quantity Then
					MaxRow = NewRow;
				EndIf;
			EndIf;
			proportion = Row2.Quantity / Row2.SLNQuantity;
			If proportion <> 0 Then
				NewRow.Amount = Round(Row2.Amount / proportion, 2);
				Total_Amount = Total_Amount - NewRow.Amount;
			
				NewRow.NetAmount = Round(Row2.NetAmount / proportion, 2);
				Total_NetAmount = Total_NetAmount - NewRow.NetAmount;
				
				NewRow.OffersAmount = Round(Row2.OffersAmount / proportion, 2);
				Total_OffersAmount = Total_OffersAmount - NewRow.OffersAmount;
			EndIf;
		EndDo;
		
		If MaxRow <> Undefined Then
			If Total_Amount <> 0 Then
				MaxRow.Amount = MaxRow.Amount + Total_Amount;
			EndIf;
				
			If Total_NetAmount <> 0 Then
				MaxRow.NetAmount = MaxRow.NetAmount + Total_NetAmount;
			EndIf;
				
			If Total_OffersAmount <> 0 Then
				MaxRow.OffersAmount = MaxRow.OffersAmount + Total_OffersAmount;
			EndIf;
		EndIf;
		
	EndDo;
			
	Query.Text = "SELECT * INTO PurchasesBySerialLotNumbers  FROM &ResultTable AS PurchasesBySerialLotNumbers";
	Query.SetParameter("ResultTable", ResultTable);
	Query.Execute();
		
EndProcedure

Procedure Posting_DocumentsRegistryPosting(Source, Cancel, PostingMode) Export
	If Cancel Then
		Return;
	EndIf;
	
	RecordSet = Source.RegisterRecords.PostedDocumentsRegistry;
	RecordSet.Clear();
	RecordSet.Write = True;
	Record = RecordSet.Add();
	FillPropertyValues(Record, Source);
	Record.Document = Source.Ref;
EndProcedure

Procedure GetDocumentPresentationFields(Source, Fields, StandardProcessing) Export
	If Not StandardProcessing Then
		Return;
	EndIf;
	StandardProcessing = False;
	Fields.Add("Number");
	Fields.Add("DocumentNumber");
	Fields.Add("Date");
EndProcedure

Procedure GetDocumentPresentation(Source, Data, Presentation, StandardProcessing) Export
	If Not StandardProcessing Then
		Return;
	EndIf;
	StandardProcessing = False;
	
	ObjectPresentation = Source.EmptyRef().Metadata().ObjectPresentation;
	DocumentNumber = ?(ValueIsFilled(Data.DocumentNumber),StrTemplate(" (%1)", Data.DocumentNumber), "");
	NewNumber = StrTemplate("%1%2", Data.Number, DocumentNumber);
	
	Presentation = StrTemplate(R().DocPresentation, ObjectPresentation, NewNumber, Data.Date);
EndProcedure

Function GenerateDocumentNumber(Object) Export
	Return Object.DocumentNumber;
EndFunction
