Procedure SetDataLock(DataLock, ItemType)
	DataSource = New ValueTable();
	DataSource.Columns.Add("Ref", New TypeDescription("CatalogRef.ItemTypes"));
	DataSource.Add().Ref = ItemType;
	
	ItemLock = DataLock.Add("Catalog.ItemTypes");
	ItemLock.Mode = DataLockMode.Exclusive;
	ItemLock.DataSource = DataSource;
	ItemLock.UseFromDataSource("Ref", "Ref");
	DataLock.Lock();
EndProcedure

Procedure AddAvailableAttribute(ItemType, Attribute) Export
	If Not TransactionActive() Then
		BeginTransaction(DataLockControlMode.Managed);
		Try
			AddDataToObject(ItemType, Attribute);
			If TransactionActive() Then
				CommitTransaction();
			EndIf;
		Except
			If TransactionActive() Then
				RollbackTransaction();
			EndIf;
		EndTry;
	Else
		AddDataToObject(ItemType, Attribute);
	EndIf;
EndProcedure

Procedure AddDataToObject(ItemType, Attribute)
	DataLock = New DataLock();
	SetDataLock(DataLock, ItemType);
	
	CatalogObject = ItemType.GetObject();
	Filter = New Structure("Attribute", Attribute);
	ArrayOfRows = CatalogObject.AvailableAttributes.FindRows(Filter);
	If Not ArrayOfRows.Count() Then
		NewRow = CatalogObject.AvailableAttributes.Add();
		NewRow.Attribute = Attribute;
		CatalogObject.Write();
	EndIf;
EndProcedure

Procedure DeleteAvailableAttribute(ItemType, Attribute) Export
	If Not TransactionActive() Then
		BeginTransaction(DataLockControlMode.Managed);
		Try
			DeleteDataFromObject(ItemType, Attribute);
			If TransactionActive() Then
				CommitTransaction();
			EndIf;
		Except
			If TransactionActive() Then
				RollbackTransaction();
			EndIf;
		EndTry;
	Else
		DeleteDataFromObject(ItemType, Attribute);
	EndIf;
EndProcedure

Procedure DeleteDataFromObject(ItemType, Attribute)
	DataLock = New DataLock();
	SetDataLock(DataLock, ItemType);
	
	CatalogObject = ItemType.GetObject();
	Filter = New Structure("Attribute", Attribute);
	ArrayOfRows = CatalogObject.AvailableAttributes.FindRows(Filter);
	For Each Row In ArrayOfRows Do
		CatalogObject.AvailableAttributes.Delete(Row);
	EndDo;
	If ArrayOfRows.Count() Then
		CatalogObject.Write();
	EndIf;
EndProcedure