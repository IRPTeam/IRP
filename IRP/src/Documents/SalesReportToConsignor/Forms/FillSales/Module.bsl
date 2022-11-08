
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.SalesPeriod.StartDate = Parameters.StartDate;
	ThisObject.SalesPeriod.EndDate   = Parameters.EndDate;	
	
	ThisObject.Company   = Parameters.Company;	
	ThisObject.Partner   = Parameters.Partner;	
	ThisObject.Agreement = Parameters.Agreement;
	ThisObject.PriceIncludeTax = Parameters.PriceIncludeTax;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	ThisObject.OwnerUUID = FormOwner.UUID;
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close(Undefined);
EndProcedure

&AtClient
Procedure Ok(Command)
	SalesInfo = PutSalesToTempStorage();
	Result = New Structure();
	Result.Insert("StartDate", ThisObject.SalesPeriod.StartDate);
	Result.Insert("EndDate"  , ThisObject.SalesPeriod.EndDate);
	Result.Insert("Address"     , SalesInfo.Address);
	Result.Insert("GroupColumn" , SalesInfo.GroupColumn);
	Result.Insert("SumColumn"   , SalesInfo.SumColumn);
	Close(Result);
EndProcedure

&AtServer
Function PutSalesToTempStorage()
	SalesTable = ThisObject.Sales.Unload().Copy(New Structure("Use", True));	
	Address = PutToTempStorage(SalesTable, ThisObject.OwnerUUID);
	GroupColumn = "Item, ItemKey, Unit, PriceType, ConsignorPrice, TradeAgentFeePercent, Price, Quantity, NetAmount, TotalAmount, SalesInvoice, PurchaseInvoice, SerialLotNumber";
	SumColumn = "SumColumn";
	Return New Structure("Address, GroupColumn, SumColumn", Address, GroupColumn, SumColumn);
EndFunction

&AtClient
Procedure FillSales(Command)
	If Not ThisObject.CheckFilling() Then
		Return;
	EndIf;
	
	FillSalesAtServer();		
EndProcedure

&AtServer
Procedure FillSalesAtServer()
	QueryParameters = New Structure();
	QueryParameters.Insert("StartDate"       , ThisObject.SalesPeriod.StartDate);
	QueryParameters.Insert("EndDate"         , ThisObject.SalesPeriod.EndDate);
	QueryParameters.Insert("Company"         , ThisObject.Company);
	QueryParameters.Insert("Partner"         , ThisObject.Partner);
	QueryParameters.Insert("Agreement"       , ThisObject.Agreement);
	QueryParameters.Insert("PriceIncludeTax" , ThisObject.PriceIncludeTax);
	
	SalesTable = DocSalesReportToConsignorServer.GetConsignorSales(QueryParameters);
	ThisObject.Sales.Load(SalesTable);
EndProcedure

&AtServer
Procedure FillCheckProcessingAtServer(Cancel, CheckedAttributes)
	CheckedAttributes.Add("SalesPeriod");
EndProcedure

&AtClient
Procedure SalesBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure SalesBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure CheckAll(Command)
	ChangeUse(True);
EndProcedure

&AtClient
Procedure UncheckAll(Command)
	ChangeUse(False);
EndProcedure

&AtClient
Procedure ChangeUse(Value)
	For Each Row In ThisObject.Sales Do
		Row.Use = Value;
	EndDo;
EndProcedure

