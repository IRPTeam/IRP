
&AtClient
Procedure SerialLotNumberOnChange(Item)
	SerialLotNumberOnChangeAtServer();
EndProcedure

&AtServer
Procedure SerialLotNumberOnChangeAtServer()
	If Not ValueIsFilled(ThisObject.SerialLotNumber) Then
		ThisObject.ItemKey = Undefined;
		ThisObject.Item    = Undefined;
		Return;
	EndIf;
	
	_ItemKey = ThisObject.SerialLotNumber.SerialLotNumberOwner;
	If TypeOf(_ItemKey) <> Type("CatalogRef.ItemKeys") Then
		Raise "Serial lot number owner is not Item key";
	EndIf;
	 
	ThisObject.ItemKey = _ItemKey;
	ThisObject.Item    = _ItemKey.Item; 
EndProcedure

&AtClient
Procedure FindRefs(Command)
	If Not CheckFilling() Then
		Return;
	EndIf;
	FindRefsAtServer();
EndProcedure

&AtClient
Procedure Replace(Command)
	If Not CheckFilling() Then
		Return;
	EndIf;
	If ReplaceAtServer() Then
		SerialLotNumberOnChangeAtServer();
		FindRefsAtServer();
	EndIf;
EndProcedure

&AtServer
Procedure FindRefsAtServer()
	ArrayOfRefs = New Array();
	ArrayOfRefs.Add(ThisObject.SerialLotNumber);
	TableResult = FindByRef(ArrayOfRefs);
	
	ThisObject.Documents.Clear();
	ThisObject.Registers.Clear();
	ThisObject.Dimensions.Clear();
	ThisObject.Resources.Clear();
	
	For Each Row In TableResult Do
		
		MetadataFullName = Row.Metadata.FullName();
		
		If Metadata.Documents.Contains(Row.Metadata) Then
			If Row.Metadata.TabularSections.Find("SerialLotNumbers") <> Undefined Then
								
				AddDocument_SerialLotNumbers(Row, MetadataFullName);
			
			ElsIf Row.Metadata.TabularSections.Find("ItemList") <> Undefined Then
					
				AddDocument_ItemList(Row, MetadataFullName, "ItemList");
				
			ElsIf Row.Metadata.TabularSections.Find("Inventory") <> Undefined Then
					
				AddDocument_ItemList(Row, MetadataFullName, "Inventory");
			Else
				Raise StrTemplate("Undefined tabular section for : [%1] [%2]", MetadataFullName, Row.Data);
			EndIf;
			
		ElsIf Metadata.InformationRegisters.Contains(Row.Metadata) Then
			
			NewRow              = ThisObject.Registers.Add();
			NewRow.RegisterName = MetadataFullName;
			NewRow.RecordUUID   = String(New UUID());
			
			ArrayOfDimensions = New Array();
			
			RecordSet = InformationRegisters[Row.Metadata.Name].CreateRecordSet();
			
			For Each Dimension In Row.Metadata.Dimensions Do
				NewRow_Dimensions = ThisObject.Dimensions.Add();
				NewRow_Dimensions.RecordUUID = NewRow.RecordUUID;
				NewRow_Dimensions.Name       = Dimension.Name;
				NewRow_Dimensions.Value      = Row.Data[Dimension.Name];
				
				If TypeOf(NewRow_Dimensions.Value) = Type("CatalogRef.Items") Then
					NewRow_Dimensions.NewValue = ThisObject.NewItem;
				ElsIf TypeOf(NewRow_Dimensions.Value) = Type("CatalogRef.ItemKeys") Then
					NewRow_Dimensions.NewValue = ThisObject.NewItemKey;	
				EndIf;
				
				RecordSet.Filter[Dimension.Name].Set(Row.Data[Dimension.Name]);
				
				ArrayOfDimensions.Add(Dimension.Name);
			EndDo;
			
			NewRow.Dimensions = StrConcat(ArrayOfDimensions, ",");
			
			RecordSet.Read();
			
			If RecordSet.Count() <> 1 Then
				Raise StrTemplate("RecordSet.Count() <> 1 [%1]", MetadataFullName);
			EndIf;
			
			ArrayOfResources = New Array();
			For Each Resource In Row.Metadata.Resources Do
				NewRow_Resources = ThisObject.Resources.Add();
				NewRow_Resources.RecordUUID = NewRow.RecordUUID;
				NewRow_Resources.Name       = Resource.Name;
				NewRow_Resources.Value      = RecordSet[0][Resource.Name];
				
				If TypeOf(NewRow_Resources.Value) = Type("CatalogRef.Items") Then
					NewRow_Resources.NewValue = ThisObject.NewItem;
				ElsIf TypeOf(NewRow_Resources.Value) = Type("CatalogRef.ItemKeys") Then
					NewRow_Resources.NewValue = ThisObject.NewItemKey;	
				EndIf;
				
				ArrayOfResources.Add(Resource.Name);
			EndDo;
			
			NewRow.Resources = StrConcat(ArrayOfResources, ",");
			
		Else
			Raise StrTemplate("Not supported metadata : [%1]", MetadataFullName);
		EndIf;
	EndDo;
