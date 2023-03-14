&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	HTML = Parameters.HTML;
	Type = Parameters.Type;
	SrcUUID = Parameters.SrcUUID;
	AddInfoAddress = PutToTempStorage(Parameters.AddInfo);
EndProcedure

&AtClient
Procedure HTMLDocumentComplete(Item)
	Return;
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "CloseForm" And Source = SrcUUID Then
		Close();
	EndIf;
EndProcedure