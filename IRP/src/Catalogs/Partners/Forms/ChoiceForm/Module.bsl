&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	CatPartnersServer.OnCreateAtServer(Cancel, StandardProcessing, ThisObject, Parameters);
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);

	For Each FilterItem In Parameters.Filter Do
		If FilterItem.Key = "Customer" Then
			FilterCustomer = FilterItem.Value;
			Items.FilterCustomer.Enabled = False;
		EndIf;
		If FilterItem.Key = "Vendor" Then
			FilterVendor = FilterItem.Value;
			Items.FilterVendor.Enabled = False;
		EndIf;
		If FilterItem.Key = "Employee" Then
			FilterEmployee = FilterItem.Value;
			Items.FilterEmployee.Enabled = False;
		EndIf;
		If FilterItem.Key = "Opponent" Then
			FilterOpponent = FilterItem.Value;
			Items.FilterOpponent.Enabled = False;
		EndIf;
	EndDo;

	SetBooleanListFilter(List.Filter.Items, "Customer", FilterCustomer);
	SetBooleanListFilter(List.Filter.Items, "Vendor", FilterVendor);
	SetBooleanListFilter(List.Filter.Items, "Employee", FilterEmployee);
	SetBooleanListFilter(List.Filter.Items, "Opponent", FilterOpponent);

	Items.FilterCustomer.TitleTextColor = ?(FilterCustomer, New Color(), WebColors.LightGray);
	Items.FilterVendor.TitleTextColor = ?(FilterVendor, New Color(), WebColors.LightGray);
	Items.FilterEmployee.TitleTextColor = ?(FilterEmployee, New Color(), WebColors.LightGray);
	Items.FilterOpponent.TitleTextColor = ?(FilterOpponent, New Color(), WebColors.LightGray);
EndProcedure

&AtClient
Procedure ListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	CommonFormActions.DynamicListBeforeAddRow(
				ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter, "Catalog.Partners.ObjectForm");
EndProcedure

&AtClient
Procedure FilterCustomerOnChange(Item)
	SetBooleanListFilter(List.Filter.Items, "Customer", FilterCustomer);
	Item.TitleTextColor = ?(FilterCustomer, New Color(), WebColors.LightGray);
EndProcedure

&AtClient
Procedure FilterVendorOnChange(Item)
	SetBooleanListFilter(List.Filter.Items, "Vendor", FilterVendor);
	Item.TitleTextColor = ?(FilterVendor, New Color(), WebColors.LightGray);
EndProcedure

&AtClient
Procedure FilterEmployeeOnChange(Item)
	SetBooleanListFilter(List.Filter.Items, "Employee", FilterEmployee);
	Item.TitleTextColor = ?(FilterEmployee, New Color(), WebColors.LightGray);
EndProcedure

&AtClient
Procedure FilterOpponentOnChange(Item)
	SetBooleanListFilter(List.Filter.Items, "Opponent", FilterOpponent);
	Item.TitleTextColor = ?(FilterOpponent, New Color(), WebColors.LightGray);
EndProcedure

&AtClientAtServerNoContext
Procedure SetBooleanListFilter(FilterItems, FieldName, RightValue)
	CommonFunctionsClientServer.SetFilterItem(FilterItems, FieldName, RightValue, DataCompositionComparisonType.Equal,
		RightValue = True);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "WritingNew" 
		And ValueIsFilled(Parameter) Then
			
		Items.List.CurrentRow = Parameter;
	EndIf;
EndProcedure