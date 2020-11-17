
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	For Each Cat In Metadata.Catalogs Do
		Items.Type.ChoiceList.Add(Cat.FullName(), Cat.Synonym, , PictureLib.Catalog);
	EndDo;
	For Each Doc In Metadata.Documents Do
		Items.Type.ChoiceList.Add(Doc.FullName(), Doc.Synonym, , PictureLib.Document);
	EndDo;
	For Each IR In Metadata.InformationRegisters Do
		Items.Type.ChoiceList.Add(IR.FullName(), IR.Synonym, , PictureLib.InformationRegister);
	EndDo;
	For Each AR In Metadata.AccumulationRegisters Do
		Items.Type.ChoiceList.Add(AR.FullName(), AR.Synonym, , PictureLib.AccumulationRegister);
	EndDo;
	ComparisonTypeArray = StrSplit("=,<>,<,<=,>,>=,IN,IN HIERARCHY,BETWEEN,IS NULL", ",");
	Items.ComparisonType.ChoiceList.LoadValues(ComparisonTypeArray);
	TypeOnChangeAtServer();
EndProcedure

&AtClient
Procedure TypeOnChange(Item)
	TypeOnChangeAtServer();
	AttributeOnChangeAtServer();
EndProcedure

&AtServer
Procedure TypeOnChangeAtServer()
	If IsBlankString(Record.Type) Then
		Record.Attribute = Undefined;
		Return;
	EndIf;
	MetadataType = Enums.MetadataTypes[StrSplit(Record.Type,".")[0]];
	MetaItem = Metadata.FindByFullName(Record.Type);
	If MetadataInfo.hasAttributes(MetadataType) Then
		AddChild(MetaItem, Items.Attribute.ChoiceList, "Attributes");
	EndIf;
	If MetadataInfo.hasDimensions(MetadataType) Then
		AddChild(MetaItem, Items.Attribute.ChoiceList, "Dimensions");
	EndIf;
	If MetadataInfo.hasStandardAttributes(MetadataType) Then
		AddChild(MetaItem, Items.Attribute.ChoiceList, "StandardAttributes");
	EndIf;	
	If MetadataInfo.hasRecalculations(MetadataType) Then
		AddChild(MetaItem, Items.Attribute.ChoiceList, "Recalculations");
	EndIf;
	If MetadataInfo.hasAccountingFlags(MetadataType) Then
		AddChild(MetaItem, Items.Attribute.ChoiceList, "AccountingFlags");
	EndIf;

	For Each CmAttribute In Metadata.CommonAttributes Do
		If CmAttribute.Content.Contains(Record.Type) Then
			Items.Attribute.ChoiceList.Add("CommonAttributes." + CmAttribute.Name, 
				?(IsBlankString(CmAttribute.Synonym), CmAttribute.Name, CmAttribute.Synonym), , PictureLib.Attribute);
		EndIf;
	EndDo;
EndProcedure

&AtServer
Procedure AddChild(MetaItem, AttributeChoiceList, DataType)

	If NOT MetaItem[DataType].Count() Then
		Return;
	EndIf;

	For Each AddChild In MetaItem[DataType] Do
		AttributeChoiceList.Add(DataType + "." + AddChild.Name, ?(IsBlankString(AddChild.Synonym), AddChild.Name, AddChild.Synonym));
	EndDo;
	
EndProcedure

&AtClient
Procedure AttributeOnChange(Item)
	AttributeOnChangeAtServer();
EndProcedure

&AtServer
Procedure AttributeOnChangeAtServer()
	If IsBlankString(Record.Attribute) Then
		Record.Value = Undefined;
		Return;
	EndIf;
	If StrSplit(Record.Attribute, ".")[0] = "CommonAttributes" Then
		Items.Value.TypeRestriction = Metadata.FindByFullName(Record.Attribute).Type;
	Else
		Items.Value.TypeRestriction = Metadata.FindByFullName(Record.Type)
				[StrSplit(Record.Attribute, ".")[0]][StrSplit(Record.Attribute, ".")[1]].Type;
	EndIf;
EndProcedure
