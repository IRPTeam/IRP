&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.Ref = Parameters.Ref;

	DCSTemplate = IDInfoServer.GetDCSTemplate(ThisObject.Ref.PredefinedDataName);
	Address = PutToTempStorage(DCSTemplate);
	ThisObject.SettingsComposer.Initialize(New DataCompositionAvailableSettingsSource(Address));

	If Parameters.SavedSettings = Undefined Then
		ThisObject.SettingsComposer.LoadSettings(DCSTemplate.DefaultSettings);
	Else
		If TypeOf(Parameters.SavedSettings) = Type("Structure") And Parameters.SavedSettings.Property(
			"AddAttributesMap") Then
			IDInfoServer.ReplaceItemsFromFilter(Parameters.SavedSettings);
			ThisObject.SettingsComposer.LoadSettings(Parameters.SavedSettings.Settings);
		Else
			ThisObject.SettingsComposer.LoadSettings(Parameters.SavedSettings);
		EndIf;
	EndIf;
EndProcedure

&AtClient
Procedure SettingsFilterOnActivateRow(Item)
	Return;
EndProcedure

&AtClient
Procedure SettingsFilterSelection(Item, RowSelected, Field, StandardProcessing)
	Return;
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close(Undefined);
EndProcedure

&AtClient
Procedure Ok(Command)
	Close(PrepareResult());
EndProcedure

&AtServer
Function PrepareResult()
	Settings = ThisObject.SettingsComposer.GetSettings();

	AddAttributesMap = New Map();
	ArrayOfFields = New Array();
	ExtractItemsFromFilter(Settings.Filter.Items, ArrayOfFields);

	For Each Row In ArrayOfFields Do
		If Not IsObjectAttribute(Row, ThisObject.Ref) Then
			AddAttributesMap.Insert(Row, GetAddAttributeBuPresentation(Row));
		EndIf;
	EndDo;

	Result = New Structure();
	Result.Insert("Settings", Settings);
	Result.Insert("AddAttributesMap", AddAttributesMap);
	Return Result;
EndFunction

&AtServer
Procedure ExtractItemsFromFilter(Items, ArrayOfFields)
	NeedPartsCount = 2;
	For Each Field In Items Do
		If TypeOf(Field) = Type("DataCompositionFilterItemGroup") Then
			ExtractItemsFromFilter(Field.Items, ArrayOfFields);
		EndIf;
		If TypeOf(Field) = Type("DataCompositionFilterItem") Then
			ArrayOfParts = StrSplit(String(Field.LeftValue), ".");
			If ArrayOfParts.Count() >= NeedPartsCount Then
				ArrayOfFields.Add(ArrayOfParts[1]);
			EndIf;
		EndIf;
	EndDo;
EndProcedure

&AtServer
Function IsObjectAttribute(AttributeName, IDInfoSetRef)
	ObjectMetadata = Undefined;
	If StrStartsWith(Ref.PredefinedDataName, "Catalog") Then
		ObjectMetadata = Metadata.Catalogs[StrReplace(IDInfoSetRef.PredefinedDataName, "Catalog_", "")];
	ElsIf StrStartsWith(Ref.PredefinedDataName, "Document") Then
		ObjectMetadata = Metadata.Documents[StrReplace(IDInfoSetRef.PredefinedDataName, "Document_", "")];
	Else
		Raise R().Exc_001;
	EndIf;
	Return ObjectMetadata.Attributes.Find(AttributeName) <> Undefined;
EndFunction

&AtServer
Function GetAddAttributeBuPresentation(Val Presentation)
	Query = New Query();
	Query.Text =
	"SELECT
	|	AddAttributeAndProperty.Ref
	|FROM
	|	ChartOfCharacteristicTypes.AddAttributeAndProperty AS AddAttributeAndProperty
	|WHERE
	|	AddAttributeAndProperty.Description_en = &Description";
	Query.Text = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(Query.Text, "AddAttributeAndProperty");
	Presentation = StrReplace(Presentation, "[", "");
	Presentation = StrReplace(Presentation, "]", "");
	Query.SetParameter("Description", TrimAll(Presentation));

	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return QuerySelection.Ref;
	Else
		Return Undefined;
	EndIf;
EndFunction

&AtClient
Procedure Verify(Command)
	VerifyAtServer();
EndProcedure

&AtServer
Procedure VerifyAtServer()
	DCSTemplate = IDInfoServer.GetDCSTemplate(ThisObject.Ref.PredefinedDataName);
	Settings = ThisObject.SettingsComposer.GetSettings();
	Result = IDInfoServer.GetRefsByCondition(DCSTemplate, Settings);
	ThisObject.ResultTable.Load(Result);
EndProcedure