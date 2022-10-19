
// @strict-types

&AtClient
Var HTMLRegExpTestRowsAnalyzeDocument Export; // Structure - HTML document

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	HTMLRegExpTestRowsAnalyze = Catalogs.ExternalFunctions.GetTemplate("RegExpAnalyse").GetText();
	RegExp = Parameters.RegExp;
EndProcedure

&AtClient
Procedure Done(Command)
	Close(RegExp);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	
	ArrayOfTestStrings = Parameters.ArrayOfTestStrings; // Array of String
	If TypeOf(ArrayOfTestStrings) = Type("Array") Then
		For Each Row In ArrayOfTestStrings Do
			NewRow = TestRexExpStrings.Add();
			NewRow.Row = Row;
		EndDo;
		
		If TestRexExpStrings.Count() Then
			FillRowParts(TestRexExpStrings[0].Row);
			CreateLabels();
			UpdateRegExpStringAtForm();
		EndIf;
	EndIf;
	
EndProcedure

&AtClient
Async Procedure FillTestRows(Command)
	TmpString = "";
	TmpString = Await InputStringAsync(TmpString, , , True);
	If TmpString = Undefined Then
		Return;
	EndIf;
	PartsString = StrSplit(TmpString, Chars.LF); 
	
	For Each Row In PartsString Do
		NewRow = TestRexExpStrings.Add();
		NewRow.Row = Row;
	EndDo;
	FillRegExpTestData();
	CheckRegExp();
EndProcedure

// Test rows selection.
// 
// Parameters:
//  Item - FormTable - Item
//  RowSelected - Number - Row selected
//  Field - FormField - Field
//  StandardProcessing - Boolean - Standard processing
&AtClient
Procedure TestRowsSelection(Item, RowSelected, Field, StandardProcessing)
	StandardProcessing = False;
	TableRow = TestRexExpStrings.FindByID(RowSelected);
	FillRowParts(TableRow.Row);
	CreateLabels();
	UpdateRegExpStringAtForm();
EndProcedure

&AtClient
Procedure FillRowParts(Val Row)
	Row = StrReplace(Row, " ", "••");
	SelectedRowParts = StrSplit(Row, "•", True);
	Object.RowParts.Clear();
	LastWasEmpty = False;
	For Each Row In SelectedRowParts Do
		
		If LastWasEmpty And Row = "" Then
			LastWasEmpty = False;
			Continue;
		ElsIf Row = "" Then
			LastWasEmpty = True;
		Else
			LastWasEmpty = False;
		EndIf;
		
		NewRow = Object.RowParts.Add();
		NewRow.RowPart = Row;
		NewRow.ExpressionType = "TypeConstant";
		If NewRow.RowPart = "" Then
			NewRow.RowPart = " ";
			NewRow.RegExp = " ";
			NewRow.isWhitespace = True;
		Else
			SetRegExpValue(NewRow.ExpressionType, NewRow);
		EndIf;
		NewRow.ID = "ID_" + StrReplace(String(New UUID), "-", "");
	EndDo;
EndProcedure

&AtServer
Procedure CreateLabels()
	ChildItemsList = New Array; // Array of FormField
	For Each ChildItem In Items.GroupRowPartsButtonTop.ChildItems Do
		ChildItemsList.Add(ChildItem);
	EndDo;
	For Each ChildItem In Items.GroupRowPartsButtonBottom.ChildItems Do
		ChildItemsList.Add(ChildItem);
	EndDo;
	
	For Each ChildItem In ChildItemsList Do
		Items.Delete(ChildItem);
	EndDo;
	
	LenAddedStrings = 0;
	MaxLenAtTopGroup = 100;
	For Each Part In Object.RowParts Do
		If Part.isWhitespace Then
			Continue;
		EndIf;
		NewItem = Items.Add(Part.ID, Type("FormDecoration"), ?(LenAddedStrings < MaxLenAtTopGroup, Items.GroupRowPartsButtonTop, Items.GroupRowPartsButtonBottom)); // FormDecoration
		NewItem.Type = FormDecorationType.Picture;
		NewItem.NonselectedPictureText = Part.RowPart;
		NewItem.SetAction("DragStart", "RowDragStart");
		NewItem.SetAction("DragCheck", "RowDragCheck");
		NewItem.SetAction("DragEnd", "RowDragEnd");
		NewItem.SetAction("Drag", "RowDrag");
		NewItem.Height = 1;
		NewItem.Width = CalculateItemWidth(Part.RowPart);
		NewItem.AutoMaxWidth = False;
		NewItem.HorizontalStretch = False;
		NewItem.BorderColor = WebColors.Red;
		NewItem.Border = New Border(ControlBorderType.Single, 1);
		NewItem.Font = New Font("Courier New");
		NewItem.EnableDrag = True;
		NewItem.EnableStartDrag = True;
		LenAddedStrings = LenAddedStrings + StrLen(Part.RowPart);
		If Not IsBlankString(Part.ExpressionType) Then
			NewItem.BorderColor = Items[Part.ExpressionType].BorderColor;
			NewItem.Border = New Border(ControlBorderType.Single, 2);
		EndIf;
	EndDo;
	
EndProcedure

&AtServer
Function CalculateItemWidth(Text)
	PreWidth = Round(StrLen(Text) / 3, 0, RoundMode.Round15as20) + 2;
	PreWidth = PreWidth + Round(PreWidth / 7) * 2;
	PreWidth = PreWidth + Round(PreWidth / 10) * 3;
	PreWidth = PreWidth + Round(PreWidth / 20) * 3;
	PreWidth = PreWidth + Round(PreWidth / 40) * 3;
	PreWidth = PreWidth + Round(PreWidth / 60) * 3;
	Return PreWidth;
EndFunction

#Region DragAndDrop

// Drag value.
// 
// Returns:
//  Structure - Drag value:
// * ID - String -
&AtClient
Function DragValue()
	Str = New Structure;
	Str.Insert("ID", "");
	Return Str;
EndFunction

// Change expression type.
// 
// Parameters:
//  Item - FormDecoration, FormDecorationExtensionForAPicture - Item
//  DragParameters - DragParameters - Drag parameters
//  StandardProcessing - Boolean - Standard processing
&AtClient
Procedure ChangeExpressionType(Item, DragParameters, StandardProcessing)
	Value = DragParameters.Value; // See DragValue
	ElementIDStartDrag = Value.ID;
	
	FindElementRows = Object.RowParts.FindRows(New Structure("ID", ElementIDStartDrag));
	If FindElementRows.Count() = 0 Then
		Return;
	EndIf;
	FindElement = FindElementRows[0];
	FindElement.ExpressionType = Item.Name;
	SetRegExpValue(Item.Name, FindElement);
	Decor = Items[ElementIDStartDrag]; // FormDecorationExtensionForAPicture
	Decor.BorderColor = Item.BorderColor;
	Decor.Border = New Border(ControlBorderType.Single, 2);
	
	UpdateRegExpStringAtForm();
EndProcedure

&AtClient
Procedure ChangeExpressionTypeCheck(Item, DragParameters, StandardProcessing)
	Value = DragParameters.Value; // See DragValue
	
	If TypeOf(Value) = Type("Structure") Then
		StandardProcessing = False;
	EndIf;
EndProcedure

// Row drag start.
// 
// Parameters:
//  Item - FormDecoration - Item
//  DragParameters - DragParameters - Drag parameters
//  Perform - Boolean - Perform
&AtClient
Procedure RowDragStart(Item, DragParameters, Perform)
	Value = DragValue();
	Value.ID = Item.Name;
	//@skip-check statement-type-change
	DragParameters.Value = Value;
EndProcedure

// Row drag check.
// 
// Parameters:
//  Item - FormDecoration, FormDecorationExtensionForAPicture - Item
//  DragParameters - DragParameters - Drag parameters
//  StandardProcessing - Boolean - Standard processing
&AtClient
Procedure RowDragCheck(Item, DragParameters, StandardProcessing)
	
	Value = DragParameters.Value; // See DragValue
	
	If Not TypeOf(Value) = Type("Structure") Then
		Return;
	EndIf;
	
	ElementIDStartDrag = Value.ID;

	If Item.Name = ElementIDStartDrag Then
		Return;
	EndIf; 
	
	FindStartElementRows = Object.RowParts.FindRows(New Structure("ID", ElementIDStartDrag));
	If FindStartElementRows.Count() = 0 Then
		Return;
	EndIf;
	
	FindStartElement = FindStartElementRows[0];
	FindEndElement = Object.RowParts.FindRows(New Structure("ID", Item.Name))[0];
	
	If FindStartElement.LineNumber < FindEndElement.LineNumber Then
		Return;
	Else
		For Index = FindEndElement.LineNumber To FindStartElement.LineNumber - 2 Do
			If Not Object.RowParts[Index].isWhitespace Then
				Return;
			EndIf;
		EndDo;
	EndIf;
	
	StandardProcessing = False;
EndProcedure

// Row drag end.
// 
// Parameters:
//  Item - FormDecoration, FormDecorationExtensionForAPicture - Item
//  DragParameters - DragParameters - Drag parameters
//  StandardProcessing - Boolean - Standard processing
&AtClient
Procedure RowDragEnd(Item, DragParameters, StandardProcessing)
	Return;
EndProcedure

// Row drag.
// 
// Parameters:
//  Item - FormDecoration, FormDecorationExtensionForAPicture - Item
//  DragParameters - DragParameters - Drag parameters
//  StandardProcessing - Boolean - Standard processing
&AtClient
Procedure RowDrag(Item, DragParameters, StandardProcessing)
	Value = DragParameters.Value; // See DragValue
	If Not TypeOf(Value) = Type("Structure") Then
		StandardProcessing = False;
		Return;
	EndIf;
	ElementIDStartDrag = Value.ID;
	
	FindStartElementRows = Object.RowParts.FindRows(New Structure("ID", ElementIDStartDrag));
	FindStartElement = FindStartElementRows[0];
	FindEndElement = Object.RowParts.FindRows(New Structure("ID", Item.Name))[0];
	
	ResultRow = "";
	ResultRegExp = "";
	ArrayRowsForDelete = New Array;
	For Index = FindEndElement.LineNumber - 1 To FindStartElement.LineNumber - 1 Do
		ResultRow = ResultRow + Object.RowParts[Index].RowPart;
		ResultRegExp = ResultRegExp + Object.RowParts[Index].RegExp;
		If Not Index = FindEndElement.LineNumber - 1 Then
			ArrayRowsForDelete.Add(Object.RowParts[Index]);
		EndIf;
	EndDo;
	
	For Each Row In ArrayRowsForDelete Do
		//@skip-check invocation-parameter-type-intersect
		Object.RowParts.Delete(Row);
	EndDo;
	
	Item.Width = CalculateItemWidth(ResultRow);

	FindEndElement.RowPart = ResultRow;
	FindEndElement.RegExp = ResultRegExp;
	Item.NonselectedPictureText = ResultRow;
	
	Items[ElementIDStartDrag].Visible = False;
	
	UpdateRegExpStringAtForm();
EndProcedure

#EndRegion

#Region RegExp

&AtClient
Procedure UpdateRegExp(Command)
	UpdateRegExpStringAtForm();
EndProcedure

&AtClient
Procedure UpdateRegExpStringAtForm()
	NewRegExp = New Array;
	For Each Row In Object.RowParts Do
		If NewRegExp.Count() Then
			If NewRegExp[NewRegExp.UBound()] = Row.RegExp = ".*" Then
				Continue;
			EndIf; 
		EndIf;
		
		NewRegExp.Add(Row.RegExp);
	EndDo;
	
	RegExp = "^" + StrConcat(NewRegExp, "") + "$";
	CheckRegExp();
EndProcedure

&AtClient
Procedure SetRegExpValue(Type, FindElement)
	
	If StrStartsWith(FindElement.RegExp, "(") Then
		FindElement.RegExp = Mid(FindElement.RegExp, 2, StrLen(FindElement.RegExp) - 2)
	EndIf;
	
	If Type = "TypeConstant" Then
		FindElement.RegExp = GenerateRegExpForConstant(FindElement.RowPart);
	ElsIf Type = "TypeVariable" Then
		FindElement.RegExp = GenerateRegExpForTemplate(FindElement.RowPart);
	ElsIf Type = "TypeManual" Then
		FindElement.RegExp = "(" + FindElement.RegExp + ")";
		OpenParameter =  New Structure("PartRow", FindElement);
		OpenForm("Catalog.ExternalFunctions.ChoiceForm", , , , , , 
			New NotifyDescription("SetExternalFunction", ThisObject, OpenParameter), 
			FormWindowOpeningMode.LockOwnerWindow);
	Else
		FindElement.RegExp = ".*";
	EndIf;

