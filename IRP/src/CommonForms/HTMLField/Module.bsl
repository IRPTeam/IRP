

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	HTML = Parameters.HTML;
	Type = Parameters.Type;
	SrcUUID = Parameters.SrcUUID;
EndProcedure

&AtClient
Procedure HTMLDocumentComplete(Item)
	If Type = "GoogleDrive" Then
		GoogleDriveClient.OnHTMLComplite(Item.Document, SrcUUID);	
	EndIf;
EndProcedure

