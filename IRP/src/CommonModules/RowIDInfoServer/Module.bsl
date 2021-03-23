
Procedure Posting_RowID(Source, Cancel, PostingMode) Export
	If Source.Metadata().TabularSections.Find("RowIDInfo") = Undefined Then
		Return;
	EndIf;
	
	If Source.Metadata().Attributes.Find("Status") <> Undefined Then
		StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Source.Ref);
		If Not StatusInfo.Posting Then
			Return;
		EndIf;
	EndIf;
	
	Query = New Query;
	Query.Text =
		"SELECT
		|	Table.Ref AS Recorder,
		|	Table.Ref.Date AS Period,
		|	*
		|INTO RowIDMovements
		|FROM
		|	Document." + Source.Metadata().Name + ".RowIDInfo AS Table
		|WHERE
		|	Table.Ref = &Ref
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	Table.Recorder,
		|	Table.Period,
		|	Table.RowID,
		|	Table.CurrentStep AS Step,
		|	CASE
		|		WHEN Table.Basis.Ref IS NULL
		|			THEN &Ref
		|		ELSE Table.Basis
		|	END AS Basis,
		|	Table.RowRef,
		|	CASE
		|		WHEN ISNULL(T10000B_RowIDMovements.QuantityBalance, 0) < Table.Quantity
		|			THEN ISNULL(T10000B_RowIDMovements.QuantityBalance, 0)
		|		ELSE Table.Quantity
		|	END AS Quantity
		|FROM
		|	RowIDMovements AS Table
		|		INNER JOIN AccumulationRegister.T10000B_RowIDMovements.Balance(&Period, (RowID, Step, Basis, RowRef) IN
		|			(SELECT
		|				Table.RowID,
		|				Table.CurrentStep,
		|				Table.Basis,
		|				Table.RowRef
		|			FROM
		|				RowIDMovements AS Table
		|			WHERE
		|				NOT Table.CurrentStep = VALUE(Catalog.MovementRules.EmptyRef))) AS T10000B_RowIDMovements
		|		ON T10000B_RowIDMovements.RowID = Table.RowID
		|		AND T10000B_RowIDMovements.Step = Table.CurrentStep
		|		AND T10000B_RowIDMovements.Basis = Table.Basis
		|		AND T10000B_RowIDMovements.RowRef = Table.RowRef
		|WHERE
		|	NOT Table.CurrentStep = VALUE(Catalog.MovementRules.EmptyRef)
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt),
		|	Table.Recorder,
		|	Table.Period,
		|	Table.RowID,
		|	Table.NextStep AS Step,
		|	&Ref,
		|
		|	Table.RowRef,
		|	Table.Quantity
		|FROM
		|	RowIDMovements AS Table
		|WHERE
		|	NOT Table.NextStep = VALUE(Catalog.MovementRules.EmptyRef)";

	Query.SetParameter("Ref", Source.Ref);
	Query.SetParameter("Period", New Boundary(Source.Ref.PointInTime(), BoundaryType.Excluding));
	
	QueryResult = Query.Execute().Unload();
	Source.RegisterRecords.T10000B_RowIDMovements.Load(QueryResult);
EndProcedure

Procedure BeforeWrite_RowID(Source, Cancel, WriteMode, PostingMode) Export
	If Source.DataExchange.Load Then
		Return;
	EndIf;
	
	If Is(Source).SO Then
		FillRowID_SO(Source);	
	ElsIf Is(Source).SI Then
		FillRowID_SI(Source);
	ElsIf Is(Source).SC Then	
		FillRowID_SC(Source);
	ElsIf Is(Source).PO Then	
		FillRowID_PO(Source);
	ElsIf Is(Source).PI Then	
		FillRowID_PI(Source);
	ElsIf Is(Source).GR Then	
		FillRowID_GR(Source);
	ElsIf Is(Source).ITO Then	
		FillRowID_ITO(Source);
	ElsIf Is(Source).IT Then	
		FillRowID_IT(Source);
	ElsIf Is(Source).ISR Then	
		FillRowID_ISR(Source);
	ElsIf Is(Source).PhysicalInventory Then
		FillRowID_PhysicalInventory(Source);
	ElsIf Is(Source).StockAdjustmentAsSurplus Then
		FillRowID_StockAdjustmentAsSurplus(Source);
	ElsIf Is(Source).StockAdjustmentAsWriteOff Then
		FillRowID_StockAdjustmentAsWriteOff(Source);
	ElsIf Is(Source).PR Then
		FillRowID_PR(Source);
	ElsIf Is(Source).PRO Then
		FillRowID_PRO(Source);
	ElsIf Is(Source).SR Then
		FillRowID_SR(Source);
	ElsIf Is(Source).SRO Then
		FillRowID_SRO(Source);			
	EndIf;
EndProcedure

Procedure OnWrite_RowID(Source, Cancel) Export
	If Source.DataExchange.Load Then
		Return;
	EndIf;
	
	If Source.Metadata().TabularSections.Find("RowIDInfo") = Undefined Then
		Return;
	EndIf;
	
	For Each Row In Source.RowIDInfo Do
		If Not ValueIsFilled(Row.RowRef.Basis) Then
			RowRefObject = Row.RowRef.GetObject();
			RowRefObject.Basis = Source.Ref;
			RowRefObject.Write();
		ElsIf Row.RowRef.Basis = Source.Ref Then
			RowItemList = Source.ItemList.FindRows(New Structure("Key", Row.Key))[0];
			RowRefObject = Row.RowRef.GetObject(); 
			UpdateRowIDCatalog(Source, Row, RowItemList, RowRefObject)
		EndIf;
	EndDo;
EndProcedure

#Region RowID

#Region FillRowID

Procedure FillRowID_SO(Source)
	For Each RowItemList In Source.ItemList Do
	
		If RowItemList.Cancel Then
			Continue;
		EndIf;
		
		Row = Undefined;
		IDInfoRows = Source.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		If IDInfoRows.Count() = 0 Then
			Row = Source.RowIDInfo.Add();
		ElsIf IDInfoRows.Count() = 1 Then
			Row = IDInfoRows[0];
		EndIf;

		FillRowID(Source, Row, RowItemList);
		Row.NextStep = GetNextStep_SO(Source, RowItemList, Row);
	EndDo;
EndProcedure

Procedure FillRowID_SI(Source)
	For Each RowItemList In Source.ItemList Do	
		Row = Undefined;
		IDInfoRows = Source.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		If IDInfoRows.Count() = 0 Then
			Row = Source.RowIDInfo.Add();
			FillRowID(Source, Row, RowItemList);
			Row.NextStep = GetNextStep_SI(Source, RowItemList, Row);
		Else
			For Each Row In IDInfoRows Do
				If ValueIsFilled(Row.RowRef) And Row.RowRef.Basis <> Source.Ref Then
					Row.NextStep = GetNextStep_SI(Source, RowItemList, Row);
				 	Continue;
				EndIf;
				FillRowID(Source, Row, RowItemList);
				Row.NextStep = GetNextStep_SI(Source, RowItemList, Row);
			EndDo;
		EndIf;
	EndDo;
EndProcedure

Procedure FillRowID_SC(Source)
	For Each RowItemList In Source.ItemList Do	
		Row = Undefined;
		IDInfoRows = Source.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		If IDInfoRows.Count() = 0 Then
			Row = Source.RowIDInfo.Add();
			FillRowID(Source, Row, RowItemList);
			Row.NextStep = GetNextStep_SC(Source, RowItemList, Row);
		Else
			
			IDInfoRowsTable = Source.RowIDInfo.Unload().Copy(New Structure("Key", RowItemList.Key));
			CurrentStep = Undefined;
			For Each Row In IDInfoRowsTable Do
				If ValueIsFilled(Row.CurrentStep) Then
					CurrentStep = Row.CurrentStep;
					Break;
				EndIf;
			EndDo;
			IDInfoRowsTable.FillValues(CurrentStep, "CurrentStep");
			IDInfoRowsTable.GroupBy("Key, RowID, Basis, CurrentStep, RowRef, BasisKey");
			For Each Row In IDInfoRows Do
		    	Source.RowIDInfo.Delete(Row);
			EndDo;
			TotalQuantity = 0;
			For Each Row In IDInfoRowsTable Do
				NewRow = Source.RowIDInfo.Add();
				FillPropertyValues(NewRow, Row);
				NewRow.NextStep = GetNextStep_SC(Source, RowItemList, NewRow);
				If ValueIsFilled(Row.Basis) Then
			    	BalanceQuantity = GetBalanceQuantity(Source, Row);
					NewRow.Quantity = Min(BalanceQuantity, RowItemList.QuantityInBaseUnit);
				Else
					NewRow.Quantity = RowItemList.QuantityInBaseUnit;
				EndIf;
				TotalQuantity = TotalQuantity + NewRow.Quantity;
			EndDo;
			If RowItemList.QuantityInBaseUnit > TotalQuantity Then
				For Each Row In IDInfoRowsTable Do
					NewRow = Source.RowIDInfo.Add();
					FillPropertyValues(NewRow, Row);
					NewRow.CurrentStep = Undefined;
					NewRow.NextStep = Catalogs.MovementRules.SI;
					NewRow.Quantity = RowItemList.QuantityInBaseUnit - TotalQuantity;
				EndDo;	
			EndIf;		
		EndIf;
	EndDo;
EndProcedure

Procedure FillRowID_PO(Source)
	For Each RowItemList In Source.ItemList Do	
		Row = Undefined;
		IDInfoRows = Source.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		If RowItemList.Cancel Then
			For Each Row In IDInfoRows Do
				Source.RowIDInfo.Delete(Row);
			EndDo;
			Continue;
		EndIf;
		If IDInfoRows.Count() = 0 Then
			Row = Source.RowIDInfo.Add();
			FillRowID(Source, Row, RowItemList);
			Row.NextStep = GetNextStep_PO(Source, RowItemList, Row);
		Else
			For Each Row In IDInfoRows Do
				If ValueIsFilled(Row.RowRef) And Row.RowRef.Basis <> Source.Ref Then
					Row.NextStep = GetNextStep_PO(Source, RowItemList, Row);
				 	Continue;
				EndIf;
				FillRowID(Source, Row, RowItemList);
				Row.NextStep = GetNextStep_PO(Source, RowItemList, Row);
			EndDo;
		EndIf;
	EndDo;
EndProcedure

Procedure FillRowID_PI(Source)
	For Each RowItemList In Source.ItemList Do	
		Row = Undefined;
		IDInfoRows = Source.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		If IDInfoRows.Count() = 0 Then
			Row = Source.RowIDInfo.Add();
			FillRowID(Source, Row, RowItemList);
			Row.NextStep = GetNextStep_PI(Source, RowItemList, Row);
		Else
			For Each Row In IDInfoRows Do
				If ValueIsFilled(Row.RowRef) And Row.RowRef.Basis <> Source.Ref Then
					Row.NextStep = GetNextStep_PI(Source, RowItemList, Row);
				 	Continue;
				EndIf;
				FillRowID(Source, Row, RowItemList);
				Row.NextStep = GetNextStep_PI(Source, RowItemList, Row);
			EndDo;
		EndIf;
	EndDo;
	
	NewRows = New Map();
	
	For Each Row In Source.RowIDInfo Do
		If Not ValueIsFilled(Row.CurrentStep) Then
			Continue;
		EndIf;
		For Each RowItemList In Source.ItemList.FindRows(New Structure("Key", Row.Key)) Do
			If ValueIsFilled(RowItemList.SalesOrder) And Not RowItemList.UseGoodsReceipt Then
				NewRows.Insert(Row, RowItemList.QuantityInBaseUnit);
			EndIf;
		EndDo;
	EndDo;
	
	For Each Row In NewRows Do
		NewRow = Source.RowIDInfo.Add();
		FillPropertyValues(NewRow, Row.Key);
		NewRow.CurrentStep = Undefined;
		NewRow.NextStep    = Catalogs.MovementRules.SI_SC;
		NewRow.Quantity    = Row.Value;
	EndDo;
EndProcedure

Procedure FillRowID_GR(Source)
	For Each RowItemList In Source.ItemList Do	
		Row = Undefined;
		IDInfoRows = Source.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		If IDInfoRows.Count() = 0 Then
			Row = Source.RowIDInfo.Add();
			FillRowID(Source, Row, RowItemList);
			Row.NextStep = GetNextStep_GR(Source, RowItemList, Row);
		Else
			
			IDInfoRowsTable = Source.RowIDInfo.Unload().Copy(New Structure("Key", RowItemList.Key));
			CurrentStep = Undefined;
			For Each Row In IDInfoRowsTable Do
				If ValueIsFilled(Row.CurrentStep) Then
					CurrentStep = Row.CurrentStep;
					Break;
				EndIf;
			EndDo;
			IDInfoRowsTable.FillValues(CurrentStep, "CurrentStep");
			IDInfoRowsTable.GroupBy("Key, RowID, Basis, CurrentStep, RowRef, BasisKey");
			For Each Row In IDInfoRows Do
		    	Source.RowIDInfo.Delete(Row);
			EndDo;
			TotalQuantity = 0;
			For Each Row In IDInfoRowsTable Do
				NewRow = Source.RowIDInfo.Add();
				FillPropertyValues(NewRow, Row);
				NewRow.NextStep = GetNextStep_GR(Source, RowItemList, NewRow);
				If ValueIsFilled(Row.Basis) Then
			    	BalanceQuantity = GetBalanceQuantity(Source, Row);
					NewRow.Quantity = Min(BalanceQuantity, RowItemList.QuantityInBaseUnit);
				Else
					NewRow.Quantity = RowItemList.QuantityInBaseUnit;
				EndIf;
				TotalQuantity = TotalQuantity + NewRow.Quantity;
			EndDo;
			If RowItemList.QuantityInBaseUnit > TotalQuantity Then
				For Each Row In IDInfoRowsTable Do
					NewRow = Source.RowIDInfo.Add();
					FillPropertyValues(NewRow, Row);
					NewRow.CurrentStep = Undefined;
					NewRow.NextStep = Catalogs.MovementRules.PI;
					NewRow.Quantity = RowItemList.QuantityInBaseUnit - TotalQuantity;
				EndDo;	
			EndIf;		
		EndIf;
	EndDo;
	
	NewRows = New Map();
	
	For Each Row In Source.RowIDInfo Do
		If Not ValueIsFilled(Row.CurrentStep) Then
			Continue;
		EndIf;
		For Each RowItemList In Source.ItemList.FindRows(New Structure("Key", Row.Key)) Do
			If ValueIsFilled(RowItemList.SalesOrder) Then
				NewRows.Insert(Row, RowItemList.QuantityInBaseUnit);
			EndIf;
		EndDo;
	EndDo;
	
	For Each Row In NewRows Do
		NewRow = Source.RowIDInfo.Add();
		FillPropertyValues(NewRow, Row.Key);
		NewRow.CurrentStep = Undefined;
		NewRow.NextStep    = Catalogs.MovementRules.SI_SC;
		NewRow.Quantity    = Row.Value;
	EndDo;
EndProcedure

Procedure FillRowID_ITO(Source)
	For Each RowItemList In Source.ItemList Do	
		Row = Undefined;
		IDInfoRows = Source.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		If IDInfoRows.Count() = 0 Then
			Row = Source.RowIDInfo.Add();
			FillRowID(Source, Row, RowItemList);
			Row.NextStep = GetNextStep_ITO(Source, RowItemList, Row);
		Else
			For Each Row In IDInfoRows Do
				If ValueIsFilled(Row.RowRef) And Row.RowRef.Basis <> Source.Ref Then
					Row.NextStep = GetNextStep_ITO(Source, RowItemList, Row);
				 	Continue;
				EndIf;
				FillRowID(Source, Row, RowItemList);
				Row.NextStep = GetNextStep_ITO(Source, RowItemList, Row);
			EndDo;
		EndIf;
	EndDo;
EndProcedure

Procedure FillRowID_IT(Source)
	For Each RowItemList In Source.ItemList Do
		IDInfoRows = Source.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		For Each Row In IDInfoRows Do
			If Not ValueIsFilled(Row.CurrentStep) Then
				Source.RowIDInfo.Delete(Row);
			EndIf;
		EndDo;
	EndDo;
	
	NewRowsSC = New Map();
	NewRowsGR = New Map();
		
	For Each RowItemList In Source.ItemList Do	
		Row = Undefined;
		IDInfoRows = Source.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		If IDInfoRows.Count() = 0 Then
			Row = Source.RowIDInfo.Add();
			FillRowID(Source, Row, RowItemList);
			Row.NextStep = GetNextStep_IT(Source, RowItemList, Row);
		Else
			Row = IDInfoRows[0];
			Row.NextStep = GetNextStep_IT(Source, RowItemList, Row);
		EndIf;
		
		If Source.UseGoodsReceipt Then
			NewRowsGR.Insert(Row, RowItemList.QuantityInBaseUnit);
		EndIf;
		
		If Source.UseShipmentConfirmation Then
			NewRowsSC.Insert(Row, RowItemList.QuantityInBaseUnit);
		EndIf;
		
	EndDo;
		
	For Each Row In NewRowsSC Do
		NewRow = Source.RowIDInfo.Add();
		FillPropertyValues(NewRow, Row.Key);
		NewRow.CurrentStep = Undefined;
		NewRow.NextStep    = Catalogs.MovementRules.SC;
		NewRow.Quantity    =Row.Value;
	EndDo;
	
	For Each Row In NewRowsGR Do
		NewRow = Source.RowIDInfo.Add();
		FillPropertyValues(NewRow, Row.Key);
		NewRow.CurrentStep = Undefined;
		NewRow.NextStep    = Catalogs.MovementRules.GR;
		NewRow.Quantity    =Row.Value;
	EndDo;
EndProcedure

Procedure FillRowID_ISR(Source)
	For Each RowItemList In Source.ItemList Do	
		Row = Undefined;
		IDInfoRows = Source.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		If IDInfoRows.Count() = 0 Then
			Row = Source.RowIDInfo.Add();
		ElsIf IDInfoRows.Count() = 1 Then
			Row = IDInfoRows[0];
		EndIf;

		FillRowID(Source, Row, RowItemList);
		Row.NextStep = GetNextStep_ISR(Source, RowItemList, Row);
	EndDo;
EndProcedure

Procedure FillRowID_PhysicalInventory(Source)
	For Each RowItemList In Source.ItemList Do	
		Row = Undefined;
		IDInfoRows = Source.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		If IDInfoRows.Count() = 0 Then
			Row = Source.RowIDInfo.Add();
		ElsIf IDInfoRows.Count() = 1 Then
			Row = IDInfoRows[0];
		EndIf;

		FillRowID(Source, Row, RowItemList);
		Row.NextStep = GetNextStep_PhysicalInventory(Source, RowItemList, Row);
	EndDo;
EndProcedure

Procedure FillRowID_StockAdjustmentAsSurplus(Source)
	For Each RowItemList In Source.ItemList Do	
		Row = Undefined;
		IDInfoRows = Source.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		If IDInfoRows.Count() = 0 Then
			Row = Source.RowIDInfo.Add();
			FillRowID(Source, Row, RowItemList);
			Row.NextStep = GetNextStep_StockAdjustmentAsSurplus(Source, RowItemList, Row);
		Else
			For Each Row In IDInfoRows Do
				If ValueIsFilled(Row.RowRef) And Row.RowRef.Basis <> Source.Ref Then
					Row.NextStep = GetNextStep_StockAdjustmentAsSurplus(Source, RowItemList, Row);
				 	Continue;
				EndIf;
				FillRowID(Source, Row, RowItemList);
				Row.NextStep = GetNextStep_StockAdjustmentAsSurplus(Source, RowItemList, Row);
			EndDo;
		EndIf;
	EndDo;
EndProcedure

Procedure FillRowID_StockAdjustmentAsWriteOff(Source)
	For Each RowItemList In Source.ItemList Do	
		Row = Undefined;
		IDInfoRows = Source.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		If IDInfoRows.Count() = 0 Then
			Row = Source.RowIDInfo.Add();
			FillRowID(Source, Row, RowItemList);
			Row.NextStep = GetNextStep_StockAdjustmentAsWriteOff(Source, RowItemList, Row);
		Else
			For Each Row In IDInfoRows Do
				If ValueIsFilled(Row.RowRef) And Row.RowRef.Basis <> Source.Ref Then
					Row.NextStep = GetNextStep_StockAdjustmentAsWriteOff(Source, RowItemList, Row);
				 	Continue;
				EndIf;
				FillRowID(Source, Row, RowItemList);
				Row.NextStep = GetNextStep_StockAdjustmentAsWriteOff(Source, RowItemList, Row);
			EndDo;
		EndIf;
	EndDo;
EndProcedure

Procedure FillRowID_PR(Source)
	For Each RowItemList In Source.ItemList Do	
		Row = Undefined;
		IDInfoRows = Source.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		If IDInfoRows.Count() = 0 Then
			Row = Source.RowIDInfo.Add();
			FillRowID(Source, Row, RowItemList);
			Row.NextStep = GetNextStep_PR(Source, RowItemList, Row);
		Else
			For Each Row In IDInfoRows Do
				If ValueIsFilled(Row.RowRef) And Row.RowRef.Basis <> Source.Ref Then
					Row.NextStep = GetNextStep_PR(Source, RowItemList, Row);
				 	Continue;
				EndIf;
				FillRowID(Source, Row, RowItemList);
				Row.NextStep = GetNextStep_PR(Source, RowItemList, Row);
			EndDo;
		EndIf;
	EndDo;
EndProcedure

Procedure FillRowID_PRO(Source)
	For Each RowItemList In Source.ItemList Do	
		Row = Undefined;
		IDInfoRows = Source.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		If IDInfoRows.Count() = 0 Then
			Row = Source.RowIDInfo.Add();
			FillRowID(Source, Row, RowItemList);
			Row.NextStep = GetNextStep_PRO(Source, RowItemList, Row);
		Else
			For Each Row In IDInfoRows Do
				If ValueIsFilled(Row.RowRef) And Row.RowRef.Basis <> Source.Ref Then
					Row.NextStep = GetNextStep_PRO(Source, RowItemList, Row);
				 	Continue;
				EndIf;
				FillRowID(Source, Row, RowItemList);
				Row.NextStep = GetNextStep_PRO(Source, RowItemList, Row);
			EndDo;
		EndIf;
	EndDo;
EndProcedure

Procedure FillRowID_SR(Source)
	For Each RowItemList In Source.ItemList Do	
		Row = Undefined;
		IDInfoRows = Source.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		If IDInfoRows.Count() = 0 Then
			Row = Source.RowIDInfo.Add();
			FillRowID(Source, Row, RowItemList);
			Row.NextStep = GetNextStep_SR(Source, RowItemList, Row);
		Else
			For Each Row In IDInfoRows Do
				If ValueIsFilled(Row.RowRef) And Row.RowRef.Basis <> Source.Ref Then
					Row.NextStep = GetNextStep_SR(Source, RowItemList, Row);
				 	Continue;
				EndIf;
				FillRowID(Source, Row, RowItemList);
				Row.NextStep = GetNextStep_SR(Source, RowItemList, Row);
			EndDo;
		EndIf;
	EndDo;
EndProcedure

Procedure FillRowID_SRO(Source)
	For Each RowItemList In Source.ItemList Do	
		Row = Undefined;
		IDInfoRows = Source.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		If IDInfoRows.Count() = 0 Then
			Row = Source.RowIDInfo.Add();
			FillRowID(Source, Row, RowItemList);
			Row.NextStep = GetNextStep_SRO(Source, RowItemList, Row);
		Else
			For Each Row In IDInfoRows Do
				If ValueIsFilled(Row.RowRef) And Row.RowRef.Basis <> Source.Ref Then
					Row.NextStep = GetNextStep_SRO(Source, RowItemList, Row);
				 	Continue;
				EndIf;
				FillRowID(Source, Row, RowItemList);
				Row.NextStep = GetNextStep_SRO(Source, RowItemList, Row);
			EndDo;
		EndIf;
	EndDo;
EndProcedure

#EndRegion

#Region GetNextStep

