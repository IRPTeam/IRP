// @strict-types

#Region Info

Function Tests() Export
	TestList = New Array;
	Return TestList;
EndFunction

#EndRegion

#Region Public

// Get size presentation.
// 
// Parameters:
//  Size - Number - Size
// 
// Returns:
//  String - Size presentation
Function GetSizePresentation(Size) Export
	
	Kilobyte = Size / 1024;
	Megabyte = Kilobyte / 1024; 
	Gigabyte = Megabyte / 1024;
	Terabyte = Gigabyte / 1024;
	
	If Size < Pow(2, 10) Then
		Return Format(Size, "NZ=; NG=;")+" B";
	ElsIf Size < Pow(2, 20) Then 
		Return Format(Kilobyte, "NFD=1; NZ=; NG=;")+" kB";
	ElsIf Size < Pow(2, 30) Then 
		Return Format(Megabyte, "NFD=1; NZ=; NG=;")+" MB";
	ElsIf Size < Pow(2, 40) Then 
		Return Format(Gigabyte, "NFD=1; NZ=; NG=;")+" GB";
	Else 
		Return Format(Terabyte, "NFD=1; NZ=; NG=;")+" TB";
	EndIf;
	
EndFunction

#EndRegion
