&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.Store = Parameters.Store;
	ThisObject.Company = Parameters.Company;
	ThisObject.Item = Parameters.Item;
	ThisObject.ItemKey = Parameters.ItemKey;
	ThisObject.Unit = Parameters.Unit;
	ThisObject.DateOfRelevance = CurrentSessionDate();
	ThisObject.VisibleSelectionTables = Parameters.VisibleSelectionTables;
	ThisObject.ShowPrecision = Parameters.ShowPrecision;

	ShowPrecision();

	ResultsTableOfBalance = ThisObject.TableOfBalance.Unload().CopyColumns();
	For Each Row In Parameters.TableOfBalance Do
		FillPropertyValues(ResultsTableOfBalance.Add(), Row);
	EndDo;

	ResultsTableOfPurchase = ThisObject.TableOfPurchase.Unload().CopyColumns();
	For Each Row In Parameters.TableOfPurchase Do
		FillPropertyValues(ResultsTableOfPurchase.Add(), Row);
	EndDo;

	ResultsTableOfInternalSupplyRequest = ThisObject.TableOfInternalSupplyRequest.Unload().CopyColumns();
	For Each Row In Parameters.TableOfInternalSupplyRequest Do
		FillPropertyValues(ResultsTableOfInternalSupplyRequest.Add(), Row);
	EndDo;

	For Each Row In Parameters.ArrayOfSupplyRequest Do
		NewRow = ThisObject.TableOfInternalSupplyRequest.Add();
		NewRow.InternalSupplyRequest = Row.InternalSupplyRequest;
		NewRow.RowKey = Row.RowKey;
		NewRow.Quantity = Row.Quantity;
		NewRow.ProcurementDate = Row.ProcurementDate;
		ThisObject.TotalQuantity = ThisObject.TotalQuantity + Row.Quantity;
	EndDo;

	Update_TableOfBalance();
	Update_TableOfPurchase();

	Query = New Query();
	Query.Text =
	"SELECT
	|	tmp.Store,
	|	tmp.Balance,
	|	tmp.BalanceIncoming,
	|	tmp.PurchaseOrder
	|INTO TableOfBalance
	|FROM
	|	&TableOfBalance AS tmp
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.Store,
	|	tmp.Quantity,
	|	tmp.QuantityIncoming,
	|	tmp.PurchaseOrder
	|INTO ResultsTableOfBalance
	|FROM
	|	&ResultsTableOfBalance AS tmp
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.Partner,
	|	tmp.PriceType,
	|	tmp.Price,
	|	tmp.DateOfRelevance,
	|	tmp.Agreement,
	|	tmp.DeliveryDate,
	|	&Store AS Store,
	|	tmp.Unit
	|INTO TableOfPurchase
	|FROM
	|	&TableOfPurchase AS tmp
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.Partner,
	|	tmp.PriceType,
	|	tmp.Price,
	|	tmp.Quantity,
	|	tmp.DateOfRelevance,
	|	tmp.Agreement,
	|	tmp.DeliveryDate,
	|	tmp.Store,
	|	tmp.Unit
	|INTO ResultsTableOfPurchase
	|FROM
	|	&ResultsTableOfPurchase AS tmp
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	TableOfBalance.Store,
	|	TableOfBalance.Balance,
	|	TableOfBalance.BalanceIncoming,
	|	TableOfBalance.PurchaseOrder,
	|	ISNULL(ResultsTableOfBalance.Quantity, 0) AS Quantity,
	|	ISNULL(ResultsTableOfBalance.QuantityIncoming, 0) AS QuantityIncoming
	|FROM
	|	TableOfBalance AS TableOfBalance
	|		LEFT JOIN ResultsTableOfBalance AS ResultsTableOfBalance
	|		ON TableOfBalance.Store = ResultsTableOfBalance.Store
	|		AND TableOfBalance.PurchaseOrder = ResultsTableOfBalance.PurchaseOrder
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	TableOfPurchase.Partner,
	|	TableOfPurchase.PriceType,
	|	TableOfPurchase.Price,
	|	TableOfPurchase.DateOfRelevance,
	|	TableOfPurchase.Agreement,
	|	ISNULL(ResultsTableOfPurchase.Quantity, 0) AS Quantity,
	|	ISNULL(ResultsTableOfPurchase.DeliveryDate, TableOfPurchase.DeliveryDate) DeliveryDate,
	|	ISNULL(ResultsTableOfPurchase.Store, TableOfPurchase.Store) Store,
	|	ISNULL(ResultsTableOfPurchase.Unit, TableOfPurchase.Unit) Unit,
	|	TableOfPurchase.Unit AS BasisUnit
	|FROM
	|	TableOfPurchase AS TableOfPurchase
	|		LEFT JOIN ResultsTableOfPurchase AS ResultsTableOfPurchase
	|		ON TableOfPurchase.Partner = ResultsTableOfPurchase.Partner
	|		AND TableOfPurchase.PriceType = ResultsTableOfPurchase.PriceType
	|		AND TableOfPurchase.Price = ResultsTableOfPurchase.Price
	|		AND TableOfPurchase.DateOfRelevance = ResultsTableOfPurchase.DateOfRelevance
	|		AND TableOfPurchase.Agreement = ResultsTableOfPurchase.Agreement
	//|		AND TableOfPurchase.DeliveryDate = ResultsTableOfPurchase.DeliveryDate

	//|		AND TableOfPurchase.Store = ResultsTableOfPurchase.Store

	//|		AND TableOfPurchase.Unit = ResultsTableOfPurchase.Unit
	|";
	Query.SetParameter("Store", ThisObject.Store);
	Query.SetParameter("TableOfBalance", ThisObject.TableOfBalance.Unload());
	Query.SetParameter("ResultsTableOfBalance", ResultsTableOfBalance);
	Query.SetParameter("TableOfPurchase", ThisObject.TableOfPurchase.Unload());
	Query.SetParameter("ResultsTableOfPurchase", ResultsTableOfPurchase);

	QueryResults = Query.ExecuteBatch();
	ThisObject.TableOfBalance.Load(QueryResults[4].Unload());
	ThisObject.TableOfPurchase.Load(QueryResults[5].Unload());

	RecalculateBasisQuantity();
