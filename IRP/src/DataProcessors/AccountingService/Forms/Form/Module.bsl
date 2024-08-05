
&AtClient
Procedure GroupStepsOnCurrentPageChange(Item, CurrentPage)
	If CurrentPage = Items.GroupStep2 Then
		FillAvailableChartsOfAccounts();
	ElsIf CurrentPage = Items.GroupStep3 Then
		 FillAvailableExtraDimensionTypes();
	ElsIf CurrentPage = Items.GroupStep4 Then
		FillAvailableTargetChartOfAccounts();
	EndIf;
EndProcedure

&AtServer
Procedure FillAvailableChartsOfAccounts()
	Items.ChartOfAccount.ChoiceList.Clear();
	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Reg.ExternalName,
	|	Reg.LedgerTypeVariant
	|FROM
	|	InformationRegister.T9060S_AccountingMappingChartsOfAccounts AS Reg
	|WHERE
	|	Reg.IntegrationSettings = &IntegrationSettings";
	Query.SetParameter("IntegrationSettings", ThisObject.IntegrationSettings);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	ThisObject.LedgerTypeVariantsMapping = New Structure();
	
	While QuerySelection.Next() Do
		Items.ChartOfAccount.ChoiceList.Add(QuerySelection.ExternalName, 
			StrTemplate("%1 [%2]", QuerySelection.LedgerTypeVariant, QuerySelection.ExternalName));
		ThisObject.LedgerTypeVariantsMapping.Insert(QuerySelection.ExternalName, QuerySelection.LedgerTypeVariant);
	EndDo;
EndProcedure

&AtServer
Procedure FillAvailableTargetChartOfAccounts()
	Items.TargetChartOfAccount.ChoiceList.Clear();
	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Reg.ExternalName,
	|	Reg.LedgerTypeVariant
	|FROM
	|	InformationRegister.T9060S_AccountingMappingChartsOfAccounts AS Reg
	|WHERE
	|	Reg.IntegrationSettings = &IntegrationSettings
	|	AND Reg.ExternalName <> &ChartOfAccounts";
	
	Query.SetParameter("IntegrationSettings", ThisObject.IntegrationSettings);
	Query.SetParameter("ChartOfAccounts", ThisObject.ChartOfAccount);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
		
	While QuerySelection.Next() Do
		Items.TargetChartOfAccount.ChoiceList.Add(QuerySelection.ExternalName);
	EndDo;
EndProcedure

&AtClient
Procedure ChartOfAccountOnChange(Item)
	ThisObject.LedgerTypeVariant = ThisObject.LedgerTypeVariantsMapping[ThisObject.ChartOfAccount];
EndProcedure

&AtServer
Procedure FillAvailableExtraDimensionTypes()
	Items.ExtraDimensionTypes.ChoiceList.Clear();
	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Reg.ExternalName,
	|	Reg.ExtraDimensionTypesName
	|FROM
	|	InformationRegister.T9060S_AccountingMappingChartsOfAccounts AS Reg
	|WHERE
	|	Reg.IntegrationSettings = &IntegrationSettings
	|	AND Reg.ExternalName = &ExternalName";
	
	Query.SetParameter("IntegrationSettings", ThisObject.IntegrationSettings);
	Query.SetParameter("ExternalName", ThisObject.ChartOfAccount);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
		
	While QuerySelection.Next() Do
		Items.ExtraDimensionTypes.ChoiceList.Add(QuerySelection.ExtraDimensionTypesName, 
			StrTemplate("%1 [%2]", QuerySelection.ExternalName , QuerySelection.ExtraDimensionTypesName));
	EndDo;
EndProcedure


#Region ChartsOfAccounts

&AtClient
Procedure FillExternalChartOfAccounts(Command)
	FillExternalChartOfAccountsAtServer()
EndProcedure

&AtServer
Procedure FillExternalChartOfAccountsAtServer()
	ResponseData = AccountingServer.SendGETRequest(ThisObject.IntegrationSettings, "charts_of_accounts");
	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Reg.ExternalName,
	|	Reg.LedgerTypeVariant
	|FROM
	|	InformationRegister.T9060S_AccountingMappingChartsOfAccounts AS Reg
	|WHERE
	|	Reg.IntegrationSettings = &IntegrationSettings";
	Query.SetParameter("IntegrationSettings", ThisObject.IntegrationSettings);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	ThisObject.ExternalChartsOfAccounts.Clear();
	
	For Each Row In ResponseData.Data Do
		NewRow = ThisObject.ExternalChartsOfAccounts.Add();
		FillPropertyValues(NewRow, Row);
		QuerySelection.Reset();
		If QuerySelection.FindNext(New Structure("ExternalName", Row.Name)) Then
			NewRow.LedgerTypeVariant = QuerySelection.LedgerTypeVariant;
			NewRow.Use = True;
		EndIf;	
	EndDo;
EndProcedure

&AtClient
Procedure SetMappingExternalChartsOfAccounts(Command)
	SetMappingExternalChartsOfAccountsAtServer();
EndProcedure

&AtServer
Procedure SetMappingExternalChartsOfAccountsAtServer()
	For Each Row In ThisObject.ExternalChartsOfAccounts Do
		If Not Row.Use Then
			RecordSet = InformationRegisters.T9060S_AccountingMappingChartsOfAccounts.CreateRecordSet();
			RecordSet.Filter.ExternalName.Set(Row.Name);
			RecordSet.Filter.IntegrationSettings.Set(ThisObject.IntegrationSettings);
			RecordSet.Clear();
			RecordSet.Write();
			Continue;
		EndIf;
		
		If Not ValueIsFilled(Row.LedgerTypeVariant) Then
			NewLedgerTypeVariant = Catalogs.LedgerTypeVariants.CreateItem();
			SetDescriptions(NewLedgerTypeVariant, Row);
			
			NewLedgerTypeVariant.AccountChartsCodeMask = Row.CodeMask;
			NewLedgerTypeVariant.Write();
			Row.LedgerTypeVariant = NewLedgerTypeVariant.Ref;
		EndIf;
		
		RecordSet = InformationRegisters.T9060S_AccountingMappingChartsOfAccounts.CreateRecordSet();
		RecordSet.Filter.ExternalName.Set(Row.Name);
		RecordSet.Filter.IntegrationSettings.Set(ThisObject.IntegrationSettings);
		Record = RecordSet.Add();
		Record.ExternalName = Row.Name;
		Record.IntegrationSettings = ThisObject.IntegrationSettings;
		Record.LedgerTypeVariant = Row.LedgerTypeVariant;
		Record.ExtraDimensionTypesName = Row.ExtraDimensionTypesName;
		RecordSet.Write();
	EndDo;