Function GetNextStep_SO(Source, RowItemList, Row)
	NextStep = Catalogs.MovementRules.EmptyRef();
	If RowItemList.ProcurementMethod = Enums.ProcurementMethods.Purchase Then
		NextStep = Catalogs.MovementRules.PO_PI;
	Else
		If RowItemList.ItemKey.Item.ItemType.Type = Enums.ItemTypes.Service Then
			NextStep = Catalogs.MovementRules.SI;
		Else
			NextStep = Catalogs.MovementRules.SI_SC;
		EndIf;
	EndIf;
	Return NextStep;
EndFunction	

Function GetNextStep_SI(Source, RowItemList, Row)
	NextStep = Catalogs.MovementRules.EmptyRef();
	If RowItemList.UseShipmentConfirmation
		And Not Source.ShipmentConfirmations.FindRows(New Structure("Key", RowItemList.Key)).Count() Then
			NextStep = Catalogs.MovementRules.SC;
	EndIf;
	Return NextStep;
EndFunction	

Function GetNextStep_SC(Source, ItemList, Row)
	NextStep = Catalogs.MovementRules.EmptyRef();
	If Source.TransactionType = Enums.ShipmentConfirmationTransactionTypes.Sales
		And Not ValueIsFilled(ItemList.SalesInvoice) Then
			NextStep = Catalogs.MovementRules.SI;
	ElsIf Source.TransactionType = Enums.ShipmentConfirmationTransactionTypes.ReturnToVendor
		And Not ValueIsFilled(ItemList.PurchaseReturn) Then
			NextStep = Catalogs.MovementRules.PR;
	EndIf;
	Return NextStep;
EndFunction	

Function GetNextStep_PO(Source, RowItemList, Row)
	NextStep = Catalogs.MovementRules.EmptyRef();
	If RowItemList.ItemKey.Item.ItemType.Type = Enums.ItemTypes.Service Then
		NextStep = Catalogs.MovementRules.PI;
	Else
		NextStep = Catalogs.MovementRules.PI_GR;
	EndIf;
	Return NextStep;
EndFunction	

Function GetNextStep_PI(Source, RowItemList, Row)
	NextStep = Catalogs.MovementRules.EmptyRef();
	If RowItemList.UseGoodsReceipt
		And Not Source.GoodsReceipts.FindRows(New Structure("Key", RowItemList.Key)).Count() Then
			NextStep = Catalogs.MovementRules.GR;
	EndIf;
	Return NextStep;
EndFunction	

Function GetNextStep_GR(Source, ItemList, Row)
	NextStep = Catalogs.MovementRules.EmptyRef();
	If Source.TransactionType = Enums.GoodsReceiptTransactionTypes.Purchase 
		And Not ValueIsFilled(ItemList.PurchaseInvoice) Then
			NextStep = Catalogs.MovementRules.PI;
	ElsIf Source.TransactionType = Enums.GoodsReceiptTransactionTypes.ReturnFromCustomer
		And Not ValueIsFilled(ItemList.SalesReturn) Then
			NextStep = Catalogs.MovementRules.SR;
	EndIf;
	Return NextStep;
EndFunction	

Function GetNextStep_ITO(Source, RowItemList, Row)
	NextStep = Catalogs.MovementRules.IT;
	Return NextStep;
EndFunction	

Function GetNextStep_IT(Source, RowItemList, Row)
	Return Undefined;
EndFunction	

Function GetNextStep_ISR(Source, RowItemList, Row)
	Return Catalogs.MovementRules.ITO_PO_PI;
EndFunction	

Function GetNextStep_PhysicalInventory(Source, RowItemList, Row)
	If RowItemList.Difference > 0 Then
		Return Catalogs.MovementRules.StockAdjustmentAsSurplus;
	EndIf;
	
	If RowItemList.Difference < 0 Then
		Return Catalogs.MovementRules.StockAdjustmentAsWriteOff;
	EndIf;
	Return Undefined;
EndFunction

Function GetNextStep_StockAdjustmentAsSurplus(Source, RowItemList, Row)
	Return Undefined;
EndFunction

Function GetNextStep_StockAdjustmentAsWriteOff(Source, RowItemList, Row)
	Return Undefined;
EndFunction

Function GetNextStep_PR(Source, RowItemList, Row)
	NextStep = Catalogs.MovementRules.EmptyRef();
	If RowItemList.UseShipmentConfirmation
		And Not Source.ShipmentConfirmations.FindRows(New Structure("Key", RowItemList.Key)).Count() Then
			NextStep = Catalogs.MovementRules.SC;
	EndIf;
	Return NextStep;
EndFunction	

Function GetNextStep_PRO(Source, RowItemList, Row)
	NextStep = Catalogs.MovementRules.PR;
	Return NextStep;
EndFunction

Function GetNextStep_SR(Source, RowItemList, Row)
	NextStep = Catalogs.MovementRules.EmptyRef();
	If RowItemList.UseGoodsReceipt
		And Not Source.GoodsReceipts.FindRows(New Structure("Key", RowItemList.Key)).Count() Then
			NextStep = Catalogs.MovementRules.GR;
	EndIf;
	Return NextStep;
EndFunction	

Function GetNextStep_SRO(Source, RowItemList, Row)
	NextStep = Catalogs.MovementRules.SR;
	Return NextStep;
EndFunction

#EndRegion

Procedure FillRowID(Source, Row, RowItemList)
	Row.Key      = RowItemList.Key;
	Row.RowID    = RowItemList.Key;
	If CommonFunctionsClientServer.ObjectHasProperty(RowItemList, "Difference") Then
		Row.Quantity = ?(RowItemList.Difference < 0, -RowItemList.Difference, RowItemList.Difference);
	Else
		Row.Quantity = RowItemList.QuantityInBaseUnit;
	EndIf;
	Row.RowRef = FindOrCreateRowIDRef(Source, Row, RowItemList);	
EndProcedure

Function FindOrCreateRowIDRef(Source, Row, RowItemList)
	Query = New Query;
	Query.Text =
		"SELECT
		|	RowIDs.Ref
		|FROM
		|	Catalog.RowIDs AS RowIDs
		|WHERE
		|	RowIDs.RowID = &RowID";
	
	Query.SetParameter("RowID", Row.RowID);
	QueryResult = Query.Execute().Select();
	
	If QueryResult.Next() Then
		RowRefObject = QueryResult.Ref.GetObject();
	Else
		RowRefObject = Catalogs.RowIDs.CreateItem();
	EndIf;
	UpdateRowIDCatalog(Source, Row, RowItemList, RowRefObject);
	Return RowRefObject.Ref;
EndFunction

Procedure UpdateRowIDCatalog(Source, Row, RowItemList, RowRefObject)
	FillPropertyValues(RowRefObject, Source);
	FillPropertyValues(RowRefObject, RowItemList);
	
	RowRefObject.RowID       = Row.RowID;
	RowRefObject.Description = Row.RowID;
	
	If Is(Source).ITO Or Is(Source).IT Then
		RowRefObject.TransactionTypeSC = Enums.ShipmentConfirmationTransactionTypes.InventoryTransfer;
		RowRefObject.TransactionTypeGR = Enums.GoodsReceiptTransactionTypes.InventoryTransfer;
	ElsIf Is(Source).SO Or Is(Source).SI Then
		RowRefObject.TransactionTypeSC = Enums.ShipmentConfirmationTransactionTypes.Sales;
	ElsIf Is(Source).PO Or Is(Source).PI Then
		RowRefObject.TransactionTypeGR = Enums.GoodsReceiptTransactionTypes.Purchase;
	ElsIf Is(Source).SC Then
		RowRefObject.TransactionTypeSC = Source.TransactionType;
	ElsIf Is(Source).GR Then
		RowRefObject.TransactionTypeGR = Source.TransactionType;
	EndIf;
	
	RowRefObject.Write();
EndProcedure

Function GetBalanceQuantity(Source, Row)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	T10000B_RowIDMovementsBalance.QuantityBalance
	|FROM
	|	AccumulationRegister.T10000B_RowIDMovements.Balance(&Period, RowID = &RowID
	|	AND Step = &Step
	|	AND Basis = &Basis
	|	AND RowRef = &RowRef) AS T10000B_RowIDMovementsBalance";
	Period = Undefined;
	If ValueIsFilled(Source.Ref) Then
		Period = New Boundary(Source.Ref.PointInTime(), BoundaryType.Excluding);
	EndIf;
	Query.SetParameter("Period" , Period);
	Query.SetParameter("RowID"  , Row.RowID);
	Query.SetParameter("Step"   , Row.CurrentStep);
	Query.SetParameter("Basis"  , Row.Basis);
	Query.SetParameter("RowRef" , Row.RowRef);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return QuerySelection.QuantityBalance;
	Else
		Return 0;
	EndIf;
EndFunction

#EndRegion

#Region ExtractData

Function ExtractData(BasisesTable, DataReceiver) Export
	
	Tables = CreateTablesForExtractData(BasisesTable.CopyColumns());
		
	For Each Row In BasisesTable Do
		If Is(Row.Basis).SO Then
			FillTablesFrom_SO(Tables, DataReceiver, Row);
		ElsIf Is(Row.Basis).SI Then
			FillTablesFrom_SI(Tables, DataReceiver, Row);
		ElsIf Is(Row.Basis).SC Then
			FillTablesFrom_SC(Tables, DataReceiver, Row);
		ElsIf Is(Row.Basis).PO Then
			FillTablesFrom_PO(Tables, DataReceiver, Row);
		ElsIf Is(Row.Basis).PI Then
			FillTablesFrom_PI(Tables, DataReceiver, Row);
		ElsIf Is(Row.Basis).GR Then
			FillTablesFrom_GR(Tables, DataReceiver, Row);
		ElsIf Is(Row.Basis).ITO Then
			FillTablesFrom_ITO(Tables, DataReceiver, Row);
		ElsIf Is(Row.Basis).IT Then
			FillTablesFrom_IT(Tables, DataReceiver, Row);
		ElsIf Is(Row.Basis).ISR Then
			FillTablesFrom_ISR(Tables, DataReceiver, Row);
		ElsIf Is(Row.Basis).PhysicalInventory Then
			FillTablesFrom_PhysicalInventory(Tables, DataReceiver, Row);
		EndIf;
	EndDo;
	
	Return ExtractDataByTables(Tables, DataReceiver);	
EndFunction

Function CreateTablesForExtractData(EmptyTable)
	Tables = New Structure();
	Tables.Insert("FromSO"                         , EmptyTable.Copy());
	Tables.Insert("FromSI"                         , EmptyTable.Copy());	
	Tables.Insert("FromSC"                         , EmptyTable.Copy());
	Tables.Insert("FromSC_ThenFromSO"              , EmptyTable.Copy());
	Tables.Insert("FromSC_ThenFromSI"              , EmptyTable.Copy());
	Tables.Insert("FromSC_ThenFromPIGR_ThenFromSO" , EmptyTable.Copy());
	Tables.Insert("FromPO"                         , EmptyTable.Copy());
	Tables.Insert("FromPI"                         , EmptyTable.Copy());
	Tables.Insert("FromGR"                         , EmptyTable.Copy());
	Tables.Insert("FromGR_ThenFromPO"              , EmptyTable.Copy());
	Tables.Insert("FromGR_ThenFromPI"              , EmptyTable.Copy());
	Tables.Insert("FromPIGR_ThenFromSO"            , EmptyTable.Copy());
	Tables.Insert("FromISR"                        , EmptyTable.Copy());
	Tables.Insert("FromITO"                        , EmptyTable.Copy());
	Tables.Insert("FromIT"                         , EmptyTable.Copy());
	Tables.Insert("FromPhysicalInventory"          , EmptyTable.Copy());
	Return Tables;
EndFunction

#Region FillTablesFrom

Procedure FillTablesFrom_SO(Tables, DataReceiver, RowBasisesTable)
	FillPropertyValues(Tables.FromSO.Add(), RowBasisesTable);
EndProcedure

Procedure FillTablesFrom_SI(Tables, DataReceiver, RowBasisesTable)
	FillPropertyValues(Tables.FromSI.Add(), RowBasisesTable);
EndProcedure

Procedure FillTablesFrom_SC(Tables, DataReceiver, RowBasisesTable)
	BasisesInfo = GetBasisesInfo(RowBasisesTable.Basis, RowBasisesTable.BasisKey, RowBasisesTable.RowID);
	If Is(BasisesInfo.ParentBasis).SO Then
		
		NewRow = Tables.FromSC_ThenFromSO.Add();
		FillPropertyValues(NewRow, RowBasisesTable);
		NewRow.ParentBasis = BasisesInfo.ParentBasis;
		
	ElsIf Is(BasisesInfo.ParentBasis).SI Then
		
		NewRow = Tables.FromSC_ThenFromSI.Add();
		FillPropertyValues(NewRow, RowBasisesTable);
		NewRow.ParentBasis = BasisesInfo.ParentBasis;
		
	ElsIf Is(BasisesInfo.RowRef.Basis).SO And (Is(BasisesInfo.ParentBasis).GR Or Is(BasisesInfo.ParentBasis).PI) Then	
				
		NewRow = Tables.FromSC_ThenFromPIGR_ThenFromSO.Add();
		FillPropertyValues(NewRow, RowBasisesTable);
		NewRow.ParentBasis = BasisesInfo.ParentBasis;
						
	Else
		FillPropertyValues(Tables.FromSC.Add(), RowBasisesTable);
	EndIf;		
EndProcedure
	
Procedure FillTablesFrom_PO(Tables, DataReceiver, RowBasisesTable)
	FillPropertyValues(Tables.FromPO.Add(), RowBasisesTable);
EndProcedure

Procedure FillTablesFrom_PI(Tables, DataReceiver, RowBasisesTable)
	If Is(RowBasisesTable.RowRef.Basis).SO And (Is(DataReceiver).SI Or Is(DataReceiver).SC) Then
		
		NewRow = Tables.FromPIGR_ThenFromSO.Add();
		FillPropertyValues(NewRow, RowBasisesTable);
		NewRow.ParentBasis = RowBasisesTable.RowRef.Basis;
		
	Else
		FillPropertyValues(Tables.FromPI.Add(), RowBasisesTable);
	EndIf;	
EndProcedure

Procedure FillTablesFrom_GR(Tables, DataReceiver, RowBasisesTable)
	If Is(RowBasisesTable.RowRef.Basis).SO And (Is(DataReceiver).SI Or Is(DataReceiver).SC) Then
		
		NewRow = Tables.FromPIGR_ThenFromSO.Add();
		FillPropertyValues(NewRow, RowBasisesTable);
		NewRow.ParentBasis = RowBasisesTable.RowRef.Basis;
		
	Else
		BasisesInfo = GetBasisesInfo(RowBasisesTable.Basis, RowBasisesTable.BasisKey, RowBasisesTable.RowID);
		If Is(BasisesInfo.ParentBasis).PO Then
			
			NewRow = Tables.FromGR_ThenFromPO.Add();
			FillPropertyValues(NewRow, RowBasisesTable);
			NewRow.ParentBasis = BasisesInfo.ParentBasis;
			
		ElsIf Is(BasisesInfo.ParentBasis).PI Then
			
			NewRow = Tables.FromGR_ThenFromPI.Add();
			FillPropertyValues(NewRow, RowBasisesTable);
			NewRow.ParentBasis = BasisesInfo.ParentBasis;
							
		Else
			FillPropertyValues(Tables.FromGR.Add(), RowBasisesTable);
		EndIf;
	EndIf;
EndProcedure

Procedure FillTablesFrom_ITO(Tables, DataReceiver, RowBasisesTable)
	FillPropertyValues(Tables.FromITO.Add(), RowBasisesTable);
EndProcedure

Procedure FillTablesFrom_IT(Tables, DataReceiver, RowBasisesTable)
	FillPropertyValues(Tables.FromIT.Add(), RowBasisesTable);
EndProcedure

Procedure FillTablesFrom_ISR(Tables, DataReceiver, RowBasisesTable)
	FillPropertyValues(Tables.FromISR.Add(), RowBasisesTable);
EndProcedure

Procedure FillTablesFrom_PhysicalInventory(Tables, DataReceiver, RowBasisesTable)
	FillPropertyValues(Tables.FromPhysicalInventory.Add(), RowBasisesTable);
EndProcedure

#EndRegion

#Region ExtractDataFrom

Function ExtractDataByTables(Tables, DataReceiver)
	ExtractedData = New Array();
	
	If Tables.FromSO.Count() Then
		ExtractedData.Add(ExtractData_FromSO(Tables.FromSO, DataReceiver));
	EndIf;
	
	If Tables.FromSI.Count() Then
		ExtractedData.Add(ExtractData_FromSI(Tables.FromSI, DataReceiver));
	EndIf;
	
	If Tables.FromSC.Count() Then
		ExtractedData.Add(ExtractData_FromSC(Tables.FromSC, DataReceiver));
	EndIf;
	
	If Tables.FromSC_ThenFromSO.Count() Then
		ExtractedData.Add(ExtractData_FromSC_ThenFromSO(Tables.FromSC_ThenFromSO, DataReceiver));
	EndIf;
	
	If Tables.FromPIGR_ThenFromSO.Count() Then
		ExtractedData.Add(ExtractData_FromPIGR_ThenFromSO(Tables.FromPIGR_ThenFromSO, DataReceiver));
	EndIf;
	
	If Tables.FromSC_ThenFromPIGR_ThenFromSO.Count() Then
		ExtractedData.Add(ExtractData_FromSC_ThenFromPIGR_ThenFromSO(Tables.FromSC_ThenFromPIGR_ThenFromSO, DataReceiver));
	EndIf;
	
	If Tables.FromSC_ThenFromSI.Count() Then
		ExtractedData.Add(ExtractData_FromSC_ThenFromSI(Tables.FromSC_ThenFromSI, DataReceiver));
	EndIf;
	
	If Tables.FromPO.Count() Then
		ExtractedData.Add(ExtractData_FromPO(Tables.FromPO, DataReceiver));
	EndIf;
	
	If Tables.FromPI.Count() Then
		ExtractedData.Add(ExtractData_FromPI(Tables.FromPI, DataReceiver));
	EndIf;
	
	If Tables.FromGR.Count() Then
		ExtractedData.Add(ExtractData_FromGR(Tables.FromGR, DataReceiver));
	EndIf;
	
	If Tables.FromGR_ThenFromPO.Count() Then
		ExtractedData.Add(ExtractData_FromGR_ThenFromPO(Tables.FromGR_ThenFromPO, DataReceiver));
	EndIf;
	
	If Tables.FromGR_ThenFromPI.Count() Then
		ExtractedData.Add(ExtractData_FromGR_ThenFromPI(Tables.FromGR_ThenFromPI, DataReceiver));
	EndIf;
	
	If Tables.FromITO.Count() Then
		ExtractedData.Add(ExtractData_FromITO(Tables.FromITO, DataReceiver));
	EndIf;
	
	If Tables.FromIT.Count() Then
		ExtractedData.Add(ExtractData_FromIT(Tables.FromIT, DataReceiver));
	EndIf;
	
	If Tables.FromISR.Count() Then
		ExtractedData.Add(ExtractData_FromISR(Tables.FromISR, DataReceiver));
	EndIf;
	
	If Tables.FromPhysicalInventory.Count() Then
		ExtractedData.Add(ExtractData_FromPhysicalInventory(Tables.FromPhysicalInventory, DataReceiver));
	EndIf;
	
	Return ExtractedData;
EndFunction

Function GetQueryText_BasisesTable()
	Return
		"SELECT
		|	BasisesTable.Key,
		|	BasisesTable.BasisKey,
		|	BasisesTable.RowID,
		|	BasisesTable.CurrentStep,
		|	BasisesTable.RowRef,
		|	BasisesTable.Basis,
		|	BasisesTable.ParentBasis,
		|	BasisesTable.Unit,
		|	BasisesTable.BasisUnit,
		|	BasisesTable.QuantityInBaseUnit
		|INTO BasisesTable
		|FROM
		|	&BasisesTable AS BasisesTable
		|; 
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT DISTINCT
		|	UNDEFINED AS Ref,
		|	BasisesTable.Key AS Key,
		|	BasisesTable.BasisKey,
		|	BasisesTable.RowID,
		|	BasisesTable.CurrentStep,
		|	BasisesTable.RowRef,
		|	BasisesTable.Basis,
		|	BasisesTable.QuantityInBaseUnit AS Quantity
		|FROM
		|	BasisesTable AS BasisesTable
		|; ";
EndFunction

Function ExtractData_FromSO(BasisesTable, DataReceiver)
	Query = New Query(GetQueryText_BasisesTable());
	Query.Text = Query.Text +
		"SELECT ALLOWED
		|	""SalesOrder"" AS BasedOn,
		|	UNDEFINED AS Ref,
		|	ItemList.Ref AS SalesOrder,
		|	ItemList.Ref AS ShipmentBasis,
		|	ItemList.Ref AS PurchaseBasis,
		|	ItemList.Ref.Partner AS Partner,
		|	ItemList.Ref.LegalName AS LegalName,
		|	ItemList.Ref.PriceIncludeTax AS PriceIncludeTax,
		|	ItemList.Ref.Agreement AS Agreement,
		|	ItemList.Ref.ManagerSegment AS ManagerSegment,
		|	ItemList.Ref.Currency AS Currency,
		|	ItemList.Ref.Company AS Company,
		|	ItemList.ItemKey AS ItemKey,
		|	ItemList.ItemKey.Item AS Item,
		|	ItemList.Store AS Store,
		|	ItemList.PriceType AS PriceType,
		|	ItemList.DeliveryDate AS DeliveryDate,
		|	ItemList.DontCalculateRow AS DontCalculateRow,
		|	ItemList.BusinessUnit AS BusinessUnit,
		|	ItemList.RevenueType AS RevenueType,
		|	ItemList.Detail AS Detail,
		|	ItemList.Store.UseShipmentConfirmation 
		|	AND NOT ItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service) 
		|	AS UseShipmentConfirmation,
		|	ItemList.Store.UseGoodsReceipt 
		|	AND NOT ItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service) 
		|	AS UseGoodsReceipt,
		|	VALUE(Enum.ShipmentConfirmationTransactionTypes.Sales) AS TransactionType,
		|	0 AS Quantity,
		|	ISNULL(ItemList.QuantityInBaseUnit, 0) AS OriginalQuantity,
		|	ISNULL(ItemList.Price, 0) AS Price,
		|	ISNULL(ItemList.TaxAmount, 0) AS TaxAmount,
		|	ISNULL(ItemList.TotalAmount, 0) AS TotalAmount,
		|	ISNULL(ItemList.NetAmount, 0) AS NetAmount,
		|	ISNULL(ItemList.OffersAmount, 0) AS OffersAmount,
		|	ItemList.LineNumber AS LineNumber,
		|	ItemList.Key AS SalesOrderItemListKey,
		|	BasisesTable.Key,
		|	BasisesTable.Unit AS Unit,
		|	BasisesTable.BasisUnit AS BasisUnit,
		|	BasisesTable.QuantityInBaseUnit AS QuantityInBaseUnit
		|FROM
		|	BasisesTable AS BasisesTable
		|		LEFT JOIN Document.SalesOrder.ItemList AS ItemList
		|		ON BasisesTable.Basis = ItemList.Ref
		|		AND BasisesTable.BasisKey = ItemList.Key
		|ORDER BY
		|	LineNumber
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT DISTINCT
		|	UNDEFINED AS Ref,
		|	BasisesTable.Key,
		|	TaxList.Tax,
		|	TaxList.Analytics,
		|	TaxList.TaxRate,
		|	TaxList.Amount,
		|	TaxList.IncludeToTotalAmount,
		|	TaxList.ManualAmount
		|FROM
		|	Document.SalesOrder.TaxList AS TaxList
		|		INNER JOIN BasisesTable AS BasisesTable
		|		ON BasisesTable.BasisKey = TaxList.Key
		|		AND BasisesTable.Basis = TaxList.Ref
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT DISTINCT
		|	UNDEFINED AS Ref,
		|	BasisesTable.Key,
		|	SpecialOffers.Offer,
		|	SpecialOffers.Amount,
		|	SpecialOffers.Percent
		|FROM
		|	Document.SalesOrder.SpecialOffers AS SpecialOffers
		|		INNER JOIN BasisesTable AS BasisesTable
		|		ON BasisesTable.Basis = SpecialOffers.Ref
		|		AND BasisesTable.BasisKey = SpecialOffers.Key";

	
	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();
	
	TableRowIDInfo     = QueryResults[1].Unload();
	TableItemList      = QueryResults[2].Unload();	
	TableTaxList       = QueryResults[3].Unload();
	TableSpecialOffers = QueryResults[4].Unload();
		
	Tables = New Structure();
	Tables.Insert("RowIDInfo"     , TableRowIDInfo);
	Tables.Insert("ItemList"      , TableItemList);
	Tables.Insert("TaxList"       , TableTaxList);
	Tables.Insert("SpecialOffers" , TableSpecialOffers);
	
	AddTables(Tables);
	
	RecalculateAmounts(Tables);
	
	Return ReduseExtractedDataInfo_SO(Tables, DataReceiver);
