
Procedure SetData(Data) Export 
	
	ValueStore = New ValueStorage(Data);
	Constants.AdditionalTableControlExceptions.Set(ValueStore);
	
EndProcedure

Function GetData() Export
	
	ValueStore = Constants.AdditionalTableControlExceptions.Get();
	Data = ValueStore.Get();
	
	If TypeOf(Data) = Type("Array") Then
		Return Data;
	EndIf;
	
	Return New Array;
	
EndFunction