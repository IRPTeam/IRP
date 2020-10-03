&AtClient
Procedure SearchByBarcode(Command, Barcode = "")
	DocumentsClient.SearchByBarcode(Barcode, DocumentObject, ThisObject, ThisObject);
EndProcedure

&AtClient
Procedure SearchByBarcodeEnd(Result, AdditionalParameters) Export

	NotifyParameters = New Structure();
	NotifyParameters.Insert("Form", ThisObject);
	NotifyParameters.Insert("Object", DocumentObject);
	Items.DetailedInformation.document.getElementById("text").innerHTML = "";
	
	For Each Row In AdditionalParameters.FoundedItems Do
		NewRow = DocumentObject.ItemList.Add();
		FillPropertyValues(NewRow, Row);
		NewRow.PhysCount = Row.Quantity;
	EndDo;

EndProcedure