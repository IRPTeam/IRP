
Function EndPointPOST(Request)
	Response = New HTTPServiceResponse(200);
	
	RequestData = CommonFunctionsServer.DeserializeJSON(Request.GetBodyAsString());
	If RequestData.Action = "READ_CATALOG_ITEMS" Then
	    Json = Action_READ_CATALOG_ITEMS();
	ElsIf RequestData.Action = "READ_CATALOG_ITEM_KEYS" Then
		Json = Action_READ_CATALOG_ITEM_KEYS(RequestData.Data);
	ElsIf RequestData.Action = "CREATE_DOCUMENT_RETAIL_SALES" Then
		Json = Action_CREATE_DOCUMENT_RETAIL_SALES(RequestData.Data);
	ElsIf RequestData.Action = "WRITE_DOCUMENT_RETAIL_SALES" Then
		Json = Action_WRITE_DOCUMENT_RETAIL_SALES(RequestData.Data);	
	ElsIf RequestData.Action = "SET_PROPERTY" Then
		Json = Action_SET_PROPERTY(RequestData.Data);
	EndIf;
	 
	Response.SetBodyFromString(Json);	
	Return Response;
EndFunction

Function Action_READ_CATALOG_ITEMS()
	Query = New Query();
	Query.Text =	
	 "SELECT
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
	//Result = New Structure("Elements", Elements);
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

Function Action_CREATE_DOCUMENT_RETAIL_SALES(Data)
	Builder = BuilderServer_V2;
	DocMetadata = Metadata.Documents.RetailSalesReceipt;
	Wrapper = Builder.CreateDocument(DocMetadata);
	jsonDataContext = CommonFunctionsServer.SerializeJSONUseXDTO(Wrapper);
	
	DataPresentation = GetTestDataPresentation();
	jsonDataPresentation = CommonFunctionsServer.SerializeJSON(DataPresentation);
	
	json = CommonFunctionsServer.SerializeJSON(
		New Structure("DataContext, DataPresentation", jsonDataContext, jsonDataPresentation));
	
	Return Json;
EndFunction

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
	itemkey2.Insert("Presentation","itemkey2");
	itemkey2.Insert("Ref","004");
	
	
	row1 = New Structure("Price, Quantity, Item, ItemKey", 100, 2, item1, itemkey1);
	row2 = New Structure("Price, Quantity, Item, ItemKey", 20.3, 4.002, item2, itemkey2);
	
//	DataPresentation.Insert("ItemList", new Structure("List", new Array()));
//	DataPresentation.ItemList.List.add(row1);
//	DataPresentation.ItemList.List.add(row2);
	
	DataPresentation.Insert("ItemList", new Array());
	DataPresentation.ItemList.add(row1);
	DataPresentation.ItemList.add(row2);
	Return DataPresentation;
EndFunction

