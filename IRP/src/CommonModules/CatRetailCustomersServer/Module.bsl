
Function GetRetailCustomerInfo(RetailCustomer, AddInfo = Undefined) Export
	RetailCustomerInfo = New Structure();
	RetailCustomerInfo.Insert("Partner"   , RetailCustomer.Partner);
	RetailCustomerInfo.Insert("LegalName" , RetailCustomer.LegalName);
	RetailCustomerInfo.Insert("Agreement" , RetailCustomer.Agreement);
	RetailCustomerInfo.Insert("ManagerSegment",
	DocumentsServer.GetManagerSegmentByPartner(RetailCustomer.Partner));
	RetailCustomerInfo.Insert("AgreementInfo",
	CatAgreementsServer.GetAgreementInfo(RetailCustomer.Agreement));
	Return RetailCustomerInfo;
EndFunction