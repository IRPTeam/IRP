
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Template = ChartsOfAccounts.Basic.GetTemplate("LoadTemplate");
	ThisObject.SpreadsheetDocument.Put(Template);
	ThisObject.SpreadsheetDocument.FixedTop = 1;
	
	ThisObject.Languages.Add("EN");
	ThisObject.Languages.Add("RU");
	ThisObject.Languages.Add("TR");
EndProcedure

&AtClient
Procedure Load(Command)
	If LoadAtServer() Then
		ShowMessageBox(, R().AccountingInfo_01);
	EndIf;
EndProcedure

&AtServer
Function LoadAtServer()
	ArrayOfColumns = New Array();
	For Each Column In StrSplit(ThisObject.Columns, ",") Do
		ArrayOfColumns.Add(TrimAll(StrReplace(Column, Chars.LF, "")));
	EndDo;
	
	ValueTable = New ValueTable();
	ValueTable.Columns.Add("RowNumber", New TypeDescription("Number"));
		
	For Each Column In ArrayOfColumns Do
		ValueTable.Columns.Add(Column);
	EndDo;
	
	BooleanColumns = New Array();
	BooleanColumns.Add("ForbidRecord");
	BooleanColumns.Add("Currency");
	BooleanColumns.Add("Quantity");
	BooleanColumns.Add("OffBalance");
	BooleanColumns.Add("Sub1Turnover");
	BooleanColumns.Add("Sub1Quantity");
	BooleanColumns.Add("Sub1Currency");
	BooleanColumns.Add("Sub1Amount");
	BooleanColumns.Add("Sub2Turnover");
	BooleanColumns.Add("Sub2Quantity");
	BooleanColumns.Add("Sub2Currency");
	BooleanColumns.Add("Sub2Amount");
	BooleanColumns.Add("Sub3Turnover");	
	BooleanColumns.Add("Sub3Quantity");
	BooleanColumns.Add("Sub3Currency");
	BooleanColumns.Add("Sub3Amount");
	
	For RowNumber = 2 To ThisObject.SpreadsheetDocument.TableHeight Do
		NewRow = ValueTable.Add();
		ColumnNumber = 1;
		For Each Column In ArrayOfColumns Do
			NewRow.RowNumber = RowNumber;
			Area = ThisObject.SpreadsheetDocument.Area(RowNumber, ColumnNumber, RowNumber, ColumnNumber);
			Value = TrimAll(Area.Text);
			
			If BooleanColumns.Find(Column) <> Undefined Then
				If ValueIsFilled(Value) Then
					Value = Boolean(Value);
				Else
					 Value = False;
				EndIf;
			EndIf;
			
			NewRow[TrimAll(Column)] = Value;
			ColumnNumber = ColumnNumber + 1;
			
			Area.Comment.Text = "";
			Area.BackColor = WebColors.White;
		EndDo;
	EndDo;
	
	QueryTableRefs = GetRefs(ValueTable);
	
	Cancel = False;
		
	CheckRef("LedgerType" , QueryTableRefs, ArrayOfColumns, Cancel);
	CheckRef("Sub1Type"   , QueryTableRefs, ArrayOfColumns, Cancel);
	CheckRef("Sub2Type"   , QueryTableRefs, ArrayOfColumns, Cancel);
	CheckRef("Sub3Type"   , QueryTableRefs, ArrayOfColumns, Cancel);
	
	CheckIsFilled("AccountNo"   , QueryTableRefs, ArrayOfColumns, Cancel);
	CheckIsFilled("Description" , QueryTableRefs, ArrayOfColumns, Cancel);
		
	If Cancel Then
		Return False;
	EndIf;
	
	BeginTransaction();
	Try
		CreateUpdateAccounts(QueryTableRefs, ValueTable);
	
		QueryTableOwners = GetOwners(ValueTable);
		
		SetOwners(QueryTableOwners, ValueTable);
		CommitTransaction();
	Except
		RollbackTransaction();
		Raise ErrorDescription();
	EndTry;
	
	Return True;
EndFunction

