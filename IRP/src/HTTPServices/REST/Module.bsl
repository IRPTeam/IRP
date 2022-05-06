
Function EndPointPOST(Request)
	Response = New HTTPServiceResponse(200);
	
	RequestData = CommonFunctionsServer.DeserializeJSON(Request.GetBodyAsString());
	If RequestData.Action = "CREATE_OBJECT" Then
		If RequestData.EntityName = "Document.RetailSalesReceipt" Then
			Json = Action_CREATE_DOCUMENT_RETAIL_SALES(RequestData.Data);
		EndIf;
	ElsIf RequestData.Action = "SET_PROPERTY" Then
		Json = Action_SET_PROPERTY(RequestData.Data);
	ElsIf RequestData.Action = "READ_LIST" Then	
		If RequestData.EntityName = "Catalog.Items" Then
			Json = Action_READ_CATALOG_ITEMS();
		ElsIf RequestData.EntityName = "Catalog.ItemKeys" Then
			Json = Action_READ_CATALOG_ITEM_KEYS(RequestData.Data);
		EndIf;
	EndIf;
				 
	Response.SetBodyFromString(Json);	
	Return Response;
EndFunction

Function Action_READ_CATALOG_ITEMS()
	Query = New Query();
	Query.Text =	
	 "SELECT top 10
	 |	Items.Ref AS Ref
	 |FROM
	 |	Catalog.Items AS Items";
	QuerySelection = Query.Execute().Select();
	Elements = New Array();
	While QuerySelection.Next() Do
		Element = New Structure();
		Element.Insert("Presentation",String(QuerySelection.Ref));
		Element.Insert("Ref", String(QuerySelection.Ref.UUID()));
		Elements.Add(Element);
	EndDo;
	json = CommonFunctionsServer.SerializeJSON(Elements);
	Return json;
EndFunction

Function Action_READ_CATALOG_ITEM_KEYS(jsonFilter)
	Query = New Query();
	Query.Text =	
	 "SELECT
	 |	ItemKeys.Ref AS Ref,
	 |	ItemKeys.Item
	 |FROM
	 |	Catalog.ItemKeys AS ItemKeys
	 |WHERE
	 |	ItemKeys.Item = &Item";
	ArrayOfFilters = CommonFunctionsServer.DeserializeJSON(jsonFilter);
	FilterItemUUID = ArrayOfFilters[0].Value.Ref;
	Query.SetParameter("Item", Catalogs.Items.GetRef(New UUID(FilterItemUUID)));
	
	QuerySelection = Query.Execute().Select();
	Elements = New Array();
	While QuerySelection.Next() Do
		Element = New Structure();
		Element.Insert("Presentation",String(QuerySelection.Ref));
		Element.Insert("Ref",String(QuerySelection.Ref.UUID()));
		
		Item = New Structure();
		Item.Insert("Presentation", String(QuerySelection.Item));
		Item.Insert("Ref", String(QuerySelection.Item.UUID()));
		
		Element.Insert("Item", Item);
		Elements.Add(Element);
	EndDo;
	Return CommonFunctionsServer.SerializeJSON(Elements);
EndFunction	

// CREATE_OBJECT Document.RetailSalesReceipt
Function Action_CREATE_DOCUMENT_RETAIL_SALES(Data)
	Builder = BuilderServer_V2;
	DocMetadata = Metadata.Documents.RetailSalesReceipt;
	
	Wrapper = Builder.CreateDocument(DocMetadata);
	Context = ValueToStringInternal(Wrapper);
	jsonDataContext = CommonFunctionsServer.SerializeJSONUseXDTO(Wrapper);
	
	DataPresentation = GetTestDataPresentation();
	jsonDataPresentation = CommonFunctionsServer.SerializeJSON(DataPresentation);
	
	json = CommonFunctionsServer.SerializeJSON(
		New Structure("DataContext, DataPresentation", jsonDataContext, jsonDataPresentation));
	
	Return Json;
EndFunction

#Region DATA_PRESENTATION

Function GetPresentation(Wrapper)
	res = New Structure();
	For Each KeyValue In Wrapper Do
		_key = KeyValue.Key;
		_value = KeyValue.Value;
		_type = TypeOf(_value);
		
		If IsRefType(_type) Then
		
		ElsIf _type = Type("Array") Then
			
		Else
		
		EndIf;
	EndDo;
EndFunction

Function IsRefType(type)
	Return Catalogs.AllRefsType().ContainsType(type) Or Documents.AllRefsType().ContainsType(type);
EndFunction

Function GetRefPresentation(value)
	Return New Structure("Ref, Presentation", String(value.UUID()), String(value));
EndFunction

#EndRegion

Function Action_WRITE_DOCUMENT_RETAIL_SALES(Data)
	Builder = BuilderServer_V2;
	DocMetadata = Metadata.Documents.RetailSalesReceipt;
	
	Wrapper = CommonFunctionsServer.DeserializeJSONUseXDTO(Data);
	Builder.Write(Wrapper, DocMetadata, DocumentWriteMode.Write);
	Result = New Structure("Success", True);
	Return CommonFunctionsServer.SerializeJSON(Result);
EndFunction

Function Action_SET_PROPERTY(jsonData)
	Builder = BuilderServer_V2;
	DocMetadata = Metadata.Documents.RetailSalesReceipt;
	
	Data = CommonFunctionsServer.DeserializeJSON(jsonData);
	//Data.Context - document context
	
	Property = CommonFunctionsServer.DeserializeJSON(Data.Value);
	//Property.Name - attribute name
	//Property.Value - attribute value
	
	Wrapper = CommonFunctionsServer.DeserializeJSONUseXDTO(Data.DataContext);
	// Data.Value
	Builder.SetProperty(Wrapper, Wrapper.Attr.Date , CurrentSessionDate());
	
	jsonDataContext = CommonFunctionsServer.SerializeJSONUseXDTO(Wrapper);
	
	DataPresentation = GetTestDataPresentation();
	jsonDataPresentation = CommonFunctionsServer.SerializeJSON(DataPresentation);
		
	json = CommonFunctionsServer.SerializeJSON(
		New Structure("DataContext, DataPresentation", jsonDataContext, jsonDataPresentation));
		
	Return json;
EndFunction

Function GetTestDataPresentation()
	DataPresentation = new Structure();
	DataPresentation.Insert("TestPresentationProperty" , String(CurrentSessionDate()));
	
	item1 = new Structure();
	item1.Insert("Presentation",String(CurrentSessionDate()));
	item1.Insert("Ref","001");
		
	item2 = new Structure();
	item2.Insert("Presentation","item2");
	item2.Insert("Ref","002");
	
	itemkey1 = new Structure();
	itemkey1.Insert("Presentation","itemkey1");
	itemkey1.Insert("Ref","003");
	
	itemkey2 = new Structure();
	itemkey2.Insert("Presentation",String(CurrentSessionDate()));
	itemkey2.Insert("Ref","004");
	
	
	row1 = New Structure("Key, Price, Quantity, Item, ItemKey", "__key__01",  100,     2, item1, itemkey1);
	row2 = New Structure("Key, Price, Quantity, Item, ItemKey", "__key__02", 20.3, 4.002, item2, itemkey2);
		
	DataPresentation.Insert("ItemList", new Array());
	DataPresentation.ItemList.add(row1);
	DataPresentation.ItemList.add(row2);
	Return DataPresentation;
EndFunction

