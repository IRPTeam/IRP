#Region FormEvents

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters, AddInfo = Undefined) Export
	DocCreditDebitNoteServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocCreditDebitNoteServer.OnReadAtServer(Object, ThisObject, CurrentObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocCreditDebitNoteServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
EndProcedure

&AtClient
Procedure OnOpen(Cancel, AddInfo = Undefined) Export
	DocCreditDebitNoteClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtClient
Procedure AfterWrite(WriteParameters)
	DocCreditDebitNoteClient.AfterWriteAtClient(Object, ThisObject, WriteParameters);
EndProcedure

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

#Region Currency

&AtClient
Procedure TransactionsCurrencyOnChange(Item)
	DocCreditDebitNoteClient.TransactionsCurrencyOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region Amount

&AtClient
Procedure TransactionsAmountOnChange(Item)
	DocCreditDebitNoteClient.TransactionsAmountOnChange(Object, ThisObject, Item);
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

&AtClient
Procedure TransactionsBeforeDeleteRow(Item, Cancel)
	DocCreditDebitNoteClient.TransactionsBeforeDeleteRow(Object, ThisObject, Item, Cancel);	
EndProcedure

&AtClient
Procedure TransactionsOnActivateRow(Item)
	DocCreditDebitNoteClient.TransactionsOnActivateRow(Object, ThisObject, Item);
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

&AtClient
Procedure CurrenciesSelection(Item, RowSelected, Field, StandardProcessing, AddInfo = Undefined)
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ExecuteAtClient", True);
	CurrenciesClient.CurrenciesTable_Selection(Object, ThisObject, Item, RowSelected, Field, StandardProcessing, AddInfo);
EndProcedure

&AtClient
Procedure CurrenciesRatePresentationOnChange(Item, AddInfo = Undefined)
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ExecuteAtClient", True);
	CurrenciesClient.CurrenciesTable_RatePresentationOnChange(Object, ThisObject, Item, AddInfo);
EndProcedure

&AtClient
Procedure CurrenciesMultiplicityOnChange(Item, AddInfo = Undefined)
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ExecuteAtClient", True);
	CurrenciesClient.CurrenciesTable_MultiplicityOnChange(Object, ThisObject, Item, AddInfo);
EndProcedure

&AtClient
Procedure CurrenciesAmountOnChange(Item, AddInfo = Undefined)
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ExecuteAtClient", True);
	CurrenciesClient.CurrenciesTable_AmountOnChange(Object, ThisObject, Item, AddInfo);
EndProcedure

&AtClient
Procedure CurrenciesBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure CurrenciesBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

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

