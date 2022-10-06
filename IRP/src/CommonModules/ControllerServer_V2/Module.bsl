
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
			GroupColumns = "Item, ItemKey, Unit"; // all defined columns in GetItemInfo.GetTableofResults
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
		
		SourceTableCopy.GroupBy(GroupColumns);
		ServerData.LoadData.CountRows = SourceTableCopy.Count();
	EndIf;
	Return ServerData;
EndFunction
