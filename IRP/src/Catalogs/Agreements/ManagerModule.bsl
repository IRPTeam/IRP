Function GetRefsArrayByPartner(Parameter) Export
	Query = New Query;
	Query.Text = "SELECT ALLOWED
		|	PartnerSegments.Segment
		|INTO PartnerSegmentsTable
		|FROM
		|	InformationRegister.PartnerSegments AS PartnerSegments
		|WHERE
		|	PartnerSegments.Partner = &Partner
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT ALLOWED
		|	Agreements.Ref
		|FROM
		|	Catalog.Agreements AS Agreements
		|		LEFT JOIN PartnerSegmentsTable AS PartnerSegmentsTable
		|		ON Agreements.PartnerSegment = PartnerSegmentsTable.Segment
		|WHERE
		|	Agreements.Partner = &Partner
		|	OR ISNULL(PartnerSegmentsTable.Segment,
		|		VALUE(Catalog.PartnerSegments.EmptyRef)) <> VALUE(Catalog.PartnerSegments.EmptyRef)
		|GROUP BY
		|	Agreements.Ref
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|DROP PartnerSegmentsTable";
	Query.SetParameter("Partner", Parameter);
	QueryExecute = Query.Execute();
	If QueryExecute.IsEmpty() Then
		ReturnValue = New Array;
	Else
		QueryResult = QueryExecute.Unload();
		ReturnValue = QueryResult.UnloadColumn("Ref");
	EndIf;
	Return ReturnValue;
EndFunction

Function GetRefsArrayBySegment(Parameter) Export
	Query = New Query;
	Query.Text = "SELECT ALLOWED
		|	PartnerSegments.Segment
		|INTO PartnerSegmentsTable
		|FROM
		|	InformationRegister.PartnerSegments AS PartnerSegments
		|WHERE
		|	PartnerSegments.Segment = &Segment
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT ALLOWED
		|	Agreements.Ref
		|FROM
		|	Catalog.Agreements AS Agreements
		|		INNER JOIN PartnerSegmentsTable AS PartnerSegmentsTable
		|		ON Agreements.PartnerSegment = PartnerSegmentsTable.Segment
		|WHERE
		|	ISNULL(Agreements.Ref, VALUE(Catalog.Agreements.EmptyRef)) <> VALUE(Catalog.Agreements.EmptyRef)
		|GROUP BY
		|	Agreements.Ref
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|DROP PartnerSegmentsTable";
	Query.SetParameter("Segment", Parameter);
	QueryExecute = Query.Execute();
	If QueryExecute.IsEmpty() Then
		ReturnValue = New Array;
	Else
		QueryResult = QueryExecute.Unload();
		ReturnValue = QueryResult.UnloadColumn("Ref");
	EndIf;
	Return ReturnValue;
EndFunction

Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
	
	If TypeOf(Parameters) <> Type("Structure")
		Or Not ValueIsFilled(Parameters.SearchString)
		Or Not Parameters.Filter.Property("AdditionalParameters") Then
		Return;
	EndIf;
	
	StandardProcessing = False;
	
	QueryTable = GetChoiceDataTable(Parameters);
	ChoiceData = New ValueList();
	For Each Row In QueryTable Do
		ChoiceData.Add(Row.Ref, Row.Presentation);
	EndDo;
EndProcedure

