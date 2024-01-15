&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	CatalogsServer.OnCreateAtServerObject(ThisObject, Object, Cancel, StandardProcessing);
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
EndProcedure

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure AddExtDataProc(Command)
	NotifyEndPut = New NotifyDescription("AddExtDataProcEnd", ThisObject);
	//@skip-warning
	BeginPutFile(NotifyEndPut, , , True);
EndProcedure

&AtClient
Procedure AddExtDataProcEnd(Result, Address, FileName, Parameters) Export
	If Not Result Then
		Return;
	EndIf;

	ThisObject.DataProcStorageAddress = TransferFileToServer(New BinaryData(FileName), ThisObject.UUID);
	ThisObject.Modified = True;
	Object.PathToExtDataProcForTest = FileName;
EndProcedure

&AtServer
Function TransferFileToServer(BinaryData, Address)
	Return PutToTempStorage(BinaryData, Address);
EndFunction

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	If ValueIsFilled(ThisObject.DataProcStorageAddress) Then
		DataProcBD = GetFromTempStorage(ThisObject.DataProcStorageAddress);
		If Not DataProcBD = Undefined Then
			CurrentObject.DataProcStorage = New ValueStorage(DataProcBD, New Deflation(9));
		EndIf;
	EndIf;
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

&AtClient
Procedure ExportExtDataProc(Command)
	FileDialog = New FileDialog(FileDialogMode.ChooseDirectory);
	Notify = New NotifyDescription("ChooseDirectoryEnding", ThisObject);
	FileDialog.Show(Notify);
EndProcedure

&AtClient
Procedure ChooseDirectoryEnding(Result, AddParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;

	If Result.Count() >= 1 Then
		PathToDirectory = Result[0];
	EndIf;

	BinaryDataPointer = GetFileFromStorage();

	If Not ValueIsFilled(BinaryDataPointer) Then
		Return;
	EndIf;

	BinaryData = GetFromTempStorage(BinaryDataPointer);
	BinaryData.Write(PathToDirectory + "\" + Object.Name + ".epf");
EndProcedure

&AtServer
Function GetFileFromStorage()
	Query = New Query();
	Query.Text =
	"SELECT
	|	ExternalDataProc.DataProcStorage AS DataProcStorage
	|FROM
	|	Catalog.ExternalDataProc AS ExternalDataProc
	|WHERE
	|	ExternalDataProc.Ref = &Ref";
	Query.SetParameter("Ref", Object.Ref);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		BinaryData = QuerySelection.DataProcStorage.Get();
		If BinaryData <> Undefined Then
			Return PutToTempStorage(BinaryData, ThisObject.UUID);
		EndIf;
	EndIf;
	Return Undefined;
EndFunction

#Region AddAttributes

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject);
EndProcedure

&AtClient
Procedure AddAttributeButtonClick(Item) Export
	AddAttributesAndPropertiesClient.AddAttributeButtonClick(ThisObject, Item);
EndProcedure

#EndRegion

#Region COMMANDS

&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	ExternalCommandsClient.GeneratedFormCommandActionByName(Object, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name);
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName) Export
	ExternalCommandsServer.GeneratedFormCommandActionByName(Object, ThisObject, CommandName);
EndProcedure

&AtClient
Procedure InternalCommandAction(Command) Export
	InternalCommandsClient.RunCommandAction(Command, ThisObject, Object, Object.Ref);
EndProcedure

#EndRegion