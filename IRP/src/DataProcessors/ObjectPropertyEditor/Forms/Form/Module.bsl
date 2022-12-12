
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	FormCash = GetFormCash(ThisObject);
	LoadMetadata(FormCash);
	
	If TypeOf(Parameters.RefsList) = Type("Array") Then
		TypeKey = TypeOf(Parameters.RefsList[0]);
		TypeRecord = Items.ObjectType.ChoiceList.FindByValue(TypeKey);
		If Not TypeRecord = Undefined Then
			ThisObject.ObjectType = TypeKey;
			SetTablesList(ThisObject);
			LoadRefsToFilter(Parameters.RefsList, ThisObject.DataSettingsComposer);
		EndIf;
	EndIf;

EndProcedure

// Load refs to filter.
// 
// Parameters:
//  RefsArray - Array of AnyRef 
//  DataSettingsComposer - DataCompositionSettingsComposer - Data settings composer
&AtClientAtServerNoContext
Procedure LoadRefsToFilter(RefsArray, DataSettingsComposer)
	List = New ValueList;
	List.LoadValues(RefsArray);
	
	RefsFilter = DataSettingsComposer.Settings.Filter.Items.Add(Type("DataCompositionFilterItem"));
	RefsFilter.LeftValue = New DataCompositionField("Ref");
	RefsFilter.ComparisonType  = DataCompositionComparisonType.InList;
	RefsFilter.RightValue = List;
	RefsFilter.Use = True;
EndProcedure

&AtClient
Procedure ObjectTypeOnChange(Item)
	
	Items.ObjectTable.ChoiceList.Clear();
	ThisObject.ObjectTable = "";
	
	If Not ThisObject.ObjectType = Undefined Then
		SetTablesList(ThisObject);
	EndIf;

EndProcedure

&AtClient
Procedure Refresh(Command)
	//TODO: Insert the handler content
EndProcedure

// Get form cash.
// 
// Parameters:
//  Form - ClientApplicationForm - Form
// 
// Returns:
//  Structure - Form cash:
// * ObjectTables - Map - Set tables of specified object:
// 	** Key - Type
//	** Value - Structure:
//		*** Key - String
//		*** Value - String
// * SchemaAddress - String
&AtClientAtServerNoContext
Function GetFormCash(Form)
	FormCash = Form["FormDataCash"];
	If Not FormCash = Undefined Then
		Return FormCash;
	EndIf;
	
	FormCash = New Structure;
	FormCash.Insert("ObjectTables", New Map);
	FormCash.Insert("SchemaAddress", "");
	
	Form["FormDataCash"] = FormCash;
	
	Return FormCash;
EndFunction

// Load metadata.
// 
// Parameters:
//  FormCash - See GetFormCash
&AtServer
Procedure LoadMetadata(FormCash)
	
	Items.ObjectType.ChoiceList.Clear();
	FormCash.ObjectTables.Clear();
	
	AvailableTypes = Metadata.DefinedTypes.typeAddPropertyOwners.Type.Types();
	For Each AvailableType In AvailableTypes Do
		
		ItemPreffics = "";
		ItemPicture = Undefined;
		If Catalogs.AllRefsType().ContainsType(AvailableType) Then
			ItemPreffics = "(catalog) ";
			ItemPicture = PictureLib.Catalog;
		ElsIf Documents.AllRefsType().ContainsType(AvailableType) Then
			ItemPreffics = "(document) ";
			ItemPicture = PictureLib.DocumentJournal;
		EndIf;
		Items.ObjectType.ChoiceList.Add(AvailableType, ItemPreffics + AvailableType, , ItemPicture);
		
		PropertyTables = New Structure;
		MetaObject = Metadata.FindByType(AvailableType);
		If TypeOf(MetaObject) = Type("MetadataObject") Then
			Try
				For Each TabularSection In MetaObject.TabularSections Do
					AttributeProperty = TabularSection.Attributes.Find("Property");
					If Not AttributeProperty = Undefined And isChartOfCharacteristicTypes(AttributeProperty.Type) Then
						PropertyTables.Insert(TabularSection.Name, TabularSection.Synonym);
					EndIf;
				EndDo;
			Except
				// Strange metadata object - it's maybe an error
				ErrorDescription = ErrorDescription(); 
			EndTry;
		EndIf;
		FormCash.ObjectTables.Insert(AvailableType, PropertyTables);
		
	EndDo;
	
	Items.ObjectType.ChoiceList.SortByPresentation();
	
