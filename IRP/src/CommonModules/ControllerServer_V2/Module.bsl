
Function GetServerData(Object, ArrayOfTableNames, FormTaxColumnsExists, TaxesCache, LoadParameters) Export
	ServerData = New Structure();
	ObjectMetadataInfo = ViewServer_V2.GetObjectMetadataInfo(Object, StrConcat(ArrayOfTableNames, ","));
	ServerData.Insert("ObjectMetadataInfo", ObjectMetadataInfo);
	
	ServerData.Insert("ArrayOfTaxInfo", New Array());
	If ServerData.ObjectMetadataInfo.Tables.Property("TaxList") Then
		If FormTaxColumnsExists Then
			DeserializedCache = CommonFunctionsServer.DeserializeXMLUseXDTO(TaxesCache);
			ServerData.ArrayOfTaxInfo = DeserializedCache.ArrayOfTaxInfo;
		Else
			ServerData.ArrayOfTaxInfo = TaxesServer._GetArrayOfTaxInfo(Object, Object.Date, Object.Company);
		EndIf;
	EndIf;
	
	ServerData.Insert("LoadData", New Structure());
	ServerData.LoadData.Insert("SourceColumnsGroupBy", "");
	ServerData.LoadData.Insert("SourceColumnsSumBy"  , "");
	ServerData.LoadData.Insert("CountRows", 0);
	
	SerialLotNumberExists = ServerData.ObjectMetadataInfo.Tables.Property("SerialLotNumbers");
	
	If  ValueIsFilled(LoadParameters.Address) Then
		SourceTable = GetFromTempStorage(LoadParameters.Address);
		SourceTableCopy = SourceTable.Copy();
		
		// group columns
		If ValueIsFilled(LoadParameters.GroupColumns) Then
			GroupColumns = LoadParameters.GroupColumns;
		Else
			GroupColumns = "Item, ItemKey, Unit"; // all defined columns in GetItemInfo.GetTableOfResults
		EndIf;
		
		If Not SerialLotNumberExists And SourceTableCopy.Columns.Find("SerialLotNumber") <> Undefined Then
			GroupColumns = GroupColumns + ", SerialLotNumber";
		EndIf;
		
		// sum columns
		If ValueIsFilled(LoadParameters.SumColumns) Then
			SumColumns = LoadParameters.SumColumns;
		Else
			SumColumns = "Quantity";
		EndIf;
		
		ServerData.LoadData.SourceColumnsGroupBy = GroupColumns;
		ServerData.LoadData.SourceColumnsSumBy   = SumColumns;
		
		ColumnItemKeyIsGroupColumn = False;
		For Each ColumnName In StrSplit(GroupColumns, ",") Do
			If Upper(TrimAll(ColumnName)) = Upper("ItemKey") Then
				ColumnItemKeyIsGroupColumn = True;
				Break;
			EndIf;
		EndDo;
		
		If ColumnItemKeyIsGroupColumn Then
			SourceTableBuffer = SourceTable.CopyColumns();
			ArrayForDelete = New Array();
		
			ItemKeyTable = SourceTable.Copy();
			ItemKeyTable.GroupBy("ItemKey");
		
			For Each RowItemKey In ItemKeyTable Do
				If RowItemKey.ItemKey.Item.ItemType.NotUseLineGrouping Then
					SourceTableRows = SourceTable.FindRows(New Structure("ItemKey", RowItemKey.ItemKey));
					For Each Row In SourceTableRows Do
						FillPropertyValues(SourceTableBuffer.Add(), Row);
						ArrayForDelete.Add(Row);
					EndDo;
				EndIf;
			EndDo;
		
			For Each ItemForDelete In ArrayForDelete Do
				SourceTable.Delete(ItemForDelete);
			EndDo;
			
			TempStorageData = New Structure();
			TempStorageData.Insert("SourceTable"       , SourceTable);
			TempStorageData.Insert("SourceTableBuffer" , SourceTableBuffer);
			
			LoadParameters.Address = PutToTempStorage(TempStorageData, LoadParameters.Address);
			
			SourceTableCopy = SourceTable.Copy();
			SourceTableCopy.GroupBy(GroupColumns);
			ServerData.LoadData.CountRows = SourceTableCopy.Count() + SourceTableBuffer.Count();
		Else	
			
			SourceTableCopy.GroupBy(GroupColumns);
			ServerData.LoadData.CountRows = SourceTableCopy.Count();
			
		EndIf;
	EndIf;
	Return ServerData;
EndFunction
