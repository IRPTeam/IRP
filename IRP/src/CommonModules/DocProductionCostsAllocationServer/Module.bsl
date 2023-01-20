#Region FormEvents

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	If Form.Parameters.Key.IsEmpty() Then
		SetGroupItemsList(Object, Form);
		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	EndIf;
	ViewServer_V2.OnCreateAtServer(Object, Form, "ProductionCostsList, ProductionDurationsList");
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	If Not Form.GroupItems.Count() Then
		SetGroupItemsList(Object, Form);
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	LockDataModificationPrivileged.LockFormIfObjectIsLocked(Form, CurrentObject);
EndProcedure

#EndRegion

#Region GroupTitle

Procedure SetGroupItemsList(Object, Form)
	AttributesArray = New Array();
	AttributesArray.Add("Company");
	AttributesArray.Add("BeginDate");
	AttributesArray.Add("EndDate");
	DocumentsServer.DeleteUnavailableTitleItemNames(AttributesArray);
	For Each Attr In AttributesArray Do
		Form.GroupItems.Add(Attr, ?(ValueIsFilled(Form.Items[Attr].Title), Form.Items[Attr].Title,
			Object.Ref.Metadata().Attributes[Attr].Synonym + ":" + Chars.NBSp));
	EndDo;
EndProcedure

#EndRegion

#Region ListFormEvents

Procedure OnCreateAtServerListForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerListForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

#Region ChoiceFormEvents

Procedure OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

Function GetCosts(QueryParameters) Export
	Query = New Query();
	Query.Text = 
		"SELECT
		|	R5022T_ExpensesTurnovers.ProfitLossCenter,
		|	R5022T_ExpensesTurnovers.ExpenseType,
		|	R5022T_ExpensesTurnovers.Currency,
		|	R5022T_ExpensesTurnovers.AmountTurnover AS Amount
		|FROM
		|	AccumulationRegister.R5022T_Expenses.Turnovers(BEGINOFPERIOD(&BeginDate, DAY), ENDOFPERIOD(&EndDate, DAY),,
		|		Company = &Company
		|	AND ExpenseType.ExpenseType = VALUE(Enum.ExpenseTypes.ProductionCosts)
		|	AND CurrencyMovementType = &LandedCostCurrency) AS R5022T_ExpensesTurnovers";
			
	Query.SetParameter("Company"   , QueryParameters.Company);
	Query.SetParameter("BeginDate" , QueryParameters.BeginDate);
	Query.SetParameter("EndDate"   , QueryParameters.EndDate);
	LandedCostCurrency = ?(ValueIsFilled(QueryParameters.Company), 
		QueryParameters.Company.LandedCostCurrencyMovementType,
		ChartsOfCharacteristicTypes.CurrencyMovementType.EmptyRef());
	Query.SetParameter("LandedCostCurrency", LandedCostCurrency);

	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
EndFunction

Function GetDurations(QueryParameters) Export
	Query = New Query();
	Query.Text = 
		"SELECT
		|	R7050T_ProductionDurationsTurnovers.BusinessUnit,
		|	R7050T_ProductionDurationsTurnovers.ItemKey.Item AS Item,
		|	R7050T_ProductionDurationsTurnovers.ItemKey,
		|	R7050T_ProductionDurationsTurnovers.DurationTurnover AS Duration
		|FROM
		|	AccumulationRegister.R7050T_ProductionDurations.Turnovers(BEGINOFPERIOD(&BeginDate, DAY), ENDOFPERIOD(&EndDate,
		|		DAY),, Company = &Company) AS R7050T_ProductionDurationsTurnovers";
	
	Query.SetParameter("Company"   , QueryParameters.Company);
	Query.SetParameter("BeginDate" , QueryParameters.BeginDate);
	Query.SetParameter("EndDate"   , QueryParameters.EndDate);

	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
EndFunction
