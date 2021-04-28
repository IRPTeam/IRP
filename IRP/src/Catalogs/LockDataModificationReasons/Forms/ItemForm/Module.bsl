
#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
	
	FillTypes();
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
Procedure FillTypes()
	ValueList = Items.RuleListType.ChoiceList;
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
	ComparisonTypeArray = StrSplit("=,<>,<,<=,>,>=,IN,IN HIERARCHY,BETWEEN,IS NULL", ",");
	Items.RuleListComparisonType.ChoiceList.LoadValues(ComparisonTypeArray);
EndProcedure

&AtClient
Procedure RuleListAttributeStartChoice(Item, ChoiceData, StandardProcessing)
	ValueList = New ValueList;
	TypeOnChangeAtServer(ValueList);
	Items.RuleListAttribute.ChoiceList.Clear();
	
	For Each Row In ValueList Do
		Items.RuleListAttribute.ChoiceList.Add(Row.Value, Row.Presentation, , Row.Picture);
	EndDo;
EndProcedure

&AtClient
Procedure RuleListValueStartChoice(Item, ChoiceData, StandardProcessing)
	RowStructure = New Structure("SetValueAsCode, Attribute, Type");
	FillPropertyValues(RowStructure, Items.RuleList.CurrentData);
	AttributeOnChangeAtServer(RowStructure);
EndProcedure

&AtServer
Procedure TypeOnChangeAtServer(ChoiceData)
	Row = Object.RuleList.FindByID(Items.RuleList.CurrentRow);
	
	If IsBlankString(Row.Type) Then
		Row.Attribute = Undefined;
		Return;
	EndIf;
	MetadataType = Enums.MetadataTypes[StrSplit(Row.Type, ".")[0]];
	MetaItem = Metadata.FindByFullName(Row.Type);
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
		If CmAttribute.Content.Contains(Metadata.FindByFullName(Row.Type)) Then
			ChoiceData.Add("CommonAttribute." + CmAttribute.Name, 
				?(IsBlankString(CmAttribute.Synonym), CmAttribute.Name, CmAttribute.Synonym), , PictureLib.CommonAttributes);
		EndIf;
	EndDo;
EndProcedure


&AtServer
Procedure AddChild(MetaItem, AttributeChoiceList, DataType)

	If NOT MetaItem[DataType].Count() Then
		Return;
	EndIf;

	For Each AddChild In MetaItem[DataType] Do
		AttributeChoiceList.Add(DataType + "." + AddChild.Name, ?(IsBlankString(AddChild.Synonym), AddChild.Name, AddChild.Synonym), , PictureLib[DataType]);
	EndDo;
	
EndProcedure

&AtServer
Procedure AttributeOnChangeAtServer(RowStructure)
	
	If RowStructure.SetValueAsCode Then
		ThisObject.Items.RuleListValue.TypeRestriction = New TypeDescription("String");
		ThisObject.Items.RuleListValue.InputHint = String(R().S_032);
	Else
		If StrSplit(RowStructure.Attribute, ".")[0] = "CommonAttribute" Then
			ThisObject.Items.RuleListValue.TypeRestriction = Metadata.FindByFullName(RowStructure.Attribute).Type;
		Else
			ThisObject.Items.RuleListValue.TypeRestriction = Metadata.FindByFullName(RowStructure.Type)
					[StrSplit(RowStructure.Attribute, ".")[0]][StrSplit(RowStructure.Attribute, ".")[1]].Type;
		EndIf;
		ThisObject.Items.RuleListValue.InputHint = String(ThisObject.Items.RuleListValue.TypeRestriction);
	EndIf;
	
EndProcedure

#EndRegion
