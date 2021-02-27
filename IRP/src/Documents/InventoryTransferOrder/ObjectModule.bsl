
Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;	
	
	If UseShipmentConfirmation And Not UseGoodsReceipt Then
		CommonFunctionsClientServer.ShowUsersMessage(R().Error_094, "UseGoodsReceipt");
		Cancel = True;
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

Procedure Posting(Cancel, PostingMode)
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
	
	If Not Cancel Then
		IsBasedOnInternalSupplyRequest = False;
		For Each Row In ThisObject.ItemList Do
			If ValueIsFilled(Row.InternalSupplyRequest) Then
				IsBasedOnInternalSupplyRequest = True;
			EndIf;
		EndDo;
		If IsBasedOnInternalSupplyRequest Then
			StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
			If StatusInfo.Posting Then
				RecordSet = InformationRegisters.CreatedProcurementOrders.CreateRecordSet();
				RecordSet.Filter.Order.Set(Ref);
				RecordSet.Clear();
				RecordSet.Write();
			Else
				RecordSet = InformationRegisters.CreatedProcurementOrders.CreateRecordSet();
				RecordSet.Filter.Order.Set(Ref);
				RecordSet.Add().Order = Ref;
				RecordSet.Write(True);
			EndIf;
		EndIf;
	EndIf;
EndProcedure

Procedure UndoPosting(Cancel)
	
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
	
EndProcedure

Procedure Filling(FillingData, FillingText, StandardProcessing)
	
	If FillingData = Undefined Then
		Return;
	EndIf;
	
	ArrayOfBasises = New Array();
	If TypeOf(FillingData) <> Type("Structure") Then
		ArrayOfBasises.Add(FillingData);
	Else
		ArrayOfBasises = FillingData.Basis;
	EndIf;
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	OrderBalanceBalance.Store AS Store,
		|	OrderBalanceBalance.Order AS InternalSupplyRequest,
		|	OrderBalanceBalance.ItemKey,
		|	OrderBalanceBalance.RowKey,
		|	CASE
		|		WHEN OrderBalanceBalance.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
		|			THEN OrderBalanceBalance.ItemKey.Unit
		|		ELSE OrderBalanceBalance.ItemKey.Item.Unit
		|	END AS Unit,
		|	OrderBalanceBalance.QuantityBalance AS Quantity
		|FROM
		|	AccumulationRegister.OrderBalance.Balance(&Period, Order IN (&ArrayOfBasises)) AS OrderBalanceBalance";
	Query.SetParameter("ArrayOfBasises", ArrayOfBasises);
	Query.SetParameter("Period", New Boundary(ThisObject.PointInTime(), BoundaryType.Excluding));
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	While QuerySelection.Next() Do
		NewRow = ThisObject.ItemList.Add();
		FillPropertyValues(NewRow, QuerySelection);
		NewRow.Key = QuerySelection.RowKey;
		If ValueIsFilled(QuerySelection.Unit) And ValueIsFilled(QuerySelection.Unit.Quantity) Then
			NewRow.Quantity = QuerySelection.Quantity / QuerySelection.Unit.Quantity;
			EndIf;
		ThisObject.StoreReceiver = QuerySelection.Store;
	EndDo;
	
	// TODO: ObjectModule.Filling(): Refact filling function
	If ArrayOfBasises.Count() Then
		FillPropertyValues(ThisObject, ArrayOfBasises.Get(0), , "Number, Date");
	EndIf;
	
EndProcedure