EndProcedure

#EndRegion

#Region Accounts

&AtClient
Procedure FillExternalAccounts(Command)
	FillExternalAccountsAtServer();
EndProcedure

&AtServer
Procedure FillExternalAccountsAtServer()
	ResponseData = AccountingServer.SendGETRequest(ThisObject.IntegrationSettings, "accounts", 
		New Structure("chart", ThisObject.ChartOfAccount));
	ThisObject.ExternalAccounts.Clear();
	For Each Row In ResponseData.Data Do
		NewRow = ThisObject.ExternalAccounts.Add();
		NewRow.Ref               = Row.Ref;
		NewRow.ParentRef         = Row.ParentRef;
		NewRow.Code              = Row.Code;
		NewRow.ParentCode        = Row.ParentCode;
		NewRow.Order             = Row.Order;
		NewRow.Type              = Row.Type;
		NewRow.OffBalance        = Row.OffBalance;
		NewRow.NotUsedForRecords = Row.NotUsedForRecords;
		NewRow.Currency          = Row.Currency;
		NewRow.Quantity          = Row.Quantity;
		SetDescriptions(NewRow, Row);
		
		// ext dimensions
		For Each Analytic In Row.Analytics Do
			NewRow["ExtDimRef" + Analytic.Number]           = Analytic.ExtDimensionType.Ref;
			NewRow["ExtDimAmount" + Analytic.Number]        = Analytic.Amount;
			NewRow["ExtDimCurrency" + Analytic.Number]      = Analytic.Currency;
			NewRow["ExtDimQuantity" + Analytic.Number]      = Analytic.Quantity;
			NewRow["ExtDimTurnoversOnly" + Analytic.Number] = Analytic.TurnoversOnly;
		EndDo;
				
	EndDo;

	ThisObject.ExternalAccounts.Sort("Order");
	GetMappingExternalAccountsAtServer();
EndProcedure

&AtServer
Procedure GetMappingExternalAccountsAtServer()
	For Each Row In ThisObject.ExternalAccounts Do
		InternalAccount = GetInternalAccount(ThisObject.ChartOfAccount, Row.Ref, False);
		If ValueIsFilled(InternalAccount) Then
			Row.Use = True;
			Row.InternalRef = InternalAccount;
		EndIf;
	EndDo;
EndProcedure

&AtClient
Procedure SetMappingExternalAccounts(Command)
	CreateAndMapAccounts();
EndProcedure

&AtServer
Procedure CreateAndMapAccounts()
	SetMappingExternalAccountsAtServer();
	SetParentForInternalAccountsAtServer();
EndProcedure

&AtServer
Procedure SetMappingExternalAccountsAtServer()
	For Each Row In ThisObject.ExternalAccounts Do
		If Row.Use Then
			// create new internal account
			If Not ValueIsFilled(Row.InternalRef) Then
				AccountObj = ChartsOfAccounts.Basic.CreateAccount();
			Else
				AccountObj = Row.InternalRef.GetObject();
			EndIf;
			
			Row.InternalRef = CreateNewInternalAccount(Row, AccountObj);
			
			ExternalRef = New UUID(Row.Ref);
			
			RecordSet = InformationRegisters.T9061S_AccountingMappingAccounts.CreateRecordSet();
			RecordSet.Filter.IntegrationSettings.Set(ThisObject.IntegrationSettings);
			RecordSet.Filter.ExternalChartName.Set(ThisObject.ChartOfAccount);
			RecordSet.Filter.ExternalRef.Set(ExternalRef);
			
			Record = RecordSet.Add();
			Record.IntegrationSettings = ThisObject.IntegrationSettings;
			Record.ExternalChartName = ThisObject.ChartOfAccount;
			Record.ExternalRef = ExternalRef;
			Record.InternalRef = Row.InternalRef;
			
			RecordSet.Write();
			
		EndIf;
	EndDo;
EndProcedure

&AtServer
Function CreateNewInternalAccount(Row, AccountObj)
	MapAccountType = New Map();
	MapAccountType.Insert(Upper("Active"), AccountType.Active);
	MapAccountType.Insert(Upper("Passive"), AccountType.Passive);
	MapAccountType.Insert(Upper("ActivePassive"), AccountType.ActivePassive);
	
	AccountObj.LedgerTypeVariant = ThisObject.LedgerTypeVariant;
	AccountObj.Code = Row.Code;
	AccountObj.Order = Row.Order;
	AccountObj.Type = MapAccountType.Get(Upper(Row.Type));
	AccountObj.NotUsedForRecords = Row.NotUsedForRecords;
	AccountObj.Quantity = Row.Quantity;
	AccountObj.Currency = Row.Currency;
	AccountObj.OffBalance = Row.OffBalance;
	SetDescriptions(AccountObj, Row);
	
	AccountObj.Write();
	Return AccountObj.Ref;
EndFunction

