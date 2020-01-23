&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Not ValueIsFilled(Object.Ref) Then
		Cancel = True;
		Return;
	EndIf;
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
EndProcedure

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	If Not Object.Predefined Then
		Cancel = True;
		CommonFunctionsClientServer.ShowUsersMessage(R()["Error_008"]);
	EndIf;
EndProcedure

