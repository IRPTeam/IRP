
Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	If ValueIsFilled(ThisObject.Basis) Then
		ThisObject.Date = ThisObject.Basis.Date;
		If CommonFunctionsClientServer.ObjectHasProperty(ThisObject.Basis, "Branch") Then
			ThisObject.Branch = ThisObject.Basis.Branch;
		EndIf;
	EndIf;
	
	If Not ThisObject.DeletionMark And Not ThisObject.UserDefined Then
		ThisObject.RegisterRecords.Basic.Clear();
			
		RecordSet = InformationRegisters.T9050S_AccountingRowAnalytics.CreateRecordSet();
		RecordSet.Filter.Document.Set(ThisObject.Basis);
		RecordSet.Filter.LedgerType.Set(ThisObject.LedgerType);
		RecordSet.Read();
		_AccountingRowAnalytics = RecordSet.Unload();
		
		AccountingServer.SortAccountingAnalyticRows(_AccountingRowAnalytics, ThisObject.Basis);
				
		RecordSet = InformationRegisters.T9051S_AccountingExtDimensions.CreateRecordSet();
		RecordSet.Filter.Document.Set(ThisObject.Basis);
		RecordSet.Filter.LedgerType.Set(ThisObject.LedgerType);
		RecordSet.Read();
		_AccountingExtDimensions = RecordSet.Unload();
			
		Result = AccountingServer.GetNewDataRegisterRecords(ThisObject.Basis, _AccountingRowAnalytics, _AccountingExtDimensions);
		DataTable = Result.DataTable;
			
		ThisObject.Errors.Clear();
		For Each Error In Result.Errors Do
			NewError = ThisObject.Errors.Add();
			NewError.Error = Error;
		EndDo;
					
		AccountingServer.SetDataRegisterRecords(DataTable, ThisObject.LedgerType, ThisObject.RegisterRecords.Basic);
	EndIf;
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	WriteOnForm = CommonFunctionsClientServer.GetFromAddInfo(ThisObject.AdditionalProperties, "WriteOnForm", False);
	
	If Not WriteOnForm Then
		ThisObject.RegisterRecords.Basic.Read();
	EndIf;
			
	For Each Record In ThisObject.RegisterRecords.Basic Do
		Record.Company = ThisObject.Company;
		Record.LedgerType = ThisObject.LedgerType;
	EndDo;
	
	ThisObject.RegisterRecords.Basic.SetActive(Not ThisObject.DeletionMark);
	ThisObject.RegisterRecords.Basic.Write();
	
	If ValueIsFilled(ThisObject.Basis) Then
		Action = ?(ThisObject.DeletionMark Or Not ThisObject.Basis.Posted, "CancelProcessed", "Processed");
		AccountingServer.UpdateAccountingRelevance(ThisObject.Basis, Action, ThisObject.LedgerType, ThisObject.Errors.Count());
	EndIf;
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure Filling(FillingData, FillingText, StandardProcessing)
	If TypeOf(FillingData) = Type("Structure") Then
		If FillingData.Property("Basis") Then
			ThisObject.Basis      = FillingData.Basis;
			If CommonFunctionsClientServer.ObjectHasProperty(FillingData.Basis, "Company") Then
				ThisObject.Company = FillingData.Basis.Company;
			EndIf;
		EndIf;
		
		If FillingData.Property("LedgerType") Then
			ThisObject.LedgerType = FillingData.LedgerType;
		EndIf;
	EndIf;
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	
	SetObjectAndFormAttributeConformity(ThisObject, "Object");
	
	If Not ThisObject.UserDefined Then
		CheckedAttributes.Add("Basis");
	EndIf;
	
	Index = 0;
	For Each Row In ThisObject.RegisterRecords.Basic Do 
		If Not ValueIsFilled(Row.Period) Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(R().AccountingError_04, "RegisterRecords.Basic["+ Index +"].Period", ThisObject);
		EndIf;
		
		If Not ValueIsFilled(Row.AccountDr) Then
			If Not (ValueIsFilled(Row.AccountCr) And Row.AccountCr.OffBalance) Then
				Cancel = True;
				CommonFunctionsClientServer.ShowUsersMessage(
					R().AccountingError_02, "RegisterRecords.Basic["+ Index +"].AccountDr", ThisObject);
			EndIf;
		Else
			If Row.AccountDr.NotUsedForRecords Then
				Cancel = True;
				CommonFunctionsClientServer.ShowUsersMessage(
					StrTemplate(R().AccountingError_01, Row.AccountDr), "RegisterRecords.Basic["+ Index +"].AccountDr", ThisObject);
			EndIf;
		EndIf;
		
		If Not ValueIsFilled(Row.AccountCr) Then
			If Not (ValueIsFilled(Row.AccountDr) And Row.AccountDr.OffBalance) Then
				Cancel = True;
				CommonFunctionsClientServer.ShowUsersMessage(
					R().AccountingError_03, "RegisterRecords.Basic["+ Index +"].AccountCr", ThisObject);
			EndIf;
		Else
			If Row.AccountCr.NotUsedForRecords Then
				Cancel = True;
				CommonFunctionsClientServer.ShowUsersMessage(
					StrTemplate(R().AccountingError_01, Row.AccountCr), "RegisterRecords.Basic["+ Index +"].AccountCr", ThisObject);
			EndIf;
		EndIf;
		
		Index = Index + 1;
	EndDo;
	
EndProcedure
