Procedure FullDataExchangeUnload() Export
	UnloadData();
EndProcedure

Procedure UnloadData(AddInfo = Undefined)
	
	UseMultiThreading = False;
	
	If AddInfo = Undefined Then
		AddInfo = New Structure();
	EndIf;
	
	AddInfo.Insert("RemoteNode");
	AddInfo.Insert("MessageNo");
	AddInfo.Insert("MetadataObjectFullName");
	AddInfo.Insert("ArrayOfMainFilters");
	AddInfo.Insert("Rule");
	AddInfo.Insert("XMLHeader");
	
	ArrayOfTokens = New Array();
	MultiThreadSettings = MultiThreadingClientServer.Settings();
	MultiThreadSettings.RowsInThread = 10000;
	
	
	DataRegistrationRules = DataRegistrationRules();
	ArrayOfRuleResults = New Array();
	
	RemoteNodes = RemoteNodes(AddInfo);
	For Each RemoteNode In RemoteNodes Do
		AddInfo.RemoteNode = RemoteNode;
		
		RegisteredData = RegisteredData(RemoteNode, AddInfo);
		AddInfo.MessageNo = RegisteredData.MessageNo;
		AddInfo.XMLHeader = RegisteredData.XMLHeader;
		
		For Each Rule In DataRegistrationRules Do
			
			AddInfo.Rule = Rule;
			
			For Each Row In RegisteredData.Map Do
				AddInfo.MetadataObjectFullName = Row.Key.MetadataObjectFullName;
				AddInfo.ArrayOfMainFilters = Row.Key.ArrayOfMainFilters;
				
				If UseMultiThreading Then
					JobDescription = StrTemplate("Executing data registration rule: %1", String(Rule));
					Token = MultiThreadingClientServer.PutJob("FullDataExchangeServer.ExecuteRule",
							Row.Value,
							MultiThreadSettings,
							JobDescription,
							AddInfo);
				Else // Not UseMultiThreading
					Token = String(New UUID());
					RuleResult = ExecuteRule(Row.Value, AddInfo);
					ArrayOfRuleResults.Add(RuleResult);
				EndIf;
				
				ArrayOfTokens.Add(Token);
				
			EndDo; // RegisteredData.Map
			
		EndDo; // DataRegistrationRule
		
	EndDo;
	
	If Not UseMultiThreading Then
		
		// NOT RUN Multithreading
		Result = JoinRuleResults(ArrayOfRuleResults, AddInfo);
		
		
		
		
		// Run multithreading
		SerializeRefsTable(Result.Refs, AddInfo);
		
		
		
		// Run multithreading
		SerializeRecordSetsTable(Result.RecordSets, AddInfo);
	EndIf;
	
EndProcedure

#Region RuleExecuter

Function ExecuteRule(Data, AddInfo = Undefined) Export
	
	Result = New Structure("MetadataObjectFullName, Rule, ArrayOfMainFilters, Data");
	
	HandlerName = AddInfo.Rule.UniqueID;
	
	HasError = False;
	HandlerResult = Undefined;
	Try
		Execute("HandlerResult = Catalogs.DataRegistrationRules."
			+ HandlerName
			+ "(Data, Metadata.FindByFullName(AddInfo.MetadataObjectFullName), AddInfo)");
	Except
		HasError = True;
	EndTry;
	
	Result.MetadataObjectFullName = AddInfo.MetadataObjectFullName;
	Result.Rule = AddInfo.Rule;
	Result.ArrayOfMainFilters = AddInfo.ArrayOfMainFilters;
	
	If HasError Or TypeOf(HandlerResult) <> Type("ValueTable") Then
		Result.Data = Data;
	Else
		Result.Data = HandlerResult;
	EndIf;
	Return Result;
EndFunction

