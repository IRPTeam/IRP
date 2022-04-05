

Function GetServerData(Object, ArrayOfTableNames, FormTaxColumnsExists, TaxesCache) Export
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
	Return ServerData;
EndFunction