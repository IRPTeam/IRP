
#Region FORM

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocDebitCreditNoteServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocDebitCreditNoteServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters) Export
	DocDebitCreditNoteServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel) Export
	DocDebitCreditNoteClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source) Export
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

&AtClient
Procedure FormSetVisibilityAvailability() Export
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	IsOffsetOfAdvances = (Object.TransactionType = PredefinedValue("Enum.DebitCreditNoteTransactionTpes.OffsetOfAdvances"));
	IsDebitCreditNote = (Object.TransactionType = PredefinedValue("Enum.DebitCreditNoteTransactionTpes.DebitCreditNote"));
	SetVisibleByTransactionType(Object, Form, IsOffsetOfAdvances, IsDebitCreditNote);
	
	Form.Items.LegalName.Enabled        = ValueIsFilled(Object.Partner);
	Form.Items.SendLegalName.Enabled    = ValueIsFilled(Object.SendPartner);
	Form.Items.ReceiveLegalName.Enabled = ValueIsFilled(Object.ReceivePartner);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibleByTransactionType(Object, Form, IsOffsetOfAdvances, IsDebitCreditNote)
	
	Elements_OffsetOfAdvances = New Array();
	Elements_OffsetOfAdvances.Add("Partner");
	Elements_OffsetOfAdvances.Add("LegalName");
	Elements_OffsetOfAdvances.Add("Agreement");
	Elements_OffsetOfAdvances.Add("LegalNameContract");
	Elements_OffsetOfAdvances.Add("OffsetOfAdvancesInvoices");
	Elements_OffsetOfAdvances.Add("OffsetOfAdvancesPayments");
	Elements_OffsetOfAdvances.Add("Branch");

	Elements_DebitCreditNote = New Array();
	Elements_DebitCreditNote.Add("SendPartner");
	Elements_DebitCreditNote.Add("SendAgreement");
	Elements_DebitCreditNote.Add("SendLegalName");
	Elements_DebitCreditNote.Add("SendLegalNameContract");
	Elements_DebitCreditNote.Add("SendBranch");
	Elements_DebitCreditNote.Add("SendDocuments");
	Elements_DebitCreditNote.Add("ReceivePartner");
	Elements_DebitCreditNote.Add("ReceiveAgreement");
	Elements_DebitCreditNote.Add("ReceiveLegalName");
	Elements_DebitCreditNote.Add("ReceiveLegalNameContract");
	Elements_DebitCreditNote.Add("ReceiveBranch");
	Elements_DebitCreditNote.Add("ReceiveDocuments");

	If IsOffsetOfAdvances Then
		For Each Item In Elements_DebitCreditNote Do
			Form.Items[Item].Visible = False;
		EndDo;
		For Each Item In Elements_OffsetOfAdvances Do
			Form.Items[Item].Visible = True;
		EndDo;
	Else
		For Each Item In Elements_OffsetOfAdvances Do
			Form.Items[Item].Visible = False;
		EndDo;
		For Each Item In Elements_DebitCreditNote Do
			Form.Items[Item].Visible = True;
		EndDo;
	EndIf;
EndProcedure

&AtClient
Procedure SetVisibleRows_OffsetOfAdvancesPayments(ActivateRow = True)
	CurrentData = Items.OffsetOfAdvancesInvoices.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	For Each Row In Object.OffsetOfAdvancesPayments Do
		Row.IsVisible = Row.KeyOwner = CurrentData.Key;
	EndDo;
	If ActivateRow Then
		VisibleRows = Object.OffsetOfAdvancesPayments.FindRows(New Structure("IsVisible", True));
		If VisibleRows.Count() Then
			Items.OffsetOfAdvancesPayments.CurrentRow = VisibleRows[0].GetID();
		EndIf;
	EndIf;
EndProcedure

&AtClient
Procedure _IdeHandler()
	ViewClient_V2.ViewIdleHandler(ThisObject, Object);
EndProcedure

&AtClient
Procedure _AttachIdleHandler() Export
	AttachIdleHandler("_IdeHandler", 1);
EndProcedure

&AtClient 
Procedure _DetachIdleHandler() Export
	DetachIdleHandler("_IdeHandler");
EndProcedure

#EndRegion

#Region COMPANY

