
&AtClient
Procedure Generate(Command)
	GenerateAtServer();
EndProcedure

&AtServer
Procedure GenerateAtServer()
	DataSelectionSections = GetSections(Enums.PLSectionTypes.DataSelection);
	
	Query = New Query();
	Query.SetParameter("Company"    , ThisObject.Company);
	Query.SetParameter("LedgerType" , ThisObject.LedgerType);
	Query.SetParameter("StartDate"  , ThisObject.Period.StartDate);
	Query.SetParameter("EndDate"    , ThisObject.Period.EndDate);
	
	ArrayOfQueryBatches = New Array();
	QueryNumber = 1;
	For Each Row In DataSelectionSections Do	
		For Each AccountsRow In Row.Section.Accounts Do
			ArrayOfQueryBatches.Add(GetQueryText(AccountsRow, QueryNumber));
			
			Query.SetParameter("ExtDimensionFilter" + String(QueryNumber), 
				ValueIsFilled(AccountsRow.ExtDimensionValue));
			Query.SetParameter("ExtDimensionValue" + String(QueryNumber),
			 	AccountsRow.ExtDimensionValue);
			Query.SetParameter("SectionName" + String(QueryNumber),
			 	Row.Section.SectionName);
			Query.SetParameter("Account" + String(QueryNumber),
				AccountsRow.Account);
			Query.SetParameter("TurnoversType" + String(QueryNumber),
				AccountsRow.TurnoversType);
			 	
			QueryNumber = QueryNumber + 1;
		EndDo;
	EndDo;
	
	Query.Text = StrConcat(ArrayOfQueryBatches, Chars.LF + " UNION ALL " + Chars.LF);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	QueryTable.GroupBy("SectionName", "Amount");
	
	Section = New Structure();
	For Each Row In QueryTable Do
		Section.Insert(Row.SectionName, Row.Amount);
	EndDo;
	
	CalculationSections = GetSections(Enums.PLSectionTypes.Calculation);
	
	ArrayOfErrors = New Array();
	SetSafeMode(True);
	For Each Row In CalculationSections Do
		Value = 0;
		If ValueIsFilled(Row.Section.Expression) Then
			Try
				Value = Eval(Row.Section.Expression);
			Except
				ArrayOfErrors.Add(ErrorDescription());
			EndTry;
		EndIf;
		Section.Insert(Row.SectionName, Value);
	EndDo;
	SetSafeMode(False);
	
	For Each Error In ArrayOfErrors Do
		CommonFunctionsClientServer.ShowUsersMessage(Error);
	EndDo;
	
	// output
	ThisObject.DocResult.Clear();
	Template = Reports.A0014_AccountingPLReport.GetTemplate("Template");
	Template.Parameters.Fill(Section);
	ThisObject.DocResult.Put(Template);
EndProcedure

&AtServer
Function GetSections(SectionType)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	PLSections.Ref AS Section,
	|	PLSections.SectionName
	|FROM
	|	Catalog.PLSections AS PLSections
	|WHERE
	|	NOT PLSections.DeletionMark
	|	AND PLSections.SectionType = &SectionType
	|
	|ORDER BY
	|	PLSections.Order";
	
	Query.SetParameter("SectionType" , SectionType);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	
	Return QueryTable;
EndFunction

&AtServer
Function GetQueryText(AccountsRow, QueryNumber)
	QueryText = 
	"SELECT
	|	SUM(CASE
	|		WHEN &TurnoversType = VALUE(Enum.AccountingAnalyticTypes.Debit)
	|			THEN BasicBalanceAndTurnovers.AmountTurnoverDr
	|		WHEN &TurnoversType = VALUE(Enum.AccountingAnalyticTypes.Credit)
	|			THEN BasicBalanceAndTurnovers.AmountTurnoverCr
	|	END) AS Amount,
	|	&SectionName AS SectionName
	|FROM
	|	AccountingRegister.Basic.BalanceAndTurnovers(BEGINOFPERIOD(&StartDate, DAY), ENDOFPERIOD(&EndDate, DAY),,, Account
	|		IN HIERARCHY (&Account),, Company = &Company
	|	AND LedgerType = &LedgerType
	|	AND CASE
	|		WHEN &ExtDimensionFilter
	|			THEN ExtDimension1 = &ExtDimensionValue
	|		ELSE TRUE
	|	END) AS BasicBalanceAndTurnovers";
	QueryText = StrReplace(QueryText, "&SectionName", "&SectionName" + String(QueryNumber));
	QueryText = StrReplace(QueryText, "ExtDimensionFilter", "ExtDimensionFilter" + String(QueryNumber));
	QueryText = StrReplace(QueryText, "ExtDimensionValue", "ExtDimensionValue" + String(QueryNumber));
	QueryText = StrReplace(QueryText, "&Account", "&Account" + String(QueryNumber));
	QueryText = StrReplace(QueryText, "&TurnoversType", "&TurnoversType" + String(QueryNumber));
	
	If ValueIsFilled(AccountsRow.ExtDimensionNumber) Then
		QueryText = StrReplace(QueryText, "ExtDimension1", "ExtDimension" + String(AccountsRow.ExtDimensionNumber));
	EndIf;
		
	Return QueryText;
EndFunction
		
