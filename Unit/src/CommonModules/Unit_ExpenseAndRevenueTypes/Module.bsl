
#Region Info

Function Tests() Export
	
	TestList = New Array;
	
	TestList.Add("ExpenseTypeCompany1ItemKey");
	TestList.Add("ExpenseTypeCompany1Item");
	TestList.Add("ExpenseTypeCompany1ItemType");
	
	TestList.Add("ExpenseTypeCompany2ItemKey");
	TestList.Add("ExpenseTypeCompany2Item");
	TestList.Add("ExpenseTypeCompany2ItemType");
	
	Return TestList;
	
EndFunction

Function GetData() Export
	
	PreparedData = New Structure;
	
	Data = New Structure;
	Data.Insert("Item", Unit_Service.GetData("Catalog.Items?ref=b762b13668d0905011eb76684b9f687d"));
	Data.Insert("ItemKey", Unit_Service.GetData("Catalog.ItemKeys?ref=b762b13668d0905011eb76684b9f687e"));
	Data.Insert("ItemType", Unit_Service.GetData("Catalog.ItemTypes?ref=b762b13668d0905011eb76684b9f6878"));
	Data.Insert("Company", Unit_Service.GetData("Catalog.Companies?ref=b762b13668d0905011eb7663e35d7964"));	
	
	Data.Insert("ERType_Empty", Unit_Service.GetData("Catalog.ExpenseAndRevenueTypes?ref=b762b13668d0905011eb76684b9f6861"));
	Data.Insert("ERType_Item", Unit_Service.GetData("Catalog.ExpenseAndRevenueTypes?ref=b762b13668d0905011eb76684b9f6862"));
	Data.Insert("ERType_ItemKey", Unit_Service.GetData("Catalog.ExpenseAndRevenueTypes?ref=b762b13668d0905011eb76684b9f6863"));
	Data.Insert("ERType_ItemType", Unit_Service.GetData("Catalog.ExpenseAndRevenueTypes?ref=b762b13668d0905011eb76684b9f6864"));

	PreparedData.Insert("Part1", Data);
	
	
	Data = New Structure;	
	Data.Insert("ItemKey", Unit_Service.GetData("Catalog.ItemKeys?ref=b762b13668d0905011eb766bf96b2759"));
	Data.Insert("Item", Unit_Service.GetData("Catalog.Items?ref=b762b13668d0905011eb766bf96b2754"));
	Data.Insert("ItemType", Unit_Service.GetData("Catalog.ItemTypes?ref=b762b13668d0905011eb76684b9f6878"));
	Data.Insert("Company", Unit_Service.GetData("Catalog.Companies?ref=b762b13668d0905011eb76684b9f685b"));

	Data.Insert("ERType_Empty", Unit_Service.GetData("Catalog.ExpenseAndRevenueTypes?ref=b762b13668d0905011eb76684b9f6861"));
	Data.Insert("ERType_ItemKey", Unit_Service.GetData("Catalog.ExpenseAndRevenueTypes?ref=b762b13668d0905011eb76684b9f6862"));
	Data.Insert("ERType_Item", Unit_Service.GetData("Catalog.ExpenseAndRevenueTypes?ref=b762b13668d0905011eb76684b9f6863"));
	Data.Insert("ERType_ItemType", Unit_Service.GetData("Catalog.ExpenseAndRevenueTypes?ref=b762b13668d0905011eb76684b9f6864"));

	PreparedData.Insert("Part2", Data);
	
	Return PreparedData;
	
EndFunction

Function PrepareDB() Export
	
	Data = GetData();
		
	IR = InformationRegisters.ExpenseRevenueTypeSettings.CreateRecordSet();
	IR.Write();
	
	// Part1
	
	CreateRecordExpenseRevenueTypeSettings(Data, "Part1", "ItemKey");
	CreateRecordExpenseRevenueTypeSettings(Data, "Part1", "Item");
	CreateRecordExpenseRevenueTypeSettings(Data, "Part1", "ItemType");
	
	// Part2
	
	CreateRecordExpenseRevenueTypeSettings(Data, "Part2", "ItemKey");
	CreateRecordExpenseRevenueTypeSettings(Data, "Part2", "Item");
	CreateRecordExpenseRevenueTypeSettings(Data, "Part2", "ItemType");
	
	Return "OK";
	
EndFunction

Procedure CreateRecordExpenseRevenueTypeSettings(Data, Step, Name)
	
	Filters = GetFilter(Step, Name);
	IR = Unit_Service.GetRecordSet("ExpenseRevenueTypeSettings", Filters);
	NewRow = IR.Add();
	FillPropertyValues(NewRow, Filters);
	NewRow.ExpenseType = Data[Step]["ERType_" + Name];
	NewRow.RevenueType = Data[Step]["ERType_" + Name];
	IR.Write();
	
EndProcedure

Function GetFilter(Step, Name)
	Data = GetData();
	Filters = InformationRegisters.ExpenseRevenueTypeSettings.GetFilter();
	Filters.Company = Data[Step].Company;
	Filters[Name] = Data[Step][Name];
	Return Filters;
EndFunction

#EndRegion

#Region Test

Function ExpenseTypeCompany1ItemKey() Export
	PrepareDB();
	Data = GetData();
	Filters = GetFilter("Part1", "ItemKey");
	Result = InformationRegisters.ExpenseRevenueTypeSettings.GetExpenseType(Filters);
	Unit_Service.isEqual(Data.Part1.ERType_ItemKey, Result);
	Return "";
EndFunction

Function ExpenseTypeCompany1Item() Export
	PrepareDB();
	Data = GetData();
	Filters = GetFilter("Part1", "Item");
	Result = InformationRegisters.ExpenseRevenueTypeSettings.GetExpenseType(Filters);
	Unit_Service.isEqual(Data.Part1.ERType_Item, Result);
	Return "";
EndFunction

Function ExpenseTypeCompany1ItemType() Export
	PrepareDB();
	Data = GetData();
	Filters = GetFilter("Part1", "ItemType");
	Result = InformationRegisters.ExpenseRevenueTypeSettings.GetExpenseType(Filters);
	Unit_Service.isEqual(Data.Part1.ERType_ItemType, Result);
	Return "";
EndFunction

Function ExpenseTypeCompany2ItemKey() Export
	PrepareDB();
	Data = GetData();
	Filters = GetFilter("Part2", "ItemKey");
	Result = InformationRegisters.ExpenseRevenueTypeSettings.GetExpenseType(Filters);
	Unit_Service.isEqual(Data.Part2.ERType_ItemKey, Result);
	Return "";
EndFunction

Function ExpenseTypeCompany2Item() Export
	PrepareDB();
	Data = GetData();
	Filters = GetFilter("Part2", "Item");
	Result = InformationRegisters.ExpenseRevenueTypeSettings.GetExpenseType(Filters);
	Unit_Service.isEqual(Data.Part2.ERType_Item, Result);
	Return "";
EndFunction

Function ExpenseTypeCompany2ItemType() Export
	PrepareDB();
	Data = GetData();
	Filters = GetFilter("Part2", "ItemType");
	Result = InformationRegisters.ExpenseRevenueTypeSettings.GetExpenseType(Filters);
	Unit_Service.isEqual(Data.Part2.ERType_ItemType, Result);
	Return "";
EndFunction

#EndRegion
