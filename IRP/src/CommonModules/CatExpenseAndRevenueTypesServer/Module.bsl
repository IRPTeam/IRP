Procedure OnCreateAtServer(Cancel, StandardProcessing, Form, Parameters) Export
	FillingData = Undefined;
	If Parameters.Property("FillingData", FillingData) Then
		Form.FillingData = CommonFunctionsServer.SerializeXMLUseXDTO(FillingData);
	EndIf;

	If Parameters.Property("FormTitle") Then
		Form.Title = Parameters.FormTitle;
		Form.AutoTitle = False;
	EndIf;
EndProcedure

Function GetExpenseType(Company, ItemKey) Export
	Filter = InformationRegisters.ExpenseRevenueTypeSettings.GetFilter();
	Filter.Company  = Company;
	Filter.ItemKey  = ItemKey;
	Filter.Item     = Filter.ItemKey.Item;
	Filter.ItemType = Filter.Item.ItemType;
	ExpenseType = InformationRegisters.ExpenseRevenueTypeSettings.GetExpenseType(Filter);
	Return ExpenseType;
EndFunction

Function GetRevenueType(Company, ItemKey) Export
	Filter = InformationRegisters.ExpenseRevenueTypeSettings.GetFilter();
	Filter.Company  = Company;
	Filter.ItemKey  = ItemKey;
	Filter.Item     = Filter.ItemKey.Item;
	Filter.ItemType = Filter.Item.ItemType;
	RevenueType = InformationRegisters.ExpenseRevenueTypeSettings.GetRevenueType(Filter);
	Return RevenueType;
EndFunction