
&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocExternalAccountingOperationServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocExternalAccountingOperationServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
	AccountingServer.BeforeWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
	CurrenciesServer.BeforeWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	DocExternalAccountingOperationServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
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
	Form.Items.EditCurrencies.Enabled = Not Form.ReadOnly;
	Form.Items.EditAccounting.Enabled = Not Form.ReadOnly;
	
	Form.Items.Errors.Visible = Object.Errors.Count() > 0;
EndProcedure

&AtClient
Procedure RecordsSelection(Item, RowSelected, Field, StandardProcessing)
	CurrentData = Items.Records.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	FormParams = GetRowFormParams(CurrentData.Key);
	OpenForm("Document.ExternalAccountingOperation.Form.RowForm", FormParams, ThisObject,,,,,FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtServer
Function GetRowFormParams(RowKey)
	RowData = New Structure();
	Row = Object.Records.FindRows(New Structure("Key", RowKey));
	For Each Column In Metadata.Documents.ExternalAccountingOperation.TabularSections.Records.Attributes Do
		RowData.Insert(Column.Name, Row[0][Column.Name]);
	EndDo;
	Return New Structure("RowData", RowData);
EndFunction

&AtClient
Procedure CopyRecorderURLToClipboard(Command)
	If ValueIsFilled(Object.RecorderURL) Then
		PutTextToClipboard(TrimAll(Object.RecorderURL));
	EndIf;	
EndProcedure

&AtClient
Async Function PutTextToClipboard(Text)
	
    If ClipboardTools.CanUse() Then
        DataFormat = ClipboardDataStandardFormat.Text;
        If Await ClipboardTools.DataFormatSupported(DataFormat) Тогда
            DataForClipboard = New ClipboardItem(DataFormat, Text);
            Return Await ClipboardTools.PutDataAsync(DataForClipboard);
        EndIf;
    EndIf;
	
    Return False;		
EndFunction

&AtClient
Function GetAccountingEntriesFromSourceAtClient()
	
	If IsBlankString(Object.RecorderURL) Then
		CommonFunctionsClientServer.ShowUsersMessage(R().Error_175, "RecorderURL");
		Return Undefined;
	EndIf;	
	If Not Items.SourceRecords.Visible Then
		GetAccountingEntriesFromSourceAtServer();
	EndIf;
	Items.SourceRecords.Visible = Not Items.SourceRecords.Visible;
	Items.RecordsShowAccountingEntriesFromSource.Check = Not Items.RecordsShowAccountingEntriesFromSource.Check;
		  
EndFunction

&AtServer
Procedure GetAccountingEntriesFromSourceAtServer()
	IntegrationSettingsRef = Object.LedgerType.IntegrationSettings;
	
	If Not ValueIsFilled(IntegrationSettingsRef) Then
		CommonFunctionsClientServer.ShowUsersMessage(R().Error_176, "RecorderURL");
		Return;
	EndIf;	
	
	QueryParameters = New Map;
	QueryParameters.Insert("RegisterURL", Object.RecorderURL);
	
	ResponseData = AccountingServer.SendGETRequest(IntegrationSettingsRef, "GetEntriesByRegister", QueryParameters);
	If TypeOf(ResponseData) <> Type("Structure") Then
		Return;
	EndIf;
	
	SourceRecords.Clear();
	SourceRecords.FixedTop = 3;
	SourceRecords.FixedLeft = 1;
	
	Template = Documents.ExternalAccountingOperation.GetTemplate("EntryTemplate");
	AreaHeader = Template.GetArea("Header");
	AreaRow = Template.GetArea("Row");
	
	SourceRecords.Put(AreaHeader);
	For Each Structure In ResponseData.DataArray Do
		AreaRow.Parameters.Fill(Structure);
		SourceRecords.Put(AreaRow);
	EndDo;		
	
EndProcedure

&AtClient
Procedure ErrorsOnActivateRow(Item)
	CurrentRow = Item.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	ErrorText = CurrentRow.Error;
	Pattern = "row-key["; 
	Symbol = StrFind(ErrorText, Pattern);
	If Symbol = 0 Then
		Return
	EndIf;
	RowID = Mid(ErrorText, Symbol + StrLen(Pattern));  
	RowID = Mid(RowID, 1, StrLen(RowID) -1);
	
	SearchArray = Object.Records.FindRows(New Structure("Key", RowID));
	If SearchArray.Count() = 0 Then
		Return;
	EndIf;
	
	Row = SearchArray[0];
	Items.Records.CurrentRow = Row.GetID();
EndProcedure

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
Procedure EditCurrencies(Command)
	CurrentData = ThisObject.Items.Records.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	FormParameters = CurrenciesClientServer.GetParameters_V6(Object, CurrentData);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form"  , ThisObject);
	Notify = New NotifyDescription("EditCurrenciesContinue", CurrenciesClient, NotifyParameters);
	OpenForm("CommonForm.EditCurrencies", FormParameters, , , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure

&AtClient
Procedure ShowHiddenTables(Command)
	DocumentsClient.ShowHiddenTables(Object, ThisObject);
EndProcedure

&AtClient
Procedure ShowUUID(Command)
	FormParams = New Structure();
	FormParams.Insert("TextUUID", Object[StrReplace(Command.Name, "ShowUUID", "")]);
	FormParams.Insert("ReadOnly", True);
	OpenForm("CommonForm.EditUUID", FormParams, ThisObject,,,,,FormWindowOpeningMode.LockOwnerWindow);	
EndProcedure

&AtClient
Procedure EditAccounting(Command)
	CurrentData = ThisObject.Items.Records.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	UpdateAccountingData();
	AccountingClient.OpenFormEditAccounting(Object, ThisObject, CurrentData, "Records");
EndProcedure

&AtServer
Procedure UpdateAccountingData()
	_AccountingRowAnalytics = ThisObject.AccountingRowAnalytics.Unload();
	_AccountingExtDimensions = ThisObject.AccountingExtDimensions.Unload();
	AccountingClientServer.UpdateAccountingTables(Object, 
			                                      _AccountingRowAnalytics, 
		                                          _AccountingExtDimensions, "Records");
	ThisObject.AccountingRowAnalytics.Load(_AccountingRowAnalytics);
	ThisObject.AccountingExtDimensions.Load(_AccountingExtDimensions);
EndProcedure

&AtClient
Procedure ShowAccountingEntriesFromSource(Command)
	GetAccountingEntriesFromSourceAtClient();	
EndProcedure

#EndRegion

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
