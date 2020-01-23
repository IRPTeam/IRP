
Procedure OnCreateAtServer(Form, Cancel, StandardProcessing) Export
	NewCommand = Form.Commands.Add("CreateFromClassifier");
	NewCommand.Action = "CreateFromClassifier";
	NewCommand.Title = "Create from classifier";
	
	NewItem = Form.Items.Add("CreateFromClassifier",
	                                 Type("FormButton"),
									 Form.CommandBar);
	NewItem.CommandName = "CreateFromClassifier";
EndProcedure


Function GetClassifierData(MetadataName) Export
	ClassifierData = New Array;
	CurrentMetadata = Metadata.FindByFullName(MetadataName);
	If CurrentMetadata = Undefined Then
		Return ClassifierData;
	EndIf;
	For Each Template In CurrentMetadata.Templates Do
		If Find(Upper(Template.Name), Upper("Classifier_JSON")) <> 0 Then
			TemplateData = ServiceSystemServer.GetManagerByMetadata(CurrentMetadata).GetTemplate(Template.Name);
			CurrentClassifierData = CommonFunctionsServer.DeserializeJSON(TemplateData.GetText());
			If TypeOf(CurrentClassifierData) = Type("Array") Then
				For Each CurrentClassifierElement In CurrentClassifierData Do
					ClassifierData.Add(CurrentClassifierElement);
				EndDo;
			EndIf;
		EndIf;
	EndDo;
	Return ClassifierData;
EndFunction

Function GetElementFromClassifier(MetadataName, KeyName, KeyValue) Export
	ClassifierData = GetClassifierData(MetadataName);
	If ClassifierData <> Undefined Then
		For Each ClassifierElement In ClassifierData Do
			If Lower(ClassifierElement[KeyName]) = Lower(KeyValue) Then
				Return ClassifierElement;
			EndIf;
		EndDo;
	EndIf;
	Return Undefined;
EndFunction

Function CreateCatalogItemFromClassifier(MetadataName, KeyName, KeyValue) Export
	ClassifierElement = GetElementFromClassifier(MetadataName, KeyName, KeyValue);
	Return CheckExistingAndCreateCatalogItemFromClassifierElement(MetadataName, ClassifierElement);
EndFunction

Function CreateCatalogItemFromClassifierElement(MetadataName, ClassifierElement) Export
	CurrentManager = ServiceSystemServer.GetManagerByMetadataFullName(MetadataName);
	If CurrentManager = Undefined Then
		Return Undefined;
	EndIf;
	If ClassifierElement <> Undefined Then
		NewObject = CurrentManager.CreateItem();
		DisassembleClassifierElement_Structure(NewObject, ClassifierElement);
		
		// Fill descriptions
		DescriptionStr = DescriptionStructure();
		FillPropertyValues(DescriptionStr, NewObject);
		For Each KeyAndValue In DescriptionStr Do
			If IsBlankString(KeyAndValue.Value) Then
				DescriptionStr[KeyAndValue.Key] = DescriptionStr["Description_en"];
			EndIf;
		EndDo;
		FillPropertyValues(NewObject, DescriptionStr);
		
		NewObject.Write();
		Return NewObject.Ref;
	Else
		Return CurrentManager.EmptyRef();
	EndIf;
EndFunction

Procedure DisassembleClassifierElement_Structure(NewObject, ClassifierElement)
	For Each KeyAndValue In ClassifierElement Do
		DisassembleClassifierElement_KeyAndValue(NewObject, KeyAndValue);
	EndDo;
EndProcedure

