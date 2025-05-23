// @strict-types

// Check and fill set predefined value.
// 
// Parameters:
//  SetRef - CatalogRef.SystemAttributesSets - Set
//  Clearing - Boolean - Clearing
Procedure CheckFillSetPredefinedValue(SetRef, Clearing = False) Export
	
	PredefinedName = SetRef.PredefinedDataName;
	If IsBlankString(PredefinedName) Then
		Return;
	EndIf;
	
	NameSegments = StrSplit(PredefinedName, "_");
	MetadataTypeName = NameSegments[0];
	MetadataObjectName = NameSegments[1];
	
	SystemAttributes = New Array; // Array of ChartOfCharacteristicTypesRef.SystemAttributes
	If MetadataTypeName = "Document" Then
		//@skip-check dynamic-access-method-not-found, statement-type-change
		SystemAttributes = Documents[MetadataObjectName].GetPredefinedSystemAttributes();
	ElsIf MetadataTypeName = "Catalog" Then
		//@skip-check dynamic-access-method-not-found, statement-type-change
		SystemAttributes = Catalogs[MetadataObjectName].GetPredefinedSystemAttributes();
	EndIf;
	
	SetObject = SetRef.GetObject();
	If Clearing Then
		SetObject.Attributes.Clear();
	EndIf;
	
	NeedToSave = False;
	For Each SystemAttribute In SystemAttributes Do
		If SetObject.Attributes.Find(SystemAttribute, "Attribute") = Undefined Then
			SystemAttributeRecord = SetObject.Attributes.Add();
			SystemAttributeRecord.Attribute = SystemAttribute;
			SystemAttributeRecord.Collection = True;
			NeedToSave = True;
		EndIf;
	EndDo;
	
	If NeedToSave Then
		SetObject.Write();
	EndIf;
	
EndProcedure