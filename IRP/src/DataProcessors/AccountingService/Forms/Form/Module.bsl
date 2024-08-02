
&AtClient
Procedure GroupStepsOnCurrentPageChange(Item, CurrentPage)
	If CurrentPage = Items.GroupStep2 Then
		FillAvailableChartsOfAccounts();
	ElsIf CurrentPage = Items.GroupStep3 Then
		 FillAvailableExtraDimensionTypes();
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
	Result = AccountingServer.SendGETRequest(ThisObject.IntegrationSettings, "charts_of_accounts");
	
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
	
	For Each Row In Result Do
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
	//AttachIdleHandler("ExpandExternalAccountsTree", 0.1, True);
EndProcedure

//&AtClient
//Procedure ExpandExternalAccountsTree() Export
//	CommonFormActions.ExpandTree(Items.ExternalAccounts, ThisObject.ExternalAccounts.GetItems());
//EndProcedure

&AtServer
Procedure FillExternalAccountsAtServer()
	Result = AccountingServer.SendGETRequest(ThisObject.IntegrationSettings, "accounts", 
		New Structure("chart", ThisObject.ChartOfAccount));
	//ThisObject.ExternalAccounts.GetItems().Clear();
	ThisObject.ExternalAccounts.Clear();
	//Tree = FormAttributeToValue("ExternalAccounts", Type("ValueTree"));
	For Each Row In Result Do
		//NewRow = Tree.Rows.Add();
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

//	ArrayForDelete = New Array();
	
//	For Each Row In Tree.Rows Do
//		If ValueIsFilled(Row.ParentRef) Then
//			ParentRow = Tree.Rows.Find(Row.ParentRef, "Ref", True);
//			If ParentRow = Undefined Then
//				Raise StrTemplate("Not found parent row with ref:[%1]", Row.ParentRef);
//			EndIf;
//			NewRow = ParentRow.Rows.Add();
//			FillPropertyValues(NewRow, Row);
//			ArrayForDelete.Add(Row);
//		EndIf;
//	EndDo;
	
//	For Each Item In ArrayForDelete Do
//		Tree.Rows.Delete(Item);
//	EndDo;
	
//	Tree.Rows.Sort("Order", True);
	ThisObject.ExternalAccounts.Sort("Order");
	
	
//	ValueToFormAttribute(Tree, "ExternalAccounts");
	
	//GetMappingExternalAccountsAtServer(ThisObject.ExternalAccounts.GetItems());
	GetMappingExternalAccountsAtServer();
EndProcedure

&AtServer
//Procedure GetMappingExternalAccountsAtServer(Rows)
Procedure GetMappingExternalAccountsAtServer()
	//For Each Row In Rows Do
	For Each Row In ThisObject.ExternalAccounts Do
		InternalAccount = GetInternalAccount(Row.Ref, False);
		If ValueIsFilled(InternalAccount) Then
			Row.Use = True;
			Row.InternalRef = InternalAccount;
		EndIf;
		//GetMappingExternalAccountsAtServer(Row.GetItems())
	EndDo;
EndProcedure

&AtClient
Procedure SetMappingExternalAccounts(Command)
	CreateAndMapAccounts();
EndProcedure

&AtServer
Procedure CreateAndMapAccounts()
	//SetMappingExternalAccountsAtServer(ThisObject.ExternalAccounts.GetItems());
	SetMappingExternalAccountsAtServer();
	//SetParentForInternalAccountsAtServer(ThisObject.ExternalAccounts.GetItems());
	SetParentForInternalAccountsAtServer();
EndProcedure

&AtServer
//Procedure SetMappingExternalAccountsAtServer(Rows)
Procedure SetMappingExternalAccountsAtServer()
	//For Each Row In Rows Do
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
//		SetMappingExternalAccountsAtServer(Row.GetItems())
	EndDo;
EndProcedure