EndFunction

Function ExtractData_FromSI(BasisesTable, DataReceiver)
	Query = New Query(GetQueryText_BasisesTable());
	Query.Text = Query.Text +
		"SELECT ALLOWED
		|	""SalesInvoice"" AS BasedOn,
		|	UNDEFINED AS Ref,
		|	ItemList.Ref AS SalesInvoice,
		|	ItemList.Ref AS ShipmentBasis,
		|	ItemList.SalesOrder AS SalesOrder,
		|	ItemList.Ref.Partner AS Partner,
		|	ItemList.Ref.LegalName AS LegalName,
		|	ItemList.Ref.PriceIncludeTax AS PriceIncludeTax,
		|	ItemList.Ref.Agreement AS Agreement,
		|	ItemList.Ref.ManagerSegment AS ManagerSegment,
		|	ItemList.Ref.Currency AS Currency,
		|	ItemList.Ref.Company AS Company,
		|	ItemList.ItemKey AS ItemKey,
		|	ItemList.ItemKey.Item AS Item,
		|	ItemList.Store AS Store,
		|	ItemList.PriceType AS PriceType,
		|	ItemList.DeliveryDate AS DeliveryDate,
		|	ItemList.DontCalculateRow AS DontCalculateRow,
		|	ItemList.BusinessUnit AS BusinessUnit,
		|	ItemList.RevenueType AS RevenueType,
		|	ItemList.Detail AS Detail,
		|	ItemList.Store.UseShipmentConfirmation
		|	AND NOT ItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service) AS UseShipmentConfirmation,
		|	VALUE(Enum.ShipmentConfirmationTransactionTypes.Sales) AS TransactionType,
		|	0 AS Quantity,
		|	ISNULL(ItemList.QuantityInBaseUnit, 0) AS OriginalQuantity,
		|	ISNULL(ItemList.Price, 0) AS Price,
		|	ISNULL(ItemList.TaxAmount, 0) AS TaxAmount,
		|	ISNULL(ItemList.TotalAmount, 0) AS TotalAmount,
		|	ISNULL(ItemList.NetAmount, 0) AS NetAmount,
		|	ISNULL(ItemList.OffersAmount, 0) AS OffersAmount,
		|	ItemList.LineNumber AS LineNumber,
		|	ItemList.Key AS SalesInvoiceItemListKey,
		|	BasisesTable.Key,
		|	BasisesTable.Unit AS Unit,
		|	BasisesTable.BasisUnit AS BasisUnit,
		|	BasisesTable.QuantityInBaseUnit AS QuantityInBaseUnit
		|FROM
		|	BasisesTable AS BasisesTable
		|		LEFT JOIN Document.SalesInvoice.ItemList AS ItemList
		|		ON BasisesTable.Basis = ItemList.Ref
		|		AND BasisesTable.BasisKey = ItemList.Key
		|ORDER BY
		|	ItemList.LineNumber
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT DISTINCT
		|	UNDEFINED AS Ref,
		|	BasisesTable.Key,
		|	TaxList.Tax,
		|	TaxList.Analytics,
		|	TaxList.TaxRate,
		|	TaxList.Amount,
		|	TaxList.IncludeToTotalAmount,
		|	TaxList.ManualAmount
		|FROM
		|	Document.SalesInvoice.TaxList AS TaxList
		|		INNER JOIN BasisesTable AS BasisesTable
		|		ON BasisesTable.BasisKey = TaxList.Key
		|		AND BasisesTable.Basis = TaxList.Ref
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT DISTINCT
		|	UNDEFINED AS Ref,
		|	BasisesTable.Key,
		|	SpecialOffers.Offer,
		|	SpecialOffers.Amount,
		|	SpecialOffers.Percent
		|FROM
		|	Document.SalesInvoice.SpecialOffers AS SpecialOffers
		|		INNER JOIN BasisesTable AS BasisesTable
		|		ON BasisesTable.Basis = SpecialOffers.Ref
		|		AND BasisesTable.BasisKey = SpecialOffers.Key";
		
	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();
	
	TableRowIDInfo     = QueryResults[1].Unload();
	TableItemList      = QueryResults[2].Unload();	
	TableTaxList       = QueryResults[3].Unload();
	TableSpecialOffers = QueryResults[4].Unload();
		
	Tables = New Structure();
	Tables.Insert("ItemList"      , TableItemList);
	Tables.Insert("RowIDInfo"     , TableRowIDInfo);
	Tables.Insert("TaxList"       , TableTaxList);
	Tables.Insert("SpecialOffers" , TableSpecialOffers);
	
	AddTables(Tables);
	
	RecalculateAmounts(Tables);
		
	Return Tables;
EndFunction

Function ExtractData_FromSC(BasisesTable, DataReceiver)
	Query = New Query(GetQueryText_BasisesTable());
	Query.Text = Query.Text +
		"SELECT ALLOWED
		|	""ShipmentConfirmation"" AS BasedOn,
		|	UNDEFINED AS Ref,
		|	ItemList.Ref.Company AS Company,
		|	ItemList.Ref.Partner AS Partner,
		|	ItemList.Ref.LegalName AS LegalName,
		|	ItemList.Store AS Store,
		|	ItemList.ItemKey.Item AS Item,
		|	ItemList.ItemKey AS ItemKey,
		|	TRUE AS UseShipmentConfirmation,
		|	0 AS Quantity,
		|	BasisesTable.Key,
		|	BasisesTable.Unit AS Unit,
		|	BasisesTable.BasisUnit AS BasisUnit,
		|	BasisesTable.QuantityInBaseUnit AS QuantityInBaseUnit
		|FROM
		|	BasisesTable AS BasisesTable
		|		LEFT JOIN Document.ShipmentConfirmation.ItemList AS ItemList
		|		ON BasisesTable.Basis = ItemList.Ref
		|		AND BasisesTable.BasisKey = ItemList.Key
		|ORDER BY
		|	ItemList.LineNumber
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT DISTINCT
		|	UNDEFINED AS Ref,
		|	ItemList.Store AS Store,
		|	ItemList.ItemKey.Item AS Item,
		|	ItemList.ItemKey AS ItemKey,
		|	BasisesTable.Unit AS Unit,
		|	BasisesTable.Key,
		|	BasisesTable.BasisKey,
		|	BasisesTable.Basis AS ShipmentConfirmation,
		|	BasisesTable.QuantityInBaseUnit AS Quantity,
		|	BasisesTable.QuantityInBaseUnit AS QuantityInShipmentConfirmation
		|FROM
		|	BasisesTable AS BasisesTable
		|		LEFT JOIN Document.ShipmentConfirmation.ItemList AS ItemList
		|		ON BasisesTable.Basis = ItemList.Ref
		|		AND BasisesTable.BasisKey = ItemList.Key";
			
	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();
	
	TableRowIDInfo             = QueryResults[1].Unload();
	TableItemList              = QueryResults[2].Unload();
	TableShipmentConfirmations = QueryResults[3].Unload();
	
	For Each RowItemList In TableItemList Do
		RowItemList.Quantity = Catalogs.Units.Convert(RowItemList.BasisUnit, RowItemList.Unit, RowItemList.QuantityInBaseUnit);
	EndDo;
		
	Tables = New Structure();
	Tables.Insert("ItemList"              , TableItemList);
	Tables.Insert("RowIDInfo"             , TableRowIDInfo);
	Tables.Insert("ShipmentConfirmations" , TableShipmentConfirmations);
	
	AddTables(Tables);
	
	Return CollapseRepeatingItemListRows(Tables, "Item, ItemKey, Store, Unit");
EndFunction

Function ExtractData_FromSC_ThenFromSO(BasisesTable, DataReceiver)
	Query = New Query(GetQueryText_BasisesTable());
	Query.Text = Query.Text +
		"SELECT DISTINCT ALLOWED
		|	BasisesTable.Key,
		|	RowIDInfo.BasisKey AS BasisKey,
		|	BasisesTable.RowID,
		|	BasisesTable.CurrentStep,
		|	BasisesTable.RowRef,
		|	VALUE(Document.SalesOrder.EmptyRef) AS ParentBasis,
		|	BasisesTable.ParentBasis AS Basis,
		|	BasisesTable.Unit,
		|	BasisesTable.BasisUnit,
		|	BasisesTable.QuantityInBaseUnit
		|FROM
		|	BasisesTable AS BasisesTable
		|		LEFT JOIN Document.ShipmentConfirmation.RowIDInfo AS RowIDInfo
		|		ON BasisesTable.Basis = RowIDInfo.Ref
		|		AND BasisesTable.BasisKey = RowIDInfo.Key
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT DISTINCT
		|	UNDEFINED AS Ref,
		|	ItemList.Store AS Store,
		|	ItemList.ItemKey.Item AS Item,
		|	ItemList.ItemKey AS ItemKey,
		|	BasisesTable.Unit AS Unit,
		|	BasisesTable.Key,
		|	BasisesTable.BasisKey,
		|	BasisesTable.Basis AS ShipmentConfirmation,
		|	BasisesTable.QuantityInBaseUnit AS Quantity,
		|	BasisesTable.QuantityInBaseUnit AS QuantityInShipmentConfirmation
		|FROM
		|	BasisesTable AS BasisesTable
		|		LEFT JOIN Document.ShipmentConfirmation.ItemList AS ItemList
		|		ON BasisesTable.Basis = ItemList.Ref
		|		AND BasisesTable.BasisKey = ItemList.Key";
	
	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();
	
	TablesSO = ExtractData_FromSO(QueryResults[2].Unload(), DataReceiver);
	TablesSO.ItemList.FillValues(True, "UseShipmentConfirmation");
	
	TableRowIDInfo             = QueryResults[1].Unload(); 
	TableShipmentConfirmations = QueryResults[3].Unload();
	
	Tables = New Structure();
	Tables.Insert("ItemList"              , TablesSO.ItemList);
	Tables.Insert("RowIDInfo"             , TableRowIDInfo);
	Tables.Insert("TaxList"               , TablesSO.TaxList);
	Tables.Insert("SpecialOffers"         , TablesSO.SpecialOffers);
	Tables.Insert("ShipmentConfirmations" , TableShipmentConfirmations);
	
	AddTables(Tables);
	
	Return CollapseRepeatingItemListRows(Tables, "SalesOrderItemListKey");
EndFunction

Function ExtractData_FromSC_ThenFromSI(BasisesTable, DataReceiver)
	Query = New Query(GetQueryText_BasisesTable());
	Query.Text = Query.Text + 
		"SELECT DISTINCT ALLOWED
		|	BasisesTable.Key,
		|	RowIDInfo.BasisKey AS BasisKey,
		|	BasisesTable.RowID,
		|	BasisesTable.CurrentStep,
		|	BasisesTable.RowRef,
		|	VALUE(Document.SalesInvoice.EmptyRef) AS ParentBasis,
		|	BasisesTable.ParentBasis AS Basis,
		|	BasisesTable.Unit,
		|	BasisesTable.BasisUnit,
		|	BasisesTable.QuantityInBaseUnit
		|FROM
		|	BasisesTable AS BasisesTable
		|		LEFT JOIN Document.ShipmentConfirmation.RowIDInfo AS RowIDInfo
		|		ON BasisesTable.Basis = RowIDInfo.Ref
		|		AND BasisesTable.BasisKey = RowIDInfo.Key
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT DISTINCT
		|	UNDEFINED AS Ref,
		|	ItemList.Store AS Store,
		|	ItemList.ItemKey.Item AS Item,
		|	ItemList.ItemKey AS ItemKey,
		|	BasisesTable.Unit AS Unit,
		|	BasisesTable.Key,
		|	BasisesTable.BasisKey,
		|	BasisesTable.Basis AS ShipmentConfirmation,
		|	BasisesTable.QuantityInBaseUnit AS Quantity,
		|	BasisesTable.QuantityInBaseUnit AS QuantityInShipmentConfirmation
		|FROM
		|	BasisesTable AS BasisesTable
		|		LEFT JOIN Document.ShipmentConfirmation.ItemList AS ItemList
		|		ON BasisesTable.Basis = ItemList.Ref
		|		AND BasisesTable.BasisKey = ItemList.Key";
	
	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();
	
	TablesSI = ExtractData_FromSI(QueryResults[2].Unload(), DataReceiver);
	TablesSI.ItemList.FillValues(True, "UseShipmentConfirmation");
	
	TableRowIDInfo             = QueryResults[1].Unload(); 
	TableShipmentConfirmations = QueryResults[3].Unload();
	
	Tables = New Structure();
	Tables.Insert("ItemList"              , TablesSI.ItemList);
	Tables.Insert("RowIDInfo"             , TableRowIDInfo);
	Tables.Insert("TaxList"               , TablesSI.TaxList);
	Tables.Insert("SpecialOffers"         , TablesSI.SpecialOffers);
	Tables.Insert("ShipmentConfirmations" , TableShipmentConfirmations);
	
	AddTables(Tables);
	
	Return CollapseRepeatingItemListRows(Tables, "SalesInvoiceItemListKey");
EndFunction

Function ExtractData_FromSC_ThenFromPIGR_ThenFromSO(BasisesTable, DataReceiver)
	Query = New Query(GetQueryText_BasisesTable());
	Query.Text = Query.Text +
		"SELECT DISTINCT ALLOWED
		|	BasisesTable.Key,
		|	RowIDInfo.BasisKey AS BasisKey,
		|	BasisesTable.RowID,
		|	BasisesTable.CurrentStep,
		|	BasisesTable.RowRef,
		|	BasisesTable.RowRef.Basis AS ParentBasis,
		|	BasisesTable.ParentBasis AS Basis,
		|	BasisesTable.Unit,
		|	BasisesTable.BasisUnit,
		|	BasisesTable.QuantityInBaseUnit
		|FROM
		|	BasisesTable AS BasisesTable
		|		LEFT JOIN Document.ShipmentConfirmation.RowIDInfo AS RowIDInfo
		|		ON BasisesTable.Basis = RowIDInfo.Ref
		|		AND BasisesTable.BasisKey = RowIDInfo.Key
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT DISTINCT
		|	UNDEFINED AS Ref,
		|	ItemList.Store AS Store,
		|	ItemList.ItemKey.Item AS Item,
		|	ItemList.ItemKey AS ItemKey,
		|	BasisesTable.Unit AS Unit,
		|	BasisesTable.Key,
		|	BasisesTable.BasisKey,
		|	BasisesTable.Basis AS ShipmentConfirmation,
		|	BasisesTable.QuantityInBaseUnit AS Quantity,
		|	BasisesTable.QuantityInBaseUnit AS QuantityInShipmentConfirmation
		|FROM
		|	BasisesTable AS BasisesTable
		|		LEFT JOIN Document.ShipmentConfirmation.ItemList AS ItemList
		|		ON BasisesTable.Basis = ItemList.Ref
		|		AND BasisesTable.BasisKey = ItemList.Key";
	
	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();
	
	TablesPIGRSO = ExtractData_FromPIGR_ThenFromSO(QueryResults[2].Unload(), DataReceiver);
	TablesPIGRSO.ItemList.FillValues(True, "UseShipmentConfirmation");
	
	TableRowIDInfo             = QueryResults[1].Unload(); 
	TableShipmentConfirmations = QueryResults[3].Unload();
	
	Tables = New Structure();
	Tables.Insert("ItemList"              , TablesPIGRSO.ItemList);
	Tables.Insert("RowIDInfo"             , TableRowIDInfo);
	Tables.Insert("TaxList"               , TablesPIGRSO.TaxList);
	Tables.Insert("SpecialOffers"         , TablesPIGRSO.SpecialOffers);
	Tables.Insert("ShipmentConfirmations" , TableShipmentConfirmations);
	
	AddTables(Tables);
	
	Return CollapseRepeatingItemListRows(Tables, "SalesOrderItemListKey");
EndFunction

Function ExtractData_FromPIGR_ThenFromSO(BasisesTable, DataReceiver)
	Query = New Query(GetQueryText_BasisesTable());
	Query.Text = Query.Text +
		"SELECT DISTINCT ALLOWED
		|	BasisesTable.Key,
		|	BasisesTable.RowID AS BasisKey,
		|	BasisesTable.RowID,
		|	BasisesTable.CurrentStep,
		|	BasisesTable.RowRef,
		|	VALUE(Document.SalesOrder.EmptyRef) AS ParentBasis,
		|	BasisesTable.ParentBasis AS Basis,
		|	BasisesTable.Unit,
		|	BasisesTable.BasisUnit,
		|	BasisesTable.QuantityInBaseUnit
		|FROM
		|	BasisesTable AS BasisesTable";
	
	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();
	
	TablesSO = ExtractData_FromSO(QueryResults[2].Unload(), DataReceiver);
	
	TableRowIDInfo = QueryResults[1].Unload(); 
	
	Tables = New Structure();
	Tables.Insert("ItemList"      , TablesSO.ItemList);
	Tables.Insert("RowIDInfo"     , TableRowIDInfo);
	Tables.Insert("TaxList"       , TablesSO.TaxList);
	Tables.Insert("SpecialOffers" , TablesSO.SpecialOffers);
	
	AddTables(Tables);
	
	Return CollapseRepeatingItemListRows(Tables, "SalesOrderItemListKey");
EndFunction

Function ExtractData_FromPO(BasisesTable, DataReceiver)
	Query = New Query(GetQueryText_BasisesTable());
	Query.Text = Query.Text +
		"SELECT ALLOWED
		|	""PurchaseOrder"" AS BasedOn,
		|	UNDEFINED AS Ref,
		|	ItemList.Ref AS PurchaseOrder,
		|	ItemList.Ref AS ReceiptBasis,
		|	ItemList.SalesOrder AS SalesOrder,
		|	ItemList.Ref.Partner AS Partner,
		|	ItemList.Ref.LegalName AS LegalName,
		|	ItemList.Ref.PriceIncludeTax AS PriceIncludeTax,
		|	ItemList.Ref.Agreement AS Agreement,
		|	ItemList.Ref.Currency AS Currency,
		|	ItemList.Ref.Company AS Company,
		|	ItemList.ItemKey AS ItemKey,
		|	ItemList.ItemKey.Item AS Item,
		|	ItemList.Store AS Store,
		|	ItemList.PriceType AS PriceType,
		|	ItemList.DeliveryDate AS DeliveryDate,
		|	ItemList.DontCalculateRow AS DontCalculateRow,
		|	ItemList.BusinessUnit AS BusinessUnit,
		|	ItemList.ExpenseType AS ExpenseType,
		|	ItemList.Detail AS Detail,
		|	ItemList.Store.UseGoodsReceipt 
		|	AND NOT ItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service) 
		|	AS UseGoodsReceipt,
		|	VALUE(Enum.GoodsReceiptTransactionTypes.Purchase) AS TransactionType,
		|	0 AS Quantity,
		|	ISNULL(ItemList.QuantityInBaseUnit, 0) AS OriginalQuantity,
		|	ISNULL(ItemList.Price, 0) AS Price,
		|	ISNULL(ItemList.TaxAmount, 0) AS TaxAmount,
		|	ISNULL(ItemList.TotalAmount, 0) AS TotalAmount,
		|	ISNULL(ItemList.NetAmount, 0) AS NetAmount,
		|	ISNULL(ItemList.OffersAmount, 0) AS OffersAmount,
		|	ItemList.LineNumber AS LineNumber,
		|	ItemList.Key AS PurchaseOrderItemListKey,
		|	BasisesTable.Key,
		|	BasisesTable.Unit AS Unit,
		|	BasisesTable.BasisUnit AS BasisUnit,
		|	BasisesTable.QuantityInBaseUnit AS QuantityInBaseUnit
		|FROM
		|	BasisesTable AS BasisesTable
		|		LEFT JOIN Document.PurchaseOrder.ItemList AS ItemList
		|		ON BasisesTable.Basis = ItemList.Ref
		|		AND BasisesTable.BasisKey = ItemList.Key
		|ORDER BY
		|	LineNumber
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT DISTINCT
		|	UNDEFINED AS Ref,
		|	BasisesTable.Key,
		|	TaxList.Tax,
		|	TaxList.Analytics,
		|	TaxList.TaxRate,
		|	TaxList.Amount,
		|	TaxList.IncludeToTotalAmount,
		|	TaxList.ManualAmount
		|FROM
		|	Document.PurchaseOrder.TaxList AS TaxList
		|		INNER JOIN BasisesTable AS BasisesTable
		|		ON BasisesTable.BasisKey = TaxList.Key
		|		AND BasisesTable.Basis = TaxList.Ref
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT DISTINCT
		|	UNDEFINED AS Ref,
		|	BasisesTable.Key,
		|	SpecialOffers.Offer,
		|	SpecialOffers.Amount,
		|	SpecialOffers.Percent
		|FROM
		|	Document.PurchaseOrder.SpecialOffers AS SpecialOffers
		|		INNER JOIN BasisesTable AS BasisesTable
		|		ON BasisesTable.Basis = SpecialOffers.Ref
		|		AND BasisesTable.BasisKey = SpecialOffers.Key";

	
	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();
	
	TableRowIDInfo     = QueryResults[1].Unload();
	TableItemList      = QueryResults[2].Unload();
	TableTaxList       = QueryResults[3].Unload();
	TableSpecialOffers = QueryResults[4].Unload();
		
	Tables = New Structure();
	Tables.Insert("ItemList"      , TableItemList);
	Tables.Insert("RowIDInfo"     , TableRowIDInfo);
	Tables.Insert("TaxList"       , TableTaxList);
	Tables.Insert("SpecialOffers" , TableSpecialOffers);
	
	AddTables(Tables);
	
	RecalculateAmounts(Tables);
	
	Return Tables;
EndFunction

