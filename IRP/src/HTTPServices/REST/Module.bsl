
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
		Element.Insert("Description",String(QuerySelection.Ref));
		Element.Insert("Ref",String(QuerySelection.Ref.UUID()));
		Elements.Add(Element);
	EndDo;
	//Result = New Structure("Elements", Elements);
	Return CommonFunctionsServer.SerializeJSON(Elements);
EndFunction

Function Action_READ_CATALOG_ITEM_KEYS(jsonFilter)
	Query = New Query();
	Query.Text =	
	 "SELECT
	 |	ItemKeys.Ref AS Ref
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
		Element.Insert("Description",String(QuerySelection.Ref));
		Element.Insert("Ref",String(QuerySelection.Ref.UUID()));
		Elements.Add(Element);
	EndDo;
	//Result = New Structure("Elements", Elements);
	Return CommonFunctionsServer.SerializeJSON(Elements);
EndFunction	

Function Action_CREATE_DOCUMENT_RETAIL_SALES(Data)
	Builder = BuilderServer_V2;
	DocMetadata = Metadata.Documents.RetailSalesReceipt;
	Wrapper = Builder.CreateDocument(DocMetadata);
	jsonDataContext = CommonFunctionsServer.SerializeJSONUseXDTO(Wrapper);
	
	DataPresentation = new Structure();
	DataPresentation.Insert("TestPresentationProperty" , String(CurrentSessionDate()));
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
	Property = CommonFunctionsServer.DeserializeJSON(Data.Value);
	//Property.Name - attribute name
	//Property.Value - attribute value
	
	Wrapper = CommonFunctionsServer.DeserializeJSONUseXDTO(Data.DataContext);
	// Data.Value
	Builder.SetProperty(Wrapper, Wrapper.Attr.Date , CurrentSessionDate());
	
	jsonDataContext = CommonFunctionsServer.SerializeJSONUseXDTO(Wrapper);
	
	DataPresentation = new Structure();
	DataPresentation.Insert("TestPresentationProperty" , "after set property");
	jsonDataPresentation = CommonFunctionsServer.SerializeJSON(DataPresentation);
		
	json = CommonFunctionsServer.SerializeJSON(
		New Structure("DataContext, DataPresentation", jsonDataContext, jsonDataPresentation));
		
	Return json;
EndFunction

