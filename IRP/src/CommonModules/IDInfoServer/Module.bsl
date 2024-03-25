Procedure OnCreateAtServer(Form, GroupNameForPlacement, AddInfo = Undefined) Export
	CreateFormControls(Form, GroupNameForPlacement, AddInfo);
EndProcedure

Procedure AfterWriteAtServer(Form, CurrentObject, WriteParameters, AddInfo = Undefined) Export
	HaveAttribute = False;
	ArrayOfAllAttributes = Form.GetAttributes();
	For Each Row In ArrayOfAllAttributes Do
		If Row.Name = "ListOfIDInfoAttributes" Then
			HaveAttribute = True;
			Break;
		EndIf;
	EndDo;

	If Not HaveAttribute Then
		Return;
	EndIf;

	ArrayOfAttributes = StrSplit(Form["ListOfIDInfoAttributes"], ",");
	For Each AttributeName In ArrayOfAttributes Do
		If Not ValueIsFilled(AttributeName) Then
			Continue;
		EndIf;

		UpdateIDInfoTypeValue(CurrentObject.Ref, GetIDInfoRefByUniqueID(NameToUniqueId(AttributeName)),
			Form[AttributeName], Form[AttributeName + "_Period"], Undefined);
	EndDo;
EndProcedure

Procedure CreateFormControls(Form, GroupNameForPlacement = "GroupContactInformation", AddInfo = Undefined) Export
	
	// Clear form
	NotSavedAttrValues = New Structure();
	If CommonFunctionsServer.FormHaveAttribute(Form, "ListOfIDInfoAttributes") Then
		ArrayForDelete = New Array();
		ArrayForDelete.Add("ListOfIDInfoAttributes");
		For Each AttrName In StrSplit(Form.ListOfIDInfoAttributes, ",") Do
			If Not ValueIsFilled(AttrName) Then
				Continue;
			EndIf;
			ArrayForDelete.Add(AttrName);
			ArrayForDelete.Add(AttrName + "_Period");
			NotSavedAttrValues.Insert(AttrName, Form[AttrName]);
			NotSavedAttrValues.Insert(AttrName + "_Period", Form[AttrName + "_Period"]);
			
			Form.Items.Delete(Form.Items[AttrName]);
		EndDo;
		If ArrayForDelete.Count() Then
			Form.ChangeAttributes( , ArrayForDelete);
		EndIf;
	EndIf;

	Attributes = New Array();
	FormAttributesInfo = New Array();
	SetName = GetSetName(Form.Object.Ref, AddInfo);
	ObjectAttributes = ObjectAttributes(Form.Object.Ref, SetName, AddInfo);

	ArrayOfNames = New Array();

	For Each Row In ObjectAttributes Do
		AttributeInfo = AttributeAndPropertyInfo(Row.IDInfoType, AddInfo);
		Attributes.Add(New FormAttribute(AttributeInfo.Name, AttributeInfo.Type, , AttributeInfo.Title, AttributeInfo.StoredData));
		Attributes.Add(New FormAttribute(AttributeInfo.Name + "_Period", New TypeDescription("Date")));
		FormAttributesInfo.Add(AttributeInfo);
		ArrayOfNames.Add(AttributeInfo.Name);
	EndDo;

	Attributes.Add(New FormAttribute("ListOfIDInfoAttributes", New TypeDescription("String")));
	Form.ChangeAttributes(Attributes);

	Form["ListOfIDInfoAttributes"] = StrConcat(ArrayOfNames, ",");

	Query = New Query();
	Query.Text =
	"SELECT
	|	IDInfoSliceLast.Period,
	|	IDInfoSliceLast.Object,
	|	IDInfoSliceLast.IDInfoType,
	|	IDInfoSliceLast.Value,
	|	IDInfoSliceLast.Info,
	|	IDInfoSliceLast.Country
	|FROM
	|	InformationRegister.IDInfo.SliceLast AS IDInfoSliceLast
	|WHERE
	|	IDInfoSliceLast.Object = &Object";
	Query.SetParameter("Object", Form.Object.Ref);
	QueryResult = Query.Execute();
	IDInfoValueTable = QueryResult.Unload();

	For Each Row In IDInfoValueTable Do
		AttributeInfo = AttributeAndPropertyInfo(Row.IDInfoType, AddInfo);
		If NotSavedAttrValues.Property(AttributeInfo.Name) And ValueIsFilled(NotSavedAttrValues[AttributeInfo.Name]) Then
			Form[AttributeInfo.Name] = NotSavedAttrValues[AttributeInfo.Name];
			Continue;
		EndIf;
		StructureOfValues = New Structure();
		StructureOfValues.Insert(AttributeInfo.Name, Row.Value);
		StructureOfValues.Insert(AttributeInfo.Name + "_Period", Row.Period);
		
		FillPropertyValues(Form, StructureOfValues);
	EndDo;

	For Each AttrInfo In FormAttributesInfo Do
		NewFormElement = Form.Items.Add(AttrInfo.Name, Type("FormField"), Form.Items[GroupNameForPlacement]);
		NewFormElement.DataPath = AttrInfo.Path;
		NewFormElement.Type = FormFieldType.InputField;
		NewFormElement.ReadOnly = AttrInfo.Ref.ReadOnly;
		NewFormElement.OpenButton = True;

		NewFormElement.SetAction("Opening", "IDInfoOpening");
	EndDo;
