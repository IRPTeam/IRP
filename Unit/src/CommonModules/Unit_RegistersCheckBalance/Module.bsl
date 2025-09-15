
#Region Info

Function Tests() Export
	TestList = New Array;
	TestList.Add("RegistersCheckBalance");	
	Return TestList;
EndFunction

#EndRegion

#Region Test

Function RegistersCheckBalance() Export
	ArrayOfErrors = New Array();
	
	_RegistersCheckBalance(ArrayOfErrors);
	
	If ArrayOfErrors.Count() Then
		Unit_Service.assertFalse("Registers check balance errors: " + Chars.LF +
			StrConcat(ArrayOfErrors, Chars.LF));
	EndIf;
	Return "";
EndFunction

Function RegisterSupport_API1(RegisterName)
	AddInfo = New Structure("UnitTest", True);
	Try
		Return AccumulationRegisters[RegisterName].CheckBalance(
			Undefined, 
			Undefined, 
			Undefined,
			Undefined, AddInfo);
	Except
		Return False;
	EndTry;
EndFunction

Function RegisterSupport_API2(RegisterName)
	AddInfo = New Structure("UnitTest", True);
	Try
		Return AccumulationRegisters[RegisterName].CheckBalance(
			Undefined, 
			Undefined, 
			Undefined, 
			Undefined, 
			Undefined, 
			Undefined, AddInfo);
	Except
		Return False;
	EndTry;
EndFunction

Procedure _RegistersCheckBalance(ArrayOfErrors)
	ArrayOfRegisters = New Array();
	
	Ignored_Registers = GetIgnored_Registers();
	
	For Each RegMetadata In Metadata.AccumulationRegisters Do
		If Ignored_Registers.Find(RegMetadata.Name) <> Undefined Then
			Continue;
		EndIf;
		
		If RegisterSupport_API1(RegMetadata.Name) Then
			ArrayOfRegisters.Add(RegMetadata.Name);
			Continue;
		EndIf;
		If RegisterSupport_API2(RegMetadata.Name) Then
			ArrayOfRegisters.Add(RegMetadata.Name);
			Continue;
		EndIf;
	EndDo;
		
	Ignored_Documents = GeIgnored_Documents();
	
	For Each RegisterName In ArrayOfRegisters Do
		Recorders = Metadata.AccumulationRegisters[RegisterName].StandardAttributes.Recorder.Type.Types();
		For Each Recorder In Recorders Do
			DocMetadata = Metadata.FindByType(Recorder);
			
			If Ignored_Documents.Find(DocMetadata.Name) <> Undefined Then
				Continue;
			EndIf;
		
			AddInfo = New Structure("UnitTest", True);
			Expression = StrTemplate("Documents.%1.CheckAfterWrite(Undefined, Undefined, Undefined, AddInfo)", DocMetadata.Name);
			Try
				SetSafeMode(True);
				Execute Expression;
			Except
				ArrayOfErrors.Add(StrTemplate("Document[%1]: Register[%2]", DocMetadata.Name, RegisterName));
			EndTry;
		EndDo;
	EndDo;
EndProcedure 

Function GeIgnored_Documents()
	Array = New Array();
	Array.Add("ManualRegisterEntry");
	Array.Add("ForeignCurrencyRevaluation");
	Return Array;
EndFunction

Function GetIgnored_Registers()
	Array = New Array();
	Array.Add("TM1010T_RowIDMovements");
	Array.Add("TM1010B_RowIDMovements");
	Array.Add("R6025B_SimpleBatch");
	Array.Add("R4010B_ActualStocks");
	Array.Add("R4011B_FreeStocks");
	Array.Add("R4014B_SerialLotNumber");
	Array.Add("R4035B_IncomingStocks");
	Array.Add("R4036B_IncomingStocksRequested");
	Array.Add("R6080T_OtherPeriodsRevenues");
	Array.Add("R6070T_OtherPeriodsExpenses");
	Array.Add("R4050B_StockInventory");
	Return Array;
EndFunction

#EndRegion
