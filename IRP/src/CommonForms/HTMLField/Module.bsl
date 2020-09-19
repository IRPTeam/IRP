&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	HTML = Parameters.HTML;
	Type = Parameters.Type;
	SrcUUID = Parameters.SrcUUID;
	AddInfoAddress = PutToTempStorage(Parameters.AddInfo);
EndProcedure

&AtClient
Procedure HTMLDocumentComplete(Item)
	If Type = "GoogleDrive" Then
		GoogleDriveClient.OnHTMLComplete(Item.Document, SrcUUID, GetFromTempStorage(AddInfoAddress));	
	EndIf;
EndProcedure