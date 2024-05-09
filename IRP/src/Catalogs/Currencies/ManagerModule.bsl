Function GetCurrencyInfo(Period, CurrencyFrom, CurrencyTo, Source = Undefined) Export

	Result = New Structure("CurrencyFrom,
						   |CurrencyTo,
						   |Source,
						   |Rate,
						   |Multiplicity");

	If CurrencyFrom = CurrencyTo Then
		Result.CurrencyFrom = CurrencyFrom;
		Result.CurrencyTo = CurrencyTo;
		Result.Rate = 1;
		Result.Multiplicity = 1;
		Return Result;
	EndIf;

	Query = New Query();
	Query.Text =
	"SELECT
	|	ISNULL(CurrencyRatesSliceLast.CurrencyFrom, &CurrencyFrom) AS CurrencyFrom,
	|	ISNULL(CurrencyRatesSliceLast.CurrencyTo, &CurrencyTo) AS CurrencyTo,
	|	ISNULL(CurrencyRatesSliceLast.Source, &Source) AS Source,
	|	ISNULL(CurrencyRatesSliceLast.Multiplicity, 0) AS Multiplicity,
	|	ISNULL(CurrencyRatesSliceLast.Rate, 0) AS Rate
	|FROM
	|	InformationRegister.CurrencyRates.SliceLast(&Period, CurrencyFrom = &CurrencyFrom
	|	AND CurrencyTo = &CurrencyTo
	|	AND CASE
	|		WHEN &Source_Filter
	|			THEN Source = &Source
	|		ELSE TRUE
	|	END) AS CurrencyRatesSliceLast";

	Source_Filter = False;

	If ValueIsFilled(Source) Then
		Source_Filter = True;
	EndIf;
	Query.SetParameter("Period", Period);
	Query.SetParameter("CurrencyFrom", CurrencyFrom);
	Query.SetParameter("CurrencyTo", CurrencyTo);
	Query.SetParameter("Source_Filter", Source_Filter);
	Query.SetParameter("Source", Source);

	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Result.CurrencyFrom = QuerySelection.CurrencyFrom;
		Result.CurrencyTo = QuerySelection.CurrencyTo;
		Result.Source = QuerySelection.Source;
		Result.Rate = QuerySelection.Rate;
		Result.Multiplicity = QuerySelection.Multiplicity;
	EndIf;

	Return Result;
EndFunction
