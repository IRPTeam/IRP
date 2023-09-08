
Function GetServerData(Object, ArrayOfTableNames, LoadParameters) Export
	ServerData = New Structure();
	ObjectMetadataInfo = ViewServer_V2.GetObjectMetadataInfo(Object, StrConcat(ArrayOfTableNames, ","));
	ServerData.Insert("ObjectMetadataInfo", ObjectMetadataInfo);
	
	//#@2094
//	If FOClientServer.IsUseMultiTaxes() Then
//		ServerData.Insert("ArrayOfTaxInfo", New Array());
//		If ServerData.ObjectMetadataInfo.Tables.Property("TaxList") Then
//			If FormTaxColumnsExists Then
//				DeserializedCache = CommonFunctionsServer.DeserializeXMLUseXDTO(TaxesCache);
//				ServerData.ArrayOfTaxInfo = DeserializedCache.ArrayOfTaxInfo;
//			Else
//				TransactionType = Undefined;
//				If CommonFunctionsClientServer.ObjectHasProperty(Object, "TransactionType") Then
//					TransactionType = Object.TransactionType;
//				EndIf;
//				ServerData.ArrayOfTaxInfo = TaxesServer.GetArrayOfTaxInfo(Object, Object.Date, Object.Company, TransactionType);
//			EndIf;
//		EndIf;
//	EndIf;
	
	ServerData.Insert("LoadData", New Structure());
	ServerData.LoadData.Insert("SourceColumnsGroupBy", "");
	ServerData.LoadData.Insert("SourceColumnsSumBy"  , "");
	ServerData.LoadData.Insert("CountRows", 0);
	
	SerialLotNumberExists = ServerData.ObjectMetadataInfo.Tables.Property("SerialLotNumbers");
	
	If Not SerialLotNumberExists Then
		ObjectRefType = TypeOf(Object.Ref);
	
		If ObjectRefType = Type("DocumentRef.PhysicalInventory")
			Or ObjectRefType = Type("DocumentRef.PhysicalCountByLocation") Then
			SerialLotNumberExists = Object.UseSerialLot;
		EndIf;
	EndIf;
	
	If  ValueIsFilled(LoadParameters.Address) Then
		SourceTable = GetFromTempStorage(LoadParameters.Address);
		SourceTableCopy = SourceTable.Copy();
		
		// group columns
		If ValueIsFilled(LoadParameters.GroupColumns) Then
			GroupColumns = LoadParameters.GroupColumns;
		Else
			GroupColumns = "Item, ItemKey, Unit"; // all defined columns in GetItemInfo.GetTableOfResults
		EndIf;
		
		If SerialLotNumberExists And SourceTableCopy.Columns.Find("SerialLotNumber") <> Undefined Then
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
				If RowItemKey.ItemKey.Item.ItemType.NotUseLineGrouping And SerialLotNumberExists Then
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

Procedure UpdateArrayOfStructures(ArrayFrom, ArrayTo) Export
	For Each Row0 In ArrayFrom Do
		For Each Row1 In ArrayTo Do
			If Row0.Key = Row1.Key Then
				For Each KeyValue In Row0 Do
					Row1[KeyValue.Key] = KeyValue.Value;
				EndDo;
			EndIf;
		EndDo;
	EndDo;
EndProcedure

Function ArrayOfStructuresIsEqual(Array0, Array1, StructureKeys) Export
	If Array0.Count() = 0 And Array1.Count() = 0 Then
		Return New Array();
	EndIf;
		
	Table0 = New ValueTable();
	Table1 = New ValueTable();
	
	ArrayOfColumns = New Array();
	For Each ColumnsName In StrSplit(StructureKeys, ",") Do
		ArrayOfColumns.Add(TrimAll(ColumnsName));
	EndDo;
	
	For Each ColumnName In ArrayOfColumns Do
		Table0.Columns.Add(ColumnName);
		Table1.Columns.Add(ColumnName);
	EndDo;
	
	For Each Row In Array0 Do
		FillPropertyValues(Table0.Add(), Row, StructureKeys);
	EndDo;
	
	For Each Row In Array1 Do
		FillPropertyValues(Table1.Add(), Row, StructureKeys);
	EndDo;
	
	Return ValueTablesIsEqual(Table0, Table1);
EndFunction
	
Function ValueTablesIsEqual(Table0, Table1) Export
	AllColumns = "";
	For Each Column In Table0.Columns Do
		AllColumns = AllColumns + ", " + Column.Name;
	EndDo;
	AllColumns = Mid(AllColumns, 2);
	
	Table = Table1.Copy();
	Table.Columns.Add("Sign", New TypeDescription("Number"));
	Table.FillValues(1, "Sign");
	
	For Each Row In Table0 Do
		FillPropertyValues(Table.Add(), Row);
	EndDo;
	
	Table.Columns.Add("Count");
	Table.FillValues(1, "Count");
	Table.GroupBy(AllColumns, "Sign, Count");
	
	Result = Table.Copy(New Structure("Count", 1), AllColumns + ", Sign");
	Return Result;
EndFunction
	