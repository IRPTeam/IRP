#Region FormEvents

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControll();
	EndIf;
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LibraryLoader.RegisterLibrary(Object, ThisObject, Currencies_GetDeclaration(Object, ThisObject));
	
	DocChequeBondTransactionServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
EndProcedure

&AtClient
Procedure OnOpen(Cancel, AddInfo = Undefined) Export
	DocChequeBondTransactionClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)
	DocChequeBondTransactionServer.OnWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure


&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocChequeBondTransactionServer.OnReadAtServer(Object, ThisObject, CurrentObject);
EndProcedure

#EndRegion

#Region ItemsEvents

&AtClient
Procedure CurrencyOnChange(Item, AddInfo = Undefined) Export
	DocChequeBondTransactionClient.CurrencyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyOnChange(Item, AddInfo = Undefined) Export
	DocChequeBondTransactionClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ChequeBondsOnActivateRow(Item, AddInfo = Undefined) Export
	DocChequeBondTransactionClient.ChequeBondsOnActivateRow(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ChequeBondsOnStartEdit(Item, NewRow, Clone)
	If Clone Then
		Item.CurrentData.Key = New UUID();
	EndIf;
EndProcedure

&AtClient
Procedure ChequeBondsBeforeRowChange(Item, Cancel)
	DocChequeBondTransactionClient.CheckCashAccountStart(Object, ThisObject, Item, Cancel);
EndProcedure

&AtClient
Procedure ChequeBondsOnActivateCell(Item)
	DocChequeBondTransactionClient.CheckCashAccountStart(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ChequeBondsChequeStartChoice(Item, ChoiceData, StandardProcessing)
	DocChequeBondTransactionClient.ChequeBondsChequeStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ChequeBondsChequeEditTextChange(Item, Text, StandardProcessing)
	DocChequeBondTransactionClient.ChequeBondsChequeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region Commands
&AtClient
Procedure FillCheques(Command)
	DocChequeBondTransactionClient.FillCheques(ThisObject, Object);
EndProcedure

&AtClient
Procedure ChequeBondsNewStatusOnChange(Item)
	DocChequeBondTransactionClient.ChequeBondsNewStatusOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ChequeBondsBeforeDeleteRow(Item, Cancel, AddInfo = Undefined) Export
	DocChequeBondTransactionClient.ChequeBondsBeforeDeleteRow(Object, ThisObject, Item, Cancel);
EndProcedure

&AtClient
Procedure FillDocuments(Command)
	DocChequeBondTransactionClient.FillDocuments(ThisObject, Object);
EndProcedure

#EndRegion

#Region Status

&AtClient
Procedure ChequeBondsStatusEditTextChange(Item, Text, StandardProcessing)
	If Not ValueIsFilled(Text) Then
		StandardProcessing = False;
		Return;
	EndIf;
	
	CurrentData = ThisObject.Items.ChequeBonds.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	ArrayOfFilters = New Array();
	
	AdditionalParameters = New Structure();
	AdditionalParameters.Insert("Filter_RefInList", True);
	AdditionalParameters.Insert("RefList",
		ObjectStatusesClient.GetAvailableStatusesByCheque(Object.Ref, CurrentData.Cheque));
	
	ArrayOfFilteredStatusRefs
	= ObjectStatusesServer.GetObjectStatusesChoiseDataTable(Text, ArrayOfFilters, AdditionalParameters);
	If Not ArrayOfFilteredStatusRefs.Count() Then
		StandardProcessing = False;
		Return;
	EndIf;
	
	ObjectStatusesClient.StatusEditTextChange(ThisObject
		, Object
		, ArrayOfFilters
		, AdditionalParameters
		, Item
		, Text
		, StandardProcessing);
EndProcedure

&AtClient
Procedure ChequeBondsStatusTextEditEnd(Item, Text, ChoiceData, DataGetParameters, StandardProcessing)
	StandardProcessing = False;
EndProcedure

&AtClient
Procedure ChequeBondsStatusStartChoice(Item, ChoiceData, StandardProcessing)
	StandardProcessing = False;
	CurrentData = ThisObject.Items.ChequeBonds.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	ChoiceData = New ValueList();
	For Each StatusRef In ObjectStatusesClient.GetAvailableStatusesByCheque(Object.Ref, CurrentData.Cheque) Do
		ChoiceData.Add(StatusRef, String(StatusRef));
	EndDo;
EndProcedure 

&AtClient
Procedure ChequeBondsChequeOnChange(Item, AddInfo = Undefined) Export
	DocChequeBondTransactionClient.ChequeBondsChequeOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

&AtClient
Procedure ChequeBondsOnChange(Item)
	For Each Row In Object.ChequeBonds Do
		If Not ValueIsFilled(Row.Key) Then
			Row.Key = New UUID();
		EndIf;
	EndDo;
EndProcedure

&AtClient
Procedure PaymentListSelection(Item, RowSelected, Field, StandardProcessing)
	DocChequeBondTransactionClient.ShowApArDocument(ThisObject, Item, RowSelected, Field, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	If Clone Then
		Return;
	EndIf;
	Cancel = True;
	CurrentChequeBondsRow = ThisObject.Items.ChequeBonds.CurrentData;
	If CurrentChequeBondsRow <> Undefined Then
		NewRow = Object.PaymentList.Add();
		NewRow.Key = CurrentChequeBondsRow.Key;
	EndIf;
EndProcedure

&AtClient
Procedure PaymentListOnStartEdit(Item, NewRow, Clone)
	DocChequeBondTransactionClient.PaymentListOnStartEdit(Object, ThisObject, Item, NewRow, Clone);
EndProcedure

#Region Company

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocumentsClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocSalesOrderClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region Partner

&AtClient
Procedure ChequeBondsPartnerOnChange(Item, AddInfo = Undefined) Export
	DocChequeBondTransactionClient.TablePartnerOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ChequeBondsPartnerStartChoice(Item, ChoiceData, StandardProcessing)
	DocChequeBondTransactionClient.TablePartnerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ChequeBondsPartnerEditTextChange(Item, Text, StandardProcessing)
	DocChequeBondTransactionClient.TablePartnerTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region Agreement

&AtClient
Procedure ChequeBondsAgreementOnChange(Item, AddInfo = Undefined) Export
	DocChequeBondTransactionClient.TableAgreementOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ChequeBondsAgreementStartChoice(Item, ChoiceData, StandardProcessing)
	DocChequeBondTransactionClient.TableAgreementStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ChequeBondsCashAccountStartChoice(Item, ChoiceData, StandardProcessing)
	DocChequeBondTransactionClient.AccountStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ChequeBondsCashAccountEditTextChange(Item, Text, StandardProcessing)
	DocChequeBondTransactionClient.AccountEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure



&AtClient
Procedure ChequeBondsAgreementEditTextChange(Item, Text, StandardProcessing)
	DocChequeBondTransactionClient.TableAgreementTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region LegalName

&AtClient
Procedure ChequeBondsLegalNameOnChange(Item)
	DocChequeBondTransactionClient.TableChequeBondsLegalNameOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ChequeBondsLegalNameStartChoice(Item, ChoiceData, StandardProcessing)
	DocChequeBondTransactionClient.TableChequeBondsLegalNameStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ChequeBondsLegalNameEditTextChange(Item, Text, StandardProcessing)
	DocChequeBondTransactionClient.TableChequeBondsLegalNameTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

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
	ArrayOfItems_MainTable.Add(Form.Items.ChequeBonds);
	LibraryLoader.AddActionHandler(Declaration, "Currencies_MainTableBeforeDeleteRow", "BeforeDeleteRow", ArrayOfItems_MainTable);
	LibraryLoader.AddActionHandler(Declaration, "Currencies_MainTableOnActivateRow", "OnActivateRow", ArrayOfItems_MainTable);
	
	ArrayOfItems_MainTableColumns = New Array();
	ArrayOfItems_MainTableColumns.Add(Form.Items.ChequeBondsCheque);
	ArrayOfItems_MainTableColumns.Add(Form.Items.ChequeBondsPartner);
	ArrayOfItems_MainTableColumns.Add(Form.Items.ChequeBondsAgreement);
	LibraryLoader.AddActionHandler(Declaration, "Currencies_MainTableColumnOnChange", "OnChange", ArrayOfItems_MainTableColumns);
	
	ArrayOfItems_MainTableAmount = New Array();
	ArrayOfItems_MainTableAmount.Add(Form.Items.ChequeBondsAmount);
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
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Currencies_CurrentTableName", "ChequeBonds");
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
	ArrayOfTableNames.Add("ChequeBonds");
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Currencies_ArrayOfTableNames", ArrayOfTableNames);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Currencies_CurrentTableName", "ChequeBonds");
	
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
	CurrenciesServer.FiilCurrencyTable(Object, 
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
Procedure AddAttributesCreateFormControll()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject, "GroupOther");
EndProcedure

#EndRegion
