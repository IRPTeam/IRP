&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.Value = GetResourceAsString(Record.ThreadKey, "Value");
	ThisObject.InputValue = GetResourceAsString(Record.ThreadKey, "InputValue");
EndProcedure

Function GetResourceAsString(ThreadKey, ResourceName)
	If Not ValueIsFilled(ThreadKey) Then
		Return "";
	EndIf;
	
	RecordSet = InformationRegisters.ThreadsInfo.CreateRecordSet();
	RecordSet.Filter.ThreadKey.Set(ThreadKey);
	RecordSet.Read();
	If RecordSet.Count() Then
		JSONWriter = New JSONWriter();
		JSONWriter.SetString();
		WriteJSON(JSONWriter, RecordSet[0][ResourceName].Get());
		JSON = JSONWriter.Close();
		Return JSON;
	Else
		Return "";
	EndIf;
EndFunction