Function ExtractData_FromPI(BasisesTable, DataReceiver)
	Query = New Query(GetQueryText_BasisesTable());
	Query.Text = Query.Text + 
		"SELECT ALLOWED
		|	""PurchaseInvoice"" AS BasedOn,
		|	UNDEFINED AS Ref,
		|	ItemList.Ref AS ReceiptBasis,
		|	ItemList.Ref AS PurchaseInvoice,
		|	ItemList.PurchaseOrder AS PurchaseOrder,
		|	ItemList.SalesOrder AS SalesOrder,
		|	ItemList.Ref.Partner AS Partner,
		|	ItemList.Ref.LegalName AS LegalName,
		|	ItemList.Ref.PriceIncludeTax AS PriceIncludeTax,
		|	ItemList.Ref.Agreement AS Agreement,
		|	ItemList.Ref.Currency AS Currency,
		|	ItemList.Ref.Company AS Company,
		|	ItemList.ItemKey AS ItemKey,
		|	ItemList.ItemKey.Item AS Item,
		|	ItemList.Store AS Store,
		|	ItemList.PriceType AS PriceType,
		|	ItemList.DeliveryDate AS DeliveryDate,
		|	ItemList.DontCalculateRow AS DontCalculateRow,
		|	ItemList.BusinessUnit AS BusinessUnit,
		|	ItemList.ExpenseType AS ExpenseType,
		|	ItemList.Detail AS Detail,
		|	ItemList.Store.UseGoodsReceipt
		|	AND NOT ItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service) AS UseGoodsReceipt,
		|	VALUE(Enum.GoodsReceiptTransactionTypes.Purchase) AS TransactionType,
		|	0 AS Quantity,
		|	ISNULL(ItemList.QuantityInBaseUnit, 0) AS OriginalQuantity,
		|	ISNULL(ItemList.Price, 0) AS Price,
		|	ISNULL(ItemList.TaxAmount, 0) AS TaxAmount,
		|	ISNULL(ItemList.TotalAmount, 0) AS TotalAmount,
		|	ISNULL(ItemList.NetAmount, 0) AS NetAmount,
		|	ISNULL(ItemList.OffersAmount, 0) AS OffersAmount,
		|	ItemList.LineNumber AS LineNumber,
		|	ItemList.Key AS PurchaseInvoiceItemListKey,
		|	BasisesTable.Key,
		|	BasisesTable.Unit AS Unit,
		|	BasisesTable.BasisUnit AS BasisUnit,
		|	BasisesTable.QuantityInBaseUnit AS QuantityInBaseUnit
		|FROM
		|	BasisesTable AS BasisesTable
		|		LEFT JOIN Document.PurchaseInvoice.ItemList AS ItemList
		|		ON BasisesTable.Basis = ItemList.Ref
		|		AND BasisesTable.BasisKey = ItemList.Key
		|ORDER BY
		|	ItemList.LineNumber
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT DISTINCT
		|	UNDEFINED AS Ref,
		|	BasisesTable.Key,
		|	TaxList.Tax,
		|	TaxList.Analytics,
		|	TaxList.TaxRate,
		|	TaxList.Amount,
		|	TaxList.IncludeToTotalAmount,
		|	TaxList.ManualAmount
		|FROM
		|	Document.PurchaseInvoice.TaxList AS TaxList
		|		INNER JOIN BasisesTable AS BasisesTable
		|		ON BasisesTable.BasisKey = TaxList.Key
		|		AND BasisesTable.Basis = TaxList.Ref
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT DISTINCT
		|	UNDEFINED AS Ref,
		|	BasisesTable.Key,
		|	SpecialOffers.Offer,
		|	SpecialOffers.Amount,
		|	SpecialOffers.Percent
		|FROM
		|	Document.PurchaseInvoice.SpecialOffers AS SpecialOffers
		|		INNER JOIN BasisesTable AS BasisesTable
		|		ON BasisesTable.Basis = SpecialOffers.Ref
		|		AND BasisesTable.BasisKey = SpecialOffers.Key";

	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();

	TableRowIDInfo     = QueryResults[1].Unload();	
	TableItemList      = QueryResults[2].Unload();	
	TableTaxList       = QueryResults[3].Unload();
	TableSpecialOffers = QueryResults[4].Unload();
		
	Tables = New Structure();
	Tables.Insert("ItemList"      , TableItemList);
	Tables.Insert("RowIDInfo"     , TableRowIDInfo);
	Tables.Insert("TaxList"       , TableTaxList);
	Tables.Insert("SpecialOffers" , TableSpecialOffers);

	AddTables(Tables);

	RecalculateAmounts(Tables);
		
	Return Tables;
EndFunction

Function ExtractData_FromGR(BasisesTable, DataReceiver)
	Query = New Query(GetQueryText_BasisesTable());
	Query.Text = Query.Text +
		"SELECT ALLOWED
		|	""GoodsReceipt"" AS BasedOn,
		|	UNDEFINED AS Ref,
		|	ItemList.Ref.Company AS Company,
		|	ItemList.Ref.Partner AS Partner,
		|	ItemList.Ref.LegalName AS LegalName,
		|	ItemList.Store AS Store,
		|	ItemList.ItemKey.Item AS Item,
		|	ItemList.ItemKey AS ItemKey,
		|	TRUE AS UseGoodsReceipt,
		|	0 AS Quantity,
		|	BasisesTable.Key,
		|	BasisesTable.Unit AS Unit,
		|	BasisesTable.BasisUnit AS BasisUnit,
		|	BasisesTable.QuantityInBaseUnit AS QuantityInBaseUnit
		|FROM
		|	BasisesTable AS BasisesTable
		|		LEFT JOIN Document.GoodsReceipt.ItemList AS ItemList
		|		ON BasisesTable.Basis = ItemList.Ref
		|		AND BasisesTable.BasisKey = ItemList.Key
		|ORDER BY
		|	ItemList.LineNumber
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT DISTINCT
		|	UNDEFINED AS Ref,
		|	ItemList.Store AS Store,
		|	ItemList.ItemKey.Item AS Item,
		|	ItemList.ItemKey AS ItemKey,
		|	BasisesTable.Unit AS Unit,
		|	BasisesTable.Key,
		|	BasisesTable.BasisKey,
		|	BasisesTable.Basis AS GoodsReceipt,
		|	BasisesTable.QuantityInBaseUnit AS Quantity,
		|	BasisesTable.QuantityInBaseUnit AS QuantityInGoodsReceipt
		|FROM
		|	BasisesTable AS BasisesTable
		|		LEFT JOIN Document.GoodsReceipt.ItemList AS ItemList
		|		ON BasisesTable.Basis = ItemList.Ref
		|		AND BasisesTable.BasisKey = ItemList.Key";
			
	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();
	
	TableRowIDInfo     = QueryResults[1].Unload();
	TableItemList      = QueryResults[2].Unload();
	TableGoodsReceipts = QueryResults[3].Unload();
	
	For Each RowItemList In TableItemList Do
		RowItemList.Quantity = Catalogs.Units.Convert(RowItemList.BasisUnit, RowItemList.Unit, RowItemList.QuantityInBaseUnit);
	EndDo;
		
	Tables = New Structure();
	Tables.Insert("ItemList"      , TableItemList);
	Tables.Insert("RowIDInfo"     , TableRowIDInfo);
	Tables.Insert("GoodsReceipts" , TableGoodsReceipts);
	
	AddTables(Tables);
	
	Return CollapseRepeatingItemListRows(Tables, "Item, ItemKey, Store, Unit");
EndFunction

Function ExtractData_FromGR_ThenFromPO(BasisesTable, DataReceiver)
	Query = New Query(GetQueryText_BasisesTable());
	Query.Text = Query.Text +
		"SELECT DISTINCT ALLOWED
		|	BasisesTable.Key,
		|	RowIDInfo.BasisKey AS BasisKey,
		|	BasisesTable.RowID,
		|	BasisesTable.CurrentStep,
		|	BasisesTable.RowRef,
		|	VALUE(Document.PurchaseOrder.EmptyRef) AS ParentBasis,
		|	BasisesTable.ParentBasis AS Basis,
		|	BasisesTable.Unit,
		|	BasisesTable.BasisUnit,
		|	BasisesTable.QuantityInBaseUnit
		|FROM
		|	BasisesTable AS BasisesTable
		|		LEFT JOIN Document.GoodsReceipt.RowIDInfo AS RowIDInfo
		|		ON BasisesTable.Basis = RowIDInfo.Ref
		|		AND BasisesTable.BasisKey = RowIDInfo.Key
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT DISTINCT
		|	UNDEFINED AS Ref,
		|	ItemList.Store AS Store,
		|	ItemList.ItemKey.Item AS Item,
		|	ItemList.ItemKey AS ItemKey,
		|	BasisesTable.Unit AS Unit,
		|	BasisesTable.Key,
		|	BasisesTable.BasisKey,
		|	BasisesTable.Basis AS GoodsReceipt,
		|	BasisesTable.QuantityInBaseUnit AS Quantity,
		|	BasisesTable.QuantityInBaseUnit AS QuantityInGoodsReceipt
		|FROM
		|	BasisesTable AS BasisesTable
		|		LEFT JOIN Document.GoodsReceipt.ItemList AS ItemList
		|		ON BasisesTable.Basis = ItemList.Ref
		|		AND BasisesTable.BasisKey = ItemList.Key";
	
	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();
	
	TablesPO = ExtractData_FromPO(QueryResults[2].Unload(), DataReceiver);
	TablesPO.ItemList.FillValues(True, "UseGoodsReceipt");
	
	TableRowIDInfo     = QueryResults[1].Unload(); 
	TableGoodsReceipts = QueryResults[3].Unload();
	
	Tables = New Structure();
	Tables.Insert("ItemList"      , TablesPO.ItemList);
	Tables.Insert("RowIDInfo"     , TableRowIDInfo);
	Tables.Insert("TaxList"       , TablesPO.TaxList);
	Tables.Insert("SpecialOffers" , TablesPO.SpecialOffers);
	Tables.Insert("GoodsReceipts" , TableGoodsReceipts);
	
	AddTables(Tables);
	
	Return CollapseRepeatingItemListRows(Tables, "PurchaseOrderItemListKey");
EndFunction

Function ExtractData_FromGR_ThenFromPI(BasisesTable, DataReceiver)
	Query = New Query(GetQueryText_BasisesTable());
	Query.Text = Query.Text +
		"SELECT DISTINCT ALLOWED
		|	BasisesTable.Key,
		|	RowIDInfo.BasisKey AS BasisKey,
		|	BasisesTable.RowID,
		|	BasisesTable.CurrentStep,
		|	BasisesTable.RowRef,
		|	VALUE(Document.PurchaseInvoice.EmptyRef) AS ParentBasis,
		|	BasisesTable.ParentBasis AS Basis,
		|	BasisesTable.Unit,
		|	BasisesTable.BasisUnit,
		|	BasisesTable.QuantityInBaseUnit
		|FROM
		|	BasisesTable AS BasisesTable
		|		LEFT JOIN Document.GoodsReceipt.RowIDInfo AS RowIDInfo
		|		ON BasisesTable.Basis = RowIDInfo.Ref
		|		AND BasisesTable.BasisKey = RowIDInfo.Key
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT DISTINCT
		|	UNDEFINED AS Ref,
		|	ItemList.Store AS Store,
		|	ItemList.ItemKey.Item AS Item,
		|	ItemList.ItemKey AS ItemKey,
		|	BasisesTable.Unit AS Unit,
		|	BasisesTable.Key,
		|	BasisesTable.BasisKey,
		|	BasisesTable.Basis AS GoodsReceipt,
		|	BasisesTable.QuantityInBaseUnit AS Quantity,
		|	BasisesTable.QuantityInBaseUnit AS QuantityInGoodsReceipt
		|FROM
		|	BasisesTable AS BasisesTable
		|		LEFT JOIN Document.GoodsReceipt.ItemList AS ItemList
		|		ON BasisesTable.Basis = ItemList.Ref
		|		AND BasisesTable.BasisKey = ItemList.Key";
	
	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();
	
	TablesPI = ExtractData_FromPI(QueryResults[2].Unload(), DataReceiver);
	TablesPI.ItemList.FillValues(True, "UseGoodsReceipt");
	
	TableRowIDInfo     = QueryResults[1].Unload(); 
	TableGoodsReceipts = QueryResults[3].Unload();
	
	Tables = New Structure();
	Tables.Insert("ItemList"      , TablesPI.ItemList);
	Tables.Insert("RowIDInfo"     , TableRowIDInfo);
	Tables.Insert("TaxList"       , TablesPI.TaxList);
	Tables.Insert("SpecialOffers" , TablesPI.SpecialOffers);
	Tables.Insert("GoodsReceipts" , TableGoodsReceipts);
	
	AddTables(Tables);
	
	Return CollapseRepeatingItemListRows(Tables, "PurchaseInvoiceItemListKey");
EndFunction

Function ExtractData_FromITO(BasisesTable, DataReceiver)
	Query = New Query(GetQueryText_BasisesTable());
	Query.Text = Query.Text +
		"SELECT ALLOWED
		|	""InventoryTransferOrder"" AS BasedOn,
		|	UNDEFINED AS Ref,
		|	ItemList.Ref AS InventoryTransferOrder,
		|	ItemList.InternalSupplyRequest AS InternalSupplyRequest,
		|	ItemList.Ref.Company AS Company,
		|	ItemList.Ref.BusinessUnit AS BusinessUnit,
		|	ItemList.Ref.StoreSender AS StoreSender,
		|	ItemList.Ref.StoreReceiver AS StoreReceiver,
		|	ItemList.ItemKey.Item AS Item,
		|	ItemList.ItemKey AS ItemKey,
		|	0 AS Quantity,
		|	BasisesTable.Key,
		|	BasisesTable.Unit AS Unit,
		|	BasisesTable.BasisUnit AS BasisUnit,
		|	BasisesTable.QuantityInBaseUnit AS QuantityInBaseUnit
		|FROM
		|	BasisesTable AS BasisesTable
		|		LEFT JOIN Document.InventoryTransferOrder.ItemList AS ItemList
		|		ON BasisesTable.Basis = ItemList.Ref
		|		AND BasisesTable.BasisKey = ItemList.Key
		|ORDER BY
		|	ItemList.LineNumber";
				
	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();
	
	TableRowIDInfo = QueryResults[1].Unload();
	TableItemList  = QueryResults[2].Unload();
	 
	For Each RowItemList In TableItemList Do
		RowItemList.Quantity = Catalogs.Units.Convert(RowItemList.BasisUnit, RowItemList.Unit, RowItemList.QuantityInBaseUnit);
	EndDo;
		
	Tables = New Structure();
	Tables.Insert("ItemList"  , TableItemList);
	Tables.Insert("RowIDInfo" , TableRowIDInfo);
	
	AddTables(Tables);
	
	Return Tables;
EndFunction

Function ExtractData_FromIT(BasisesTable, DataReceiver)
	Query = New Query(GetQueryText_BasisesTable());
	Query.Text = Query.Text +
		"SELECT ALLOWED
		|	""InventoryTransfer"" AS BasedOn,
		|	UNDEFINED AS Ref,
		|	ItemList.Ref AS InventoryTransfer,
		|	ItemList.InventoryTransferOrder AS InventoryTransferOrder,
		|	ItemList.Ref.Company AS Company,
		|	ItemList.Ref AS ShipmentBasis,
		|	ItemList.Ref AS ReceiptBasis,
		|	ItemList.Ref.%1 AS Store,
		|	%2 AS TransactionType,
		|	ItemList.ItemKey.Item AS Item,
		|	ItemList.ItemKey AS ItemKey,
		|	0 AS Quantity,
		|	BasisesTable.Key,
		|	BasisesTable.Unit AS Unit,
		|	BasisesTable.BasisUnit AS BasisUnit,
		|	BasisesTable.QuantityInBaseUnit AS QuantityInBaseUnit
		|FROM
		|	BasisesTable AS BasisesTable
		|		LEFT JOIN Document.InventoryTransfer.ItemList AS ItemList
		|		ON BasisesTable.Basis = ItemList.Ref
		|		AND BasisesTable.BasisKey = ItemList.Key
		|ORDER BY
		|	ItemList.LineNumber";
	
	StoreName = "UNDEFINED";
	TransactionType = "UNDEFINED";
	If Is(DataReceiver).SC Then
		StoreName = "StoreSender";
		TransactionType = "VALUE(Enum.ShipmentConfirmationTransactionTypes.InventoryTransfer)";
	ElsIf Is(DataReceiver).GR Then
		StoreName = "StoreReceiver";
		TransactionType = "VALUE(Enum.GoodsReceiptTransactionTypes.InventoryTransfer)";
	EndIf;
	Query.Text = StrTemplate(Query.Text, StoreName, TransactionType);
	
	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();
	
	TableRowIDInfo  = QueryResults[1].Unload();
	TableItemList   = QueryResults[2].Unload();
	 
	For Each RowItemList In TableItemList Do
		RowItemList.Quantity = Catalogs.Units.Convert(RowItemList.BasisUnit, RowItemList.Unit, RowItemList.QuantityInBaseUnit);
	EndDo;
		
	Tables = New Structure();
	Tables.Insert("ItemList"  , TableItemList);
	Tables.Insert("RowIDInfo" , TableRowIDInfo);
	
	AddTables(Tables);
	
	Return Tables;
EndFunction

Function ExtractData_FromISR(BasisesTable, DataReceiver)
	Query = New Query(GetQueryText_BasisesTable());
	Query.Text = Query.Text +
		"SELECT ALLOWED
		|	""InternalSupplyRequest"" AS BasedOn,
		|	UNDEFINED AS Ref,
		|	ItemList.Ref AS InternalSupplyRequest,
		|	ItemList.Ref.Company AS Company,
		|	ItemList.Ref.BusinessUnit AS BusinessUnit,
		|	ItemList.Ref.Store AS Store,
		|	ItemList.Ref.Store AS StoreReceiver,
		|	ItemList.ItemKey.Item AS Item,
		|	ItemList.ItemKey AS ItemKey,
		|	0 AS Quantity,
		|	BasisesTable.Key,
		|	BasisesTable.Unit AS Unit,
		|	BasisesTable.BasisUnit AS BasisUnit,
		|	BasisesTable.QuantityInBaseUnit AS QuantityInBaseUnit
		|FROM
		|	BasisesTable AS BasisesTable
		|		LEFT JOIN Document.InternalSupplyRequest.ItemList AS ItemList
		|		ON BasisesTable.Basis = ItemList.Ref
		|		AND BasisesTable.BasisKey = ItemList.Key
		|ORDER BY
		|	ItemList.LineNumber";
				
	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();
	
	TableRowIDInfo     = QueryResults[1].Unload();
	TableItemList      = QueryResults[2].Unload();

	For Each RowItemList In TableItemList Do
		RowItemList.Quantity = Catalogs.Units.Convert(RowItemList.BasisUnit, RowItemList.Unit, RowItemList.QuantityInBaseUnit);
	EndDo;
		
	Tables = New Structure();
	Tables.Insert("ItemList"  , TableItemList);
	Tables.Insert("RowIDInfo" , TableRowIDInfo);
	
	AddTables(Tables);
	
	Return Tables;
EndFunction

Function ExtractData_FromPhysicalInventory(BasisesTable, DataReceiver)
	Query = New Query(GetQueryText_BasisesTable());
	Query.Text = Query.Text +
		"SELECT ALLOWED
		|	""PhysicalInventory"" AS BasedOn,
		|	UNDEFINED AS Ref,
		|	ItemList.Ref AS PhysicalInventory,
		|	ItemList.Ref AS BasisDocument,
		|	ItemList.Ref.Store AS Store,
		|	ItemList.ItemKey.Item AS Item,
		|	ItemList.ItemKey AS ItemKey,
		|	0 AS Quantity,
		|	BasisesTable.Key,
		|	BasisesTable.Unit AS Unit,
		|	BasisesTable.BasisUnit AS BasisUnit,
		|	BasisesTable.QuantityInBaseUnit AS QuantityInBaseUnit
		|FROM
		|	BasisesTable AS BasisesTable
		|		LEFT JOIN Document.PhysicalInventory.ItemList AS ItemList
		|		ON BasisesTable.Basis = ItemList.Ref
		|		AND BasisesTable.BasisKey = ItemList.Key
		|ORDER BY
		|	ItemList.LineNumber";
				
	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();
	
	TableRowIDInfo     = QueryResults[1].Unload();
	TableItemList      = QueryResults[2].Unload();

	For Each RowItemList In TableItemList Do
		RowItemList.Quantity = Catalogs.Units.Convert(RowItemList.BasisUnit, RowItemList.Unit, RowItemList.QuantityInBaseUnit);
	EndDo;
		
	Tables = New Structure();
	Tables.Insert("ItemList"  , TableItemList);
	Tables.Insert("RowIDInfo" , TableRowIDInfo);
	
	AddTables(Tables);
	
	Return Tables;
EndFunction

#EndRegion

Procedure AddTables(Tables)
	If Tables.Property("ItemList") Then
		Tables.ItemList = AddColumnsToItemList(Tables.ItemList);
	Else
		Tables.Insert("ItemList", GetEmptyTable_ItemList());
	EndIf;
	
	If Not Tables.Property("TaxList") Then
		Tables.Insert("TaxList", GetEmptyTable_TaxList());
	EndIf;
	
	If Not Tables.Property("SpecialOffers") Then
		Tables.Insert("SpecialOffers", GetEmptyTable_SpecialOffers());
	EndIf;
	
	If Not Tables.Property("ShipmentConfirmations") Then
		Tables.Insert("ShipmentConfirmations", GetEmptyTable_ShipmentConfirmations());
	EndIf;
	
	If Not Tables.Property("GoodsReceipts") Then
		Tables.Insert("GoodsReceipts", GetEmptyTable_GoodsReceipts());
	EndIf;
EndProcedure

Function AddColumnsToItemList(TableItemList)
	EmptyTableItemList = GetEmptyTable_ItemList();
	For Each Column In EmptyTableItemList.Columns Do
		If TableItemList.Columns.Find(Column.Name) = Undefined Then
			TableItemList.Columns.Add(Column.Name);
		EndIf;
	EndDo;
	Return TableItemList;
EndFunction

Procedure RecalculateAmounts(Tables)
	For Each RowItemList In Tables.ItemList Do
		
		RowItemList.Quantity = Catalogs.Units.Convert(RowItemList.BasisUnit, RowItemList.Unit, RowItemList.QuantityInBaseUnit);
		
		// ItemList
		If RowItemList.OriginalQuantity = 0 Then
			RowItemList.TaxAmount    = 0;
			RowItemList.NetAmount    = 0;
			RowItemList.TotalAmount  = 0;
			RowItemList.OffersAmount = 0;
		ElsIf RowItemList.OriginalQuantity <> RowItemList.QuantityInBaseUnit Then
			RowItemList.TaxAmount    = RowItemList.TaxAmount    / RowItemList.OriginalQuantity * RowItemList.QuantityInBaseUnit;
			RowItemList.NetAmount    = RowItemList.NetAmount    / RowItemList.OriginalQuantity * RowItemList.QuantityInBaseUnit;
			RowItemList.TotalAmount  = RowItemList.TotalAmount  / RowItemList.OriginalQuantity * RowItemList.QuantityInBaseUnit;
			RowItemList.OffersAmount = RowItemList.OffersAmount / RowItemList.OriginalQuantity * RowItemList.QuantityInBaseUnit;
		EndIf;	
		
		Filter = New Structure("Ref, Key", RowItemList.Ref, RowItemList.Key);
		
		// TaxList
		If Tables.Property("TaxList") Then
			For Each RowTaxList In Tables.TaxList.FindRows(Filter) Do
				If RowItemList.OriginalQuantity = 0 Then
					RowTaxList.Amount       = 0;
					RowTaxList.ManualAmount = 0;
				Else
					RowTaxList.Amount       = RowTaxList.Amount       / RowItemList.OriginalQuantity * RowItemList.QuantityInBaseUnit;
					RowTaxList.ManualAmount = RowTaxList.ManualAmount / RowItemList.OriginalQuantity * RowItemList.QuantityInBaseUnit;								
				EndIf;
			EndDo;
		EndIf;
		
		// SpecialOffers
		If Tables.Property("SpecialOffers") Then
			For Each RowSpecialOffers In Tables.SpecialOffers.FindRows(Filter) Do
				If RowItemList.OriginalQuantity = 0 Then
					RowSpecialOffers.Amount = 0;
				Else
					RowSpecialOffers.Amount = RowSpecialOffers.Amount / RowItemList.OriginalQuantity * RowItemList.QuantityInBaseUnit;
				EndIf;
			EndDo;
		EndIf;
	EndDo;
EndProcedure