Procedure DisassembleClassifierElement_KeyAndValue(NewObject, KeyAndValue)
	If TypeOf(KeyAndValue.Value) = Type("Structure") Then
		If KeyAndValue.Key = "TabularSection" Then
			For Each TabularSection In KeyAndValue.Value Do
				DisassembleClassifierElement_TabularSection(NewObject, TabularSection);
			EndDo;
		Else
			MetadataType = Undefined;
			If KeyAndValue.Value.Property("MetadataType", MetadataType) Then
				If Find(MetadataType, "Catalog") <> 0 Then
					NewObject[KeyAndValue.Key] = CheckExistingAndCreateCatalogItemFromClassifierElement(
									MetadataType, KeyAndValue.Value, False);
				EndIf;
				If Find(MetadataType, "Enum") <> 0 Then
					EnumManager = ServiceSystemServer.GetManagerByMetadataFullName(MetadataType);
					If EnumManager <> Undefined Then
						NewObject[KeyAndValue.Key] = EnumManager[KeyAndValue.Value.Value];
					EndIf;
				EndIf;
				If Find(MetadataType, "ValueStorage_Structure") <> 0 Then
					ValueStorage_Structure = New Structure(); 
					For Each ValueStorage_KeyAndValue In KeyAndValue.Value Do
						If ValueStorage_KeyAndValue.Key <> "MetadataType" Then
							ValueStorage_Structure.Insert(ValueStorage_KeyAndValue.Key);
						EndIf;
					EndDo;
					DisassembleClassifierElement_Structure(ValueStorage_Structure, KeyAndValue.Value);
					NewObject[KeyAndValue.Key] = New ValueStorage(ValueStorage_Structure, New Deflation(9));	
				Endif;
				If Find(MetadataType, "ValueStorage_ExtData") <> 0 Then
					NewObject[KeyAndValue.Key] = GetBinaryDataFromTemplate(KeyAndValue.Value);		
				EndIf;
			EndIf;
		EndIf;
	Else
		// primitive type
		FillingStructure = New Structure(KeyAndValue.Key, KeyAndValue.Value);
		FillPropertyValues(NewObject, FillingStructure);
	EndIf;
EndProcedure

Procedure DisassembleClassifierElement_TabularSection(NewObject, TabularSection)
	For Each TabularSectionRow In TabularSection.Value Do
		NewRow = NewObject[TabularSection.Key].Add();
		 DisassembleClassifierElement_Structure(NewRow, TabularSectionRow);
	EndDo;
EndProcedure

Function CheckExistingAndCreateCatalogItemFromClassifierElement(MetadataName, ClassifierElement, OwnClassifier=True) Export
	If TypeOf(ClassifierElement) <> Type("Structure") OR Not ClassifierElement.Count() Then
		CurrentManager = ServiceSystemServer.GetManagerByMetadataFullName(MetadataName);
		If CurrentManager = Undefined Then
			Return Undefined;
		EndIf;
		Return CurrentManager.EmptyRef();
	EndIf;
	
	For Each KeyAndValue In ClassifierElement Do
		SearchingKeyAndValue = KeyAndValue;
		Break;
	EndDo;
	
	// Step1: Check existing item
	Query = New Query(
	"SELECT TOP 1
	|	Table.Ref
	|FROM
	|	Catalog.%1 AS Table
	|WHERE
	|	Table.%2 = &%2");
	Query.Text = StrTemplate(Query.Text, Mid(MetadataName,9), SearchingKeyAndValue.Key);
	Query.SetParameter(SearchingKeyAndValue.Key, SearchingKeyAndValue.Value);
	
	Selection = Query.Execute().Select();
	If Selection.Next() Then
		Return Selection.Ref;
	EndIf;
	
	// Step2: Try create from Metadata own classifier
	If Not OwnClassifier Then
		ItemFromMetadataClassifier = CreateCatalogItemFromClassifier(
					MetadataName, SearchingKeyAndValue.Key, SearchingKeyAndValue.Value);
		If ValueIsFilled(ItemFromMetadataClassifier) Then
			Return ItemFromMetadataClassifier;
		EndIf;
	EndIf;
	
	// Step3: Create from this ClassifierElement
	Return CreateCatalogItemFromClassifierElement(MetadataName, ClassifierElement);
EndFunction

Function GetBinaryDataFromTemplate(ClassifierElement) Export
	Var TemplatePath, TemplateName;
	
	If Not ClassifierElement.Property("TemplateName", TemplateName) 
			OR Not ClassifierElement.Property("TemplatePath", TemplatePath) Then
		Return Undefined;
	EndIf;
	
	CurrentMetadata = Metadata.FindByFullName(TemplatePath);
	If CurrentMetadata = Undefined Then
		Return Undefined;
	EndIf;
		
	For Each Template In CurrentMetadata.Templates Do
		If Upper(Template.Name) = Upper(TemplateName) Then
			TemplateData = ServiceSystemServer.GetManagerByMetadata(CurrentMetadata).GetTemplate(Template.Name);
			Return New ValueStorage(TemplateData, New Deflation(9));
		EndIf;	
	EndDo;
	
	Return Undefined;
EndFunction
	
Function DescriptionStructure(Description = "") Export
	Str = New Structure();
	Str.Insert("Description_" + LocalizationReuse.GetLocalizationCode()	, Description);
	Str.Insert("Description_en"											, Description);
	Str.Insert("Description"											, Description);
	Return Str;
EndFunction
