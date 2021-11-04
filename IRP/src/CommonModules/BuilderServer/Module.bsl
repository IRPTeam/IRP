
Function CreateBuilder() Export
	Return New Structure();
EndFunction

Function CreateDocument(State, DocumentName) Export
	Object = Documents[DocumentName].CreateDocument();
	State.Insert("Object", Object);
	
	Form = New Structure();
	Form.Insert("Object", Object);
	
	Execute "Doc" + DocumentName + "Server.OnReadAtServer(Object, Form, Object)";
	Execute "Doc" + DocumentName + "Server.OnCreateAtServer(Object, Form, Object)";
	Execute "Doc" + DocumentName + "Client.OnOpen(Object, Form, Object)";
	
	
	Form.Insert("CurrentAgreement");
	Form.Insert("CurrentDate");
	Form.Insert("CurrentDeliveryDate");
	Form.Insert("CurrentPartner");
	Form.Insert("CurrentPriceType");
	Form.Insert("CurrentStore");
	Form.Insert("DeliveryDate");
	Form.Insert("Description");
	Form.Insert("ExternalLinkedDocs");
	Form.Insert("GroupItems", New ValueList());
	Form.Insert("InternalLinkedDocs");
	Form.Insert("LockedFields");
	Form.Insert("SerialLotNumbersTree");
	Form.Insert("ShipmentConfirmationsTree");
	Form.Insert("Store");
	Form.Insert("StoreBeforeChange");
	Form.Insert("TaxAndOffersCalculated");
	
	Items = New Structure();
	Items.Insert("Company", New Structure("Title"));
	Items.Insert("Partner", New Structure("Title"));
	Items.Insert("LegalName", New Structure("Title"));
	Items.Insert("Agreement", New Structure("Title"));
	Items.Insert("LegalNameContract", New Structure("Title"));
	Items.Insert("Store", New Structure("InputHint"));
	
	Form.Insert("Items", Items);
	
	State.Insert("Form", Form);
	
	// Object events
	Object.Fill(Undefined);
	
	Execute "Doc" + DocumentName + "Server.OnReadAtServer(Object, Form, Object)";
	
	Return State;
EndFunction

Procedure TEST(PartnerRef) Export
	Doc = Documents.PurchaseInvoice.CreateDocument();
	Doc.Date = CurrentDate();
	Results = New Array();
	Result = New Structure();
	Result.Insert("Value"      , PartnerRef);
	Result.Insert("Parameters" , New Structure("Key"));
	Results.Add(Result);
	
	Parameters1 = New Structure("Object", Doc);
	Parameters1.Insert("ControllerModule", ControllerClientServer_V2);
	
	ControllerClientServer_V2.Compile();
	ControllerClientServer_V2.SetPartner_API(Parameters1, Results);
	Doc.Write();
EndProcedure

