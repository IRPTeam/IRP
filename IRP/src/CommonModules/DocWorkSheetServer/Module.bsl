#Region FORM

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	If Form.Parameters.Key.IsEmpty() Then
		SetGroupItemsList(Object, Form);
		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	EndIf;
//	RowIDInfoServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	ViewServer_V2.OnCreateAtServer(Object, Form, "ItemList");
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
//	RowIDInfoServer.AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters);
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	If Not Form.GroupItems.Count() Then
		SetGroupItemsList(Object, Form);
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
//	RowIDInfoServer.OnReadAtServer(Object, Form, CurrentObject);
EndProcedure

#EndRegion

#Region GroupTitle

Procedure SetGroupItemsList(Object, Form)
	AttributesArray = New Array();
	AttributesArray.Add("Company");
	AttributesArray.Add("Partner");
	AttributesArray.Add("LegalName");
	DocumentsServer.DeleteUnavailableTitleItemNames(AttributesArray);
	For Each Attr In AttributesArray Do
		Form.GroupItems.Add(Attr, ?(ValueIsFilled(Form.Items[Attr].Title), Form.Items[Attr].Title,
			Object.Ref.Metadata().Attributes[Attr].Synonym + ":" + Chars.NBSp));
	EndDo;
EndProcedure

#EndRegion

#Region ListFormEvents

Procedure OnCreateAtServerListForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerListForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

#Region ChoiceFormEvents

Procedure OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

Function GetMaterialsForWork(BillOfMaterialsRef, UUID) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	BillOfMaterialsContent.Item AS Item,
	|	BillOfMaterialsContent.ItemKey AS ItemKey,
	|	BillOfMaterialsContent.Unit AS Unit,
	|	BillOfMaterialsContent.Quantity AS Quantity,
	
	|	BillOfMaterialsContent.Item AS ItemBOM,
	|	BillOfMaterialsContent.ItemKey AS ItemKeyBOM,
	|	BillOfMaterialsContent.Unit AS UnitBOM,
	|	BillOfMaterialsContent.Quantity AS QuantityBOM,
	
	|	BillOfMaterialsContent.Ref.BusinessUnit.MaterialStore AS Store,
	|	VALUE(Enum.MaterialsCostWriteOff.IncludeToWorkCost) AS CostWriteOff
	|FROM
	|	Catalog.BillOfMaterials.Content AS BillOfMaterialsContent
	|WHERE
	|	BillOfMaterialsContent.Ref = &Ref";
	Query.SetParameter("Ref", BillOfMaterialsRef);
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	
	Address = PutToTempStorage(QueryTable, UUID);
	GroupColumns = "Item, ItemKey, Unit, ItemBOM, ItemKeyBOM, UnitBOM, Store, CostWriteOff";
	SumColumns = "Quantity, QuantityBOM";
	
	Return New Structure("Address, GroupColumns, SumColumns", Address, GroupColumns, SumColumns);
EndFunction