&AtServer
Function GetInternalAccount(ExternalChartName, ExternalRef, RaiseExceptionIfNotFound)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Reg.InternalRef
	|FROM
	|	InformationRegister.T9061S_AccountingMappingAccounts AS Reg
	|WHERE
	|	Reg.IntegrationSettings = &IntegrationSettings
	|	AND Reg.ExternalChartName = &ExternalChartName
	|	AND Reg.ExternalRef = &ExternalRef";
	Query.SetParameter("IntegrationSettings", ThisObject.IntegrationSettings);
	Query.SetParameter("ExternalChartName", ExternalChartName);
	Query.SetParameter("ExternalRef", New UUID(ExternalRef));
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Count() = 0 And RaiseExceptionIfNotFound Then
		Raise StrTemplate("Not found internal account - Integration settings:[%1] Chart of accounts:[%2] Ref[%3]",
		ThisObject.IntegrationSettings, ThisObject.ChartOfAccount, ExternalRef);
	ElsIf QuerySelection.Count() > 1 Then
		Raise StrTemplate("Found more than 1 internal account - Integration settings:[%1] Chart of accounts:[%2] Ref[%3]",
		ThisObject.IntegrationSettings, ThisObject.ChartOfAccount, ExternalRef);
	EndIf;
	
	QuerySelection.Next();
	Return QuerySelection.InternalRef;
EndFunction

&AtServer
Procedure SetParentForInternalAccountsAtServer()
	For Each Row In ThisObject.ExternalAccounts Do
		If ValueIsFilled(Row.ParentRef) And ValueIsFilled(Row.InternalRef) Then
			ParentAccount = GetInternalAccount(ThisObject.ChartOfAccount, Row.ParentRef, True);
			ObjAccount = Row.InternalRef.GetObject();
			ObjAccount.Parent = ParentAccount;
			ObjAccount.Write();
		EndIf;
	EndDo;
EndProcedure

&AtClient
Procedure SelectAllExternalAccounts(Command)
	SetSelectedAccounts(True);
EndProcedure

&AtClient
Procedure UnselectAllExternalAccounts(Command)
	SetSelectedAccounts(False);
EndProcedure

&AtClient
Procedure SetSelectedAccounts(Value)
	For Each Row In ThisObject.ExternalAccounts Do
		Row.Use = Value;
	EndDo;
EndProcedure

&AtClient
Procedure ExternalAccountsUseOnChange(Item)
	Return;
EndProcedure

#EndRegion

#Region AccounMatching

&AtClient
Procedure FillAccountMatching(Command)
	FillAccountMatchingAtServer();
EndProcedure

&AtServer
Procedure FillAccountMatchingAtServer()
	ResponseData = AccountingServer.SendGETRequest(ThisObject.IntegrationSettings, "account_matching");
	
	ThisObject.AccountMatching.Clear();
	
	For Each Row In ResponseData.Data Do
		NewRow = ThisObject.AccountMatching.Add();
		
		NewRow.SourceAccountRef = Row.SourceAccount.Ref;
		NewRow.SourceAccountCode = Row.SourceAccount.Code;
		NewRow.SourceAccountDescription_en = Row.SourceAccount.Description_en;
		NewRow.SourceAccountDescription_ru = Row.SourceAccount.Description_ru;
		NewRow.SourceAccountDescription_tr = Row.SourceAccount.Description_tr;
		
		NewRow.TargetAccountRef = Row.TargetAccount.Ref;
		NewRow.TargetAccountCode = Row.TargetAccount.Code;
		NewRow.TargetAccountDescription_en = Row.TargetAccount.Description_en;
		NewRow.TargetAccountDescription_ru = Row.TargetAccount.Description_ru;
		NewRow.TargetAccountDescription_tr = Row.TargetAccount.Description_tr;
		
		NewRow.AllExtDimensionValues1 = Row.AllExtDimensionValues1;
		NewRow.AllExtDimensionValues2 = Row.AllExtDimensionValues2;
		NewRow.AllExtDimensionValues3 = Row.AllExtDimensionValues3;
		
		
		// ext dimensions
		For Each Analytic In Row.Analytics Do
			NewRow["ExtDimensionRef" + Analytic.Number]  = Analytic.ExtDimensionRef;
			NewRow["BaseClass" + Analytic.Number]        = Analytic.BaseClass;
			NewRow["Class" + Analytic.Number]            = Analytic.Class;
			NewRow["IsRef" + Analytic.Number]            = Analytic.IsRef;
			
			NewRow["ValueRef" + Analytic.Number] = Analytic.Value.Ref;
			NewRow["ValueDescription_ru" + Analytic.Number] = Analytic.Value.Description_ru;
			NewRow["ValueDescription_en" + Analytic.Number] = Analytic.Value.Description_en;
			NewRow["ValueDescription_tr" + Analytic.Number] = Analytic.Value.Description_tr;
		EndDo;
				
	EndDo;

	ThisObject.AccountMatching.Sort("SourceAccountCode");
	
	GetMappingAccountMatchingAtServer();
EndProcedure

&AtServer
Procedure GetMappingAccountMatchingAtServer()
	For Each Row In ThisObject.AccountMatching Do
		
		Row.InternalSourceAccount = GetInternalAccount(ThisObject.ChartOfAccount, Row.SourceAccountRef, False);
		Row.InternalTargetAccount = GetInternalAccount(ThisObject.TargetChartOfAccount, Row.TargetAccountRef, False);
		
		If ValueIsFilled(Row.ExtDimensionRef1) Then		
			Result1 = GetInternalExtDimension(New UUID(Row.ExtDimensionRef1), Row.BaseClass1, Row.Class1);
			Row.InternalExtDimension1 = Result1.InternalRef;
			Row.InternalBaseClass1 = Result1.InternalBaseClass;
			Row.InternalClass1 = Result1.InternalClass;
		EndIf;
		
		If ValueIsFilled(Row.ExtDimensionRef2) Then		
			Result2 = GetInternalExtDimension(New UUID(Row.ExtDimensionRef2), Row.BaseClass2, Row.Class2);
			Row.InternalExtDimension2 = Result2.InternalRef;
			Row.InternalBaseClass2 = Result2.InternalBaseClass;
			Row.InternalClass2 = Result2.InternalClass;
		EndIf;
		
		If ValueIsFilled(Row.ExtDimensionRef3) Then		
			Result3 = GetInternalExtDimension(New UUID(Row.ExtDimensionRef3), Row.BaseClass3, Row.Class3);
			Row.InternalExtDimension3 = Result3.InternalRef;
			Row.InternalBaseClass3 = Result3.InternalBaseClass;
			Row.InternalClass3 = Result3.InternalClass;			
		EndIf;
		
		If ValueIsFilled(Row.ValueRef1) Then
			Row.InternalExtDimensionValue1 = FindOrCreateAnalytic(Row, 1);
		EndIf;
		
		If ValueIsFilled(Row.ValueRef2) Then
			Row.InternalExtDimensionValue2 = FindOrCreateAnalytic(Row, 2);
		EndIf;
		
		If ValueIsFilled(Row.ValueRef3) Then
			Row.InternalExtDimensionValue3 = FindOrCreateAnalytic(Row, 3);
		EndIf;
		
		Row.Use = GetExstingAccountMatching(Row);
		
	EndDo;
