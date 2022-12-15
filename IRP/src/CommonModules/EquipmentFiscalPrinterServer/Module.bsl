#Region Public

Function ShiftGetXMLOperation(CommonParameters) Export
	
	XMLWriter = New XMLWriter();
	XMLWriter.SetString("UTF-8");
	XMLWriter.WriteXMLDeclaration();
	XMLWriter.WriteStartElement("InputParameters");
	XMLWriter.WriteStartElement("Parameters");
	
	XMLWriter.WriteAttribute("CashierName", ?(Not IsBlankString(CommonParameters.CashierName), XMLString(CommonParameters.CashierName), "Administrator"));
	If Not IsBlankString(CommonParameters.CashierINN) Then
		XMLWriter.WriteAttribute("CashierINN" , XMLString(CommonParameters.CashierINN));
	EndIf;
	If Not IsBlankString(CommonParameters.SaleAddress) Then   
		XMLWriter.WriteAttribute("SaleAddress", XMLString(CommonParameters.АдресРасчетов));
	EndIf;
	If Not IsBlankString(CommonParameters.SaleLocation) Then  
		XMLWriter.WriteAttribute("SaleLocation", XMLString(CommonParameters.МестоРасчетов));
	EndIf;
	
	XMLWriter.WriteEndElement();
	XMLWriter.WriteEndElement();
	
	Return XMLWriter.Close();
	
EndFunction

#EndRegion
	