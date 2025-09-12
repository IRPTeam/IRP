Procedure BeforeWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
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

Procedure Filling(FillingData, FillingText, StandardProcessing)
	If TypeOf(FillingData) = Type("Structure") Then
		FillPropertyValues(ThisObject, FillingData);
	EndIf;
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	CheckUniqueDescriptionsParameters = New Structure();
	CheckUniqueDescriptionsParameters.Insert("QueryText", "AND Table.OurCompany = &OurCompany");
	CheckUniqueDescriptionsParameters.Insert("QueryParameters", New Structure("OurCompany", ThisObject.OurCompany));
	ThisObject.AdditionalProperties.Insert("CheckUniqueDescriptionsParameters", CheckUniqueDescriptionsParameters);
	CommonFunctionsServer.CheckUniqueDescriptions_PrivilegedCall(Cancel, ThisObject);
EndProcedure
