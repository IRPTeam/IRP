Procedure ShowUsersMessage(Text, Field = Undefined, Data = Undefined, AddInfo = Undefined) Export
	
	If IsBlankString(Text) Then
		Return;
	EndIf;
	
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

Function GetSearchStringNumber(SearchString) Export
	AccessSymbols = ".,- ¶" + Chars.LF + Chars.NBSp + Chars.CR;
	Return GetNumberPartFromString(SearchString, AccessSymbols);
EndFunction

Function GetNumberPartFromString(String, ReturnIfOnlyThisSymbolsPresent = "", GetOnlyNumbers = False, GetAsNumber = True) Export

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
	
	If GetAsNumber Then
		Return Number(StrConcat(NumberPart));
	Else
		Return StrConcat(NumberPart);
	EndIf;

EndFunction

Function GetSliceLastDateByRefAndDate(Ref, Date) Export
	If Not ValueIsFilled(Ref) Then
		If Not ValueIsFilled(Date) Then
			Return CommonFunctionsServer.GetCurrentSessionDate();
		EndIf;
		If BegOfDay(Date) = BegOfDay(CommonFunctionsServer.GetCurrentSessionDate()) Then
			Return EndOfDay(Date);
		Else
			Return Date;
		EndIf;
	Else
		Return Date;
	EndIf;
EndFunction

// Get size presentation.
// 
// Parameters:
//  Size - Number - Size in byte
// 
// Returns:
//  String - Size presentation
Function GetSizePresentation(Size) Export
	
	Kilobyte = Pow(2, 10);
	Megabyte = Pow(2, 20); 
	Gigabyte = Pow(2, 30);
	Terabyte = Pow(2, 40);
	
	FormatByte = "NZ=; NG=;";
	FormatMore = "NFD=1; NZ=; NG=;";
	
	If Size < Kilobyte Then
		Return Format(Size, FormatByte) + " B";
	ElsIf Size < Megabyte Then 
		Return Format(Size / Kilobyte, FormatMore) + " kB";
	ElsIf Size < Gigabyte Then 
		Return Format(Size / Megabyte, FormatMore) + " MB";
	ElsIf Size < Terabyte Then 
		Return Format(Size / Gigabyte, FormatMore) + " GB";
	Else 
		Return Format(Size / Terabyte, FormatMore) + " TB";
	EndIf;
	
EndFunction

Procedure DeleteValueFromArray(Array, Value) Export
	Index = Array.Find(Value);
	If Index <> Undefined Then
		Array.Delete(Index);
	EndIf;
EndProcedure

Procedure AddValueToArray(Array, Value) Export
	Index = Array.Find(Value);
	If Index = Undefined Then
		Array.Add(Value);
	EndIf;
EndProcedure

// Is base64 value.
// 
// Parameters:
//  Value - String - Value
// 
// Returns:
//  Boolean - Is base64 value
Function isBase64Value(Value) Export
	
	// ^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)?$
	
	StrLen = StrLen(Value);
	If Not StrLen / 4 = Int(StrLen / 4)  OR StrLen < 4 Then
		Return False;
	EndIf;
	
	For Index = 1 To StrLen Do
		Code = CharCode(Mid(Value, Index, 1));
		If Code >= 48 And Code <= 57 Then // Numbers
		
		ElsIf Code >= 65 And Code <= 90 Then // A-Z
		
		ElsIf Code >= 97 And Code <= 122 Then // a-z
		
		ElsIf Code = 61 And StrLen - Index <= 2 Then // =
		
		ElsIf Code = 47 OR Code = 43 Then // /
		
		Else
			Return False;		
		EndIf;
	EndDo;
	
	Return True;
EndFunction

Function CalculateDistance(Lat1, Lon1, Lat2, Lon2) Export
    // Radius of the Earth in kilometers
    RadiusOfEarth = 6371;
    pi = 3.14159265358979;
    
    // Convert degrees to radians
    Phi1 = Lat1 * pi / 180;
    Phi2 = Lat2 * pi / 180;
    DeltaPhi = (Lat2 - Lat1) * pi / 180;
    DeltaLambda = (Lon2 - Lon1) * pi / 180;
    
    // Haversine formula
    A = Pow(Sin(DeltaPhi / 2), 2) + Cos(Phi1) * Cos(Phi2) * Pow(Sin(DeltaLambda / 2), 2);
    C = 2 * ASin(Sqrt(A));
    // Distance in kilometers
    Distance = RadiusOfEarth * C;
    
    Return Distance;
EndFunction

Procedure LoadFormItemChoiceList(Form, ItemName, ChoiceList) Export
	If ObjectHasProperty(Form.Items, ItemName) Then
		Form.Items[ItemName].ChoiceList.Clear();
		Form.Items[ItemName].ChoiceList.LoadValues(ChoiceList);
	EndIf;
EndProcedure
