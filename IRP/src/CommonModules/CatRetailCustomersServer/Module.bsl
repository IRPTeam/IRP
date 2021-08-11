
Function GetRetailCustomerInfo(RetailCustomer, AddInfo = Undefined) Export
	RetailCustomerInfo = New Structure();
	RetailCustomerInfo.Insert("UsePartnerTransactions" , RetailCustomer.UsePartnerTransactions);
	RetailCustomerInfo.Insert("UsePartnerInfo"         , RetailCustomer.UsePartnerInfo);
	
	RetailCustomerInfo.Insert("Partner"   , Undefined);
	RetailCustomerInfo.Insert("LegalName" , Undefined);
	RetailCustomerInfo.Insert("Agreement" , Undefined);
	
	If RetailCustomerInfo.UsePartnerTransactions Then
		If Not RetailCustomerInfo.UsePartnerInfo Then
			FillPropertyValues(RetailCustomerInfo, GetPartnerInfoFromUserSettinfs());
		Else
			RetailCustomerInfo.Partner   = RetailCustomer.Partner;
			RetailCustomerInfo.LegalName = RetailCustomer.LegalName;
			RetailCustomerInfo.Agreement = RetailCustomer.Agreement;
		EndIf;
	Else
		FillPropertyValues(RetailCustomerInfo, GetPartnerInfoFromUserSettinfs());
	EndIf;
	
	RetailCustomerInfo.Insert("ManagerSegment",
	DocumentsServer.GetManagerSegmentByPartner(RetailCustomerInfo.Partner));
	RetailCustomerInfo.Insert("AgreementInfo",
	CatAgreementsServer.GetAgreementInfo(RetailCustomerInfo.Agreement));
	Return RetailCustomerInfo;
EndFunction

Function GetPartnerInfoFromUserSettinfs()
	Result = New Structure("Partner, LegalName, Agreement");
	FilterParameters = New Structure();
	FilterParameters.Insert("MetadataObject", Metadata.Documents.RetailSalesReceipt);
	UserSettings = UserSettingsServer.GetUserSettings(SessionParameters.CurrentUser, FilterParameters);
		
	Data = New Structure();
	For Each Row In UserSettings Do
		If Row.KindOfAttribute = Enums.KindsOfAttributes.Regular
			Or Row.KindOfAttribute = Enums.KindsOfAttributes.Common Then
			Data.Insert(Row.AttributeName, Row.Value);
		EndIf;
	EndDo;
		
	If Data.Property("Partner") Then
		Result.Partner = Data.Partner;
	EndIf;
	If Data.Property("LegalName") Then
		Result.LegalName = Data.LegalName;
	EndIf;
	If Data.Property("Agreement") Then
		Result.Agreement = Data.Agreement;
	EndIf;
	Return Result;
EndFunction
	