EndProcedure

Function FindOrCreateAnalytic(Row, Number)
		
		ExternalIsRef = Upper(Row["BaseClass" + Number]) = Upper("Catalogs") 
						Or Upper(Row["BaseClass" + Number]) = Upper("Documents");
		InternalIsRef = Upper(Row["InternalBaseClass" + Number]) = Upper("Catalogs") 
						Or Upper(Row["InternalBaseClass" + Number]) = Upper("Documents");
		
		NewObjData = New Structure();
		NewObjData.Insert("Description_ru", Row["ValueDescription_ru" + Number]);
		NewObjData.Insert("Description_en", Row["ValueDescription_en" + Number]);
		NewObjData.Insert("Description_tr", Row["ValueDescription_tr" + Number]);
		
		NewObjData.Insert("InternalBaseClass" , Row["InternalBaseClass" + Number]);
		NewObjData.Insert("InternalClass"     , Row["InternalClass" + Number]);			
		
		NewObjData.Insert("ExternalBaseClass" , Row["BaseClass" + Number]);
		NewObjData.Insert("ExternalClass"     , Row["Class" + Number]);
		
		If ExternalIsRef Then				
			Return AccountingServer.FindOrCreateRefAnalytic(ThisObject.IntegrationSettings, 
										   Row["ValueRef" + Number], 
										   Row["InternalExtDimension" + Number], 
										   NewObjData, InternalIsRef);
		
		ELsIf Not ExternalIsRef Then 
			Return AccountingServer.FindOrCreateEnumAnalytic(ThisObject.IntegrationSettings, 
			                                Row["ValueRef" + Number], 
			                                Row["InternalExtDimension" + Number], 
			                                NewObjData, InternalIsRef);
		EndIf;
		
EndFunction

&AtServer
Function GetExstingAccountMatching(Row)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Reg.TargetAccount
	|FROM
	|	InformationRegister.T9068S_AccountingMappingAccountsMatching AS Reg
	|WHERE
	|	Reg.IntegrationSettings = &IntegrationSettings
	|	AND Reg.SourceLedgerType = &SourceLedgerType
	|	AND Reg.SourceAccount = &SourceAccount
	|	AND Reg.ExtDimensionType1 = &ExtDimensionType1
	|	AND Reg.ExtDimensionValue1 = &ExtDimensionValue1
	|	AND Reg.ExtDimensionType2 = &ExtDimensionType2
	|	AND Reg.ExtDimensionValue2 = &ExtDimensionValue2
	|	AND Reg.ExtDimensionType3 = &ExtDimensionType3
	|	AND Reg.ExtDimensionValue3 = &ExtDimensionValue3
	|	AND Reg.TargetLedgerType = &TargetLedgerType";
	 
	Query.SetParameter("IntegrationSettings" , ThisObject.IntegrationSettings);
	Query.SetParameter("SourceLedgerType"    , ThisObject.SourceLedgerType);	
	Query.SetParameter("TargetLedgerType"    , ThisObject.TargetLedgerType);
	
	Query.SetParameter("SourceAccount"       , Row.InternalSourceAccount);
			
	Query.SetParameter("ExtDimensionType1"   , Row.InternalExtDimension1);
	Query.SetParameter("ExtDimensionValue1"  , Row.InternalExtDimensionValue1);
	Query.SetParameter("ExtDimensionType2"   , Row.InternalExtDimension2);
	Query.SetParameter("ExtDimensionValue2"  , Row.InternalExtDimensionValue2);		
	Query.SetParameter("ExtDimensionType3"   , Row.InternalExtDimension3);
	Query.SetParameter("ExtDimensionValue3"  , Row.InternalExtDimensionValue3);
		
	 QueryResult = Query.Execute();
	 QuerySelection = QueryResult.Select();
	 
	 If QuerySelection.Next() Then
	 	Return True
	 EndIf;
	 
	 Return False; 
EndFunction

&AtClient
Procedure SetMappingAccountMatching(Command)
	SetMappingAccountMatchingAtServer()
EndProcedure

&AtServer
Procedure SetMappingAccountMatchingAtServer()
	CountMatches = 0;
	For Each Row In ThisObject.AccountMatching Do
		
		RecordSet = InformationRegisters.T9068S_AccountingMappingAccountsMatching.CreateRecordSet();
		RecordSet.Filter.IntegrationSettings.Set(ThisObject.IntegrationSettings);
		
		RecordSet.Filter.SourceLedgerType.Set(ThisObject.SourceLedgerType);
		RecordSet.Filter.TargetLedgerType.Set(ThisObject.TargetLedgerType);
		
		RecordSet.Filter.SourceAccount.Set(Row.InternalSourceAccount);
		
		RecordSet.Filter.ExtDimensionType1.Set(Row.InternalExtDimension1);
		RecordSet.Filter.ExtDimensionValue1.Set(Row.InternalExtDimensionValue1);
		
		RecordSet.Filter.ExtDimensionType2.Set(Row.InternalExtDimension2);
		RecordSet.Filter.ExtDimensionValue2.Set(Row.InternalExtDimensionValue2);
		
		RecordSet.Filter.ExtDimensionType3.Set(Row.InternalExtDimension3);
		RecordSet.Filter.ExtDimensionValue3.Set(Row.InternalExtDimensionValue3);
		
		If Not Row.Use Then
			RecordSet.Clear();
			RecordSet.Write();
			Continue;
		EndIf;
		
		CountMatches = CountMatches + 1;
		
		Record = RecordSet.Add();
		
		Record.IntegrationSettings = ThisObject.IntegrationSettings;
		
		Record.SourceLedgerType = ThisObject.SourceLedgerType;
		Record.TargetLedgerType = ThisObject.TargetLedgerType;
		
		Record.SourceAccount = Row.InternalSourceAccount;
		
		Record.ExtDimensionType1 = Row.InternalExtDimension1;
		Record.ExtDimensionValue1 = Row.InternalExtDimensionValue1;
		
		Record.ExtDimensionType2 = Row.InternalExtDimension2;
		Record.ExtDimensionValue2 = Row.InternalExtDimensionValue2;
		
		Record.ExtDimensionType3 = Row.InternalExtDimension3;
		Record.ExtDimensionValue3 = Row.InternalExtDimensionValue3;
		
		Record.TargetAccount = Row.InternalTargetAccount;
		Record.TargetLedgerType = ThisObject.TargetLedgerType;
		
		Record.AllExtDimensionValues1 = Row.AllExtDimensionValues1;
		Record.AllExtDimensionValues2 = Row.AllExtDimensionValues2;
		Record.AllExtDimensionValues3 = Row.AllExtDimensionValues3;
		
		RecordSet.Write();
	EndDo;
	
	If CountMatches > 0 Then
		Obj = ThisObject.TargetLedgerType.GetObject();
		Obj.SourceLedgerType = ThisObject.SourceLedgerType;
		Obj.Write();
	EndIf;
EndProcedure

&AtClient
Procedure SelectAllAccountMatching(Command)
	SetSelectedAccountMatching(True);
EndProcedure

&AtClient
Procedure UnselectAllAccountMatching(Command)
	SetSelectedAccountMatching(False);
EndProcedure

&AtClient
Procedure SetSelectedAccountMatching(Value)
	For Each Row In ThisObject.AccountMatching Do
		Row.Use = Value;
	EndDo;
EndProcedure

#EndRegion

#Region Companies

&AtClient
Procedure FillExtarnalCompanies(Command)
	FillExtarnalCompaniesAtServer();
EndProcedure

&AtServer
Procedure FillExtarnalCompaniesAtServer()
	ResponseData = AccountingServer.SendGETRequest(ThisObject.IntegrationSettings, "companies");
	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Reg.ExternalRef,
	|	Reg.InternalRef
	|FROM
	|	InformationRegister.T9062S_AccountingMappingCompanies AS Reg
	|WHERE
	|	Reg.IntegrationSettings = &IntegrationSettings";
	Query.SetParameter("IntegrationSettings", ThisObject.IntegrationSettings);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	ThisObject.ExternalCompanies.Clear();
	
	For Each Row In ResponseData.Data Do
		NewRow = ThisObject.ExternalCompanies.Add();
		FillPropertyValues(NewRow, Row);
		QuerySelection.Reset();
		If QuerySelection.FindNext(New Structure("ExternalRef", New UUID(Row.Ref))) Then
			NewRow.InternalRef = QuerySelection.InternalRef;
			NewRow.Use = True;
		EndIf;	
	EndDo;
EndProcedure

&AtClient
Procedure SetMappingExternalCompanies(Command)
	SetMappingExternalCompaniesAtServer();
EndProcedure

&AtServer
Procedure SetMappingExternalCompaniesAtServer()
	For Each Row In ThisObject.ExternalCompanies Do
		ExternalRef = New UUID(Row.Ref);
		If Not Row.Use Then
			RecordSet = InformationRegisters.T9062S_AccountingMappingCompanies.CreateRecordSet();
			RecordSet.Filter.ExternalRef.Set(ExternalRef);
			RecordSet.Filter.IntegrationSettings.Set(ThisObject.IntegrationSettings);
			RecordSet.Clear();
			RecordSet.Write();
			Continue;
		EndIf;
		
		If Row.Use And ValueIsFilled(Row.InternalRef) Then
			RecordSet = InformationRegisters.T9062S_AccountingMappingCompanies.CreateRecordSet();
			RecordSet.Filter.ExternalRef.Set(ExternalRef);
			RecordSet.Filter.IntegrationSettings.Set(ThisObject.IntegrationSettings);
			Record = RecordSet.Add();
			Record.ExternalRef = ExternalRef;
			Record.IntegrationSettings = ThisObject.IntegrationSettings;
			Record.InternalRef = Row.InternalRef;
			RecordSet.Write();
		EndIf;
	EndDo;
EndProcedure

#EndRegion

#Region Currencies

&AtClient
Procedure FillExternalCurrencies(Command)
	FillExternalCurrenciesAtServer();
EndProcedure

&AtServer
Procedure FillExternalCurrenciesAtServer()
	ResponseData = AccountingServer.SendGETRequest(ThisObject.IntegrationSettings, "currencies");
	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Reg.ExternalRef,
	|	Reg.InternalRef
	|FROM
	|	InformationRegister.T9063S_AccountingMappingCurrencies AS Reg
	|WHERE
	|	Reg.IntegrationSettings = &IntegrationSettings";
	Query.SetParameter("IntegrationSettings", ThisObject.IntegrationSettings);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	ThisObject.ExternalCurrencies.Clear();
	
	For Each Row In ResponseData.Data Do
		NewRow = ThisObject.ExternalCurrencies.Add();
		FillPropertyValues(NewRow, Row);
		QuerySelection.Reset();
		If QuerySelection.FindNext(New Structure("ExternalRef", New UUID(Row.Ref))) Then
			NewRow.InternalRef = QuerySelection.InternalRef;
			NewRow.Use = True;
		EndIf;	
	EndDo;
EndProcedure

&AtClient
Procedure SetMappingExternalCurrencies(Command)
	SetMappingExternalCurrenciesAtServer();
EndProcedure