Function CollapseRepeatingItemListRows(Tables, UniqueColumnNames)
	ItemListGrouped = Tables.ItemList.Copy();
	ItemListGrouped.GroupBy(UniqueColumnNames, GetColumnNamesSum_ItemList());
	ItemListResult = Tables.ItemList.CopyColumns();
	
	For Each RowGrouped In ItemListGrouped Do
		Filter = New Structure(UniqueColumnNames);
		FillPropertyValues(Filter, RowGrouped);
		ArrayOfItemListRows = Tables.ItemList.FindRows(Filter);
		
		If ArrayOfItemListRows.Count() = 1 Then
			FillPropertyValues(ItemListResult.Add(), ArrayOfItemListRows[0]);
			Continue;
		Else
			KeyTable = New ValueTable();
			KeyTable.Columns.Add("Key");
			For Each Row In ArrayOfItemListRows Do
				KeyTable.Add().Key = Row.Key;
			EndDo;
			 KeyTable.GroupBy("Key");
			 If KeyTable.Count() = 1 Then
			 	FillPropertyValues(ItemListResult.Add(), ArrayOfItemListRows[0]);
			 	Continue;
			 EndIf;
		EndIf;
		
		NewKey = String(New UUID());
		
		For Each ItemOfArray In ArrayOfItemListRows Do
			Filter = New Structure("Key" , ItemOfArray.Key);
			
			For Each Row In Tables.RowIDInfo.FindRows(Filter) Do
				Row.Key = NewKey;
			EndDo;
			
			For Each Row In Tables.TaxList.FindRows(Filter) Do
				Row.Key = NewKey;
			EndDo;
			
			For Each Row In Tables.SpecialOffers.FindRows(Filter) Do
				Row.Key = NewKey;
			EndDo;
			
			For Each Row In Tables.ShipmentConfirmations.FindRows(Filter) Do
				Row.Key = NewKey;
			EndDo;
			
			For Each Row In Tables.GoodsReceipts.FindRows(Filter) Do
				Row.Key = NewKey;
			EndDo;
		EndDo;
		
		NewRow = ItemListResult.Add();
		FillPropertyValues(NewRow, ArrayOfItemListRows[0]);
		FillPropertyValues(NewRow, RowGrouped, GetColumnNamesSum_ItemList());
		NewRow.Key = NewKey;
	EndDo;
	
	Tables.TaxList.GroupBy(GetColumnNames_TaxList(), GetColumnNamesSum_TaxList());
	Tables.SpecialOffers.GroupBy(GetColumnNames_SpecialOffers(), GetColumnNamesSum_SpecialOffers());
	Tables.ShipmentConfirmations.GroupBy(GetColumnNames_ShipmentConfirmations(), GetColumnNamesSum_ShipmentConfirmations());
	Tables.GoodsReceipts.GroupBy(GetColumnNames_GoodsReceipts(), GetColumnNamesSum_GoodsReceipts());
	
	Tables.ItemList = ItemListResult;
	Return Tables;
EndFunction

Function ReduseExtractedDataInfo(Tables, ReduseInfo)
	If Not ReduseInfo.Reduse Then
		Return Tables;
	EndIf;
	
	For Each KeyValue In Tables Do
		TableName = KeyValue.Key;
		
		If Upper(TableName) = Upper("RowIDInfo") Then
			Continue;
		EndIf;
			
		If Not ReduseInfo.Tables.Property(TableName) Then
			Tables[TableName].Clear();
		Else
			ColumnNames = New Array();
			For Each ColumnName In StrSplit(ReduseInfo.Tables[TableName], ",") Do
				ColumnNames.Add(TrimAll(ColumnName));
			EndDo;
				
			For Each Column In Tables[TableName].Columns Do
				If ColumnNames.Find(Column.Name) = Undefined Then
					Tables[TableName].FillValues(Undefined, Column.Name);
				EndIf;
			EndDo;
		EndIf;
			
	EndDo;
	Return Tables;
EndFunction

Function ReduseExtractedDataInfo_SO(Tables, DataReceiver)
	ReduseInfo = New Structure("Reduse, Tables", False, New Structure());
	
	If Is(DataReceiver).PO Or Is(DataReceiver).PI Then
		ReduseInfo.Reduse = True;
		ReduseInfo.Tables.Insert("ItemList", 
		"Key, BasedOn, Company, Store, UseGoodsReceipt, PurchaseBasis, SalesOrder, 
		|Item, ItemKey, Unit, BasisUnit, Quantity, QuantityInBaseUnit");
	EndIf;
	
	Return ReduseExtractedDataInfo(Tables, ReduseInfo);
EndFunction

#EndRegion

#Region GetBasises

Function GetBasises(Ref, FilterValues) Export
	If Is(Ref).SI Then
		Return GetBasisesFor_SI(FilterValues);
	ElsIf Is(Ref).SC Then
		Return GetBasisesFor_SC(FilterValues);
	ElsIf Is(Ref).PO Then
		Return GetBasisesFor_PO(FilterValues);
	ElsIf Is(Ref).PI Then
		Return GetBasisesFor_PI(FilterValues);
	ElsIf Is(Ref).GR Then
		Return GetBasisesFor_GR(FilterValues);
	ElsIf Is(Ref).IT Then
		Return GetBasisesFor_IT(FilterValues);
	ElsIf Is(Ref).ITO Then
		Return GetBasisesFor_ITO(FilterValues);	
	ElsIf Is(Ref).StockAdjustmentAsSurplus Then
		Return GetBasisesFor_StockAdjustmentAsSurplus(FilterValues);	
	ElsIf Is(Ref).StockAdjustmentAsWriteOff Then
		Return GetBasisesFor_StockAdjustmentAsWriteOff(FilterValues);
	ElsIf Is(Ref).PR Then
		Return GetBasisesFor_PR(FilterValues);
	ElsIf Is(Ref).PRO Then
		Return GetBasisesFor_PRO(FilterValues);
	ElsIf Is(Ref).SR Then
		Return GetBasisesFor_SR(FilterValues);
	ElsIf Is(Ref).SRO Then
		Return GetBasisesFor_SRO(FilterValues);
	EndIf;
EndFunction

#Region GetBasisesFor

Function GetBasisesFor_SI(FilterValues)
	StepArray = New Array;
	StepArray.Add(Catalogs.MovementRules.SI);
	StepArray.Add(Catalogs.MovementRules.SI_SC);
	
	FilterSets = GetAvailableFilterSets();
	FilterSets.SO_ForSI = True;
	FilterSets.SC_ForSI = True;
	
	FilterSets.GR_ForSI_ForSC = True;
	FilterSets.PI_ForSI_ForSC = True;
		
	Return GetBasisesTable(StepArray, FilterValues, FilterSets);
EndFunction

Function GetBasisesFor_SC(FilterValues)	
	StepArray = New Array;
	StepArray.Add(Catalogs.MovementRules.SC);
	StepArray.Add(Catalogs.MovementRules.SI_SC);
	
	FilterSets = GetAvailableFilterSets();
	FilterSets.SO_ForSC = True;
	FilterSets.SI_ForSC = True;
	
	FilterSets.GR_ForSI_ForSC = True;
	FilterSets.PI_ForSI_ForSC = True;
	
	FilterSets.IT_ForSC = True;
	
	Return GetBasisesTable(StepArray, FilterValues, FilterSets);
EndFunction

Function GetBasisesFor_PO(FilterValues)
	StepArray = New Array;
	StepArray.Add(Catalogs.MovementRules.PO_PI);
	StepArray.Add(Catalogs.MovementRules.ITO_PO_PI);
	
	FilterSets = GetAvailableFilterSets();
	FilterSets.SO_ForPO_ForPI = True;
	FilterSets.ISR_ForITO_ForPO_ForPI = True;
	
	Return GetBasisesTable(StepArray, FilterValues, FilterSets);
EndFunction

Function GetBasisesFor_PI(FilterValues)
	StepArray = New Array;
	StepArray.Add(Catalogs.MovementRules.PI);
	StepArray.Add(Catalogs.MovementRules.PI_GR);
	StepArray.Add(Catalogs.MovementRules.PO_PI);
	StepArray.Add(Catalogs.MovementRules.ITO_PO_PI);
	
	FilterSets = GetAvailableFilterSets();
	FilterSets.PO_ForPI = True;
	FilterSets.GR_ForPI = True;
	FilterSets.SO_ForPO_ForPI = True;
	FilterSets.ISR_ForITO_ForPO_ForPI = True;
	
	Return GetBasisesTable(StepArray, FilterValues, FilterSets);
EndFunction

Function GetBasisesFor_GR(FilterValues)	
	StepArray = New Array;
	StepArray.Add(Catalogs.MovementRules.GR);
	StepArray.Add(Catalogs.MovementRules.PI_GR);
	
	FilterSets = GetAvailableFilterSets();
	FilterSets.PO_ForGR = True;
	FilterSets.PI_ForGR = True;
	
	FilterSets.IT_ForGR = True;
	
	Return GetBasisesTable(StepArray, FilterValues, FilterSets);
EndFunction

Function GetBasisesFor_IT(FilterValues)	
	StepArray = New Array;
	StepArray.Add(Catalogs.MovementRules.IT);
	
	FilterSets = GetAvailableFilterSets();
	FilterSets.ITO_ForIT = True;
	
	Return GetBasisesTable(StepArray, FilterValues, FilterSets);
EndFunction

Function GetBasisesFor_ITO(FilterValues)
	StepArray = New Array;
	StepArray.Add(Catalogs.MovementRules.ITO_PO_PI);
	
	FilterSets = GetAvailableFilterSets();
	FilterSets.ISR_ForITO_ForPO_ForPI = True;
	
	Return GetBasisesTable(StepArray, FilterValues, FilterSets);
EndFunction

Function GetBasisesFor_StockAdjustmentAsSurplus(FilterValues)
	StepArray = New Array;
	StepArray.Add(Catalogs.MovementRules.StockAdjustmentAsSurplus);
	
	FilterSets = GetAvailableFilterSets();
	FilterSets.PhysicalInventory_ForSurplus_ForWriteOff = True;
	
	Return GetBasisesTable(StepArray, FilterValues, FilterSets);
EndFunction

Function GetBasisesFor_StockAdjustmentAsWriteOff(FilterValues)
	StepArray = New Array;
	StepArray.Add(Catalogs.MovementRules.StockAdjustmentAsWriteOff);
	
	FilterSets = GetAvailableFilterSets();
	FilterSets.PhysicalInventory_ForSurplus_ForWriteOff = True;
	
	Return GetBasisesTable(StepArray, FilterValues, FilterSets);
EndFunction

Function GetBasisesFor_PR(FilterValues)
	StepArray = New Array;
	StepArray.Add(Catalogs.MovementRules.PR);
	
	FilterSets = GetAvailableFilterSets();
	FilterSets.SC_ForPR = True;
	
	// ???
	//FilterSets.PI_ForPR = True;
	//FilterSets.PRO_ForPR = True;
	
	Return GetBasisesTable(StepArray, FilterValues, FilterSets);
EndFunction

Function GetBasisesFor_PRO(FilterValues)

EndFunction

Function GetBasisesFor_SR(FilterValues)
	StepArray = New Array;
	StepArray.Add(Catalogs.MovementRules.SR);
	
	FilterSets = GetAvailableFilterSets();
	FilterSets.GR_ForSR = True;
	
	Return GetBasisesTable(StepArray, FilterValues, FilterSets);
EndFunction

Function GetBasisesFor_SRO(FilterValues)

EndFunction

#EndRegion

#Region FIlterSets

Function GetAvailableFilterSets()
	Result = New Structure();
	Result.Insert("SO_ForSI"       , False);
	Result.Insert("SO_ForSC"       , False);
	Result.Insert("SO_ForPO_ForPI" , False);
	
	Result.Insert("SC_ForSI"       , False);
	Result.Insert("SI_ForSC"       , False);
	
	Result.Insert("PO_ForPI"       , False);
	Result.Insert("PO_ForGR"       , False);
	
	Result.Insert("GR_ForPI"       , False);
	Result.Insert("PI_ForGR"       , False);
	
	Result.Insert("GR_ForSI_ForSC" , False);
	Result.Insert("PI_ForSI_ForSC" , False);
	
	Result.Insert("ITO_ForIT"      , False);
	Result.Insert("IT_ForSC"       , False);
	Result.Insert("IT_ForGR"       , False);
	
	Result.Insert("ISR_ForITO_ForPO_ForPI", False);
	
	Result.Insert("PhysicalInventory_ForSurplus_ForWriteOff", False);
	
	Result.Insert("SC_ForPR", False);
	Result.Insert("GR_ForSR", False);
	
	Return Result;
EndFunction

Procedure EnableRequiredFilterSets(FilterSets, Query, QueryArray)
	
	If FilterSets.SO_ForSI Then
		ApplyFilterSet_SO_ForSI(Query);
		QueryArray.Add(GetDataByFilterSet_SO_ForSI());
	EndIf;
	
	If FilterSets.SO_ForSC Then
		ApplyFilterSet_SO_ForSC(Query);
		QueryArray.Add(GetDataByFilterSet_SO_ForSC());
	EndIf;
	
	If FilterSets.SO_ForPO_ForPI Then
		ApplyFilterSet_SO_ForPO_ForPI(Query);
		QueryArray.Add(GetDataByFilterSet_SO_ForPO_ForPI());
	EndIf;
	
	If FilterSets.SI_ForSC Then
		ApplyFilterSet_SI_ForSC(Query);
		QueryArray.Add(GetDataByFilterSet_SI_ForSC());
	EndIf;
		
	If FilterSets.SC_ForSI Then
		ApplyFilterSet_SC_ForSI(Query);
		QueryArray.Add(GetDataByFilterSet_SC_ForSI());
	EndIf;
	
	If FilterSets.PO_ForPI Then
		ApplyFilterSet_PO_ForPI(Query);
		QueryArray.Add(GetDataByFilterSet_PO_ForPI());
	EndIf;

	If FilterSets.PO_ForGR Then
		ApplyFilterSet_PO_ForGR(Query);
		QueryArray.Add(GetDataByFilterSet_PO_ForGR());
	EndIf;
	
	If FilterSets.GR_ForPI Then
		ApplyFilterSet_GR_ForPI(Query);
		QueryArray.Add(GetDataByFilterSet_GR_ForPI());
	EndIf;

	If FilterSets.PI_ForGR Then
		ApplyFIlterSet_PI_ForGR(Query);
		QueryArray.Add(GetDataByFilterSet_PI_ForGR());
	EndIf;
	
	If FilterSets.PI_ForSI_ForSC Then
		ApplyFIlterSet_PI_ForSI_ForSC(Query);
		QueryArray.Add(GetDataByFilterSet_PI_ForSI_ForSC());
	EndIf;
	
	If FilterSets.GR_ForSI_ForSC Then
		ApplyFilterSet_GR_ForSI_ForSC(Query);
		QueryArray.Add(GetDataByFilterSet_GR_ForSI_ForSC());
	EndIf;
	
	If FilterSets.ITO_ForIT Then
		ApplyFilterSet_ITO_ForIT(Query);
		QueryArray.Add(GetDataByFilterSet_ITO_ForIT());
	EndIf;
	
	If FilterSets.IT_ForSC Then
		ApplyFilterSet_IT_ForSC(Query);
		QueryArray.Add(GetDataByFilterSet_IT_ForSC());
	EndIf;
	
	If FilterSets.IT_ForGR Then
		ApplyFilterSet_IT_ForGR(Query);
		QueryArray.Add(GetDataByFilterSet_IT_ForGR());
	EndIf;

	If FilterSets.ISR_ForITO_ForPO_ForPI Then
		ApplyFilterSet_ISR_ForITO_ForPO_ForPI(Query);
		QueryArray.Add(GetDataByFilterSet_ISR_ForITO_ForPO_ForPI());
	EndIf;
	
	If FilterSets.PhysicalInventory_ForSurplus_ForWriteOff Then
		ApplyFilterSet_PhysicalInventory_ForSurplus_ForWriteOff(Query);
		QueryArray.Add(GetDataByFilterSet_PhysicalInventory_ForSurplus_ForWriteOff());
	EndIf;
	
	If FilterSets.SC_ForPR Then
		ApplyFilterSet_SC_ForPR(Query);
		QueryArray.Add(GetDataByFilterSet_SC_ForPR());
	EndIf;
	
	If FilterSets.GR_ForSR Then
		ApplyFilterSet_GR_ForSR(Query);
		QueryArray.Add(GetDataByFilterSet_GR_ForSR());
	EndIf;
EndProcedure

#Region ApplyFilterSets

Procedure ApplyFilterSet_SO_ForSI(Query)
	Query.Text = 
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_SO_ForSI
	|FROM
	|	AccumulationRegister.T10000B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_Partner
	|					THEN RowRef.Partner = &Partner
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_LegalName
	|					THEN RowRef.LegalName = &LegalName
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_Agreement
	|					THEN RowRef.Agreement = &Agreement
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_Currency
	|					THEN RowRef.Currency = &Currency
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_PriceIncludeTax
	|					THEN RowRef.PriceIncludeTax = &PriceIncludeTax
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_ItemKey
	|					THEN RowRef.ItemKey = &ItemKey
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_Store
	|					THEN RowRef.Store = &Store
	|				ELSE TRUE
	|			END))) AS RowIDMovements";
	Query.Execute();
EndProcedure	

Procedure ApplyFilterSet_SO_ForSC(Query)
	Query.Text = 
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_SO_ForSC
	|FROM
	|	AccumulationRegister.T10000B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_Partner
	|					THEN RowRef.Partner = &Partner
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_LegalName
	|					THEN RowRef.LegalName = &LegalName
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_TransactionType
	|					THEN RowRef.TransactionTypeSC = &TransactionType
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_ItemKey
	|					THEN RowRef.ItemKey = &ItemKey
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_Store
	|					THEN RowRef.Store = &Store
	|				ELSE TRUE
	|			END))) AS RowIDMovements";
	Query.Execute();
EndProcedure

Procedure ApplyFilterSet_SO_ForPO_ForPI(Query)
	Query.Text = 
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_SO_ForPO_ForPI
	|FROM
	|	AccumulationRegister.T10000B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_ProcurementMethod
	|					THEN RowRef.ProcurementMethod = &ProcurementMethod
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_ItemKey
	|					THEN RowRef.ItemKey = &ItemKey
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_Store
	|					THEN RowRef.Store = &Store
	|				ELSE TRUE
	|			END))) AS RowIDMovements";
	Query.Execute();
EndProcedure	

Procedure ApplyFilterSet_SC_ForSI(Query)
	Query.Text = 
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_SC_ForSI
	|FROM
	|	AccumulationRegister.T10000B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef.Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_Partner
	|					THEN RowRef.Partner = &Partner
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_LegalName
	|					THEN RowRef.LegalName = &LegalName
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_TransactionType
	|					THEN RowRef.TransactionTypeSC = &TransactionType
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_ItemKey
	|					THEN RowRef.ItemKey = &ItemKey
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_Store
	|					THEN RowRef.Store = &Store
	|				ELSE TRUE
	|			END))) AS RowIDMovements";
	Query.Execute();
EndProcedure

Procedure ApplyFilterSet_SI_ForSC(Query)
	Query.Text = 
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_SI_ForSC
	|FROM
	|	AccumulationRegister.T10000B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef.Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_Partner
	|					THEN RowRef.Partner = &Partner
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_LegalName
	|					THEN RowRef.LegalName = &LegalName
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_TransactionType
	|					THEN RowRef.TransactionTypeSC = &TransactionType
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_ItemKey
	|					THEN RowRef.ItemKey = &ItemKey
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_Store
	|					THEN RowRef.Store = &Store
	|				ELSE TRUE
	|			END))) AS RowIDMovements";
	Query.Execute();
EndProcedure

Procedure ApplyFilterSet_PO_ForPI(Query)
	Query.Text = 
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_PO_ForPI
	|FROM
	|	AccumulationRegister.T10000B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef.Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_Partner
	|					THEN RowRef.Partner = &Partner
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_LegalName
	|					THEN RowRef.LegalName = &LegalName
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_Agreement
	|					THEN RowRef.Agreement = &Agreement
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_Currency
	|					THEN RowRef.Currency = &Currency
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_PriceIncludeTax
	|					THEN RowRef.PriceIncludeTax = &PriceIncludeTax
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_ItemKey
	|					THEN RowRef.ItemKey = &ItemKey
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_Store
	|					THEN RowRef.Store = &Store
	|				ELSE TRUE
	|			END))) AS RowIDMovements";
	Query.Execute();
EndProcedure	

Procedure ApplyFilterSet_PO_ForGR(Query)
	Query.Text = 
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_PO_ForGR
	|FROM
	|	AccumulationRegister.T10000B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_Partner
	|					THEN RowRef.Partner = &Partner
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_LegalName
	|					THEN RowRef.LegalName = &LegalName
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_TransactionType
	|					THEN RowRef.TransactionTypeGR = &TransactionType
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_ItemKey
	|					THEN RowRef.ItemKey = &ItemKey
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_Store
	|					THEN RowRef.Store = &Store
	|				ELSE TRUE
	|			END))) AS RowIDMovements";
	Query.Execute();
EndProcedure

Procedure ApplyFilterSet_GR_ForSI_ForSC(Query)
	Query.Text = 
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_GR_ForSI_ForSC
	|FROM
	|	AccumulationRegister.T10000B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises) 
	|     OR RowRef.Basis IN (&Basises)
	|	  OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_ProcurementMethod
	|					THEN RowRef.ProcurementMethod = &ProcurementMethod
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_ItemKey
	|					THEN RowRef.ItemKey = &ItemKey
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_Store
	|					THEN RowRef.Store = &Store
	|				ELSE TRUE
	|			END))) AS RowIDMovements";
	Query.Execute();
EndProcedure

Procedure ApplyFIlterSet_PI_ForSI_ForSC(Query)
	Query.Text = 
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_PI_ForSI_ForSC
	|FROM
	|	AccumulationRegister.T10000B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises))
	|	OR RowRef.Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_ProcurementMethod
	|					THEN RowRef.ProcurementMethod = &ProcurementMethod
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_ItemKey
	|					THEN RowRef.ItemKey = &ItemKey
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_Store
	|					THEN RowRef.Store = &Store
	|				ELSE TRUE
	|			END)) AS RowIDMovements";
	Query.Execute();
EndProcedure

Procedure ApplyFilterSet_GR_ForPI(Query)
	Query.Text = 
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_GR_ForPI
	|FROM
	|	AccumulationRegister.T10000B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef.Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_Partner
	|					THEN RowRef.Partner = &Partner
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_LegalName
	|					THEN RowRef.LegalName = &LegalName
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_TransactionType
	|					THEN RowRef.TransactionTypeSC = &TransactionType
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_ItemKey
	|					THEN RowRef.ItemKey = &ItemKey
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_Store
	|					THEN RowRef.Store = &Store
	|				ELSE TRUE
	|			END))) AS RowIDMovements";
	Query.Execute();
EndProcedure

Procedure ApplyFilterSet_PI_ForGR(Query)
	Query.Text = 
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_PI_ForGR
	|FROM
	|	AccumulationRegister.T10000B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef.Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_Partner
	|					THEN RowRef.Partner = &Partner
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_LegalName
	|					THEN RowRef.LegalName = &LegalName
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_TransactionType
	|					THEN RowRef.TransactionTypeSC = &TransactionType
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_ItemKey
	|					THEN RowRef.ItemKey = &ItemKey
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_Store
	|					THEN RowRef.Store = &Store
	|				ELSE TRUE
	|			END))) AS RowIDMovements";
	Query.Execute();
EndProcedure

Procedure ApplyFIlterSet_ITO_ForIT(Query)
	Query.Text = 
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_ITO_ForIT
	|FROM
	|	AccumulationRegister.T10000B_RowIDMovements.Balance(&Period,
	|	Step IN (&StepArray)
	|	AND Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Basises
	|					THEN Basis IN (&Basises)
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_ItemKey
	|					THEN RowRef.ItemKey = &ItemKey
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_StoreSender
	|					THEN RowRef.StoreSender = &StoreSender
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_StoreReceiver
	|					THEN RowRef.StoreReceiver = &StoreReceiver
	|				ELSE TRUE
	|			END)) AS RowIDMovements";
	Query.Execute();
EndProcedure

Procedure ApplyFilterSet_IT_ForSC(Query)
	Query.Text = 
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_IT_ForSC
	|FROM
	|	AccumulationRegister.T10000B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_TransactionType
	|					THEN RowRef.TransactionTypeSC = &TransactionType
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_ItemKey
	|					THEN RowRef.ItemKey = &ItemKey
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_Store
	|					THEN RowRef.StoreSender = &Store
	|				ELSE TRUE
	|			END))) AS RowIDMovements";
	Query.Execute();
EndProcedure

