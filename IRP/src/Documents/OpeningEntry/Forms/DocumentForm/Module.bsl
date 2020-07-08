#Region FormEvents

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters, AddInfo = Undefined) Export
	DocOpeningEntryServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	FillItemList();
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LibraryLoader.RegisterLibrary(Object, ThisObject, Currencies_GetDeclaration(Object, ThisObject));	
	DocOpeningEntryServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
EndProcedure

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)
	ItemList = Object.Inventory.Unload().Copy(New Structure("ItemKey", PredefinedValue("Catalog.ItemKeys.EmptyRef")));
	ObjectRef = Object.Ref;
	
	If ItemList.Count() = 0 Then
		RecordSet = InformationRegisters.SavedItems.CreateRecordSet();
		RecordSet.Filter.ObjectRef.Set(Object.Ref);
		RecordSet.Write(True);
		Return;
	EndIf;
	
	ItemList.Columns.Add("ObjectRef");
	ItemList.FillValues(Object.Ref, "ObjectRef");
	
	RecordSet = InformationRegisters.SavedItems.CreateRecordSet();
	RecordSet.Filter.ObjectRef.Set(ObjectRef);
	
	RecordSet.Load(ItemList);
	RecordSet.Write(True);
EndProcedure

#EndRegion

&AtServer
Procedure FillItemList()
	RowMap = New Map();
	For Each Row In Object.Inventory Do
		RowMap.Insert(Row.Key, Row);
		Row.Item = Row.ItemKey.Item;
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
	QuerySelection = QueryResult.Select();
	
	While QuerySelection.Next() Do
		RowMap[QuerySelection.Key].Item = QuerySelection.Item;
	EndDo;
EndProcedure

&AtClient
Procedure MainTableOnChange(Item)
	For Each Row In Object[Item.Name] Do
		If Not ValueIsFilled(Row.Key) Then
			Row.Key = New UUID();
		EndIf;
	EndDo;
EndProcedure

&AtClient
Procedure AccountBalanceOnActivateCell(Item)
	CurrentData = Items.AccountBalance.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	CashAccountInfo = CatCashAccountsServer.GetCashAccountInfo(CurrentData.Account);
	
	Items.AccountBalanceCurrency.ReadOnly = 
	Item.CurrentItem.Name = "AccountBalanceCurrency" And ValueIsFilled(CashAccountInfo.Currency);
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject) Export
	DocOpeningEntryServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	FillItemList();
EndProcedure

&AtClient
Procedure OnOpen(Cancel, AddInfo = Undefined) Export
	DocOpeningEntryClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtClient
Procedure CompanyOnChange(Item, AddInfo = Undefined) Export
	DocOpeningEntryClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocOpeningEntryClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocOpeningEntryClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure DateOnChange(Item, AddInfo = Undefined) Export
	DocOpeningEntryClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocOpeningEntryClient.DecorationGroupTitleCollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLabelClick(Item)
	DocOpeningEntryClient.DecorationGroupTitleCollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocOpeningEntryClient.DecorationGroupTitleUncollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLabelClick(Item)
	DocOpeningEntryClient.DecorationGroupTitleUncollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	DocOpeningEntryClient.DescriptionClick(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure InventoryItemStartChoice(Item, ChoiceData, StandardProcessing)
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
	                                True, DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("ItemType.Type", 
	                                PredefinedValue("Enum.ItemTypes.Service"), DataCompositionComparisonType.NotEqual));

	DocumentsClient.ItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

&AtClient
Procedure InventoryItemEditTextChange(Item, Text, StandardProcessing)
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("ItemType.Type", 
	                                                          PredefinedValue("Enum.ItemTypes.Service"), ComparisonType.NotEqual));
	DocumentsClient.ItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

&AtClient
Procedure AccountBalanceAccountOnChange(Item, AddInfo = Undefined) Export
	CurrentData = Items.AccountBalance.CurrentData;
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Currencies_CurrentTableName", "AccountBalance");
	If CurrentData = Undefined Then
		Return;
	EndIf;
	CashAccountInfo = CatCashAccountsServer.GetCashAccountInfo(CurrentData.Account);
	CurrentData.Currency = CashAccountInfo.Currency;
