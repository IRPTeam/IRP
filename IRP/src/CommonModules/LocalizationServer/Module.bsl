// @strict-types

// Strings.
// 
// Parameters:
//  LangCode - String - Lang code
//  LocalizationObject - CommonModule, ExternalDataProcessor -
// 
// Returns:
//  See Localization.Strings
Function LocalizationStrings(Val LangCode = "", LocalizationObject = Undefined) Export
	If IsBlankString(LangCode) Then
		LangCode = Metadata.DefaultLanguage.LanguageCode;
	EndIf;
	If LocalizationObject = Undefined Then
		Strings = Localization.Strings(LangCode);
	Else
		// @skip-check dynamic-access-method-not-found, statement-type-change
		Strings = LocalizationObject.Strings(LangCode); // Stucture
	EndIf;

	If LangCode <> Metadata.DefaultLanguage.LanguageCode Then
		If LocalizationObject = Undefined Then
			LocalizationStrings_df = Localization.Strings(Metadata.DefaultLanguage.LanguageCode);
		Else
			// @skip-check dynamic-access-method-not-found, statement-type-change
			LocalizationStrings_df = LocalizationObject.Strings(Metadata.DefaultLanguage.LanguageCode);
		EndIf;
		For Each StringsStructureItem In Strings Do
			If Not ValueIsFilled(StringsStructureItem.Value) Then
				Strings[StringsStructureItem.Key] = LocalizationStrings_df[StringsStructureItem.Key];
			EndIf;
		EndDo;
	EndIf;
	If LocalizationObject = Undefined Then
			
		Strings.Error_016 = StrTemplate(Strings.Error_016, Metadata.Documents.SalesOrder.Synonym);
		Strings.Error_017 = StrTemplate(Strings.Error_017, Metadata.Documents.GoodsReceipt.Synonym,
			Metadata.Documents.PurchaseInvoice.Synonym);
		Strings.Error_018 = StrTemplate(Strings.Error_018, Metadata.Documents.ShipmentConfirmation.Synonym,
			Metadata.Documents.SalesInvoice.Synonym);
		Strings.Error_023 = StrTemplate(Strings.Error_023, Metadata.Documents.InternalSupplyRequest.Synonym);
		Strings.Error_028 = StrTemplate(Strings.Error_028, Metadata.Documents.GoodsReceipt.Synonym,
			Metadata.Documents.PurchaseInvoice.Synonym);
		Strings.Error_052 = StrTemplate(Strings.Error_052, "%1",
			Metadata.Catalogs.Stores.Attributes.UseShipmentConfirmation.Synonym,
			Metadata.Documents.ShipmentConfirmation.Synonym);
		Strings.Error_053 = StrTemplate(Strings.Error_053, "%1",
			Metadata.Catalogs.Stores.Attributes.UseGoodsReceipt.Synonym, Metadata.Documents.GoodsReceipt.Synonym);
		Strings.Error_056 = StrTemplate(Strings.Error_056, Metadata.Documents.SalesOrder.Synonym,
			Metadata.Documents.PurchaseOrder.Synonym);
		Strings.Error_057 = StrTemplate(Strings.Error_057, "%1", Metadata.Documents.CashTransferOrder.Synonym);
		Strings.Error_058 = StrTemplate(Strings.Error_058, "%1", Metadata.Documents.CashTransferOrder.Synonym);
		Strings.Error_059 = StrTemplate(Strings.Error_059, "%1", Metadata.Documents.CashTransferOrder.Synonym);
		Strings.Error_060 = StrTemplate(Strings.Error_060, "%1", Metadata.Documents.CashTransferOrder.Synonym);
		Strings.Error_064 = StrTemplate(Strings.Error_064, "%1", Metadata.Documents.ShipmentConfirmation.Synonym,
			Metadata.Documents.SalesOrder.Synonym);
		Strings.Error_075 = StrTemplate(Strings.Error_075, Metadata.Documents.PhysicalCountByLocation.Synonym);
		Strings.InfoMessage_006 = StrTemplate(Strings.InfoMessage_006, Metadata.Documents.PhysicalCountByLocation.Synonym);
	
	EndIf;
	
	Return Strings;
EndFunction

// Catalog description.
// 
// Parameters:
//  Ref - CatalogRef - Ref
//  LangCode - String - Lang code
//  AddInfo - Undefined, Structure - Add info
// 
// Returns:
//  String - Catalog description
Function CatalogDescription(Val Ref, Val LangCode = "", AddInfo = Undefined) Export
	LangCode = ?(ValueIsFilled(LangCode), LangCode, LocalizationReuse.GetLocalizationCode());
	Presentation = "";
	TypeOfRef = TypeOf(Ref);
	If TypeOfRef = Type("String") Or TypeOfRef = Type("Date") Or TypeOfRef = Type("Number") Then
		Presentation = String(Ref);
	ElsIf Not UseMultiLanguage(Ref.Metadata().FullName(), LangCode, AddInfo) Then
		Presentation = String(Ref);
	ElsIf Not IsBlankString(String(Ref["Description_" + LangCode])) Then
		Presentation = String(Ref["Description_" + LangCode]);
	ElsIf Not IsBlankString(Ref["Description_en"]) Then
		Presentation = String(Ref["Description_en"]);
	Else
		Presentation = "";
	EndIf;

	Return Presentation;
