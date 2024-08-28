#Region GroupTitle

Function GetGroupItemsArray(Object, Form)
	ItemsArray = New Array();

	If Not CommonFunctionsClientServer.ObjectHasProperty(Form, "GroupItems") Then
		Return ItemsArray;
	EndIf;

	ItemStructure = New Structure();
	ItemStructure.Insert("Title", R().Form_013 + ":" + Chars.NBSp);
	ItemStructure.Insert("Value", Format(Object.Date, "DLF=DDT;"));
	ItemsArray.Add(ItemStructure);
	ItemStructure = New Structure();
	ItemStructure.Insert("Title", R().Form_014 + ":" + Chars.NBSp);
	ItemStructure.Insert("Value", ?(Not ValueIsFilled(Object.Number), "", String(Object.Number)));
	ItemsArray.Add(ItemStructure);

	For Each Attr In Form.GroupItems Do
		// hidden attributes will Not be shown
		If Form.Items.Find(Attr.Value) <> Undefined And Not Form.Items[Attr.Value].Visible Then
			Continue;
		EndIf;
		If Not CommonFunctionsServer.isOjectAttributeAvailableByCurrentFunctionalOptions(Object, Attr.Value) Then
			Continue;
		EndIf;
		ItemStructure = New Structure();
		ItemStructure.Insert("Title", Attr.Presentation);
		ItemStructure.Insert("Value", ?(Not ValueIsFilled(Object[Attr.Value]), "", String(Object[Attr.Value])));
		ItemsArray.Add(ItemStructure);
	EndDo;

	ItemStructure = New Structure();
	ItemStructure.Insert("Title", R().DocStatus_Name + ":" + Chars.NBSp);
	ItemStructure.Insert("Value", 
		?(Object.Ref.IsEmpty(), R().DocStatus_New, 
			?(Object.DeletionMark, R().DocStatus_Deleted, 
				?(Object.Posted, R().DocStatus_Posted, R().DocStatus_NotPosted)
			)
		)
	);
	ItemsArray.Add(ItemStructure);

	Return ItemsArray;
EndFunction

Procedure ChangeTitleGroupTitle(Object, Form, Settings = Undefined) Export

#If Server Then
	If SessionParameters.isMobile Then
		Return;
	EndIf;
#ElsIf MobileClient Then
	Return;
