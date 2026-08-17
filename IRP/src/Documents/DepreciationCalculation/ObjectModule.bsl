
Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	If CurrenciesServer.NeedUpdateCurrenciesTable(ThisObject) Then
		
		Parameters = CurrenciesClientServer.GetParameters_V7(ThisObject, Undefined, 
			CurrenciesServer.GetLandedCostCurrency(ThisObject.Company), 0);
		CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies);
		CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);

	EndIf;
	
	ThisObject.AdditionalProperties.Insert("WriteMode", WriteMode);
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	WriteMode = CommonFunctionsClientServer.GetFromAddInfo(ThisObject.AdditionalProperties, "WriteMode");
	If FOServer.IsUseAccounting() And WriteMode = DocumentWriteMode.Posting Then
		AccountingServer.OnWrite(ThisObject, Cancel);
	EndIf;
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure Posting(Cancel, PostingMode)
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
EndProcedure

Procedure UndoPosting(Cancel)
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	DepreciationCalculation.Ref
	|FROM
	|	Document.DepreciationCalculation AS DepreciationCalculation
	|WHERE
	|	DepreciationCalculation.Ref <> &Ref
	|	AND DepreciationCalculation.Company = &Company
	|	AND DepreciationCalculation.Date BETWEEN BEGINOFPERIOD(&Date, MONTH) AND ENDOFPERIOD(&Date, MONTH)
	|	AND DepreciationCalculation.Posted";
	Query.SetParameter("Ref", ThisObject.Ref);
	Query.SetParameter("Company", ThisObject.Company);
	Query.SetParameter("Date", ThisObject.Date);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	While QuerySelection.Next() Do
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_FixedAsset_01, QuerySelection.Ref), "Date", ThisObject);
		Cancel = True;
	EndDo;	
EndProcedure
