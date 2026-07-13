
// Filling parameters.
// 
// Returns:
//  Structure - Filling parameters:
// * FillingData - Structure - 
// * BasedOn - String - 
// * Force - Boolean - 
Function FillingParameters() Export
	
	Parameters = New Structure;
	
	Parameters.Insert("FillingData", New Structure);
	Parameters.Insert("BasedOn", "");
	Parameters.Insert("Force", False);
	
	Return Parameters;
	
EndFunction

// Check filling parameters.
// 
// Parameters:
//  FillingParameters - See FillingParameters
// 
// Returns:
//  Boolean - Check filling parameters
Function CheckFillingParameters(FillingParameters) Export
	
	If TypeOf(FillingParameters) <> Type("Structure") Then
		Return False;
	EndIf;
	
	If Not FillingParameters.Property("FillingData") OR TypeOf(FillingParameters.FillingData) <> Type("Structure") Then
		Return False;
	ElsIf Not FillingParameters.Property("BasedOn") OR TypeOf(FillingParameters.BasedOn) <> Type("String") Then
		Return False;
	ElsIf Not FillingParameters.Property("Force") OR TypeOf(FillingParameters.Force) <> Type("Boolean") Then
		Return False;
	EndIf;
	
	Return True;
	
EndFunction