
Procedure BeforeWrite(Cancel)
	If DataExchange.Load Then
		Return;
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

Procedure Filling(FillingData, FillingText, StandardProcessing)
	ThisObject.Type = Enums.BillOfMaterialsTypes.Product;
	ThisObject.Active = True;
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If ThisObject.Type = Enums.BillOfMaterialsTypes.Product Then		
		IndexOfArray = CheckedAttributes.Find("Content.ExpenseType");
		If IndexOfArray <> Undefined Then
			CheckedAttributes.Delete(IndexOfArray);
		EndIf;
		CheckProductBillOfMaterials(Cancel, CheckedAttributes);
	EndIf;
EndProcedure

Procedure CheckProductBillOfMaterials(Cancel, CheckedAttributes)
	ValueTable = New ValueTable();
	ValueTable.Columns.Add("ItemKey");
	ValueTable.Columns.Add("Counter");
	For Each Row In ThisObject.Content Do
		NewRow = ValueTable.Add();
		NewRow.ItemKey = Row.ItemKey;
		NewRow.Counter = 1;
	EndDo;
	ValueTable.GroupBy("ItemKey", "Counter");
	ArrayOfTakes = New Array();
	For Each Row In ValueTable Do
		If Row.Counter > 1 Then
			ArrayOfTakes.Add(Row.ItemKey);
		EndIf;
	EndDo;
	For Each ItemOfTakes In ArrayOfTakes Do
		ArrayOfContentRows = ThisObject.Content.FindRows(New Structure("ItemKey", ItemOfTakes));
		For Each ItemOfContentRows In ArrayOfContentRows Do
			Cancel = True;
			MessageText = StrTemplate(R().MF_Error_001, ""+ItemOfContentRows.ItemKey.Item+", "+ItemOfContentRows.ItemKey);
			CommonFunctionsClientServer.ShowUsersMessage(MessageText, 
			"Object.Content[" + (ItemOfContentRows.LineNumber - 1) + "].ItemKey", 
			"Object.Content");
		EndDo;
	EndDo;
	
	If Cancel = True Then
		Return;
	EndIf;
	
	ArrayRowsWithError = New Array();
	For Each Row In ThisObject.Content Do
		ArrayOfLoopedSemoproducts = New Array();
		If Not ValueIsFilled(Row.BillOfMaterials) Then
			Continue;
		EndIf;
		ArrayOfSemiproducts = New Array();
		ArrayOfSemiproducts.Add(Row.ItemKey);
		If Row.BillOfMaterials = ThisObject.Ref Then
			CheckSemiproductsRecursive(ThisObject.Content, ArrayOfSemiproducts, ArrayOfLoopedSemoproducts);
		Else
			CheckSemiproductsRecursive(Row.BillOfMaterials.Content, ArrayOfSemiproducts, ArrayOfLoopedSemoproducts);
		EndIf;
		If ArrayOfLoopedSemoproducts.Count() Then
			ArrayRowsWithError.Add(Row);
		EndIf;
	EndDo;
	
	For Each ItemRowWithError In ArrayRowsWithError Do
		ArrayOfContentRows = ThisObject.Content.FindRows(New Structure("ItemKey", ItemRowWithError.ItemKey));
		For Each ItemOfContentRows In ArrayOfContentRows Do
			Cancel = True;
			MessageText = StrTemplate(R().MF_Error_002, ""+ItemOfContentRows.ItemKey.Item+", "+ItemOfContentRows.ItemKey);
			CommonFunctionsClientServer.ShowUsersMessage(MessageText, 
			"Object.Content[" + (ItemOfContentRows.LineNumber - 1) + "].ItemKey", 
			"Object.Content");
		EndDo;
	EndDo;
	
EndProcedure

Procedure CheckSemiproductsRecursive(Content, ArrayOfSemiproducts, ArrayOfLoopedSemoproducts)
	For Each Row In Content Do
		If Not ValueIsFilled(Row.BillOfMaterials) Then
			Continue;
		EndIf;
		
		If ArrayOfSemiproducts.Find(Row.ItemKey) <> Undefined Then
			ArrayOfLoopedSemoproducts.Add(Row.ItemKey);
		Else
			ArrayOfSemiproducts.Add(Row.ItemKey);
			CheckSemiproductsRecursive(Row.BillOfMaterials.Content, ArrayOfSemiproducts, ArrayOfLoopedSemoproducts);
		EndIf;
	EndDo;
EndProcedure
