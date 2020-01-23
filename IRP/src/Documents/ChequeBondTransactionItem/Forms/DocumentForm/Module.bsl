&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Not ValueIsFilled(Object.Ref) Then
		Cancel = True;
	EndIf;
	CurrenciesServer.UpdateRatePresentation(Object);
EndProcedure