&AtServer
Procedure SetMappingExternalCurrenciesAtServer()
	For Each Row In ThisObject.ExternalCurrencies Do
		ExternalRef = New UUID(Row.Ref);
		If Not Row.Use Then
			RecordSet = InformationRegisters.T9063S_AccountingMappingCurrencies.CreateRecordSet();
			RecordSet.Filter.ExternalRef.Set(ExternalRef);
			RecordSet.Filter.IntegrationSettings.Set(ThisObject.IntegrationSettings);
			RecordSet.Clear();
			RecordSet.Write();
			Continue;
		EndIf;
		
		If Row.Use And ValueIsFilled(Row.InternalRef) Then
			RecordSet = InformationRegisters.T9063S_AccountingMappingCurrencies.CreateRecordSet();
			RecordSet.Filter.ExternalRef.Set(ExternalRef);
			RecordSet.Filter.IntegrationSettings.Set(ThisObject.IntegrationSettings);
			Record = RecordSet.Add();
			Record.ExternalRef = ExternalRef;
			Record.IntegrationSettings = ThisObject.IntegrationSettings;
			Record.InternalRef = Row.InternalRef;
			RecordSet.Write();
		EndIf;
	EndDo;
EndProcedure

#EndRegion

#Region Registers

&AtClient
Procedure FillExternalRegisters(Command)
	FillExternalRegistersAtServer();
EndProcedure

&AtServer
Procedure FillExternalRegistersAtServer()
	ResponseData = AccountingServer.SendGETRequest(ThisObject.IntegrationSettings, "registers");
	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Reg.ExternalName,
	|	Reg.LedgerType
	|FROM
	|	InformationRegister.T9064S_AccountingMappingRegisters AS Reg
	|WHERE
	|	Reg.IntegrationSettings = &IntegrationSettings";
	Query.SetParameter("IntegrationSettings", ThisObject.IntegrationSettings);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	ThisObject.ExternalRegisters.Clear();
	
	For Each Row In ResponseData.Data Do
		NewRow = ThisObject.ExternalRegisters.Add();
		FillPropertyValues(NewRow, Row);
		QuerySelection.Reset();
		If QuerySelection.FindNext(New Structure("ExternalName", Row.Name)) Then
			NewRow.LedgerType = QuerySelection.LedgerType;
			NewRow.Use = True;
		EndIf;	
	EndDo;
EndProcedure

&AtClient
Procedure SetMappingExternalRegisters(Command)
	SetMappingExternalRegistersAtServer();
EndProcedure

&AtServer
Procedure SetMappingExternalRegistersAtServer()
	For Each Row In ThisObject.ExternalRegisters Do
		If Not Row.Use Then
			RecordSet = InformationRegisters.T9064S_AccountingMappingRegisters.CreateRecordSet();
			RecordSet.Filter.ExternalName.Set(Row.Name);
			RecordSet.Filter.IntegrationSettings.Set(ThisObject.IntegrationSettings);
			RecordSet.Clear();
			RecordSet.Write();
			Continue;
		EndIf;
		
		If Row.Use And ValueIsFilled(Row.LedgerType) Then
			RecordSet = InformationRegisters.T9064S_AccountingMappingRegisters.CreateRecordSet();
			RecordSet.Filter.ExternalName.Set(Row.Name);
			RecordSet.Filter.IntegrationSettings.Set(ThisObject.IntegrationSettings);
			Record = RecordSet.Add();
			Record.ExternalName = Row.Name;
			Record.IntegrationSettings = ThisObject.IntegrationSettings;
			Record.LedgerType = Row.LedgerType;
			RecordSet.Write();
		EndIf;
	EndDo;
EndProcedure

#EndRegion

#Region ExtDimensions

&AtClient
Procedure FillExternalExtDimensions(Command)
	FillExternalExtDimensionsAtServer();
	AttachIdleHandler("ExpandExtDimensionsTree", 0.1, True);
EndProcedure

&AtClient
Procedure ExpandExtDimensionsTree() Export
	CommonFormActions.ExpandTree(Items.ExternalExtDimensions, ThisObject.ExternalExtDimensions.GetItems());
EndProcedure

&AtServer
Procedure FillExternalExtDimensionsAtServer()
	ResponseData = AccountingServer.SendGETRequest(ThisObject.IntegrationSettings, "extdimensiontypes", 
		New Structure("name", ThisObject.ExtraDimensionTypes));
	ThisObject.ExternalExtDimensions.GetItems().Clear();
	
	For Each Row In ResponseData.Data Do
		ExternalRef = New UUID(Row.Ref);
		
		NewRow = ThisObject.ExternalExtDimensions.GetItems().Add();
		NewRow.Ref   = Row.Ref;
		NewRow.Code  = Row.Code;
		SetDescriptions(NewRow, Row);
		
		InternalData = GetInternalExtDimension(ExternalRef);
		
		NewRow.InternalRef = InternalData.InternalRef;
		NewRow.Use = ValueIsFilled(NewRow.InternalRef);
			
		For Each ValueType In Row.ValueTypes Do
			ValueTypeRow = NewRow.GetItems().Add();
			
			ValueTypeRow.Ref   = Row.Ref;
						
			ValueTypeRow.BaseClass = ValueType.BaseClass;
			ValueTypeRow.Class     = ValueType.Class;
			ValueTypeRow.IsRef     = ValueType.IsRef;
			
			InternalData = GetInternalExtDimension(ExternalRef, ValueType.BaseClass, ValueType.Class);
			
			ValueTypeRow.InternalRef = InternalData.InternalRef;
			ValueTypeRow.InternalBaseClass = InternalData.InternalBaseClass;
			ValueTypeRow.InternalClass     = InternalData.InternalClass;
			ValueTypeRow.TypePresentation  = "" + InternalData.InternalBaseClass + "." + InternalData.InternalClass;
			ValueTypeRow.Use = ValueIsFilled(ValueTypeRow.InternalRef);
		EndDo; 
	EndDo;	
EndProcedure

&AtClient
Procedure SetMappingExternalExtDimensions(Command)
	CreateAndMapExtDimensions();
	AttachIdleHandler("ExpandExtDimensionsTree", 0.1, True);
EndProcedure

&AtServer
Procedure CreateAndMapExtDimensions()
	SetMappingExternalExtDimensionsAtServer();
	FillExternalExtDimensionsAtServer();
	SetAccountExtDimensions();
EndProcedure

