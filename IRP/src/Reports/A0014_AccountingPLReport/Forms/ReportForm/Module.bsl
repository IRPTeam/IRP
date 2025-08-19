
&AtClient
Procedure Generate(Command)
	GenerateAtServer();
EndProcedure

&AtServer
Procedure GenerateAtServer()
	Template = Reports.A0014_AccountingPLReport.GetTemplate("Template");
	Area_Header = Template.GetArea("Header");
	Area_Header.Parameters.Period = 
		Format(ThisObject.Period.StartDate, "DF=dd.MM.yyyy;") + " - " + Format(ThisObject.Period.EndDate, "DF=dd.MM.yyyy;");
	Area_Header.Parameters.Header = String(ThisObject.Variant);
	
	ThisObject.DocResult.Clear();
	ThisObject.DocResult.Put(Area_Header);
	
	ReportTree = New ValueTree();
	ReportTree.Columns.Add("Section");
	ReportTree.Columns.Add("Value");
	
	CalculateReportTree(ThisObject.Variant, ReportTree.Rows);
	
	CalculateTotalAmounts(ReportTree.Rows);
	
	SectionLevel = 0;
	SectionSpace = "";
	
	ThisObject.DocResult.StartRowAutoGrouping();
	OutputReportTree(ReportTree.Rows, Template, SectionLevel, SectionSpace);
	ThisObject.DocResult.EndRowAutoGrouping();
EndProcedure

&AtServer
Procedure CalculateReportTree(Parent, ReportTreeRows)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	PLSections.Ref
	|FROM
	|	Catalog.PLSections AS PLSections
	|WHERE
	|	PLSections.Parent = &Parent
	|	AND NOT PLSections.DeletionMark";
	Query.SetParameter("Parent", Parent);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	While QuerySelection.Next() Do
		ReportRow = ReportTreeRows.Add();
		ReportRow.Section = QuerySelection.Ref;
		ReportRow.Value = GetSectionValue(QuerySelection.Ref);
		CalculateReportTree(QuerySelection.Ref, ReportRow.Rows);
	EndDo;	
EndProcedure

&AtServer
Function GetSectionValue(SectionRef)
	TotalAmount = 0;
	For Each Row In SectionRef.Accounts Do
		Query = New Query();
		Query.Text = 
		"SELECT
		|	CASE
		|		WHEN &TurnoversType = VALUE(Enum.AccountingAnalyticTypes.Debit)
		|			THEN BasicBalanceAndTurnovers.AmountTurnoverDr
		|		WHEN &TurnoversType = VALUE(Enum.AccountingAnalyticTypes.Credit)
		|			THEN BasicBalanceAndTurnovers.AmountTurnoverCr
		|	END AS Amount
		|FROM
		|	AccountingRegister.Basic.BalanceAndTurnovers(BEGINOFPERIOD(&StartDate, DAY), ENDOFPERIOD(&EndDate, DAY),,,
		|		Account = &Account,, Company = &Company
		|	AND LedgerType = &LedgerType
		|	AND CASE
		|		WHEN &ExtDimensionFilter
		|			THEN ExtDimension1 = &ExtDimensionValue
		|		ELSE TRUE
		|	END) AS BasicBalanceAndTurnovers";
		If ValueIsFilled(Row.ExtDimensionNumber) Then
			Query.Text = StrReplace(Query.Text, "ExtDimension1", "ExtDimension" + String(Row.ExtDimensionNumber));
		EndIf;
		Query.SetParameter("ExtDimensionFilter", ValueIsFilled(Row.ExtDimensionValue));
		Query.SetParameter("ExtDimensionValue", Row.ExtDimensionValue);
		
		Query.SetParameter("Company"    , ThisObject.Company);
		Query.SetParameter("LedgerType" , ThisObject.Variant.LedgerType);
		Query.SetParameter("StartDate"  , ThisObject.Period.StartDate);
		Query.SetParameter("EndDate"    , ThisObject.Period.EndDate);
		Query.SetParameter("Account"    , Row.Account);
		Query.SetParameter("TurnoversType" , Row.TurnoversType);
		
		QueryResult = Query.Execute();
		QuerySelection = QueryResult.Select();
		While QuerySelection.Next() Do
			TotalAmount = TotalAmount + QuerySelection.Amount;
		EndDo;
	EndDo;
	
	Return TotalAmount;
EndFunction

&AtServer
Function CalculateTotalAmounts(ReportTreeRows)
	TotalAmount = 0;
	For Each Row In ReportTreeRows Do
		Row.Value = Row.Value + CalculateTotalAmounts(Row.Rows);
		TotalAmount = TotalAmount + Row.Value;
	EndDo;
	Return TotalAmount;
EndFunction

&AtServer
Procedure OutputReportTree(ReportTreeRows, Template, val SectionLevel, val SectionSpace)
	SectionLevel = SectionLevel + 1;
	SectionSpace = SectionSpace + " ";
	
	For Each Row In ReportTreeRows Do
		Area_Section = Template.GetArea("Section");
		Area_Section.Parameters.SectionName = SectionSpace + String(Row.Section);
		Area_Section.Parameters.Value = Row.Value;
		ThisObject.DocResult.Put(Area_Section, SectionLevel);
		OutputReportTree(Row.Rows, Template, SectionLevel, SectionSpace);
	EndDo;
EndProcedure













