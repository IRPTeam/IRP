// @strict-types

// Get bank payment types value.
// 
// Parameters:
//  Branch - CatalogRef.BusinessUnits - Branch
// 
// Returns:
//  ValueTable - Get bank payment types value:
// * PaymentType - CatalogRef.PaymentTypes -
// * Description - DefinedType.typeDescription -
// * BankTerm - CatalogRef.BankTerms -
// * Account - CatalogRef.CashAccounts -
// * Percent - Number -
// * PaymentTypeParent - CatalogRef.PaymentTypes -
// * ParentDescription - DefinedType.typeDescription -
Function GetBankPaymentTypesValue(Branch) Export

	Query = New Query();
	Query.Text = "SELECT
				 |	BranchBankTerms.BankTerm
				 |FROM
				 |	InformationRegister.BranchBankTerms AS BranchBankTerms
				 |WHERE
				 |	BranchBankTerms.Branch = &Branch";
	Query.SetParameter("Branch", Branch);
	QueryUnload = Query.Execute().Unload();
	BankTerms = QueryUnload.UnloadColumn("BankTerm");

	Query = New Query();
	Query.Text = "SELECT
				 |	PaymentTypes.PaymentType,
				 |	PaymentTypes.PaymentType.Presentation AS Description,
				 |	PaymentTypes.Ref AS BankTerm,
				 |	PaymentTypes.Account,
				 |	PaymentTypes.Percent,
				 |	PaymentTypes.PaymentType.Parent AS PaymentTypeParent,
				 |	PaymentTypes.PaymentType.Parent.Presentation AS ParentDescription
				 |FROM
				 |	Catalog.BankTerms.PaymentTypes AS PaymentTypes
				 |WHERE
				 |	PaymentTypes.Ref In (&BankTerms)";
	Query.SetParameter("BankTerms", BankTerms);
	BankPaymentTypesValue = Query.Execute().Unload();
	Return BankPaymentTypesValue
	
EndFunction

// Get cash payment types value.
// 
// Parameters:
//  CashAccount - CatalogRef.CashAccounts
// 
// Returns:
//  ValueTable - Get cash payment types value:
//  *PaymentType - CatalogRef.PaymentTypes
//  *Description - DefinedType.typeDescription
//  *Account - CatalogRef.CashAccounts
Function GetCashPaymentTypesValue(CashAccount) Export
	Query = New Query();
	Query.Text = "SELECT
	|	PaymentTypes.Ref AS PaymentType,
	|	PaymentTypes.Description_en AS Description,
	|	&CashAccount AS Account,
	|	VALUE(Enum.PaymentTypes.Cash) AS PaymentTypeEnum
	|FROM
	|	Catalog.PaymentTypes AS PaymentTypes
	|WHERE
	|	PaymentTypes.Type = VALUE(Enum.PaymentTypes.Cash)
	|	AND NOT PaymentTypes.DeletionMark";
	Query.SetParameter("CashAccount", CashAccount);
	Return Query.Execute().Unload();
EndFunction

// Get certificate payment types value.
// 
// Parameters:
//  CashAccount - CatalogRef.CashAccounts
// 
// Returns:
//  ValueTable - Get cash payment types value:
//  *PaymentType - CatalogRef.PaymentTypes
//  *Description - DefinedType.typeDescription
//  *Account - CatalogRef.CashAccounts
Function GetCertificatePaymentTypesValue(CashAccount) Export
	Query = New Query();
	Query.Text = "SELECT
	|	PaymentTypes.Ref AS PaymentType,
	|	PaymentTypes.Description_en AS Description,
	|	&CashAccount AS Account,
	|	VALUE(Enum.PaymentTypes.Certificate) AS PaymentTypeEnum
	|FROM
	|	Catalog.PaymentTypes AS PaymentTypes
	|WHERE
	|	PaymentTypes.Type = VALUE(Enum.PaymentTypes.Certificate)
	|	AND NOT PaymentTypes.DeletionMark";
	Query.SetParameter("CashAccount", CashAccount);
	Return Query.Execute().Unload();
EndFunction

// Get payment agent types value.
// 
// Parameters:
//  Branch - CatalogRef.BusinessUnits - Branch
// 
// Returns:
//  ValueTable - Get payment agent types value:
//  * BankTerm - CatalogRef.BankTerms
//  * PaymentType - CatalogRef.PaymentTypes
//  * Description - DefinedType.typeDescription
//  * Partner - CatalogRef.Partners
//  * Legalname - CatalogRef.Companies
//  * PartnerTerms - CatalogRef.Agreements
//  * LegalNameContract - CatalogRef.LegalNameContracts
//  * Percent - Number -
Function GetPaymentAgentTypesValue(Branch) Export
	
	Query = New Query();
	Query.Text = 
		"SELECT
		|	BranchBankTerms.BankTerm,
		|	BankTermsPaymentTypes.PaymentType,
		|	BankTermsPaymentTypes.PaymentType.Description_en AS Description,
		|	BankTermsPaymentTypes.Partner,
		|	BankTermsPaymentTypes.LegalName,
		|	BankTermsPaymentTypes.PartnerTerms,
		|	BankTermsPaymentTypes.LegalNameContract,
		|	BankTermsPaymentTypes.Percent
		|FROM
		|	InformationRegister.BranchBankTerms AS BranchBankTerms
		|		LEFT JOIN Catalog.BankTerms.PaymentTypes AS BankTermsPaymentTypes
		|		ON BranchBankTerms.BankTerm = BankTermsPaymentTypes.Ref
		|WHERE
		|	BranchBankTerms.Branch = &Branch
		|	AND BankTermsPaymentTypes.PaymentType.Type = VALUE(Enum.PaymentTypes.PaymentAgent)
		|	AND NOT BranchBankTerms.BankTerm.DeletionMark
		|	AND NOT BankTermsPaymentTypes.PaymentType.DeletionMark";
	Query.SetParameter("Branch", Branch);
	Return Query.Execute().Unload();
EndFunction
