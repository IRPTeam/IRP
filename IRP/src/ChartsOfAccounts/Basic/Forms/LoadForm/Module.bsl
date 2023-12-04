
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Template = ChartsOfAccounts.Basic.GetTemplate("LoadTemplate");
	ThisObject.SpreadsheetDocument.Put(Template);
	ThisObject.SpreadsheetDocument.FixedTop = 1;
EndProcedure

&AtClient
Procedure Load(Command)
	LoadAtServer();
EndProcedure

&AtServer
Procedure LoadAtServer()
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
	
	QueryTable = GetRefs(ValueTable);
	
	Cancel = False;
		
	CheckRef("LedgerType" , QueryTable, ArrayOfColumns, Cancel);
	CheckRef("Sub1Type"   , QueryTable, ArrayOfColumns, Cancel);
	CheckRef("Sub2Type"   , QueryTable, ArrayOfColumns, Cancel);
	CheckRef("Sub3Type"   , QueryTable, ArrayOfColumns, Cancel);
	
	CheckIsFilled("AccountNo"   , QueryTable, ArrayOfColumns, Cancel);
	CheckIsFilled("Description" , QueryTable, ArrayOfColumns, Cancel);
		
	If Cancel Then
		Return;
	EndIf;
	
	NewChart = ChartsOfAccounts.Basic.CreateAccount();
	NewChart.LedgerTypeVariant = Undefined; // LedgerType
	NewChart.NotUsedForRecords = False; // ForbidRecord
	NewChart.Code = ""; // AccountNo
	
	NewChart.Currency = False;
	NewChart.Quantity = False;
	NewChart.OffBalance = False;
	
	NewChart.Type = AccountType.Active;
	
	Sub1Type = NewChart.ExtDimensionTypes.Add();
	Sub1Type.ExtDimensionType = Undefined;
	Sub1Type.TurnoversOnly = False;
	Sub1Type.Quantity = False;
	Sub1Type.Currency = False;
	Sub1Type.ExtraDimensionsAccountingFlagName = False;
EndProcedure

&AtServer
Function GetRefs(ValueTable)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ValueTable.RowNumber,
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
	|	tmp_Ledgertype.RowNumber AS RowNumber,
	|	tmp_Ledgertype.LedgerType AS LedgerType,
	|	LedgerTypeVariants.Ref AS LedgerTypeRef,
	|	CASE
	|		WHEN LedgerTypeVariants.Ref IS NULL
	|			THEN FALSE
	|		ELSE TRUE
	|	END AS IsFound_LedgerType,
	|	tmp_Ledgertype.Sub1Type AS Sub1Type,
	|	TableSub1Type.Ref AS Sub1TypeRef,
	|	CASE
	|		WHEN tmp_Ledgertype.Sub1Type <> """"
	|		AND TableSub1Type.Ref IS NULL
	|			THEN FALSE
	|		ELSE TRUE
	|	END AS IsFound_Sub1Type,
	|	tmp_Ledgertype.Sub2Type AS Sub2Type,
	|	TableSub2Type.Ref AS Sub2TypeRef,
	|	CASE
	|		WHEN tmp_Ledgertype.Sub2Type <> """"
	|		AND TableSub2Type.Ref IS NULL
	|			THEN FALSE
	|		ELSE TRUE
	|	END AS IsFound_Sub2Type,
	|	tmp_Ledgertype.Sub3Type AS Sub3Type,
	|	TableSub3Type.Ref AS Sub3TypeRef,
	|	CASE
	|		WHEN tmp_Ledgertype.Sub3Type <> """"
	|		AND TableSub3Type.Ref IS NULL
	|			THEN FALSE
	|		ELSE TRUE
	|	END AS IsFound_Sub3Type
	|FROM
	|	tmp_Ledgertype AS tmp_Ledgertype
	|		LEFT JOIN Catalog.LedgerTypeVariants AS LedgerTypeVariants
	|		ON tmp_Ledgertype.LedgerType = LedgerTypeVariants.UniqueID
	|		LEFT JOIN ChartOfCharacteristicTypes.AccountingExtraDimensionTypes AS TableSub1Type
	|		ON CASE
	|			WHEN tmp_Ledgertype.Sub1Type = """"
	|				THEN FALSE
	|			ELSE tmp_Ledgertype.Sub1Type = TableSub1Type.UniqueID
	|		END
	|		LEFT JOIN ChartOfCharacteristicTypes.AccountingExtraDimensionTypes AS TableSub2Type
	|		ON CASE
	|			WHEN tmp_Ledgertype.Sub2Type = """"
	|				THEN FALSE
	|			ELSE tmp_Ledgertype.Sub2Type = TableSub2Type.UniqueID
	|		END
	|		LEFT JOIN ChartOfCharacteristicTypes.AccountingExtraDimensionTypes AS TableSub3Type
	|		ON CASE
	|			WHEN tmp_Ledgertype.Sub3Type = """"
	|				THEN FALSE
	|			ELSE tmp_Ledgertype.Sub3Type = TableSub1Type.UniqueID
	|		END";
	
	StringType = New TypeDescription("String", New StringQualifiers(100));
	
	ValueTableRefs = New ValueTable();
	ValueTableRefs.Columns.Add("RowNumber"  , New TypeDescription("Number"));
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
	