EndProcedure

&AtClient
Procedure ShowPrecisionOnChange(Item)
	ShowPrecision();
EndProcedure

&AtServer
Procedure ShowPrecision()
	FieldFormat = ?(ThisObject.ShowPrecision, "", "NFD=0");
	Items.TableOfBalanceBalance.Format = FieldFormat;

	Items.TableOfBalanceQuantity.Format = FieldFormat;
	Items.TableOfBalanceQuantity.EditFormat = FieldFormat;

	Items.TableOfPurchaseQuantity.Format = FieldFormat;
	Items.TableOfPurchaseQuantity.EditFormat = FieldFormat;

	Items.TableOfInternalSupplyRequestQuantity.Format = FieldFormat;
	Items.TableOfInternalSupplyRequestTransfer.Format = FieldFormat;
	Items.TableOfInternalSupplyRequestPurchase.Format = FieldFormat;
EndProcedure

&AtServer
Procedure Update_AllTables()
	Update_TableOfBalance();
	Update_TableOfPurchase();
EndProcedure

&AtClient
Procedure TableOfInternalSupplyRequestSelection(Item, RowSelected, Field, StandardProcessing)
	StandardProcessing = False;
	CurrentData = Items.TableOfInternalSupplyRequest.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	If Upper(Field.Name) = Upper("TableOfInternalSupplyRequestInternalSupplyRequest") Then
		If Not ValueIsFilled(CurrentData.InternalSupplyRequest) Then
			Return;
		EndIf;
		OpenParameters = New Structure();
		OpenParameters.Insert("Key", CurrentData.InternalSupplyRequest);
		OpenForm(GetMetadataFullName(CurrentData.InternalSupplyRequest) + ".ObjectForm", OpenParameters);
	EndIf;
EndProcedure

&AtClient
Procedure TableOfBalanceSelection(Item, RowSelected, Field, StandardProcessing)
	CurrentData = Items.TableOfBalance.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	If Upper(Field.Name) = Upper("TableOfBalanceStore") Then
		StandardProcessing = False;
		If Not ValueIsFilled(CurrentData.Store) Then
			Return;
		EndIf;
		OpenParameters = New Structure();
		OpenParameters.Insert("Key", CurrentData.Store);
		OpenForm(GetMetadataFullName(CurrentData.Store) + ".ObjectForm", OpenParameters);
	EndIf;
	If Upper(Field.Name) = Upper("TableOfBalancePurchaseOrder") Then
		StandardProcessing = False;
		If Not ValueIsFilled(CurrentData.PurchaseOrder) Then
			Return;
		EndIf;
		OpenParameters = New Structure();
		OpenParameters.Insert("Key", CurrentData.PurchaseOrder);
		OpenForm(GetMetadataFullName(CurrentData.PurchaseOrder) + ".ObjectForm", OpenParameters);
	EndIf;