Procedure ApplyFilterSet_IT_ForGR(Query)
	Query.Text = 
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_IT_ForGR
	|FROM
	|	AccumulationRegister.T10000B_RowIDMovements.Balance(&Period,
	|	Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_TransactionType
	|					THEN RowRef.TransactionTypeGR = &TransactionType
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_ItemKey
	|					THEN RowRef.ItemKey = &ItemKey
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_Store
	|					THEN RowRef.StoreReceiver = &Store
	|				ELSE TRUE
	|			END))) AS RowIDMovements";
	Query.Execute();
EndProcedure

Procedure ApplyFilterSet_ISR_ForITO_ForPO_ForPI(Query)
	Query.Text = 
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_ISR_ForITO_ForPO_ForPI
	|FROM
	|	AccumulationRegister.T10000B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_ItemKey
	|					THEN RowRef.ItemKey = &ItemKey
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_Store
	|					THEN RowRef.Store = &Store
	|				ELSE TRUE
	|			END))) AS RowIDMovements";
	Query.Execute();
EndProcedure	

Procedure ApplyFilterSet_PhysicalInventory_ForSurplus_ForWriteOff(Query)
	Query.Text = 
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_PhysicalInventory_ForSurplus_ForWriteOff
	|FROM
	|	AccumulationRegister.T10000B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_ItemKey
	|					THEN RowRef.ItemKey = &ItemKey
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_Store
	|					THEN RowRef.Store = &Store
	|				ELSE FALSE
	|			END))) AS RowIDMovements";
	Query.Execute();
EndProcedure	

Procedure ApplyFilterSet_SC_ForPR(Query)
	Query.Text = 
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_SC_ForPR
	|FROM
	|	AccumulationRegister.T10000B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef.Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_Partner
	|					THEN RowRef.Partner = &Partner
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_LegalName
	|					THEN RowRef.LegalName = &LegalName
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_TransactionType
	|					THEN RowRef.TransactionTypeSC = &TransactionType
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_ItemKey
	|					THEN RowRef.ItemKey = &ItemKey
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_Store
	|					THEN RowRef.Store = &Store
	|				ELSE TRUE
	|			END))) AS RowIDMovements";
	Query.Execute();
EndProcedure

Procedure ApplyFilterSet_GR_ForSR(Query)
	Query.Text = 
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_GR_ForSR
	|FROM
	|	AccumulationRegister.T10000B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef.Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_Partner
	|					THEN RowRef.Partner = &Partner
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_LegalName
	|					THEN RowRef.LegalName = &LegalName
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_TransactionType
	|					THEN RowRef.TransactionTypeGR = &TransactionType
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_ItemKey
	|					THEN RowRef.ItemKey = &ItemKey
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_Store
	|					THEN RowRef.Store = &Store
	|				ELSE TRUE
	|			END))) AS RowIDMovements";
	Query.Execute();
EndProcedure

#Region GetDataByFilterSet

Function GetDataByFilterSet_SO_ForSI()
	Return
	"SELECT 
	|	Doc.ItemKey,
	|	Doc.ItemKey.Item,
	|	Doc.Store,
	|	Doc.Ref,
	|	Doc.Key,
	|	Doc.Key,
	|	CASE
	|		WHEN Doc.ItemKey.Unit.Ref IS NULL
	|			THEN Doc.ItemKey.Item.Unit
	|		ELSE Doc.ItemKey.Unit
	|	END AS BasisUnit,
	|	RowIDMovements.Quantity,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	Doc.LineNumber
	|FROM
	|	Document.SalesOrder.ItemList AS Doc
	|		INNER JOIN Document.SalesOrder.RowIDInfo AS RowIDInfo
	|		ON Doc.Ref = RowIDInfo.Ref
	|		AND Doc.Key = RowIDInfo.Key
	|		INNER JOIN RowIDMovements_SO_ForSI AS RowIDMovements
	|		ON RowIDMovements.RowID = RowIDInfo.RowID
	|		AND RowIDMovements.Basis = RowIDInfo.Ref";
EndFunction

Function GetDataByFilterSet_SO_ForSC()
	Return
	"SELECT 
	|	Doc.ItemKey,
	|	Doc.ItemKey.Item,
	|	Doc.Store,
	|	Doc.Ref,
	|	Doc.Key,
	|	Doc.Key,
	|	CASE
	|		WHEN Doc.ItemKey.Unit.Ref IS NULL
	|			THEN Doc.ItemKey.Item.Unit
	|		ELSE Doc.ItemKey.Unit
	|	END AS BasisUnit,
	|	RowIDMovements.Quantity,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	Doc.LineNumber
	|FROM
	|	Document.SalesOrder.ItemList AS Doc
	|		INNER JOIN Document.SalesOrder.RowIDInfo AS RowIDInfo
	|		ON Doc.Ref = RowIDInfo.Ref
	|		AND Doc.Key = RowIDInfo.Key
	|		INNER JOIN RowIDMovements_SO_ForSC AS RowIDMovements
	|		ON RowIDMovements.RowID = RowIDInfo.RowID
	|		AND RowIDMovements.Basis = RowIDInfo.Ref";
EndFunction

Function GetDataByFilterSet_SO_ForPO_ForPI()
	Return
	"SELECT
	|	Doc.ItemKey,
	|	Doc.ItemKey.Item,
	|	Doc.Store,
	|	Doc.Ref,
	|	Doc.Key,
	|	Doc.Key,
	|	CASE
	|		WHEN Doc.ItemKey.Unit.Ref IS NULL
	|			THEN Doc.ItemKey.Item.Unit
	|		ELSE Doc.ItemKey.Unit
	|	END,
	|	RowIDMovements.Quantity,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	Doc.LineNumber
	|FROM
	|	Document.SalesOrder.ItemList AS Doc
	|		INNER JOIN Document.SalesOrder.RowIDInfo AS RowIDInfo
	|		ON Doc.Ref = RowIDInfo.Ref
	|		AND Doc.Key = RowIDInfo.Key
	|		INNER JOIN RowIDMovements_SO_ForPO_ForPI AS RowIDMovements
	|		ON RowIDMovements.RowID = RowIDInfo.RowID
	|		AND RowIDMovements.Basis = RowIDInfo.Ref";
EndFunction

Function GetDataByFilterSet_PO_ForPI()
	Return
	"SELECT
	|	Doc.ItemKey,
	|	Doc.ItemKey.Item,
	|	Doc.Store,
	|	Doc.Ref,
	|	Doc.Key,
	|	Doc.Key,
	|	CASE
	|		WHEN Doc.ItemKey.Unit.Ref IS NULL
	|			THEN Doc.ItemKey.Item.Unit
	|		ELSE Doc.ItemKey.Unit
	|	END,
	|	RowIDMovements.Quantity,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	Doc.LineNumber
	|FROM
	|	Document.PurchaseOrder.ItemList AS Doc
	|		INNER JOIN Document.PurchaseOrder.RowIDInfo AS RowIDInfo
	|		ON Doc.Ref = RowIDInfo.Ref
	|		AND Doc.Key = RowIDInfo.Key
	|		INNER JOIN RowIDMovements_PO_ForPI AS RowIDMovements
	|		ON RowIDMovements.RowID = RowIDInfo.RowID
	|		AND RowIDMovements.Basis = RowIDInfo.Ref";
EndFunction

Function GetDataByFilterSet_PO_ForGR()
	Return
	"SELECT
	|	Doc.ItemKey,
	|	Doc.ItemKey.Item,
	|	Doc.Store,
	|	Doc.Ref,
	|	Doc.Key,
	|	Doc.Key,
	|	CASE
	|		WHEN Doc.ItemKey.Unit.Ref IS NULL
	|			THEN Doc.ItemKey.Item.Unit
	|		ELSE Doc.ItemKey.Unit
	|	END,
	|	RowIDMovements.Quantity,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	Doc.LineNumber
	|FROM
	|	Document.PurchaseOrder.ItemList AS Doc
	|		INNER JOIN Document.PurchaseOrder.RowIDInfo AS RowIDInfo
	|		ON Doc.Ref = RowIDInfo.Ref
	|		AND Doc.Key = RowIDInfo.Key
	|		INNER JOIN RowIDMovements_PO_ForGR AS RowIDMovements
	|		ON RowIDMovements.RowID = RowIDInfo.RowID
	|		AND RowIDMovements.Basis = RowIDInfo.Ref";
EndFunction

Function GetDataByFilterSet_SI_ForSC()
	Return
	"SELECT
	|	Doc.ItemKey,
	|	Doc.ItemKey.Item,
	|	Doc.Store,
	|	Doc.Ref,
	|	Doc.Key,
	|	Doc.Key,
	|	CASE
	|		WHEN Doc.ItemKey.Unit.Ref IS NULL
	|			THEN Doc.ItemKey.Item.Unit
	|		ELSE Doc.ItemKey.Unit
	|	END,
	|	RowIDMovements.Quantity,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	Doc.LineNumber
	|FROM
	|	Document.SalesInvoice.ItemList AS Doc
	|		INNER JOIN Document.SalesInvoice.RowIDInfo AS RowIDInfo
	|		ON Doc.Ref = RowIDInfo.Ref
	|		AND Doc.Key = RowIDInfo.Key
	|		INNER JOIN RowIDMovements_SI_ForSC AS RowIDMovements
	|		ON RowIDMovements.RowID = RowIDInfo.RowID
	|		AND RowIDMovements.Basis = RowIDInfo.Ref";
EndFunction

Function GetDataByFilterSet_PI_ForSI_ForSC()
	Return
	"SELECT
	|	Doc.ItemKey,
	|	Doc.ItemKey.Item,
	|	Doc.Store,
	|	Doc.Ref,
	|	Doc.Key,
	|	Doc.Key,
	|	CASE
	|		WHEN Doc.ItemKey.Unit.Ref IS NULL
	|			THEN Doc.ItemKey.Item.Unit
	|		ELSE Doc.ItemKey.Unit
	|	END,
	|	RowIDMovements.Quantity,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	Doc.LineNumber
	|FROM
	|	Document.PurchaseInvoice.ItemList AS Doc
	|		INNER JOIN Document.PurchaseInvoice.RowIDInfo AS RowIDInfo
	|		ON Doc.Ref = RowIDInfo.Ref
	|		AND Doc.Key = RowIDInfo.Key
	|		INNER JOIN RowIDMovements_PI_ForSI_ForSC AS RowIDMovements
	|		ON RowIDMovements.RowID = RowIDInfo.RowID
	|		AND RowIDMovements.Basis = RowIDInfo.Ref";
EndFunction

Function GetDataByFilterSet_PI_ForGR()
	Return
	"SELECT
	|	Doc.ItemKey,
	|	Doc.ItemKey.Item,
	|	Doc.Store,
	|	Doc.Ref,
	|	Doc.Key,
	|	Doc.Key,
	|	CASE
	|		WHEN Doc.ItemKey.Unit.Ref IS NULL
	|			THEN Doc.ItemKey.Item.Unit
	|		ELSE Doc.ItemKey.Unit
	|	END,
	|	RowIDMovements.Quantity,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	Doc.LineNumber
	|FROM
	|	Document.PurchaseInvoice.ItemList AS Doc
	|		INNER JOIN Document.PurchaseInvoice.RowIDInfo AS RowIDInfo
	|		ON Doc.Ref = RowIDInfo.Ref
	|		AND Doc.Key = RowIDInfo.Key
	|		INNER JOIN RowIDMovements_PI_ForGR AS RowIDMovements
	|		ON RowIDMovements.RowID = RowIDInfo.RowID
	|		AND RowIDMovements.Basis = RowIDInfo.Ref";
EndFunction

Function GetDataByFilterSet_SC_ForSI()
	Return
	"SELECT
	|	Doc.ItemKey,
	|	Doc.ItemKey.Item,
	|	Doc.Store,
	|	Doc.Ref,
	|	Doc.Key,
	|	Doc.Key,
	|	CASE
	|		WHEN Doc.ItemKey.Unit.Ref IS NULL
	|			THEN Doc.ItemKey.Item.Unit
	|		ELSE Doc.ItemKey.Unit
	|	END,
	|	RowIDMovements.Quantity,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	Doc.LineNumber
	|FROM
	|	Document.ShipmentConfirmation.ItemList AS Doc
	|		INNER JOIN Document.ShipmentConfirmation.RowIDInfo AS RowIDInfo
	|		ON Doc.Ref = RowIDInfo.Ref
	|		AND Doc.Key = RowIDInfo.Key
	|		INNER JOIN RowIDMovements_SC_ForSI AS RowIDMovements
	|		ON RowIDMovements.RowID = RowIDInfo.RowID
	|		AND RowIDMovements.Basis = RowIDInfo.Ref";
EndFunction

Function GetDataByFilterSet_GR_ForSI_ForSC()
	Return
	"SELECT
	|	Doc.ItemKey,
	|	Doc.ItemKey.Item,
	|	Doc.Store,
	|	Doc.Ref,
	|	Doc.Key,
	|	Doc.Key,
	|	CASE
	|		WHEN Doc.ItemKey.Unit.Ref IS NULL
	|			THEN Doc.ItemKey.Item.Unit
	|		ELSE Doc.ItemKey.Unit
	|	END,
	|	RowIDMovements.Quantity,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	Doc.LineNumber
	|FROM
	|	Document.GoodsReceipt.ItemList AS Doc
	|		INNER JOIN Document.GoodsReceipt.RowIDInfo AS RowIDInfo
	|		ON Doc.Ref = RowIDInfo.Ref
	|		AND Doc.Key = RowIDInfo.Key
	|		INNER JOIN RowIDMovements_GR_ForSI_ForSC AS RowIDMovements
	|		ON RowIDMovements.RowID = RowIDInfo.RowID
	|		AND RowIDMovements.Basis = RowIDInfo.Ref";
EndFunction

Function GetDataByFilterSet_GR_ForPI()
	Return
	"SELECT
	|	Doc.ItemKey,
	|	Doc.ItemKey.Item,
	|	Doc.Store,
	|	Doc.Ref,
	|	Doc.Key,
	|	Doc.Key,
	|	CASE
	|		WHEN Doc.ItemKey.Unit.Ref IS NULL
	|			THEN Doc.ItemKey.Item.Unit
	|		ELSE Doc.ItemKey.Unit
	|	END,
	|	RowIDMovements.Quantity,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	Doc.LineNumber
	|FROM
	|	Document.GoodsReceipt.ItemList AS Doc
	|		INNER JOIN Document.GoodsReceipt.RowIDInfo AS RowIDInfo
	|		ON Doc.Ref = RowIDInfo.Ref
	|		AND Doc.Key = RowIDInfo.Key
	|		INNER JOIN RowIDMovements_GR_ForPI AS RowIDMovements
	|		ON RowIDMovements.RowID = RowIDInfo.RowID
	|		AND RowIDMovements.Basis = RowIDInfo.Ref";
EndFunction

Function GetDataByFilterSet_ITO_ForIT()
	Return
	"SELECT
	|	Doc.ItemKey,
	|	Doc.ItemKey.Item,
	|	Doc.Ref.StoreSender,
	|	Doc.Ref,
	|	Doc.Key,
	|	Doc.Key,
	|	CASE
	|		WHEN Doc.ItemKey.Unit.Ref IS NULL
	|			THEN Doc.ItemKey.Item.Unit
	|		ELSE Doc.ItemKey.Unit
	|	END,
	|	RowIDMovements.Quantity,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	Doc.LineNumber
	|FROM
	|	Document.InventoryTransferOrder.ItemList AS Doc
	|		INNER JOIN Document.InventoryTransferOrder.RowIDInfo AS RowIDInfo
	|		ON Doc.Ref = RowIDInfo.Ref
	|		AND Doc.Key = RowIDInfo.Key
	|		INNER JOIN RowIDMovements_ITO_ForIT AS RowIDMovements
	|		ON RowIDMovements.RowID = RowIDInfo.RowID
	|		AND RowIDMovements.Basis = RowIDInfo.Ref";
EndFunction

Function GetDataByFilterSet_IT_ForSC()
	Return
	"SELECT
	|	Doc.ItemKey,
	|	Doc.ItemKey.Item,
	|	Doc.Ref.StoreSender,
	|	Doc.Ref,
	|	Doc.Key,
	|	Doc.Key,
	|	CASE
	|		WHEN Doc.ItemKey.Unit.Ref IS NULL
	|			THEN Doc.ItemKey.Item.Unit
	|		ELSE Doc.ItemKey.Unit
	|	END,
	|	RowIDMovements.Quantity,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	Doc.LineNumber
	|FROM
	|	Document.InventoryTransfer.ItemList AS Doc
	|		INNER JOIN Document.InventoryTransfer.RowIDInfo AS RowIDInfo
	|		ON Doc.Ref = RowIDInfo.Ref
	|		AND Doc.Key = RowIDInfo.Key
	|		INNER JOIN RowIDMovements_IT_ForSC AS RowIDMovements
	|		ON RowIDMovements.RowID = RowIDInfo.RowID
	|		AND RowIDMovements.Basis = RowIDInfo.Ref";
EndFunction

Function GetDataByFilterSet_IT_ForGR()
	Return
	"SELECT
	|	Doc.ItemKey,
	|	Doc.ItemKey.Item,
	|	Doc.Ref.StoreReceiver,
	|	Doc.Ref,
	|	Doc.Key,
	|	Doc.Key,
	|	CASE
	|		WHEN Doc.ItemKey.Unit.Ref IS NULL
	|			THEN Doc.ItemKey.Item.Unit
	|		ELSE Doc.ItemKey.Unit
	|	END,
	|	RowIDMovements.Quantity,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	Doc.LineNumber
	|FROM
	|	Document.InventoryTransfer.ItemList AS Doc
	|		INNER JOIN Document.InventoryTransfer.RowIDInfo AS RowIDInfo
	|		ON Doc.Ref = RowIDInfo.Ref
	|		AND Doc.Key = RowIDInfo.Key
	|		INNER JOIN RowIDMovements_IT_ForGR AS RowIDMovements
	|		ON RowIDMovements.RowID = RowIDInfo.RowID
	|		AND RowIDMovements.Basis = RowIDInfo.Ref";
EndFunction

Function GetDataByFilterSet_ISR_ForITO_ForPO_ForPI()
	Return
	"SELECT 
	|	Doc.ItemKey,
	|	Doc.ItemKey.Item,
	|	Doc.Ref.Store,
	|	Doc.Ref,
	|	Doc.Key,
	|	Doc.Key,
	|	CASE
	|		WHEN Doc.ItemKey.Unit.Ref IS NULL
	|			THEN Doc.ItemKey.Item.Unit
	|		ELSE Doc.ItemKey.Unit
	|	END AS BasisUnit,
	|	RowIDMovements.Quantity,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	Doc.LineNumber
	|FROM
	|	Document.InternalSupplyRequest.ItemList AS Doc
	|		INNER JOIN Document.InternalSupplyRequest.RowIDInfo AS RowIDInfo
	|		ON Doc.Ref = RowIDInfo.Ref
	|		AND Doc.Key = RowIDInfo.Key
	|		INNER JOIN RowIDMovements_ISR_ForITO_ForPO_ForPI AS RowIDMovements
	|		ON RowIDMovements.RowID = RowIDInfo.RowID
	|		AND RowIDMovements.Basis = RowIDInfo.Ref";
EndFunction

Function GetDataByFilterSet_PhysicalInventory_ForSurplus_ForWriteOff()
	Return
	"SELECT 
	|	Doc.ItemKey,
	|	Doc.ItemKey.Item,
	|	Doc.Ref.Store,
	|	Doc.Ref,
	|	Doc.Key,
	|	Doc.Key,
	|	CASE
	|		WHEN Doc.ItemKey.Unit.Ref IS NULL
	|			THEN Doc.ItemKey.Item.Unit
	|		ELSE Doc.ItemKey.Unit
	|	END AS BasisUnit,
	|	RowIDMovements.Quantity,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	Doc.LineNumber
	|FROM
	|	Document.PhysicalInventory.ItemList AS Doc
	|		INNER JOIN Document.PhysicalInventory.RowIDInfo AS RowIDInfo
	|		ON Doc.Ref = RowIDInfo.Ref
	|		AND Doc.Key = RowIDInfo.Key
	|		INNER JOIN RowIDMovements_PhysicalInventory_ForSurplus_ForWriteOff AS RowIDMovements
	|		ON RowIDMovements.RowID = RowIDInfo.RowID
	|		AND RowIDMovements.Basis = RowIDInfo.Ref";
EndFunction

Function GetDataByFilterSet_SC_ForPR()
	Return
	"SELECT
	|	Doc.ItemKey,
	|	Doc.ItemKey.Item,
	|	Doc.Store,
	|	Doc.Ref,
	|	Doc.Key,
	|	Doc.Key,
	|	CASE
	|		WHEN Doc.ItemKey.Unit.Ref IS NULL
	|			THEN Doc.ItemKey.Item.Unit
	|		ELSE Doc.ItemKey.Unit
	|	END,
	|	RowIDMovements.Quantity,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	Doc.LineNumber
	|FROM
	|	Document.ShipmentConfirmation.ItemList AS Doc
	|		INNER JOIN Document.ShipmentConfirmation.RowIDInfo AS RowIDInfo
	|		ON Doc.Ref = RowIDInfo.Ref
	|		AND Doc.Key = RowIDInfo.Key
	|		INNER JOIN RowIDMovements_SC_ForPR AS RowIDMovements
	|		ON RowIDMovements.RowID = RowIDInfo.RowID
	|		AND RowIDMovements.Basis = RowIDInfo.Ref";
EndFunction

Function GetDataByFilterSet_GR_ForSR()
	Return
	"SELECT
	|	Doc.ItemKey,
	|	Doc.ItemKey.Item,
	|	Doc.Store,
	|	Doc.Ref,
	|	Doc.Key,
	|	Doc.Key,
	|	CASE
	|		WHEN Doc.ItemKey.Unit.Ref IS NULL
	|			THEN Doc.ItemKey.Item.Unit
	|		ELSE Doc.ItemKey.Unit
	|	END,
	|	RowIDMovements.Quantity,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	Doc.LineNumber
	|FROM
	|	Document.GoodsReceipt.ItemList AS Doc
	|		INNER JOIN Document.GoodsReceipt.RowIDInfo AS RowIDInfo
	|		ON Doc.Ref = RowIDInfo.Ref
	|		AND Doc.Key = RowIDInfo.Key
	|		INNER JOIN RowIDMovements_GR_ForSR AS RowIDMovements
	|		ON RowIDMovements.RowID = RowIDInfo.RowID
	|		AND RowIDMovements.Basis = RowIDInfo.Ref";
EndFunction

#EndRegion

#EndRegion

#EndRegion

