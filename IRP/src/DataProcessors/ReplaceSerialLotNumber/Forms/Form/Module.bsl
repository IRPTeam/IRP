
&AtClient
Procedure SetItemKey(Command)
	For Each _row In ThisObject.SerialLotNumbers Do
		_row.NewItem = ThisObject.Item;
		_row.NewItemKey = ThisObject.ItemKey;
	EndDo;
EndProcedure

&AtClient
Procedure Load(Command)
	_notify = New NotifyDescription("OnLoadContinue", ThisObject);
	OpenForm("DataProcessor.ReplaceSerialLotNumber.Form.LoadSerialLotNumbers", , ThisObject, , , , _notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure OnLoadContinue(Result, AddPrams) Export
	If Result = Undefined Then
		Return;
	EndIf;
	ThisObject.SerialLotNumbers.Clear();
	OnLoadContinueAtServer(Result.ArrayOfSerialLotNumbers);	
EndProcedure

&AtServer
Procedure OnLoadContinueAtServer(_arrayOfSerialLotNumbers)
	For Each _serialLotNumber In _arrayOfSerialLotNumbers Do
		_serialLotNumberInfo = GetInfoBySerialLotNumber(_serialLotNumber);
		_newRow = ThisObject.SerialLotNumbers.Add();
		_newRow.SerialLotNumber = _serialLotNumber;
		_newRow.Item    = _serialLotNumberInfo.Item;
		_newRow.ItemKey = _serialLotNumberInfo.ItemKey;
	EndDo;
EndProcedure

&AtClient
Procedure SerialLotNumbersSerialLotNumberOnChange(Item)
	_currentData = Items.SerialLotNumbers.CurrentData;
	If _currentData = Undefined Then
		Return;
	EndIf;
	
	_serialLotNumberInfo = GetInfoBySerialLotNumber(_currentData.SerialLotNumber);
	_currentData.Item    = _serialLotNumberInfo.Item;
	_currentData.ItemKey = _serialLotNumberInfo.ItemKey;
EndProcedure

&AtServer
Function GetInfoBySerialLotNumber(_serialLotNumber)
	_result = New Structure("Item, ItemKey");
	If Not ValueIsFilled(_serialLotNumber) Then
		Return _result;
	EndIf;
	
	_itemKey = _serialLotNumber.SerialLotNumberOwner;
	If TypeOf(_itemKey) <> Type("CatalogRef.ItemKeys") Then
		Raise "Serial lot number owner is not Item key";
	EndIf;
	 
	_result.ItemKey = _itemKey;
	_result.Item    = _itemKey.Item;
	
	Return _result;
EndFunction

&AtServer
Procedure FillCheckProcessingAtServer(Cancel, CheckedAttributes)
	_arrayOfSerialLotNumbers = New Array();
	_index = 0;
	For Each _row In ThisObject.SerialLotNumbers Do
		If Not ValueIsFilled(_row.SerialLotNumber) Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage("Serial lot number is required field",
				"SerialLotNumbers[" + Format(_index, "NZ=0; NG=0;") + "].SerialLotNumber", ThisObject);
		EndIf;
			
		If Not ValueIsFilled(_row.NewItem) Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage("New Item is required field",
				"SerialLotNumbers[" + Format(_index, "NZ=0; NG=0;") + "].NewItem", ThisObject);
		EndIf;
		
		If Not ValueIsFilled(_row.NewItemKey) Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage("New Item key is required field",
				"SerialLotNumbers[" + Format(_index, "NZ=0; NG=0;") + "].NewItemKey", ThisObject);
		EndIf;
		
		If _arrayOfSerialLotNumbers.Find(_row.SerialLotNumber) = Undefined Then
			_arrayOfSerialLotNumbers.Add(_row.SerialLotNumber);
		Else
			Cancel = True;
			
			_index2 = 0;
			For Each _row2 In ThisObject.SerialLotNumbers Do
				If _row2.SerialLotNumber = _row.SerialLotNumber Then
				CommonFunctionsClientServer.ShowUsersMessage("Repeating serial lot number",
					"SerialLotNumbers[" + Format(_index2, "NZ=0; NG=0;") + "].SerialLotNumber", ThisObject);
					Break;
				EndIf;
				_index2 = _index2 + 1;
			EndDo;
						
		EndIf;
		_index = _index + 1;
	EndDo;	
EndProcedure

&AtClient
Procedure FindRefs(Command)
	If Not CheckFilling() Then
		Return;
	EndIf;
	ClearTables();
	For Each _row In ThisObject.SerialLotNumbers Do
		_rowInfo = New Structure("KeySLN, SerialLotNumber, NewItem, NewItemKey");
		FillPropertyValues(_rowInfo, _row);
		FindRefsAtServer(_rowInfo);
	EndDo;
EndProcedure

&AtClient
Procedure Replace(Command)
	If Not CheckFilling() Then
		Return;
	EndIf;
	If ReplaceAtServer() Then
		For Each _row In ThisObject.SerialLotNumbers Do
			_serialLotNumberInfo = GetInfoBySerialLotNumber(_row.SerialLotNumber);
			_row.Item    = _serialLotNumberInfo.Item;
			_row.ItemKey = _serialLotNumberInfo.ItemKey;
		EndDo;
		ClearTables();
		For Each _row In ThisObject.SerialLotNumbers Do
			_rowInfo = New Structure("KeySLN, SerialLotNumber, NewItem, NewItemKey");
			FillPropertyValues(_rowInfo, _row);
			FindRefsAtServer(_rowInfo);
		EndDo;
	EndIf;
EndProcedure

&AtClient
Procedure ClearTables()
	ThisObject.Documents.Clear();
	ThisObject.Registers.Clear();
	ThisObject.Dimensions.Clear();
	ThisObject.Resources.Clear();
	For Each _row In ThisObject.SerialLotNumbers Do
		_row.KeySLN = String(New UUID());
	EndDo;
EndProcedure	

&AtServer
Procedure FindRefsAtServer(_rowInfo)
	_arrayOfRefs = New Array();
	_arrayOfRefs.Add(_rowInfo.SerialLotNumber);
	_tableResult = FindByRef(_arrayOfRefs);
	
	For Each _resultRow In _tableResult Do
		
		_metadataFullName = _resultRow.Metadata.FullName();
		
		If Metadata.Documents.Contains(_resultRow.Metadata) Then
			If _resultRow.Metadata.TabularSections.Find("SerialLotNumbers") <> Undefined Then
								
				AddDocument_SerialLotNumbers(_resultRow, _metadataFullName, _rowInfo);
			
			ElsIf _resultRow.Metadata.TabularSections.Find("ItemList") <> Undefined Then
					
				AddDocument_ItemList(_resultRow, _metadataFullName, "ItemList", _rowInfo);
				
			ElsIf _resultRow.Metadata.TabularSections.Find("Inventory") <> Undefined Then
					
				AddDocument_ItemList(_resultRow, _metadataFullName, "Inventory", _rowInfo);
			Else
				Raise StrTemplate("Undefined tabular section for : [%1] [%2]", _metadataFullName, _resultRow.Data);
			EndIf;
			
		ElsIf Metadata.InformationRegisters.Contains(_resultRow.Metadata) Then
			
			_newRow              = ThisObject.Registers.Add();
			_newRow.KeySLN       = _rowInfo.KeySLN;
			_newRow.RegisterName = _metadataFullName;
			_newRow.RecordUUID   = String(New UUID());
			
			_arrayOfDimensions = New Array();
			
			_recordSet = InformationRegisters[_resultRow.Metadata.Name].CreateRecordSet();
			
			For Each _dimension In _resultRow.Metadata.Dimensions Do
				_newRow_Dimensions = ThisObject.Dimensions.Add();
				_newRow_Dimensions.RecordUUID = _newRow.RecordUUID;
				_newRow_Dimensions.Name       = _dimension.Name;
				_newRow_Dimensions.Value      = _resultRow.Data[_dimension.Name];
				
				If TypeOf(_newRow_Dimensions.Value) = Type("CatalogRef.Items") Then
					_newRow_Dimensions.NewValue = _rowInfo.NewItem;
				ElsIf TypeOf(_newRow_Dimensions.Value) = Type("CatalogRef.ItemKeys") Then
					_newRow_Dimensions.NewValue = _rowInfo.NewItemKey;	
				EndIf;
				
				_recordSet.Filter[_dimension.Name].Set(_resultRow.Data[_dimension.Name]);
				
				_arrayOfDimensions.Add(_dimension.Name);
			EndDo;
			
			_newRow.Dimensions = StrConcat(_arrayOfDimensions, ",");
			
			_recordSet.Read();
			
			If _recordSet.Count() <> 1 Then
				Raise StrTemplate("RecordSet.Count() <> 1 [%1]", _metadataFullName);
			EndIf;
			
			_arrayOfResources = New Array();
			For Each _resource In _resultRow.Metadata.Resources Do
				_newRow_Resources = ThisObject.Resources.Add();
				_newRow_Resources.RecordUUID = _newRow.RecordUUID;
				_newRow_Resources.Name       = _resource.Name;
				_newRow_Resources.Value      = _recordSet[0][_resource.Name];
				
				If TypeOf(_newRow_Resources.Value) = Type("CatalogRef.Items") Then
					_newRow_Resources.NewValue = _rowInfo.NewItem;
				ElsIf TypeOf(_newRow_Resources.Value) = Type("CatalogRef.ItemKeys") Then
					_newRow_Resources.NewValue = _rowInfo.NewItemKey;	
				EndIf;
				
				_arrayOfResources.Add(_resource.Name);
			EndDo;
			
			_newRow.Resources = StrConcat(_arrayOfResources, ",");
			
		Else
			Raise StrTemplate("Not supported metadata : [%1]", _metadataFullName);
		EndIf;
	EndDo;
EndProcedure

&AtServer
Procedure AddDocument_SerialLotNumbers(_resultRow, _metadataFullName, _rowInfo)
	_depRows = _resultRow.Data.SerialLotNumbers.FindRows(New Structure("SerialLotNumber", _rowInfo.SerialLotNumber));
	
	For Each _depRow In _depRows Do
		_newRow = ThisObject.Documents.Add();
		_newRow.KeySLN            = _rowInfo.KeySLN;
		_newRow.Ref               = _resultRow.Data;
		_newRow.DocumentName      = _metadataFullName;
		_newRow.SerialLotNumber   = _depRow.SerialLotNumber;
		_newRow.TabularSection    = "ItemList";
		_newRow.DepTabularSection = "SerialLotNumbers";
		_newRow.Key	              = _depRow.Key;
		_newRow.DepLineNumber     = _depRow.LineNumber;
					
		_itemListRows = _resultRow.Data.ItemList.FindRows(New Structure("Key", _depRow.Key));
		If _itemListRows.Count() <> 1 Then
			Raise StrTemplate("ItemListRows.Count() <> 1 :[%1] [%2]", _metadataFullName, _depRow.Key);
		EndIf;
		
		_itemListRow = _itemListRows[0];
					
		_newRow.LineNumber = _itemListRow.LineNumber;
		_newRow.Item       = _itemListRow.Item;
		_newRow.ItemKey    = _itemListRow.ItemKey;	
		
		_otherSLN = _resultRow.Data.SerialLotNumbers.FindRows(New Structure("Key", _depRow.Key));
		_newRow.RepeatingLines = _otherSLN.Count();
		
		_isOk = True;
		For Each _rowOtherSLN In _otherSLN Do
			If _rowOtherSLN.SerialLotNumber <> _rowInfo.SerialLotNumber Then
				_isOk = False;
				Break;
			EndIf;
		EndDo;
					
		_newRow.IsOk = _isOk;
		
		If CommonFunctionsClientServer.ObjectHasProperty(_itemListRow, "Price") 
		 	And CommonFunctionsClientServer.ObjectHasProperty(_itemListRow, "PriceType") Then
			
			_manualPriceType = Catalogs.PriceTypes.ManualPriceType;
			
			_newRow.WithPrice       = True;
			
			_newRow.CurrentPrice     = _itemListRow.Price;
			_newRow.CurrentPriceType = _itemListRow.PriceType;
			
			If _itemListRow.PriceType = _manualPriceType Then
				
				_newRow.NewPrice = _itemListRow.Price;
				
				_newRow.AcceptNewPrice  = True;
				_newRow.ResultPriceType = _manualPriceType;
				_newRow.ResultPrice     = _itemListRow.Price;
				
			Else

				_docInfo = New Structure();
				_docInfo.Insert("DocObject"   , _resultRow.Data.GetObject());
				_docInfo.Insert("DocMetadata" , _resultRow.Metadata);
			
				_doc = BuilderAPI.Initialize(Undefined, Undefined, Undefined, Undefined, _docInfo);
				BuilderAPI.SetRowProperty(_doc, _newRow.Key, "Item"    , _rowInfo.NewItem    , "ItemList");
				BuilderAPI.SetRowProperty(_doc, _newRow.Key, "ItemKey" , _rowInfo.NewItemKey , "ItemList");
				
				_newRow.NewPrice = _doc.Object.ItemList.FindRows(New Structure("Key", _newRow.Key))[0].Price;
				_newRow.AcceptNewPrice  = True;
				If Not ValueIsFilled(_newRow.NewPrice) Then

					_newRow.ResultPriceType = _manualPriceType;
					_newRow.ResultPrice     = _itemListRow.Price;
				
				Else
					
					If _newRow.CurrentPrice = _newRow.NewPrice Then
						_newRow.ResultPriceType = _itemListRow.PriceType;
					Else
						_newRow.ResultPriceType = _manualPriceType;
					EndIf;
						
					_newRow.ResultPrice     = _newRow.NewPrice;
										
				EndIf;
				
			EndIf;
			
		EndIf;
		
	EndDo;
EndProcedure

&AtServer
Procedure AddDocument_ItemList(_resultRow, _metadataFullName, _tabularSectionName, _rowInfo)
	_newRow = ThisObject.Documents.Add();
	_newRow.Ref               = _resultRow.Data;
	_newRow.KeySLN            = _rowInfo.KeySLN;
	_newRow.DocumentName      = _metadataFullName;
					
	_newRow.TabularSection    = _tabularSectionName;
	_newRow.DepTabularSection = "";
	_newRow.DepLineNumber     = 0;
					
	_mainRows = _resultRow.Data[_tabularSectionName].FindRows(New Structure("SerialLotNumber", _rowInfo.SerialLotNumber));
	If _mainRows.Count() <> 1 Then
		Raise StrTemplate("MainRows.Count() <> 1 :[%1] [%2]", _metadataFullName, _rowInfo.SerialLotNumber);
	EndIf;

	_newRow.RepeatingLines    = 1;
	_newRow.IsOk              = True;
					
	_newRow.Key	             = _mainRows[0].Key;
	_newRow.SerialLotNumber   = _rowInfo.SerialLotNumber;
					
	_newRow.LineNumber = _mainRows[0].LineNumber;
	_newRow.Item       = _mainRows[0].Item;
	_newRow.ItemKey    = _mainRows[0].ItemKey;
EndProcedure

&AtServer
Function ReplaceAtServer()
	_isError = True;
	BeginTransaction();
	Try
		For Each _row In ThisObject.SerialLotNumbers Do
			ReplaceRef(_row);
		EndDo;
		_isError = False;
		CommonFunctionsClientServer.ShowUsersMessage("Done");
		CommitTransaction();
	Except
		RollbackTransaction();
		ErrorInfo = ErrorDescription();
		Raise ErrorInfo;
	EndTry;
	
	Return Not _isError;
EndFunction

&AtServer
Procedure ReplaceRef(_row)
	_serialLotNumberObject = _row.SerialLotNumber.GetObject();
	_serialLotNumberObject.SerialLotNumberOwner = _row.NewItemKey;
	_serialLotNumberObject.Write();
	
	_arrayOfDocuments = ThisObject.Documents.FindRows(New Structure("KeySLN", _row.KeySLN));
	
	For Each _rowDocuments In _arrayOfDocuments Do
		If Not _rowDocuments.IsOk Then
			Raise StrTemplate("Unable replace ref [%1]", _rowDocuments.Ref);
		EndIf;
	
		_docInfo = New Structure();
		_docInfo.Insert("DocObject"   , _rowDocuments.Ref.GetObject());
		_docInfo.Insert("DocMetadata" , _rowDocuments.Ref.Metadata());
			
		_doc = BuilderAPI.Initialize(Undefined, Undefined, Undefined, Undefined, _docInfo);
		BuilderAPI.SetRowProperty(_doc, _rowDocuments.Key, "Item"    , _row.NewItem    , _rowDocuments.TabularSection);
		BuilderAPI.SetRowProperty(_doc, _rowDocuments.Key, "ItemKey" , _row.NewItemKey , _rowDocuments.TabularSection);
		
		If _rowDocuments.AcceptNewPrice Then
			BuilderAPI.SetRowProperty(_doc, _rowDocuments.Key, "PriceType" , _rowDocuments.ResultPriceType , _rowDocuments.TabularSection);
			BuilderAPI.SetRowProperty(_doc, _rowDocuments.Key, "Price"     , _rowDocuments.ResultPrice     , _rowDocuments.TabularSection);
		EndIf;
		
		If _doc.Object.Posted Then
			BuilderAPI.Write(_doc, DocumentWriteMode.Posting);
		Else
			BuilderAPI.Write(_doc, DocumentWriteMode.Write);
		EndIf;
	EndDo;
	
	_arrayOfRegisters = ThisObject.Registers.FindRows(New Structure("KeySLN", _row.KeySLN));
	
	For Each _rowRegisters In _arrayOfRegisters Do
		_registerName = TrimAll(StrSplit(_rowRegisters.RegisterName, ".")[1]);
		_recordManager = InformationRegisters[_registerName].CreateRecordManager();
		
		_dimensionsRows = ThisObject.Dimensions.FindRows(New Structure("RecordUUID", _rowRegisters.RecordUUID));
		_resourcesRows = ThisObject.Resources.FindRows(New Structure("RecordUUID", _rowRegisters.RecordUUID));
		
		For Each _dimensionRow In _dimensionsRows Do
			_recordManager[_dimensionRow.Name] = _dimensionRow.Value;
		EndDo;
		
		_recordManager.Read();
		
		If _recordManager.Selected() Then
			
			For Each _dimensionRow In _dimensionsRows Do
				If ValueIsFilled(_dimensionRow.NewValue) Then
					_recordManager[_dimensionRow.Name] = _dimensionRow.NewValue;
				EndIf;
			EndDo;
		
			For Each _resourcesRow In _resourcesRows Do
				If ValueIsFilled(_resourcesRow.NewValue) Then
					_recordManager[_resourcesRow.Name] = _resourcesRow.NewValue;
				EndIf;
			EndDo;
			
		EndIf;
		_recordManager.Write();
	EndDo;	
EndProcedure
