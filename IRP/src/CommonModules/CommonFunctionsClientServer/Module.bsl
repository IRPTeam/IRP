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

Function GetFromAddInfo(AddInfo, Key, DefaultValue = Undefined) Export
	If TypeOf(AddInfo) <> Type("Structure") Then
		Return DefaultValue;
	EndIf;
	If AddInfo.Property(Key) Then
		Return AddInfo[Key];
	Else
		Return DefaultValue;
	EndIf;
EndFunction

Procedure DeleteFromAddInfo(AddInfo, Key) Export
	If TypeOf(AddInfo) = Type("Structure") And AddInfo.Property(Key) Then
		AddInfo.Delete(Key);
	EndIf;
EndProcedure

Procedure CalculateVolume(Object) Export
	Object.Volume = Object.Length * Object.Width * Object.Height;
EndProcedure

Function GetNumberPartFromString(String, ReturnIfOnlyThisSymbolsPresent = "", GetOnlyNumbers = False) Export

	RejectSymbols = New Array;
	For Index = 1 To StrLen(ReturnIfOnlyThisSymbolsPresent) Do
		RejectSymbols.Add(Mid(ReturnIfOnlyThisSymbolsPresent, Index, 1));
	EndDo;
	
	NumberPart = New Array;
	For Index = 1 To StrLen(String) Do
		Symbol = Mid(String, Index, 1);
		
		CharCode = CharCode(String, Index);
		If CharCode >= 48 And CharCode <= 57 Then
			NumberPart.Add(Symbol);
		ElsIf RejectSymbols.Find(Symbol) = Undefined And Not GetOnlyNumbers Then
			NumberPart.Clear();
			Break;
		EndIf;
	EndDo;

	If Not NumberPart.Count() Then
		Return Undefined;
	EndIf;

	Return Number(StrConcat(NumberPart));

EndFunction

Function GetSliceLastDateByRefAndDate(Ref, Date) Export
	If Not ValueIsFilled(Ref) Then
		If Not ValueIsFilled(Date) Then
			Return CurrentDate();
		EndIf;
		If BegOfDay(Date) = BegOfDay(CurrentDate()) Then
			Return EndOfDay(Date);
		Else
			Return Date;
		EndIf;
	Else
		Return Date;
	EndIf;
EndFunction

