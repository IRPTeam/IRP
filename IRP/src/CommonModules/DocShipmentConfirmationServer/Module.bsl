#Region FormEvents

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsClientServer.ChangeTitleCollapse(Object, Form, Not ValueIsFilled(Object.Ref));
	If Form.Parameters.Key.IsEmpty() Then
		DocumentsServer.FillItemList(Object, Form);
		
		ObjectData = DocumentsClientServer.GetStructureFillStores();
		FillPropertyValues(ObjectData, Object);
		DocumentsClientServer.FillStores(ObjectData, Form);
		
		SetGroupItemsList(Object, Form);
		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	EndIf;
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	DocumentsServer.FillItemList(Object, Form);
	
	ObjectData = DocumentsClientServer.GetStructureFillStores();
	FillPropertyValues(ObjectData, CurrentObject);
	DocumentsClientServer.FillStores(ObjectData, Form);
	
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	DocumentsServer.FillItemList(Object, Form);
	
	ObjectData = DocumentsClientServer.GetStructureFillStores();
	FillPropertyValues(ObjectData, CurrentObject);
	DocumentsClientServer.FillStores(ObjectData, Form);
	
	If Not Form.GroupItems.Count() Then
		SetGroupItemsList(Object, Form);
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
EndProcedure

#EndRegion

Function GetLegalNameByPartner(Partner, LegalName) Export
	If Not Partner.IsEmpty() Then
		ArrayOfFilters = New Array();
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
		If ValueIsFilled(LegalName) Then
			ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Ref", LegalName, ComparisonType.Equal));
		EndIf;
		AdditionalParameters = New Structure();
		If ValueIsFilled(Partner) Then
			AdditionalParameters.Insert("Partner", Partner);
			AdditionalParameters.Insert("FilterByPartnerHierarchy", True);
		EndIf;
		Parameters = New Structure("CustomSearchFilter, AdditionalParameters",
				DocumentsServer.SerializeArrayOfFilters(ArrayOfFilters),
				DocumentsServer.SerializeArrayOfFilters(AdditionalParameters));
		Return Catalogs.Companies.GetDefaultChoiseRef(Parameters);
	EndIf;
	Return Undefined;
EndFunction

#Region GroupTitle

Procedure SetGroupItemsList(Object, Form)
	AttributesArray = New Array;
	AttributesArray.Add("Company");
	AttributesArray.Add("Partner");
	AttributesArray.Add("LegalName");
	DocumentsServer.DeleteUnavailableTitleItemNames(AttributesArray);
	For Each Atr In AttributesArray Do
		Form.GroupItems.Add(Atr, ?(ValueIsFilled(Form.Items[Atr].Title),
				Form.Items[Atr].Title,
				Object.Ref.Metadata().Attributes[Atr].Synonym + ":" + Chars.NBSp));
	EndDo;
EndProcedure

#EndRegion

Function PutQueryTableToTempTable(QueryTable) Export
	QueryTable.Columns.Add("Key", New TypeDescription("UUID"));
	For Each Row In QueryTable Do
		Row.Key = New UUID(Row.RowKey);
	EndDo;
	tempManager = New TempTablesManager();
	Query = New Query();
	Query.TempTablesManager = tempManager;
	Query.Text =
		"SELECT
		|	QueryTable.Store,
		|	QueryTable.ShipmentBasis,
		|	QueryTable.Currency,
		|   QueryTable.ItemKey,
		|   QueryTable.Unit,
		|	QueryTable.Quantity,
		|   QueryTable.Key,
		|   QueryTable.RowKey
		|INTO tmpQueryTable
		|FROM
		|	&QueryTable AS QueryTable";
	
	Query.SetParameter("QueryTable", QueryTable);
	Query.Execute();
	Return tempManager;
EndFunction

#Region ListFormEvents

Procedure OnCreateAtServerListForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerListForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion