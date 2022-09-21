
// Strings.
// 
// Parameters:
//  Lang - String - Lang
// 
// Returns:
// Structure:
//  Structure, Arbitrary - Unit strings:
// * Mock_001 - String - Empty file!
&Around("Strings")
Function Unit_Strings(Lang) Export
	Strings = ProceedWithCall(Lang); // Structure
	Strings.Insert("Mock_001", NStr("en = 'Empty file!'", Lang));
	Strings.Insert("Mock_002", NStr("en = 'Not Found'", Lang));
	Strings.Insert("Mock_003", NStr("en = 'Found out'", Lang));
	Strings.Insert("Mock_004", NStr("en = 'Start address check'", Lang));
	Strings.Insert("Mock_005", NStr("en = 'Start headers check'", Lang));
	Strings.Insert("Mock_006", NStr("en = 'Start body check'", Lang));
	Strings.Insert("Mock_007", NStr("en = 'Start variables check'", Lang));
	Strings.Insert("Mock_008", NStr("en = 'Start body´s variables check'", Lang));
	Strings.Insert("Mock_009", NStr("en = 'Start getting variables from the request'", Lang));
	Strings.Insert("Mock_010", NStr("en = 'Calculation of %1'", Lang));
	Strings.Insert("Mock_011", NStr("en = 'Check passed successfully'", Lang));
	Strings.Insert("Mock_012", NStr("en = 'All checks passed successfully'", Lang));
	Strings.Insert("Mock_013", NStr("en = 'Error: There are more parts in the address pattern'", Lang));
	Strings.Insert("Mock_014", NStr("en = 'Error: Difference in %1-th part of the address'", Lang));
	Strings.Insert("Mock_015", NStr("en = 'Error: Header Not found - %1'", Lang));
	Strings.Insert("Mock_016", NStr("en = 'Error: Difference in meaning of header - %1'", Lang));
	Strings.Insert("Mock_017", NStr("en = 'Error: Difference in meaning of MD5'", Lang));
	Strings.Insert("Mock_018", NStr("en = 'MD5 binary'", Lang));
	Strings.Insert("Mock_019", NStr("en = 'MD5 string'", Lang));
	Strings.Insert("Mock_020", NStr("en = 'Error: Variable Not found - %1'", Lang));
	Strings.Insert("Mock_021", NStr("en = 'Error: Difference in meaning of variable - %1'", Lang));
	Strings.Insert("Mock_022", NStr("en = 'Required value'", Lang));
	Strings.Insert("Mock_023", NStr("en = 'Found value'", Lang));
	Strings.Insert("Mock_024", NStr("en = 'Input address'", Lang));
	Strings.Insert("Mock_025", NStr("en = 'Pattern address'", Lang));
	Return Strings;
EndFunction
