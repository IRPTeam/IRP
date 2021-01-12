Function Strings(LangCode = "") Export
	If IsBlankString(LangCode) Then
		LangCode = Metadata.DefaultLanguage.LanguageCode;
	EndIf;
	Strings = Localization.Strings(LangCode);
	
	If LangCode <> Metadata.DefaultLanguage.LanguageCode Then
		LocalizationStrings_df = Localization.Strings(Metadata.DefaultLanguage.LanguageCode);
		For Each StringsStructureItem In Strings Do
			If Not ValueIsFilled(StringsStructureItem.Value) Then
				Strings[StringsStructureItem.Key] = LocalizationStrings_df[StringsStructureItem.Key];
			EndIf;
		EndDo; 
	EndIf;
	
	Strings.Error_016 = StrTemplate(Strings.Error_016, Metadata.Documents.SalesOrder.Synonym);
	Strings.Error_017 = StrTemplate(Strings.Error_017, Metadata.Documents.GoodsReceipt.Synonym, Metadata.Documents.PurchaseInvoice.Synonym);
	Strings.Error_018 = StrTemplate(Strings.Error_018, Metadata.Documents.ShipmentConfirmation.Synonym, Metadata.Documents.SalesInvoice.Synonym);
	Strings.Error_023 = StrTemplate(Strings.Error_023, Metadata.Documents.InternalSupplyRequest.Synonym);
	Strings.Error_028 = StrTemplate(Strings.Error_028, Metadata.Documents.GoodsReceipt.Synonym, Metadata.Documents.PurchaseInvoice.Synonym);
	Strings.Error_052 = StrTemplate(Strings.Error_052, "%1", Metadata.Catalogs.Stores.Attributes.UseShipmentConfirmation.Synonym, Metadata.Documents.ShipmentConfirmation.Synonym);										
	Strings.Error_053 = StrTemplate(Strings.Error_053, "%1", Metadata.Catalogs.Stores.Attributes.UseGoodsReceipt.Synonym, Metadata.Documents.GoodsReceipt.Synonym);
	Strings.Error_056 = StrTemplate(Strings.Error_056, Metadata.Documents.SalesOrder.Synonym, Metadata.Documents.PurchaseOrder.Synonym);
	Strings.Error_057 = StrTemplate(Strings.Error_057, "%1", Metadata.Documents.CashTransferOrder.Synonym);
	Strings.Error_058 = StrTemplate(Strings.Error_058, "%1", Metadata.Documents.CashTransferOrder.Synonym);
	Strings.Error_059 = StrTemplate(Strings.Error_059, "%1", Metadata.Documents.CashTransferOrder.Synonym);
	Strings.Error_060 = StrTemplate(Strings.Error_060, "%1", Metadata.Documents.CashTransferOrder.Synonym);
	Strings.Error_064 = StrTemplate(Strings.Error_064, "%1", Metadata.Documents.ShipmentConfirmation.Synonym, Metadata.Documents.SalesOrder.Synonym);
	Strings.Error_075 = StrTemplate(Strings.Error_075, Metadata.Documents.PhysicalCountByLocation.Synonym);
	Strings.InfoMessage_006 = StrTemplate(Strings.InfoMessage_006, Metadata.Documents.PhysicalCountByLocation.Synonym);
	Strings.Title_00100 = StrTemplate(Strings.Title_00100, Metadata.Documents.ChequeBondTransaction.Synonym);
	
	Return Strings;
EndFunction

Function CatalogDescription(Ref, LangCode = "", AddInfo = Undefined) Export
	LangCode = ?(ValueIsFilled(LangCode), LangCode, LocalizationReuse.GetLocalizationCode());
	If Not UseMultiLanguage(Ref.Metadata().FullName(), LangCode, AddInfo) Then
		Return Strings(Ref);
	EndIf;
	
	UsersL = Ref["Description_" + LangCode];
	If ValueIsFilled(UsersL) Then
		Return UsersL;
	EndIf;
	
	If ValueIsFilled(Ref["Description_en"]) Then
		Return Ref["Description_en"];
	EndIf;
	
	Return StrTemplate(R().Error_002, LangCode);
EndFunction

Function CatalogDescriptionWithAddAttributes(Ref, LangCode = "", AddInfo = Undefined) Export
	LangCode = ?(ValueIsFilled(LangCode), LangCode, LocalizationReuse.UserLanguageCode());
	UsersL = New Array();
	For Each AddAttribute In Ref.AddAttributes Do
		If StrSplit(Ref.Metadata().FullName(),".")[0] = "Catalog" Then
			UsersL.Add(LocalizationReuse.CatalogDescription(AddAttribute.Value, LangCode, AddInfo));
		Else
			UsersL.Add(String(AddAttribute.Value));
		EndIf;
	EndDo;
	
	UsersLStr = StrConcat(UsersL, "/");
	If ValueIsFilled(UsersLStr) Then
		Return UsersLStr;
	EndIf;
	
	If Ref.Metadata() = Metadata.Catalogs.ItemKeys Or Ref.Metadata() = Metadata.Catalogs.PriceKeys Then
		If ValueIsFilled(Ref.Item) Then
			Return LocalizationServer.CatalogDescription(Ref.Item, LangCode, AddInfo);
		EndIf;
	EndIf;
	Return StrTemplate(R().Error_005, LangCode);
EndFunction

Function AllDescription(AddInfo = Undefined) Export
	Array = New Array;
	For Each Description In Metadata.CommonAttributes Do
		If StrStartsWith(Description.Name, "Description_") Then
			Array.Add(Description.Name);
		EndIf;
	EndDo;
	Return Array;
EndFunction

Function UseMultiLanguage(MetadataFullName, LangCode = "", AddInfo = Undefined) Export
	LangCode = ?(ValueIsFilled(LangCode), LangCode, LocalizationReuse.UserLanguageCode());
	MetadataFullName = StrReplace(MetadataFullName, "Manager.", ".");
	MetadataObject = Metadata.FindByFullName(MetadataFullName);
	DescriptionAttr = Metadata.CommonAttributes["Description_" + LangCode];
	Content = DescriptionAttr.Content.Find(MetadataObject);
	
	If NOT Content = Undefined Then
		If Content.Use = Metadata.ObjectProperties.CommonAttributeUse.Use
			Or (Content.Use = Metadata.ObjectProperties.CommonAttributeUse.Auto
				And DescriptionAttr.AutoUse = Metadata.ObjectProperties.CommonAttributeAutoUse.Use) Then
			Return True;
		EndIf;
	EndIf;
	
	Return False;
EndFunction

Function GetLocalizationCode(AddInfo = Undefined) Export
	Return TrimAll(SessionParameters.LocalizationCode);
EndFunction

Function FieldsListForDescriptions(Val Source) Export
	Fields = New Array;
	If Source = "CatalogManager.Currencies" Then
		Fields.Add("Code");
		Return Fields;
	ElsIf Source = "CatalogManager.PriceKeys" Then
		Fields.Add("Ref");
		Return Fields;
	ElsIf Source = "CatalogManager.IDInfoAddresses" Then
		Fields.Add("FullDescription");
		Return Fields;
	ElsIf NOT LocalizationReuse.UseMultiLanguage(Source) Then
		Fields.Add("Description");
		Return Fields;
	EndIf;
	For Each DescriptionName In AllDescription() Do
		Fields.Add(DescriptionName);
	EndDo;
	Return Fields;
EndFunction