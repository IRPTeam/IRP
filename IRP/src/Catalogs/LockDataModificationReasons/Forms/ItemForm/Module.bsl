#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);

	RuleListTypeList = FillTypes();
	For Each Row In RuleListTypeList Do
		Items.RuleListType.ChoiceList.Add(Row.Value, Row.Presentation, , Row.Picture);
	EndDo;

	ComparisonTypeArray = StrSplit("=,<>,<,<=,>,>=,IN,IN HIERARCHY,BETWEEN,IS NULL", ",");
	Items.RuleListComparisonType.ChoiceList.LoadValues(ComparisonTypeArray);
	Items.ComparisonType.ChoiceList.LoadValues(ComparisonTypeArray);

	If Object.SetOneRuleForAllObjects Then
		If Object.RuleList.Count() Then
			FillAttributeListHead(Items.Attribute.ChoiceList);
		EndIf;
	EndIf;
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure ForAllUsersOnChange(Item)
	SetVisible();
EndProcedure
&AtClient
Procedure OnOpen(Cancel)
	SetVisible();
EndProcedure
&AtClient
Procedure SetOneRuleForAllObjectsOnChange(Item)
	SetVisible();
EndProcedure

&AtClient
Procedure ValueStartChoice(Item, ChoiceData, StandardProcessing)
	If Object.RuleList.Count() Then
		FillValueTypeHead(Object.RuleList[0].Type);
	EndIf;
EndProcedure

#EndRegion

#Region Privat

&AtClient
Procedure SetVisible()
	Items.AccessGroupList.Visible = Not Object.ForAllUsers;
	Items.UserList.Visible = Not Object.ForAllUsers;
	Items.RuleListAttribute.Visible = Not Object.SetOneRuleForAllObjects;
	Items.RuleListComparisonType.Visible = Not Object.SetOneRuleForAllObjects;
	Items.RuleListValue.Visible = Not Object.SetOneRuleForAllObjects;
	Items.RuleListSetValueAsCode.Visible = Not Object.SetOneRuleForAllObjects;
	Items.GroupRuleSettings.Visible = Object.SetOneRuleForAllObjects;
EndProcedure
#EndRegion

#Region AddAttributes

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject);
EndProcedure

#EndRegion

#Region FillData

&AtServer
Function FillTypes()
	ValueList = New ValueList();
	For Each Cat In Metadata.Catalogs Do
		ValueList.Add(Cat.FullName(), Cat.Synonym, , PictureLib.Catalog);
	EndDo;
	For Each Doc In Metadata.Documents Do
		ValueList.Add(Doc.FullName(), Doc.Synonym, , PictureLib.Document);
	EndDo;
	For Each IR In Metadata.InformationRegisters Do
		ValueList.Add(IR.FullName(), IR.Synonym, , PictureLib.InformationRegister);
	EndDo;
	For Each AR In Metadata.AccumulationRegisters Do
		ValueList.Add(AR.FullName(), AR.Synonym, , PictureLib.AccumulationRegister);
	EndDo;
	Return ValueList;
EndFunction

&AtClient
Procedure RuleListAttributeStartChoice(Item, ChoiceData, StandardProcessing)
	ValueList = New ValueList();
	FillAttributeList(ValueList, Items.RuleList.CurrentData.Type);
	Items.RuleListAttribute.ChoiceList.Clear();
	For Each Row In ValueList Do
		Items.RuleListAttribute.ChoiceList.Add(Row.Value, Row.Presentation, , Row.Picture);
	EndDo;
EndProcedure

&AtClient
Procedure AttributeStartChoice(Item, ChoiceData, StandardProcessing)
	ValueList = New ValueList();
	FillAttributeListHead(ValueList);
	Items.Attribute.ChoiceList.Clear();
	For Each Row In ValueList Do
		Items.Attribute.ChoiceList.Add(Row.Value, Row.Presentation, , Row.Picture);
	EndDo;
EndProcedure

&AtClient
Procedure RuleListValueStartChoice(Item, ChoiceData, StandardProcessing)
	RowStructure = New Structure("SetValueAsCode, Attribute, Type");
	FillPropertyValues(RowStructure, Items.RuleList.CurrentData);
	FillValueType(RowStructure);
EndProcedure