&AtServer
Function CreateNewInternalAccount(TreeRow, AccountObj)
	MapAccountType = New Map();
	MapAccountType.Insert(Upper("Active"), AccountType.Active);
	MapAccountType.Insert(Upper("Passive"), AccountType.Passive);
	MapAccountType.Insert(Upper("ActivePassive"), AccountType.ActivePassive);
	
	AccountObj.LedgerTypeVariant = ThisObject.LedgerTypeVariant;
	AccountObj.Code = TreeRow.Code;
	AccountObj.Order = TreeRow.Order;
	AccountObj.Type = MapAccountType.Get(Upper(TreeRow.Type));
	AccountObj.NotUsedForRecords = TreeRow.NotUsedForRecords;
	AccountObj.Quantity = TreeRow.Quantity;
	AccountObj.Currency = TreeRow.Currency;
	AccountObj.OffBalance = TreeRow.OffBalance;
	SetDescriptions(AccountObj, TreeRow);
	
	AccountObj.Write();
	Return AccountObj.Ref;
EndFunction

&AtServer
Function GetInternalAccount(ExternalRef, RaiseExceptionIfNotFound=True)
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
	Query.SetParameter("ExternalChartName", ThisObject.ChartOfAccount);
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
//Procedure SetParentForInternalAccountsAtServer(Rows)
Procedure SetParentForInternalAccountsAtServer()
	//For Each Row In Rows Do
	For Each Row In ThisObject.ExternalAccounts Do
		If ValueIsFilled(Row.ParentRef) And ValueIsFilled(Row.InternalRef) Then
			ParentAccount = GetInternalAccount(Row.ParentRef);
			ObjAccount = Row.InternalRef.GetObject();
			ObjAccount.Parent = ParentAccount;
			ObjAccount.Write();
		EndIf;
		//SetParentForInternalAccountsAtServer(Row.GetItems())
	EndDo;
EndProcedure

&AtClient
Procedure SelectAllExternalAccounts(Command)
	//SetSelectedAccounts(ThisObject.ExternalAccounts.GetItems(), True);
	SetSelectedAccounts(True);
EndProcedure

&AtClient
Procedure UnselectAllExternalAccounts(Command)
	//SetSelectedAccounts(ThisObject.ExternalAccounts.GetItems(), False);
	SetSelectedAccounts(False);
EndProcedure

&AtClient
//Procedure SetSelectedAccounts(Rows, Value)
Procedure SetSelectedAccounts(Value)
	For Each Row In ThisObject.ExternalAccounts Do
		Row.Use = Value;
//		SetSelectedAccounts(Row.GetItems(), Value);
	EndDo;
EndProcedure

&AtClient
Procedure ExternalAccountsUseOnChange(Item)
//	CurrentData = Items.ExternalAccounts.CurrentData;
//	If CurrentData = Undefined Then
//		Return;
//	EndIf;
//
//	If CurrentData.Use Then
//		SetSelectedParentAccounts(CurrentData.GetParent());
//	Else
//		SetSelectedAccounts(CurrentData.GetItems(), False);
//	EndIf;
EndProcedure

//&AtClient
//Procedure SetSelectedParentAccounts(TreeRow)
//	If TreeRow <> Undefined Then
//		TreeRow.Use = True;
//		SetSelectedParentAccounts(TreeRow.GetParent());
//	EndIf;
//EndProcedure

#EndRegion

#Region Companies

&AtClient
Procedure FillExtarnalCompanies(Command)
	FillExtarnalCompaniesAtServer();
EndProcedure

&AtServer
Procedure FillExtarnalCompaniesAtServer()
	Result = AccountingServer.SendGETRequest(ThisObject.IntegrationSettings, "companies");
	
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
	
	For Each Row In Result Do
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
	Result = AccountingServer.SendGETRequest(ThisObject.IntegrationSettings, "currencies");
	
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
	
	For Each Row In Result Do
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
	Result = AccountingServer.SendGETRequest(ThisObject.IntegrationSettings, "registers");
	
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
	
	For Each Row In Result Do
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
	Result = AccountingServer.SendGETRequest(ThisObject.IntegrationSettings, "extdimensiontypes", 
		New Structure("name", ThisObject.ExtraDimensionTypes));
	ThisObject.ExternalExtDimensions.GetItems().Clear();
	
	For Each Row In Result Do
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
	//SetAccountExtDimensions(ThisObject.ExternalAccounts.GetItems());
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
//Procedure SetAccountExtDimensions(Rows)
Procedure SetAccountExtDimensions()
	//For Each Row In Rows Do
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
		//SetAccountExtDimensions(Row.GetItems());
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









		
