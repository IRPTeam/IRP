

&AtClient
Procedure BuildSI(Command)
	BuildSIAtServer();
EndProcedure

&AtServer
Procedure BuildSIAtServer()
	State = BuilderServer.CreateBuilder();
	
	BuilderServer.CreateDocument(State, "SalesInvoice");
//	BuilderServer.SetAttribute(State, "Partner", PartnerRef);
	
	
EndProcedure

// CLIENT

&AtClient
Procedure PartnerOnChange(Command)
	ControllerClientServer_V2.PartnerOnChange(Undefined);
EndProcedure

// SERVER

&AtServer
Procedure PartnerOnChangeAtServer(Command)
	PartnerOnChangeAtServerAtServer();
EndProcedure

&AtServer
Procedure PartnerOnChangeAtServerAtServer()
	ControllerClientServer_V2.PartnerOnChange(Undefined);
EndProcedure