&AtClient
Procedure CompanyOnChange(Item) Export
	DocDebitCreditNoteClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocDebitCreditNoteClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocDebitCreditNoteClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region _DATE

&AtClient
Procedure DateOnChange(Item) Export
	DocDebitCreditNoteClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region CURRENCY

&AtClient
Procedure CurrencyOnChange(Item)
	DocDebitCreditNoteClient.CurrencyOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region TRANSACTION_TYPE

&AtClient
Procedure TransactionTypeOnChange(Item)
	DocDebitCreditNoteClient.TransactionTypeOnChange(Object, ThisObject, Item);	
EndProcedure

&AtClient
Procedure OffsetOfAdvancesInvoicesInvoiceStartChoice(Item, ChoiceData, StandardProcessing)
	DocDebitCreditNoteClient.OffsetOfAdvancesInvoicesInvoiceStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure OffsetOfAdvancesInvoicesInvoiceOnChange(Item)
	DocDebitCreditNoteClient.OffsetOfAdvancesInvoicesInvoiceOnChange(Object, ThisObject, Item);
EndProcedure



#EndRegion

#Region PARTNER

&AtClient
Procedure PartnerOnChange(Item)
	DocDebitCreditNoteClient.PartnerOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PartnerStartChoice(Item, ChoiceData, StandardProcessing)
	DocDebitCreditNoteClient.PartnerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PartnerEditTextChange(Item, Text, StandardProcessing)
	DocDebitCreditNoteClient.PartnerEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region LEGAL_NAME

&AtClient
Procedure LegalNameOnChange(Item)
	DocDebitCreditNoteClient.LegalNameOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure LegalNameStartChoice(Item, ChoiceData, StandardProcessing)
	DocDebitCreditNoteClient.LegalNameStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure LegalNameEditTextChange(Item, Text, StandardProcessing)
	DocDebitCreditNoteClient.LegalNameEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region AGREMENT

&AtClient
Procedure AgreementOnChange(Item)
	DocDebitCreditNoteClient.AgreementOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure AgreementStartChoice(Item, ChoiceData, StandardProcessing)
	DocDebitCreditNoteClient.AgreementStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure AgreementEditTextChange(Item, Text, StandardProcessing)
	DocDebitCreditNoteClient.AgreementEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region OFFSET_OF_ADVANCES_INVOICES