EndProcedure

Function GetSetName(Ref, AddInfo = Undefined) Export
	Return StrReplace(Ref.Metadata().FullName(), ".", "_");
EndFunction

Function ObjectAttributes(Ref, SetName, AddInfo = Undefined) Export
	AllItems = Catalogs.IDInfoSets[SetName].IDInfoTypes;
	Return GetCollectionOfIDInfo(Ref, AllItems, SetName, AddInfo);
EndFunction

Function GetCollectionOfIDInfo(Ref, AllItems, SetName, AddInfo = Undefined)
	ArrayOfCollection = New Array();
	Template = GetDCSTemplate(SetName, AddInfo);
	For Each Row In AllItems Do
		If Not Row.IDInfoType.ShowOnForm Then
			Continue;
		EndIf;
		If Row.IsConditionSet Then
			StructureOfCondition = Row.Condition.Get();
			If StructureOfCondition.Property("AddAttributesMap") Then
				ReplaceItemsFromFilter(StructureOfCondition);
			EndIf;

			NewFilter = StructureOfCondition.Settings.Filter.Items.Add(Type("DataCompositionFilterItem"));
			LeftValue = New DataCompositionField("Ref");
			NewFilter.LeftValue = LeftValue;
			NewFilter.Use = True;
			NewFilter.ComparisonType = DataCompositionComparisonType.Equal;
			NewFilter.RightValue = Ref;
			RefsByConditions = AddAttributesAndPropertiesServer.GetRefsByCondition(Template, StructureOfCondition.Settings, AddInfo);
			If RefsByConditions.Count() Then
				ArrayOfCollection.Add(Row);
			EndIf;
		Else
			ArrayOfCollection.Add(Row);
		EndIf;
	EndDo;
	Return ArrayOfCollection;
EndFunction

Procedure ReplaceItemsFromFilter(StructureOfCondition) Export
	For Each Field In StructureOfCondition.Settings.Filter.Items Do
		If TypeOf(Field) = Type("DataCompositionFilterItemGroup") Then
			ReplaceItemsFromFilter(Field.Items);
		EndIf;
		If TypeOf(Field) = Type("DataCompositionFilterItem") Then
			ArrayOfParts = StrSplit(String(Field.LeftValue), ".");
			NeedCountOfParts = 2;
			If ArrayOfParts.Count() >= NeedCountOfParts Then
				NewField = New DataCompositionField(ArrayOfParts[0] + "." + "[" + String(
					StructureOfCondition.AddAttributesMap.Get(ArrayOfParts[1])) + "]");
				Field.LeftValue = NewField;
			EndIf;
		EndIf;
	EndDo;
EndProcedure

Function GetDCSTemplate(PredefinedDataName, AddInfo = Undefined) Export
	If StrStartsWith(PredefinedDataName, "Catalog") Then
		TableName = StrReplace(PredefinedDataName, "_", ".");
		Template = Catalogs.IDInfoSets.GetTemplate("DCS_Catalog");
	ElsIf StrStartsWith(PredefinedDataName, "Document") Then
		TableName = StrReplace(PredefinedDataName, "_", ".");
		Template = Catalogs.IDInfoSets.GetTemplate("DCS_Document");
	Else
		Raise R().Error_004;
	EndIf;
	Template.DataSets[0].Query = StrTemplate(Template.DataSets[0].Query, TableName);
	Return Template;
EndFunction