EndProcedure

&AtClient
Procedure GroupPagesOnCurrentPageChange(Item, CurrentPage)
	CurrentTableName = GetCurrentTableName(CurrentPage);
	If ValueIsFilled(CurrentTableName) Then
		Currencies_MainTableOnActivateRow(CurrentTableName);
	EndIf;
EndProcedure

&AtClient
Procedure GroupAdvanceFromCustomersAndToSuppliersOnCurrentPageChange(Item, CurrentPage)
	CurrentTableName = GetCurrentTableName_Advance(CurrentPage.Name);
	If CurrentTableName <> Undefined Then
		Currencies_MainTableOnActivateRow(CurrentTableName);
	EndIf;
EndProcedure

&AtClient
Function GetCurrentTableName_Advance(PageName)
	If PageName = "GroupFromCustomers" Then
		Return "AdvanceFromCustomers";
	ElsIf PageName = "GroupToSuppliers" Then
		Return "AdvanceToSuppliers";
	Else
		Return Undefined;
	EndIf;
EndFunction

&AtClient
Procedure GroupAccountPayableByAgreementsAndByDocumentsOnCurrentPageChange(Item, CurrentPage)
	CurrentTableName = GetCurrentTableName_AccountPayable(CurrentPage.Name);
	If CurrentTableName <> Undefined Then
		Currencies_MainTableOnActivateRow(CurrentTableName);
	EndIf;
EndProcedure

&AtClient
Function GetCurrentTableName_AccountPayable(PageName)
	If PageName = "GroupAccountPayableByAgreements" Then
		Return "AccountPayableByAgreements";
	ElsIf PageName = "GroupAccountPayableByDocuments" Then
		 Return "AccountPayableByDocuments";
	Else
		Return Undefined;
	EndIf;
EndFunction

&AtClient
Procedure GroupAccountReceivableByAgreementsAndByDocumentsOnCurrentPageChange(Item, CurrentPage)
	CurrentTableName = GetCurrentTableName_AccountReceivable(CurrentPage.Name);
	If CurrentTableName <> Undefined Then
		Currencies_MainTableOnActivateRow(CurrentTableName);
	EndIf;
EndProcedure

&AtClient
Function GetCurrentTableName_AccountReceivable(PageName)
	If PageName = "GroupAccountReceivableByAgreements" Then
		Return "AccountReceivableByAgreements";
	ElsIf PageName = "GroupAccountReceivableByDocuments" Then
		Return "AccountReceivableByDocuments";
	Else
		Return Undefined;
	EndIf;
EndFunction

&AtClient
Function GetCurrentTableName(CurrentPage)
	If CurrentPage.Name = "GroupAdvance" Then
		PageName = CurrentPage.ChildItems.GroupAdvanceFromCustomersAndToSuppliers.CurrentPage.Name;
		Return GetCurrentTableName_Advance(PageName);
	ElsIf CurrentPage.Name = "GroupAccountPayable" Then
		PageName = CurrentPage.ChildItems.GroupAccountPayableByAgreementsAndByDocuments.CurrentPage.Name;
		Return GetCurrentTableName_AccountPayable(PageName);
	ElsIf CurrentPage.Name = "GroupAccountReceivable" Then
		PageName = CurrentPage.ChildItems.GroupAccountReceivableByAgreementsAndByDocuments.CurrentPage.Name;
		Return GetCurrentTableName_AccountReceivable(PageName);
	ElsIf CurrentPage.Name = "GroupAccountBalance" Then
		Return "AccountBalance";
	Else
		Return Undefined;
	EndIf;
EndFunction

&AtClient
Procedure MainTableLegalNameStartChoice(Item, ChoiceData, StandardProcessing)
	CurrentData = Items[StrReplace(Item.Name, "LegalName", "")].CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
																	True, DataCompositionComparisonType.NotEqual));
	OpenSettings.FormParameters = New Structure();
	If ValueIsFilled(CurrentData.Partner) Then
		OpenSettings.FormParameters.Insert("Partner", CurrentData.Partner);
		OpenSettings.FormParameters.Insert("FilterByPartnerHierarchy", True);
	EndIf;
	OpenSettings.FillingData = New Structure("Partner", CurrentData.Partner);
	
	DocumentsClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

