&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.Volume = PictureViewerServer.GetIntegrationSettingsPicture().DefaultPictureStorageVolume;
EndProcedure

&AtClient
Procedure FilesIDBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure FilesIDBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure CheckAll(Command)
	For Each Row In ThisObject.Files Do
		Row.Use = True;
	EndDo;
EndProcedure

&AtClient
Procedure UncheckAll(Command)
	For Each Row In ThisObject.Files Do
		Row.Use = False;
	EndDo;
EndProcedure

&AtClient
Procedure FindUnusedFiles(Command)
	FindUnusedFilesAtClient();
EndProcedure

&AtClient
Procedure FindUnusedFilesAtClient()
	IntegrationSettings = PictureViewerServer.GetIntegrationSettingsPicture(Volume);
	ArrayOfUnusedFilesID = PictureViewerClient.GetArrayOfUnusedFiles(IntegrationSettings.POSTIntegrationSettings);

	ThisObject.Files.Clear();
	For Each ItemOfArray In ArrayOfUnusedFilesID Do
		NewRow = ThisObject.Files.Add();
		NewRow.FileURI = ItemOfArray;
		NewRow.POSTSettingName = "POSTIntegrationSettings";
		NewRow.GETSettingName = "GETIntegrationSettings";
	EndDo;
EndProcedure

&AtClient
Procedure FilesIDSelection(Item, RowSelected, Field, StandardProcessing)
	CurrentData = Items.Files.CurrentData;
	If Not ValueIsFilled(CurrentData.GETSettingName) Or Not ValueIsFilled(CurrentData.FileURI) Then
		Return;
	EndIf;
	IntegrationSettings = PictureViewerServer.GetIntegrationSettingsPicture(Volume);
	PictureTempAddress = PictureViewerClient.GetPictureAndPutToTempStorage(ThisObject.UUID, CurrentData.FileURI,
		IntegrationSettings[CurrentData.GETSettingName]);

	OpenForm("CommonForm.PictureViewerFormRegular", New Structure("PictureTempAddress", PictureTempAddress),
		ThisObject, , , , , FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure DeleteUnusedFiles(Command)
	IntegrationSettings = PictureViewerServer.GetIntegrationSettingsPicture(Volume);

	ArrayOfUnusedFilesID = PrepareDeletionFilesID();
	For Each Row In ArrayOfUnusedFilesID Do
		PictureViewerClient.DeleteUnusedFiles(Row.ArrayOfFilesID, IntegrationSettings[Row.POSTSettingName]);
	EndDo;
	FindUnusedFilesAtClient();
EndProcedure

&AtServer
Function PrepareDeletionFilesID()
	ValueTable = ThisObject.Files.Unload().Copy(New Structure("Use", True));
	ValueTableCopy = ValueTable.Copy();
	ValueTableCopy.GroupBy("POSTSettingName");
	ArrayOfResults = New Array();
	For Each Row In ValueTableCopy Do
		Result = New Structure();
		Result.Insert("POSTSettingName", Row.PostSettingName);
		Result.Insert("ArrayOfFilesID", New Array());
		For Each Row2 In ValueTable.FindRows(New Structure("POSTSettingName", Row.POSTSettingName)) Do
			Result.ArrayOfFilesID.Add(Row2.FileURI);
		EndDo;
		ArrayOfResults.Add(Result);
	EndDo;
	Return ArrayOfResults;
EndFunction