#EndIf

	If Settings <> Undefined And Settings.Property("ChangeTitleGroupTitle") And Not Settings.ChangeTitleGroupTitle Then
		Return;
	EndIf;

	ItemsArray = GetGroupItemsArray(Object, Form);

	If Not ItemsArray.Count() Then
		Return;
	EndIf;

	TitleFont = New Font(Form.Items.DecorationGroupTitleCollapsedLabel.Font, , , True);
	TitleTextColor = WebColors.Gray;
	TitleBackColor = Form.Items.DecorationGroupTitleCollapsedLabel.BackColor;
	If TitleBackColor = New Color() Then
		TitleBackColor = WebColors.White;
	EndIf;

	ValueFont = New Font(Form.Items.DecorationGroupTitleCollapsedLabel.Font);
	ValueTextColor = New Color(28, 85, 174); // Standard hyperlink color (28, 85, 174)
	ValueBackColor = Form.Items.DecorationGroupTitleCollapsedLabel.BackColor;
	If ValueBackColor = New Color() Then
		ValueBackColor = WebColors.White;
	EndIf;

	SeparatorText = "   ";
	SeparatorFont = New Font(Form.Items.DecorationGroupTitleCollapsedLabel.Font);
	SeparatorTextColor = Form.Items.DecorationGroupTitleCollapsedLabel.BackColor;
	If SeparatorTextColor = New Color() Then
		SeparatorTextColor = WebColors.White;
	EndIf;
	SeparatorBackColor = Form.Items.DecorationGroupTitleCollapsedLabel.BackColor;
	If SeparatorBackColor = New Color() Then
		SeparatorBackColor = WebColors.White;
	EndIf;

	TitleArray = New Array();

	For Each Item In ItemsArray Do
		If ValueIsFilled(Item.Value) Then
			TitleRow = New FormattedString(Item.Title, TitleFont, TitleTextColor, TitleBackColor);
			TitleArray.Add(TitleRow);
			TitleRow = New FormattedString(Item.Value, ValueFont, ValueTextColor, ValueBackColor);
			TitleArray.Add(TitleRow);
			TitleRow = New FormattedString(SeparatorText, SeparatorFont, SeparatorTextColor, SeparatorBackColor);
			TitleArray.Add(TitleRow);
		EndIf;
	EndDo;

	TitleRow = New FormattedString(TitleArray);
	If IsBlankString(TitleRow) Then
		Form.Items.DecorationGroupTitleCollapsedLabel.Title = New FormattedString(R().I_3, ValueFont, ValueTextColor,
			ValueBackColor);
	Else
		Form.Items.DecorationGroupTitleCollapsedLabel.Title = TitleRow;
	EndIf;

	TitleFont = New Font(Form.Items.DecorationGroupTitleUncollapsedLabel.Font, , , True);
	TitleTextColor = WebColors.LightGray;
	TitleBackColor = Form.Items.DecorationGroupTitleUncollapsedLabel.BackColor;
	If TitleBackColor = New Color() Then
		TitleBackColor = WebColors.White;
	EndIf;

	ValueFont = New Font(Form.Items.DecorationGroupTitleUncollapsedLabel.Font);
	ValueTextColor = New Color(111, 168, 255);
	ValueBackColor = Form.Items.DecorationGroupTitleUncollapsedLabel.BackColor;
	If ValueBackColor = New Color() Then
		ValueBackColor = WebColors.White;
	EndIf;

	SeparatorText = "   ";
	SeparatorFont = New Font(Form.Items.DecorationGroupTitleUncollapsedLabel.Font);
	SeparatorTextColor = Form.Items.DecorationGroupTitleUncollapsedLabel.BackColor;
	If SeparatorTextColor = New Color() Then
		SeparatorTextColor = WebColors.White;
	EndIf;
	SeparatorBackColor = Form.Items.DecorationGroupTitleUncollapsedLabel.BackColor;
	If SeparatorBackColor = New Color() Then
		SeparatorBackColor = WebColors.White;
	EndIf;

	TitleArray = New Array();

	For Each Item In ItemsArray Do
		If ValueIsFilled(Item.Value) Then
			TitleRow = New FormattedString(Item.Title, TitleFont, TitleTextColor, TitleBackColor);
			TitleArray.Add(TitleRow);
			TitleRow = New FormattedString(Item.Value, ValueFont, ValueTextColor, ValueBackColor);
			TitleArray.Add(TitleRow);
			TitleRow = New FormattedString(SeparatorText, SeparatorFont, SeparatorTextColor, SeparatorBackColor);
			TitleArray.Add(TitleRow);
		EndIf;
	EndDo;

	TitleRow = New FormattedString(TitleArray);
	If IsBlankString(TitleRow) Then
		Form.Items.DecorationGroupTitleUncollapsedLabel.Title = New FormattedString(R().I_3, ValueFont, ValueTextColor,
			ValueBackColor);
	Else
		Form.Items.DecorationGroupTitleUncollapsedLabel.Title = TitleRow;
	EndIf;

EndProcedure

// TODO: Delete parameter Object
Procedure ChangeTitleCollapse(Object = Undefined, Form, TitleVisible = True) Export

#If Server Then
	If SessionParameters.isMobile Then
		Return;
	EndIf;
#ElsIf MobileClient Then
	Return;
#EndIf

	Form.Items.GroupTitleCollapsed.Visible = Not TitleVisible;
	Form.Items.GroupTitleUncollapsed.Visible = TitleVisible;
	Form.Items.GroupTitleItems.Visible = TitleVisible;

EndProcedure

#EndRegion

#Region Common