&AtClient
Procedure AdvanceFromCustomersOnActivateCell(Item)
	AdvanceMainTableOnActivateCell("AdvanceFromCustomers", Item);
EndProcedure

&AtClient
Procedure AdvanceToSuppliersOnActivateCell(Item)
	AdvanceMainTableOnActivateCell("AdvanceToSuppliers", Item);
EndProcedure

&AtClient
Procedure AccountPayableByAgreementsOnActivateCell(Item)
	AccountByAgreementsMainTableOnActivateCell("AccountPayableByAgreements", Item);
EndProcedure

&AtClient
Procedure AccountPayableByDocumentsOnActivateCell(Item)
	AccountByDocumentsMainTableOnActivateCell("AccountPayableByDocuments", Item);
EndProcedure

&AtClient
Procedure AccountReceivableByAgreementsOnActivateCell(Item)
	AccountByAgreementsMainTableOnActivateCell("AccountReceivableByAgreements", Item);
EndProcedure

&AtClient
Procedure AccountReceivableByDocumentsOnActivateCell(Item)
	AccountByDocumentsMainTableOnActivateCell("AccountReceivableByDocuments", Item);
EndProcedure

&AtClient
Procedure AdvanceMainTableOnActivateCell(TableName, Item)
	CurrentData = Items[TableName].CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;	
	Items[TableName + "LegalName"].ReadOnly = Not ValueIsFilled(CurrentData.Partner);
EndProcedure

&AtClient
Procedure AccountByAgreementsMainTableOnActivateCell(TableName, Item)
	CurrentData = Items[TableName].CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;	
	Items[TableName + "LegalName"].ReadOnly = Not ValueIsFilled(CurrentData.Partner);
	Items[TableName + "Agreement"].ReadOnly = Not ValueIsFilled(CurrentData.Partner);
EndProcedure

&AtClient
Procedure AccountByDocumentsMainTableOnActivateCell(TableName, Item)
	CurrentData = Items[TableName].CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;	
	Items[TableName + "LegalName"].ReadOnly = Not ValueIsFilled(CurrentData.Partner);
	Items[TableName + "Agreement"].ReadOnly = Not ValueIsFilled(CurrentData.Partner);
	Items[TableName + "BasisDocument"].ReadOnly = 
	Not ValueIsFilled(CurrentData.Partner) Or Not ValueIsFilled(CurrentData.Agreement);
EndProcedure

&AtClient
Procedure AdvanceMainTablePartnerOnChange(Item)
	CurrentData = Items[StrReplace(Item.Name, "Partner", "")].CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	CurrentData.LegalName = DocumentsServer.GetLegalNameByPartner(CurrentData.Partner, CurrentData.LegalName);
EndProcedure

&AtClient
Function AccountByAgreementsMainTablePartnerOnChange(Item, AgreementType, ApArPostingDetail)
	TableName = StrReplace(Item.Name, "Partner", "");
	CurrentData = Items[TableName].CurrentData;
	If CurrentData = Undefined Then
		Return Undefined;
	EndIf;
	CurrentData.LegalName = DocumentsServer.GetLegalNameByPartner(CurrentData.Partner, CurrentData.LegalName);
	AgreementParameters = New Structure();
	AgreementParameters.Insert("Partner", CurrentData.Partner);
	AgreementParameters.Insert("Agreement", CurrentData.Agreement);
	AgreementParameters.Insert("CurrentDate", Object.Date);
	
	AgreementParameters.Insert("ArrayOfFilters", New Array());
	AgreementParameters.ArrayOfFilters.Add(
	DocumentsClientServer.CreateFilterItem("Type", AgreementType, ComparisonType.Equal));
	AgreementParameters.ArrayOfFilters.Add(
	DocumentsClientServer.CreateFilterItem("ApArPostingDetail", ApArPostingDetail, ComparisonType.Equal));
	
	CurrentData.Agreement = DocumentsServer.GetAgreementByPartner(AgreementParameters);
	AgreementInfo = CatAgreementsServer.GetAgreementInfo(CurrentData.Agreement);
	CurrentData.Currency = AgreementInfo.Currency;
	Return TableName;
