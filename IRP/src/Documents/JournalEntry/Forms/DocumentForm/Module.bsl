
#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocJournalEntryServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocJournalEntryServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	CurrentObject.AdditionalProperties.Insert("WriteOnForm", True);
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	DocJournalEntryServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtClient
Procedure AfterWrite(WriteParameters)
	If ValueIsFilled(Object.Basis) Then
		NotifyChanged(Object.Basis);
	EndIf;
	Notify("AfterWriteJournalEntry");
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocJournalEntryClient.OnOpen(Object, ThisObject, Cancel);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	Form.Items.DecorationSaveDocument.Visible = Not ValueIsFilled(Object.Ref);
	Form.Items.RegularOperations.Visible = Object.UserDefined;
	Form.Items.Errors.Visible = Object.Errors.Count() > 0;
	
	If ValueIsFilled(Object.Basis) Then
		If CommonFunctionsClientServer.ObjectHasProperty(Object.Basis, "Comment") Then
			Form.BasisComment = CommonFunctionsServer.GetRefAttribute(Object.Basis, "Comment");
		EndIf;
	Else
		Form.BasisComment = "";
	EndIf;
	
	IsUseELedger = FOServer.IsUseELedger();
	
	Form.Items.ELedgerRegistry.Visible = IsUseELedger;
	Form.Items.SequentalNumber.Visible = IsUseELedger;
	Form.AccountingEntries.Clear();
	
#IF Client THEN
	ArrayOfRowInfo = New Array();
	For Each Row In Object.RegisterRecords.Basic Do
		RowInfo = New Structure();
		RowInfo.Insert("DrInfo", New Structure());
		RowInfo.Insert("CrInfo", New Structure());
			
		RowInfo.DrInfo.Insert("Account", Row.AccountDr);
		RowInfo.DrInfo.Insert("IsCurrency", False);
		
		RowInfo.CrInfo.Insert("Account", Row.AccountCr);
		RowInfo.CrInfo.Insert("IsCurrency", False);
		
		ArrayOfRowInfo.Add(RowInfo);
	EndDo;
	
	GetRowInfoAtServer(ArrayOfRowInfo);
	
	index = 0;
	For Each Row In ArrayOfRowInfo Do
		RecordRow = Object.RegisterRecords.Basic[index];
		RecordRow.DrIsCurrency = Row.DrInfo.IsCurrency;
		If Not Row.DrInfo.IsCurrency Then
			RecordRow.CurrencyDr = Undefined;
		EndIf;
		
		RecordRow.CrIsCurrency = Row.CrInfo.IsCurrency;
		If Not Row.CrInfo.IsCurrency Then
			RecordRow.CurrencyCr = Undefined;
		EndIf;
		index = index + 1;
	EndDo;
#ENDIF
	
	For Each Row In Object.RegisterRecords.Basic Do
		DrRow = Form.AccountingEntries.Add();
		DrRow.Account = Row.AccountDr;
		Index = 1;
		
#IF Client THEN
		For i=1 To 3 Do
			DrRow["ExtDimension"+Index] = Row["ExtDimensionDr"+Index];
			Index = Index + 1;
		EndDo; 
#ELSE		
		For Each ExtRow In Row.ExtDimensionsDr Do
			DrRow["ExtDimension"+Index] = ExtRow.Value;
			Index = Index + 1;
		EndDo;
#ENDIF
		CrRow = Form.AccountingEntries.Add();
		CrRow.Account = Row.AccountCr;
		Index = 1;
		
#IF Client THEN
		For i=1 To 3 Do
			CrRow["ExtDimension"+Index] = Row["ExtDimensionCr"+Index];
			Index = Index + 1;
		EndDo; 	
#ELSE
		For Each ExtRow In Row.ExtDimensionsCr Do
			CrRow["ExtDimension"+Index] = ExtRow.Value;
			Index = Index + 1;
		EndDo;
#ENDIF
		
		CrRow.AmountCr = Row.Amount;		
		DrRow.AmountDr = Row.Amount;		
	EndDo;
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

&AtServerNoContext
Procedure GetRowInfoAtServer(ArrayOfRowInfo)
	For Each Row In ArrayOfRowInfo Do
		If ValueIsFilled(Row.DrInfo.Account) Then
			Row.DrInfo.IsCurrency = Row.DrInfo.Account.Currency;
		EndIf;
		If ValueIsFilled(Row.CrInfo.Account) Then
			Row.CrInfo.IsCurrency = Row.CrInfo.Account.Currency;
		EndIf;
	EndDo;
