&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
EndProcedure