EndFunction

&AtClient
Function AccountByDocumentsMainTablePartnerOnChange(Item, AgreementType, ApArPostingDetail)
	TableName = StrReplace(Item.Name, "Partner", "");
	CurrentData = Items[TableName].CurrentData;
	If CurrentData = Undefined Then
		Return Undefined;
	EndIf;
	CurrentData.LegalName = DocumentsServer.GetLegalNameByPartner(CurrentData.Partner, CurrentData.LegalName);
	AgreementParameters = New Structure();
	AgreementParameters.Insert("Partner", CurrentData.Partner);
	AgreementParameters.Insert("Agreement", CurrentData.Agreement);
	AgreementParameters.Insert("CurrentDate", Object.Date);
	AgreementParameters.Insert("PartnerType", AgreementType);
	AgreementParameters.Insert("ApArPostingDetail", ApArPostingDetail);
	AgreementParameters.Insert("ArrayOfFilters", New Array());
	
	CurrentData.Agreement = DocumentsServer.GetAgreementByPartner(AgreementParameters);
	AgreementInfo = CatAgreementsServer.GetAgreementInfo(CurrentData.Agreement);
	CurrentData.Currency = AgreementInfo.Currency;
	Return TableName;
EndFunction

&AtClient
Procedure AccountPayableByAgreementsPartnerOnChange(Item, AddInfo = Undefined) Export
	TableName = AccountByAgreementsMainTablePartnerOnChange(Item, 
	                                                        PredefinedValue("Enum.AgreementTypes.Vendor"),
	                                                        PredefinedValue("Enum.ApArPostingDetail.ByAgreements"));
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Currencies_CurrentTableName", TableName);
EndProcedure

&AtClient
Procedure AccountReceivableByAgreementsPartnerOnChange(Item, AddInfo = Undefined) Export
	TableName = AccountByAgreementsMainTablePartnerOnChange(Item, 
	                                                        PredefinedValue("Enum.AgreementTypes.Customer"),
	                                                        PredefinedValue("Enum.ApArPostingDetail.ByAgreements"));
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Currencies_CurrentTableName", TableName);
EndProcedure

&AtClient
Procedure AccountPayableByDocumentsPartnerOnChange(Item, AddInfo = Undefined) Export
	TableName = AccountByDocumentsMainTablePartnerOnChange(Item, 
	                                                       PredefinedValue("Enum.AgreementTypes.Vendor"),
	                                                       PredefinedValue("Enum.ApArPostingDetail.ByDocuments"));
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Currencies_CurrentTableName", TableName);
EndProcedure

&AtClient
Procedure AccountReceivableByDocumentsPartnerOnChange(Item, AddInfo = Undefined) Export
	TableName = AccountByDocumentsMainTablePartnerOnChange(Item, 
	                                                       PredefinedValue("Enum.AgreementTypes.Customer"),
	                                                       PredefinedValue("Enum.ApArPostingDetail.ByDocuments"));
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Currencies_CurrentTableName", TableName);
EndProcedure

&AtClient
Procedure MainTableLegalNameEditTextChange(Item, Text, StandardProcessing)
	CurrentData = Items[StrReplace(Item.Name, "LegalName", "")].CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	AdditionalParameters = New Structure();
	If ValueIsFilled(CurrentData.Partner) Then
		AdditionalParameters.Insert("Partner", CurrentData.Partner);
		AdditionalParameters.Insert("FilterByPartnerHierarchy", True);
	EndIf;
	DocumentsClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing, ArrayOfFilters, AdditionalParameters);
EndProcedure

&AtClient
Procedure AccountReceivableByAgreementsAgreementStartChoice(Item, ChoiceData, StandardProcessing)
	AgreementStartChoice("AccountReceivableByAgreements", 
	                     PredefinedValue("Enum.AgreementTypes.Customer"),
	                     PredefinedValue("Enum.ApArPostingDetail.ByAgreements"),
	                     Item, 
	                     ChoiceData, 
	                     StandardProcessing);
EndProcedure

&AtClient
Procedure AccountReceivableByDocumentsAgreementStartChoice(Item, ChoiceData, StandardProcessing)
	AgreementStartChoice("AccountReceivableByDocuments", 
	                     PredefinedValue("Enum.AgreementTypes.Customer"),
	                     PredefinedValue("Enum.ApArPostingDetail.ByDocuments"),
	                     Item, 
	                     ChoiceData, 
	                     StandardProcessing);	
EndProcedure

&AtClient
Procedure AccountPayableByAgreementsAgreementStartChoice(Item, ChoiceData, StandardProcessing)
	AgreementStartChoice("AccountPayableByAgreements", 
	                     PredefinedValue("Enum.AgreementTypes.Vendor"),
	                     PredefinedValue("Enum.ApArPostingDetail.ByAgreements"),
	                     Item, 
	                     ChoiceData, 
	                     StandardProcessing);
EndProcedure

&AtClient
Procedure AccountPayableByDocumentsAgreementStartChoice(Item, ChoiceData, StandardProcessing)
	AgreementStartChoice("AccountPayableByDocuments", 
	                     PredefinedValue("Enum.AgreementTypes.Vendor"),
	                     PredefinedValue("Enum.ApArPostingDetail.ByDocuments"),
	                     Item, 
	                     ChoiceData, 
	                     StandardProcessing);
EndProcedure

&AtClient
Procedure AgreementStartChoice(TableName, AgreementType, ApArPostingDetail, Item, ChoiceData, StandardProcessing)
	CurrentData = Items[TableName].CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark",
									True, 
	                                DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type", 
	                                AgreementType, 
	                                DataCompositionComparisonType.Equal));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("ApArPostingDetail", 
	                                ApArPostingDetail, 
	                                DataCompositionComparisonType.Equal));
	OpenSettings.FormParameters = New Structure();
	OpenSettings.FormParameters.Insert("Partner", CurrentData.Partner);
	OpenSettings.FormParameters.Insert("IncludeFilterByPartner", True);
	OpenSettings.FormParameters.Insert("IncludePartnerSegments", True);
	OpenSettings.FormParameters.Insert("EndOfUseDate", Object.Date);
	OpenSettings.FormParameters.Insert("IncludeFilterByEndOfUseDate", True);
	OpenSettings.FillingData = New Structure();
	OpenSettings.FillingData.Insert("Partner", CurrentData.Partner);
	OpenSettings.FillingData.Insert("LegalName", CurrentData.LegalName);
	OpenSettings.FillingData.Insert("Company", Object.Company);
	OpenSettings.FillingData.Insert("Type", AgreementType);
	OpenSettings.FillingData.Insert("ApArPostingDetail", ApArPostingDetail);
	
	DocumentsClient.AgreementStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

&AtClient
Procedure AccountReceivableByAgreementsAgreementEditTextChange(Item, Text, StandardProcessing)
	AgreementEditTextChange("AccountReceivableByAgreements",
		                     PredefinedValue("Enum.AgreementTypes.Customer"),
	                         PredefinedValue("Enum.ApArPostingDetail.ByAgreements"),
	                         Item,
	                         Text,
	                         StandardProcessing); 
	
EndProcedure

&AtClient
Procedure AccountReceivableByDocumentsAgreementEditTextChange(Item, Text, StandardProcessing)
	AgreementEditTextChange("AccountReceivableByDocuments",
	                        PredefinedValue("Enum.AgreementTypes.Customer"),
	                        PredefinedValue("Enum.ApArPostingDetail.ByDocuments"),
	                        Item,
	                        Text,
	                        StandardProcessing);
EndProcedure

&AtClient
Procedure AccountPayableByAgreementsAgreementEditTextChange(Item, Text, StandardProcessing)
	AgreementEditTextChange("AccountPayableByAgreements",
	                        PredefinedValue("Enum.AgreementTypes.Vendor"),
	                        PredefinedValue("Enum.ApArPostingDetail.ByAgreements"),
	                        Item,
	                        Text,
	                        StandardProcessing);
EndProcedure

&AtClient
Procedure AccountPayableByDocumentsAgreementEditTextChange(Item, Text, StandardProcessing)
	AgreementEditTextChange("AccountPayableByDocuments",
		                    PredefinedValue("Enum.AgreementTypes.Vendor"),
	                        PredefinedValue("Enum.ApArPostingDetail.ByDocuments"),
	                         Item,
	                         Text,
	                         StandardProcessing);
EndProcedure

&AtClient
Procedure AgreementEditTextChange(TableName, AgreementType, ApArPostingDetail, Item, Text, StandardProcessing)
	CurrentData = Items[TableName].CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type", AgreementType, ComparisonType.Equal));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("ApArPostingDetail", ApArPostingDetail, ComparisonType.Equal));
	AdditionalParameters = New Structure();
	AdditionalParameters.Insert("IncludeFilterByEndOfUseDate", True);
	AdditionalParameters.Insert("IncludeFilterByPartner", True);
	AdditionalParameters.Insert("IncludePartnerSegments", True);
	AdditionalParameters.Insert("EndOfUseDate", Object.Date);
	AdditionalParameters.Insert("Partner", CurrentData.Partner);
	DocumentsClient.AgreementEditTextChange(Object, ThisObject, Item, Text, StandardProcessing, ArrayOfFilters, AdditionalParameters);	
EndProcedure

&AtClient
Procedure AgreementOnChange(Item, AddInfo = Undefined) Export
	CountLeftSymbols = 29;
	TableName  = Left("AccountReceivableByAgreementsAgreement", CountLeftSymbols);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Currencies_CurrentTableName", TableName);
	CurrentData = Items[TableName].CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	AgreementInfo = CatAgreementsServer.GetAgreementInfo(CurrentData.Agreement);
	CurrentData.Currency = AgreementInfo.Currency;
EndProcedure

#Region Currencies

#Region Currencies_Library_Loader

