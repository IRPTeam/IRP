
Procedure CheckCreditLimit(Ref, Cancel) Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	R2021B_CustomersTransactionsBalance.AmountBalance
	|FROM
	|	AccumulationRegister.R2021B_CustomersTransactions.Balance(&Period,
	|		CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	AND Partner = &Partner
	|	AND Agreement = &Agreement) AS R2021B_CustomersTransactionsBalance";
	Query.SetParameter("Period", New Boundary(Ref.PointInTime(), BoundaryType.Excluding));
	Query.SetParameter("Partner", Ref.Partner);
	Query.SetParameter("Agreement", Ref.Agreement);

	QuerySelection = Query.Execute().Select();
	If QuerySelection.Next() Then

		CreditLimitAmount = Ref.Agreement.CreditLimitAmount;

		If (QuerySelection.AmountBalance + Ref.DocumentAmount) > CreditLimitAmount Then
			Cancel = True;
			Message = StrTemplate(R().Error_085, CreditLimitAmount, CreditLimitAmount - QuerySelection.AmountBalance,
				Ref.DocumentAmount, (QuerySelection.AmountBalance + Ref.DocumentAmount) - CreditLimitAmount,
				Ref.Currency);
			CommonFunctionsClientServer.ShowUsersMessage(Message);
		EndIf;
	EndIf;
EndProcedure