&AtClient
Procedure LanguagesBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure LanguagesBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtServer
Function GetRefs(ValueTable)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ValueTable.RowNumber,
	|	ValueTable.Description,
	|	ValueTable.AccountNo,
	|	ValueTable.LedgerType,
	|	ValueTable.Sub1Type,
	|	ValueTable.Sub2Type,
	|	ValueTable.Sub3Type
	|INTO tmp_Ledgertype
	|FROM
	|	&ValueTable AS ValueTable
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.RowNumber AS RowNumber,
	|	tmp.Description AS Description,
	|	tmp.LedgerType AS LedgerType,
	|	LedgerTypeVariants.Ref AS LedgerTypeRef,
	|	CASE
	|		WHEN LedgerTypeVariants.Ref IS NULL
	|			THEN FALSE
	|		ELSE TRUE
	|	END AS IsFound_LedgerType,
	|	tmp.Sub1Type AS Sub1Type,
	|	TableSub1Type.Ref AS Sub1TypeRef,
	|	CASE
	|		WHEN tmp.Sub1Type <> """"
	|		AND TableSub1Type.Ref IS NULL
	|			THEN FALSE
	|		ELSE TRUE
	|	END AS IsFound_Sub1Type,
	|	tmp.Sub2Type AS Sub2Type,
	|	TableSub2Type.Ref AS Sub2TypeRef,
	|	CASE
	|		WHEN tmp.Sub2Type <> """"
	|		AND TableSub2Type.Ref IS NULL
	|			THEN FALSE
	|		ELSE TRUE
	|	END AS IsFound_Sub2Type,
	|	tmp.Sub3Type AS Sub3Type,
	|	TableSub3Type.Ref AS Sub3TypeRef,
	|	CASE
	|		WHEN tmp.Sub3Type <> """"
	|		AND TableSub3Type.Ref IS NULL
	|			THEN FALSE
	|		ELSE TRUE
	|	END AS IsFound_Sub3Type,
	|	tmp.AccountNo AS AccountNo,
	|	Basic.Ref AS AccountNoRef
	|FROM
	|	tmp_Ledgertype AS tmp
	|		LEFT JOIN Catalog.LedgerTypeVariants AS LedgerTypeVariants
	|		ON tmp.LedgerType = LedgerTypeVariants.UniqueID
	|		LEFT JOIN ChartOfCharacteristicTypes.AccountingExtraDimensionTypes AS TableSub1Type
	|		ON CASE
	|			WHEN tmp.Sub1Type = """"
	|				THEN FALSE
	|			ELSE tmp.Sub1Type = TableSub1Type.UniqueID
	|		END
	|		LEFT JOIN ChartOfCharacteristicTypes.AccountingExtraDimensionTypes AS TableSub2Type
	|		ON CASE
	|			WHEN tmp.Sub2Type = """"
	|				THEN FALSE
	|			ELSE tmp.Sub2Type = TableSub2Type.UniqueID
	|		END
	|		LEFT JOIN ChartOfCharacteristicTypes.AccountingExtraDimensionTypes AS TableSub3Type
	|		ON CASE
	|			WHEN tmp.Sub3Type = """"
	|				THEN FALSE
	|			ELSE tmp.Sub3Type = TableSub1Type.UniqueID
	|		END
	|		LEFT JOIN ChartOfAccounts.Basic AS Basic
	|		ON Basic.Code = tmp.AccountNo";
	
	StringType = New TypeDescription("String", New StringQualifiers(100));
	
	ValueTableRefs = New ValueTable();
	ValueTableRefs.Columns.Add("RowNumber"  , New TypeDescription("Number"));
	ValueTableRefs.Columns.Add("AccountNo" , StringType);
	ValueTableRefs.Columns.Add("Description" , StringType);
	ValueTableRefs.Columns.Add("LedgerType" , StringType);
	ValueTableRefs.Columns.Add("Sub1Type"   , StringType);
	ValueTableRefs.Columns.Add("Sub2Type"   , StringType);
	ValueTableRefs.Columns.Add("Sub3Type"   , StringType);
	
	For Each Row In ValueTable Do
		FillPropertyValues(ValueTableRefs.Add(), Row);
	EndDo;
		
	Query.SetParameter("ValueTable", ValueTableRefs);
	QueryResult = Query.Execute();
	
	QueryTable = QueryResult.Unload();
	
	Return QueryTable;
