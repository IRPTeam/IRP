#Region FormEvents

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters, AddInfo = Undefined) Export
	DocCreditDebitNoteServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetBasisDocumentReadOnly(CurrentObject, ThisObject);
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocCreditDebitNoteServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	SetBasisDocumentReadOnly(CurrentObject, ThisObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LibraryLoader.RegisterLibrary(Object, ThisObject, Currencies_GetDeclaration(Object, ThisObject));	
	DocCreditDebitNoteServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	If Parameters.Key.IsEmpty() Then
		SetBasisDocumentReadOnly(Object, ThisObject);
	EndIf;
EndProcedure

&AtClient
Procedure OnOpen(Cancel, AddInfo = Undefined) Export
	DocCreditDebitNoteClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtClientAtServerNoContext
Procedure SetBasisDocumentReadOnly(Object, Form, CurrentData = Undefined)
	If CurrentData <> Undefined Then
		If ValueIsFilled(CurrentData.Agreement) Then
			CurrentData.BasisDocumentReadOnly = IsBasisDocumentReadOnly(CurrentData.Agreement);
		Else
			CurrentData.BasisDocumentReadOnly = False;
		EndIf;  
	Else
		For Each Row In Form.Object.Transactions Do
			If ValueIsFilled(Row.Agreement) Then
				Row.BasisDocumentReadOnly = IsBasisDocumentReadOnly(Row.Agreement);
			Else
				Row.BasisDocumentReadOnly = False;
			EndIf;	
		EndDo;
	EndIf;
EndProcedure

&AtServerNoContext
Function IsBasisDocumentReadOnly(Agreement)
	Return ServiceSystemServer.GetCompositeObjectAttribute(Agreement, "ApArPostingDetail") <>
		PredefinedValue("Enum.ApArPostingDetail.ByDocuments");
EndFunction

#EndRegion

#Region _Date

&AtClient
Procedure DateOnChange(Item, AddInfo = Undefined) Export
	DocCreditDebitNoteClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region Company

&AtClient
Procedure CompanyOnChange(Item, AddInfo = Undefined) Export
	DocCreditDebitNoteClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocCreditDebitNoteClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocCreditDebitNoteClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region Partner

&AtClient
Procedure TransactionsPartnerOnChange(Item, AddInfo = Undefined) Export
	DocCreditDebitNoteClient.TransactionsPartnerOnChange(Object, ThisObject, Item);
	CurrentData = Items.Transactions.CurrentData;
	If CurrentData <> Undefined Then
		SetBasisDocumentReadOnly(Object, ThisObject, CurrentData);
	EndIf;
EndProcedure

&AtClient
Procedure TransactionsPartnerStartChoice(Item, ChoiceData, StandardProcessing)
	DocCreditDebitNoteClient.TransactionsPartnerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure TransactionsPartnerEditTextChange(Item, Text, StandardProcessing)
	DocCreditDebitNoteClient.TransactionsPartnerEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region Agreement

&AtClient
Procedure TransactionsAgreementOnChange(Item, AddInfo = Undefined) Export
	DocCreditDebitNoteClient.TransactionsAgreementOnChange(Object, ThisObject, Item);
	CurrentData = Items.Transactions.CurrentData;
	If CurrentData <> Undefined Then
		SetBasisDocumentReadOnly(Object, ThisObject, CurrentData);
	EndIf;
EndProcedure

&AtClient
Procedure TransactionsAgreementStartChoice(Item, ChoiceData, StandardProcessing)
	DocCreditDebitNoteClient.TransactionsAgreementStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure TransactionsAgreementEditTextChange(Item, Text, StandardProcessing)
	DocCreditDebitNoteClient.TransactionsAgreementTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region LegalName

&AtClient
Procedure TransactionsLegalNameOnChange(Item, AddInfo = Undefined) Export
	DocCreditDebitNoteClient.TransactionsLegalNameOnChange(Object, ThisObject, Item);
	CurrentData = Items.Transactions.CurrentData;
	If CurrentData <> Undefined Then
		SetBasisDocumentReadOnly(Object, ThisObject, CurrentData);
	EndIf;
EndProcedure

&AtClient
Procedure TransactionsLegalNameStartChoice(Item, ChoiceData, StandardProcessing)
	DocCreditDebitNoteClient.TransactionsLegalNameStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure TransactionsLegalNameEditTextChange(Item, Text, StandardProcessing)
	DocCreditDebitNoteClient.TransactionsLegalNameEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region BasisDocument

&AtClient
Procedure TransactionsBasisDocumentStartChoice(Item, ChoiceData, StandardProcessing)
	DocCreditDebitNoteClient.TransactionsBasisDocumentStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

#EndRegion

#Region Transaction

&AtClient
Procedure TransactionsOnStartEdit(Item, NewRow, Clone)
	UserSettingsClient.TableOnStartEdit(Object, ThisObject, "Object.Transactions", Item, NewRow, Clone);
EndProcedure

&AtClient
Procedure TransactionsOnChange(Item)
	For Each Row In Object.Transactions Do
		If Not ValueIsFilled(Row.Key) Then
			Row.Key = New UUID();
		EndIf;
	EndDo;
EndProcedure

#EndRegion

#Region ItemDescription

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	DocCreditDebitNoteClient.DescriptionClick(Object, ThisObject, Item, StandardProcessing);
EndProcedure

#EndRegion

#Region GroupTitleDecorations

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocCreditDebitNoteClient.DecorationGroupTitleCollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLabelClick(Item)
	DocCreditDebitNoteClient.DecorationGroupTitleCollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocCreditDebitNoteClient.DecorationGroupTitleUncollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLabelClick(Item)
	DocCreditDebitNoteClient.DecorationGroupTitleUncollapsedLabelClick(Object, ThisObject, Item);
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
	ArrayOfItems_MainTable.Add(Form.Items.Transactions);
	LibraryLoader.AddActionHandler(Declaration, "Currencies_MainTableBeforeDeleteRow", "BeforeDeleteRow", ArrayOfItems_MainTable);
	LibraryLoader.AddActionHandler(Declaration, "Currencies_MainTableOnActivateRow", "OnActivateRow", ArrayOfItems_MainTable);
	
	ArrayOfItems_MainTableColumns = New Array();
	ArrayOfItems_MainTableColumns.Add(Form.Items.TransactionsBasisDocument);
	ArrayOfItems_MainTableColumns.Add(Form.Items.TransactionsPartner);
	ArrayOfItems_MainTableColumns.Add(Form.Items.TransactionsAgreement);
	ArrayOfItems_MainTableColumns.Add(Form.Items.TransactionsCurrency);
	LibraryLoader.AddActionHandler(Declaration, "Currencies_MainTableColumnOnChange", "OnChange", ArrayOfItems_MainTableColumns);
	
	ArrayOfItems_MainTableAmount = New Array();
	ArrayOfItems_MainTableAmount.Add(Form.Items.TransactionsAmount);
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
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Currencies_CurrentTableName", "Transactions");
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
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Currencies_CurrentTableName", "Transactions");
	CurrenciesClientServer.MainTableColumnOnChange(Object, ThisObject, Item, AddInfo);
EndProcedure

&AtClient
Procedure Currencies_MainTableAmountOnChange(Item, AddInfo = Undefined) Export
	CurrenciesClientServer.MainTableAmountOnChange(Object, ThisObject, Item, AddInfo);
EndProcedure

&AtClient
Procedure Currencies_HeaderOnChange(Item, AddInfo = Undefined) Export
	ArrayOfTableNames = New Array();
	ArrayOfTableNames.Add("Transactions");
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Currencies_ArrayOfTableNames", ArrayOfTableNames);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Currencies_CurrentTableName", "Transactions");
	
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

#Region ExternalCommands

&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	ExternalCommandsClient.GeneratedFormCommandActionByName(Object, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name);	
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName) Export
	ExternalCommandsServer.GeneratedFormCommandActionByName(Object, ThisObject, CommandName);
EndProcedure

#EndRegion

