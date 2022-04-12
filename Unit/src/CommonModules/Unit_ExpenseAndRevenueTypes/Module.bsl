
#Region Info

Function Tests() Export
	
	TestList = New Array;
	TestList.Add("ExpenseTypeCompany1");
	TestList.Add("ExpenseTypeCompany1ItemKey");
	TestList.Add("ExpenseTypeCompany1Item");
	TestList.Add("ExpenseTypeCompany1ItemType");
	
	TestList.Add("ExpenseTypeCompany2");
	TestList.Add("ExpenseTypeCompany2ItemKey");
	TestList.Add("ExpenseTypeCompany2Item");
	TestList.Add("ExpenseTypeCompany2ItemType");
		
	TestList.Add("ExpenseTypeCompanyEqualsCompany1");
	TestList.Add("ExpenseTypeCompanyEqualsCompany1ItemKey");
	TestList.Add("ExpenseTypeCompanyEqualsCompany1Item");
	TestList.Add("ExpenseTypeCompanyEqualsCompany1ItemType");
		
	TestList.Add("ExpenseTypeDiffCompany");
	
	Return TestList;
	
EndFunction

Function GetData() Export
	
	PreparedData = New Structure;
	
	Data = New Structure;
	Data.Insert("Company" , Unit_Service.GetData("Catalog.Companies?ref=aa78120ed92fbced11eaf113ba6c185c"));	
	Data.Insert("ItemKey" , Unit_Service.GetData( "Catalog.ItemKeys?ref=a2c1aafaa4d87ef711ecb0fbebb448aa"));
	Data.Insert("Item"    , Unit_Service.GetData(    "Catalog.Items?ref=a2c1aafaa4d87ef711ecb0fbebb448a9"));
	Data.Insert("ItemType", Unit_Service.GetData("Catalog.ItemTypes?ref=a2c1aafaa4d87ef711ecb0fbebb448a7"));
	
	Data.Insert("ERType_Company" , Unit_Service.GetData("Catalog.ExpenseAndRevenueTypes?ref=a2c1aafaa4d87ef711ecb0fbebb448ab"));
	Data.Insert("ERType_ItemKey" , Unit_Service.GetData("Catalog.ExpenseAndRevenueTypes?ref=a2c1aafaa4d87ef711ecb0fbebb448ad"));
	Data.Insert("ERType_Item"    , Unit_Service.GetData("Catalog.ExpenseAndRevenueTypes?ref=a2c1aafaa4d87ef711ecb0fbebb448ac"));
	Data.Insert("ERType_ItemType", Unit_Service.GetData("Catalog.ExpenseAndRevenueTypes?ref=a2c1aafaa4d87ef711ecb0fbebb448ae"));

	PreparedData.Insert("Part1", Data);
	
	Data = New Structure;	
	Data.Insert("Company" , Unit_Service.GetData("Catalog.Companies?ref=a2c1aafaa4d87ef711ecba6501ea0343"));
	Data.Insert("ItemKey" , Unit_Service.GetData( "Catalog.ItemKeys?ref=a2c1aafaa4d87ef711ecb0fbebb448aa"));
	Data.Insert("Item"    , Unit_Service.GetData(    "Catalog.Items?ref=a2c1aafaa4d87ef711ecb0fbebb448a9"));
	Data.Insert("ItemType", Unit_Service.GetData("Catalog.ItemTypes?ref=a2c1aafaa4d87ef711ecb0fbebb448a7"));

	Data.Insert("ERType_Company" , Unit_Service.GetData("Catalog.ExpenseAndRevenueTypes?ref=a2c1aafaa4d87ef711ecb0fbebb41111"));
	Data.Insert("ERType_ItemKey" , Unit_Service.GetData("Catalog.ExpenseAndRevenueTypes?ref=a2c1aafaa4d87ef711ecb0fbebb42222"));
	Data.Insert("ERType_Item"    , Unit_Service.GetData("Catalog.ExpenseAndRevenueTypes?ref=a2c1aafaa4d87ef711ecb0fbebb43333"));
	Data.Insert("ERType_ItemType", Unit_Service.GetData("Catalog.ExpenseAndRevenueTypes?ref=a2c1aafaa4d87ef711ecb0fbebb44444"));

	PreparedData.Insert("Part2", Data);

	Data = New Structure;
	Data.Insert("Company" , Unit_Service.GetData("Catalog.Companies?ref=aa78120ed92fbced11eaf113ba6c185c"));	
	Data.Insert("ItemKey" , Unit_Service.GetData( "Catalog.ItemKeys?ref=a2c1aafaa4d87ef711ecb0fbebb11111"));
	Data.Insert("Item"    , Unit_Service.GetData(    "Catalog.Items?ref=a2c1aafaa4d87ef711ecb0fbebb41111"));
	Data.Insert("ItemType", Unit_Service.GetData("Catalog.ItemTypes?ref=a2c1aafaa4d87ef711ecb0fbebb41111"));
	
	Data.Insert("ERType_Company" , Unit_Service.GetData("Catalog.ExpenseAndRevenueTypes?ref=a2c1aafaa4d87ef711ecb0fbebb448ab"));
	Data.Insert("ERType_ItemKey" , Unit_Service.GetData("Catalog.ExpenseAndRevenueTypes?ref=a2c1aafaa4d87ef711ecb0fbebb448ad"));
	Data.Insert("ERType_Item"    , Unit_Service.GetData("Catalog.ExpenseAndRevenueTypes?ref=a2c1aafaa4d87ef711ecb0fbebb448ac"));
	Data.Insert("ERType_ItemType", Unit_Service.GetData("Catalog.ExpenseAndRevenueTypes?ref=a2c1aafaa4d87ef711ecb0fbebb448ae"));

	PreparedData.Insert("Part3", Data);
	
	Data = New Structure;
	Data.Insert("Company" , Unit_Service.GetData("Catalog.Companies?ref=aa78120ed92fbced11eaf113ba6c185c"));	
	Data.Insert("ItemKey" , Unit_Service.GetData( "Catalog.ItemKeys?ref=a2c1aafaa4d87ef711ecb0fbebb11111"));
	Data.Insert("Item"    , Unit_Service.GetData(    "Catalog.Items?ref=a2c1aafaa4d87ef711ecb0fbebb41111"));
	Data.Insert("ItemType", Unit_Service.GetData("Catalog.ItemTypes?ref=a2c1aafaa4d87ef711ecb0fbebb41111"));
	
	Data.Insert("ERType_Company" , Unit_Service.GetData("Catalog.ExpenseAndRevenueTypes?ref=a2c1aafaa4d87ef711ecb0fbebb448ab"));
	Data.Insert("ERType_ItemKey" , Unit_Service.GetData("Catalog.ExpenseAndRevenueTypes?ref=a2c1aafaa4d87ef711ecb0fbebb448ad"));
	Data.Insert("ERType_Item"    , Unit_Service.GetData("Catalog.ExpenseAndRevenueTypes?ref=a2c1aafaa4d87ef711ecb0fbebb448ac"));
	Data.Insert("ERType_ItemType", Unit_Service.GetData("Catalog.ExpenseAndRevenueTypes?ref=a2c1aafaa4d87ef711ecb0fbebb448ae"));

	PreparedData.Insert("Part4", Data);
	
	Return PreparedData;
	
