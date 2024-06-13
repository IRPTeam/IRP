
#Region Info

Function Tests() Export
	TestList = New Array;
	TestList.Add("ModuleIsConnected_AddAttributes");	
	TestList.Add("ModuleIsConnected_AddProperties");	
	Return TestList;
EndFunction

#EndRegion

#Region Test

Function ModuleIsConnected_AddAttributes() Export
	ArrayOfErrors = New Array();
	PredefinedTable = GetPredefinedTable();
	
	_ModuleIsConnected_AddAttributes(Metadata.Catalogs, PredefinedTable, ArrayOfErrors, "Catalog_");
	_ModuleIsConnected_AddAttributes(Metadata.Documents, PredefinedTable, ArrayOfErrors, "Document_");
	
	If ArrayOfErrors.Count() Then
		Unit_Service.assertFalse("Not connected module [AddAttributes]: " + Chars.LF +
			StrConcat(ArrayOfErrors, Chars.LF));
	EndIf;
	Return "";
EndFunction

Function ModuleIsConnected_AddProperties() Export
	ArrayOfErrors = New Array();
	PredefinedTable = GetPredefinedTable();
	
	_ModuleIsConnected_AddProperties(Metadata.Catalogs, PredefinedTable, ArrayOfErrors, "Catalog_");
	_ModuleIsConnected_AddProperties(Metadata.Documents, PredefinedTable, ArrayOfErrors, "Document_");
	
	If ArrayOfErrors.Count() Then
		Unit_Service.assertFalse("Not connected module [AddProperties]: " + Chars.LF +
			StrConcat(ArrayOfErrors, Chars.LF));
	EndIf;
	Return "";
EndFunction

Function GetExclude_AddAttributes()
	ArrayOfExcluded = New Array();
	ArrayOfExcluded.Add("Catalog.AccessKey");
	ArrayOfExcluded.Add("Catalog.AddAttributeAndPropertySets");
	ArrayOfExcluded.Add("Catalog.AddAttributeAndPropertyValues");
	ArrayOfExcluded.Add("Catalog.AdvancesKeys");
	ArrayOfExcluded.Add("Catalog.Batches");
	ArrayOfExcluded.Add("Catalog.BatchKeys");
	ArrayOfExcluded.Add("Catalog.ConfigurationMetadata");
	ArrayOfExcluded.Add("Catalog.CurrencyMovementSets");
	ArrayOfExcluded.Add("Catalog.DataAreas");
	ArrayOfExcluded.Add("Catalog.DataBaseStatus");
	ArrayOfExcluded.Add("Catalog.DataMappingItems");
	ArrayOfExcluded.Add("Catalog.Extensions");
	ArrayOfExcluded.Add("Catalog.IDInfoAddresses");
	ArrayOfExcluded.Add("Catalog.IDInfoSets");
	ArrayOfExcluded.Add("Catalog.MovementRules");
	ArrayOfExcluded.Add("Catalog.PrintTemplates");
	ArrayOfExcluded.Add("Catalog.ReportOptions");
	ArrayOfExcluded.Add("Catalog.RowIDs");
	ArrayOfExcluded.Add("Catalog.TransactionsKeys");
	ArrayOfExcluded.Add("Catalog.ExternalFunctions");
	ArrayOfExcluded.Add("Catalog.Unit_MockServiceData");
	ArrayOfExcluded.Add("Catalog.Unit_ServiceExchangeHistory");
	ArrayOfExcluded.Add("Catalog.FillingTemplates");
	ArrayOfExcluded.Add("Catalog.ObjectAccessKeys");
	ArrayOfExcluded.Add("Catalog.PrintInfo");
	ArrayOfExcluded.Add("Catalog.Unit_ErrorTypes");
	ArrayOfExcluded.Add("Catalog.AttachedDocumentSettings");

	ArrayOfExcluded.Add("Document.AdditionalCostAllocation");
	ArrayOfExcluded.Add("Document.AdditionalRevenueAllocation");
	ArrayOfExcluded.Add("Document.CalculationMovementCosts");
	ArrayOfExcluded.Add("Document.CustomersAdvancesClosing");
	ArrayOfExcluded.Add("Document.VendorsAdvancesClosing");
	ArrayOfExcluded.Add("Document.BatchReallocateIncoming");
	ArrayOfExcluded.Add("Document.BatchReallocateOutgoing");
	ArrayOfExcluded.Add("Document.ChequeBondTransactionItem");
	ArrayOfExcluded.Add("Document.WorkOrderClosing");
	ArrayOfExcluded.Add("Document.ForeignCurrencyRevaluation");
	ArrayOfExcluded.Add("Document.DepreciationCalculation");
	ArrayOfExcluded.Add("Document.CalculationDeservedVacations");
	Return ArrayOfExcluded;
EndFunction

Function GetExclude_Properties()
	ArrayOfExcluded = New Array();
	ArrayOfExcluded.Add("Catalog.AccessKey");
	ArrayOfExcluded.Add("Catalog.AddAttributeAndPropertySets");
	ArrayOfExcluded.Add("Catalog.AddAttributeAndPropertyValues");
	ArrayOfExcluded.Add("Catalog.AdvancesKeys");
	ArrayOfExcluded.Add("Catalog.Batches");
	ArrayOfExcluded.Add("Catalog.BatchKeys");
	ArrayOfExcluded.Add("Catalog.ConfigurationMetadata");
	ArrayOfExcluded.Add("Catalog.CurrencyMovementSets");
	ArrayOfExcluded.Add("Catalog.DataAreas");
	ArrayOfExcluded.Add("Catalog.DataBaseStatus");
	ArrayOfExcluded.Add("Catalog.DataMappingItems");
	ArrayOfExcluded.Add("Catalog.Extensions");
	ArrayOfExcluded.Add("Catalog.IDInfoAddresses");
	ArrayOfExcluded.Add("Catalog.IDInfoSets");
	ArrayOfExcluded.Add("Catalog.MovementRules");
	ArrayOfExcluded.Add("Catalog.PrintTemplates");
	ArrayOfExcluded.Add("Catalog.ReportOptions");
	ArrayOfExcluded.Add("Catalog.RowIDs");
	ArrayOfExcluded.Add("Catalog.TransactionsKeys");
	ArrayOfExcluded.Add("Catalog.ExternalFunctions");
	ArrayOfExcluded.Add("Catalog.Unit_MockServiceData");
	ArrayOfExcluded.Add("Catalog.Unit_ServiceExchangeHistory");
	ArrayOfExcluded.Add("Catalog.FillingTemplates");
	ArrayOfExcluded.Add("Catalog.ObjectAccessKeys");
	ArrayOfExcluded.Add("Catalog.PrintInfo");
	ArrayOfExcluded.Add("Catalog.Unit_ErrorTypes");
	ArrayOfExcluded.Add("Catalog.AttachedDocumentSettings");
	
	ArrayOfExcluded.Add("Document.AdditionalCostAllocation");
	ArrayOfExcluded.Add("Document.AdditionalRevenueAllocation");
	ArrayOfExcluded.Add("Document.CalculationMovementCosts");
	ArrayOfExcluded.Add("Document.CustomersAdvancesClosing");
	ArrayOfExcluded.Add("Document.VendorsAdvancesClosing");
	ArrayOfExcluded.Add("Document.BatchReallocateIncoming");
	ArrayOfExcluded.Add("Document.BatchReallocateOutgoing");
	ArrayOfExcluded.Add("Document.ChequeBondTransactionItem");
	ArrayOfExcluded.Add("Document.WorkOrderClosing");
	ArrayOfExcluded.Add("Document.ForeignCurrencyRevaluation");
	ArrayOfExcluded.Add("Document.DepreciationCalculation");
	ArrayOfExcluded.Add("Document.CalculationDeservedVacations");
	Return ArrayOfExcluded;
EndFunction

Procedure _ModuleIsConnected_AddAttributes(MetadataCollection, PredefinedTable, ArrayOfErrors, Prefix)
	ArrayOfExcluded = GetExclude_AddAttributes();
	For Each ObjectMetadata In MetadataCollection Do
		If ArrayOfExcluded.Find(ObjectMetadata.FullName()) <> Undefined 
			Or Mid(ObjectMetadata.Name, 3, 1) = "_"
			Or Mid(ObjectMetadata.Name, 4, 1) = "_"  Then
			Continue;
		EndIf;
		
		IsPresentTabularSection = False;
		For Each TabularSection In ObjectMetadata.TabularSections Do
			If Upper(TabularSection.Name) = Upper("AddAttributes") Then
				IsPresentTabularSection = True;
				Break;
			EndIf;
		EndDo;
		
		If Not IsPresentInPredefinedTable(ObjectMetadata, PredefinedTable, Prefix) Or Not IsPresentTabularSection Then
			ArrayOfErrors.Add(ObjectMetadata.FullName());
		EndIf;
	EndDo;
EndProcedure

Procedure _ModuleIsConnected_AddProperties(MetadataCollection, PredefinedTable, ArrayOfErrors, Prefix)
	ArrayOfExcluded = GetExclude_Properties();
	For Each ObjectMetadata In MetadataCollection Do
		If ArrayOfExcluded.Find(ObjectMetadata.FullName()) <> Undefined
			Or Mid(ObjectMetadata.Name, 3, 1) = "_"
			Or Mid(ObjectMetadata.Name, 4, 1) = "_"  Then
			Continue;
		EndIf;
		
		IsPresentInCommand = False;
		ObjectType = ObjectMetadata.StandardAttributes.Ref.Type.Types()[0];
		For Each CommandType In  Metadata.DefinedTypes.typeAddPropertyOwners.Type.Types() Do
			If CommandType = ObjectType Then
				IsPresentInCommand = True;
				Break;
			EndIf;
		EndDo;
		
		If Not IsPresentInPredefinedTable(ObjectMetadata, PredefinedTable, Prefix) Or Not IsPresentInCommand Then
			ArrayOfErrors.Add(ObjectMetadata.FullName());
		EndIf;
	EndDo;
EndProcedure

Function GetPredefinedTable()
	Query = New Query();
	Query.Text = 
	"SELECT
	|	AddAttributeAndPropertySets.PredefinedDataName
	|FROM
	|	Catalog.AddAttributeAndPropertySets AS AddAttributeAndPropertySets";
	QueryResult = Query.Execute();
	PredefinedTable = QueryResult.Unload();
	Return PredefinedTable;
EndFunction

Function IsPresentInPredefinedTable(ObjectMetadata, PredefinedTable, Prefix)
	Filter = New Structure("PredefinedDataName", Prefix + ObjectMetadata.Name);
	Return PredefinedTable.FindRows(Filter).Count() > 0;
EndFunction

#EndRegion