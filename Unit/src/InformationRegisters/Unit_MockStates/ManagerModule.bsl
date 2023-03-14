// @strict-types

#Region Public

// Set mock state.
// 
// Parameters:
//  Mock - CatalogRef.Unit_MockServiceData - Mock
//  Key - String - Key
//  Value - Arbitrary - Value
Procedure SetMockState(Mock, Key, Value) Export
	ValueString = "";
	If TypeOf(Value) = Type("String") Then
		ValueString = Value;
	ElsIf TypeOf(Value) = Type("Number") Then
		ValueString = Format(Value, "NZ=; NG=;");
	Else
		ValueString = String(Value);
	EndIf;
	
	RecordManager = CreateRecordManager();
	RecordManager.Period = CommonFunctionsServer.GetCurrentSessionDate();
	RecordManager.Mock = Mock;
	RecordManager.Key = Key;
	RecordManager.Value = ValueString;
	RecordManager.Write();
EndProcedure

Function GetMockState(Mock, Key) Export
	Filter = New Structure;
	Filter.Insert("Mock", Mock);
	Filter.Insert("Key", Key);
	
	Return GetLast(, Filter);
EndFunction

#EndRegion