&AtServerNoContext
Function Currencies_GetDeclaration(Object, Form)
	Declaration = LibraryLoader.GetDeclarationInfo();
	Declaration.LibraryName = "LibraryCurrencies";
	
	LibraryLoader.AddActionHandler(Declaration, "Currencies_OnOpen", "OnOpen", Form);
	LibraryLoader.AddActionHandler(Declaration, "Currencies_AfterWriteAtServer", "AfterWriteAtServer", Form);
	LibraryLoader.AddActionHandler(Declaration, "Currencies_AfterWrite", "AfterWrite", Form);
	
	ArrayOfItems_MainTable = New Array();
	ArrayOfItems_MainTable.Add(Form.Items.AccountBalance);
	ArrayOfItems_MainTable.Add(Form.Items.AdvanceFromCustomers);
	ArrayOfItems_MainTable.Add(Form.Items.AdvanceToSuppliers);
	ArrayOfItems_MainTable.Add(Form.Items.AccountPayableByAgreements);
	ArrayOfItems_MainTable.Add(Form.Items.AccountPayableByDocuments);
	ArrayOfItems_MainTable.Add(Form.Items.AccountReceivableByAgreements);
	ArrayOfItems_MainTable.Add(Form.Items.AccountReceivableByDocuments);
	LibraryLoader.AddActionHandler(Declaration, "Currencies_MainTableBeforeDeleteRow", "BeforeDeleteRow", ArrayOfItems_MainTable);
	LibraryLoader.AddActionHandler(Declaration, "Currencies_MainTableOnActivateRow", "OnActivateRow", ArrayOfItems_MainTable);
	
	ArrayOfItems_MainTableColumns = New Array();
	ArrayOfItems_MainTableColumns.Add(Form.Items.AccountBalanceCurrency);
	ArrayOfItems_MainTableColumns.Add(Form.Items.AdvanceFromCustomersCurrency);
	ArrayOfItems_MainTableColumns.Add(Form.Items.AdvanceToSuppliersCurrency);
	ArrayOfItems_MainTableColumns.Add(Form.Items.AccountPayableByAgreementsCurrency);
	ArrayOfItems_MainTableColumns.Add(Form.Items.AccountPayableByDocumentsCurrency);
	ArrayOfItems_MainTableColumns.Add(Form.Items.AccountReceivableByAgreementsCurrency);
	ArrayOfItems_MainTableColumns.Add(Form.Items.AccountReceivableByDocumentsCurrency);
	
	ArrayOfItems_MainTableColumns.Add(Form.Items.AccountBalanceAccount);
	
	ArrayOfItems_MainTableColumns.Add(Form.Items.AccountPayableByAgreementsAgreement);
	ArrayOfItems_MainTableColumns.Add(Form.Items.AccountPayableByDocumentsAgreement);
	ArrayOfItems_MainTableColumns.Add(Form.Items.AccountReceivableByAgreementsAgreement);
	ArrayOfItems_MainTableColumns.Add(Form.Items.AccountReceivableByDocumentsAgreement);
	
	ArrayOfItems_MainTableColumns.Add(Form.Items.AccountPayableByAgreementsPartner);
	ArrayOfItems_MainTableColumns.Add(Form.Items.AccountPayableByDocumentsPartner);
	ArrayOfItems_MainTableColumns.Add(Form.Items.AccountReceivableByAgreementsPartner);
	ArrayOfItems_MainTableColumns.Add(Form.Items.AccountReceivableByDocumentsPartner);
	LibraryLoader.AddActionHandler(Declaration, "Currencies_MainTableColumnOnChange", "OnChange", ArrayOfItems_MainTableColumns);
	
	ArrayOfItems_MainTableAmount = New Array();
	ArrayOfItems_MainTableAmount.Add(Form.Items.AccountBalanceAmount);
	ArrayOfItems_MainTableAmount.Add(Form.Items.AdvanceFromCustomersAmount);
	ArrayOfItems_MainTableAmount.Add(Form.Items.AdvanceToSuppliersAmount);
	ArrayOfItems_MainTableAmount.Add(Form.Items.AccountPayableByAgreementsAmount);
	ArrayOfItems_MainTableAmount.Add(Form.Items.AccountPayableByDocumentsAmount);
	ArrayOfItems_MainTableAmount.Add(Form.Items.AccountReceivableByAgreementsAmount);
	ArrayOfItems_MainTableAmount.Add(Form.Items.AccountReceivableByDocumentsAmount);
	LibraryLoader.AddActionHandler(Declaration, "Currencies_MainTableAmountOnChange", "OnChange", ArrayOfItems_MainTableAmount);
	
	ArrayOfItems_Header = New Array();
	ArrayOfItems_Header.Add(Form.Items.Company);
	ArrayOfItems_Header.Add(Form.Items.Date);
	LibraryLoader.AddActionHandler(Declaration, "Currencies_HeaderOnChange", "OnChange", ArrayOfItems_Header);
	
	LibraryData = New Structure();
	LibraryData.Insert("Version", "1.0");
	LibraryLoader.PutData(Declaration, LibraryData);
	
	Return Declaration;
EndFunction

#Region Currencies_Event_Handlers

&AtClient
Procedure Currencies_OnOpen(Cancel, AddInfo = Undefined) Export
	CurrenciesClientServer.OnOpen(Object, ThisObject, Cancel, AddInfo);
EndProcedure

&AtServer
Procedure Currencies_AfterWriteAtServer(CurrentObject, WriteParameters, AddInfo = Undefined) Export
	CurrenciesClientServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters, AddInfo);
EndProcedure
	
&AtClient
Procedure Currencies_AfterWrite(WriteParameters, AddInfo = Undefined) Export
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Currencies_CurrentTableName", GetCurrentTableName(Items.GroupPages.CurrentPage));
	CurrenciesClientServer.AfterWrite(Object, ThisObject, WriteParameters, AddInfo);
EndProcedure

&AtClient
Procedure Currencies_MainTableBeforeDeleteRow(Item, AddInfo = Undefined) Export
	CurrenciesClientServer.MainTableBeforeDeleteRow(Object, ThisObject, Item, AddInfo);
EndProcedure

&AtClient
Procedure Currencies_MainTableOnActivateRow(Item, AddInfo = Undefined) Export
	CurrenciesClientServer.MainTableOnActivateRow(Object, ThisObject, Item, AddInfo);
EndProcedure

