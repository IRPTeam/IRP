

&AtClient
Procedure BuildSI(Command)
	BuildSIAtServer(PartnerRef);
EndProcedure

&AtServerNoContext
Procedure BuildSIAtServer(PartnerRef)
	Return;
EndProcedure

// CLIENT

&AtClient
Procedure PartnerOnChange(Command)
	Return;
EndProcedure

// SERVER

&AtServer
Procedure PartnerOnChangeAtServer(Command)
	PartnerOnChangeAtServerAtServer();
EndProcedure

&AtServer
Procedure PartnerOnChangeAtServerAtServer()
	Return;
EndProcedure


