
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	ThisObject.RetailCustomer = Parameters.RetailCustomer;
	ThisObject.ItemKey = Parameters.ItemKey;
	
	SetListParameters();

EndProcedure

&AtClient
Procedure Choose(Command)
	CurrentData = Items.List.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	Close(CurrentData.RetailSalesReceipt);
EndProcedure

&AtClient
Procedure ListSelection(Item, RowSelected, Field, StandardProcessing)
	StandardProcessing = False;
	Choose(Undefined);
EndProcedure

&AtClient
Procedure RetailCustomerOnChange(Item)
	SetListParameters();
	Items.List.Refresh();
EndProcedure

&AtClient
Procedure ItemKeyOnChange(Item)
	SetListParameters();
	Items.List.Refresh();
EndProcedure

&AtClient
Procedure FiscalNumberOnChange(Item)
	SetListParameters();
	Items.List.Refresh();
EndProcedure

&AtServer
Procedure SetListParameters()
	
	ThisObject.List.QueryText = 
	"SELECT
	|	R2050T_RetailSalesTurnovers.RetailSalesReceipt,
	|	SalesTable.Date AS SaleDate,
	|	SalesTable.RetailCustomer AS RetailCustomer,
	|	MAX(ISNULL(DocumentFiscalStatus.DataPresentation, """")) AS FiscalData,
	|	SalesTable.DocumentAmount
	|INTO tmpData
	|FROM
	|	AccumulationRegister.R2050T_RetailSales.Turnovers AS R2050T_RetailSalesTurnovers
	|		LEFT JOIN Document.RetailSalesReceipt AS SalesTable
	|		ON R2050T_RetailSalesTurnovers.RetailSalesReceipt = SalesTable.Ref
	|		LEFT JOIN InformationRegister.DocumentFiscalStatus AS DocumentFiscalStatus
	|		ON R2050T_RetailSalesTurnovers.RetailSalesReceipt = DocumentFiscalStatus.Document
	|
	|" + ?(ThisObject.ItemKey.IsEmpty(), "", "WHERE R2050T_RetailSalesTurnovers.ItemKey = &ItemKey") + "
	|GROUP BY
	|	R2050T_RetailSalesTurnovers.RetailSalesReceipt,
	|	SalesTable.Date,
	|	SalesTable.RetailCustomer,
	|	SalesTable.DocumentAmount
	|HAVING
	|	SUM(R2050T_RetailSalesTurnovers.QuantityTurnover) > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmpData.RetailSalesReceipt,
	|	tmpData.SaleDate,
	|	tmpData.RetailCustomer,
	|	tmpData.FiscalData,
	|	tmpData.DocumentAmount
	|FROM
	|	tmpData AS tmpData
	|WHERE
	|	TRUE
	|	" + ?(ThisObject.RetailCustomer.IsEmpty(), "", "AND tmpData.RetailCustomer = &RetailCustomer") + "
	|	" + ?(IsBlankString(ThisObject.FiscalNumber), "", "AND tmpData.FiscalData LIKE &FiscalNumber");
	
	If Not ThisObject.ItemKey.IsEmpty() Then
		ThisObject.List.Parameters.SetParameterValue("ItemKey", ThisObject.ItemKey);
	EndIf;
	
	If Not ThisObject.RetailCustomer.IsEmpty() Then
		ThisObject.List.Parameters.SetParameterValue("RetailCustomer", ThisObject.RetailCustomer);
	EndIf;
	
	If Not IsBlankString(ThisObject.FiscalNumber) Then
		ThisObject.List.Parameters.SetParameterValue("FiscalNumber", "%" + TrimAll(ThisObject.FiscalNumber) + "%");
	EndIf;
	
EndProcedure

