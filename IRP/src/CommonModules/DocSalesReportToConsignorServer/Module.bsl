#Region FORM

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	If Form.Parameters.Key.IsEmpty() Then
		SetGroupItemsList(Object, Form);
		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	EndIf;
	ViewServer_V2.OnCreateAtServer(Object, Form, "ItemList");
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	Form.Taxes_CreateFormControls();
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	If Not Form.GroupItems.Count() Then
		SetGroupItemsList(Object, Form);
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	Form.Taxes_CreateFormControls();
	LockDataModificationPrivileged.LockFormIfObjectIsLocked(Form, CurrentObject);
EndProcedure

#EndRegion

#Region _TITLE

Procedure SetGroupItemsList(Object, Form)
	AttributesArray = New Array();
	AttributesArray.Add("Company");
	AttributesArray.Add("Partner");
	AttributesArray.Add("LegalName");
	AttributesArray.Add("Agreement");
	AttributesArray.Add("LegalNameContract");
	DocumentsServer.DeleteUnavailableTitleItemNames(AttributesArray);
	For Each Attr In AttributesArray Do
		Form.GroupItems.Add(Attr, ?(ValueIsFilled(Form.Items[Attr].Title), Form.Items[Attr].Title,
			Object.Ref.Metadata().Attributes[Attr].Synonym + ":" + Chars.NBSp));
	EndDo;
EndProcedure

#EndRegion

#Region LIST_FORM

Procedure OnCreateAtServerListForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerListForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

#Region CHOICE_FORM

Procedure OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

Function GetConsignorSales(Parameters) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ConsignorSales.ItemKey.Item AS Item,
	|	ConsignorSales.ItemKey,
	|	ConsignorSales.Unit,
	|	ConsignorSales.PriceType,
	|	ConsignorSales.ConsignorPrice,
	|	ConsignorSales.Price,
	|	ConsignorSales.QuantityTurnover AS Quantity,
	|	ConsignorSales.NetAmountTurnover AS NetAmount,
	|	ConsignorSales.AmountTurnover AS TotalAmount,
	|	ConsignorSales.SalesInvoice,
	|	ConsignorSales.PurchaseInvoice,
	|	VALUE(Catalog.SerialLotNumbers.EmptyRef) AS SerialLotNumber,
	|	0 AS SumColumn,
	|	TRUE AS Use,
	|	CASE
	|		WHEN ConsignorSales.Agreement.TradeAgentFeeType = VALUE(Enum.TradeAgentFeeTypes.Percent)
	|			then ConsignorSales.Agreement.TradeAgentFeePercent
	|		ELSE 0
	|	END AS TradeAgentFeePercent
	|FROM
	|	AccumulationRegister.R8014T_ConsignorSales.Turnovers(BEGINOFPERIOD(&StartDate, DAY), ENDOFPERIOD(&EndDate, DAY),,
	|		Company = &Company
	|	AND Partner = &Partner
	|	AND Agreement = &Agreement
	|	AND PriceIncludeTax = &PriceIncludeTax
	|	AND CurrencyMovementType = &CurrencyMovementType) AS ConsignorSales
	|WHERE
	|	ConsignorSales.QuantityTurnover <> 0";
	Query.SetParameter("StartDate"       , Parameters.StartDate);
	Query.SetParameter("EndDate"         , Parameters.EndDate);
	Query.SetParameter("Company"         , Parameters.Company);
	Query.SetParameter("Partner"         , Parameters.Partner);
	Query.SetParameter("Agreement"       , Parameters.Agreement);
	Query.SetParameter("PriceIncludeTax" , Parameters.PriceIncludeTax);
	Query.SetParameter("CurrencyMovementType" , Parameters.Agreement.CurrencyMovementType);
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
EndFunction


