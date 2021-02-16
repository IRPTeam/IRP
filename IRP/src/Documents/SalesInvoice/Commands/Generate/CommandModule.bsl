
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	ArrayOfFillingValues = GetArrayOfFillingValues(CommandParameter);
	If Not ArrayOfFillingValues.Count() Then
		CommonFunctionsClientServer.ShowUsersMessage("nothing to fill");
	EndIf;
	For Each FillingValues In ArrayOfFillingValues Do
		FormParameters = New Structure("FillingValues", FillingValues);
		OpenForm("Document.SalesInvoice.ObjectForm", FormParameters, , New UUID());
	EndDo;
EndProcedure

Function GetArrayOfFillingValues(Basises)
	
	BasisesTable = RowIDInfo.GetBasisesFor_SalesInvoice(New Structure("Basises", Basises));
	
	Basises_SalesOrder = BasisesTable.Copy();
	Basises_SalesOrder.Clear();
	For Each Row In BasisesTable Do
		If TypeOf(Row.Basis) = Type("DocumentRef.SalesOrder") Then
			FillPropertyValues(Basises_SalesOrder.Add(), Row);
		EndIf;
	EndDo;
	
	ExtractedData = New Array();
	ExtractedData.Add(RowIDInfo.ExtractData_SalesOrder(Basises_SalesOrder));
	
	Return RowIDInfo.ConvertDataToFillingValues(Metadata.Documents.SalesInvoice, ExtractedData);	
EndFunction