EndProcedure

&AtServer
Procedure AddDocument_SerialLotNumbers(Row, MetadataFullName)
	DepRows = Row.Data.SerialLotNumbers.FindRows(New Structure("SerialLotNumber", ThisObject.SerialLotNumber));
	
	For Each DepRow In DepRows Do
		NewRow = ThisObject.Documents.Add();
		NewRow.Ref               = Row.Data;
		NewRow.DocumentName       = MetadataFullName;
		NewRow.SerialLotNumber   = DepRow.SerialLotNumber;
		NewRow.TabularSection    = "ItemList";
		NewRow.DepTabularSection = "SerialLotNumbers";
		NewRow.Key	             = DepRow.Key;
		NewRow.DepLineNumber     = DepRow.LineNumber;
					
		ItemListRows = Row.Data.ItemList.FindRows(New Structure("Key", DepRow.Key));
		If ItemListRows.Count() <> 1 Then
			Raise StrTemplate("ItemListRows.Count() <> 1 :[%1] [%2]", MetadataFullName, DepRow.Key);
		EndIf;
		
		ItemListRow = ItemListRows[0];
					
		NewRow.LineNumber = ItemListRow.LineNumber;
		NewRow.Item       = ItemListRow.Item;
		NewRow.ItemKey    = ItemListRow.ItemKey;	
		
		OtherSerialLotNumbers = Row.Data.SerialLotNumbers.FindRows(New Structure("Key", DepRow.Key));
		NewRow.RepeatingLines = OtherSerialLotNumbers.Count();
		
		IsOk = True;
		For Each Row2 In OtherSerialLotNumbers Do
			If Row2.SerialLotNumber <> ThisObject.SerialLotNumber Then
				IsOk = False;
				Break;
			EndIf;
		EndDo;
					
		NewRow.IsOk = IsOk;
		
		If CommonFunctionsClientServer.ObjectHasProperty(ItemListRow, "Price") 
		 	And CommonFunctionsClientServer.ObjectHasProperty(ItemListRow, "PriceType") Then
			
			ManualPriceType = Catalogs.PriceTypes.ManualPriceType;
			
			NewRow.WithPrice       = True;
			
			NewRow.CurrentPrice     = ItemListRow.Price;
			NewRow.CurrentPriceType = ItemListRow.PriceType;
			
			If ItemListRow.PriceType = ManualPriceType Then
				
				NewRow.NewPrice = ItemListRow.Price;
				
				NewRow.AcceptNewPrice  = True;
				NewRow.ResultPriceType = ManualPriceType;
				NewRow.ResultPrice     = ItemListRow.Price;
				
			Else

				DocInfo = New Structure();
				DocInfo.Insert("DocObject"   , Row.Data.GetObject());
				DocInfo.Insert("DocMetadata" , Row.Metadata);
			
				Doc = BuilderAPI.Initialize(Undefined, Undefined, Undefined, Undefined, DocInfo);
				BuilderAPI.SetRowProperty(Doc, NewRow.Key, "Item"    , ThisObject.NewItem    , "ItemList");
				BuilderAPI.SetRowProperty(Doc, NewRow.Key, "ItemKey" , ThisObject.NewItemKey , "ItemList");
				
				NewRow.NewPrice = Doc.Object.ItemList.FindRows(New Structure("Key", NewRow.Key))[0].Price;
				NewRow.AcceptNewPrice  = True;
				If Not ValueIsFilled(NewRow.NewPrice) Then

					NewRow.ResultPriceType = ManualPriceType;
					NewRow.ResultPrice     = ItemListRow.Price;
				
				Else
					
					If NewRow.CurrentPrice = NewRow.NewPrice Then
						NewRow.ResultPriceType = ItemListRow.PriceType;
					Else
						NewRow.ResultPriceType = ManualPriceType;
					EndIf;
						
					NewRow.ResultPrice     = NewRow.NewPrice;
										
				EndIf;
				
			EndIf;
			
		EndIf;
		
	EndDo;