EndFunction

Function PrepareDB() Export
	
	Data = GetData();
		
	IR = InformationRegisters.ExpenseRevenueTypeSettings.CreateRecordSet();
	IR.Write();
	
	// Part1
	CreateRecordExpenseRevenueTypeSettings(Data, "Part1", "Company");
	CreateRecordExpenseRevenueTypeSettings(Data, "Part1", "ItemKey");
	CreateRecordExpenseRevenueTypeSettings(Data, "Part1", "Item");
	CreateRecordExpenseRevenueTypeSettings(Data, "Part1", "ItemType");
	
	// Part2
	CreateRecordExpenseRevenueTypeSettings(Data, "Part2", "Company");
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

// Part 1
Function ExpenseTypeCompany1() Export
	PrepareDB();
	Data = GetData();
	Filters = GetFilter("Part1", "Company");
	Result = InformationRegisters.ExpenseRevenueTypeSettings.GetExpenseType(Filters);
	Unit_Service.isEqual(Data.Part1.ERType_Company, Result);
	Return "";
EndFunction

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

// Part 2
Function ExpenseTypeCompany2() Export
	PrepareDB();
	Data = GetData();
	Filters = GetFilter("Part2", "Company");
	Result = InformationRegisters.ExpenseRevenueTypeSettings.GetExpenseType(Filters);
	Unit_Service.isEqual(Data.Part2.ERType_Company, Result);
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

// Part 3
Function ExpenseTypeCompanyEqualsCompany1() Export
	PrepareDB();
	Data = GetData();
	Filters = GetFilter("Part3", "Company");
	Result = InformationRegisters.ExpenseRevenueTypeSettings.GetExpenseType(Filters);
	Unit_Service.isEqual(Data.Part3.ERType_Company, Result);
	Return "";
EndFunction

Function ExpenseTypeCompanyEqualsCompany1ItemKey() Export
	PrepareDB();
	Data = GetData();
	Filters = GetFilter("Part3", "ItemKey");
	Result = InformationRegisters.ExpenseRevenueTypeSettings.GetExpenseType(Filters);
	Unit_Service.isEqual(Data.Part3.ERType_Company, Result);
	Return "";
EndFunction

Function ExpenseTypeCompanyEqualsCompany1Item() Export
	PrepareDB();
	Data = GetData();
	Filters = GetFilter("Part3", "Item");
	Result = InformationRegisters.ExpenseRevenueTypeSettings.GetExpenseType(Filters);
	Unit_Service.isEqual(Data.Part3.ERType_Company, Result);
	Return "";
EndFunction

Function ExpenseTypeCompanyEqualsCompany1ItemType() Export
	PrepareDB();
	Data = GetData();
	Filters = GetFilter("Part3", "ItemType");
	Result = InformationRegisters.ExpenseRevenueTypeSettings.GetExpenseType(Filters);
	Unit_Service.isEqual(Data.Part3.ERType_Company, Result);
	Return "";
EndFunction

// Part4
Function ExpenseTypeDiffCompany() Export
	PrepareDB();
	Data = GetData();
	Filters = InformationRegisters.ExpenseRevenueTypeSettings.GetFilter();
	FillPropertyValues(Filters, Data.Part4);
	Result = InformationRegisters.ExpenseRevenueTypeSettings.GetExpenseType(Filters);
	Unit_Service.isEqual(Data.Part4.ERType_Company, Result);
	Return "";
EndFunction


#EndRegion
