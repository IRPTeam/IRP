
&AtClient
Var HTMLWindow Export;

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	TemplateName = Parameters.TemplateName;
	HTML = GetCommonTemplate(TemplateName).GetText();
EndProcedure

&AtClient
Procedure HTMLDocumentComplete(Item)
	HTMLWindow = PictureViewerClient.InfoDocumentComplete(Item);
	HTMLWindow.fillData(Data);
	Data = "";
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "HTMLPrintForm" Then
		If Source = TemplateName Then
			If Not IsBlankString(Parameter) Then
				If HTMLWindow = Undefined Then
					Data = Parameter;
				Else
					HTMLWindow.fillData(Parameter);
				EndIf;
			EndIf;
		EndIf;
	EndIf;
EndProcedure
