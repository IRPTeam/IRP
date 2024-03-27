#Region Public

// Get current workstation.
// 
// Returns:
//  CatalogRef.Workstations -  Get current workstation
Function GetCurrentWorkstation() Export
	UniqueIDValue = GetUniqueID();
	Workstation = WorkstationServer.GetWorkstationByUniqueID(UniqueIDValue);
	Return Workstation;
EndFunction

// Get unique ID.
// 
// Returns:
//  String -  Get unique ID
Function GetUniqueID() Export
#If WebClient Then
	ComputerName = "WebClient";
#Else
		ComputerName = ComputerName();
#EndIf
	ReturnValue = ComputerName;
	Return ReturnValue;
EndFunction

#EndRegion