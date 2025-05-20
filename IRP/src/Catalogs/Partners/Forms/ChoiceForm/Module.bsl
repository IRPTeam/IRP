
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	CatPartnersServer.OnCreateAtServer(Cancel, StandardProcessing, ThisObject, Parameters);
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
	CatalogsServer.OnCreateAtServerChoiceForm(ThisObject, List, Cancel, StandardProcessing);

	ThisObject.FilterGroupType = Parameters.FilterGroupType;
	
	If Parameters.Property("DocumentFilter") Then
		SetListFilter(Parameters.DocumentFilter);
		Items.FilterCustomer.Enabled   = False;
		Items.FilterVendor.Enabled     = False;
		Items.FilterEmployee.Enabled   = False;
		Items.FilterConsignor.Enabled  = False;
		Items.FilterTradeAgent.Enabled = False;
		Items.FilterOther.Enabled      = False;
	Else
		SetListFilter(Parameters.Filter);
		SetBooleanListFilter(List.Filter.Items, "Customer"   , ThisObject.FilterCustomer    , ThisObject.FilterGroupType);
		SetBooleanListFilter(List.Filter.Items, "Vendor"     , ThisObject.FilterVendor      , ThisObject.FilterGroupType);
		SetBooleanListFilter(List.Filter.Items, "Employee"   , ThisObject.FilterEmployee    , ThisObject.FilterGroupType);
		SetBooleanListFilter(List.Filter.Items, "Consignor"  , ThisObject.FilterConsignor   , ThisObject.FilterGroupType);
		SetBooleanListFilter(List.Filter.Items, "TradeAgent" , ThisObject.FilterTradeAgent  , ThisObject.FilterGroupType);
		SetBooleanListFilter(List.Filter.Items, "Other"      , ThisObject.FilterOther       , ThisObject.FilterGroupType);
	EndIf;
	
	Items.FilterCustomer.TitleTextColor   = ?(ThisObject.FilterCustomer   , New Color(), WebColors.LightGray);
	Items.FilterVendor.TitleTextColor     = ?(ThisObject.FilterVendor     , New Color(), WebColors.LightGray);
	Items.FilterEmployee.TitleTextColor   = ?(ThisObject.FilterEmployee   , New Color(), WebColors.LightGray);
	Items.FilterConsignor.TitleTextColor  = ?(ThisObject.FilterConsignor  , New Color(), WebColors.LightGray);
	Items.FilterTradeAgent.TitleTextColor = ?(ThisObject.FilterTradeAgent , New Color(), WebColors.LightGray);
	Items.FilterOther.TitleTextColor      = ?(ThisObject.FilterOther      , New Color(), WebColors.LightGray);
EndProcedure

&AtServer
Procedure SetListFilter(FilterItems)
	For Each FilterItem In FilterItems Do
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
EndProcedure

&AtClient
Procedure ListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	CommonFormActions.DynamicListBeforeAddRow(ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter, "Catalog.Partners.ObjectForm");
EndProcedure

&AtClient
Procedure FilterCustomerOnChange(Item)
	SetBooleanListFilter(List.Filter.Items, "Customer", ThisObject.FilterCustomer, ThisObject.FilterGroupType);
	Item.TitleTextColor = ?(ThisObject.FilterCustomer, New Color(), WebColors.LightGray);
EndProcedure

&AtClient
Procedure FilterVendorOnChange(Item)
	SetBooleanListFilter(List.Filter.Items, "Vendor", ThisObject.FilterVendor, ThisObject.FilterGroupType);
	Item.TitleTextColor = ?(ThisObject.FilterVendor, New Color(), WebColors.LightGray);
EndProcedure

&AtClient
Procedure FilterEmployeeOnChange(Item)
	SetBooleanListFilter(List.Filter.Items, "Employee", ThisObject.FilterEmployee, ThisObject.FilterGroupType);
	Item.TitleTextColor = ?(ThisObject.FilterEmployee, New Color(), WebColors.LightGray);
EndProcedure

&AtClient
Procedure FilterConsignorOnChange(Item)
	SetBooleanListFilter(List.Filter.Items, "Consignor", ThisObject.FilterConsignor, ThisObject.FilterGroupType);
	Item.TitleTextColor = ?(ThisObject.FilterConsignor, New Color(), WebColors.LightGray);
EndProcedure

&AtClient
Procedure FilterTradeAgentOnChange(Item)
	SetBooleanListFilter(List.Filter.Items, "TradeAgent", ThisObject.FilterTradeAgent, ThisObject.FilterGroupType);
	Item.TitleTextColor = ?(ThisObject.FilterTradeAgent, New Color(), WebColors.LightGray);
EndProcedure

&AtClient
Procedure FilterOtherOnChange(Item)
	SetBooleanListFilter(List.Filter.Items, "Other", ThisObject.FilterOther, ThisObject.FilterGroupType);
	Item.TitleTextColor = ?(ThisObject.FilterOther, New Color(), WebColors.LightGray);	
EndProcedure

&AtClientAtServerNoContext
Procedure SetBooleanListFilter(FilterItems, FieldName, RightValue, FilterGroupType)
	If FilterGroupType = "OrGroup" Then
		FilterGroup = Undefined;
		For Each Filter In FilterItems Do
			If TypeOf(Filter) = Type("DataCompositionFilterItemGroup") 
				And Filter.GroupType = DataCompositionFilterItemsGroupType.OrGroup Then
				FilterGroup = Filter;
				Break;
			EndIf;
		EndDo;
		If FilterGroup = Undefined Then
			FilterGroup = FilterItems.Add(Type("DataCompositionFilterItemGroup"));
			FilterGroup.GroupType = DataCompositionFilterItemsGroupType.OrGroup;
		EndIf;
		CommonFunctionsClientServer.SetFilterItem(FilterGroup.Items, FieldName, RightValue, DataCompositionComparisonType.Equal, RightValue = True);
	Else
		CommonFunctionsClientServer.SetFilterItem(FilterItems, FieldName, RightValue, DataCompositionComparisonType.Equal, RightValue = True);
	EndIf;
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "NewPartnerCreated" 
		And ValueIsFilled(Parameter) Then	
		Items.List.CurrentRow = Parameter;
	EndIf;
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