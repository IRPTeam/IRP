
Procedure BeforeWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	ExternalDataProcNames = New Structure();
	For Each KeyValue In SessionParameters.ConnectedAddDataProc Do
		If KeyValue.Key <> ThisObject.Name Then
			ExternalDataProcNames.Insert(KeyValue.Key, KeyValue.Value);
		EndIf;
	EndDo;
	SessionParameters.ConnectedAddDataProc = New FixedStructure(ExternalDataProcNames);
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure
