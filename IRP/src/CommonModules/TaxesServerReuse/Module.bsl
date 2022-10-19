Function GetTaxesByCompany(Date, Company) Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	TaxesSliceLast.Tax,
	|	TaxesSliceLast.Tax.Type AS Type,
	|	TaxesSliceLast.Tax.UseDocuments.(
	|		DocumentName) AS UseDocuments
	|FROM
	|	InformationRegister.Taxes.SliceLast(&Date, Company = &Company) AS TaxesSliceLast
	|WHERE
	|	TaxesSliceLast.Use
	|ORDER BY
	|	TaxesSliceLast.Priority";
	Query.SetParameter("Date"    , Date);
	Query.SetParameter("Company" , Company);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	ArrayOfResults = New Array();
	While QuerySelection.Next() Do
		TaxInfo = New Structure();
		TaxInfo.Insert("Tax"          , QuerySelection.Tax);
		TaxInfo.Insert("Type"         , QuerySelection.Type);
		TaxInfo.Insert("UseDocuments" , QuerySelection.UseDocuments.Unload());
		ArrayOfResults.Add(TaxInfo);
	EndDo;
	Return ArrayOfResults;
EndFunction