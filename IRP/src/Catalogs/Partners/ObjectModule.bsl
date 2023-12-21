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
	CommonFunctionsServer.CheckUniqueDescriptions(Cancel, ThisObject);
EndProcedure
