&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.Settings = GetSettingsAsString(Record.Token);
	ThisObject.AddInfo = GetAddInfoAsString(Record.Token);
EndProcedure

Function GetSettingsAsString(Token)
	If Not ValueIsFilled(Token) Then
		Return "";
	EndIf;
	
	RecordSet = InformationRegisters.JobSettings.CreateRecordSet();
	RecordSet.Filter.Token.Set(Token);
	RecordSet.Read();
	If RecordSet.Count() Then
		Return RecordSet[0].Settings.Get();
	Else
		Return "";
	EndIf;
EndFunction

Function GetAddInfoAsString(Token)
	If Not ValueIsFilled(Token) Then
		Return "";
	EndIf;
	
	RecordSet = InformationRegisters.JobSettings.CreateRecordSet();
	RecordSet.Filter.Token.Set(Token);
	RecordSet.Read();
	If RecordSet.Count() Then
		Return SerializeToJson(RecordSet[0].AddInfo.Get());
	Else
		Return "";
	EndIf;
EndFunction

Function SerializeToJson(Value)
	JSONWriter = New JSONWriter();
	JSONWriter.SetString();
	XDTOSerializer.WriteJSON(JSONWriter, Value);
	JSON = JSONWriter.Close();
	Return JSON;
EndFunction