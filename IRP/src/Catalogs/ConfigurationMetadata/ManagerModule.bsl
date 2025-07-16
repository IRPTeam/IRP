
Function GetAttributeNamesByObject(Object) Export
	
	Result = New Structure;
	Result.Insert("Attributes", New Map);
	Result.Insert("Tables", New Map);
	
	MetaObject = Object.Ref.Metadata();
	
	For Each AttributItem In Metadata.CommonAttributes Do
		If Not CommonFunctionsServer.isCommonAttributeUseForMetadata(AttributItem.Name, MetaObject) Then
			Continue;
		EndIf;
		Result.Attributes.Insert(AttributItem.Name, AttributItem.Synonym);
	EndDo;
	For Each AttributItem In MetaObject.Attributes Do
		Result.Attributes.Insert(AttributItem.Name, AttributItem.Synonym);
	EndDo;
	
	For Each TabularItem In MetaObject.TabularSections Do
		TableStructure = New Structure;
		TableStructure.Insert("Synonym", TabularItem.Synonym);
		TableStructure.Insert("Attributes", New Map);
		For Each AttributItem In TabularItem.Attributes Do
			TableStructure.Attributes.Insert(AttributItem.Name, AttributItem.Synonym);
		EndDo;
		Result.Tables.Insert(TabularItem.Name, TableStructure);
	EndDo;
	
	Return Result;
	
EndFunction