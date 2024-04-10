Procedure BeforeWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	AgreementTypes = New Array();
	If ThisObject.Customer Then
		AgreementTypes.Add(Enums.AgreementTypes.Customer);
	EndIf;
	If ThisObject.Vendor Then
		AgreementTypes.Add(Enums.AgreementTypes.Vendor);
	EndIf;
	Parameters = New Structure("Partner, AgreementTypes", ThisObject, AgreementTypes);
	FOServer.CreateDefault_LegalName(Parameters);
	FOServer.CreateDefault_Agreement(Parameters);
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	CommonFunctionsServer.CheckUniqueDescriptions_PrivilegedCall(Cancel, ThisObject);
	
	ArrayOfPartnerTypes = New Array();
	ArrayOfPartnerTypes.Add("Customer");
	ArrayOfPartnerTypes.Add("Vendor");
	ArrayOfPartnerTypes.Add("Employee");
	ArrayOfPartnerTypes.Add("Consignor");
	ArrayOfPartnerTypes.Add("TradeAgent");
	ArrayOfPartnerTypes.Add("Other");
	
	For Each PartnerType In ArrayOfPartnerTypes Do
		AllIsFalse = True;
		If ThisObject[PartnerType] Then
			AllIsFalse = False;
			Break;
		EndIf;
	EndDo;
	
	If AllIsFalse Then
		Cancel = True;
		CommonFunctionsClientServer.ShowUsersMessage(R().Error_140, ArrayOfPartnerTypes[0], ThisObject);
	EndIf;
EndProcedure