Function AttributeAndPropertyInfo(AttributeProperty, AddInfo = Undefined) Export
	Result = New Structure();
	Name = UniqueIdToName(AttributeProperty.UniqueID, AddInfo);
	Result.Insert("Ref", AttributeProperty);
	Result.Insert("Name", Name);
	Result.Insert("Type", AttributeProperty.ValueType);
	Result.Insert("Path", Name);
	Result.Insert("Title", String(AttributeProperty));
	Result.Insert("StoredData", True);
	Return Result;
EndFunction

Function UniqueIdToName(UniqueID, AddInfo = Undefined)
	Return "_" + StrReplace(UniqueID, " ", "");
EndFunction

Function NameToUniqueId(Name, AddInfo = Undefined)
	Return Mid(Name, 2);
EndFunction

Function GetCountryByIDInfoType(IDInfoTypeRef, Country, UUIDForSettings, AddInfo = Undefined) Export
	ArrayOfCountry = New Array();
	For Each Row In IDInfoTypeRef.ExternalDataProcess Do
		If ValueIsFilled(Country) And Row.Country <> Country Then
			Continue;
		EndIf;
		Structure = New Structure();
		Structure.Insert("Country", Row.Country);
		Structure.Insert("ExternalDataProc", Row.ExternalDataProc);
		Structure.Insert("Settings", PutToTempStorage(Row.Settings.Get(), UUIDForSettings));
		ArrayOfCountry.Add(Structure);
	EndDo;
	If Not ArrayOfCountry.Count() Then
		For Each Row In IDInfoTypeRef.ExternalDataProcess Do
			If Not ValueIsFilled(Row.Country) Then
				Structure = New Structure();
				Structure.Insert("Country", Country);
				Structure.Insert("ExternalDataProc", Row.ExternalDataProc);
				Structure.Insert("Settings", PutToTempStorage(Row.Settings.Get(), UUIDForSettings));
				ArrayOfCountry.Add(Structure);
			EndIf;
		EndDo;
	EndIf;
	Return ArrayOfCountry;
EndFunction

Function GetCountryFromValues(Ref, ArrayOfIDInfoTypes, AddInfo = Undefined) Export
	Values = GetIDInfoTypeValues(Ref, ArrayOfIDInfoTypes);
	Country = Catalogs.Countries.EmptyRef();
	For Each Row In Values Do
		If ValueIsFilled(Row.Country) Then
			Country = Row.Country;
			Break;
		EndIf;
	EndDo;
	Return Country;
EndFunction

Function GetIDInfoRefByUniqueID(UniqueID, AddInfo = Undefined) Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	IDInfoTypes.Ref AS Ref
	|FROM
	|	ChartOfCharacteristicTypes.IDInfoTypes AS IDInfoTypes
	|WHERE
	|	IDInfoTypes.UniqueID = &UniqueID";

	Query.SetParameter("UniqueID", UniqueID);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return QuerySelection.Ref;
	Else
		Raise StrTemplate("Not found IDInfo by name: %1", UniqueID);
	EndIf;
EndFunction

Function GetRelatedIDInfoTypes(IDInfoType, Ref, AddInfo = Undefined) Export

	ArrayOfIDInfoTypes = New Array();
	For Each Row In IDInfoType.RelatedValues Do
		ArrayOfIDInfoTypes.Add(Row.IDInfoType);
	EndDo;

	IDInfoTypeValues = GetIDInfoTypeValues(Ref, ArrayOfIDInfoTypes);

	ArrayOfResult = New Array();
	For Each Row In IDInfoTypeValues Do
		Structure = New Structure();
		Structure.Insert("Value", Row.Value);
		Structure.Insert("IDInfoType", Row.IDInfoType);
		Structure.Insert("Country", Row.Country);
		ArrayOfResult.Add(Structure);
	EndDo;
	Return ArrayOfResult;
EndFunction

