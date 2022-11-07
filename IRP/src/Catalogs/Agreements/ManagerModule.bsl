Function GetRefsArrayByPartner(Parameter) Export
	Query = New Query();
	Query.Text = 
	"SELECT ALLOWED
	|	PartnerSegments.Segment
	|INTO PartnerSegmentsTable
	|FROM
	|	InformationRegister.PartnerSegments AS PartnerSegments
	|WHERE
	|	PartnerSegments.Partner = &Partner
	|;
	|
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
	|
	|////////////////////////////////////////////////////////////////////////////////
	|DROP PartnerSegmentsTable";
	Query.SetParameter("Partner", Parameter);
	QueryExecute = Query.Execute();
	If QueryExecute.IsEmpty() Then
		ReturnValue = New Array();
	Else
		QueryResult = QueryExecute.Unload();
		ReturnValue = QueryResult.UnloadColumn("Ref");
	EndIf;
	Return ReturnValue;
EndFunction

Function GetRefsArrayBySegment(Parameter) Export
	Query = New Query();
	Query.Text = 
	"SELECT ALLOWED
	|	PartnerSegments.Segment
	|INTO PartnerSegmentsTable
	|FROM
	|	InformationRegister.PartnerSegments AS PartnerSegments
	|WHERE
	|	PartnerSegments.Segment = &Segment
	|;
	|
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
	|
	|////////////////////////////////////////////////////////////////////////////////
	|DROP PartnerSegmentsTable";
	Query.SetParameter("Segment", Parameter);
	QueryExecute = Query.Execute();
	If QueryExecute.IsEmpty() Then
		ReturnValue = New Array();
	Else
		QueryResult = QueryExecute.Unload();
		ReturnValue = QueryResult.UnloadColumn("Ref");
	EndIf;
	Return ReturnValue;
EndFunction

Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
	If TypeOf(Parameters) <> Type("Structure") Or Not ValueIsFilled(Parameters.SearchString)
		Or Not Parameters.Filter.Property("AdditionalParameters") Then
		Return;
	EndIf;

	StandardProcessing = False;
	CommonFormActionsServer.CutLastSymbolsIfCameFromExcel(Parameters);
	QueryTable = GetChoiceDataTable(Parameters);
	ChoiceData = CommonFormActionsServer.QueryTableToChoiceData(QueryTable);	
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
	Settings = New Structure();
	Settings.Insert("MetadataObject", Metadata.Catalogs.Agreements);
	Settings.Insert("Filter", Filter);
	// enable search by code
	Settings.Insert("UseSearchByCode", True);
	
	QueryBuilderText = CommonFormActionsServer.QuerySearchInputByString(Settings);
	QueryBuilder = New QueryBuilder(QueryBuilderText);
	QueryBuilder.FillSettings();
	CommonFormActionsServer.SetCustomSearchFilter(QueryBuilder, Parameters);
	
	Query = QueryBuilder.GetQuery();

	Query.SetParameter("SearchString", Parameters.SearchString);

	QueryParametersStr = New Structure();
	QueryParametersStr.Insert("IncludeFilterByEndOfUseDate", False);
	QueryParametersStr.Insert("IncludeFilterByPartner", False);
	QueryParametersStr.Insert("IncludePartnerSegments", False);
	QueryParametersStr.Insert("EndOfUseDate", Date(1, 1, 1));
	QueryParametersStr.Insert("Partner", Undefined);
	QueryParametersStr.Insert("PartnerSegments", New Array());

	AdditionalParameters = CommonFunctionsServer.DeserializeXMLUseXDTO(Parameters.Filter.AdditionalParameters);
	For Each QueryParameter In QueryParametersStr Do
		KeyValue = ?(AdditionalParameters.Property(QueryParameter.Key), AdditionalParameters[QueryParameter.Key], QueryParameter.Value);
		Query.SetParameter(QueryParameter.Key, KeyValue);
	EndDo;
	If Query.Parameters.IncludePartnerSegments Then
		PartnersSegmentsArray = InformationRegisters.PartnerSegments.GetSegmentsRefArrayByPartner(Query.Parameters.Partner);
		Query.SetParameter("PartnerSegments", PartnersSegmentsArray);
	EndIf;
	
	// parameters search by code
	SearchStringNumber = CommonFunctionsClientServer.GetSearchStringNumber(Parameters.SearchString);
	Query.SetParameter("SearchStringNumber", SearchStringNumber);
	
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
	|	Case
	|		when Table.DaysBeforeDelivery > 0
	|			Then DATEADD(&CurrentDate, DAY, Table.DaysBeforeDelivery)
	|		Else Datetime(1, 1, 1)
	|	End AS DateOfShipment,
	|	Case
	|		when Table.DaysBeforeDelivery > 0
	|			Then DATEADD(&CurrentDate, DAY, Table.DaysBeforeDelivery)
	|		Else Datetime(1, 1, 1)
	|	End AS DeliveryDate,
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
	|	Table.ApArPostingDetail,
	|	Table.TradeAgentFeeType,
	|	Table.TradeAgentFeePercent
	|FROM
	|	Catalog.Agreements AS Table
	|WHERE
	|	Table.Ref = &Ref";
	Query.SetParameter("Ref", Agreement);
	Query.SetParameter("CurrentDate", CurrentSessionDate());
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

Function GetAgreementPaymentTerms(Agreement) Export
	ArrayOfPaymentTerms = New Array();
	If ValueIsFilled(Agreement) And ValueIsFilled(Agreement.PaymentTerm) Then
		For Each Stage In Agreement.PaymentTerm.StagesOfPayment Do
			NewRow = New Structure();
			NewRow.Insert("Date"                , Date(1, 1, 1));
			NewRow.Insert("ProportionOfPayment" , Stage.ProportionOfPayment);
			NewRow.Insert("DuePeriod"           , Stage.DuePeriod);
			NewRow.Insert("Amount"              , 0);
			NewRow.Insert("CalculationType"     , Stage.CalculationType);
			ArrayOfPaymentTerms.Add(NewRow);
		EndDo;
	EndIf;
	Return ArrayOfPaymentTerms;
EndFunction
