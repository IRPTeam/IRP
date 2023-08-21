// @strict-types

#Region Info

Function Tests() Export
	TestList = New Array; // Array of String
	TestList.Add("CommonFunctionsServer_GetAttributesFromRef");
	TestList.Add("GetItemInfo_GetPackageDimensions");
	TestList.Add("CommonFunctionsClientServer_isBase64Value");
	Return TestList;
EndFunction

#EndRegion

#Region Test

// @skip-check wrong-string-literal-content
Function CommonFunctionsServer_GetAttributesFromRef() Export
	ArrayOfErrors = New Array; // Array of String

	EmptyRef = Catalogs.Items.GetRef(New UUID("11111111-1111-1111-1111-111111111111"));

	If IsBlankString(EmptyRef.DataVersion) Then
		NewItem = Catalogs.Items.CreateItem();
		NewItem.SetNewObjectRef(EmptyRef);
		NewItem.DataExchange.Load = True;
		NewItem.Write();
		EmptyRef = NewItem.Ref;
	EndIf;

	Result = CommonFunctionsServer.GetAttributesFromRef(EmptyRef, "Code, Ref.Code, Ref.Ref.Ref, Ref.Ref.Code"); // Structure

	If Not TypeOf(Result) = Type("Structure") Then
		ArrayOfErrors.Add("Unknown response type");
	Else
		If Not Result.Property("Code") Then
			ArrayOfErrors.Add("Property ""Code"" not found");
		ElsIf Not Result["Code"] = 0 Then
			ArrayOfErrors.Add("Property ""Code"" has an invalid value");
		EndIf;

		If Not Result.Property("Ref") Then
			ArrayOfErrors.Add("Property ""Ref"" not found");
		ElsIf Not TypeOf(Result["Ref"]) = Type("Structure") Then
			ArrayOfErrors.Add("Property ""Ref"" has an unknown type");
		Else
			ResultRef = Result["Ref"]; // Structure
			If Not ResultRef.Property("Ref") Then
				ArrayOfErrors.Add("Property ""Ref.Ref"" not found");
			ElsIf Not TypeOf(ResultRef["Ref"]) = Type("Structure") Then
				ArrayOfErrors.Add("Property ""Ref.Ref"" has an unknown type");
			Else
				ResultRefRef = ResultRef["Ref"];  // Structure
				If Not ResultRefRef.Property("Code") Then
					ArrayOfErrors.Add("Property ""Ref.Ref.Code"" not found");
				ElsIf Not ResultRefRef["Code"] = 0 Then
					ArrayOfErrors.Add("Property ""Ref.Ref.Code"" has an invalid value");
				EndIf;
				If Not ResultRefRef.Property("Ref") Then
					ArrayOfErrors.Add("Property ""Ref.Ref.Ref"" not found");
				ElsIf Not ResultRefRef["Ref"] = EmptyRef Then
					ArrayOfErrors.Add("Property ""Ref.Ref.Ref"" has an invalid value");
				EndIf;
			EndIf;
		EndIf;
	EndIf;

	If ArrayOfErrors.Count() Then
		Unit_Service.assertFalse("Errors in : CommonFunctionsServer.GetAttributesFromRef() - String" + Chars.LF +
			StrConcat(ArrayOfErrors, Chars.LF));
	EndIf;

	Attributes = New Array; // Array of String
	Attributes.Add("Ref");
	Attributes.Add("Code");

	Result = CommonFunctionsServer.GetAttributesFromRef(EmptyRef, Attributes); // Structure

	If Not TypeOf(Result) = Type("Structure") Then
		ArrayOfErrors.Add("Unknown response type");
	Else
		If Not Result.Property("Code") Then
			ArrayOfErrors.Add("Property ""Code"" not found");
		ElsIf Not Result["Code"] = 0 Then
			ArrayOfErrors.Add("Property ""Code"" has an invalid value");
		EndIf;
		If Not Result.Property("Ref") Then
			ArrayOfErrors.Add("Property ""Ref"" not found");
		ElsIf Not Result["Ref"] = EmptyRef Then
			ArrayOfErrors.Add("Property ""Ref"" has an invalid value");
		EndIf;
	EndIf;

	If ArrayOfErrors.Count() Then
		Unit_Service.assertFalse("Errors in : CommonFunctionsServer.GetAttributesFromRef() - Array" + Chars.LF +
			StrConcat(ArrayOfErrors, Chars.LF));
	EndIf;

	Selection = Catalogs.Items.Select();
	If Selection.Next() Then
		Result = CommonFunctionsServer.GetAttributesFromRef(Selection.Ref, Attributes); // Structure

		If Not Selection.Ref = Result["Ref"] Then
			ArrayOfErrors.Add("Property ""Ref"" has an invalid value");
		EndIf;
		If Not Selection.Code = Result["Code"] Then
			ArrayOfErrors.Add("Property ""Code"" has an invalid value");
		EndIf;

		If ArrayOfErrors.Count() Then
			Unit_Service.assertFalse("Errors in : CommonFunctionsServer.GetAttributesFromRef() - Exist Ref" + Chars.LF +
				StrConcat(ArrayOfErrors, Chars.LF));
		EndIf;
	EndIf;

	Return Undefined;
