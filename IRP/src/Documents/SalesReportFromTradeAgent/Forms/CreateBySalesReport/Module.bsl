
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.SalesReportList.Load(CommissionTradeServer.GetSalesReportToConsignorList());
EndProcedure

&AtClient
Procedure Ok(Command)
	For Each Row In ThisObject.SalesReportList Do
		If Row.Use Then
			FillingData = CommissionTradeServer.GetFillingDataBySalesReportToConsignor(Row.SalesReportRef);
			OpenForm("Document.SalesReportFromTradeAgent.ObjectForm", New Structure("FillingValues", FillingData), , New UUID());
			Break;
		EndIf;
	EndDo;
	Close();
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close();
EndProcedure

&AtClient
Procedure SalesReportListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure SalesReportListBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure SalesReportListUseOnChange(Item)
	CurrentData = Items.SalesReportList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	RowID = CurrentData.GetID();
	For Each Row In ThisObject.SalesReportList Do
		If Row.GetID() = RowID Then
			Continue;
		EndIf;
		Row.Use = False;
	EndDo;
EndProcedure