EndFunction

// Catalog description with additional attributes.
// 
// Parameters:
//  Ref - CatalogRef - Ref
//  LangCode - String - Lang code
//  AddInfo - Undefined, Structure - Add info
// 
// Returns:
//  String - Catalog description
Function CatalogDescriptionWithAddAttributes(Val Ref, Val LangCode = "", AddInfo = Undefined) Export

	Presentation = "";
	LangCode = ?(ValueIsFilled(LangCode), LangCode, LocalizationReuse.UserLanguageCode());
	UsersL = New Array(); // Array Of String
	For Each AddAttribute In Ref.AddAttributes Do
		If StrSplit(Ref.Metadata().FullName(), ".")[0] = "Catalog" Then
			PresentationAttribute = LocalizationReuse.CatalogDescription(AddAttribute.Value, LangCode, AddInfo);
		Else
			PresentationAttribute = String(AddAttribute.Value);
		EndIf;
		If Not IsBlankString(PresentationAttribute) Then
			UsersL.Add(PresentationAttribute);
		EndIf;
	EndDo;

	If UsersL.Count() Then
		Presentation = StrConcat(UsersL, "/");
	ElsIf Ref.Metadata() = Metadata.Catalogs.ItemKeys Or Ref.Metadata() = Metadata.Catalogs.PriceKeys Then
		If ValueIsFilled(Ref.Item) And Not Ref.AddAttributes.Count() Then
			Presentation = CatalogDescription(Ref.Item, LangCode, AddInfo);
		EndIf;
	EndIf;
	Return Presentation;
EndFunction

// All description.
// 
// Parameters:
//  AddInfo - Undefined - Add info
// 
// Returns:
//  Array of String - All description
Function AllDescription(AddInfo = Undefined) Export
	Array = New Array(); // Array Of String
	For Each Description In Metadata.CommonAttributes Do
		If StrStartsWith(Description.Name, "Description_") Then
			Array.Add(Description.Name);
		EndIf;
	EndDo;
	Return Array;
EndFunction

// Use multi language.
// 
// Parameters:
//  MetadataFullName - String - Metadata full name
//  LangCode - String - Lang code
//  AddInfo - Undefined, Structure - Add info
// 
// Returns:
//  Boolean - Use multi language
Function UseMultiLanguage(Val MetadataFullName, Val LangCode = "", AddInfo = Undefined) Export
	LangCode = ?(ValueIsFilled(LangCode), LangCode, LocalizationReuse.UserLanguageCode());
	MetadataFullName = StrReplace(MetadataFullName, "Manager.", ".");
	MetadataObject = Metadata.FindByFullName(MetadataFullName);
	DescriptionAttr = Metadata.CommonAttributes["Description_" + LangCode];
	//@skip-check invocation-parameter-type-intersect
	Content = DescriptionAttr.Content.Find(MetadataObject);

	If Not Content = Undefined Then
		If Content.Use = Metadata.ObjectProperties.CommonAttributeUse.Use 
			Or (Content.Use = Metadata.ObjectProperties.CommonAttributeUse.Auto 
				And DescriptionAttr.AutoUse = Metadata.ObjectProperties.CommonAttributeAutoUse.Use) Then
			Return True;
		EndIf;
	EndIf;

	Return False;
EndFunction

// Get localization code.
// 
// Parameters:
//  AddInfo - Undefined - Add info
// 
// Returns:
//  String - Get localization code
Function GetLocalizationCode(AddInfo = Undefined) Export
	Return TrimAll(SessionParameters.LocalizationCode);
EndFunction

// Fields list for descriptions.
// 
// Parameters:
//  Source - String - Source
// 
// Returns:
//  Array of String - Fields list for descriptions
Function FieldsListForDescriptions(Val Source) Export
	Fields = New Array(); // Array Of String
	If Source = "CatalogManager.Currencies" Then
		Fields.Add("Code");
		Return Fields;
	ElsIf Source = "ChartOfAccountsManager.Basic" Then
		Fields.Add("Code");
		Return Fields;
	ElsIf Source = "CatalogManager.PriceKeys" Then
		Fields.Add("Ref");
		Return Fields;
	ElsIf Source = "CatalogManager.PrintInfo" Then
		Fields.Add("Description");
		Return Fields;	
	ElsIf Source = "CatalogManager.IDInfoAddresses" Then
		Fields.Add("FullDescription");
	ElsIf Not LocalizationReuse.UseMultiLanguage(Source) Then
		Fields.Add("Description");
		Return Fields;
	EndIf;
	For Each DescriptionName In AllDescription() Do
		Fields.Add(DescriptionName);
	EndDo;
	Return Fields;
EndFunction
