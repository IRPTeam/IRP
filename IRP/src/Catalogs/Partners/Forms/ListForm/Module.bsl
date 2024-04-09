&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
	CatalogsServer.OnCreateAtServerListForm(ThisObject, List, Cancel, StandardProcessing);

	If Parameters.Property("FormTitle") Then
		ThisObject.Title = Parameters.FormTitle;
		ThisObject.AutoTitle = False;
	EndIf;

	For Each FilterItem In Parameters.Filter Do
		If FilterItem.Key = "Customer" Then
			ThisObject.FilterCustomer = FilterItem.Value;
			Items.FilterCustomer.Enabled = False;
		EndIf;
		If FilterItem.Key = "Vendor" Then
			ThisObject.FilterVendor = FilterItem.Value;
			Items.FilterVendor.Enabled = False;
		EndIf;
		If FilterItem.Key = "Employee" Then
			ThisObject.FilterEmployee = FilterItem.Value;
			Items.FilterEmployee.Enabled = False;
		EndIf;
		If FilterItem.Key = "Consignor" Then
			ThisObject.FilterConsignor = FilterItem.Value;
			Items.FilterConsignor.Enabled = False;
		EndIf;
		If FilterItem.Key = "TradeAgent" Then
			ThisObject.FilterTradeAgent = FilterItem.Value;
			Items.FilterTradeAgent.Enabled = False;
		EndIf;
		If FilterItem.Key = "Other" Then
			ThisObject.FilterOther = FilterItem.Value;
			Items.FilterOther.Enabled = False;
		EndIf;		
	EndDo;

	SetBooleanListFilter(List.Filter.Items, "Customer"   , ThisObject.FilterCustomer);
	SetBooleanListFilter(List.Filter.Items, "Vendor"     , ThisObject.FilterVendor);
	SetBooleanListFilter(List.Filter.Items, "Employee"   , ThisObject.FilterEmployee);
	SetBooleanListFilter(List.Filter.Items, "Consignor"  , ThisObject.FilterConsignor);
	SetBooleanListFilter(List.Filter.Items, "TradeAgent" , ThisObject.FilterTradeAgent);
	SetBooleanListFilter(List.Filter.Items, "Other"      , ThisObject.FilterOther);
	
	Items.FilterCustomer.TitleTextColor   = ?(ThisObject.FilterCustomer   , New Color(), WebColors.LightGray);
	Items.FilterVendor.TitleTextColor     = ?(ThisObject.FilterVendor     , New Color(), WebColors.LightGray);
	Items.FilterEmployee.TitleTextColor   = ?(ThisObject.FilterEmployee   , New Color(), WebColors.LightGray);
	Items.FilterConsignor.TitleTextColor  = ?(ThisObject.FilterConsignor  , New Color(), WebColors.LightGray);
	Items.FilterTradeAgent.TitleTextColor = ?(ThisObject.FilterTradeAgent , New Color(), WebColors.LightGray);
	Items.FilterOther.TitleTextColor      = ?(ThisObject.FilterTradeAgent , New Color(), WebColors.LightGray);
EndProcedure

&AtClient
Procedure FilterCustomerOnChange(Item)
	SetBooleanListFilter(List.Filter.Items, "Customer", ThisObject.FilterCustomer);
	Item.TitleTextColor = ?(ThisObject.FilterCustomer, New Color(), WebColors.LightGray);
EndProcedure

&AtClient
Procedure FilterVendorOnChange(Item)
	SetBooleanListFilter(List.Filter.Items, "Vendor", ThisObject.FilterVendor);
	Item.TitleTextColor = ?(ThisObject.FilterVendor, New Color(), WebColors.LightGray);
EndProcedure

&AtClient
Procedure FilterEmployeeOnChange(Item)
	SetBooleanListFilter(List.Filter.Items, "Employee", ThisObject.FilterEmployee);
	Item.TitleTextColor = ?(ThisObject.FilterEmployee, New Color(), WebColors.LightGray);
EndProcedure

&AtClient
Procedure FilterConsignorOnChange(Item)
	SetBooleanListFilter(List.Filter.Items, "Consignor", ThisObject.FilterConsignor);
	Item.TitleTextColor = ?(ThisObject.FilterConsignor, New Color(), WebColors.LightGray);	
EndProcedure

&AtClient
Procedure FilterTradeAgentOnChange(Item)
	SetBooleanListFilter(List.Filter.Items, "TradeAgent", ThisObject.FilterTradeAgent);
	Item.TitleTextColor = ?(ThisObject.FilterTradeAgent, New Color(), WebColors.LightGray);
EndProcedure

&AtClient
Procedure FilterOtherOnChange(Item)
	SetBooleanListFilter(List.Filter.Items, "Other", ThisObject.FilterOther);
	Item.TitleTextColor = ?(ThisObject.FilterOther, New Color(), WebColors.LightGray);
EndProcedure

&AtClientAtServerNoContext
Procedure SetBooleanListFilter(FilterItems, FieldName, RightValue)
	CommonFunctionsClientServer.SetFilterItem(FilterItems, FieldName, RightValue, DataCompositionComparisonType.Equal, RightValue = True);
EndProcedure

#Region COMMANDS

&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	SelectedRows = Items.List.SelectedRows;
	ExternalCommandsClient.GeneratedListChoiceFormCommandActionByName(SelectedRows, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name, SelectedRows);
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName, SelectedRows) Export
	ExternalCommandsServer.GeneratedListChoiceFormCommandActionByName(SelectedRows, ThisObject, CommandName);
EndProcedure

&AtClient
Procedure InternalCommandAction(Command) Export
	InternalCommandsClient.RunCommandAction(Command, ThisObject, List, Items.List.SelectedRows);
EndProcedure

&AtClient
Procedure InternalCommandActionWithServerContext(Command) Export
	InternalCommandActionWithServerContextAtServer(Command.Name);
EndProcedure

&AtServer
Procedure InternalCommandActionWithServerContextAtServer(CommandName)
	InternalCommandsServer.RunCommandAction(CommandName, ThisObject, List, Items.List.SelectedRows);
EndProcedure

#EndRegion