&AtClient
Procedure OffsetOfAdvancesInvoicesAfterDeleteRow(Item)
	DocDebitCreditNoteClient.OffsetOfAdvancesInvoicesAfterDeleteRow(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure OffsetOfAdvancesInvoicesBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocDebitCreditNoteClient.OffsetOfAdvancesInvoicesBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure OffsetOfAdvancesInvoicesBeforeDeleteRow(Item, Cancel)
	DocDebitCreditNoteClient.OffsetOfAdvancesInvoicesBeforeDeleteRow(Object, ThisObject, Item, Cancel);
EndProcedure

&AtClient
Procedure OffsetOfAdvancesInvoicesSelection(Item, RowSelected, Field, StandardProcessing)
	DocDebitCreditNoteClient.OffsetOfAdvancesInvoicesSelection(Object, ThisObject, Item, RowSelected, Field, StandardProcessing);
EndProcedure

&AtClient
Procedure OffsetOfAdvancesInvoicesOnActivateRow(Item)
	SetVisibleRows_OffsetOfAdvancesPayments();
EndProcedure

#EndRegion

#Region OFFSET_OF_ADVANCES_PAYMENTS

&AtClient
Procedure OffsetOfAdvancesPaymentsBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocDebitCreditNoteClient.OffsetOfAdvancesPaymentsBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
	SetVisibleRows_OffsetOfAdvancesPayments(False);
EndProcedure

#EndRegion

#Region SEND_PARTNER

&AtClient
Procedure SendPartnerOnChange(Item)
	DocDebitCreditNoteClient.SendPartnerOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure SendPartnerStartChoice(Item, ChoiceData, StandardProcessing)
	DocDebitCreditNoteClient.SendPartnerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure SendPartnerEditTextChange(Item, Text, StandardProcessing)
	DocDebitCreditNoteClient.SendPartnerEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region SEND_AGREEMENT

&AtClient
Procedure SendAgreementOnChange(Item)
	DocDebitCreditNoteClient.SendAgreementOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure SendAgreementStartChoice(Item, ChoiceData, StandardProcessing)
	DocDebitCreditNoteClient.SendAgreementStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure SendAgreementEditTextChange(Item, Text, StandardProcessing)
	DocDebitCreditNoteClient.SendAgreementEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region SEND_LEGAL_NAME

&AtClient
Procedure SendLegalNameOnChange(Item)
	DocDebitCreditNoteClient.SendLegalNameOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure SendLegalNameStartChoice(Item, ChoiceData, StandardProcessing)
	DocDebitCreditNoteClient.SendLegalNameStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure SendLegalNameEditTextChange(Item, Text, StandardProcessing)
	DocDebitCreditNoteClient.SendLegalNameEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region SEND_DOCUMENTS

&AtClient
Procedure SendDocumentsAfterDeleteRow(Item)
	DocDebitCreditNoteClient.SendDocumentsAfterDeleteRow(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure SendDocumentsBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocDebitCreditNoteClient.SendDocumentsBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure SendDocumentsSelection(Item, RowSelected, Field, StandardProcessing)
	DocDebitCreditNoteClient.SendDocumentsSelection(Object, ThisObject, Item, RowSelected, Field, StandardProcessing);
EndProcedure

#EndRegion

#Region RECEIVE_PARTNER

&AtClient
Procedure ReceivePartnerOnChange(Item)
	DocDebitCreditNoteClient.ReceivePartnerOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ReceivePartnerStartChoice(Item, ChoiceData, StandardProcessing)
	DocDebitCreditNoteClient.ReceivePartnerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ReceivePartnerEditTextChange(Item, Text, StandardProcessing)
	DocDebitCreditNoteClient.ReceivePartnerEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region RECEIVE_AGREEMENT

&AtClient
Procedure ReceiveAgreementOnChange(Item)
	DocDebitCreditNoteClient.ReceiveAgreementOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ReceiveAgreementStartChoice(Item, ChoiceData, StandardProcessing)
	DocDebitCreditNoteClient.ReceiveAgreementStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ReceiveAgreementEditTextChange(Item, Text, StandardProcessing)
	DocDebitCreditNoteClient.ReceiveAgreementEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region RECEIVE_LEGAL_NAME

&AtClient
Procedure ReceiveLegalNameOnChange(Item)
	DocDebitCreditNoteClient.ReceiveLegalNameOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ReceiveLegalNameStartChoice(Item, ChoiceData, StandardProcessing)
	DocDebitCreditNoteClient.ReceivePartnerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ReceiveLegalNameEditTextChange(Item, Text, StandardProcessing)
	DocDebitCreditNoteClient.ReceiveLegalNameEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region RECEIVE_DOCUMENTS

&AtClient
Procedure ReceiveDocumentsAfterDeleteRow(Item)
	DocDebitCreditNoteClient.ReceiveDocumentsAfterDeleteRow(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ReceiveDocumentsBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocDebitCreditNoteClient.ReceiveDocumentsBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure ReceiveDocumentsSelection(Item, RowSelected, Field, StandardProcessing)
	DocDebitCreditNoteClient.ReceiveDocumentsSelection(Object, ThisObject, Item, RowSelected, Field, StandardProcessing);
EndProcedure

#EndRegion

#Region SERVICE

#Region DESCRIPTION

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	CommonFormActions.EditMultilineText(ThisObject, Item, StandardProcessing);
EndProcedure

#EndRegion

#Region TITLE_DECORATIONS

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, True);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLabelClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, True);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, False);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLabelClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, False);
EndProcedure

#EndRegion

#Region ADD_ATTRIBUTES

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject, "GroupOther");
EndProcedure

&AtClient
Procedure AddAttributeButtonClick(Item) Export
	AddAttributesAndPropertiesClient.AddAttributeButtonClick(ThisObject, Item);
EndProcedure

#EndRegion

#Region EXTERNAL_COMMANDS

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

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure

&AtClient
Procedure ShowHiddenTables(Command)
	DocumentsClient.ShowHiddenTables(Object, ThisObject);
EndProcedure

#EndRegion

ThisObject.TabularSections = "SendDocuments, ReceiveDocuments, OffsetOfAdvancesInvoices, OffsetOfAdvancesPayments";
