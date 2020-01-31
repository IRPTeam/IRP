&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
EndProcedure

&AtServer
Procedure FillCheckProcessingAtServer(Cancel, CheckedAttributes)
	If Not ValueIsFilled(Object.Code) Then
		MessageText = StrTemplate(R()["Error_010"], "Code");
		CommonFunctionsClientServer.ShowUsersMessage(MessageText,
					"Object.Code",
					"Object");
		Cancel = True;
	EndIf;
EndProcedure

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