Function JoinRuleResults(ArrayOfRuleResults, AddInfo = Undefined)
	Result = New Structure("RecordSets, Refs");
	

	RecordSets = New ValueTable();
	RecordSets.Columns.Add("MetadataObjectFullName");
	RecordSets.Columns.Add("Rule");
	RecordSets.Columns.Add("TableOfMainFilters");
	RecordSets.Columns.Add("DataCollection");
	Result.RecordSets = RecordSets;
	
	Refs = New ValueTable();
	Refs.Columns.Add("MetadataObjectFullName");
	Refs.Columns.Add("Rule");
	Refs.Columns.Add("DataCollection");
	Result.Refs = Refs;
	
	For Each Row In ArrayOfRuleResults Do
		
		If Row.Data = Undefined Or Not Row.Data.Count() Then
			Continue;
		EndIf;
		
		MetadataObject = Metadata.FindByFullName(Row.MetadataObjectFullName);
		
		If Metadata.InformationRegisters.Contains(MetadataObject) Or
			Metadata.AccountingRegisters.Contains(MetadataObject) Then
			
			// Serialize will be later				
			PutToRecordSets(RecordSets, Row.Rule, Row.Data, Row.ArrayOfMainFilters, Row.MetadataObjectFullName, AddInfo);
			
		Else // Catalog or Document
			
			PutToRefs(Refs, Row.Rule, Row.Data, Row.MetadataObjectFullName, AddInfo);
			
		EndIf;
	EndDo;
	
	Return Result;
EndFunction

Procedure PutToRefs(Refs, Rule, DataCollection, MetadataObjectFullName, AddInfo = Undefined)
	RowOfRefs = Undefined;
	Filter = New Structure("MetadataObjectFullName, Rule", MetadataObjectFullName, Rule);
	ArrayOfRows = Refs.FindRows(Filter);
	If ArrayOfRows.Count() Then
		RowOfRefs = ArrayOfRows[0];
	Else
		RowOfRefs = Refs.Add();
		RowOfRefs.MetadataObjectFullName = MetadataObjectFullName;
		RowOfRefs.Rule = Rule;
		RowOfRefs.DataCollection = New ValueTable();
		For Each DataColumn In DataCollection.Columns Do
			RowOfRefs.DataCollection.Columns.Add(DataColumn.Name);
		EndDo;
	EndIf;
	For Each DataRow In DataCollection Do
		FillPropertyValues(RowOfRefs.DataCollection.Add(), DataRow);
	EndDo;
EndProcedure

Procedure PutToRecordSets(RecordSets, Rule, DataCollection, ArrayOfMainFilters, MetadataObjectFullName, AddInfo = Undefined)
	Filter = New Structure("MetadataObjectFullName, Rule", MetadataObjectFullName, Rule);
	ArrayOfRows = RecordSets.FindRows(Filter);
	
	TableOfMainFilters = New ValueTable();
	TableOfMainFilters.Columns.Add("Filter");
	For Each ItemFilter In ArrayOfMainFilters Do
		TableOfMainFilters.Add().Filter = ItemFilter;
	EndDo;
	
	RowOfRecordSet = Undefined;
	For Each Row In ArrayOfRows Do
		If ValueTablesIsEqual(Row.TableOfMainFilters, TableOfMainFilters, "Filter") Then
			RowOfRecordSet = Row;
			Break;
		EndIf;
	EndDo;
	
	// Create New row In RecordSet Table
	If RowOfRecordSet = Undefined Then
		RowOfRecordSet = RecordSets.Add();
		RowOfRecordSet.MetadataObjectFullName = MetadataObjectFullName;
		RowOfRecordSet.Rule = Rule;
		// Filters		
		RowOfRecordSet.TableOfMainFilters = TableOfMainFilters;
		
		// DataCollection		
		RowOfRecordSet.DataCollection = New ValueTable();
		For Each DataColumn In DataCollection.Columns Do
			RowOfRecordSet.DataCollection.Columns.Add(DataColumn.Name);
		EndDo;
		
	EndIf;
	
	For Each DataRow In DataCollection Do
		FillPropertyValues(RowOfRecordSet.DataCollection.Add(), DataRow);
	EndDo;
EndProcedure

Function ValueTablesIsEqual(Val Table1, Val Table2, Columns)
	Filter = New Structure(Columns);
	
	Resources = New Array();
	For Index = 0 To Table1.Columns.Count() - 1 Do
		If Not Filter.Property(Table1.Columns[Index].Name) Then
			Resources.Add(Index);
		EndIf;
	EndDo;
	
	Table2.Columns.Add("Sign", New TypeDescription("Number"));
	Table2.FillValues(1, "Sign");
	Table2.Indexes.Add(Columns);
	
	Difference = Table2.CopyColumns();
	
	For Each Row1 In Table1 Do
		FillPropertyValues(Filter, Row1);
		Rows2 = Table2.FindRows(Filter);
		If Not Rows2.Count() Then
			FillPropertyValues(Difference.Add(), Row1);
		Else
			Row2 = Rows2[0];
			For Each Resource In Resources Do
				If Row1[Resource] <> Row2[Resource] Then
					FillPropertyValues(Difference.Add(), Row1);
					FillPropertyValues(Difference.Add(), Row2);
					Break;
				EndIf;
			EndDo;
			Row2.Sign = 0;
		EndIf;
	EndDo;
	
	For Each Row2 In Table2.FindRows(New Structure("Sign", 1)) Do
		FillPropertyValues(Difference.Add(), Row2);
	EndDo;
	
	Return Difference.Count() > 0;
