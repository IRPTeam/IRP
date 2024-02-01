&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	LocalizationEvents.FillDescription(Parameters.FillingText, Object);
	ChartsOfCharacteristicTypesServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	ChartsOfCharacteristicTypesServer.OnReadAtServer(Object, ThisObject, CurrentObject);
EndProcedure

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)
	ChartsOfCharacteristicTypesServer.OnWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure