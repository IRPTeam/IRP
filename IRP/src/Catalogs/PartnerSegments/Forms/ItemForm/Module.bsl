&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	
	If Parameters.Key.IsEmpty() Then
		If Parameters.FillingValues.Property("Managers") Then
			Items.Managers.Visible = False;
		EndIf;
	EndIf;
	ExtentionServer.AddAtributesFromExtensions(ThisObject, Object.Ref);
EndProcedure

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure