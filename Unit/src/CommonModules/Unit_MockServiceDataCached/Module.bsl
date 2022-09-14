// @strict-types

#Region Public

// Wildcard address check.
// 
// Parameters:
//  Address - String - Address
//  Pattern - String - Pattern of address
// 
// Returns:
//  Boolean - address matches
Function AddressCheck(Address, Pattern) Export

	AddressParts = StrSplit(Address, "/", False);
	PatternParts = StrSplit(Address, "/", False);
	
	If AddressParts.Count() < PatternParts.Count() Then
		Return False;
	Else
		NumberExtraSections = PatternParts.Count() - AddressParts.Count();
		AnyString = GetAnyString();
		For index = 1 To NumberExtraSections Do
			PatternParts.Add(AnyString);
		EndDo; 
	EndIf;
	
	For index = 1 To AddressParts.Count() Do
		If Not StringIdentityCheck(AddressParts[index], PatternParts[index]) Then
			Return False;
		EndIf;
	EndDo;

	Return True;
	
EndFunction 

// String identity check.
// 
// Parameters:
//  InputString - String - Input string
//  PatternString - String - Pattern string
// 
// Returns:
//  Boolean - Strings are identical
Function StringIdentityCheck(Val InputString, Val PatternString) Export
	
	AnyString = GetAnyString();
	
	If StrFind(PatternString, AnyString) > 0 Then
		ValidSize = StrFind(PatternString, AnyString) - 1;
		If ValidSize = 0 Then
			Return True;
		EndIf;
		InputString = Mid(InputString, 1, ValidSize);
		PatternString = Mid(PatternString, 1, ValidSize); 
	EndIf;
	
	Return StrCompare(InputString, PatternString) = 0;
		
EndFunction

// Get any string.
// 
// Returns:
//  String - Any string
Function GetAnyString() Export
	Return "*";
EndFunction

#EndRegion 