EndProcedure

// Set external function.
// 
// Parameters:
//  Result - CatalogRef.ExternalFunctions - Result
//  AddInfo - Structure:
//   * PartRow - Structure:
//   ** ExternalFunction - CatalogRef.ExternalFunctions
&AtClient
Procedure SetExternalFunction(Result, AddInfo) Export
	AddInfo.PartRow.ExternalFunction = Result;
EndProcedure

&AtClient
Function GenerateRegExpForConstant(Val Row)
	
	RegExpValue = New Array;
	
	Symbols = New Array; // Array of String
	For Index = 1 To StrLen(Row) Do
		Symbols.Add(Mid(Row, Index, 1));
	EndDo;
	
	SpecChars = RegExpSpecialChars();
	
	For Each Symbol In Symbols Do
		If Not SpecChars.Find(Symbol) = Undefined Then	
			RegExpValue.Add("\" + Symbol);
		Else
			RegExpValue.Add(Symbol);
		EndIf;
	EndDo;
	
	Return StrConcat(RegExpValue);

EndFunction

&AtClient
Function GenerateRegExpForTemplate(Val Row)
	
	RegExpValue = New Array;
	
	Symbols = New Array; // Array of String
	For Index = 1 To StrLen(Row) Do
		Symbols.Add(Mid(Row, Index, 1));
	EndDo;
	
	SpecChars = RegExpSpecialChars();
	
	For Each Symbol In Symbols Do
		
		CodeChar = CharCode(Symbol);
		If Not SpecChars.Find(Symbol) = Undefined Then	
			RegExpValue.Add("\" + Symbol);
		ElsIf CodeChar >= 48 And CodeChar <= 57 Then // Numbers
			RegExpValue.Add("\d");
		ElsIf (CodeChar >= 65 And CodeChar <= 90)
			OR (CodeChar >= 97 And CodeChar <= 122) Then // Text
			RegExpValue.Add("\w");
		Else
			RegExpValue.Add(".");
		EndIf;
	EndDo;
	
	Return StrConcat(RegExpValue);

EndFunction

&AtClient
Function RegExpSpecialChars()
	Return StrSplit(".,+,*,?,^,$,(,),[,],{,},|,\", ",");
EndFunction

#EndRegion

#Region HTMLPreview

&AtClient
Procedure RegExpEditTextChange(Item, Text, StandardProcessing)
	CheckRegExp(Text);
EndProcedure

&AtClient
Procedure HTMLRegExpTestRowsAnalyzeDocumentDocumentComplete(Item)
	HTMLRegExpTestRowsAnalyzeDocument = PictureViewerClient.InfoDocumentComplete(Item); // Structure
	FillRegExpTestData();
	CheckRegExp();
EndProcedure

&AtClient
//@skip-check dynamic-access-method-not-found, property-return-type, variable-value-type
Procedure FillRegExpTestData()
	Text = HTMLRegExpTestRowsAnalyzeDocument.document.getElementById("list"); // Structure
	Text.innerHTML = "";
	For Each Row In TestRexExpStrings Do
		li = HTMLRegExpTestRowsAnalyzeDocument.document.createElement("li");
		li.innerText = Row.Row;
		Text.appendChild(li);
	EndDo;
EndProcedure

&AtClient
Async Procedure CheckRegExp(Text = Undefined)
	
	If HTMLRegExpTestRowsAnalyzeDocument = Undefined Then
		Return;
	EndIf;
	
	Facet = ?(Text = Undefined, RegExp, Text);
	//@skip-check dynamic-access-method-not-found
	HTMLRegExpTestRowsAnalyzeDocument.displayMatches(Facet);
	
EndProcedure

#EndRegion
