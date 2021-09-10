Procedure ShowUsersMessage(Text, Field = Undefined, Data = Undefined, AddInfo = Undefined) Export
	Message = New UserMessage();
	Message.Text = Text;
	Message.Field = Field;
	Message.SetData(Data);
	Message.Message();
EndProcedure

Procedure SetListFilters(List, QueryFilters) Export
	Filters = List.Filter.Items;
	For Each Filter In QueryFilters Do
		SetFilterItem(Filters, Filter.FieldName, Filter.Value, Filter.DataCompositionComparisonType);
	EndDo;
EndProcedure

Procedure SetFilterItem(FilterItems, Val FieldName, Val RightValue, Val ComparisonType, Val Use = True) Export

	If ComparisonType = Undefined Then
		ComparisonType = DataCompositionComparisonType.Equal;
	EndIf;

	Field = New DataCompositionField(FieldName);
	FilterItem = Undefined;
	For Each Element In FilterItems Do
		If TypeOf(Element) = Type("DataCompositionFilterItem") And Element.LeftValue = Field Then
			FilterItem = Element;
			Break;
		EndIf;
	EndDo;
	If FilterItem = Undefined Then
		FilterItem = FilterItems.Add(Type("DataCompositionFilterItem"));
	EndIf;

	FilterItem.LeftValue = Field;
	FilterItem.Use = Use;
	FilterItem.ComparisonType = ComparisonType;
	FilterItem.RightValue = RightValue;

EndProcedure

Function CompositionComparisonTypeToComparisonType(CompositionComparisonType) Export
	Map = New Map();
	Map.Insert(DataCompositionComparisonType.Equal, ComparisonType.Equal);
	Map.Insert(DataCompositionComparisonType.NotEqual, ComparisonType.NotEqual);
	Map.Insert(DataCompositionComparisonType.InList, ComparisonType.InList);
	Result = Map.Get(CompositionComparisonType);
	If Result = Undefined Then
		Raise R().Error_037;
	EndIf;
	Return Result;
EndFunction

Function ObjectHasProperty(Object, Property) Export
	If TypeOf(Object) = Type("Structure") Then
		Return Object.Property(Property);
	EndIf;

	NewUUID = New UUID();
	Str = New Structure(Property, NewUUID);
	FillPropertyValues(Str, Object);
	Return Str[Property] <> NewUUID;
EndFunction

Procedure PutToAddInfo(AddInfo, Key, Value) Export
	If TypeOf(AddInfo) <> Type("Structure") Then
		AddInfo = New Structure();
	EndIf;
	If AddInfo.Property(Key) Then
		AddInfo[Key] = Value;
	Else
		AddInfo.Insert(Key, Value);
	EndIf;
EndProcedure

Function GetFromAddInfo(AddInfo, Key) Export
	If TypeOf(AddInfo) <> Type("Structure") Then
		Return Undefined;
	EndIf;
	If AddInfo.Property(Key) Then
		Return AddInfo[Key];
	Else
		Return Undefined;
	EndIf;
EndFunction

Procedure DeleteFromAddInfo(AddInfo, Key) Export
	If TypeOf(AddInfo) = Type("Structure") And AddInfo.Property(Key) Then
		AddInfo.Delete(Key);
	EndIf;
EndProcedure

Function GetStructureOfProperty(Object, AddInfo = Undefined) Export

	ServerData = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "ServerData");
	If ServerData = Undefined Then
		MetaDataStructure = ServiceSystemServer.GetMetaDataStructure(Object.Ref);
	Else
		MetaDataStructure = ServerData.MetaDataStructure;
	EndIf;

	CacheObject = New Structure();
	CacheObject.Insert("Attributes", MetaDataStructure.Attributes);

	FillPropertyValues(CacheObject.Attributes, Object);

	CacheObject.Insert("TabularSections", New Array());

	For Each TabularSectionMap In MetaDataStructure.TabularSections Do
		TabularSection = TabularSectionMap.Value;
		CacheRows = New Map();
		For Each Row In Object[TabularSection.Name] Do
			NewRow = New Structure();
			For Each Attribute In TabularSection.Attributes Do
				NewRow.Insert(Attribute.Key);
			EndDo;
			CacheRows.Insert(Row.LineNumber, NewRow);
			FillPropertyValues(CacheRows[Row.LineNumber], Row);
		EndDo;
		CacheObject.Insert(TabularSection.Name, CacheRows);
		CacheObject.TabularSections.Add(TabularSection.Name);
	EndDo;

	Return CacheObject;
EndFunction

Procedure FillStructureInObject(Structure, Object) Export

	FillPropertyValues(Object, Structure.Attributes);

	For Each TabularSection In Structure.TabularSections Do
		CacheRows = Structure[TabularSection];
		For Each Row In Object[TabularSection] Do
			If CacheRows[Row.LineNumber] = Undefined Then
				Continue;
			EndIf;
			FillPropertyValues(Row, CacheRows[Row.LineNumber]);
		EndDo;
	EndDo;
EndProcedure

Procedure CalculateVolume(Object) Export
	Object.Volume = Object.Length * Object.Width * Object.Height;
EndProcedure

#Region FormItemsModifiedByUser

Procedure SetFormItemModifiedByUser(Form, ItemName) Export
	FoundedItem = Form.FormItemsModifiedByUser.FindByValue(ItemName);
	If FoundedItem = Undefined Then
		Form.FormItemsModifiedByUser.Add(ItemName);
	EndIf;
EndProcedure

Function IsFormItemModifiedByUser(Form, ItemName) Export
	ReturnValue = False;
	FoundedItem = Form.FormItemsModifiedByUser.FindByValue(ItemName);
	If FoundedItem <> Undefined Then
		ReturnValue = True;
	EndIf;
	Return ReturnValue;
EndFunction

Procedure ClearFormItemModifiedByUser(Form, ItemName) Export
	FoundedItem = Form.FormItemsModifiedByUser.FindByValue(ItemName);
	If FoundedItem <> Undefined Then
		Form.FormItemsModifiedByUser.Delete(FoundedItem);
	EndIf;
EndProcedure

#EndRegion

#Region FormObjectAttributesPreviousValues

Function GetObjectPreviousValue(Object, Form, AttributeName) Export
	ReturnValue = Undefined;
	FoundedRows = Form.PreviousValues.FindRows(New Structure("AttributeName", "Object." + AttributeName));
	If FoundedRows.Count() Then
		ReturnValue = FoundedRows[0].AttributeValue;
	EndIf;
	Return ReturnValue;
EndFunction

Procedure SetObjectPreviousValue(Object, Form, AttributeName) Export
	FoundedRows = Form.PreviousValues.FindRows(New Structure("AttributeName", "Object." + AttributeName));
	If FoundedRows.Count() Then
		FoundedRows[0].AttributeValue = Object[AttributeName];
	Else
		NewStr = Form.PreviousValues.Add();
		NewStr.AttributeName = "Object." + AttributeName;
		NewStr.AttributeValue = Object[AttributeName];
	EndIf;
EndProcedure

Function GetFormPreviousValue(Object, Form, AttributeName) Export
	ReturnValue = Undefined;
	FoundedRows = Form.PreviousValues.FindRows(New Structure("AttributeName", AttributeName));
	If FoundedRows.Count() Then
		ReturnValue = FoundedRows[0].AttributeValue;
	EndIf;
	Return ReturnValue;
EndFunction

Procedure SetFormPreviousValue(Object, Form, AttributeName) Export
	FoundedRows = Form.PreviousValues.FindRows(New Structure("AttributeName", AttributeName));
	If FoundedRows.Count() Then
		FoundedRows[0].AttributeValue = Form[AttributeName];
	Else
		NewStr = Form.PreviousValues.Add();
		NewStr.AttributeName = AttributeName;
		NewStr.AttributeValue = Form[AttributeName];
	EndIf;
EndProcedure

#EndRegion