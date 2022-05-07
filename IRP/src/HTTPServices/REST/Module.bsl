
Function EndPointPOST(Request)
	Builder = BuilderServer_V2;
	Response = New HTTPServiceResponse(200);
	RequestData = CommonFunctionsServer.DeserializeJSON(Request.GetBodyAsString());
	
	If RequestData.Action = "CREATE_OBJECT" Then
		
		If Not StrStartsWith(RequestData.EntityName, "Document.") Then
			Raise "Create supported only for documents";
		EndIf;
		EntityName = StrReplace(RequestData.EntityName, "Document.", "");
		DocMetadata = Metadata.Documents[EntityName];
		Wrapper = Builder.CreateDocument(DocMetadata);
		
		Json = WrapperToJson(Wrapper);
	
	ElsIf RequestData.Action = "SET_PROPERTY" Then
		
		If Not StrStartsWith(RequestData.EntityName, "Document.") Then
			Raise "Set property supported only for documents";
		EndIf;
		EntityName = StrReplace(RequestData.EntityName, "Document.", "");
		Data = CommonFunctionsServer.DeserializeJSON(RequestData.Data);
		Wrapper = ValueFromStringInternal(Data.LinkedContext);
		Property = CommonFunctionsServer.DeserializeJSON(Data.Value);
		
		// Property.Name - attribute name
		// Property.Value - attribute value
		// Property.EntityName - attribute table
		
		If ValueIsFilled(Property.EntityName) Then
			If StrStartsWith(Property.EntityName, "Catalog.") Then
				Value = Catalogs[StrReplace(Property.EntityName, "Catalog.", "")]
					.GetRef(New UUID(Property.Value.Ref));
			Else
				Raise "Ref as value supported only for catalogs";
			EndIf;
		Else
			Value = Property.Value;
		EndIf;
		
		Builder.SetProperty(Wrapper, Wrapper.Attr[Property.Name], Value);
		
		Json = WrapperToJson(Wrapper);
				
	ElsIf RequestData.Action = "READ_LIST" Then	
		If Not StrStartsWith(RequestData.EntityName, "Catalog.") Then
			Raise "Read list supported only for documents";
		EndIf;
		
		If RequestData.EntityName = "Catalog.ItemKeys" Then
			Json = Action_READ_CATALOG_ITEM_KEYS(RequestData.Data);
		Else
			Json = ReadList(RequestData.EntityName);
		EndIf;
	EndIf;
				 
	Response.SetBodyFromString(Json);	
	Return Response;
EndFunction

Function WrapperToJson(Wrapper)
	LinkedContext = ValueToStringInternal(Wrapper);
	ObjectPresentation = GetPresentation(Wrapper);
	jsonObjectPresentation = CommonFunctionsServer.SerializeJSON(ObjectPresentation);
	
	SendingData = New Structure();
	SendingData.Insert("LinkedContext", LinkedContext);
	SendingData.Insert("ObjectPresentation", jsonObjectPresentation);
			
	Json = CommonFunctionsServer.SerializeJSON(SendingData);
	Return Json;
EndFunction

Function GetPresentation(Wrapper)
	Presentation = New Structure();
	For Each KeyValue In Wrapper.Object Do
		_Key = KeyValue.Key;
		Value = KeyValue.Value;
		Type = TypeOf(Value);
		If Value = Undefined Then
			Presentation.Insert(_Key, null);
		ElsIf IsRefType(Type) Then
			Presentation.Insert(_Key, GetRefPresentation(Value));
		ElsIf Type = Type("ValueTable") Then
			ValueArray = New Array();
			For Each Row In Value Do
				ValueRow = New Structure();
				For Each Column In Value.Columns Do
					CellValue = Row[Column.Name];
					If CellValue = Undefined Then
						ValueRow.Insert(Column.Name, null);
					ElsIf IsRefType(TypeOf(CellValue)) Then
						ValueRow.Insert(Column.Name, GetRefPresentation(CellValue));
					Else
						ValueRow.Insert(Column.Name, CellValue);
					EndIf;
				EndDo;
				ValueArray.Add(ValueRow);
			EndDo;
			Presentation.Insert(_Key, ValueArray);
		Else
			Presentation.Insert(_Key, Value);
		EndIf;
	EndDo;
	Return Presentation;
EndFunction

Function IsRefType(Type)
	Return Catalogs.AllRefsType().ContainsType(Type) Or Documents.AllRefsType().ContainsType(Type);
EndFunction

Function GetRefPresentation(Value)
	Return New Structure("Ref, Presentation", String(Value.UUID()), String(Value));
EndFunction

Function ReadList(EntityName)
	Query = New Query();
	Query.Text =	
	 "SELECT top 20
	 |	t.Ref,
	 |	t.Code 
	 |FROM
	 |	%1 AS t";
	Query.Text = StrTemplate(Query.Text, EntityName);
	QuerySelection = Query.Execute().Select();
	Elements = New Array();
	While QuerySelection.Next() Do
		Element = New Structure();
		Element.Insert("Presentation",String(QuerySelection.Ref));
		Element.Insert("Ref", String(QuerySelection.Ref.UUID()));
		Element.Insert("Code", QuerySelection.Code);
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