EndProcedure

#EndRegion

#Region FormHeaderItemsEventHandlers

#Region ItemDate

&AtClient
Procedure DateOnChange(Item)
	DocJournalEntryClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region ItemCompany

&AtClient
Procedure CompanyOnChange(Item)
	DocJournalEntryClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocJournalEntryClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocJournalEntryClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ItemLedgerType

&AtClient
Procedure LedgerTypeOnChange(Item)
	DocJournalEntryClient.LedgerTypeOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region SwitchRecordsActivity

&AtClient
Procedure SwitchRecordsActivity(Command)
	SwitchRecordsActivityAtServer();
EndProcedure

&AtServer
Procedure SwitchRecordsActivityAtServer()
	If ValueIsFilled(Object.Ref) Then
		RecordSet = AccountingRegisters.Basic.CreateRecordSet();
		RecordSet.Filter.Recorder.Set(Object.Ref);
		RecordSet.Read();
		For Each Record In RecordSet Do
			Record.Active = Not Record.Active;
		EndDo;
		RecordSet.Write();
		Object.RegisterRecords.Basic.Load(RecordSet.Unload());
	EndIf;
EndProcedure

#EndRegion

#Region ItemBasis

&AtClient
Procedure BasisOnChange(Item)
	DocJournalEntryClient.BasisOnChange(Object, ThisObject, Item);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

#EndRegion

&AtClient
Procedure UserDefinedOnChange(Item)
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

#EndRegion
&AtClient
Procedure RegisterRecordsAccountCrOnChange(Item)
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure RegisterRecordsAccountDrOnChange(Item)
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure


&AtClient
Procedure RegisterRecordsOnStartEdit(Item, NewRow, Clone)
	Return;
EndProcedure

#Region GroupTitleDecorations

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

#Region DescriptionEvents

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	CommonFormActions.EditMultilineText(ThisObject, Item, StandardProcessing);
EndProcedure

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

&AtClient
Procedure AddAttributeButtonClick(Item) Export
	AddAttributesAndPropertiesClient.AddAttributeButtonClick(ThisObject, Item);
EndProcedure

#EndRegion

#Region COMMANDS

&AtClient
Procedure InternalCommandAction(Command) Export
	InternalCommandsClient.RunCommandAction(Command, ThisObject, Object, Object.Ref);
EndProcedure

&AtClient
Procedure InternalCommandActionWithServerContext(Command) Export
	InternalCommandActionWithServerContextAtServer(Command.Name);
EndProcedure

&AtServer
Procedure InternalCommandActionWithServerContextAtServer(CommandName)
	InternalCommandsServer.RunCommandAction(CommandName, ThisObject, Object, Object.Ref);
EndProcedure

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

#Region Service

&AtClient
Function GetProcessingModule() Export
	Str = New Structure;
	Str.Insert("Client", DocJournalEntryClient);
	Str.Insert("Server", DocJournalEntryServer);
	Return Str;
EndFunction

&AtClient
Procedure ProfitLostOffset(Command)
	If Not CheckFilling() Then
		Return;
	EndIf;
	ProfitLostOffsetAtServer();
	Write();
EndProcedure

&AtServer
Procedure ProfitLostOffsetAtServer()
	Object.RegisterRecords.Basic.Clear();
	
	RegisterRecords = AccountingRegisters.Basic.CreateRecordSet();
	RegisterRecords.Filter.Recorder.Set(Object.Ref);
	RegisterRecords.Write();
		
	DataTable = Catalogs.LedgerTypes.ProfitLostOffset(Object.Company, 
		Object.LedgerType, 
		Object.Ref, 
		Object.Date, 
		Object.DeletionMark,
		RegisterRecords);
	
	Object.RegisterRecords.Basic.Clear();
	
	AccountingServer.SetDataRegisterRecords(DataTable, Object.LedgerType, Object.RegisterRecords.Basic);
	For Each Record In Object.RegisterRecords.Basic Do
		Record.Active = Not Object.DeletionMark;
	EndDo;
EndProcedure

&AtClient
Procedure SetNewNumber(Command)
	SetNewNumberAtServer();
EndProcedure

&AtServer
Procedure SetNewNumberAtServer()
	If Object.NumeratorRules.IsEmpty() Then
		Object.NumeratorRules = 
			NumberingRulesServer.GetNumeratorGroupForDocument(Object.Ref.Metadata().FullName(), Object.Date);
	EndIf;
	NumberingRulesServer.SetSourceNewNumber(Object);
EndProcedure

#EndRegion
