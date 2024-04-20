
Function GetT9010S_AccountsItemKey_Reuse(Period, Company, LedgerTypeVariant, ItemKey) Export
	Return AccountingServer.__GetT9010S_AccountsItemKey(Period, Company, LedgerTypeVariant, ItemKey);
EndFunction

Function GetT9011S_AccountsCashAccount_Reuse(Period, Company, LedgerTypeVariant, CashAccount, Currency) Export
	Return AccountingServer.__GetT9011S_AccountsCashAccount(Period, Company, LedgerTypeVariant, CashAccount, Currency);
EndFunction

Function GetT9012S_AccountsPartner_Reuse(Period, Company, LedgerTypeVariant, Partner, Agreement, Currency) Export
	Return AccountingServer.__GetT9012S_AccountsPartner(Period, Company, LedgerTypeVariant, Partner, Agreement, Currency);
EndFunction
	
Function GetT9013S_AccountsTax_Reuse(Period, Company, LedgerTypeVariant, Tax, VatRate) Export
	Return AccountingServer.__GetT9013S_AccountsTax(Period, Company, LedgerTypeVariant, Tax, VatRate);
EndFunction

Function GetT9014S_AccountsExpenseRevenue_Reuse(Period, Company, LedgerTypeVariant, ExpenseRevenue, ProfitLossCenter) Export
	Return AccountingServer.__GetT9014S_AccountsExpenseRevenue(Period, Company, LedgerTypeVariant, ExpenseRevenue, ProfitLossCenter);
EndFunction

Function GetT9015S_AccountsFixedAsset_Reuse(Period, Company, LedgerTypeVariant, FixedAsset) Export
	Return AccountingServer.__GetT9015S_AccountsFixedAsset(Period, Company, LedgerTypeVariant, FixedAsset);
EndFunction

Function GetT9016S_AccountsEmployee_Reuse(Period, Company, LedgerTypeVariant, Employee) Export
	Return AccountingServer.__GetT9016S_AccountsEmployee(Period, Company, LedgerTypeVariant, Employee);
EndFunction