EndProcedure

&AtClient
Procedure TableOfPurchaseSelection(Item, RowSelected, Field, StandardProcessing)
	CurrentData = Items.TableOfPurchase.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	If Upper(Field.Name) = Upper("TableOfPurchasePartner") Then
		StandardProcessing = False;
		If Not ValueIsFilled(CurrentData.Partner) Then
			Return;
		EndIf;
		OpenParameters = New Structure();
		OpenParameters.Insert("Key", CurrentData.Partner);
		OpenForm(GetMetadataFullName(CurrentData.Partner) + ".ObjectForm", OpenParameters);
	EndIf;

	If Upper(Field.Name) = Upper("TableOfPurchaseAgreement") Then
		StandardProcessing = False;
		If Not ValueIsFilled(CurrentData.Agreement) Then
			Return;
		EndIf;
		OpenParameters = New Structure();
		OpenParameters.Insert("Key", CurrentData.Agreement);
		OpenForm(GetMetadataFullName(CurrentData.Agreement) + ".ObjectForm", OpenParameters);
	EndIf;

	If Upper(Field.Name) = Upper("TableOfPurchasePriceType") Then
		StandardProcessing = False;
		If Not ValueIsFilled(CurrentData.PriceType) Then
			Return;
		EndIf;
		OpenParameters = New Structure();
		OpenParameters.Insert("Key", CurrentData.PriceType);
		OpenForm(GetMetadataFullName(CurrentData.PriceType) + ".ObjectForm", OpenParameters);
	EndIf;
EndProcedure

&AtServerNoContext
Function GetMetadataFullName(Ref)
	Return Ref.Metadata().FullName();
EndFunction

&AtClient
Procedure TableOfBalanceQuantityOnChange(Item)
	Update_TotalQuantity();
EndProcedure

&AtClient
Procedure TableOfBalanceQuantityIncomingOnChange(Item)
	Update_TotalQuantity();
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	Update_TotalQuantity();
	SetVisible();
EndProcedure

&AtClient
Procedure TableOfPurchaseQuantityOnChange(Item)
	CurrentData = Items.TableOfPurchase.CurrentData;
	If CurrentData <> Undefined Then
		UnitFactor = GetUnitFactor(CurrentData.Unit, CurrentData.BasisUnit);
		CurrentData.BasisQuantity = CurrentData.Quantity * UnitFactor;
	EndIf;
	Update_TotalQuantity();
EndProcedure

&AtClient
Procedure Update_TotalQuantity()
	ThisObject.SelectedQuantity = 0;
	TransferQuantity = 0;
	PurchaseQuantity = 0;
	For Each Row In ThisObject.TableOfBalance Do
		ThisObject.SelectedQuantity = ThisObject.SelectedQuantity + Row.Quantity + Row.QuantityIncoming;
		TransferQuantity = TransferQuantity + Row.Quantity + Row.QuantityIncoming;
	EndDo;
	For Each Row In ThisObject.TableOfPurchase Do
		ThisObject.SelectedQuantity = ThisObject.SelectedQuantity + Row.BasisQuantity;
		PurchaseQuantity = PurchaseQuantity + Row.BasisQuantity;
	EndDo;
	ThisObject.LackQuantity = ThisObject.TotalQuantity - ThisObject.SelectedQuantity;

	For Each Row In ThisObject.TableOfInternalSupplyRequest Do
		Row.Transfer = 0;
		Row.Purchase = 0;
	EndDo;

	For Each Row In ThisObject.TableOfInternalSupplyRequest Do
		If TransferQuantity <= 0 Then
			Break;
		EndIf;
		Row.Transfer = Min(TransferQuantity, Row.Quantity);
		TransferQuantity = TransferQuantity - Row.Transfer;
	EndDo;

	For Each Row In ThisObject.TableOfInternalSupplyRequest Do
		If PurchaseQuantity <= 0 Then
			Break;
		EndIf;
		Row.Purchase = Min(PurchaseQuantity, Row.Quantity - Row.Transfer);
		PurchaseQuantity = PurchaseQuantity - Row.Purchase;
	EndDo;
