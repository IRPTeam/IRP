// @strict-types

// Write.
// 
// Parameters:
//  Name - String - Event name. Ex. "Send to API"
//  Logs - Arbitrary, String - Logs data. String, or serializeble object, ex. Structure, Map, Array
//  Level - Number - Level:
//  	0 - Error
//  	1 - Info
//  	2 - Warning
//  	3 - Note
//  Step - String - Add part to event name. "Name.Step"
//  Ref - Undefined - Ref to db data
Procedure Write(Name, Logs, Level = 0, Step = "", Ref = Undefined) Export
	
	If Level = 0 Then
		EventLevel = EventLogLevel.Error;
	ElsIf Level = 1 Then
		EventLevel = EventLogLevel.Information;
	ElsIf Level = 2 Then
		EventLevel = EventLogLevel.Warning;
	Else
		EventLevel = EventLogLevel.Note;
	EndIf;
	_Logs = "";
	If Not TypeOf(Logs) = Type("String") Then
		Try
			_Logs = CommonFunctionsServer.SerializeJSON(Logs);
		Except
			_Logs = String(Logs);
		EndTry;
	Else
		_Logs = Logs
	EndIf;
	
	WriteLogEvent(Name, EventLevel, , Ref, _Logs);
EndProcedure