&AtServer
Procedure FillAttributeListHead(ChoiceData)

	VT = New ValueTable();
	VT.Columns.Add("Attribute", New TypeDescription("String"));
	VT.Columns.Add("Count", New TypeDescription("Number"));
	ValueList = New ValueList();
	For Each Row In Object.RuleList Do
		ValueList = New ValueList();
		FillAttributeList(ValueList, Row.Type);
		For Each VLRow In ValueList Do
			VTRow = VT.Add();
			VTRow.Attribute = VLRow.Value;
			VTRow.Count = 1;
		EndDo;
	EndDo;

	VT.GroupBy("Attribute", "Count");
	For Each AttributeName In VT.FindRows(New Structure("Count", Object.RuleList.Count())) Do
		Row = ValueList.FindByValue(AttributeName.Attribute);
		ChoiceData.Add(Row.Value, Row.Presentation, , Row.Picture);
	EndDo;
EndProcedure

&AtServer
Procedure FillAttributeList(ChoiceData, DataType)
	MetadataType = Enums.MetadataTypes[StrSplit(DataType, ".")[0]];
	MetaItem = Metadata.FindByFullName(DataType);
	If MetadataInfo.hasAttributes(MetadataType) Then
		AddChild(MetaItem, ChoiceData, "Attributes");
	EndIf;
	If MetadataInfo.hasDimensions(MetadataType) Then
		AddChild(MetaItem, ChoiceData, "Dimensions");
	EndIf;
	If MetadataInfo.hasStandardAttributes(MetadataType) Then
		AddChild(MetaItem, ChoiceData, "StandardAttributes");
	EndIf;
	If MetadataInfo.hasRecalculations(MetadataType) Then
		AddChild(MetaItem, ChoiceData, "Recalculations");
	EndIf;
	If MetadataInfo.hasAccountingFlags(MetadataType) Then
		AddChild(MetaItem, ChoiceData, "AccountingFlags");
	EndIf;

	For Each CmAttribute In Metadata.CommonAttributes Do
		If Not CmAttribute.Content.Find(Metadata.FindByFullName(DataType)) = Undefined And CmAttribute.Content.Find(
			Metadata.FindByFullName(DataType)).Use = Metadata.ObjectProperties.CommonAttributeUse.Use Then
			ChoiceData.Add("CommonAttribute." + CmAttribute.Name, ?(IsBlankString(CmAttribute.Synonym),
				CmAttribute.Name, CmAttribute.Synonym), , PictureLib.CommonAttributes);
		EndIf;
	EndDo;
EndProcedure
&AtServer
Procedure AddChild(MetaItem, AttributeChoiceList, DataType)

	If Not MetaItem[DataType].Count() Then
		Return;
	EndIf;

	For Each AddChild In MetaItem[DataType] Do
		AttributeChoiceList.Add(DataType + "." + AddChild.Name, ?(IsBlankString(AddChild.Synonym), AddChild.Name,
			AddChild.Synonym), , PictureLib[DataType]);
	EndDo;

EndProcedure

&AtServer
Procedure FillValueType(RowStructure)

	If RowStructure.SetValueAsCode Then
		ThisObject.Items.RuleListValue.TypeRestriction = New TypeDescription("String");
		ThisObject.Items.RuleListValue.InputHint = String(R().S_032);
	Else
		If StrSplit(RowStructure.Attribute, ".")[0] = "CommonAttribute" Then
			ThisObject.Items.RuleListValue.TypeRestriction = Metadata.FindByFullName(RowStructure.Attribute).Type;
		Else
			ThisObject.Items.RuleListValue.TypeRestriction = Metadata.FindByFullName(RowStructure.Type)[StrSplit(
				RowStructure.Attribute, ".")[0]][StrSplit(RowStructure.Attribute, ".")[1]].Type;
		EndIf;
		ThisObject.Items.RuleListValue.InputHint = String(ThisObject.Items.RuleListValue.TypeRestriction);
	EndIf;

EndProcedure

&AtServer
Procedure FillValueTypeHead(Type)

	If Object.SetValueAsCode Then
		ThisObject.Items.Value.TypeRestriction = New TypeDescription("String");
		ThisObject.Items.Value.InputHint = String(R().S_032);
	Else
		If StrSplit(Object.Attribute, ".")[0] = "CommonAttribute" Then
			ThisObject.Items.Value.TypeRestriction = Metadata.FindByFullName(Object.Attribute).Type;
		Else
			ThisObject.Items.Value.TypeRestriction = Metadata.FindByFullName(Type)[StrSplit(Object.Attribute,
				".")[0]][StrSplit(Object.Attribute, ".")[1]].Type;
		EndIf;
		ThisObject.Items.Value.InputHint = String(ThisObject.Items.Value.TypeRestriction);
	EndIf;

EndProcedure

#EndRegion