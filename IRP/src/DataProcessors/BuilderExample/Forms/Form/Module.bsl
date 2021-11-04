

&AtClient
Procedure BuildSI(Command)
	BuildSIAtServer(PartnerRef);
EndProcedure

&AtServerNoContext
Procedure BuildSIAtServer(PartnerRef)
	
	//Doc = Documents.SalesInvoice.CreateInvoice();
	//Doc.SetPartner(Ref);
	
	BuilderServer.TEST(PartnerRef);
//	Doc = Documents.SalesInvoice.CreateDocument();
//	
//	Results = New Array();
//	Result = New Structure();
//	Result.Insert("Value"      , PartnerRef);
//	Result.Insert("Parameters" , Undefined);
//	Results.Add(Result);
//	
//	Parameters1 = New Structure("Object", Doc);
//	
//	ControllerClientServer_V2.SetPartner(Parameters1, Results);
//	Doc.Write();
//	
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
	
EndProcedure