Function GetIDInfoTypeValues(Ref, ArrayOfIDInfoTypes = Undefined, AddInfo = Undefined) Export

	SetName = StrReplace(Ref.Metadata().FullName(), ".", "_");
	SetRef = Catalogs.IDInfoSets[SetName];

	Query = New Query();
	Query.Text =
	"SELECT
	|	IDInfoTypes.IDInfoType AS IDInfoType
	|INTO IDInfo
	|FROM
	|	Catalog.IDInfoSets.IDInfoTypes AS IDInfoTypes
	|WHERE
	|	IDInfoTypes.Ref = &SetRef
	|	AND CASE
	|		WHEN &Filter_ArrayOfIDInfoTypes
	|			THEN IDInfoTypes.IDInfoType IN (&ArrayOfIDInfoTypes)
	|		ELSE TRUE
	|	END
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	IDInfoSliceLast.Value AS Value,
	|	IDInfo.IDInfoType AS IDInfoType,
	|	IDInfoSliceLast.Country AS Country,
	|	IDInfoSliceLast.Period
	|FROM
	|	IDInfo AS IDInfo
	|		LEFT JOIN InformationRegister.IDInfo.SliceLast AS IDInfoSliceLast
	|		ON IDInfo.IDInfoType = IDInfoSliceLast.IDInfoType
	|		AND (IDInfoSliceLast.Object = &Object)";

	Query.SetParameter("Object", Ref);
	Query.SetParameter("SetRef", SetRef);

	If ArrayOfIDInfoTypes = Undefined Then
		Query.SetParameter("Filter_ArrayOfIDInfoTypes", False);
		Query.SetParameter("ArrayOfIDInfoTypes", New Array());
	Else
		Query.SetParameter("Filter_ArrayOfIDInfoTypes", True);
		Query.SetParameter("ArrayOfIDInfoTypes", ArrayOfIDInfoTypes);
	EndIf;

	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();

	Return QueryTable;
EndFunction

Function GetIDInfoTypeValue(Ref, ArrayOfIDInfoTypes, AddInfo = Undefined) Export
	Values = GetIDInfoTypeValues(Ref, ArrayOfIDInfoTypes);
	If Values.Count() Then
		Result = New Structure();
		Result.Insert("Period" , Values[0].Period);
		Result.Insert("Value"  , Values[0].Value);
		Return Result;
	EndIf;
	Return Undefined;
EndFunction

Procedure SaveIDInfoTypeValues(Ref, ValueTable, AddInfo = Undefined) Export

	_Period = CommonFunctionsServer.GetCurrentSessionDate();
	RecordSet = InformationRegisters.IDInfo.CreateRecordSet();
	RecordSet.Filter.Object.Set(Ref);
	RecordSet.Filter.Period.Set(_Period);
	ValueTable.Columns.Add("Object");
	ValueTable.FillValues(Ref, "Object");

	ArrayForDelete = New Array();
	For Each Row In ValueTable Do
		If Not ValueIsFilled(Row.Value) Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;
	For Each Item In ArrayForDelete Do
		ValueTable.Delete(Item);
	EndDo;

	RecordSet.Load(ValueTable);
	For Each Record In RecordSet Do
		Record.Period = _Period;
	EndDo;
	RecordSet.Write();
EndProcedure

Procedure UpdateIDInfoTypeValue(Ref, IDInfoType, Value, Period, Country, AddInfo = Undefined) Export
	
	_Period = ?(ValueIsFilled(Period), Period, Date(2000, 01, 01));
	
	RecordSet = InformationRegisters.IDInfo.CreateRecordSet();
	RecordSet.Filter.Object.Set(Ref);
	RecordSet.Filter.IDInfoType.Set(IDInfoType);
	RecordSet.Filter.Period.Set(_Period);
	
	tmpCountry = Undefined;

	RecordSet.Read();
	If RecordSet.Count() Then
		Record = RecordSet[0];
		tmpCountry = Record.Country;
	Else
		Record = RecordSet.Add();
		tmpCountry = Country;
	EndIf;
	Record.Object     = Ref;
	Record.IDInfoType = IDInfoType;
	Record.Period     = _Period;
	Record.Value      = Value;
	Record.Country    = tmpCountry;
	
	RecordSet.Write();
EndProcedure

Procedure EndEditIDInfo(Ref, Result, Parameters, AddInfo = Undefined) Export
	Period = Undefined;
	If Result.Property("Period") Then
		Period = Result.Period;
	EndIf;
	UpdateIDInfoTypeValue(Ref, Parameters.IDInfoType, Result.Value, Period, Parameters.Country);
	If IsUpdateIDInfoTypeValue(Result) Then
		UpdateIDInfoTypeValue(Ref, Result.StructuredAddress, Result.StructuredAddressRef, Period, Parameters.Country);
	EndIf;
EndProcedure

Function IsUpdateIDInfoTypeValue(Result)
	Return Result.Property("StructuredAddressRef") 
		And Result.Property("StructuredAddress") 
		And ValueIsFilled(Result.StructuredAddressRef) 
		And ValueIsFilled(Result.StructuredAddress);
EndFunction