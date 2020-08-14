
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ExtentionServer.AddAtributesFromExtensions(ThisObject, Object.Ref);
EndProcedure
