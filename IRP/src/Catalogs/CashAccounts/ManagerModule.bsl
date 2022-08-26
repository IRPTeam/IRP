Function GetCashAccountInfo(CashAccount) Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	CashAccounts.Currency,
	|	CashAccounts.Ref,
	|	CashAccounts.BankName,
	|	CashAccounts.Type,
	|	CashAccounts.Company
	|FROM
	|	Catalog.CashAccounts AS CashAccounts
	|WHERE
	|	CashAccounts.Ref = &Ref";
	Query.SetParameter("Ref", CashAccount);
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

//Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
//	If TypeOf(Parameters) <> Type("Structure") Or Not ValueIsFilled(Parameters.SearchString)
//		//Or Not Parameters.Filter.Property("CustomParameters") Then
//		Or Not Parameters.Filter.Property("AdditionalParameters") Then
//		Return;
//	EndIf;
//
//	StandardProcessing = False;
//	CommonFormActionsServer.CutLastSymblosIfCameFromExcel(Parameters);
//	QueryTable = GetChoiceDataTable(Parameters);
//	ChoiceData = CommonFormActionsServer.QueryTableToChoiceData(QueryTable);	
//	
////	CustomParameters = CommonFunctionsServer.DeserializeXMLUseXDTO(Parameters.Filter.CustomParameters);
////	CustomParameters.ComplexFilters.Add(DocumentsClientServer.CreateFilterItem("BySearchString", Parameters.SearchString));
////	QueryTable = CommonFunctionsServer.QueryTable("Catalog.CashAccounts", CatCashAccountsServer, CustomParameters);
////	
////	ChoiceData = New ValueList();
////	For Each Row In QueryTable Do
////		ChoiceData.Add(Row.Ref, Row.Presentation);
////	EndDo;
//EndProcedure
//
//Function GetChoiceDataTable(Parameters)
//	Filter = "";
//	Settings = New Structure();
//	Settings.Insert("MetadataObject", Metadata.Catalogs.CashAccounts);
//	Settings.Insert("Filter", Filter);
//	// enable search by code
//	Settings.Insert("UseSearchByCode", True);
//	
//	QueryBuilderText = CommonFormActionsServer.QuerySearchInputByString(Settings);
//	Query = CommonFormActionsServer.SetCustomSearchFilter(QueryBuilderText, Parameters);
//
//	Query.SetParameter("SearchString", Parameters.SearchString);
//
//	// parameters search by code
//	AccessSymbols = ".,- ¶" + Chars.LF + Chars.NBSp + Chars.CR;
//	SearchStringNumber = CommonFunctionsClientServer.GetNumberPartFromString(Parameters.SearchString, AccessSymbols);
//	Query.SetParameter("SearchStringNumber", SearchStringNumber);
//
//	Return Query.Execute().Unload();	
//EndFunction
//