&AtClient
Procedure Currencies_MainTableColumnOnChange(Item, AddInfo = Undefined) Export
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Currencies_CurrentTableName", Item.Parent.Name);
	CurrenciesClientServer.MainTableColumnOnChange(Object, ThisObject, Item, AddInfo);
EndProcedure

&AtClient
Procedure Currencies_MainTableAmountOnChange(Item, AddInfo = Undefined) Export
	CurrenciesClientServer.MainTableAmountOnChange(Object, ThisObject, Item, AddInfo);
EndProcedure

&AtClient
Procedure Currencies_HeaderOnChange(Item, AddInfo = Undefined) Export
	ArrayOfTableNames = New Array();
	ArrayOfTableNames.Add("AccountBalance");
	ArrayOfTableNames.Add("AdvanceFromCustomers");
	ArrayOfTableNames.Add("AdvanceToSuppliers");
	ArrayOfTableNames.Add("AccountPayableByAgreements");
	ArrayOfTableNames.Add("AccountPayableByDocuments");
	ArrayOfTableNames.Add("AccountReceivableByAgreements");
	ArrayOfTableNames.Add("AccountReceivableByDocuments");
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Currencies_ArrayOfTableNames", ArrayOfTableNames);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Currencies_CurrentTableName", GetCurrentTableName(Items.GroupPages.CurrentPage));
	
	CurrenciesClientServer.HeaderOnChange(Object, ThisObject, Item, AddInfo);
EndProcedure

#EndRegion

#EndRegion

#Region Currencies_TableCurrencies_Events

&AtClient
Procedure CurrenciesSelection(Item, RowSelected, Field, StandardProcessing)
	CurrenciesClient.CurrenciesTable_Selection(Object, ThisObject, Item, RowSelected, Field, StandardProcessing);
EndProcedure

&AtClient
Procedure CurrenciesBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure CurrenciesBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure CurrenciesRatePresentationOnChange(Item)
	CurrenciesClient.CurrenciesTable_RatePresentationOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CurrenciesMultiplicityOnChange(Item)
	CurrenciesClient.CurrenciesTable_MultiplicityOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CurrenciesAmountOnChange(Item)
	CurrenciesClient.CurrenciesTable_AmountOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region Currencies_Server_API

&AtServer
Procedure Currencies_SetVisibleCurrenciesRow(RowKey, IgnoreRowKey = False) Export
	CurrenciesServer.SetVisibleCurrenciesRow(Object, RowKey, IgnoreRowKey);
EndProcedure

&AtServer
Procedure Currencies_ClearCurrenciesTable(RowKey = Undefined) Export
	CurrenciesServer.ClearCurrenciesTable(Object, RowKey);
EndProcedure

&AtServer
Procedure Currencies_FillCurrencyTable(RowKey, Currency, AgreementInfo) Export
	CurrenciesServer.FillCurrencyTable(Object, 
	                                   Object.Date, 
	                                   Object.Company, 
	                                   Currency, 
	                                   RowKey,
	                                   AgreementInfo);
EndProcedure

&AtServer
Procedure Currencies_UpdateRatePresentation() Export
	CurrenciesServer.UpdateRatePresentation(Object);
EndProcedure

&AtServer
Procedure Currencies_CalculateAmount(Amount, RowKey) Export
	CurrenciesServer.CalculateAmount(Object, Amount, RowKey);
EndProcedure

&AtServer
Procedure Currencies_CalculateRate(Amount, MovementType, RowKey) Export
	CurrenciesServer.CalculateRate(Object, Amount, MovementType, RowKey);
EndProcedure

#EndRegion

#EndRegion

#Region AddAttributes

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject, "GroupOther");
EndProcedure

#EndRegion

#Region InventoryItemsEvents

&AtClient
Procedure InventoryItemOnChange(Item, AddInfo = Undefined) Export
	DocOpeningEntryClient.InventoryItemOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure InventoryItemKeyOnChange(Item, AddInfo = Undefined) Export
	DocOpeningEntryClient.InventoryItemKeyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure InventoryOnStartEdit(Item, NewRow, Clone)
	UserSettingsClient.TableOnStartEdit(Object, ThisObject, "Object.Inventory", Item, NewRow, Clone);
EndProcedure

#EndRegion
