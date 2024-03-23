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

Procedure DeleteAvailableAttribute(ItemType, Attribute) Export
	If Not TransactionActive() Then
		//@skip-check rollback-transaction, commit-transaction
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