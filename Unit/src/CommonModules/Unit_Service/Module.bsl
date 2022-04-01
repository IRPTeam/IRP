// @strict-types

Function Tests() Export
	
	TestList = New Array;
	
	Return TestList;
	
EndFunction

// Run test.
// 
// Parameters:
//  Code - String - Code
// 
// Returns:
//  String - Run test
Function RunTest(Code) Export
	Try
		Result = Eval(Code);
		Return "";
	Except
		Return ErrorProcessing.DetailErrorDescription(ErrorInfo());
	EndTry;
EndFunction

// Get all test.
// 
// Returns:
//  Array of String - Get all test
Function GetAllTest() Export

	TestList = New Array;
	For Each Module In Metadata.CommonModules Do
		If StrStartsWith(Module.Name, "Unit_") Then
			TestInModule = Eval(Module.Name + ".Tests()");
			For Each Test In TestInModule Do
				TestList.Add(Module.Name + "." + Test + "()");
			EndDo;
		EndIf;
	EndDo;
	Return TestList;
EndFunction

// Get data.
// 
// Parameters:
//  URL - String - URL
// 
// Returns:
//  AnyRef - Get data
Function GetData(URL) Export
	// Catalog.Items?ref=a2c1aafaa4d87ef711ecb0fbebb448a9
	Parts = StrSplit(URL, ".?=");
    ValueTemplate = ValueToStringInternal(PredefinedValue(Parts[0] + "." + Parts[1] + ".EmptyRef"));
    LinkValue = StrReplace(ValueTemplate, "00000000000000000000000000000000", Parts[3]);

    Return ValueFromStringInternal(LinkValue);
      
EndFunction

// Get record set.
// 
// Parameters:
//  RegName - String - Reg name
//  Filters - Array of KeyAndValue:
//  	*Key - String -
//  	*Value - AnyRef -
// 
// Returns:
//  InformationRegisterRecordSetInformationRegisterName - Get record set
Function GetRecordSet(RegName, Filters) Export
	
	IR = InformationRegisters[RegName].CreateRecordSet();
	For Each Filter In Filters Do
		If Not IR.Filter.Find(Filter.Key) = Undefined Then
			IR.Filter[Filter.Key].Set(Filter.Value);
		EndIf;
	EndDo;
	Return IR;
	
EndFunction

// Is equal.
// 
// Parameters:
//  weWait - Arbitrary - Data1
//  weGot - Arbitrary - Data2
Procedure isEqual(weWait, weGot) Export
	
	If Not weWait = weGot Then
		Error = "We wait for: " + weWait + Chars.LF + "And got: " + weGot;
		Raise Error;
	EndIf;
	
EndProcedure
