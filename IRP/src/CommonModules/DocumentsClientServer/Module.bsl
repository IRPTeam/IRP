
#Region GroupTitle

Function GetGroupItemsArray(Object, Form)
	ItemsArray = New Array;
	
	ItemStructure = New Structure;
	ItemStructure.Insert("Title", R().Form_013 + ":" + Chars.NBSp);
	ItemStructure.Insert("Value", Format(Object.Date, "DLF=DDT;"));
	ItemsArray.Add(ItemStructure);
	ItemStructure = New Structure;
	ItemStructure.Insert("Title", R().Form_014 + ":" + Chars.NBSp);
	ItemStructure.Insert("Value", ?(Not ValueIsFilled(Object.Number), "", String(Object.Number)));
	ItemsArray.Add(ItemStructure);
	
	For Each Atr In Form.GroupItems Do
		// hidden attributes will Not be shown
		If Form.Items.Find(Atr.Value) <> Undefined
			AND Not Form.Items[Atr.Value].Visible Then
			Continue;
		EndIf;
		ItemStructure = New Structure;
		ItemStructure.Insert("Title", Atr.Presentation);
		ItemStructure.Insert("Value", ?(Not ValueIsFilled(Object[Atr.Value]), "", String(Object[Atr.Value])));
		ItemsArray.Add(ItemStructure);
	EndDo;
	
	Return ItemsArray;
EndFunction

Procedure ChangeTitleGroupTitle(Object, Form) Export
		
	#If Server Then
	If SessionParameters.isMobile Then
		Return;
	EndIf;
	#ElsIf MobileClient Then
	Return;
	#EndIf
	
	ItemsArray = GetGroupItemsArray(Object, Form);
	
	TitleFont = New Font(Form.Items.DecorationGroupTitleCollapsedLabel.Font, , , True);
	TitleTextColor = WebColors.Gray;
	TitleBackColor = Form.Items.DecorationGroupTitleCollapsedLabel.BackColor;
	If TitleBackColor = New Color Then
		TitleBackColor = WebColors.White;
	EndIf;
	
	ValueFont = New Font(Form.Items.DecorationGroupTitleCollapsedLabel.Font);
	ValueTextColor = New Color(28, 85, 174); // Standard hyperlink color (28, 85, 174)
	ValueBackColor = Form.Items.DecorationGroupTitleCollapsedLabel.BackColor;
	If ValueBackColor = New Color Then
		ValueBackColor = WebColors.White;
	EndIf;
	
	SeparatorText = "   ";
	SeparatorFont = New Font(Form.Items.DecorationGroupTitleCollapsedLabel.Font);
	SeparatorTextColor = Form.Items.DecorationGroupTitleCollapsedLabel.BackColor;
	If SeparatorTextColor = New Color Then
		SeparatorTextColor = WebColors.White;
	EndIf;
	SeparatorBackColor = Form.Items.DecorationGroupTitleCollapsedLabel.BackColor;
	If SeparatorBackColor = New Color Then
		SeparatorBackColor = WebColors.White;
	EndIf;
	
	TitleArray = New Array;
	
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
		Form.Items.DecorationGroupTitleCollapsedLabel.Title = New FormattedString(R().I_3,
				ValueFont, ValueTextColor, ValueBackColor);
	Else
		Form.Items.DecorationGroupTitleCollapsedLabel.Title = TitleRow;
	EndIf;
	
	TitleFont = New Font(Form.Items.DecorationGroupTitleUncollapsedLabel.Font, , , True);
	TitleTextColor = WebColors.LightGray;
	TitleBackColor = Form.Items.DecorationGroupTitleUncollapsedLabel.BackColor;
	If TitleBackColor = New Color Then
		TitleBackColor = WebColors.White;
	EndIf;
	
	ValueFont = New Font(Form.Items.DecorationGroupTitleUncollapsedLabel.Font);
	ValueTextColor = New Color(111, 168, 255);
	ValueBackColor = Form.Items.DecorationGroupTitleUncollapsedLabel.BackColor;
	If ValueBackColor = New Color Then
		ValueBackColor = WebColors.White;
	EndIf;
	
	SeparatorText = "   ";
	SeparatorFont = New Font(Form.Items.DecorationGroupTitleUncollapsedLabel.Font);
	SeparatorTextColor = Form.Items.DecorationGroupTitleUncollapsedLabel.BackColor;
	If SeparatorTextColor = New Color Then
		SeparatorTextColor = WebColors.White;
	EndIf;
	SeparatorBackColor = Form.Items.DecorationGroupTitleUncollapsedLabel.BackColor;
	If SeparatorBackColor = New Color Then
		SeparatorBackColor = WebColors.White;
	EndIf;
	
	TitleArray = New Array;
	
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
		Form.Items.DecorationGroupTitleUncollapsedLabel.Title = New FormattedString(R().I_3,
				ValueFont, ValueTextColor, ValueBackColor);
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

