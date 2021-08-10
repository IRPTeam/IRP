
Procedure BeforeWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	Description = Name + " " + Surname;
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;	
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If Not ThisObject.UsePartnerTransactions Or ThisObject.PartnerInfoFromUserSettings Then
		CheckedAttributes.Delete(CheckedAttributes.Find("Partner"));
		CheckedAttributes.Delete(CheckedAttributes.Find("LegalName"));
		CheckedAttributes.Delete(CheckedAttributes.Find("Agreement"));
	EndIf;
EndProcedure



