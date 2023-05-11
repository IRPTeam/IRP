// @strict-types

// Write.
// 
// Parameters:
//  Name - String - Event name. Ex. "Send to API"
//  Log - Arbitrary, String - Log data. String, or serializeble object, ex. Structure, Map, Array
//  Level - Number - Level:
//  	0 - Error
//  	1 - Info
//  	2 - Warning
//  	3 - Note
//  Step - String - Add part to event name. "Name.Step"
//  Ref - Undefined - Ref to db data
Procedure Write(Name, Log, Level = 0, Step = "", Ref = Undefined) Export
	
	If Level = 0 Then
		EventLevel = EventLogLevel.Error;
	ElsIf Level = 1 Then
		EventLevel = EventLogLevel.Information;
	ElsIf Level = 2 Then
		EventLevel = EventLogLevel.Warning;
	Else
		EventLevel = EventLogLevel.Note;
	EndIf;
	
	If Not TypeOf(Log) = Type("String") Then
		Try
			Log = CommonFunctionsServer.SerializeJSON(Log);
		Except
			Log = String(Log);
		EndTry;
	EndIf;
	
	WriteLogEvent(Name, EventLevel, , Ref, Log);
EndProcedure