Procedure SetVisibilityItemsByArray(Items, Val ArrayAll, Val ArrayVisible) Export
	If TypeOf(ArrayVisible) <> Type("Array") Then
		ArrayVisible = New Array();
	EndIf;
	For Each ArrayElement In ArrayAll Do
		ItemName = StrReplace(ArrayElement, ".", "");
		Visibility = (ArrayVisible.Find(ArrayElement) <> Undefined);
		If Items.Find(ItemName) <> Undefined
			And Items[ItemName].Visible <> Visibility Then
			Items[ItemName].Visible = Visibility;
		EndIf;
	EndDo;
EndProcedure

Procedure CleanDataByArray(Object, Val ArrayAll, Val ArrayVisible) Export
	If TypeOf(ArrayVisible) <> Type("Array") Then
		ArrayVisible = New Array();
	EndIf;
	For Each ArrayElement In ArrayAll Do
		If Not ArrayVisible.Find(ArrayElement) = Undefined Then
			Continue;
		EndIf;
		
		If StrFind(ArrayElement, ".") Then
			TableName = Left(ArrayElement, StrFind(ArrayElement, ".") - 1);
			ItemName = StrReplace(ArrayElement, TableName + ".", "");
			For Each Row In Object[TableName] Do
				Row[ItemName] = Undefined;
			EndDo;
		Else
			If ServiceSystemClientServer.ObjectHasAttribute(ArrayElement, Object) Then
				Object[ArrayElement] = Undefined;
			EndIf;
		EndIf;
	EndDo;
EndProcedure

#Region Stores
Procedure FillStores(ObjectData, Form) Export
	
	#If AtServer Then
	If Not ValueIsFilled(Form.CurrentStore) Then
		Form.CurrentStore = DocumentsServer.GetCurrentStore(ObjectData);
	EndIf;
	#EndIf
	
	StoreArray = New Array;
	For Each Row In ObjectData.ItemList Do
		If ValueIsFilled(Row.Store) Then
			If StoreArray.Find(Row.Store) = Undefined Then
				StoreArray.Add(Row.Store);
			EndIf;
		EndIf;
	EndDo;
	
	If StoreArray.Count() = 0 Then
		Form.Items.Store.InputHint = "";
		Form.Store = Form.CurrentStore;
	ElsIf StoreArray.Count() = 1 Then
		Form.Items.Store.InputHint = "";
		Form.Store = StoreArray[0];
		If Not ValueIsFilled(Form.CurrentStore) Then
			Form.CurrentStore = Form.Store;
		EndIf;
	Else
		Form.Store = PredefinedValue("Catalog.Stores.EmptyRef");
		Form.Items.Store.InputHint = StrConcat(StoreArray, "; ");
	EndIf;
	Form.StoreBeforeChange = Form.Store;
	
EndProcedure

Function GetStructureFillStores() Export
	
	ObjectData = New Structure();
	ObjectData.Insert("ItemList");
	ObjectData.Insert("Agreement");
	ObjectData.Insert("Ref");
	
	Return ObjectData;
EndFunction

#EndRegion

#Region Common

Function CreateFilterItem(FieldName, Value = Undefined, ComparisonTypeValue = Undefined, DataCompositionComparisonTypeValue = Undefined) Export
	FilterStructure = New Structure();
	FilterStructure.Insert("FieldName",						FieldName);
	FilterStructure.Insert("Value",							Value);
	FilterStructure.Insert("ComparisonType",				ComparisonTypeValue);
	FilterStructure.Insert("DataCompositionComparisonType",	DataCompositionComparisonTypeValue);
	Return FilterStructure;
EndFunction

#EndRegion

#Region Common
Procedure FillDefinedData(Object, Form) Export
	If (Not Form.Parameters.Property("CopyingValue") Or NOT ValueIsFilled(Form.Parameters.CopyingValue)) 
		AND (Not Form.Parameters.Property("BasedOn") Or NOT Form.Parameters.FillingValues.Property("BasedOn")) Then
		AgreementInfo = CatAgreementsServer.GetAgreementInfo(Object.Agreement);
		Object.PriceIncludeTax 	= AgreementInfo.PriceIncludeTax;
		Object.Currency 		= AgreementInfo.Currency;
		
	EndIf;
EndProcedure
#EndRegion