&AtServer
Function GetInternalExtDimension(ExternalRef, ExternalBaseClass = Undefined, ExternalClass = Undefined)
	Query = New Query();
	Query.Text = 
	"SELECT TOP 1
	|	Reg.InternalRef,
	|	Reg.InternalBaseClass,
	|	Reg.InternalClass
	|FROM
	|	InformationRegister.T9065S_AccountingMappingExtDimensions AS Reg
	|WHERE
	|	Reg.IntegrationSettings = &IntegrationSettings
	|	AND Reg.ExternalRef = &ExternalRef
	|	AND CASE
	|		WHEN &Filter_ExternalBaseClass
	|			THEN Reg.ExternalBaseClass = &ExternalBaseClass
	|		ELSE TRUE
	|	END
	|	AND CASE
	|		WHEN &Filter_ExternalClass
	|			THEN Reg.ExternalClass = &ExternalClass
	|		ELSE TRUE
	|	END";
	
	Query.SetParameter("IntegrationSettings", ThisObject.IntegrationSettings);
	Query.SetParameter("ExternalRef"        , ExternalRef);
	Query.SetParameter("ExternalBaseClass"  , ExternalBaseClass);
	Query.SetParameter("Filter_ExternalBaseClass", ValueIsFilled(ExternalBaseClass));
	Query.SetParameter("ExternalClass"      , ExternalClass);
	Query.SetParameter("Filter_ExternalClass"     , ValueIsFilled(ExternalClass));
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	Result = New Structure("InternalRef, InternalBaseClass, InternalClass");
	If QuerySelection.Next() Then
		FillPropertyValues(Result, QuerySelection);
	EndIf;	
	Return Result;
EndFunction

&AtServer
Procedure SetMappingExternalExtDimensionsAtServer()
	For Each Row In ThisObject.ExternalExtDimensions.GetItems() Do
		ExternalRef = New UUID(Row.Ref);
		If Not Row.Use Then
			RecordSet = InformationRegisters.T9065S_AccountingMappingExtDimensions.CreateRecordSet();
			RecordSet.Filter.IntegrationSettings.Set(ThisObject.IntegrationSettings);
			RecordSet.Filter.ExternalRef.Set(ExternalRef);
			RecordSet.Clear();
			RecordSet.Write();
			Continue;
		EndIf;
		
		If Not ValueIsFilled(Row.InternalRef) Then
			// create new
			NewExtDimension = ChartsOfCharacteristicTypes.AccountingExtraDimensionTypes.CreateItem();
			NewExtDimension.ValueType = New TypeDescription("CatalogRef.ExtDimensions");
			SetDescriptions(NewExtDimension, Row);
			NewExtDimension.Write();
			
			Row.InternalRef = NewExtDimension.Ref;
			For Each RowValueType In Row.GetItems() Do
				RowValueType.InternalBaseClass = "Catalogs";
				RowValueType.InternalClass = "ExtDimensions";
			EndDo;				
		EndIf;

		For Each RowValueType In Row.GetItems() Do
			RecordSet = InformationRegisters.T9065S_AccountingMappingExtDimensions.CreateRecordSet();
			RecordSet.Filter.IntegrationSettings.Set(ThisObject.IntegrationSettings);
			RecordSet.Filter.ExternalRef.Set(ExternalRef);
			RecordSet.Filter.ExternalBaseClass.Set(RowValueType.BaseClass);
			RecordSet.Filter.ExternalClass.Set(RowValueType.Class);
		
			Record = RecordSet.Add();
			Record.IntegrationSettings = ThisObject.IntegrationSettings;
			Record.ExternalRef         = ExternalRef;
			Record.ExternalBaseClass   = RowValueType.BaseClass;
			Record.ExternalClass       = RowValueType.Class;
	
			Record.InternalRef       = Row.InternalRef;
			Record.InternalBaseClass = RowValueType.InternalBaseClass;
			Record.InternalClass     = RowValueType.InternalClass;
			RecordSet.Write();
		EndDo;
	EndDo;
EndProcedure

&AtServer
Procedure SetAccountExtDimensions()
	For Each Row In ThisObject.ExternalAccounts Do
		If Row.Use  And ValueIsFilled(Row.InternalRef) Then
			AccountObject = Row.InternalRef.GetObject();
			AccountObject.ExtDimensionTypes.Clear();
			
			i = 1;
			While i <= 3 Do
				ExtDimRef = Row["ExtDimRef" + i];
				
				If Not ValueIsFilled(ExtDimRef) Then
					i = i + 1;
					Continue;
				EndIf;
				
				ExtDimensionsInternalRef = Undefined;
				For Each ExtDimRow In ThisObject.ExternalExtDimensions.GetItems() Do
					If ExtDimRow.Ref = ExtDimRef Then
						ExtDimensionsInternalRef = ExtDimRow.InternalRef;
						Break;
					EndIf;
				EndDo;
				
				If ExtDimensionsInternalRef <> Undefined Then
					NewExtDimRow = AccountObject.ExtDimensionTypes.Add();
					NewExtDimRow.ExtDimensionType = ExtDimensionsInternalRef;
					NewExtDimRow.Amount           = Row["ExtDimAmount" + i]; 		
					NewExtDimRow.Currency         = Row["ExtDimCurrency" + i]; 		
					NewExtDimRow.Quantity         = Row["ExtDimQuantity" + i]; 		
					NewExtDimRow.TurnoversOnly    = Row["ExtDimTurnoversOnly" + i]; 
				EndIf;
				i = i + 1;
			EndDo;
			
			AccountObject.Write();
		EndIf;
	EndDo;
EndProcedure

&AtClient
Procedure ExternalExtDimensionsTypePresentationStartChoice(Item, ChoiceData, ChoiceByAdding, StandardProcessing)
	CurrentData = Items.ExternalExtDimensions.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	RowParent = CurrentData.GetParent();
	If RowParent = Undefined Then
		Return;
	EndIf;
	
	ExtDimensionTypes = GetTypePresentationOfExtDimension(RowParent.InternalRef);
	
	Items.ExternalExtDimensionsTypePresentation.ChoiceList.Clear();
	Items.ExternalExtDimensionsTypePresentation.ChoiceList.LoadValues(ExtDimensionTypes);