Function CreateFilterItem(FieldName, Value = Undefined, ComparisonTypeValue = Undefined, DataCompositionComparisonTypeValue = Undefined) Export
	FilterStructure = New Structure();
	FilterStructure.Insert("FieldName", FieldName);
	FilterStructure.Insert("Value", Value);
	FilterStructure.Insert("ComparisonType", ComparisonTypeValue);
	FilterStructure.Insert("DataCompositionComparisonType", DataCompositionComparisonTypeValue);
	Return FilterStructure;
EndFunction

#EndRegion

Procedure SetReadOnlyPaymentTermsCanBePaid(Object, Form) Export
	CalculationTypes_Prepaid = PredefinedValue("Enum.CalculationTypes.Prepaid");
	For Each Row In Form.Object.PaymentTerms Do
		If CommonFunctionsClientServer.ObjectHasProperty(Row, "IsReadOnlyCanBePaid") Then
			Row.IsReadOnlyCanBePaid = (Row.CalculationType <> CalculationTypes_Prepaid);
			If Row.IsReadOnlyCanBePaid Then
				Row.CanBePaid = False;
			EndIf; 
		EndIf;
	EndDo;
EndProcedure

Function FindRowInArrayOfStructures(ArrayOfStructures, KeyNames, 
                                    Value1 = Undefined, 
                                    Value2 = Undefined, 
                                    Value3 = Undefined) Export
	ArrayOfKeys = StrSplit(KeyNames, ",");
	EqualRow = Undefined;
	For Each Row In ArrayOfStructures Do
		RowIsEqual = True;
		
		KeyNumber = 1;
		For Each KeyName In ArrayOfKeys Do
			If KeyNumber = 1 And Value1 <> Undefined Then
				If Row[TrimAll(KeyName)] <> Value1 Then
					RowIsEqual = False;
					Break;
				EndIf;
			EndIf;
			
			If KeyNumber = 2 And Value2 <> Undefined Then
				If Row[TrimAll(KeyName)] <> Value2 Then
					RowIsEqual = False;
					Break;
				EndIf;
			EndIf;
			
			If KeyNumber = 3 And Value3 <> Undefined Then
				If Row[TrimAll(KeyName)] <> Value3 Then
					RowIsEqual = False;
					Break;
				EndIf;
			EndIf;
			
			KeyNumber = KeyNumber + 1;
		EndDo;
		
		If RowIsEqual Then
			EqualRow = Row;
			Break;
		EndIf;
	EndDo;
	Return EqualRow;
EndFunction

Function GetSalesReturnData(Object) Export
	SalesReturnData = New Structure();
	SalesReturnData.Insert("Date", Object.Date);
	ArrayOfSalesDocuments = New Array();
	For Each Row In Object.ItemList Do
		If ValueIsFilled(Row.RetailSalesReceipt) Then
			ArrayOfSalesDocuments.Add(Row.RetailSalesReceipt);
		EndIf;
	EndDo;
	SalesReturnData.Insert("ArrayOfSalesDocuments", ArrayOfSalesDocuments);
	Return SalesReturnData;
EndFunction

Function GetHiddenTables() Export
	
	HiddenTables = New Array;
	
	HiddenTables.Add("RowIDInfo");
	HiddenTables.Add("Currencies");
	HiddenTables.Add("DELETE_TaxList");
	HiddenTables.Add("SpecialOffers");
	HiddenTables.Add("SerialLotNumbers");
	HiddenTables.Add("ShipmentConfirmations");
	HiddenTables.Add("GoodsReceipts");
	HiddenTables.Add("PaymentTerms");
	HiddenTables.Add("AddAttributes");
	HiddenTables.Add("DataSet");
	HiddenTables.Add("DataPrice");
	HiddenTables.Add("AccountingRowAnalytics");
	HiddenTables.Add("AccountingExtDimensions");
	HiddenTables.Add("CostList");
	HiddenTables.Add("RevenueList");
	HiddenTables.Add("AllocationList");
	HiddenTables.Add("ControlCodeStrings");
	HiddenTables.Add("TimeSheetList");
	
	Return HiddenTables;
	
EndFunction
