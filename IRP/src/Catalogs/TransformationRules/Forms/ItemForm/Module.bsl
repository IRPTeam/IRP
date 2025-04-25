
&AtClient
Procedure FillMapping(Command)
	FillMappingAtServer();
	CommonFunctionsClientServer.ShowUsersMessage(R().InfoMessage_005);
	ThisObject.Modified = True;
EndProcedure

&AtClient
Procedure MappingDefaultValueStartChoice(Item, ChoiceData, ChoiceByAdding, StandardProcessing)
	Return;
EndProcedure

&AtClient
Procedure MappingDefaultValueClearing(Item, StandardProcessing)
	Items.Mapping.CurrentData.DefaultValue = Undefined;
EndProcedure

&AtClient
Procedure MappingOnActivateCell(Item)
	If Not Item.CurrentItem = Items.MappingDefaultValue Then
		Return;
	EndIf;
	
	CurrentRow = Items.Mapping.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	
	If IsBlankString(CurrentRow.TargetAttribute) Then
		Return;
	EndIf;	
	
	ThisObject.Items.MappingDefaultValue.TypeRestriction = FillValueType(CurrentRow.TargetAttribute);
	ThisObject.Items.MappingDefaultValue.InputHint = String(ThisObject.Items.MappingDefaultValue.TypeRestriction);
EndProcedure

&AtClient
Procedure ClearDefaultValue(Command)
	CurrentRow = Items.Mapping.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	CurrentRow.DefaultValue = Undefined;
	ThisObject.Modified = True;
EndProcedure

#Region Private 

// Fill value type.
// 
// Parameters:
//  AttributePath - String - 
// @skip-check statement-type-change
// @skip-check property-return-type
// 
// Returns:
//  TypeDescription - Fill value type
&AtServer
Function FillValueType(AttributePath)
	
	If Not Metadata.FindByFullName("CommonAttribute." + AttributePath) = Undefined Then
		TypeRestriction = Metadata.FindByFullName("CommonAttribute." + AttributePath).Type;
	ElsIf StrSplit(AttributePath, ".").Count() = 1 Then
		MetadataObj = Metadata.FindByFullName(Object.TargetType.ObjectFullName); // MetadataObjectDocument
		If MetadataObj.Attributes.Find(AttributePath) = Undefined Then
			TypeRestriction = MetadataObj.StandardAttributes[AttributePath].Type;
		Else
			TypeRestriction = MetadataObj.Attributes[AttributePath].Type;
		EndIf;
	Else
		Table = StrSplit(AttributePath, ".")[0];
		AttrName = StrSplit(AttributePath, ".")[1];
		TypeRestriction = Metadata.FindByFullName(Object.TargetType.ObjectFullName).TabularSections[Table].Attributes[AttrName].Type;
	EndIf;
	Return TypeRestriction;
EndFunction

&AtServer
Procedure FillMappingAtServer()
	
	SourceMetadata = CatConfigurationMetadataServer.GetMetadataByConfigurationMetadata(Object.SourceType); // MetadataObjectDocument
	TargetMetadata = CatConfigurationMetadataServer.GetMetadataByConfigurationMetadata(Object.TargetType); // MetadataObjectDocument
	
	Ignore = TransformObjects.IgnoreAttributeOnMapping();
	IgnoreTables = TransformObjects.IgnoreTablesOnMapping();
	FillAttributeData(SourceMetadata, "Source", Ignore, IgnoreTables);
	FillAttributeData(TargetMetadata, "Target", Ignore, IgnoreTables);
	Object.Mapping.Sort("SortingIndex, TargetAttribute, SourceAttribute");
EndProcedure

&AtServer
Procedure FillAttributeData(TypeMetadata, DataType, Ignore, IgnoreTables)
	For Each Attribute In TypeMetadata.StandardAttributes Do
		FillRow(Ignore, Attribute, DataType, , "01. StandardAttributes");
	EndDo;
	For Each Attribute In TypeMetadata.Attributes Do
		FillRow(Ignore, Attribute, DataType, , "02. Attributes");
	EndDo;
	For Each AttributeDescription In Metadata.CommonAttributes Do
		If Not AttributeDescription.Content.Find(TypeMetadata) = Undefined 
				AND AttributeDescription.Content.Find(TypeMetadata).Use = Metadata.ObjectProperties.CommonAttributeUse.Use Then
			FillRow(Ignore, AttributeDescription, DataType, , "03. CommonAttributes");
		EndIf;
	EndDo;
	
	For Each Table In TypeMetadata.TabularSections Do
		
		If Not IgnoreTables.Find(Table.Name) = Undefined Then
			Continue;
		EndIf;
		
		For Each Attribute In TypeMetadata.TabularSections[Table.Name].Attributes Do
			FillRow(Ignore, Attribute, DataType, Table.Name);
		EndDo;
	EndDo;
EndProcedure

&AtServer
Procedure FillRow(Ignore, Attribute, FillingType, Val Table = "", Val SortIndex = "")
	If Not Ignore.Find(Attribute.Name) = Undefined Then
		Return;
	EndIf;
	
	TablePath = ?(IsBlankString(Table), "", Table + ".");
	
	AttributeType = GetTypeView(Attribute);
	FirstRow = Object.Mapping.FindRows(New Structure(FillingType + "Attribute", TablePath + Attribute.Name));
	If FirstRow.Count() > 0 Then
		If Not FirstRow[0][FillingType + "Type"] = AttributeType Then
			FirstRow[0][FillingType + "Type"] = AttributeType
		EndIf;
		Return;
	EndIf;
	
	ExRows = Object.Mapping.FindRows(New Structure(?(FillingType = "Target", "Source", "Target") + "Attribute", TablePath + Attribute.Name));
	If ExRows.Count() > 0 Then
		Row = ExRows[0];
	Else
		Row = Object.Mapping.Add();
	EndIf;
	Row.SortingIndex = ?(IsBlankString(SortIndex), Table, SortIndex);
	Row[FillingType + "Type"] = AttributeType;
	Row[FillingType + "Attribute"] = TablePath + Attribute.Name;
	If FillingType = "Target" Then
		Row.MustBeFilled = Attribute.FillChecking = FillChecking.ShowError;
	EndIf;
	
EndProcedure

&AtServer
Function GetTypeView(Attribute)
	JSON = CommonFunctionsServer.SerializeJSONUseXDTO(Attribute.Type);
	LeftPart = 68;
	RightPart = 11;
	JSON = Mid(JSON, LeftPart, StrLen(JSON) - (LeftPart + RightPart));
	JSON = StrReplace(JSON, "{http://www.w3.org/2001/XMLSchema}", "");
	JSON = StrReplace(JSON, "{http://v8.1c.ru/8.1/data/enterprise/current-config}", "");
	JSON = StrReplace(JSON, "{", "");
	JSON = StrReplace(JSON, "}", "");
	JSON = StrReplace(JSON, "	", "");
	JSON = StrReplace(JSON, ",", "");
	JSON = StrReplace(JSON, "]", "");
	JSON = StrReplace(JSON, "[", "");
	JSON = StrReplace(JSON, """", "");
	Return JSON;
EndFunction

#EndRegion