EndProcedure

&AtClient
Procedure TableOfPurchaseUnitOnChange(Item)
	CurrentData = Items.TableOfPurchase.CurrentData;
	If CurrentData <> Undefined Then
		UnitFactor = GetUnitFactor(CurrentData.Unit, CurrentData.BasisUnit);
		CurrentData.BasisQuantity = CurrentData.Quantity * UnitFactor;
	EndIf;
	Update_TotalQuantity();
EndProcedure

&AtServer
Procedure RecalculateBasisQuantity()
	For Each Row In ThisObject.TableOfPurchase Do
		UnitFactor = Catalogs.Units.GetUnitFactor(Row.Unit, Row.BasisUnit);
		Row.BasisQuantity = Row.Quantity * UnitFactor;
	EndDo;
EndProcedure

&AtServerNoContext
Function GetUnitFactor(FromUnit, ToUnit)
	Return Catalogs.Units.GetUnitFactor(FromUnit, ToUnit);
EndFunction

&AtClient
Procedure TableOfBalanceBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure TableOfBalanceBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure TableOfPurchaseBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure TableOfPurchaseBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure Cancel(Command)
	Result = New Structure();
	Result.Insert("IsOkPressed", False);
	Result.Insert("VisibleSelectionTables", ThisObject.VisibleSelectionTables);

	Close(Result);
EndProcedure

&AtClient
Procedure BeforeClose(Cancel, Exit, WarningText, StandardProcessing)
	StandardProcessing = False;
	Result = New Structure();
	Result.Insert("IsOkPressed", False);
	Result.Insert("VisibleSelectionTables", ThisObject.VisibleSelectionTables);

	Close(Result);
EndProcedure
&AtClient
Procedure DateOfRelevanceOnChange(Item)
	Update_AllTables();
EndProcedure

&AtClient
Procedure Refresh(Command)
	Update_AllTables();
EndProcedure

&AtServer
Procedure Update_TableOfBalance()
	Query = New Query();
	Query.Text =
	"SELECT
	|	R4011B_FreeStocksBalance.Store,
	|	UNDEFINED AS PurchaseOrder,
	|	R4011B_FreeStocksBalance.QuantityBalance AS Balance,
	|	0 AS BalanceIncoming
	|FROM
	|	AccumulationRegister.R4011B_FreeStocks.Balance(ENDOFPERIOD(&DateOfRelevance, day), ItemKey = &ItemKey
	|	AND Store <> &Store) AS R4011B_FreeStocksBalance
	|
	|UNION ALL
	|
	|SELECT
	|	IncomingStocksBalance.Store,
	|	IncomingStocksBalance.Order,
	|	0,
	|	IncomingStocksBalance.QuantityBalance
	|FROM
	|	AccumulationRegister.R4035B_IncomingStocks.Balance(ENDOFPERIOD(&DateOfRelevance, day), ItemKey = &ItemKey
	|	AND Store <> &Store) AS IncomingStocksBalance
	|WHERE
	|	IncomingStocksBalance.Order REFS Document.PurchaseOrder";
	Query.SetParameter("Store", ThisObject.Store);
	Query.SetParameter("DateOfRelevance", ThisObject.DateOfRelevance);
	Query.SetParameter("ItemKey", ThisObject.ItemKey);

	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	ThisObject.TableOfBalance.Load(QueryTable);
EndProcedure

