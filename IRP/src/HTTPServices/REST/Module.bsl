
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
		// Property.EntityName - attribute table if value is ref
		
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
	
	ElsIf RequestData.Action = "ADD_NEW_ROW" Then
		If Not StrStartsWith(RequestData.EntityName, "Document.") Then
			Raise "Add new row to tabular section supported only for documents";
		EndIf;
		// EntityName - Document.<name of document>.TabularSection.<name of tabular section>
		Segments = StrSplit(RequestData.EntityName, ".");
		TabularSectionName = Segments[3];
		Data = CommonFunctionsServer.DeserializeJSON(RequestData.Data);
		Wrapper = ValueFromStringInternal(Data.LinkedContext);
			
		Builder.AddRow(Wrapper, Wrapper.Tables[TabularSectionName]); 
		
		Json = WrapperToJson(Wrapper);
		
	ElsIf RequestData.Action = "SET_CELL" Then
		If Not StrStartsWith(RequestData.EntityName, "Document.") Then
			Raise "Set cell at row to tabular section supported only for documents";
		EndIf;
		// EntityName - Document.<name of document>.TabularSection.<name of tabular section>.Row
		Segments = StrSplit(RequestData.EntityName, ".");
		TabularSectionName = Segments[3];
		Data = CommonFunctionsServer.DeserializeJSON(RequestData.Data);
		Wrapper = ValueFromStringInternal(Data.LinkedContext);
		Cell = CommonFunctionsServer.DeserializeJSON(Data.Value);
		
		// Cell.ColumnName - column name
		// Cell.RowKey - row key
		// Cell.Value - cell value
		// Cell.EntityName - cell table if value is ref
		
		If ValueIsFilled(Cell.EntityName) Then
			If StrStartsWith(Cell.EntityName, "Catalog.") Then
				Value = Catalogs[StrReplace(Cell.EntityName, "Catalog.", "")]
					.GetRef(New UUID(Cell.Value.Ref));
			Else
				Raise "Ref as value supported only for catalogs";
			EndIf;
		Else
			Value = Cell.Value;
		EndIf;
		
		WrapperRow = Undefined;
		For Each Row In Wrapper.Object[TabularSectionName] Do
			If Row.Key = Cell.RowKey Then
				WrapperRow = Row;
				Break;
			EndIf;
		EndDo;
	
		Builder.SetRowProperty(Wrapper, WrapperRow, 
			Wrapper.Tables[TabularSectionName][Cell.ColumnName], Value);
		
		Json = WrapperToJson(Wrapper);
		
	ElsIf RequestData.Action = "READ_LIST" Then	
		If Not StrStartsWith(RequestData.EntityName, "Catalog.") Then
			Raise "Read list supported only for documents";
		EndIf;
		
		If RequestData.EntityName = "Catalog.ItemKeys" Then // for test with filters
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
			//Presentation.Insert(_Key, null);
			Continue;
		ElsIf IsRefType(Type) Then
			Presentation.Insert(_Key, GetRefPresentation(Value));
		ElsIf Type = Type("ValueTable") Then
			ValueArray = New Array();
			For Each Row In Value Do
				ValueRow = New Structure();
				For Each Column In Value.Columns Do
					CellValue = Row[Column.Name];
					If CellValue = Undefined Then
						//ValueRow.Insert(Column.Name, null);
						Continue;
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
	 "SELECT top 20
	 |	ItemKeys.Ref AS Ref,
	 |	ItemKeys.Item
	 |FROM
	 |	Catalog.ItemKeys AS ItemKeys
	 |WHERE
	 |	case
	 |		when &UseFilterItem
	 |			then ItemKeys.Item = &FilterItem
	 |		else true
	 |	end";
	ArrayOfFilters = CommonFunctionsServer.DeserializeJSON(jsonFilter);
	FilterItem = Undefined;
	If ValueIsFilled(ArrayOfFilters[0].Value) Then
		FilterItemUUID = ArrayOfFilters[0].Value.Ref;
		FilterItem = Catalogs.Items.GetRef(New UUID(FilterItemUUID));
	EndIf;
	Query.SetParameter("FilterItem", FilterItem);
	Query.SetParameter("UseFilterItem", FilterItem <> Undefined);
	
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
