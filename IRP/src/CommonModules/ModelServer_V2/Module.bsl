
Procedure ServerEntryPoint(StepsEnablerName, Parameters) Export
	ModelClientServer_V2.ServerEntryPoint(StepsEnablerName, Parameters);
EndProcedure

Function ExtractDataAgreementApArPostingDetailImp(Agreement) Export
	If Not ValueIsFilled(Agreement) Then
		Return Enums.ApArPostingDetail.EmptyRef();
	EndIf;
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Agreements.ApArPostingDetail
	|FROM
	|	Catalog.Agreements AS Agreements
	|WHERE
	|	Agreements.Ref = &Ref";
	Query.SetParameter("Ref", Agreement);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return QuerySelection.ApArPostingDetail;
	EndIf;
	Return Enums.ApArPostingDetail.EmptyRef();
EndFunction
	
Function ConvertQuantityToQuantityInBaseUnit(Bundle, Unit, Quantity) Export
	If TypeOf(Bundle) = Type("CatalogRef.ItemKeys") Then
		Return Catalogs.Units.ConvertQuantityToQuantityInBaseUnit(Bundle, Unit, Quantity).QuantityInBaseUnit;
	ElsIf TypeOf(Bundle) = Type("CatalogRef.Items") Then
		Return Catalogs.Units.Convert(Unit, Bundle.Unit, Quantity);
	EndIf;
EndFunction

Function GetCommissionPercentExecute(Options) Export
	Query = New Query;
	Query.Text =
		"SELECT
		|	BankTermsPaymentTypes.Percent
		|FROM
		|	Catalog.BankTerms.PaymentTypes AS BankTermsPaymentTypes
		|WHERE
		|	BankTermsPaymentTypes.Ref = &Ref
		|	AND BankTermsPaymentTypes.PaymentType = &PaymentType";
	
	Query.SetParameter("Ref", Options.BankTerm);
	Query.SetParameter("PaymentType", Options.PaymentType);
	
	QueryResult = Query.Execute();
	
	SelectionDetailRecords = QueryResult.Select();
	
	While SelectionDetailRecords.Next() Do
		Return SelectionDetailRecords.Percent;
	EndDo;

	Return 0;
EndFunction

Function ConvertPriceByCurrency(Period, PriceType, CurrencyTo, Price) Export
	If Not ValueIsFilled(PriceType) Then
		Return Price;
	EndIf;
	
	CurrencyFrom = PriceType.Currency;
	If Not ValueIsFilled(CurrencyFrom) 
		Or Not ValueIsFilled(CurrencyTo) 
		Or CurrencyFrom = CurrencyTo Then
		Return Price;
	EndIf;
	
	CurrencyInfo = Catalogs.Currencies.GetCurrencyInfo(Period, 
			CurrencyFrom, 
			CurrencyTo,
			PriceType.Source);
	Rate = ?(ValueIsFilled(CurrencyInfo.Rate), CurrencyInfo.Rate, 0);
	Multiplicity = ?(ValueIsFilled(CurrencyInfo.Multiplicity), CurrencyInfo.Multiplicity, 0);
	
	If Rate = 0 Or Multiplicity = 0 Then
		Return Price;
	EndIf;
	
	PriceRecalculated = (Price * Rate) / Multiplicity;
	Return PriceRecalculated;
EndFunction

Function GetLandedCostCurrencyByCompany(Company) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Companies.LandedCostCurrencyMovementType.Currency AS Currency
	|FROM
	|	Catalog.Companies AS Companies
	|WHERE
	|	Companies.Ref = &Ref";
	Query.SetParameter("Ref", Company);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return QuerySelection.Currency;
	Else
		Return Undefined;
	EndIf;
EndFunction

Function GetBillOfMaterialsByItemKey(Item, ItemKey) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	BillOfMaterials.Ref
	|FROM
	|	Catalog.BillOfMaterials AS BillOfMaterials
	|WHERE
	|	BillOfMaterials.Item = &Item
	|	AND BillOfMaterials.ItemKey = &ItemKey
	|	AND NOT BillOfMaterials.DeletionMark";
	Query.SetParameter("Item", Item);
	Query.SetParameter("ItemKey", ItemKey);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return QuerySelection.Ref;
	Else
		Return Undefined;
	EndIf;
EndFunction
