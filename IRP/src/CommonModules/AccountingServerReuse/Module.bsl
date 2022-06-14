
Function GetT9010S_AccountsItemKey_Reuse(Period, Company, LedgerTypeVariant, ItemKey) Export
	Return AccountingServer.__GetT9010S_AccountsItemKey(Period, Company, LedgerTypeVariant, ItemKey);
EndFunction

Function GetT9011S_AccountsCashAccount_Reuse(Period, Company, LedgerTypeVariant, CashAccount) Export
	Return AccountingServer.__GetT9011S_AccountsCashAccount(Period, Company, LedgerTypeVariant, CashAccount);
EndFunction

Function GetT9012S_AccountsPartner_Reuse(Period, Company, LedgerTypeVariant, Partner, Agreement) Export
	Return AccountingServer.__GetT9012S_AccountsPartner(Period, Company, LedgerTypeVariant, Partner, Agreement);
EndFunction
	
Function GetT9013S_AccountsTax_Reuse(Period, Company, LedgerTypeVariant, Tax) Export
	Return AccountingServer.__GetT9013S_AccountsTax(Period, Company, LedgerTypeVariant, Tax);
EndFunction

Function GetT9014S_AccountsExpenseRevenue_Reuse(Period, Company, LedgerTypeVariant, ExpenseRevenue) Export
	Return AccountingServer.__GetT9014S_AccountsExpenseRevenue(Period, Company, LedgerTypeVariant, ExpenseRevenue);
EndFunction
