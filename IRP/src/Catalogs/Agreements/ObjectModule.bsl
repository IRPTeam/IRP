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
	Query = New Query(
	"SELECT TOP 1
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
		If PartnerInfo.Vendor AND Not PartnerInfo.Customer Then
			Type = Enums.AgreementTypes.Vendor;
		ElsIf Not PartnerInfo.Vendor AND PartnerInfo.Customer Then
			Type = Enums.AgreementTypes.Customer;
		Else
			Type = Enums.AgreementTypes.EmptyRef();
		EndIf;
	EndIf;
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If ThisObject.ApArPostingDetail <> Enums.ApArPostingDetail.ByStandardAgreement Then
		Index = CheckedAttributes.Find("StandardAgreement");
		If  Index <> Undefined Then
			CheckedAttributes.Delete(Index);
		EndIf;
	EndIf;
	
	If ThisObject.Kind <> Enums.AgreementKinds.Regular Then
		Index = CheckedAttributes.Find("PriceType");
		If Index <> Undefined Then
			CheckedAttributes.Delete(Index);
		EndIf;
		Index = CheckedAttributes.Find("Type");
		If Index <> Undefined Then
			CheckedAttributes.Delete(Index);
		EndIf;
	EndIf;
EndProcedure

Procedure BeforeWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	If ThisObject.Kind <> Enums.AgreementKinds.Regular Then
		ThisObject.Type = Enums.AgreementTypes.EmptyRef();
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
