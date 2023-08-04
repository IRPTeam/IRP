
&AtClient
Procedure Select(Command)
	If CurrentItem = Items.SalesOrders Then
		CurrentRow = Items.SalesOrders.CurrentData;
	ElsIf CurrentItem = Items.RetailShipmentConfirmation Then
		CurrentRow = Items.RetailShipmentConfirmation.CurrentData;
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
	
	NewFilter = RetailShipmentConfirmation.Filter.Items.Add(Type("DataCompositionFilterItem"));
	NewFilter.Use = True;
	NewFilter.RightValue = Parameters.RetailCustomer;
	NewFilter.LeftValue = New DataCompositionField("RetailCustomer");
EndProcedure
