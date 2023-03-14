Procedure BeforeWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;

	If ThisObject.IsFolder Or (ThisObject.AdditionalProperties.Property("WriteMode")
		And ThisObject.AdditionalProperties.WriteMode = "Service") Then
		Return;
	EndIf;

	Query = New Query();
	Query.Text =
	"SELECT
	|	ObjectStatuses.Ref
	|FROM
	|	Catalog.ObjectStatuses AS ObjectStatuses
	|WHERE
	|	ObjectStatuses.SetByDefault
	|	AND ObjectStatuses.Parent = &Parent
	|	AND ObjectStatuses.Ref <> &Ref";

	Query.SetParameter("Parent", ThisObject.Parent);
	Query.SetParameter("Ref", ThisObject.Ref);
	QueryResult = Query.Execute();

	QueryTable = QueryResult.Unload();

	DataLock = New DataLock();
	ItemLock = DataLock.Add("Catalog.ObjectStatuses");
	ItemLock.Mode = DataLockMode.Exclusive;
	ItemLock.DataSource = QueryTable;
	ItemLock.UseFromDataSource("Ref", "Ref");
	DataLock.Lock();

	If Not QueryTable.Count() Then
		ThisObject.SetByDefault = True;
	Else
		If ThisObject.SetByDefault Then
			For Each Row In QueryTable Do
				OtherObject = Row.Ref.GetObject();
				OtherObject.SetByDefault = False;
				OtherObject.AdditionalProperties.Insert("WriteMode", "Service");
				Try
					OtherObject.Write();
				Except
					Cancel = True;
					Message = StrTemplate(R().Error_009, String(ErrorInfo()));
					CommonFunctionsClientServer.ShowUsersMessage(Message);
					Return;
				EndTry;
			EndDo;
		EndIf;
	EndIf;
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If ThisObject.IsFolder Then
		Index = CheckedAttributes.Find("Parent");
		If Index <> Undefined Then
			CheckedAttributes.Delete(Index);
		EndIf;
	EndIf;
EndProcedure

Procedure Filling(FillingData, FillingText, StandardProcessing)
	If ThisObject.IsFolder Then
		Return;
	EndIf;
	
	ThisObject.PostingChequeBondBalance    = Enums.DocumentPostingTypes.Nothing;
	ThisObject.PostingVendorTransactions   = Enums.DocumentPostingTypes.Nothing;
	ThisObject.PostingCustomerTransactions = Enums.DocumentPostingTypes.Nothing;
	ThisObject.PostingCashPlanning         = Enums.DocumentPostingTypes.Nothing;
EndProcedure

Procedure OnCopy(CopiedObject)
	CopiedObject.UniqueID = Undefined;
EndProcedure