EndFunction

#EndRegion

Function SerializeRefsTable(ValueTable, AddInfo = Undefined)
	ValueTable.Columns.Add("XML");
	For Each Row In ValueTable Do
		XMLWriter = New XMLWriter();
		XMLWriter.SetString();
		XMLWriter.WriteStartElement("Root");
		
		MetadataObject = Metadata.FindByFullName(Row.MetadataObjectFullName);
		
		SerializeObjectType(Row.DataCollection, MetadataObject, XMLWriter, AddInfo);
		
		XMLWriter.WriteEndElement();
		Row.XML = XMLWriter.Close();
	EndDo;
	
	Return Undefined;
	
EndFunction

Function SerializeRecordSetsTable(ValueTable, AddInfo = Undefined)
	ValueTable.Columns.Add("XML");
	For Each Row In ValueTable Do
		XMLWriter = New XMLWriter();
		XMLWriter.SetString();
		XMLWriter.WriteStartElement("Root");
		
		MetadataObject = Metadata.FindByFullName(Row.MetadataObjectFullName);
		ArrayOfMainFilters = Row.TableOfMainFilters.UnloadColumn("Filter");
		
		SerializeNonObjectType(Row.DataCollection, MetadataObject, ArrayOfMainFilters, XMLWriter, AddInfo);
		
		XMLWriter.WriteEndElement();
		Row.XML = XMLWriter.Close();
	EndDo;
	
	Return Undefined;
	
EndFunction

Procedure SerializeNonObjectType(DataCollection, MetadataObject, ArrayOfMainFilters, XMLWriter, AddInfo = Undefined)
	For Each DataRow In DataCollection Do
		RecordSet = InformationRegisters[MetadataObject.Name].CreateRecordSet();
		// Set filters
		For Each Filter In ArrayOfMainFilters Do
			RecordSet.Filter[Filter].Set(DataRow[Filter]);
		EndDo;
		// эта строяка добавляется не всегда а только когда все поля 
		FillPropertyValues(RecordSet.Add(), DataRow);
		WriteXML(XMLWriter, RecordSet);
	EndDo;
EndProcedure

Procedure SerializeObjectType(DataCollection, MetadataObject, XMLWriter, AddInfo = Undefined)
	For Each DataRow In DataCollection Do
		If DataRow.ObjectDeletion Then
			ObjectDeletion = New ObjectDeletion(DataRow.Ref);
			WriteXML(XMLWriter, ObjectDeletion);
		Else
			Object = DataRow.Ref.GetObject();
			WriteXML(XMLWriter, Object);
		EndIf;
	EndDo;
EndProcedure

Function RemoteNodes(AddInfo = Undefined)
	Query = New Query();
	Query.Text =
		"SELECT
		|	FullDataExchange.Ref AS RemoteNode
		|FROM
		|	ExchangePlan.FullDataExchange AS FullDataExchange
		|WHERE
		|	NOT FullDataExchange.ThisNode";
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable.UnloadColumn("RemoteNode");
EndFunction

Function DataRegistrationRules(AddInfo = Undefined)
	Query = New Query();
	Query.Text =
		"SELECT
		|	DataRegistrationRules.Ref AS Rule
		|FROM
		|	Catalog.DataRegistrationRules AS DataRegistrationRules
		|WHERE
		|	DataRegistrationRules.Active";
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable.UnloadColumn("Rule");
EndFunction