EndProcedure

&AtClient
Procedure ExternalExtDimensionsTypePresentationOnChange(Item)
	CurrentData = Items.ExternalExtDimensions.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	If ValueIsFilled(CurrentData.TypePresentation) Then
		Segments = StrSplit(CurrentData.TypePresentation, ".");
		CurrentData.InternalBaseClass = TrimAll(Segments[0]);
		CurrentData.InternalClass = TrimAll(Segments[1]);
	Else
		CurrentData.InternalBaseClass = "";
		CurrentData.InternalClass = "";
	EndIf;			
EndProcedure

&AtClient
Procedure ExternalExtDimensionsInternalRefOnChange(Item)
	CurrentData = Items.ExternalExtDimensions.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	If ValueIsFilled(CurrentData.InternalRef) Then
		CurrentData.Use = True;
		SetSelectedExtDimensions(CurrentData.GetItems(), True);
		
		ExtDimensionTypes = GetTypePresentationOfExtDimension(CurrentData.InternalRef);
		
		For Each Row In CurrentData.GetItems() Do
			Row.InternalRef = CurrentData.InternalRef;
			If ExtDimensionTypes.Count() = 1 Then
				Segments = StrSplit(ExtDimensionTypes[0], ".");
				Row.InternalBaseClass = TrimAll(Segments[0]);
				Row.InternalClass = TrimAll(Segments[1]);
			EndIf;
		EndDo;
	Else
		CurrentData.Use = False;
		SetSelectedExtDimensions(CurrentData.GetItems(), False);
		For Each Row In CurrentData.GetItems() Do
			Row.InternalRef = Undefined;
			Row.InternalBaseClass = "";
			Row.InternalClass = "";
		EndDo;
	EndIf;
	
EndProcedure

&AtServer
Function GetTypePresentationOfExtDimension(ExtDimRef)
	ArrayOfResults = New Array();
	For Each T In ExtDimRef.ValueType.Types() Do
		MetadataObj = Metadata.FindByType(T);
		
		If Metadata.Documents.Contains(MetadataObj) Then
			ArrayOfResults.Add("Documents." + MetadataObj.Name);
		ElsIf Metadata.Catalogs.Contains(MetadataObj) Then
			ArrayOfResults.Add("Catalogs." + MetadataObj.Name);
		ElsIf Metadata.Enums.Contains(MetadataObj) Then
			ArrayOfResults.Add("Enums." + MetadataObj.Name);
		Else
			Raise StrTemplate("Unsupported analytic type [%1]", String(T));
		EndIf;
	EndDo;
	Return ArrayOfResults;
EndFunction

&AtClient
Procedure UnselectAllExternalExtDimensions(Command)
	SetSelectedExtDimensions(ThisObject.ExternalExtDimensions.GetItems(), False);
EndProcedure

&AtClient
Procedure SelectAllExternalExtDimensions(Command)
	SetSelectedExtDimensions(ThisObject.ExternalExtDimensions.GetItems(), True);
EndProcedure

&AtClient
Procedure ExternalExtDimensionsUseOnChange(Item)
	CurrentData = Items.ExternalExtDimensions.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	SetSelectedExtDimensions(CurrentData.GetItems(), CurrentData.Use);
EndProcedure

&AtClient
Procedure SetSelectedExtDimensions(Rows, Value)
	For Each Row In Rows Do
		Row.Use = Value;
		SetSelectedExtDimensions(Row.GetItems(), Value);
	EndDo;
EndProcedure

#EndRegion

&AtServerNoContext
Procedure SetDescriptions(Receiver, Source)
	Receiver.Description_en = Source.Description_en;
	Receiver.Description_ru = Source.Description_ru;
	Receiver.Description_tr = Source.Description_tr;
EndProcedure

&AtClient
Procedure TestPostRequest(Command)
	TestPostRequestAtServer();
EndProcedure

&AtServer
Procedure TestPostRequestAtServer()
	Data = New Structure();
	Data.Insert("StartDate", ThisObject.TestPeriod.StartDate);
	Data.Insert("EndDate", ThisObject.TestPeriod.EndDate);
	Data.Insert("NodeCode", ThisObject.IntegrationSettings.UniqueID);
	Data.Insert("RegisterName", ThisObject.TestRegisterName);
	
	ThisObject.TestPostResponse = AccountingServer.SendPOSTRequest(ThisObject.IntegrationSettings, "get_changes", Data);
EndProcedure

&AtClient
Procedure TestPostRequest2(Command)
	TestPostRequest2AtServer();
EndProcedure

&AtServer
Procedure TestPostRequest2AtServer()
	Data = New Structure();
	Data.Insert("Date", EndOfDay(ThisObject.TestOpeningEntryDate));
	Data.Insert("RegisterName", ThisObject.TestRegisterName);	
	ThisObject.TestPostResponse = AccountingServer.SendPOSTRequest(IntegrationSettings, "get_opening_entry", Data);	
EndProcedure

&AtClient
Procedure TestLoadRecords(Command)
	TestLoadRecordsAtServer();
EndProcedure

&AtServer
Procedure TestLoadRecordsAtServer()
	If ThisObject.TestLoadAllRecords Then
		AccountingServer.LoadAccountingRecordsAll(ThisObject.IntegrationSettings, ThisObject.TestRegisterName);
	Else
		AccountingServer.LoadAccountingRecordsByPeriod(ThisObject.IntegrationSettings,
			ThisObject.TestPeriod.StartDate, ThisObject.TestPeriod.EndDate, ThisObject.TestRegisterName);
	EndIf;
EndProcedure

&AtClient
Procedure TestLoadOpeningEntry(Command)
	TestLoadOpeningEntryAtServer();
EndProcedure

&AtServer
Procedure TestLoadOpeningEntryAtServer()
	AccountingServer.LoadAccountingOpeningEntry(ThisObject.IntegrationSettings, ThisObject.TestOpeningEntryDate, ThisObject.TestRegisterName);
EndProcedure








		