&AtServer
Procedure Update_TableOfPurchase()
	Query = New Query();
	Query.Text =
	"SELECT
	|	Agreements.Partner AS Partner,
	|	Agreements.PriceType AS PriceType,
	|	Agreements.Ref AS Agreement,
	|	&ItemKey AS ItemKey
	|INTO tmp
	|FROM
	|	Catalog.Agreements AS Agreements
	|WHERE
	|	(Agreements.StartUsing <= ENDOFPERIOD(&Period, DAY)
	|	AND Agreements.EndOfUse >= ENDOFPERIOD(&Period, DAY)
	|	OR Agreements.EndOfUse = DATETIME(1, 1, 1))
	|	AND Agreements.Partner.Vendor
	|	AND Agreements.Type = VALUE(Enum.AgreementTypes.Vendor)
	|GROUP BY
	|	Agreements.Partner,
	|	Agreements.PriceType,
	|	Agreements.Ref
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemKeys.Ref AS ItemKey,
	|	ItemKeys.Specification AS Specification,
	|	ItemKeys.AffectPricingMD5 AS AffectPricingMD5,
	|	ItemKeys.Item AS Item,
	|	tmp.PriceType AS PriceType,
	|	tmp.Partner AS Partner,
	|	tmp.Agreement AS Agreement
	|INTO t_ItemKeys
	|FROM
	|	tmp AS tmp
	|		INNER JOIN Catalog.ItemKeys AS ItemKeys
	|		ON tmp.ItemKey = ItemKeys.Ref
	|		AND ItemKeys.Specification = VALUE(Catalog.Specifications.EmptyRef)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemKeys.ItemKey AS ItemKey,
	|	ItemKeys.Specification AS Specification,
	|	ItemKeys.AffectPricingMD5 AS AffectPricingMD5,
	|	ItemKeys.Item AS Item,
	|	ItemKeys.PriceType AS PriceType,
	|	ItemKeys.Partner AS Partner,
	|	ItemKeys.Agreement AS Agreement,
	|	PricesByItemKeysSliceLast.Period AS DateOfRelevance,
	|	ISNULL(PricesByItemKeysSliceLast.Price, 0) AS Price
	|INTO t_PricesByItemKeys
	|FROM
	|	t_ItemKeys AS ItemKeys
	|		LEFT JOIN InformationRegister.PricesByItemKeys.SliceLast(&Period, (PriceType, ItemKey) IN
	|			(SELECT
	|				tmp.PriceType,
	|				tmp.ItemKey
	|			FROM
	|				tmp AS tmp)) AS PricesByItemKeysSliceLast
	|		ON ItemKeys.ItemKey = PricesByItemKeysSliceLast.ItemKey
	|		AND ItemKeys.PriceType = PricesByItemKeysSliceLast.PriceType
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp2.ItemKey AS ItemKey,
	|	tmp2.AffectPricingMD5 AS AffectPricingMD5,
	|	tmp2.Item AS Item,
	|	tmp2.Partner AS Partner,
	|	tmp2.Agreement AS Agreement,
	|	tmp2.PriceType AS PriceType
	|INTO tmp2
	|FROM
	|	t_PricesByItemKeys AS tmp2
	|WHERE
	|	tmp2.Price = 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	PriceKeys.Ref AS PriceKey,
	|	tmp2.ItemKey AS ItemKey,
	|	tmp2.AffectPricingMD5 AS AffectPricingMD5,
	|	tmp2.Item AS Item,
	|	tmp2.Partner AS Partner,
	|	tmp2.Agreement AS Agreement,
	|	tmp2.PriceType AS PriceType
	|INTO t_PriceKeys
	|FROM
	|	tmp2 AS tmp2
	|		LEFT JOIN Catalog.PriceKeys AS PriceKeys
	|		ON tmp2.AffectPricingMD5 = PriceKeys.AffectPricingMD5
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	PriceKeys.ItemKey AS ItemKey,
	|	PriceKeys.Item AS Item,
	|	PriceKeys.Partner AS Partner,
	|	PriceKeys.Agreement AS Agreement,
	|	PriceKeys.PriceType AS PriceType,
	|	PricesByPropertiesSliceLast.Period AS DateOfRelevance,
	|	ISNULL(PricesByPropertiesSliceLast.Price, 0) AS Price
	|INTO t_PricesByProperties
	|FROM
	|	t_PriceKeys AS PriceKeys
	|		LEFT JOIN InformationRegister.PricesByProperties.SliceLast(&Period, (PriceType, PriceKey) IN
	|			(SELECT
	|				tmp.PriceType,
	|				tmp.PriceKey
	|			FROM
	|				t_PriceKeys AS tmp)) AS PricesByPropertiesSliceLast
	|		ON PriceKeys.PriceKey = PricesByPropertiesSliceLast.PriceKey
	|		AND PriceKeys.PriceType = PricesByPropertiesSliceLast.PriceType
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp3.ItemKey AS ItemKey,
	|	tmp3.Item AS Item,
	|	tmp3.Partner AS Partner,
	|	tmp3.Agreement AS Agreement,
	|	tmp3.PriceType AS PriceType
	|INTO tmp3
	|FROM
	|	t_PricesByProperties AS tmp3
	|WHERE
	|	tmp3.Price = 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp3.ItemKey AS ItemKey,
	|	tmp3.Item AS Item,
	|	tmp3.Partner AS Partner,
	|	tmp3.Agreement AS Agreement,
	|	tmp3.PriceType AS PriceType,
	|	PricesByItemsSliceLast.Period AS DateOfRelevance,
	|	ISNULL(PricesByItemsSliceLast.Price, 0) AS Price
	|INTO t_PricesByItems
	|FROM
	|	tmp3 AS tmp3
	|		LEFT JOIN InformationRegister.PricesByItems.SliceLast(&Period, (PriceType, Item) IN
	|			(SELECT
	|				tmp.PriceType,
	|				tmp.Item
	|			FROM
	|				tmp3 AS tmp)) AS PricesByItemsSliceLast
	|		ON tmp3.Item = PricesByItemsSliceLast.Item
	|		AND tmp3.PriceType = PricesByItemsSliceLast.PriceType
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT DISTINCT
	|	ItemKeys.ItemKey AS ItemKey,
	|	ItemKeys.Specification AS Specification,
	|	ItemKeys.AffectPricingMD5 AS AffectPricingMD5,
	|	ItemKeys.Item AS Item,
	|	ItemKeys.Partner AS Partner,
	|	ItemKeys.Agreement AS Agreement,
	|	DATEADD(&Period, DAY, ItemKeys.Agreement.DaysBeforeDelivery) AS DeliveryDate,
	|	ItemKeys.PriceType AS PriceType,
	|	&Store AS Store,
	|	CASE WHEN ItemKeys.Item.Unit = Value(Catalog.Units.EmptyRef) THEN
	|		ItemKeys.ItemKey.Unit
	|	ELSE
	|		ItemKeys.Item.Unit
	|	END AS Unit,
	|	CASE
	|		WHEN ISNULL(t_PricesByItemKeys.DateOfRelevance, DATETIME(1, 1, 1)) <> DATETIME(1, 1, 1)
	|			THEN ISNULL(t_PricesByItemKeys.DateOfRelevance, DATETIME(1, 1, 1))
	|		WHEN ISNULL(t_PricesByProperties.DateOfRelevance, DATETIME(1, 1, 1)) <> DATETIME(1, 1, 1)
	|			THEN ISNULL(t_PricesByProperties.DateOfRelevance, DATETIME(1, 1, 1))
	|		WHEN ISNULL(t_PricesByItems.DateOfRelevance, DATETIME(1, 1, 1)) <> DATETIME(1, 1, 1)
	|			THEN ISNULL(t_PricesByItems.DateOfRelevance, DATETIME(1, 1, 1))
	|	END AS DateOfRelevance,
	|	ISNULL(t_PricesByItemKeys.Price, 0) AS PriceByItemKeys,
	|	ISNULL(t_PricesByProperties.Price, 0) AS PriceByProperties,
	|	ISNULL(t_PricesByItems.Price, 0) AS PriceByItems,
	|	CASE
	|		WHEN ISNULL(t_PricesByItemKeys.Price, 0) <> 0
	|			THEN ISNULL(t_PricesByItemKeys.Price, 0)
	|		WHEN ISNULL(t_PricesByProperties.Price, 0) <> 0
	|			THEN ISNULL(t_PricesByProperties.Price, 0)
	|		WHEN ISNULL(t_PricesByItems.Price, 0) <> 0
	|			THEN ISNULL(t_PricesByItems.Price, 0)
	|	END AS Price
	|FROM
	|	t_ItemKeys AS ItemKeys
	|		LEFT JOIN t_PricesByItemKeys AS t_PricesByItemKeys
	|		ON ItemKeys.ItemKey = t_PricesByItemKeys.ItemKey
	|		AND ItemKeys.PriceType = t_PricesByItemKeys.PriceType
	|		LEFT JOIN t_PricesByProperties AS t_PricesByProperties
	|		ON ItemKeys.ItemKey = t_PricesByProperties.ItemKey
	|		AND ItemKeys.PriceType = t_PricesByProperties.PriceType
	|		LEFT JOIN t_PricesByItems AS t_PricesByItems
	|		ON ItemKeys.ItemKey = t_PricesByItems.ItemKey
	|		AND ItemKeys.PriceType = t_PricesByItems.PriceType
	|WHERE
	|	CASE
	|		WHEN ISNULL(t_PricesByItemKeys.Price, 0) <> 0
	|			THEN ISNULL(t_PricesByItemKeys.Price, 0)
	|		WHEN ISNULL(t_PricesByProperties.Price, 0) <> 0
	|			THEN ISNULL(t_PricesByProperties.Price, 0)
	|		WHEN ISNULL(t_PricesByItems.Price, 0) <> 0
	|			THEN ISNULL(t_PricesByItems.Price, 0)
	|	END <> 0";

	Query.SetParameter("Store", ThisObject.Store);
	Query.SetParameter("ItemKey", ThisObject.ItemKey);
	Query.SetParameter("Period", EndOfDay(ThisObject.DateOfRelevance));
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	ThisObject.TableOfPurchase.Load(QueryTable);
EndProcedure