Function GetBasisesTable(StepArray, FilterValues, FilterSets)				
	Query = New Query;
	FillQueryParameters(Query, FilterValues);
	
	Query.SetParameter("StepArray", StepArray);
	
	Basises = New Array();
	Filter_Basises = False;
	If FilterValues.Property("Basises") And FilterValues.Basises.Count() Then
		Basises = FilterValues.Basises;
		Filter_Basises = True;
	EndIf;
	Query.SetParameter("Basises", Basises);
	Query.SetParameter("Filter_Basises", Filter_Basises);
	
	Ref = Documents.SalesInvoice.EmptyRef();
	Period = Undefined;
	If FilterValues.Property("Ref")	And ValueIsFilled(FilterValues.Ref) Then
		Ref = FilterValues.Ref;
		Period = New Boundary(FilterValues.Ref.PointInTime(), BoundaryType.Excluding);
	EndIf;
	Query.SetParameter("Ref", Ref);
	Query.SetParameter("Period", Period);
	
	Query.TempTablesManager = New TempTablesManager();
	
	QueryArray = New Array();
	QueryArray.Add(
	"SELECT ALLOWED
	|UNDEFINED AS ItemKey,
	|UNDEFINED AS Item,
	|UNDEFINED AS Store,
	|UNDEFINED AS Basis,
	|UNDEFINED AS Key,
	|UNDEFINED AS BasisKey,
	|UNDEFINED AS BasisUnit,
	|UNDEFINED AS QuantityInBaseUnit,
	|UNDEFINED AS RowRef,
	|UNDEFINED AS RowID,
	|UNDEFINED AS CurrentStep,
	|UNDEFINED AS LineNumber
	|INTO AllData
	|WHERE FALSE ");
	
	EnableRequiredFilterSets(FilterSets, Query, QueryArray);
	
	Query.Text = StrConcat(QueryArray, " UNION ALL ");
	
	Query.Text = Query.Text +
	"
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT DISTINCT
	|	AllData.ItemKey,
	|	AllData.Item,
	|	AllData.Store,
	|	AllData.Basis AS Basis,
	|	UNDEFINED AS ParentBasis,
	|	AllData.Key,
	|	AllData.BasisKey,
	|	AllData.BasisUnit,
	|	AllData.QuantityInBaseUnit,
	|	AllData.RowRef,
	|	AllData.RowID,
	|	AllData.CurrentStep,
	|	AllData.LineNumber AS LineNumber
	|FROM
	|	AllData AS AllData
	|ORDER BY
	|	Basis,
	|	LineNumber
	|AUTOORDER";
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	
	Return QueryTable;
EndFunction

Procedure FillQueryParameters(Query, FilterValues)
	For Each Attribute In Metadata.Catalogs.RowIDs.Attributes Do
		Value = Undefined; Use = False;
		If FilterValues.Property(Attribute.Name) And ValueIsFilled(FilterValues[Attribute.Name]) Then
			Value = FilterValues[Attribute.Name];
			Use = True;
		EndIf;
		Query.SetParameter("Filter_" + Attribute.Name, Use);
		Query.SetParameter(Attribute.Name, Value);
	EndDo;
EndProcedure	

#EndRegion

#Region AddLinkUnlinkDocumentRow

Procedure AddLinkedDocumentRows(Object, FillingValues) Export
	FillingValue = GetFillingValue(FillingValues);
	If FillingValue = Undefined Then
		Return;
	EndIf;
	
	TableNames_Refreshable = GetTableNames_Refreshable();
	
	For Each Row_ItemList In FillingValue.ItemList Do
		NewKey = String(New UUID());
		
		For Each TableName In TableNames_Refreshable Do
			If Not FillingValue.Property(TableName) Then
				Continue;
			EndIf;
			For Each Row In FillingValue[TableName] Do
				If CommonFunctionsClientServer.ObjectHasProperty(Row, "Key") 
					And Row.Key = Row_ItemList.Key Then
					Row.Key = NewKey;
				EndIf;
			EndDo;
		EndDo;
		Row_ItemList.Key = NewKey;
	EndDo;
	
	TableNames_Refreshable.Add("ItemList");
	
	For Each TableName In TableNames_Refreshable Do
		If FillingValue.Property(TableName) 
			And CommonFunctionsClientServer.ObjectHasProperty(Object, TableName) Then
			For Each Row In FillingValue[TableName] Do
				FillPropertyValues(Object[TableName].Add(), Row);
			EndDo;
		EndIf;
	EndDo;
EndProcedure

Procedure LinkUnlinkDocumentRows(Object, FillingValues) Export
	
	// Tables with linked documents, will be cleaning on unlink
	TableNames_LinkedDocuments = GetTableNames_LinkedDocuments();
	
	// ItemList attributes with refs to linked documents
	AttributeNames_LinkedDocuments = GetAttributeNames_LinkedDocuments();
	
	// Refreshable tables on unlink documents
	TableNames_Refreshable = GetTableNames_Refreshable();
	
	FillingValue = GetFillingValue(FillingValues);
	If FillingValue = Undefined Then
		UnlinkRows = New Array();
		For Each OldRow In Object.RowIDInfo Do
			UnlinkRows.Add(OldRow);
		EndDo;
		Unlink(Object, UnlinkRows, TableNames_LinkedDocuments, AttributeNames_LinkedDocuments);
		Object.RowIDInfo.Clear();
		Return;
	EndIf;
	
	// Unlink
	UnlinkRows = GetUnlinkRows(Object, FillingValue);
	Unlink(Object, UnlinkRows, TableNames_LinkedDocuments, AttributeNames_LinkedDocuments);
		
	// Link
	LinkRows = GetLinkRows(Object, FillingValue);
	Link(Object, FillingValue, LinkRows, TableNames_Refreshable);
	
	Object.RowIDInfo.Clear();
	For Each Row In FillingValue.RowIDInfo Do
		FillPropertyValues(Object.RowIDInfo.Add(), Row);
	EndDo;	
EndProcedure

Function GetFillingValue(FillingValues)
	If TypeOf(FillingValues) = Type("Structure") Then
		Return FillingValues;
	ElsIf TypeOf(FillingValues) = Type("Array") And FillingValues.Count() = 1 Then
		Return FillingValues[0];
	EndIf;
	Return Undefined;
EndFunction

#Region Unlink

Procedure Unlink(Object, UnlinkRows, TableNames, AttributeNames)
	For Each UnlinkRow In UnlinkRows Do
		UnlinkTables(Object, UnlinkRow, TableNames);
		
		// Clear attributes in ItemList
		LinkedRows = Object.ItemList.FindRows(New Structure("Key", UnlinkRow.Key));
		For Each LinkedRow In LinkedRows Do			
			If Not IsCanUnlinkAttributes(Object, UnlinkRow, TableNames) Then
				Continue;
			EndIf;
			UnlinkAttributes(LinkedRow, AttributeNames);
		EndDo;
	EndDo;
EndProcedure

Function GetUnlinkRows(Object, FillingValue)
	UnlinkRows = New Array();
	For Each OldRow In Object.RowIDInfo Do
		IsUnlink = True;
		For Each NewRow In FillingValue.RowIDInfo Do
			If OldRow.Key = NewRow.Key 
				And OldRow.BasisKey = NewRow.BasisKey 
				And OldRow.Basis = NewRow.Basis Then
				IsUnlink = False;
				Break;
			EndIf;
		EndDo;		
		If IsUnlink Then
			UnlinkRows.Add(OldRow);
		EndIf;
	EndDo;
	Return UnlinkRows;
EndFunction

Procedure UnlinkTables(Object, UnlinkRow, TableNames)
	For Each TableName In TableNames Do
		If Not Object.Property(TableName) Then
			Continue;
		EndIf;
			
		Filter = New Structure("Key, BasisKey", UnlinkRow.Key, UnlinkRow.BasisKey);
		LinkedRows = Object[TableName].FindRows(Filter);
			
		For Each LinkedRow In LinkedRows Do
			Object[TableName].Delete(LinkedRow);
		EndDo;
	EndDo;
EndProcedure

Function IsCanUnlinkAttributes(Object, UnlinkRow, TableNames)
	IsCanUnlink = True;
	For Each TableName In TableNames Do
		If Not Object.Property(TableName) Then
			Continue;
		EndIf;
			
		Filter = New Structure("Key", UnlinkRow.Key);
		LinkedRows = Object[TableName].FindRows(Filter);
		If LinkedRows.Count() Then
			IsCanUnlink = False;
			Break;
		EndIf;
	EndDo;
	Return IsCanUnlink;
EndFunction

Procedure UnlinkAttributes(LinkedRow, AttributeNames)
	For Each AttributeName In AttributeNames Do
		If LinkedRow.Property(AttributeName) Then
			LinkedRow[AttributeName] = Undefined;
		EndIf;
	EndDo;
EndProcedure

#EndRegion

#Region Link

Procedure Link(Object, FillingValue, LinkRows, TableNames)
	For Each LinkRow In LinkRows Do
		// Update ItemList row
		LinkAttributes(Object, FillingValue, LinkRow);
		
		// Update tables
		LinkTables(Object, FillingValue, LinkRow, TableNames);		
	EndDo;
EndProcedure	

Function GetLinkRows(Object, FillingValue)
	LinkRows = New Array();
	For Each NewRow In FillingValue.RowIDInfo Do
		IsLink = True;
		For Each OldRow In Object.RowIDInfo Do
			If NewRow.Key = OldRow.Key
				And NewRow.BasisKey = OldRow.BasisKey
				And NewRow.Basis = OldRow.Basis Then
				IsLink = False;
				Break;
			EndIf;
		EndDo;
		If IsLink Then
			LinkRows.Add(NewRow);
		EndIf;
	EndDo;	
	Return LinkRows;
EndFunction

Procedure LinkTables(Object, FillingValue, LinkRow, TableNames)
	For Each TableName In TableNames Do
		If Upper(TableName) = Upper("RowIDInfo") Then
			Continue;
		EndIf;
		If Object.Property(TableName) Then
			For Each DeletionRow In Object[TableName].FindRows(New Structure("Key", LinkRow.Key)) Do
				Object[TableName].Delete(DeletionRow);
			EndDo;
		Else
			Continue;
		EndIf;
			
		If Not FillingValue.Property(TableName) Then
			Continue;
		EndIf;
				
		For Each Row In FillingValue[TableName] Do
			If Row.Key = LinkRow.Key Then
				FillPropertyValues(Object[TableName].Add(), Row);
			EndIf;
		EndDo;
	EndDo;
EndProcedure

Procedure LinkAttributes(Object, FillingValue, LinkRow)
	For Each Row_ItemLIst In FillingValue.ItemList Do
		If LinkRow.Key <> Row_ItemList.Key Then
			Continue;
		EndIf;
		For Each Row In Object.ItemList.FindRows(New Structure("Key", LinkRow.Key)) Do
				FillPropertyValues(Row, Row_ItemList);
		EndDo;
	EndDo;
EndProcedure

#EndRegion

#EndRegion

#Region DataToFillingValues

Function GetSeperatorColumns(DocReceiverMetadata) Export
	If DocReceiverMetadata = Metadata.Documents.SalesInvoice Then
		Return "Partner, Company, Currency, Agreement, PriceIncludeTax, ManagerSegment, LegalName";
	ElsIf DocReceiverMetadata = Metadata.Documents.ShipmentConfirmation Then
		Return "Company, Partner, LegalName, TransactionType";
	ElsIf DocReceiverMetadata = Metadata.Documents.PurchaseOrder Then
		Return "Company";
	ElsIf DocReceiverMetadata = Metadata.Documents.PurchaseInvoice Then
		Return "Company, Partner, LegalName, Agreement, Currency, PriceIncludeTax";
	ElsIf DocReceiverMetadata = Metadata.Documents.GoodsReceipt Then
		Return "Company, Partner, LegalName, TransactionType";
	ElsIf DocReceiverMetadata = Metadata.Documents.InventoryTransfer Then
		Return "Company, BusinessUnit, StoreSender, StoreReceiver";	 
	ElsIf DocReceiverMetadata = Metadata.Documents.InventoryTransferOrder Then
		Return "Company, BusinessUnit, StoreReceiver";
	ElsIf DocReceiverMetadata = Metadata.Documents.StockAdjustmentAsSurplus Then
		Return "Store";
	ElsIf DocReceiverMetadata = Metadata.Documents.StockAdjustmentAsWriteOff Then
		Return "Store";
	ElsIf DocReceiverMetadata = Metadata.Documents.SalesReturn Then
		Return "Company, Partner, LegalName, Agreement, Currency, PriceIncludeTax";
	ElsIf DocReceiverMetadata = Metadata.Documents.PurchaseReturn Then
		Return "Company, Partner, LegalName, Agreement, Currency, PriceIncludeTax";
	EndIf;
EndFunction	

Function ConvertDataToFillingValues(DocReceiverMetadata, ExtractedData) Export

	Tables = JoinAllExtractedData(ExtractedData);
	
	TableNames_Refreshable = GetTableNames_Refreshable();
		
	SeparatorColumns = GetSeperatorColumns(DocReceiverMetadata);
	
	UniqueRows = Tables.ItemList.Copy();
	UniqueRows.GroupBy(SeparatorColumns);
	
	FullFilledUniqueRows = New Array();
	For Each UniqueRow In UniqueRows Do
		AllColumnsIsNotUndefined = True;
		For Each Column In UniqueRows.Columns Do
			If UniqueRow[Column.Name] = Undefined Then
				AllColumnsIsNotUndefined = False;
				Break;
			EndIf;
		EndDo;
		
		If AllColumnsIsNotUndefined Then
			FullFilledUniqueRows.Add(UniqueRow);
		EndIf;	
	EndDo;
	
	If FullFilledUniqueRows.Count() = 1 Then
		For Each Column In UniqueRows.Columns Do
			For Each UniqueRow In UniqueRows Do
				UniqueRow[Column.Name] = FullFilledUniqueRows[0][Column.Name]; 
			EndDo;
			For Each RowItemList In Tables.ItemList Do
				RowItemList[Column.Name] = FullFilledUniqueRows[0][Column.Name];
			EndDo;
		EndDo;
		UniqueRows.GroupBy(SeparatorColumns);
	EndIf;	
		
	MainFilter = New Structure(SeparatorColumns);
	ArrayOfFillingValues = New Array();
	
	For Each UniqueRow In UniqueRows Do
		FillPropertyValues(MainFilter, UniqueRow);
		TablesFilters = New Array();
		
		FillingValues = New Structure(SeparatorColumns);
		FillPropertyValues(FillingValues, UniqueRow);			
		
		FillingValues.Insert("ItemList", New Array());
		For Each TableName_Refreshable In TableNames_Refreshable Do
			FillingValues.Insert(TableName_Refreshable, New Array());
		EndDo;
				
		For Each RowItemList In Tables.ItemList.Copy(MainFilter) Do
			TablesFilters.Add(New Structure("Ref, Key", RowItemList.Ref, RowItemList.Key));			
			FillingValues.ItemList.Add(ValueTableRowToStructure(Tables.ItemList.Columns, RowItemList));
		EndDo;
		
		For Each TableFilter In TablesFilters Do
			For Each TableName_Refreshable In TableNames_Refreshable Do
				If Not CommonFunctionsClientServer.ObjectHasProperty(Tables, TableName_Refreshable) Then
					Continue;
				EndIf;
				For Each Row_DepTable In Tables[TableName_Refreshable].Copy(TableFilter) Do
					FillingValues[TableName_Refreshable].Add(ValueTableRowToStructure(Tables[TableName_Refreshable].Columns, Row_DepTable));
				EndDo;
			EndDo;
		EndDo;
		FillingValues.Insert("BasedOn", True);
		ArrayOfFillingValues.Add(FillingValues);
	EndDo;	
	Return ArrayOfFillingValues;
EndFunction

Function JoinAllExtractedData(ArrayOfData)
	Tables = New Structure();
	Tables.Insert("ItemList"              , GetEmptyTable_ItemList());
	Tables.Insert("RowIDInfo"             , GetEmptyTable_RowIDInfo());
	Tables.Insert("TaxList"               , GetEmptyTable_TaxList());
	Tables.Insert("SpecialOffers"         , GetEmptyTable_SpecialOffers());
	Tables.Insert("ShipmentConfirmations" , GetEmptyTable_ShipmentConfirmations());
	Tables.Insert("GoodsReceipts"         , GetEmptyTable_GoodsReceipts());
	For Each Data In ArrayOfData Do
		For Each Table In Tables Do
			If Data.Property(Table.Key) Then
				CopyTable(Table.Value, Data[Table.Key]);
			EndIf;
		EndDo;
	EndDo;
	Return Tables;
EndFunction

Function GetTableNames_Refreshable()
	NamesArray = New Array();
	NamesArray.Add("RowIDInfo");
	NamesArray.Add("TaxList");
	NamesArray.Add("SpecialOffers");
	NamesArray.Add("ShipmentConfirmations");
	NamesArray.Add("GoodsReceipts");
	Return NamesArray;
EndFunction

Function GetTableNames_LinkedDocuments()
	NamesArray = New Array();
	NamesArray.Add("ShipmentConfirmations");
	NamesArray.Add("GoodsReceipts");
	Return NamesArray;
EndFunction

Function GetAttributeNames_LinkedDocuments()	
	NamesArray = New Array();
	NamesArray.Add("SalesOrder");
	NamesArray.Add("ShipmentBasis");
	NamesArray.Add("PurchaseBasis");
	NamesArray.Add("SalesInvoice");
	NamesArray.Add("PurchaseOrder");
	NamesArray.Add("ReceiptBasis");
	NamesArray.Add("PurchaseInvoice");
	NamesArray.Add("InternalSupplyRequest");
	NamesArray.Add("InventoryTransferOrder");
	NamesArray.Add("InventoryTransfer");
	NamesArray.Add("PhysicalInventory");
	NamesArray.Add("BasisDocument");
	Return NamesArray;
EndFunction

Procedure CopyTable(Receiver, Source)
	For Each Row In Source Do
		FillPropertyValues(Receiver.Add(), Row);
	EndDo;
EndProcedure

Function ValueTableRowToStructure(Columns,Row)
	Result = New Structure();
	For Each Column In Columns Do
		Result.Insert(Column.Name, Row[Column.Name]);
	EndDo;
	Return Result;
EndFunction

#Region EmptyTables

Function GetEmptyTable(Columns)
	Table = New ValueTable();
	For Each Column In StrSplit(Columns, ",") Do
		Table.Columns.Add(TrimAll(Column));
	EndDo;
	Return Table;	
EndFunction

#Region EmptyTables_ItemList

Function GetColumnNames_ItemList()
	Return
	"Ref,
	|Key,
	|BasedOn,
	|Company,
	|Partner,
	|LegalName,
	|Agreement,
	|Currency,
	|PriceIncludeTax,
	|ManagerSegment,
	|Store,
	|ItemKey,
	|Item,
	|SalesOrder,
	|PurchaseBasis,
	|ShipmentBasis,
	|SalesInvoice,
	|PurchaseOrder,
	|ReceiptBasis,
	|PurchaseInvoice,
	|Unit,
	|PriceType,
	|Price,
	|DeliveryDate,
	|DontCalculateRow,
	|BusinessUnit,
	|RevenueType,
	|ExpenseType,
	|Detail,
	|UseShipmentConfirmation,
	|UseGoodsReceipt,
	|TransactionType,
	|InternalSupplyRequest,
	|InventoryTransferOrder,
	|InventoryTransfer,
	|StoreSender,
	|StoreReceiver,
	|PhysicalInventory,
	|BasisDocument";
EndFunction

Function GetEmptyTable_ItemList()
	Return GetEmptyTable(GetColumnNames_ItemList() + ", " + GetColumnNamesSum_ItemList());
EndFunction

Function GetColumnNamesSum_ItemList()
	Return "Quantity, QuantityInBaseUnit, TaxAmount, TotalAmount, NetAmount, OffersAmount";
EndFunction

#EndRegion

#Region EmptyTables_RowIDInfo

Function GetColumnNames_RowIDInfo()
	Return "Ref, Key, RowID, BasisKey, Basis, CurrentStep, NextStep, RowRef";
EndFunction

Function GetColumnNamesSum_RowIDInfo()
	Return "Quantity";
EndFunction

Function GetEmptyTable_RowIDInfo()
	Return GetEmptyTable(GetColumnNames_RowIDInfo() + ", " + GetColumnNamesSum_RowIDInfo());
EndFunction

#EndRegion

#Region EmptyTables_TaxList

Function GetColumnNames_TaxList()
	Return "Ref, Key, Tax, Analytics, TaxRate, IncludeToTotalAmount";
EndFunction

Function GetColumnNamesSum_TaxList()
	Return "Amount, ManualAmount";
EndFunction

Function GetEmptyTable_TaxList()
	Return GetEmptyTable(GetColumnNames_TaxList() + ", " + GetColumnNamesSum_TaxList());
EndFunction

#EndRegion

#Region EmptyTables_SpecialOffers

Function GetColumnNames_SpecialOffers()
	Return "Ref, Key, Offer, Percent";
EndFunction

Function GetColumnNamesSum_SpecialOffers()
	Return "Amount";
EndFunction
	
Function GetEmptyTable_SpecialOffers()
	Return GetEmptyTable(GetColumnNames_SpecialOffers() + ", " + GetColumnNamesSum_SpecialOffers());
EndFunction

#EndRegion

#Region EmptyTables_ShipmentConfirmations

Function GetColumnNames_ShipmentConfirmations()
	Return "Ref, Key, BasisKey, ShipmentConfirmation";
EndFunction

Function GetColumnNamesSum_ShipmentConfirmations()
	Return "Quantity, QuantityInShipmentConfirmation";
EndFunction

Function GetEmptyTable_ShipmentConfirmations()
	Return GetEmptyTable(GetColumnNames_ShipmentConfirmations() + ", " + GetColumnNamesSum_ShipmentConfirmations());
EndFunction

#EndRegion

#Region EmptyTables_GoodsReceipts

Function GetColumnNames_GoodsReceipts()
	Return "Ref, Key, BasisKey, GoodsReceipt";
EndFunction

Function GetColumnNamesSum_GoodsReceipts()
	Return "Quantity, QuantityInGoodsReceipt";
EndFunction

Function GetEmptyTable_GoodsReceipts()
	Return GetEmptyTable(GetColumnNames_GoodsReceipts() + ", " + GetColumnNamesSum_GoodsReceipts());
EndFunction

#EndRegion

#EndRegion

#EndRegion

#Region BasisesTree

&AtServer
Function CreateBasisesTree(TreeReverseInfo, BasisesTable, ResultsTable, BasisesTreeRows) Export
	TreeReverse = TreeReverseInfo.Tree;
	
	BasisTable = New ValueTable();
	BasisTable.Columns.Add("Basis");
	
	FilterTable = New ValueTable();
	FilterTable.Columns.Add("Basis");
	FilterTable.Columns.Add("Level");
	FilterTable.Columns.Add("BasisKey");
	FilterTable.Columns.Add("RowID");
	FilterTable.Columns.Add("RowRef");
	
	LastRows = TreeReverse.Rows.FindRows(New Structure("LastRow", True), True);
	If Not LastRows.Count() Then
		Return Undefined;
	EndIf;
	
	For Each LastRow In LastRows Do
		LastRow.LastRow = False;
		
		FillPropertyValues(BasisTable.Add(), LastRow);
		
		NewFilterRow = FilterTable.Add();
		FillPropertyValues(NewFilterRow, LastRow);
		NewFilterRow.Level    = LastRow.Level - 1;
		NewFilterRow.BasisKey = LastRow.Key;
	EndDo;
	
	BasisTable.GroupBy("Basis");
	FilterTable.GroupBy("Basis, Level, BasisKey, RowID, RowRef");
		
	For Each RowBasis In BasisTable Do
		NewBasisesTreeRow = BasisesTreeRows.Add();
		NewBasisesTreeRow.Picture = 1;
		NewBasisesTreeRow.RowPresentation = String(RowBasis.Basis);
		
		FillPropertyValues(NewBasisesTreeRow, RowBasis);
		
		For Each RowFilter In FilterTable.FindRows(New Structure("Basis", RowBasis.Basis)) Do
		
			ParentFilter = New Structure("Level, BasisKey, RowID, RowRef");
			FillPropertyValues(ParentFilter, RowFilter);
			ParentRows = TreeReverse.Rows.FindRows(ParentFilter, True);
		
			If Not ParentRows.Count() Then
				BasisesFilter = New Structure();
				BasisesFilter.Insert("BasisKey" , RowFilter.BasisKey);
				BasisesFilter.Insert("RowID"    , RowFilter.RowID);
				BasisesFilter.Insert("RowRef"   , RowFilter.RowRef);
				BasisesFilter.Insert("Basis"    , RowFilter.Basis);
				For Each TableRow In BasisesTable.FindRows(BasisesFilter) Do
					
					// deep level
					DeepLevelRow = NewBasisesTreeRow.GetItems().Add();
					DeepLevelRow.Picture = 0;
					DeepLevelRow.RowPresentation =
					String(TableRow.Item) + ", " + String(TableRow.ItemKey);
					
					DeepLevelRow.DeepLevel = True;
					FillPropertyValues(DeepLevelRow, TableRow);
					
					// price, currency, unit
					BasisesInfoFilter = New Structure("RowID", TableRow.RowID);
					For Each InfoRow In TreeReverseInfo.BasisesInfoTable.FindRows(BasisesInfoFilter) Do
						FillPropertyValues(DeepLevelRow, InfoRow);
					EndDo;
					
					DeepLevelRow.Quantity = Catalogs.Units.Convert(DeepLevelRow.BasisUnit, 
						DeepLevelRow.Unit, DeepLevelRow.QuantityInBaseUnit);
						
						
					ResultsFilter = New Structure();
					ResultsFilter.Insert("RowID"    , DeepLevelRow.RowID);
					ResultsFilter.Insert("BasisKey" , DeepLevelRow.Key);
					ResultsFilter.Insert("Basis"    , DeepLevelRow.Basis);
					If ResultsTable.FindRows(ResultsFilter).Count() Then
						DeepLevelRow.Use = True;
						DeepLevelRow.Linked = True;
					EndIf;
			
				EndDo;
			Else
				For Each ParentRow In ParentRows Do
					ParentRow.LastRow = True;
				EndDo;
				
			EndIf; // ParentRows.Count()
		
		EndDo; // FilterTable
	
			CreateBasisesTree(TreeReverseInfo, BasisesTable, ResultsTable, NewBasisesTreeRow.GetItems());
		
	EndDo; // BasisTable
EndFunction

Function CreateBasisesTreeReverse(BasisesTable) Export
	Tree = New ValueTree();
	Tree.Columns.Add("Key");
	Tree.Columns.Add("Basis");
	Tree.Columns.Add("RowRef");
	Tree.Columns.Add("RowID");
	Tree.Columns.Add("BasisKey");
	
	Tree.Columns.Add("Price");
	Tree.Columns.Add("Currency");
	Tree.Columns.Add("Unit");
	
	Tree.Columns.Add("Level");
	Tree.Columns.Add("LastRow");
	
	For Each TableRow In BasisesTable Do
		
		BasisesInfo = GetBasisesInfo(TableRow.Basis, TableRow.BasisKey, TableRow.RowID);
			
		//top level
		Level = 1;
		NewTreeRow = Tree.Rows.Add();
		NewTreeRow.Level = Level;
			
		FillPropertyValues(NewTreeRow, BasisesInfo);
		
		CreateBasisesTreeReverseRecursive(BasisesInfo, NewTreeRow.Rows, Level);
		
		If Not NewTreeRow.Rows.Count() Then
			NewTreeRow.LastRow = True;
		EndIf;
			
	EndDo;
		
	BasisesInfoTable = New ValueTable();
	BasisesInfoTable.Columns.Add("RowID");
	BasisesInfoTable.Columns.Add("Price");
	BasisesInfoTable.Columns.Add("Currency");
	BasisesInfoTable.Columns.Add("Unit");
	
	LastRows =  Tree.Rows.FindRows(New Structure("LastRow", True), True);
	For Each LastRow In LastRows Do
		FillPropertyValues(BasisesInfoTable.Add(), LastRow);
	EndDo;
		
	Return New Structure("Tree, BasisesInfoTable", Tree, BasisesInfoTable);
EndFunction

Procedure CreateBasisesTreeReverseRecursive(BasisesInfo, TreeRows, Level)
	If BasisesInfo.Basis <> BasisesInfo.RowRef.Basis Then
		ParentBasisInfo = GetBasisesInfo(BasisesInfo.ParentBasis, BasisesInfo.BasisKey, BasisesInfo.RowID);
		Level = Level + 1;
		NewTreeRow = TreeRows.Add();
		NewTreeRow.Level = Level;
		
		FillPropertyValues(NewTreeRow, ParentBasisInfo);
		
		CreateBasisesTreeReverseRecursive(ParentBasisInfo, NewTreeRow.Rows, Level);
		
		If Not NewTreeRow.Rows.Count() Then
			NewTreeRow.LastRow = True;
		EndIf;
		
	EndIf;
EndProcedure

Function GetBasisesInfo(Basis, BasisKey, RowID)
	Query = New Query();
	
	If Is(Basis).SO Then
		Query.Text = GetBasisesInfoQueryText_SO();
	ElsIf Is(Basis).SI Then
		Query.Text = GetBasisesInfoQueryText_SI();
	ElsIf Is(Basis).SC Then
		Query.Text = GetBasisesInfoQueryText_SC();
	ElsIf Is(Basis).PO Then
		Query.Text = GetBasisesInfoQueryText_PO();
	ElsIf Is(Basis).PI Then
		Query.Text = GetBasisesInfoQueryText_PI();
	ElsIf Is(Basis).GR Then
		Query.Text = GetBasisesInfoQueryText_GR();
	ElsIf Is(Basis).ITO Then
		Query.Text = GetBasisesInfoQueryText_ITO();
	ElsIf Is(Basis).IT Then
		Query.Text = GetBasisesInfoQueryText_IT();
	ElsIf Is(Basis).ISR Then
		Query.Text = GetBasisesInfoQueryText_ISR();
	ElsIf Is(Basis).PhysicalInventory Then
		Query.Text = GetBasisesInfoQueryText_PhysicalInventory();
	ElsIf Is(Basis).PR Then
		Query.Text = GetBasisesInfoQueryText_PR();
	ElsIf Is(Basis).PRO Then
		Query.Text = GetBasisesInfoQueryText_PRO();
	ElsIf Is(Basis).SR Then
		Query.Text = GetBasisesInfoQueryText_SR();
	ElsIf Is(Basis).SRO Then
		Query.Text = GetBasisesInfoQueryText_SRO();								
	EndIf;
	
	Query.SetParameter("Basis"    , Basis);
	Query.SetParameter("BasisKey" , BasisKey);
	Query.SetParameter("RowID"    , RowID);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	BasisInfo = New Structure("Key, Basis, RowRef, RowID, ParentBasis, BasisKey, Price, Currency, Unit");
	If QuerySelection.Next() Then
		FillPropertyValues(BasisInfo, QuerySelection);
	EndIf;
	Return BasisInfo;
EndFunction

Function GetBasisesInfoQueryText_SO()
	Return
	"SELECT
	|	RowIDInfo.Ref AS Basis,
	|	RowIDInfo.RowRef AS RowRef,
	|	RowIDInfo.BasisKey AS BasisKey,
	|	RowIDInfo.RowID AS RowID,
	|	RowIDInfo.Basis AS ParentBasis,
	|	ItemList.Key AS Key,
	|	ItemList.Price AS Price,
	|	ItemList.Ref.Currency AS Currency,
	|	ItemList.Unit AS Unit
	|FROM
	|	Document.SalesOrder.ItemList AS ItemList
	|		INNER JOIN Document.SalesOrder.RowIDInfo AS RowIDInfo
	|		ON RowIDInfo.Ref = &Basis
	|		AND ItemList.Ref = &Basis
	|		AND RowIDInfo.Key = &BasisKey
	|		AND ItemList.Key = &BasisKey
	|		AND RowIDInfo.Key = ItemList.Key
	|		AND RowIDInfo.Ref = ItemList.Ref
	|		AND RowIDInfo.RowID = &RowID";
EndFunction

Function GetBasisesInfoQueryText_SC()
	Return
	"SELECT
	|	RowIDInfo.Ref AS Basis,
	|	RowIDInfo.RowRef AS RowRef,
	|	RowIDInfo.BasisKey AS BasisKey,
	|	RowIDInfo.RowID AS RowID,
	|	RowIDInfo.Basis AS ParentBasis,
	|	ItemList.Key AS Key,
	|	0 AS Price,
	|	UNDEFINED AS Currency,
	|	ItemList.Unit AS Unit
	|FROM
	|	Document.ShipmentConfirmation.ItemList AS ItemList
	|		INNER JOIN Document.ShipmentConfirmation.RowIDInfo AS RowIDInfo
	|		ON RowIDInfo.Ref = &Basis
	|		AND ItemList.Ref = &Basis
	|		AND RowIDInfo.Key = &BasisKey
	|		AND ItemList.Key = &BasisKey
	|		AND RowIDInfo.Key = ItemList.Key
	|		AND RowIDInfo.Ref = ItemList.Ref
	|		AND RowIDInfo.RowID = &RowID";
EndFunction

Function GetBasisesInfoQueryText_SI()
	Return
	"SELECT
	|	RowIDInfo.Ref AS Basis,
	|	RowIDInfo.RowRef AS RowRef,
	|	RowIDInfo.BasisKey AS BasisKey,
	|	RowIDInfo.RowID AS RowID,
	|	RowIDInfo.Basis AS ParentBasis,
	|	ItemList.Key AS Key,
	|	ItemList.Price AS Price,
	|	ItemList.Ref.Currency AS Currency,
	|	ItemList.Unit AS Unit
	|FROM
	|	Document.SalesInvoice.ItemList AS ItemList
	|		INNER JOIN Document.SalesInvoice.RowIDInfo AS RowIDInfo
	|		ON RowIDInfo.Ref = &Basis
	|		AND ItemList.Ref = &Basis
	|		AND RowIDInfo.Key = &BasisKey
	|		AND ItemList.Key = &BasisKey
	|		AND RowIDInfo.Key = ItemList.Key
	|		AND RowIDInfo.Ref = ItemList.Ref
	|		AND RowIDInfo.RowID = &RowID";
EndFunction

Function GetBasisesInfoQueryText_PO()
	Return
	"SELECT
	|	RowIDInfo.Ref AS Basis,
	|	RowIDInfo.RowRef AS RowRef,
	|	RowIDInfo.BasisKey AS BasisKey,
	|	RowIDInfo.RowID AS RowID,
	|	RowIDInfo.Basis AS ParentBasis,
	|	ItemList.Key AS Key,
	|	ItemList.Price AS Price,
	|	ItemList.Ref.Currency AS Currency,
	|	ItemList.Unit AS Unit
	|FROM
	|	Document.PurchaseOrder.ItemList AS ItemList
	|		INNER JOIN Document.PurchaseOrder.RowIDInfo AS RowIDInfo
	|		ON RowIDInfo.Ref = &Basis
	|		AND ItemList.Ref = &Basis
	|		AND RowIDInfo.Key = &BasisKey
	|		AND ItemList.Key = &BasisKey
	|		AND RowIDInfo.Key = ItemList.Key
	|		AND RowIDInfo.Ref = ItemList.Ref
	|		AND RowIDInfo.RowID = &RowID";
EndFunction

Function GetBasisesInfoQueryText_GR()
	Return
	"SELECT
	|	RowIDInfo.Ref AS Basis,
	|	RowIDInfo.RowRef AS RowRef,
	|	RowIDInfo.BasisKey AS BasisKey,
	|	RowIDInfo.RowID AS RowID,
	|	RowIDInfo.Basis AS ParentBasis,
	|	ItemList.Key AS Key,
	|	0 AS Price,
	|	UNDEFINED AS Currency,
	|	ItemList.Unit AS Unit
	|FROM
	|	Document.GoodsReceipt.ItemList AS ItemList
	|		INNER JOIN Document.GoodsReceipt.RowIDInfo AS RowIDInfo
	|		ON RowIDInfo.Ref = &Basis
	|		AND ItemList.Ref = &Basis
	|		AND RowIDInfo.Key = &BasisKey
	|		AND ItemList.Key = &BasisKey
	|		AND RowIDInfo.Key = ItemList.Key
	|		AND RowIDInfo.Ref = ItemList.Ref
	|		AND RowIDInfo.RowID = &RowID";
EndFunction

Function GetBasisesInfoQueryText_PI()
	Return 
	"SELECT
	|	RowIDInfo.Ref AS Basis,
	|	RowIDInfo.RowRef AS RowRef,
	|	RowIDInfo.BasisKey AS BasisKey,
	|	RowIDInfo.RowID AS RowID,
	|	RowIDInfo.Basis AS ParentBasis,
	|	ItemList.Key AS Key,
	|	ItemList.Price AS Price,
	|	ItemList.Ref.Currency AS Currency,
	|	ItemList.Unit AS Unit
	|FROM
	|	Document.PurchaseInvoice.ItemList AS ItemList
	|		INNER JOIN Document.PurchaseInvoice.RowIDInfo AS RowIDInfo
	|		ON RowIDInfo.Ref = &Basis
	|		AND ItemList.Ref = &Basis
	|		AND RowIDInfo.Key = &BasisKey
	|		AND ItemList.Key = &BasisKey
	|		AND RowIDInfo.Key = ItemList.Key
	|		AND RowIDInfo.Ref = ItemList.Ref
	|		AND RowIDInfo.RowID = &RowID";
EndFunction

Function GetBasisesInfoQueryText_ITO()
	Return
	"SELECT
	|	RowIDInfo.Ref AS Basis,
	|	RowIDInfo.RowRef AS RowRef,
	|	RowIDInfo.BasisKey AS BasisKey,
	|	RowIDInfo.RowID AS RowID,
	|	RowIDInfo.Basis AS ParentBasis,
	|	ItemList.Key AS Key,
	|	0 AS Price,
	|	UNDEFINED AS Currency,
	|	ItemList.Unit AS Unit
	|FROM
	|	Document.InventoryTransferOrder.ItemList AS ItemList
	|		INNER JOIN Document.InventoryTransferOrder.RowIDInfo AS RowIDInfo
	|		ON RowIDInfo.Ref = &Basis
	|		AND ItemList.Ref = &Basis
	|		AND RowIDInfo.Key = &BasisKey
	|		AND ItemList.Key = &BasisKey
	|		AND RowIDInfo.Key = ItemList.Key
	|		AND RowIDInfo.Ref = ItemList.Ref
	|		AND RowIDInfo.RowID = &RowID";
EndFunction

Function GetBasisesInfoQueryText_IT()
	Return
	"SELECT
	|	RowIDInfo.Ref AS Basis,
	|	RowIDInfo.RowRef AS RowRef,
	|	RowIDInfo.BasisKey AS BasisKey,
	|	RowIDInfo.RowID AS RowID,
	|	RowIDInfo.Basis AS ParentBasis,
	|	ItemList.Key AS Key,
	|	0 AS Price,
	|	UNDEFINED AS Currency,
	|	ItemList.Unit AS Unit
	|FROM
	|	Document.InventoryTransfer.ItemList AS ItemList
	|		INNER JOIN Document.InventoryTransfer.RowIDInfo AS RowIDInfo
	|		ON RowIDInfo.Ref = &Basis
	|		AND ItemList.Ref = &Basis
	|		AND RowIDInfo.Key = &BasisKey
	|		AND ItemList.Key = &BasisKey
	|		AND RowIDInfo.Key = ItemList.Key
	|		AND RowIDInfo.Ref = ItemList.Ref
	|		AND RowIDInfo.RowID = &RowID";
EndFunction

Function GetBasisesInfoQueryText_ISR()
	Return
	"SELECT
	|	RowIDInfo.Ref AS Basis,
	|	RowIDInfo.RowRef AS RowRef,
	|	RowIDInfo.BasisKey AS BasisKey,
	|	RowIDInfo.RowID AS RowID,
	|	RowIDInfo.Basis AS ParentBasis,
	|	ItemList.Key AS Key,
	|	0 AS Price,
	|	UNDEFINED AS Currency,
	|	ItemList.Unit AS Unit
	|FROM
	|	Document.InternalSupplyRequest.ItemList AS ItemList
	|		INNER JOIN Document.InternalSupplyRequest.RowIDInfo AS RowIDInfo
	|		ON RowIDInfo.Ref = &Basis
	|		AND ItemList.Ref = &Basis
	|		AND RowIDInfo.Key = &BasisKey
	|		AND ItemList.Key = &BasisKey
	|		AND RowIDInfo.Key = ItemList.Key
	|		AND RowIDInfo.Ref = ItemList.Ref
	|		AND RowIDInfo.RowID = &RowID";
EndFunction

Function GetBasisesInfoQueryText_PhysicalInventory()
	Return
	"SELECT
	|	RowIDInfo.Ref AS Basis,
	|	RowIDInfo.RowRef AS RowRef,
	|	RowIDInfo.BasisKey AS BasisKey,
	|	RowIDInfo.RowID AS RowID,
	|	RowIDInfo.Basis AS ParentBasis,
	|	ItemList.Key AS Key,
	|	0 AS Price,
	|	UNDEFINED AS Currency,
	|	ItemList.Unit AS Unit
	|FROM
	|	Document.PhysicalInventory.ItemList AS ItemList
	|		INNER JOIN Document.PhysicalInventory.RowIDInfo AS RowIDInfo
	|		ON RowIDInfo.Ref = &Basis
	|		AND ItemList.Ref = &Basis
	|		AND RowIDInfo.Key = &BasisKey
	|		AND ItemList.Key = &BasisKey
	|		AND RowIDInfo.Key = ItemList.Key
	|		AND RowIDInfo.Ref = ItemList.Ref
	|		AND RowIDInfo.RowID = &RowID";
EndFunction

Function GetBasisesInfoQueryText_PR()
	Return
	"SELECT
	|	RowIDInfo.Ref AS Basis,
	|	RowIDInfo.RowRef AS RowRef,
	|	RowIDInfo.BasisKey AS BasisKey,
	|	RowIDInfo.RowID AS RowID,
	|	RowIDInfo.Basis AS ParentBasis,
	|	ItemList.Key AS Key,
	|	ItemList.Price AS Price,
	|	ItemList.Ref.Currency AS Currency,
	|	ItemList.Unit AS Unit
	|FROM
	|	Document.PurchaseReturn.ItemList AS ItemList
	|		INNER JOIN Document.PurchaseReturn.RowIDInfo AS RowIDInfo
	|		ON RowIDInfo.Ref = &Basis
	|		AND ItemList.Ref = &Basis
	|		AND RowIDInfo.Key = &BasisKey
	|		AND ItemList.Key = &BasisKey
	|		AND RowIDInfo.Key = ItemList.Key
	|		AND RowIDInfo.Ref = ItemList.Ref
	|		AND RowIDInfo.RowID = &RowID";
EndFunction

Function GetBasisesInfoQueryText_PRO()
	Return
	"SELECT
	|	RowIDInfo.Ref AS Basis,
	|	RowIDInfo.RowRef AS RowRef,
	|	RowIDInfo.BasisKey AS BasisKey,
	|	RowIDInfo.RowID AS RowID,
	|	RowIDInfo.Basis AS ParentBasis,
	|	ItemList.Key AS Key,
	|	ItemList.Price AS Price,
	|	ItemList.Ref.Currency AS Currency,
	|	ItemList.Unit AS Unit
	|FROM
	|	Document.PurchaseReturnOrder.ItemList AS ItemList
	|		INNER JOIN Document.PurchaseReturnOrder.RowIDInfo AS RowIDInfo
	|		ON RowIDInfo.Ref = &Basis
	|		AND ItemList.Ref = &Basis
	|		AND RowIDInfo.Key = &BasisKey
	|		AND ItemList.Key = &BasisKey
	|		AND RowIDInfo.Key = ItemList.Key
	|		AND RowIDInfo.Ref = ItemList.Ref
	|		AND RowIDInfo.RowID = &RowID";
EndFunction

Function GetBasisesInfoQueryText_SR()
	Return
	"SELECT
	|	RowIDInfo.Ref AS Basis,
	|	RowIDInfo.RowRef AS RowRef,
	|	RowIDInfo.BasisKey AS BasisKey,
	|	RowIDInfo.RowID AS RowID,
	|	RowIDInfo.Basis AS ParentBasis,
	|	ItemList.Key AS Key,
	|	ItemList.Price AS Price,
	|	ItemList.Ref.Currency AS Currency,
	|	ItemList.Unit AS Unit
	|FROM
	|	Document.SalesReturn.ItemList AS ItemList
	|		INNER JOIN Document.SalesReturn.RowIDInfo AS RowIDInfo
	|		ON RowIDInfo.Ref = &Basis
	|		AND ItemList.Ref = &Basis
	|		AND RowIDInfo.Key = &BasisKey
	|		AND ItemList.Key = &BasisKey
	|		AND RowIDInfo.Key = ItemList.Key
	|		AND RowIDInfo.Ref = ItemList.Ref
	|		AND RowIDInfo.RowID = &RowID";
EndFunction

Function GetBasisesInfoQueryText_SRO()
	Return
	"SELECT
	|	RowIDInfo.Ref AS Basis,
	|	RowIDInfo.RowRef AS RowRef,
	|	RowIDInfo.BasisKey AS BasisKey,
	|	RowIDInfo.RowID AS RowID,
	|	RowIDInfo.Basis AS ParentBasis,
	|	ItemList.Key AS Key,
	|	ItemList.Price AS Price,
	|	ItemList.Ref.Currency AS Currency,
	|	ItemList.Unit AS Unit
	|FROM
	|	Document.SalesReturnOrder.ItemList AS ItemList
	|		INNER JOIN Document.SalesReturnOrder.RowIDInfo AS RowIDInfo
	|		ON RowIDInfo.Ref = &Basis
	|		AND ItemList.Ref = &Basis
	|		AND RowIDInfo.Key = &BasisKey
	|		AND ItemList.Key = &BasisKey
	|		AND RowIDInfo.Key = ItemList.Key
	|		AND RowIDInfo.Ref = ItemList.Ref
	|		AND RowIDInfo.RowID = &RowID";
EndFunction

#EndRegion

#Region Service

Function Is(Source)
	TypeOf = TypeOf(Source);
	Result = New Structure();
	Result.Insert("SO" , TypeOf = Type("DocumentObject.SalesOrder")             
	                  Or TypeOf = Type("DocumentRef.SalesOrder"));
	Result.Insert("SI" , TypeOf = Type("DocumentObject.SalesInvoice")           
	                  Or TypeOf = Type("DocumentRef.SalesInvoice"));
	Result.Insert("SC" , TypeOf = Type("DocumentObject.ShipmentConfirmation")   
	                  Or TypeOf = Type("DocumentRef.ShipmentConfirmation"));
	Result.Insert("PO" , TypeOf = Type("DocumentObject.PurchaseOrder")          
	                  Or TypeOf = Type("DocumentRef.PurchaseOrder"));
	Result.Insert("PI" , TypeOf = Type("DocumentObject.PurchaseInvoice")        
	                  Or TypeOf = Type("DocumentRef.PurchaseInvoice"));
	Result.Insert("GR" , TypeOf = Type("DocumentObject.GoodsReceipt")           
	                  Or TypeOf = Type("DocumentRef.GoodsReceipt"));
	Result.Insert("ITO", TypeOf = Type("DocumentObject.InventoryTransferOrder") 
	                  Or TypeOf = Type("DocumentRef.InventoryTransferOrder"));
	Result.Insert("IT" , TypeOf = Type("DocumentObject.InventoryTransfer")      
	                  Or TypeOf = Type("DocumentRef.InventoryTransfer"));
	Result.Insert("ISR", TypeOf = Type("DocumentObject.InternalSupplyRequest")      
	                  Or TypeOf = Type("DocumentRef.InternalSupplyRequest"));
	Result.Insert("PhysicalInventory", TypeOf = Type("DocumentObject.PhysicalInventory")      
	                  Or TypeOf = Type("DocumentRef.PhysicalInventory"));
	Result.Insert("StockAdjustmentAsSurplus", TypeOf = Type("DocumentObject.StockAdjustmentAsSurplus")      
	                  Or TypeOf = Type("DocumentRef.StockAdjustmentAsSurplus"));
	Result.Insert("StockAdjustmentAsWriteOff", TypeOf = Type("DocumentObject.StockAdjustmentAsWriteOff")      
	                  Or TypeOf = Type("DocumentRef.StockAdjustmentAsWriteOff"));
	Result.Insert("PR", TypeOf  = Type("DocumentObject.PurchaseReturn")      
	                  Or TypeOf = Type("DocumentRef.PurchaseReturn"));
	Result.Insert("PRO", TypeOf = Type("DocumentObject.PurchaseReturnOrder")      
	                  Or TypeOf = Type("DocumentRef.PurchaseReturnOrder"));
	Result.Insert("SR", TypeOf  = Type("DocumentObject.SalesReturn")      
	                  Or TypeOf = Type("DocumentRef.SalesReturn"));
	Result.Insert("SRO", TypeOf = Type("DocumentObject.SalesReturnOrder")      
	                  Or TypeOf = Type("DocumentRef.SalesReturnOrder"));
	
	Return Result;
EndFunction

#EndRegion
