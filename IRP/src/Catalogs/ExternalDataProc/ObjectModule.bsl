Procedure OnWrite(Cancel)
	ExternalDataProcNames = New Structure();
	For Each KeyValue In SessionParameters.ConnectedAddDataProc Do
		If KeyValue.Key <> ThisObject.Name Then
			ExternalDataProcNames.Insert(KeyValue.Key, KeyValue.Value);
		EndIf;
	EndDo;
	SessionParameters.ConnectedAddDataProc = New FixedStructure(ExternalDataProcNames);
EndProcedure