EndFunction

&AtServer
Function GetOwners(ValueTable)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ValueTable.OwnerNo,
	|	ValueTable.AccountNo
	|INTO tmp_Ledgertype
	|FROM
	|	&ValueTable AS ValueTable
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.OwnerNo AS OwnerNo,
	|	BasicOwner.Ref AS OwnerNoRef,
	|	tmp.AccountNo AS AccountNo,
	|	BasicAccount.Ref AS AccountNoRef
	|FROM
	|	tmp_Ledgertype AS tmp
	|		LEFT JOIN ChartOfAccounts.Basic AS BasicOwner
	|		ON BasicOwner.Code = tmp.OwnerNo
	|		LEFT JOIN ChartOfAccounts.Basic AS BasicAccount
	|		ON BasicAccount.Code = tmp.AccountNo";
	
	StringType = New TypeDescription("String", New StringQualifiers(100));
	
	ValueTableRefs = New ValueTable();
	ValueTableRefs.Columns.Add("AccountNo" , StringType);
	ValueTableRefs.Columns.Add("OwnerNo"   , StringType);
	
	For Each Row In ValueTable Do
		FillPropertyValues(ValueTableRefs.Add(), Row);
	EndDo;
		
	Query.SetParameter("ValueTable", ValueTableRefs);
	QueryResult = Query.Execute();
	
	QueryTable = QueryResult.Unload();
	
	Return QueryTable;
EndFunction

&AtServer
Procedure CheckRef(ColumnName, QueryTable, ArrayOfColumns, Cancel)
	For Each ErrorRow In QueryTable.FindRows(New Structure("IsFound_" + ColumnName, False)) Do
		ColumnNumber = ArrayOfColumns.Find(ColumnName) + 1;
		Area = ThisObject.SpreadsheetDocument.Area(ErrorRow.RowNumber, ColumnNumber, ErrorRow.RowNumber, ColumnNumber);
		Area.BackColor = WebColors.Pink;
		Area.Comment.Text = StrTemplate("%1 [%2] not found", ColumnName, ErrorRow[ColumnName]);
		Cancel = True;
	EndDo;
EndProcedure

&AtServer
Procedure CheckIsFilled(ColumnName, QueryTable, ArrayOfColumns, Cancel)
	For Each ErrorRow In QueryTable Do
		If ValueIsFilled(ErrorRow[ColumnName]) Then
			Continue;
		EndIf;
		ColumnNumber = ArrayOfColumns.Find(ColumnName) + 1;
		Area = ThisObject.SpreadsheetDocument.Area(ErrorRow.RowNumber, ColumnNumber, ErrorRow.RowNumber, ColumnNumber);
		Area.BackColor = WebColors.Pink;
		Area.Comment.Text = StrTemplate("%1 [%2] is required field", ColumnName, ErrorRow[ColumnName]);
		Cancel = True;
	EndDo;
EndProcedure
	
