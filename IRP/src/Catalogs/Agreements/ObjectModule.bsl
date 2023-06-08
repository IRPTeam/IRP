Procedure BeforeWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;

	If ThisObject.Kind <> Enums.AgreementKinds.Regular Then
		ThisObject.PriceType = Catalogs.PriceTypes.EmptyRef();
		ThisObject.PriceIncludeTax = False;
		ThisObject.DaysBeforeDelivery = 0;
		ThisObject.Store = Catalogs.Stores.EmptyRef();
	EndIf;

	If ThisObject.ApArPostingDetail <> Enums.ApArPostingDetail.ByStandardAgreement Then
		ThisObject.StandardAgreement = Catalogs.Agreements.EmptyRef();
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

	If ValueIsFilled(Partner) Then
		FillByPartner();
	EndIf;

	If Not ValueIsFilled(ApArPostingDetail) Then
		ApArPostingDetail = Enums.ApArPostingDetail.ByAgreements;
	EndIf;
	If Not ValueIsFilled(Kind) Then
		Kind = Enums.AgreementKinds.Regular;
	EndIf;
EndProcedure

Procedure FillByPartner()
	Query = New Query("SELECT TOP 1
					  |	Partners.Ref,
					  |	Partners.Customer,
					  |	Partners.Vendor
					  |FROM
					  |	Catalog.Partners AS Partners
					  |WHERE
					  |	Partners.Ref = &Ref");
	Query.SetParameter("Ref", Partner);

	PartnerInfo = Query.Execute().Select();
	If PartnerInfo.Next() Then
		If PartnerInfo.Vendor And Not PartnerInfo.Customer Then
			Type = Enums.AgreementTypes.Vendor;
		ElsIf Not PartnerInfo.Vendor And PartnerInfo.Customer Then
			Type = Enums.AgreementTypes.Customer;
		Else
			Type = Enums.AgreementTypes.EmptyRef();
		EndIf;
	EndIf;
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If ThisObject.ApArPostingDetail <> Enums.ApArPostingDetail.ByStandardAgreement Then
		CommonFunctionsClientServer.DeleteValueFromArray(CheckedAttributes, "StandardAgreement");
	EndIf;

	If ThisObject.Kind <> Enums.AgreementKinds.Regular Then
		CommonFunctionsClientServer.DeleteValueFromArray(CheckedAttributes, "PriceType");
		CommonFunctionsClientServer.DeleteValueFromArray(CheckedAttributes, "Type");
	EndIf;
	
	If ThisObject.Type = Enums.AgreementTypes.Other Then
		CommonFunctionsClientServer.DeleteValueFromArray(CheckedAttributes, "PriceType");
	EndIf;
EndProcedure
