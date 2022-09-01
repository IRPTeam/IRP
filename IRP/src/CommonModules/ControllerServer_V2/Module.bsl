
Function GetServerData(Object, ArrayOfTableNames, FormTaxColumnsExists, TaxesCache, LoadDataAddress) Export
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
	ServerData.LoadData.Insert("CountRows", 0);
	
	SerialLotNumberExists = ServerData.ObjectMetadataInfo.Tables.Property("SerialLotNumbers");
	
	If  ValueIsFilled(LoadDataAddress) Then
		GroupColumns = "Item, ItemKey, Unit"; // all defined columns in GetItemInfo.GetTableofResults
		If Not SerialLotNumberExists Then
			GroupColumns = GroupColumns + ", SerialLotNumber";
		EndIf;
		ServerData.LoadData.SourceColumnsGroupBy = GroupColumns;
		SourceTable = GetFromTempStorage(LoadDataAddress);
		SourceTableCopy = SourceTable.Copy();
		SourceTableCopy.GroupBy(GroupColumns);
		ServerData.LoadData.CountRows = SourceTableCopy.Count();
	EndIf;
	Return ServerData;
EndFunction
