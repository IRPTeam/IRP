
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.Company = Parameters.Company;
	ThisObject.LedgerType = Parameters.LedgerType;
	ThisObject.AccountingOperation = Parameters.AccountingOperation;
	UpdateDetailComments();
EndProcedure

&AtServer
Procedure UpdateDetailComments()
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Reg.LocalizationCode,
	|	Reg.DetailComment
	|FROM
	|	InformationRegister.T9070S_ELedgerDetailComments AS Reg
	|WHERE
	|	Reg.Company = &Company
	|	AND Reg.LedgerType = &LedgerType
	|	AND Reg.AccountingOperation = &AccountingOperation";
	Query.SetParameter("Company", ThisObject.Company);
	Query.SetParameter("LedgerType", ThisObject.LedgerType);
	Query.SetParameter("AccountingOperation", ThisObject.AccountingOperation);
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	
	AllDescriptions = LocalizationReuse.AllDescription();
	For Each Desc In AllDescriptions Do
		LocalizationCode = Upper(StrReplace(Desc, "Description_", ""));
		Filter = New Structure("LocalizationCode", LocalizationCode);
		Rows = ThisObject.DetailComments.FindRows(Filter); 
		If  Rows.Count() = 0 Then
			Row = ThisObject.DetailComments.Add();
			Row.LocalizationCode = LocalizationCode;
		Else
			Row = Rows[0];
		EndIf;
		
		RegisterRows = QueryTable.FindRows(Filter);
		If RegisterRows.Count() > 0 Then
			If ValueIsFilled(RegisterRows[0].DetailComment) 
				And Not ValueIsFilled(Row.DetailComment) Then
				Row.DetailComment = RegisterRows[0].DetailComment;
			EndIf;
		EndIf;
	EndDo;
EndProcedure

&AtClient
Procedure AccountingOperationOnChange(Item)
	UpdateDetailComments();
EndProcedure

&AtClient
Procedure LedgerTypeOnChange(Item)
	UpdateDetailComments();
EndProcedure

&AtClient
Procedure CompanyOnChange(Item)
	UpdateDetailComments();
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close();
EndProcedure

&AtClient
Procedure Ok(Command)
	If Not CheckFilling() Then
		Return;
	EndIf;
	OkAtServer();
	Close();
EndProcedure

&AtServer
Procedure OkAtServer()
	For Each Row In ThisObject.DetailComments Do
		RecordSet = InformationRegisters.T9070S_ELedgerDetailComments.CreateRecordSet();
		RecordSet.Filter.Company.Set(ThisObject.Company);
		RecordSet.Filter.LedgerType.Set(ThisObject.LedgerType);
		RecordSet.Filter.AccountingOperation.Set(ThisObject.AccountingOperation);
		RecordSet.Filter.LocalizationCode.Set(Row.LocalizationCode);
		
		RecordSet.Clear();
		
		If ValueIsFilled(Row.DetailComment) Then
			Record = RecordSet.Add();
			Record.Company             = ThisObject.Company;
			Record.LedgerType          = ThisObject.LedgerType;
			Record.AccountingOperation = ThisObject.AccountingOperation;
			Record.LocalizationCode    = Row.LocalizationCode;
			Record.DetailComment       = Row.DetailComment;
		EndIf;
		
		RecordSet.Write(True);
	EndDo;
EndProcedure

&AtClient
Procedure DetailCommentsBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure DetailCommentsBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure
