
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ExtensionServer.AddAtributesFromExtensions(ThisObject, Object.Ref);
EndProcedure