Function RegisteredData(RemoteNode, AddInfo = Undefined)
	Result = New Structure("MessageNo, Map, XMLHeader", 0, New Map(), "");
	
	MessageWriter = ExchangePlans.CreateMessageWriter();
	XMLWriter = New XMLWriter();
	XMLWriter.SetString();
	MessageWriter.BeginWrite(XMLWriter, RemoteNode);
	
	MessageNo = MessageWriter.MessageNo;
	Result.MessageNo = MessageNo;
	
	// for test
	s = ExchangePlans.SelectChanges(RemoteNode, MessageWriter.MessageNo);
	While s.Next() Do
		WriteXML(XMLWriter, s.Get());
	EndDo;
	// end for test
	
	ArrayOfMainFilters = New Array();
	QueryText = "";
	Content = Metadata.ExchangePlans.FullDataExchange.Content;
	For Each Item In Content Do
		GeneratedResult = GenerateQueryTextByFullMetadataName(Item.Metadata, MessageNo, AddInfo);
		QueryText = QueryText + GeneratedResult.QueryText;
		ArrayOfMainFilters.Add(GeneratedResult.MainFilters);
	EndDo;
	Query = New Query(QueryText);
	Query.SetParameter("Node", RemoteNode);
	Query.SetParameter("MessageNo", MessageNo);
	ArrayOfResult = Query.ExecuteBatch();
	
	Index = 0;
	For Each Item In Content Do
		KeyStructure = New Structure();
		KeyStructure.Insert("MetadataObjectFullName", Item.Metadata.FullName());
		KeyStructure.Insert("ArrayOfMainFilters", ArrayOfMainFilters[Index]);
		ResultTable = ArrayOfResult[Index].Unload();
		For Each Column In ResultTable.Columns Do
			If StrEndsWith(Column.Name, "1") Then
				Column.Name = Left(Column.Name, StrLen(Column.Name) - 1) + "_DataFromDB";
			EndIf;
		EndDo;
		Result.Map.Insert(KeyStructure, ResultTable);
		Index = Index + 1;
	EndDo;
	
	MessageWriter.EndWrite();
	Result.XMLHeader = XMLWriter.Close();
	Return Result;
EndFunction

Function GenerateQueryTextByFullMetadataName(MetadataObject, MessageNo, AddInfo = Undefined)
	Result = New Structure("QueryText, MainFilters", "", New Array());
	// for registers by dimensions
	If Metadata.InformationRegisters.Contains(MetadataObject)
		Or Metadata.AccountingRegisters.Contains(MetadataObject) Then
		
		
		For Each Dimension In MetadataObject.Dimensions Do
			If Dimension.MainFilter Then
				Result.MainFilters.Add(Dimension.Name);
			EndIf;
		EndDo;
		If MetadataObject.MainFilterOnPeriod Then
			Result.MainFilters.Add("Period");
		EndIf;
		
		ArrayOfSelectedFields = New Array();
		ArrayOfJoinConditions = New Array();
		For Each MainFilter In Result.MainFilters Do
			ArrayOfJoinConditions.Add(StrTemplate(
					"Changes.%1 = Table.%1",
					MainFilter));
			
			ArrayOfSelectedFields.Add(StrTemplate(
					"CASE WHEN NOT Changes.%1 IS NULL THEN Changes.%1 ELSE Table.%1 END AS %1",
					MainFilter));
			
			ArrayOfSelectedFields.Add(StrTemplate(
					"CASE WHEN NOT Changes.%1 IS NULL THEN TRUE ELSE FALSE END AS %1_IncludeToFilter",
					MainFilter));
		EndDo;
		ArrayOfSelectedFields.Add("Table.*");
		
		QueryText =
			"SELECT %1
			|FROM
			|	%2.Changes AS Changes
			|		LEFT JOIN %2 AS Table
			|		ON %3
			|WHERE
			|	Changes.Node = &Node
			|	AND Changes.MessageNo <= &MessageNo;" + Chars.LF;
		
		SelectedFields = StrConcat(ArrayOfSelectedFields, ", ");
		JoinCondition = StrConcat(ArrayOfJoinConditions, " AND ");
		Result.QueryText = StrTemplate(QueryText,
				SelectedFields,
				MetadataObject.FullName(),
				JoinCondition);
		
		// for others by ref
	Else
		QueryText = "SELECT *,
			| CASE WHEN Changes.Ref.Ref IS NULL THEN TRUE ELSE FALSE END AS ObjectDeletion
			| FROM %1.Changes AS Changes 
			|WHERE Changes.Node = &Node AND Changes.MessageNo <= &MessageNo;" + Chars.LF;
		Result.QueryText = StrTemplate(QueryText, MetadataObject.FullName());
	EndIf;
	Return Result;
EndFunction