EndProcedure

&AtServer
Procedure AddDocument_ItemList(Row, MetadataFullName, TabularSectionName)
	NewRow = ThisObject.Documents.Add();
	NewRow.Ref               = Row.Data;
	NewRow.DocumentName       = MetadataFullName;
					
	NewRow.TabularSection    = TabularSectionName;
	NewRow.DepTabularSection = "";
	NewRow.DepLineNumber     = 0;
					
	MainRows = Row.Data[TabularSectionName].FindRows(New Structure("SerialLotNumber", ThisObject.SerialLotNumber));
	If MainRows.Count() <> 1 Then
		Raise StrTemplate("MainRows.Count() <> 1 :[%1] [%2]", MetadataFullName, ThisObject.SerialLotNumber);
	EndIf;

	NewRow.RepeatingLines    = 1;
	NewRow.IsOk              = True;
					
	NewRow.Key	             = MainRows[0].Key;
	NewRow.SerialLotNumber   = ThisObject.SerialLotNumber;
					
	NewRow.LineNumber = MainRows[0].LineNumber;
	NewRow.Item       = MainRows[0].Item;
	NewRow.ItemKey    = MainRows[0].ItemKey;
EndProcedure

&AtServer
Function ReplaceAtServer()
	BeginTransaction();
	IsError = True;
	Try
		ReplaceRef();
		IsError = False;
	Except
		ErrorInfo = ErrorDescription();
	EndTry;
	
	If IsError Then
		RollbackTransaction();
		Raise ErrorInfo;
	Else
		CommitTransaction();
		CommonFunctionsClientServer.ShowUsersMessage("Done");
	EndIf;
	Return Not IsError;
EndFunction

&AtServer
Procedure ReplaceRef()
	SerialLotNumberObject = ThisObject.SerialLotNumber.GetObject();
	SerialLotNumberObject.SerialLotNumberOwner = ThisObject.NewItemKey;
	SerialLotNumberObject.Write();
	
	For Each Row In ThisObject.Documents Do
		If Not Row.IsOk Then
			Raise StrTemplate("Unable replace ref [%1]", Row.Ref);
		EndIf;
	
		DocInfo = New Structure();
		DocInfo.Insert("DocObject"   , Row.Ref.GetObject());
		DocInfo.Insert("DocMetadata" , Row.Ref.Metadata());
			
		Doc = BuilderAPI.Initialize(Undefined, Undefined, Undefined, Undefined, DocInfo);
		BuilderAPI.SetRowProperty(Doc, Row.Key, "Item"    , ThisObject.NewItem    , Row.TabularSection);
		BuilderAPI.SetRowProperty(Doc, Row.Key, "ItemKey" , ThisObject.NewItemKey , Row.TabularSection);
		
		If Row.AcceptNewPrice Then
			BuilderAPI.SetRowProperty(Doc, Row.Key, "PriceType" , Row.ResultPriceType , Row.TabularSection);
			BuilderAPI.SetRowProperty(Doc, Row.Key, "Price"     , Row.ResultPrice     , Row.TabularSection);
		EndIf;
		
		If Doc.Object.Posted Then
			BuilderAPI.Write(Doc, DocumentWriteMode.Posting);
		Else
			BuilderAPI.Write(Doc, DocumentWriteMode.Write);
		EndIf;
	EndDo;
	
	For Each Row In ThisObject.Registers Do
		RegisterName = TrimAll(StrSplit(Row.RegisterName, ".")[1]);
		RecordManager = InformationRegisters[RegisterName].CreateRecordManager();
		
		DimensionsRows = ThisObject.Dimensions.FindRows(New Structure("RecordUUID", Row.RecordUUID));
		ResourcesRows = ThisObject.Resources.FindRows(New Structure("RecordUUID", Row.RecordUUID));
		
		For Each DimensionRow In DimensionsRows Do
			RecordManager[DimensionRow.Name] = DimensionRow.Value;
		EndDo;
		
		RecordManager.Read();
		
		If RecordManager.Selected() Then
			
			For Each DimensionRow In DimensionsRows Do
				If ValueIsFilled(DimensionRow.NewValue) Then
					RecordManager[DimensionRow.Name] = DimensionRow.NewValue;
				EndIf;
			EndDo;
		
			For Each ResourcesRow In ResourcesRows Do
				If ValueIsFilled(ResourcesRow.NewValue) Then
					RecordManager[ResourcesRow.Name] = ResourcesRow.NewValue;
				EndIf;
			EndDo;
			
		EndIf;
		RecordManager.Write();
	EndDo;	
EndProcedure
