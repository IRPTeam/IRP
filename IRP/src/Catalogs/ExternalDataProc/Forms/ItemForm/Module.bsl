&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
EndProcedure

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure AddExtDataProc(Command)
	NotifyEndPut = New NotifyDescription("AddExtDataProcEnd", ThisObject);
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