Function GetChoiceDataTable(Parameters) Export
	
	Filter = "
		|	AND (CASE
		|		WHEN &IncludeFilterByPartner
		|			THEN Table.Partner = &Partner
		|			OR &IncludePartnerSegments
		|			AND Table.PartnerSegment IN (&PartnerSegments)
		|		ELSE TRUE
		|	END
		|	AND CASE
		|		WHEN &IncludeFilterByEndOfUseDate
		|			THEN Table.StartUsing <= &EndOfUseDate
		|			AND (Table.EndOfUse >= &EndOfUseDate
		|			OR Table.EndOfUse = DATETIME(1, 1, 1))
		|		ELSE TRUE
		|	END)";
	Settings = New Structure;
	Settings.Insert("Name", "Catalog.Agreements");
	Settings.Insert("Filter", Filter);
	
	QueryBuilderText = CommonFormActionsServer.QuerySearchInputByString(Settings);
	
	QueryBuilder = New QueryBuilder(QueryBuilderText);
	QueryBuilder.FillSettings();
	If TypeOf(Parameters) = Type("Structure")
		And Parameters.Filter.Property("CustomSearchFilter") Then
		ArrayOfFilters = CommonFunctionsServer.DeserializeXMLUseXDTO(Parameters.Filter.CustomSearchFilter);
		For Each Filter In ArrayOfFilters Do
			NewFilter = QueryBuilder.Filter.Add("Ref." + Filter.FieldName);
			NewFilter.Use = True;
			NewFilter.ComparisonType = Filter.ComparisonType;
			NewFilter.Value = Filter.Value;
		EndDo;
	EndIf;
	Query = QueryBuilder.GetQuery();
	
	Query.SetParameter("SearchString", Parameters.SearchString);
	
	QueryParametersStr = New Structure();
	QueryParametersStr.Insert("IncludeFilterByEndOfUseDate", False);
	QueryParametersStr.Insert("IncludeFilterByPartner"     , False);
	QueryParametersStr.Insert("IncludePartnerSegments"     , False);
	QueryParametersStr.Insert("EndOfUseDate"               , Date(1, 1, 1));
	QueryParametersStr.Insert("Partner"                    , Undefined);
	QueryParametersStr.Insert("PartnerSegments"            , New Array);

	AdditionalParameters = CommonFunctionsServer.DeserializeXMLUseXDTO(Parameters.Filter.AdditionalParameters);
	For Each QueryParameter In QueryParametersStr Do
		KeyValue = ?(AdditionalParameters.Property(QueryParameter.Key),
						AdditionalParameters[QueryParameter.Key],
						QueryParameter.Value);
		Query.SetParameter(QueryParameter.Key, KeyValue);
	EndDo;
	If Query.Parameters.IncludePartnerSegments Then
		PartnersSegmentsArray = InformationRegisters.PartnerSegments.GetSegmentsRefArrayByPartner(Query.Parameters.Partner);
		Query.SetParameter("PartnerSegments", PartnersSegmentsArray);
	EndIf;
	Return Query.Execute().Unload();
EndFunction

Function GetDefaultChoiceRef(Parameters) Export
	QueryTable = GetChoiceDataTable(New Structure("SearchString, Filter", "", Parameters));
	
	If QueryTable.Count() = 1 Then
		Return QueryTable[0].Ref;
	Else 
		If Parameters.Property("Agreement") Then
			Rows = QueryTable.FindRows(New Structure("Ref", Parameters.Agreement));
			If Rows.Count() = 0 Then
				Return PredefinedValue("Catalog.Agreements.EmptyRef");
			Else
				Return Parameters.Agreement;
			EndIf;
		Else
			Return PredefinedValue("Catalog.Agreements.EmptyRef");
		EndIf;
	EndIf;
	
EndFunction

Function GetAgreementInfo(Agreement) Export
	Query = New Query();
	Query.Text = 
	"SELECT ALLOWED TOP 1
	|	DATEADD(&CurrentDate, DAY, Table.NumberDaysBeforeDelivery) AS DateOfShipment,
	|	DATEADD(&CurrentDate, DAY, Table.NumberDaysBeforeDelivery) AS DeliveryDate,
	|	Table.Ref AS Ref,
	|	Table.Store AS Store,
	|	Table.PriceIncludeTax AS PriceIncludeTax,
	|	Table.Company AS Company,
	|	Table.PriceType AS PriceType,
	|	Table.Partner AS Partner,
	|	Table.Type AS Type,
	|	Table.CurrencyMovementType.Currency AS Currency,
	|	Table.CurrencyMovementType.Source AS Source,
	|	Table.CurrencyMovementType AS CurrencyMovementType,
	|	Table.ApArPostingDetail
	|FROM
	|	Catalog.Agreements AS Table
	|WHERE
	|	Table.Ref = &Ref";
	Query.SetParameter("Ref", Agreement);
	Query.SetParameter("CurrentDate", CurrentDate());
	QueryResult = Query.Execute();
	
	Result = New Structure();
	For Each Column In QueryResult.Columns Do
		Result.Insert(Column.Name);
	EndDo;
	
	Selection = QueryResult.Select();
	If Selection.Next() Then
		FillPropertyValues(Result, Selection);
	EndIf;
	Return Result;
EndFunction