&AtServer
Procedure CreateUpdateAccounts(QueryTable, ValueTable)
	AccountNoMap = New Map();
	LedgerTypeMap = New Map();
	Sub1TypeMap = New Map();
	Sub2TypeMap = New Map();
	Sub3TypeMap = New Map();
	
	For Each Row In QueryTable Do
		AccountNoMap.Insert(Row.AccountNo, Row.AccountNoRef);
		LedgerTypeMap.Insert(Row.LedgerType, Row.LedgerTypeRef);
		Sub1TypeMap.Insert(Row.Sub1Type, Row.Sub1TypeRef);
		Sub2TypeMap.Insert(Row.Sub2Type, Row.Sub2TypeRef);
		Sub3TypeMap.Insert(Row.Sub3Type, Row.Sub3TypeRef);
	EndDo;
	
	Descriptions = New Array();
	For Each Item In ThisObject.Languages Do
		If Item.Check Then
			Descriptions.Add("Description_" + Item.Value);
		EndIf;
	EndDo;
		
	For Each Row In ValueTable Do
		AccountNoRef = AccountNoMap[Row.AccountNo];
		If ValueIsFilled(AccountNoRef) Then
			NewChart = AccountNoRef.GetObject();
		Else
			NewChart = ChartsOfAccounts.Basic.CreateAccount();
		EndIf;
		
		For Each Desc In Descriptions Do
			NewChart[Desc] = Row.Description;
		EndDo;
		
		NewChart.LedgerTypeVariant = LedgerTypeMap[Row.LedgerType];
		NewChart.NotUsedForRecords = Row.ForbidRecord;
		NewChart.Code = Row.AccountNo;
	
		NewChart.Currency = Row.Currency;
		NewChart.Quantity = Row.Quantity;
		NewChart.OffBalance = Row.OffBalance;
	
		If Upper(Row.A_P) = "P" Then
			NewChart.Type = AccountType.Passive;
		ElsIf Upper(Row.A_P) = "AP" Then
			NewChart.Type = AccountType.ActivePassive;
		Else
			NewChart.Type = AccountType.Active;
		EndIf;
	
		NewChart.ExtDimensionTypes.Clear();
		
		Sub1TypeRef = Sub1TypeMap[Row.Sub1Type];
		If ValueIsFilled(Sub1TypeRef) Then
			Sub1Type = NewChart.ExtDimensionTypes.Add();
			Sub1Type.ExtDimensionType = Sub1TypeMap[Row.Sub1Type];
			Sub1Type.TurnoversOnly    = Row.Sub1Turnover;
			Sub1Type.Quantity         = Row.Sub1Quantity;
			Sub1Type.Currency         = Row.Sub1Currency;
			Sub1Type.Amount 		  = Row.Sub1Amount;
		EndIf;
	
		Sub2TypeRef = Sub2TypeMap[Row.Sub2Type];
		If ValueIsFilled(Sub2TypeRef) Then
			Sub2Type = NewChart.ExtDimensionTypes.Add();
			Sub2Type.ExtDimensionType = Sub2TypeMap[Row.Sub2Type];
			Sub2Type.TurnoversOnly    = Row.Sub2Turnover;
			Sub2Type.Quantity         = Row.Sub2Quantity;
			Sub2Type.Currency         = Row.Sub2Currency;
			Sub2Type.Amount = Row.Sub2Amount;
		EndIf;
		
		Sub3TypeRef = Sub3TypeMap[Row.Sub3Type];
		If ValueIsFilled(Sub3TypeRef) Then
			Sub3Type = NewChart.ExtDimensionTypes.Add();
			Sub3Type.ExtDimensionType = Sub3TypeMap[Row.Sub3Type];
			Sub3Type.TurnoversOnly    = Row.Sub3Turnover;
			Sub3Type.Quantity         = Row.Sub3Quantity;
			Sub3Type.Currency         = Row.Sub3Currency;
			Sub3Type.Amount = Row.Sub3Amount;
		EndIf;
		NewChart.Write();
	EndDo;
EndProcedure

&AtServer
Procedure SetOwners(QueryTable, ValueTable)
	AccountNoMap = New Map();
	OwnerNoMap = New Map();
	
	For Each Row In QueryTable Do
		AccountNoMap.Insert(Row.AccountNo, Row.AccountNoRef);
		OwnerNoMap.Insert(Row.OwnerNo, Row.OwnerNoRef);
	EndDo;
		
	For Each Row In ValueTable Do
		OwnerNoRef = OwnerNoMap[Row.OwnerNo];
		If Not ValueIsFilled(OwnerNoRef) Then
			Continue;
		EndIf;
		
		AccountNoRef = AccountNoMap[Row.AccountNo];
		NewChart = AccountNoRef.GetObject();
		
		NewChart.Parent = OwnerNoRef;
		NewChart.Write();
	EndDo;
EndProcedure
	
ThisObject.Columns = 
		"LedgerType,
		|ForbidRecord,
		|OwnerNo,
		|AccountNo,
		|Description,
		|Currency,
		|A_P,
		|Quantity,
		|OffBalance,
		|Sub1Type,
		|Sub1Turnover,
		|Sub1Quantity,
		|Sub1Currency,
		|Sub1Amount,
		|Sub2Type,
		|Sub2Turnover,
		|Sub2Quantity,
		|Sub2Currency,
		|Sub2Amount,
		|Sub3Type,
		|Sub3Turnover,
		|Sub3Quantity,
		|Sub3Currency,
		|Sub3Amount";
	