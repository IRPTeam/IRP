
#Region Public

//
Function GetCurrentWorkstation() Export
	UniqueIDValue = GetUniqueID();
	Workstation = WorkstationServer.GetWorkstationByUniqueID(UniqueIDValue);
	Return Workstation;
EndFunction

//
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