&AtClient
Procedure Ok(Command)
	Result = New Structure();
	Result.Insert("IsOkPressed", True);
	Result.Insert("VisibleSelectionTables", ThisObject.VisibleSelectionTables);

	Result.Insert("Item", ThisObject.Item);
	Result.Insert("ItemKey", ThisObject.ItemKey);
	Result.Insert("Unit", ThisObject.Unit);

	Result.Insert("TableOfBalance", New Array());
	Result.Insert("TableOfPurchase", New Array());
	Result.Insert("TableOfInternalSupplyRequest", New Array());

	For Each Row In ThisObject.TableOfBalance Do
		If Not ValueIsFilled(Row.Quantity) And Not ValueIsFilled(Row.QuantityIncoming) Then
			Continue;
		EndIf;
		NewRow = New Structure();
		NewRow.Insert("ItemKey", ThisObject.ItemKey);
		NewRow.Insert("Store", Row.Store);
		NewRow.Insert("Quantity", Row.Quantity);
		NewRow.Insert("QuantityIncoming", Row.QuantityIncoming);
		NewRow.Insert("PurchaseOrder", Row.PurchaseOrder);

		Result.TableOfBalance.Add(NewRow);
	EndDo;

	For Each Row In ThisObject.TableOfPurchase Do
		If Not ValueIsFilled(Row.Quantity) Then
			Continue;
		EndIf;
		NewRow = New Structure();
		NewRow.Insert("ItemKey", ThisObject.ItemKey);
		NewRow.Insert("Partner", Row.Partner);
		NewRow.Insert("PriceType", Row.PriceType);
		NewRow.Insert("Price", Row.Price);
		NewRow.Insert("Quantity", Row.Quantity);
		NewRow.Insert("DateOfRelevance", Row.DateOfRelevance);
		NewRow.Insert("Agreement", Row.Agreement);
		NewRow.Insert("DeliveryDate", Row.DeliveryDate);
		NewRow.Insert("Unit", Row.Unit);
		NewRow.Insert("Store", Row.Store);
		NewRow.Insert("BasisUnit", Row.BasisUnit);
		NewRow.Insert("BasisQuantity", Row.BasisQuantity);
		Result.TableOfPurchase.Add(NewRow);
	EndDo;

	For Each Row In ThisObject.TableOfInternalSupplyRequest Do
		If Not ValueIsFilled(Row.Quantity) Then
			Continue;
		EndIf;
		NewRow = New Structure();
		NewRow.Insert("ItemKey", ThisObject.ItemKey);
		NewRow.Insert("InternalSupplyRequest", Row.InternalSupplyRequest);
		NewRow.Insert("Quantity", Row.Quantity);
		NewRow.Insert("Transfer", Row.Transfer);
		NewRow.Insert("Purchase", Row.Purchase);
		NewRow.Insert("ProcurementDate", Row.ProcurementDate);
		NewRow.Insert("RowKey", Row.RowKey);
		Result.TableOfInternalSupplyRequest.Add(NewRow);
	EndDo;

	Close(Result);
EndProcedure

&AtClient
Procedure VisibleSelectionTablesOnChange(Item)
	SetVisible();
EndProcedure

&AtClient
Procedure SetVisible()
	If Upper(ThisObject.VisibleSelectionTables) = Upper("All") Then
		Items.TableOfBalance.Visible = True;
		Items.TableOfPurchase.Visible = True;
	ElsIf Upper(ThisObject.VisibleSelectionTables) = Upper("Transfer") Then
		Items.TableOfBalance.Visible = True;
		Items.TableOfPurchase.Visible = False;
	ElsIf Upper(ThisObject.VisibleSelectionTables) = Upper("Purchase") Then
		Items.TableOfBalance.Visible = False;
		Items.TableOfPurchase.Visible = True;
	EndIf;
EndProcedure