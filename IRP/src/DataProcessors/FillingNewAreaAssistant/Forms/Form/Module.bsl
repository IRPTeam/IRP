 #Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Object.Area = Catalogs.DataAreas.FindByCode(SessionParameters.IDValue);
	
	DataProcObject = FormAttributeToValue("Object");
	
	Query = New Query;
	Query.Text = 
	"SELECT TOP 1
	|	DataAreas.Ref,
	|	DataAreas.CompanyName,
	|	DataAreas.CompanyLocalization,
	|	CatCompany.Ref AS Company
	|FROM
	|	Catalog.DataAreas AS DataAreas
	|	LEFT JOIN Catalog.Companies AS CatCompany
	|	ON DataAreas.CompanyName = CatCompany.Description_en
	|		AND NOT CatCompany.DeletionMark
	|WHERE
	|	DataAreas.Ref = &Area;
	|/////////////////////////////////////////
	|SELECT TOP 1
	|	Table.Ref
	|FROM
	|	Catalog.IntegrationSettings AS Table
	|WHERE
	|	Table.Description = &CurrencyRateIntegrationSettings";
	Query.SetParameter("CurrencyRateIntegrationSettings", DataProcObject.CurrencyRateIntegrationSettingsName());
	Query.SetParameter("Area", Object.Area);
	
	Results = Query.ExecuteBatch();
	Selection = Results[0].Select();
	If Selection.Next() Then
		Object.CompanyName         = Selection.CompanyName;
		Object.CompanyLocalization = Lower(Selection.CompanyLocalization);
		
		Object.Company			   = Selection.Company;
	EndIf;
	
	Selection = Results[1].Select();
	If Selection.Next() Then
		Object.CurrencyRateIntegrationSettings = Selection.Ref;
	EndIf;
	 
	FillCurrencyClassifierTable();
	FillAccounts();
	
	// default value - Banknote Buying
	Object.DownloadRateType = "A";
	CollectTax = 2;
	
	FillPagesTable();
	
	Items.GroupPages.CurrentPage = Items[PagesTable[0].PageName];
	
	SetConditionalApeearence();
	SetVisibility(ThisObject);
	
	CommonFunctionsClientServer.SetFilterItem(CompanyTaxes.Filter.Items,
		"Company",
		Object.Company,
		DataCompositionComparisonType.Equal,
		True);
		
	AddAttrSet_ItemsObject = Catalogs.AddAttributeAndPropertySets.Catalog_Items.GetObject();
	ValueToFormAttribute(AddAttrSet_ItemsObject, "AddAttrSet_Items");
	
	AddAttrSet_PartnersObject = Catalogs.AddAttributeAndPropertySets.Catalog_Partners.GetObject();
	ValueToFormAttribute(AddAttrSet_PartnersObject, "AddAttrSet_Partners");
	
	CodeLanguage = ServiceSystemServer.GetSessionParameter("InterfaceLocalizationCode");	
EndProcedure

&AtServer
Procedure SetConditionalApeearence()
	ConditionalAppearance.Items.Clear();
	
	AppearenceElement = ConditionalAppearance.Items.Add();
	
	FieldElement = AppearenceElement.Fields.Items.Add();
	FieldElement.Field			= New DataCompositionField(Items.CurrencyClassifierTable);
	
	FilterElement = AppearenceElement.Filter.Items.Add(Type("DataCompositionFilterItem"));
	FilterElement.LeftValue		= New DataCompositionField("CurrencyClassifierTable.Mark");
	FilterElement.ComparisonType= DataCompositionComparisonType.Equal;
	FilterElement.RightValue    = True;
	
	AppearenceElement.Appearance.SetParameterValue("Font", New Font( , , True));
	
	////////////////////////////////////////////////////////
	AppearenceElement = ConditionalAppearance.Items.Add();
	
	FieldElement = AppearenceElement.Fields.Items.Add();
	FieldElement.Field			= New DataCompositionField(Items.CurrencyClassifierTable);
	
	FilterElement = AppearenceElement.Filter.Items.Add(Type("DataCompositionFilterItem"));
	FilterElement.LeftValue		= New DataCompositionField("CurrencyClassifierTable.AlreadyCreated");
	FilterElement.ComparisonType= DataCompositionComparisonType.Equal;
	FilterElement.RightValue    = True;
	
	AppearenceElement.Appearance.SetParameterValue("ReadOnly", False);
	
EndProcedure

&AtClient
Procedure BeforeClose(Cancel, Exit, WarningText, StandardProcessing)
	BeforeCloseAtServer();
EndProcedure

&AtServer
Procedure BeforeCloseAtServer()
	If DoNotShowAgain Then
		Constants.NotFirstStart.Set(True);
	EndIf;
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibility(Form)
	If ValueIsFilled(Form.Object.Company) Then
		Form.Items.PageCompany.Enabled = False;
	EndIf;
	If ValueIsFilled(Form.Object.CurrencyRateIntegrationSettings) Then
		Form.Items.GroupCurrencyRateSettings.Enabled = False;
	EndIf;
	Form.Items.CompanyTaxes.Visible = (Form.CollectTax=1);
EndProcedure

#EndRegion


&AtServer
Procedure FillPagesTable()
	PagesTable.Clear();
	For Each ItemPage In Items.GroupPages.ChildItems Do
		If TypeOf(ItemPage) = Type("FormGroup")
				AND ItemPage.Type = FormGroupType.Page Then
			PagesTable.Add().PageName = ItemPage.Name;
		EndIf;
	EndDo;
EndProcedure

&AtServer
Procedure FillCurrencyClassifierTable()
	CurrencyClassifierTable.Clear();
	Query = New Query(
	"SELECT
	|	Currencies.NumericCode
	|FROM
	|	Catalog.Currencies AS Currencies");
	SelectionExisting = Query.Execute().Select();
	
	ClassifierData = FillingFromClassifiers.GetClassifierData("Catalog.Currencies");
	For Each ClassifierStructure In ClassifierData Do
		NewRow = CurrencyClassifierTable.Add();
		FillPropertyValues(NewRow, ClassifierStructure);
		
		SelectionExisting.Reset();
		NewRow.AlreadyCreated = SelectionExisting.FindNext(New Structure("NumericCode", ClassifierStructure.NumericCode));
		NewRow.Mark = NewRow.AlreadyCreated;
	EndDo;
EndProcedure

&AtServer
Procedure FillAccounts()
	If Not ValueIsFilled(Object.Company) Then
		Return;
	EndIf;
	
	Object.CreatedCashAccounts.Clear();
	Object.CreatedBankAccounts.Clear();
	
	Query = New Query(
	"SELECT
	|	CashAccounts.Ref AS CashAccount,
	|	CashAccounts.Type
	|FROM
	|	Catalog.CashAccounts AS CashAccounts
	|WHERE
	|	CashAccounts.Company = &Company");
	Query.SetParameter("Company", Object.Company);
	
	Selection = Query.Execute().Select();
	While Selection.Next() Do
		If Selection.Type = PredefinedValue("Enum.CashAccountTypes.Cash") Then
			Object.CreatedCashAccounts.Add().CashAccount = Selection.CashAccount;
		EndIf;
		If Selection.Type = PredefinedValue("Enum.CashAccountTypes.Bank") Then
			Object.CreatedBankAccounts.Add().CashAccount = Selection.CashAccount;
		EndIf;	
	EndDo;	
EndProcedure


#Region CommandInterface

&AtClient
Procedure Next(Command)
	If Not CheckPageFilling() Then
		Return;	
	EndIf;
	
	PageIndex = CurrentPageIndex();
	If PageIndex < PagesTable.Count()-1 Then
		If Items.GroupPages.CurrentPage.Enabled Then
			GroupPagesBeforeCurrentPageChangeAtServer();
		EndIf;
		Items.GroupPages.CurrentPage = Items[PagesTable[PageIndex+1].PageName];
	Else
		FinishAtServer();
		Close();
	EndIf;	
	
	GroupPagesOnCurrentPageChange(Items.GroupPages, Items.GroupPages.CurrentPage);
EndProcedure

&AtClient
Procedure Previous(Command)
	If Not CheckPageFilling() Then
		Return;	
	EndIf;
	
	PageIndex = CurrentPageIndex();
	Items.GroupPages.CurrentPage = Items[PagesTable[PageIndex-1].PageName];	
	
	GroupPagesOnCurrentPageChange(Items.GroupPages, Items.GroupPages.CurrentPage);
EndProcedure

#EndRegion


&AtClient
Function CheckPageFilling()	
	OK = True;
	If Not Items.GroupPages.CurrentPage.Enabled Then
		Return OK;
	EndIf;
	
	If Items.GroupPages.CurrentPage = Items.PageCompany Then
		If Not ValueIsFilled(Object.CompanyName) Then
			MessageText = StrTemplate(R()["Error_010"], "Company");
			CommonFunctionsClientServer.ShowUsersMessage(MessageText,
						"Object.CompanyName",
						);
			OK = False;
		EndIf;
		MarkedRows = CurrencyClassifierTable.FindRows(New Structure("Mark", True));
		If Not MarkedRows.Count() Then
			MessageText = StrTemplate(R()["Error_048"], "Currency", "classifier");
			CommonFunctionsClientServer.ShowUsersMessage(MessageText,
						"CurrencyClassifierTable",
						);
			OK = False;
		EndIf;
		If Not ValueIsFilled(Object.DownloadRateType) Then
			MessageText = StrTemplate(R()["Error_010"], R()["Form_021"]);
			CommonFunctionsClientServer.ShowUsersMessage(MessageText,
						"Object.DownloadRateType",
						);
			OK = False;
		EndIf;
	ElsIf Items.GroupPages.CurrentPage = Items.PageCustomFieldsSettings Then
		For Each Row In AddAttrSet_Items.Attributes Do
			If Not ValueIsFilled(Row.Attribute) Then
				MessageText = StrTemplate(R()["Error_010"], "Attribute");
				CommonFunctionsClientServer.ShowUsersMessage(MessageText,
							"AddAttrSet_Items.Attributes",
							);
				OK = False;
			EndIf;
		EndDo;
		For Each Row In AddAttrSet_Partners.Attributes Do
			If Not ValueIsFilled(Row.Attribute) Then
				MessageText = StrTemplate(R()["Error_010"], "Attribute");
				CommonFunctionsClientServer.ShowUsersMessage(MessageText,
							"AddAttrSet_Partners.Attributes",
							);
				OK = False;
			EndIf;
		EndDo;
	Else
		OK = True;
	EndIf;
	
	Return OK;
EndFunction

&AtClient
Function CurrentPageIndex()	
	Str = New Structure("PageName", Items.GroupPages.CurrentPage.Name);
	Return PagesTable.IndexOf(PagesTable.FindRows(Str)[0]);
EndFunction

&AtClient
Procedure GroupPagesOnCurrentPageChange(Item, CurrentPage)
	PageIndex = CurrentPageIndex();
	
	If PagesTable.Count() = PageIndex+1 Then
		Items.Next.Title         = R().Form_015;
		Items.Next.DefaultButton = True;
	Else
		Items.Next.Title         = R().Form_016 + ">";
		Items.Next.DefaultButton = False;
	EndIf;
	
	If PageIndex = 0 Then
		Items.Previous.Enabled = False;
	Else
		Items.Previous.Enabled = True;
	EndIf;	
	
	GroupPagesOnCurrentPageChangeAtServer();
EndProcedure

&AtServer
Procedure GroupPagesOnCurrentPageChangeAtServer()
	If Items.GroupPages.CurrentPage = Items.PageCashStorage Then	
		// Default Cash and Bank account
		DataProcObject = FormAttributeToValue("Object");
		DataProcObject.CreateDefaultCashAndBankAccounts();
		FillAccounts();
	EndIf;
EndProcedure

&AtServer
Procedure GroupPagesBeforeCurrentPageChangeAtServer()
	If Items.GroupPages.CurrentPage = Items.PageCompany Then
		DataProcObject = FormAttributeToValue("Object");
		 
		DataProcessors.FillingNewAreaAssistant.CreateDefaultObjects();
		
		// 1.Currency rates Integration settings
		DataProcObject.CreateCurrencyRateIntegrationSettings();
		
		// 2.Company
		DataProcObject.CreateCompany();
		
		// 3.Currencies
		MarkedRows = CurrencyClassifierTable.FindRows(New Structure("Mark, AlreadyCreated", True, False));
		CurrenciesArray = New Array();
		For Each MarkedRow In MarkedRows Do
			CurrenciesStructure = New Structure("Code", MarkedRow.Code);
			CurrenciesArray.Add(CurrenciesStructure);
		EndDo;
		DataProcObject.CreateCurrencies(CurrenciesArray);
		
		
		// 4.Agreements
		DataProcObject.CreateAgreements();
		
		CommonFunctionsClientServer.SetFilterItem(CompanyTaxes.Filter.Items,
				"Company",
				Object.Company,
				DataCompositionComparisonType.Equal,
				True);
				
		ValueToFormAttribute(DataProcObject, "Object");
	EndIf;
	
	If Items.GroupPages.CurrentPage = Items.PageCustomFieldsSettings Then
		
		// 1.Add attribute and property set Catalog_Items 
		CatalogObject = FormAttributeToValue("AddAttrSet_Items");
		If IsBlankString(CatalogObject.Description_en) Then
			CatalogObject.Description_en = "Catalog_Items";
		EndIf;
		CatalogObject.Write();
		ValueToFormAttribute(CatalogObject, "AddAttrSet_Items");
		
		CommonFunctionsClientServer.ShowUsersMessage(
					StrTemplate(R()["InfoMessage_002"], CatalogObject));
					
		// 2.Add attribute and property set Catalog_Partners
		CatalogObject = FormAttributeToValue("AddAttrSet_Partners");
		If IsBlankString(CatalogObject.Description_en) Then
			CatalogObject.Description_en = "Catalog_Partners";
		EndIf;
		
		CatalogObject.Write();
		ValueToFormAttribute(CatalogObject, "AddAttrSet_Partners");
		
		CommonFunctionsClientServer.ShowUsersMessage(
					StrTemplate(R()["InfoMessage_002"], CatalogObject));
	EndIf;
	
	SetVisibility(ThisObject);
EndProcedure

&AtServer
Procedure FinishAtServer()
	DataProcObject = FormAttributeToValue("Object");
	DataProcObject.CreateFinishData();
	
	DoNotShowAgain = True;
	Constants.NotFirstStart.Set(True);
EndProcedure


#Region PageAccounts

&AtClient
Procedure CreatedCashAccountsOnActivateRow(Item)
	If Items.CreatedCashAccounts.CurrentData <> Undefined Then
		If NOT ValueIsFilled(Items.CreatedCashAccounts.CurrentData.CashAccount) Then
			FormParameters = New Structure("FillingValues", New Structure());
			FormParameters.FillingValues.Insert("Type"   , PredefinedValue("Enum.CashAccountTypes.Cash"));
			FormParameters.FillingValues.Insert("Company", Object.Company);
			FormParameters.Insert("CurrencyType", "Fixed");
			NewObjectForm = OpenForm("Catalog.CashAccounts.Form.ItemForm", FormParameters, ThisObject, , , , , );
			NotifyParameters = New Structure("TableName" , "CreatedCashAccounts");
			NotifyParameters.Insert("Form", NewObjectForm);
			NewObjectForm.OnCloseNotifyDescription = New NotifyDescription(
						"AfterCreatingNewAccount", ThisObject, NotifyParameters);
		EndIf;
	EndIf;
EndProcedure

&AtClient
Procedure CreatedBankAccountsOnActivateRow(Item)
	If Items.CreatedBankAccounts.CurrentData <> Undefined Then
		If NOT ValueIsFilled(Items.CreatedBankAccounts.CurrentData.CashAccount) Then
			FormParameters = New Structure("FillingValues", New Structure());
			FormParameters.FillingValues.Insert("Type"   , PredefinedValue("Enum.CashAccountTypes.Bank"));
			FormParameters.FillingValues.Insert("Company", Object.Company);
			NewObjectForm = OpenForm("Catalog.CashAccounts.Form.ItemForm", FormParameters, ThisObject, , , , , );
			NotifyParameters = New Structure("TableName" , "CreatedBankAccounts");
			NotifyParameters.Insert("Form", NewObjectForm);
			NewObjectForm.OnCloseNotifyDescription = New NotifyDescription(
						"AfterCreatingNewAccount", ThisObject, NotifyParameters);
		EndIf;
	EndIf;
EndProcedure

&AtClient
Procedure AfterCreatingNewAccount(Result, AdditionalParameters) Export
	Var TableName, Form;
	
	If AdditionalParameters.Property("TableName", TableName)
			AND AdditionalParameters.Property("Form", Form) 
			AND TypeOf(Form) = Type("ClientApplicationForm") Then
				
		If ValueIsFilled(Form.Parameters.Key) Then
			Items[TableName].CurrentData.CashAccount = Form.Parameters.Key;
		Else
			ArrayOfEmpty = Object[TableName].FindRows(
					New Structure("CashAccount", PredefinedValue("Catalog.CashAccounts.EmptyRef")));
			For Each EmptyRow In ArrayOfEmpty Do
				Object[TableName].Delete(EmptyRow);
			EndDo;
		EndIf;
	EndIf;
EndProcedure

&AtClient
Procedure CreatedCashAccountsSelection(Item, RowSelected, Field, StandardProcessing)
	If Items.CreatedCashAccounts.CurrentData <> Undefined Then
		OpenValue(Items.CreatedCashAccounts.CurrentData.CashAccount);
	EndIf;
EndProcedure

&AtClient
Procedure CreatedBankAccountsSelection(Item, RowSelected, Field, StandardProcessing)
	If Items.CreatedBankAccounts.CurrentData <> Undefined Then
		OpenValue(Items.CreatedBankAccounts.CurrentData.CashAccount);
	EndIf;
EndProcedure

#EndRegion


#Region PageTaxes

&AtClient
Procedure CollectTaxOnChange(Item)
	FillTaxesAtServer();
	
	CommonFunctionsClientServer.SetFilterItem(CompanyTaxes.Filter.Items,
		"Company",
		Object.Company,
		DataCompositionComparisonType.Equal,
		True);
		
	SetVisibility(ThisObject);
EndProcedure

&AtServer
Procedure FillTaxesAtServer()
	DataProcObject = FormAttributeToValue("Object");
	DataProcObject.FillDefaultCompanyTaxes();
	Items.CollectTax.Enabled = False;			
EndProcedure

#EndRegion