EndProcedure

// Set tables list.
// 
// Parameters:
//  Form - ClientApplicationForm - Form
&AtClientAtServerNoContext
Procedure SetTablesList(Form)
	TablesStructure = GetFormCash(Form).ObjectTables.Get(Form.ObjectType);
	If TypeOf(TablesStructure) = Type("Structure") Then
		For Each TableKeValue In TablesStructure Do
			Form.Items.ObjectTable.ChoiceList.Add(TableKeValue.Key, TableKeValue.Value);
		EndDo;
	EndIf;
	If Form.Items.ObjectTable.ChoiceList.Count() > 0 Then
		Form.ObjectTable = Form.Items.ObjectTable.ChoiceList[0].Value;
	EndIf;
	SetSourceSettings(Form);
EndProcedure

// Set source settings.
// 
// Parameters:
//  Form - ClientApplicationForm - Form
&AtServerNoContext
Procedure SetSourceSettings(Form)
	
	MetaObject = Metadata.FindByType(Form.ObjectType);
	MetaObjectTable = MetaObject.TabularSections[Form.ObjectTable];
	
	DCSchema = New DataCompositionSchema;

	DS = DCSchema.DataSources.Add();
	DS.Name = "DataSources";
	DS.DataSourceType = "Local";
	
	DataSet = DCSchema.DataSets.Add(Type("DataCompositionSchemaDataSetQuery"));
	DataSet.Name = "DataSet1";
	DataSet.DataSource = "DataSources";
	DataSet.Query = 
	"SELECT
	|	Table.Ref,
	|	Table.Property,
	|	Table.Value
	|FROM
	|	" + MetaObject.FullName() + "." + Form.ObjectTable + " AS Table";
	
	DataField = DataSet.Fields.Add(Type("DataCompositionSchemaDataSetField"));
	DataField.Field = "Ref";
	DataField.DataPath = "Ref";
	DataField.Title = "Ref";
		
	DataField = DataSet.Fields.Add(Type("DataCompositionSchemaDataSetField"));
	DataField.Field = "Property";
	DataField.DataPath = "Property";
	DataField.Title = MetaObjectTable.Attributes.Property.Synonym;
		
	DataField = DataSet.Fields.Add(Type("DataCompositionSchemaDataSetField"));
	DataField.Field = "Value";
	DataField.DataPath = "Value";
	DataField.Title = MetaObjectTable.Attributes.Value.Synonym;
		
	SchemaAddress = PutToTempStorage(DCSchema, Form.UUID);
	
	FormCash = GetFormCash(Form);
	FormCash.SchemaAddress = SchemaAddress; 
    
  	AvailableSettingsSource = New DataCompositionAvailableSettingsSource(SchemaAddress);
	Form.DataSettingsComposer.Initialize(AvailableSettingsSource);
    Form.DataSettingsComposer.LoadSettings(DCSchema.DefaultSettings);
    
EndProcedure

// Is chart of characteristic types.
// 
// Parameters:
//  ValueTypes - TypeDescription - Value types
// 
// Returns:
//  Boolean - Is chart of characteristic types
&AtServerNoContext
Function isChartOfCharacteristicTypes(ValueTypes)
	For Each ValueType In ValueTypes.Types() Do
		If ChartsOfCharacteristicTypes.AllRefsType().ContainsType(ValueType) Then
			Return True;
		EndIf;
	EndDo;
	Return False;
EndFunction