EndFunction

Function GetItemInfo_GetPackageDimensions() Export

	// TEST 0

	Result = GetItemInfo.GetPackageDimensions(Catalogs.ItemKeys.EmptyRef());
	If Not TypeOf(Result) = Type("Structure") Then
		Unit_Service.assertFalse(
			"Errors in : GetItemInfo.GetPackageDimensions() - Unknown result type: " + TypeOf(Result));
	EndIf;

	ArrayOfErrors = New Array; // Array of String
	If Not Result.Property("Weight") Then
		ArrayOfErrors.Add("Property 'Weight' not found");
	EndIf;
	If Not Result.Property("Volume") Then
		ArrayOfErrors.Add("Property 'Volume' not found");
	EndIf;
	If Not Result.Property("Height") Then
		ArrayOfErrors.Add("Property 'Height' not found");
	EndIf;
	If Not Result.Property("Width") Then
		ArrayOfErrors.Add("Property 'Width' not found");
	EndIf;
	If Not Result.Property("Length") Then
		ArrayOfErrors.Add("Property 'Length' not found");
	EndIf;
	If ArrayOfErrors.Count() Then
		Unit_Service.assertFalse("Errors in : GetItemInfo.GetPackageDimensions() " + Chars.LF +
			StrConcat(ArrayOfErrors, Chars.LF));
		Return Undefined;
	EndIf;

	// Creatng mock data
	MockData = New Structure;
	MockData.Insert("Weight", 8);
	MockData.Insert("Volume", 6);
	MockData.Insert("Height", 1);
	MockData.Insert("Width",  2);
	MockData.Insert("Length", 3);

	BeginTransaction();

	// TEST 1

	ItemKeyUnit = Catalogs.Units.CreateItem();
	For Each MockItem In MockData Do
		ItemKeyUnit[MockItem.Key] = MockItem.Value + 20;
	EndDo;
	ItemKeyUnit.DataExchange.Load = True;
	ItemKeyUnit.Write();

	PackageUnit = Catalogs.Units.CreateItem();
	For Each MockItem In MockData Do
		PackageUnit[MockItem.Key] = MockItem.Value + 30;
	EndDo;
	PackageUnit.DataExchange.Load = True;
	PackageUnit.Write();

	ItemUnit = Catalogs.Units.CreateItem();
	For Each MockItem In MockData Do
		ItemUnit[MockItem.Key] = MockItem.Value + 40;
	EndDo;
	ItemUnit.DataExchange.Load = True;
	ItemUnit.Write();

	Item = Catalogs.Items.CreateItem();
	Item.Unit = ItemUnit.Ref;
	Item.PackageUnit = PackageUnit.Ref;
	For Each MockItem In MockData Do
		Item[MockItem.Key] = MockItem.Value + 10;
	EndDo;
	Item.DataExchange.Load = True;
	Item.Write();

	ItemKey = Catalogs.ItemKeys.CreateItem();
	ItemKey.Unit = ItemKeyUnit.Ref;
	ItemKey.Item = Item.Ref;
	For Each MockItem In MockData Do
		ItemKey[MockItem.Key] = MockItem.Value;
	EndDo;
	ItemKey.DataExchange.Load = True;
	ItemKey.Write();

	Result_Test1 = GetItemInfo.GetPackageDimensions(ItemKey.Ref);

	// TEST 2
	For Each MockItem In MockData Do
		ItemKey[MockItem.Key] = 0;
	EndDo;
	ItemKey.DataExchange.Load = True;
	ItemKey.Write();

	Result_Test2 = GetItemInfo.GetPackageDimensions(ItemKey.Ref);

	// TEST 3

	For Each MockItem In MockData Do
		Item[MockItem.Key] = 0;
	EndDo;
	Item.DataExchange.Load = True;
	Item.Write();

	Result_Test3 = GetItemInfo.GetPackageDimensions(ItemKey.Ref);

	// TEST 4

	ItemKey.Unit = Catalogs.Units.EmptyRef();
	ItemKey.DataExchange.Load = True;
	ItemKey.Write();

	Result_Test4 = GetItemInfo.GetPackageDimensions(ItemKey.Ref);

	// TEST 5

	Item.PackageUnit = Catalogs.Units.EmptyRef();
	Item.DataExchange.Load = True;
	Item.Write();

	Result_Test5 = GetItemInfo.GetPackageDimensions(ItemKey.Ref);

	// TEST 6

	For Each MockItem In MockData Do
		ItemUnit[MockItem.Key] = 0;
	EndDo;
	ItemUnit.DataExchange.Load = True;
	ItemUnit.Write();

	Result_Test6 = GetItemInfo.GetPackageDimensions(ItemKey.Ref);

	RollbackTransaction();

	// Check TEST 1
	For Each MockItem In MockData Do
		MockValue = MockItem.Value;
		ResultValue = Result_Test1[MockItem.Key]; // Number
		If Not ResultValue = MockValue Then
			Unit_Service.assertFalse(
				"Errors in : GetItemInfo.GetPackageDimensions() - Test #1: " + Chars.LF +
				MockItem.Key + ": expected " + MockValue + " and got " + ResultValue);
		EndIf;
	EndDo;

	// Check TEST 2
	For Each MockItem In MockData Do
		MockValue = MockItem.Value + 10;
		ResultValue = Result_Test2[MockItem.Key]; // Number
		If Not ResultValue = MockValue Then
			Unit_Service.assertFalse(
				"Errors in : GetItemInfo.GetPackageDimensions() - Test #2: " + Chars.LF +
				MockItem.Key + ": expected " + MockValue + " and got " + ResultValue);
		EndIf;
	EndDo;

	// Check TEST 3
	For Each MockItem In MockData Do
		MockValue = MockItem.Value + 20;
		ResultValue = Result_Test3[MockItem.Key]; // Number
		If Not ResultValue = MockValue Then
			Unit_Service.assertFalse(
				"Errors in : GetItemInfo.GetPackageDimensions() - Test #3: " + Chars.LF +
				MockItem.Key + ": expected " + MockValue + " and got " + ResultValue);
		EndIf;
	EndDo;

	// Check TEST 4
	For Each MockItem In MockData Do
		MockValue = MockItem.Value + 30;
		ResultValue = Result_Test4[MockItem.Key]; // Number
		If Not ResultValue = MockValue Then
			Unit_Service.assertFalse(
				"Errors in : GetItemInfo.GetPackageDimensions() - Test #4: " + Chars.LF +
				MockItem.Key + ": expected " + MockValue + " and got " + ResultValue);
		EndIf;
	EndDo;

	// Check TEST 5
	For Each MockItem In MockData Do
		MockValue = MockItem.Value + 40;
		ResultValue = Result_Test5[MockItem.Key]; // Number
		If Not ResultValue = MockValue Then
			Unit_Service.assertFalse(
				"Errors in : GetItemInfo.GetPackageDimensions() - Test #5: " + Chars.LF +
				MockItem.Key + ": expected " + MockValue + " and got " + ResultValue);
		EndIf;
	EndDo;

	// Check TEST 6
	For Each MockItem In MockData Do
		MockValue = 0;
		ResultValue = Result_Test6[MockItem.Key]; // Number
		If Not ResultValue = MockValue Then
			Unit_Service.assertFalse(
				"Errors in : GetItemInfo.GetPackageDimensions() - Test #6: " + Chars.LF +
				MockItem.Key + ": expected " + MockValue + " and got " + ResultValue);
		EndIf;
	EndDo;

	Return Undefined;
EndFunction

Function CommonFunctionsClientServer_isBase64Value() Export

	TestString = "";
	Unit_Service.isEqual(False, CommonFunctionsClientServer.isBase64Value(TestString));

	TestString = "ASD/";
	Unit_Service.isEqual(False, CommonFunctionsClientServer.isBase64Value(TestString));

	TestString = "====";
	Unit_Service.isEqual(False, CommonFunctionsClientServer.isBase64Value(TestString));

	TestString = "12345678";
	Unit_Service.isEqual(True, CommonFunctionsClientServer.isBase64Value(TestString));

	TestString = "VGVzdA==";
	Unit_Service.isEqual(True, CommonFunctionsClientServer.isBase64Value(TestString));

	Return Undefined;
EndFunction
#EndRegion
