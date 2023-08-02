
&AtClient
Procedure Select(Command)
	If Items.MainPages.CurrentPage = Items.PageSalesOrders Then
		CurrentRow = Items.SalesOrders.CurrentData;
	EndIf;
	If Not CurrentRow = Undefined Then
		Close(CurrentRow.Ref);
	EndIf;
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	NewFilter = SalesOrders.Filter.Items.Add(Type("DataCompositionFilterItem"));
	NewFilter.Use = True;
	NewFilter.RightValue = Parameters.RetailCustomer;
	NewFilter.LeftValue = New DataCompositionField("RetailCustomer");
EndProcedure
