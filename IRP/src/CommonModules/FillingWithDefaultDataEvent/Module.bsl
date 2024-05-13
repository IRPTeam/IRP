Procedure FillingDocumentsWithDefaultData(Source, FillingData, FillingText, StandardProcessing, Force = False) Export
	If Force = Undefined Then
		Force = False;
	EndIf;

	IsUsedNewFunctionality = UsedNewFunctionality(Source);

	Data = New Structure();

	Data.Insert("Author", SessionParameters.CurrentUser);
	FillPropertyValues(Source, Data);

	FilterParameters = New Structure();
	FilterParameters.Insert("MetadataObject", Source.Metadata());
	UserSettings = UserSettingsServer.GetUserSettings(SessionParameters.CurrentUser, FilterParameters);

	Data = New Structure();
	Data.Insert("ManagerSegment", SessionParameters.CurrentUserPartner);
	Data.Insert("Workstation"   , SessionParameters.Workstation);
	
	For Each Row In UserSettings Do
		If Row.KindOfAttribute = Enums.KindsOfAttributes.Regular 
			Or Row.KindOfAttribute = Enums.KindsOfAttributes.Common Then
			Data.Insert(Row.AttributeName, Row.Value);
		EndIf;
	EndDo;
	
	If Not Data.Property("Store") And Not FOServer.IsUseStores() Then
		Data.Insert("Store", Catalogs.Stores.Default);
	EndIf;
	
	If IsUsedNewFunctionality Then
		ArrayOfAllMainTables = New Array();
		ArrayOfAllMainTables.Add("ItemList");
		ArrayOfAllMainTables.Add("PaymentList");
		ArrayOfAllMainTables.Add("Transactions");
		ArrayOfAllMainTables.Add("Productions");
		
		ArrayOfMainTables = New Array();
		For Each TableName In ArrayOfAllMainTables Do
			If CommonFunctionsClientServer.ObjectHasProperty(Source, TableName) Then
				ArrayOfMainTables.Add(TableName);
			EndIf;
		EndDo;
		If Not ArrayOfMainTables.Count() Then
			ArrayOfMainTables.Add("");
		EndIf;
		
		ArrayOfAllSubordinateTables = New Array();
		ArrayOfAllSubordinateTables.Add("Materials");
		
		ArrayOfSubordinateTables = New Array();
		For Each TableName In ArrayOfAllSubordinateTables Do
			If CommonFunctionsClientServer.ObjectHasProperty(Source, TableName) Then
				ArrayOfSubordinateTables.Add(TableName);
			EndIf;
		EndDo;
		
		// properties from UserSettings
		ArrayOfUserSettingsProperties = New Array();
		For Each KeyValue In Data Do
			If CommonFunctionsClientServer.ObjectHasProperty(Source, KeyValue.Key) 
				And ValueIsFilled(Data[KeyValue.Key]) Then				
				ArrayOfUserSettingsProperties.Add(TrimAll(KeyValue.Key));	
			EndIf;
		EndDo;
		UserSettingsProperties = StrConcat(ArrayOfUserSettingsProperties, ",");
	
		ReadOnlyProperties = "";
		Source.AdditionalProperties.Property("ReadOnlyProperties", ReadOnlyProperties);
		ReadOnlyProperties = ?(ReadOnlyProperties = Undefined, "", ReadOnlyProperties);
		
		IsBasedOn = False;
		Source.AdditionalProperties.Property("IsBasedOn", IsBasedOn);
		IsBasedOn = ?(IsBasedOn = Undefined, False, IsBasedOn);
		
		// if document was generated on basis, then it already has completed attributes
		// list of completed attributes in ReadOnlyProperties
		// need call handler OnChange for each already filled attribute
	
		ArrayOfAllProperties = StrSplit(ReadOnlyProperties, ",");
		
		ArrayOfUserSettingsProperties   = StrSplit(UserSettingsProperties, ",");
		ArrayOfBasisDocumentProperties = New Array();
		ArrayOfSubordinateTablesProperties = New Array();
		
		For Each SubordinateTableName In ArrayOfSubordinateTables Do
			For Each DataPath In ArrayOfAllProperties Do
				_DataPath = TrimAll(DataPath);
				Segments = StrSplit(_DataPath, ".");
				If Segments.Count() = 2 And StrStartsWith(Segments[0], SubordinateTableName) Then
					ArrayOfSubordinateTablesProperties.Add(_DataPath);
				EndIf;
			EndDo;
		EndDo;
		
		For Each BasisProp In ArrayOfAllProperties Do
			PropIsExists = False;
			For Each SubProp In ArrayOfSubordinateTablesProperties Do
				If TrimAll(Upper(BasisProp)) = TrimAll(Upper(SubProp)) Then
					PropIsExists = True;
					Break;
				EndIf;
			EndDo;
			
			If Not PropIsExists Then
				ArrayOfBasisDocumentProperties.Add(BasisProp);
			EndIf;
		EndDo;
		
		Info = New Structure();
		Info.Insert("ReadOnlyProperties"     , ReadOnlyProperties);
		Info.Insert("UserSettingsProperties" , UserSettingsProperties);
		Info.Insert("Data"                   , Data);
		
		For Each TableName In ArrayOfMainTables Do
			ProcessProperties(Info, Source, IsBasedOn, TableName, ArrayOfBasisDocumentProperties);
			ViewServer_V2.ExecuteCommandAtServer(Source, TableName, "Command_RecalculationWhenBasedOn");
		EndDo;
		
		For Each TableName In ArrayOfSubordinateTables Do
			ProcessProperties(Info, Source, IsBasedOn, TableName, ArrayOfSubordinateTablesProperties);
		EndDo;
		
		For Each TableName In ArrayOfMainTables Do
			ProcessPropertiesByUserSettings(Info, Source, IsBasedOn, TableName, ArrayOfUserSettingsProperties, ArrayOfBasisDocumentProperties, ArrayOfSubordinateTables);
		EndDo;
				
	EndIf; // IsUsedNewFunctionality 
	
	For Each KeyValue In Data Do
		If CommonFunctionsClientServer.ObjectHasProperty(Source, KeyValue.Key) Then
			If TypeOf(Source[KeyValue.Key]) = Type("Boolean") And Not Source[KeyValue.Key] Then
				Source[KeyValue.Key] = KeyValue.Value;
			ElsIf Not ValueIsFilled(Source[KeyValue.Key]) Or Force Then
				Source[KeyValue.Key] = KeyValue.Value;
			EndIf;
		EndIf;
	EndDo;

	Attributes = Source.Metadata().Attributes;
	
	StatusAttribute = Attributes.Find("Status");
	If StatusAttribute <> Undefined And StatusAttribute.Type = New TypeDescription("CatalogRef.ObjectStatuses")
		And Not ValueIsFilled(Source.Status) Then
		Source.Status = ObjectStatusesServer.GetStatusByDefault(Source.Ref);
	EndIf;
	
	If IsUsedNewFunctionality Then
		Return;
	EndIf;
	
	UseShipmentConfirmation = False;
	If Attributes.Find("StoreSender") <> Undefined And Attributes.Find("UseShipmentConfirmation") <> Undefined Then
		UseShipmentConfirmation = Source.StoreSender.UseShipmentConfirmation;
		Source.UseShipmentConfirmation = UseShipmentConfirmation;
	EndIf;

	If Attributes.Find("StoreReceiver") <> Undefined And Attributes.Find("UseGoodsReceipt") <> Undefined Then
		Source.UseGoodsReceipt = Source.StoreReceiver.UseGoodsReceipt Or UseShipmentConfirmation;
	EndIf;

	AgreementAttribute = Attributes.Find("Agreement");
	If AgreementAttribute <> Undefined And AgreementAttribute.Type = New TypeDescription("CatalogRef.Agreements") Then

		If Attributes.Find("Partner") <> Undefined 
			And ValueIsFilled(Source.Partner) 
			And ValueIsFilled(Source.Agreement) Then
				AgreementParameters = New Structure();
				AgreementParameters.Insert("Partner"        , Source.Partner);
				AgreementParameters.Insert("Agreement"      , Source.Agreement);
				AgreementParameters.Insert("CurrentDate"    , CommonFunctionsServer.GetCurrentSessionDate());
				AgreementParameters.Insert("ArrayOfFilters" , New Array());
				AgreementParameters.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark",
					True, ComparisonType.NotEqual));
				AgreementParameters.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Kind",
					PredefinedValue("Enum.AgreementKinds.Standard"), ComparisonType.NotEqual));
				Source.Agreement = DocumentsServer.GetAgreementByPartner(AgreementParameters);
		EndIf;

	EndIf;

EndProcedure

Procedure ClearDocumentBasisesOnCopy(Source, CopiedObject) Export
	TypeOfSource = TypeOf(Source);
	ArrayOfExclude = New Array();
	ArrayOfExclude.Add(Type("DocumentObject.PriceList"));
	ArrayOfExclude.Add(Type("DocumentObject.AdditionalCostAllocation"));
	ArrayOfExclude.Add(Type("DocumentObject.AdditionalRevenueAllocation"));
	ArrayOfExclude.Add(Type("DocumentObject.ExpenseAccruals"));
	ArrayOfExclude.Add(Type("DocumentObject.RevenueAccruals"));
	If ArrayOfExclude.Find(TypeOfSource) <> Undefined Then
		Return;
	EndIf;
	
	SourceMetadata = Source.Metadata();
	For Each AttributeMetadata In SourceMetadata.Attributes Do
		If CommonFunctionsServer.IsDocumentRef(Source[AttributeMetadata.Name]) Then
			Source[AttributeMetadata.Name] = Undefined;
		EndIf;
	EndDo;
	For Each TabularSectionMetadata In SourceMetadata.TabularSections Do
		For Each AttributeMetadata In TabularSectionMetadata.Attributes Do
			For Each Row In Source[TabularSectionMetadata.Name] Do
				If CommonFunctionsServer.IsDocumentRef(Row[AttributeMetadata.Name]) Then
					Row[AttributeMetadata.Name] = Undefined;
				EndIf;
			EndDo;
		EndDo;
	EndDo;
	
	// Clear link to other rows
	If CommonFunctionsClientServer.ObjectHasProperty(Source, "RowIDInfo") Then
		Source.RowIDInfo.Clear();
	EndIf;
	
	// Clear link to other documents
	If CommonFunctionsClientServer.ObjectHasProperty(Source, "ShipmentConfirmations") Then
		Source.ShipmentConfirmations.Clear();
	EndIf;

	If CommonFunctionsClientServer.ObjectHasProperty(Source, "GoodsReceipts") Then
		Source.GoodsReceipts.Clear();
	EndIf;
	
	If CommonFunctionsClientServer.ObjectHasProperty(Source, "WorkSheets") Then
		Source.WorkSheets.Clear();
	EndIf;
	
	// Update key in tabular sections
	If CommonFunctionsClientServer.ObjectHasProperty(Source, "ItemList") Then
		LinkedTables = New Array();
		For Each TabularSectionMetadata In SourceMetadata.TabularSections Do
			If Upper(TabularSectionMetadata.Name) = Upper("ItemList") Then
				Continue;
			EndIf;
			If TabularSectionMetadata.Attributes.Find("Key") <> Undefined Then
				LinkedTables.Add(Source[TabularSectionMetadata.Name]);
			EndIf;
		EndDo;
		DocumentsServer.SetNewTableUUID(Source.ItemList, LinkedTables);
	EndIf;
EndProcedure

Procedure ProcessProperties(Info, Source, IsBasedOn, TableName, ArrayOfProperties)
	// BasisDocument
	ServerParameters = ControllerClientServer_V2.GetServerParameters(Source);
	ServerParameters.IsBasedOn          = IsBasedOn;
	ServerParameters.TableName          = TableName;
	ServerParameters.ReadOnlyProperties = Info.ReadOnlyProperties;
	Parameters = ControllerClientServer_V2.GetParameters(ServerParameters);
			
	For Each DataPath In ArrayOfProperties Do
		_DataPath = TrimAll(DataPath);
		If Not ValueIsFilled(_DataPath) Then
			Continue;
		EndIf;
				
		Property = New Structure("DataPath", _DataPath);
		ControllerClientServer_V2.API_SetProperty(Parameters, Property, Undefined);
	EndDo;
EndProcedure

Procedure ProcessPropertiesByUserSettings(Info, Source, IsBasedOn, TableName, ArrayOfUserSettingsProperties, ArrayOfBasisDocumentProperties, ArrayOfSubordinateTablesProperties)
	// UserSetting
	ServerParameters = ControllerClientServer_V2.GetServerParameters(Source);
	ServerParameters.IsBasedOn          = IsBasedOn;
	ServerParameters.TableName          = TableName;
	ServerParameters.ReadOnlyProperties = ?(ValueIsFilled(Info.ReadOnlyProperties), 
	Info.ReadOnlyProperties + ", " + Info.UserSettingsProperties, Info.UserSettingsProperties);
	Parameters = ControllerClientServer_V2.GetParameters(ServerParameters);
			
	For Each PropertyName In ArrayOfUserSettingsProperties Do
		If Not ValueIsFilled(PropertyName) Then
			Continue;
		EndIf;
		Value = Info.Data[PropertyName];
		If ValueIsFilled(Value) And Not ValueIsFilled(Source[PropertyName])
			And ArrayOfBasisDocumentProperties.Find(PropertyName) = Undefined 
			And ArrayOfSubordinateTablesProperties.Find(PropertyName) = Undefined Then
				Source[PropertyName] = Value;
		Else
			Continue;
		EndIf;
				
		DataPath = StrSplit(PropertyName, ".");
		If DataPath.Count() = 1 Then
			Property = New Structure("DataPath", TrimAll(DataPath[0]));
			ControllerClientServer_V2.API_SetProperty(Parameters, Property, Undefined);
		EndIf;
	EndDo;
EndProcedure

Function UsedNewFunctionality(Source)
	IsUsedNewFunctionality =
	   TypeOf(Source) = Type("DocumentObject.IncomingPaymentOrder")
	Or TypeOf(Source) = Type("DocumentObject.OutgoingPaymentOrder")
	
	Or TypeOf(Source) = Type("DocumentObject.MoneyTransfer")
	   
	Or TypeOf(Source) = Type("DocumentObject.BankPayment")
	Or TypeOf(Source) = Type("DocumentObject.BankReceipt")
	Or TypeOf(Source) = Type("DocumentObject.CashPayment")
	Or TypeOf(Source) = Type("DocumentObject.CashReceipt")
	
	Or TypeOf(Source) = Type("DocumentObject.CashExpense")
	Or TypeOf(Source) = Type("DocumentObject.CashRevenue")
	Or TypeOf(Source) = Type("DocumentObject.CreditNote")
	Or TypeOf(Source) = Type("DocumentObject.DebitNote")
	
	Or TypeOf(Source) = Type("DocumentObject.ShipmentConfirmation")
	Or TypeOf(Source) = Type("DocumentObject.GoodsReceipt")
	Or TypeOf(Source) = Type("DocumentObject.StockAdjustmentAsSurplus")
	Or TypeOf(Source) = Type("DocumentObject.StockAdjustmentAsWriteOff")
	Or TypeOf(Source) = Type("DocumentObject.SalesInvoice")
	Or TypeOf(Source) = Type("DocumentObject.PurchaseInvoice")
	Or TypeOf(Source) = Type("DocumentObject.InternalSupplyRequest")
	Or TypeOf(Source) = Type("DocumentObject.RetailSalesReceipt")
	
	Or TypeOf(Source) = Type("DocumentObject.SalesReturn")
	Or TypeOf(Source) = Type("DocumentObject.PurchaseReturn")
	Or TypeOf(Source) = Type("DocumentObject.RetailReturnReceipt")

	Or TypeOf(Source) = Type("DocumentObject.SalesOrder")
	Or TypeOf(Source) = Type("DocumentObject.SalesOrderClosing")
	Or TypeOf(Source) = Type("DocumentObject.PurchaseOrder")
	Or TypeOf(Source) = Type("DocumentObject.PurchaseOrderClosing")
	Or TypeOf(Source) = Type("DocumentObject.SalesReturnOrder")
	Or TypeOf(Source) = Type("DocumentObject.PurchaseReturnOrder")
	Or TypeOf(Source) = Type("DocumentObject.InventoryTransfer")
	Or TypeOf(Source) = Type("DocumentObject.InventoryTransferOrder")
	Or TypeOf(Source) = Type("DocumentObject.PhysicalInventory")
	Or TypeOf(Source) = Type("DocumentObject.ItemStockAdjustment")
	Or TypeOf(Source) = Type("DocumentObject.Bundling")
	Or TypeOf(Source) = Type("DocumentObject.Unbundling")
	Or TypeOf(Source) = Type("DocumentObject.CashStatement")
	
	Or TypeOf(Source) = Type("DocumentObject.CashTransferOrder")
	Or TypeOf(Source) = Type("DocumentObject.ChequeBondTransaction")
	Or TypeOf(Source) = Type("DocumentObject.ConsolidatedRetailSales")
	Or TypeOf(Source) = Type("DocumentObject.WorkOrder")
	Or TypeOf(Source) = Type("DocumentObject.WorkSheet")
	Or TypeOf(Source) = Type("DocumentObject.ProductionPlanning")
	Or TypeOf(Source) = Type("DocumentObject.ProductionPlanningCorrection")
	Or TypeOf(Source) = Type("DocumentObject.ProductionPlanningClosing")
	Or TypeOf(Source) = Type("DocumentObject.Production")
	Or TypeOf(Source) = Type("DocumentObject.SalesReportFromTradeAgent")
	Or TypeOf(Source) = Type("DocumentObject.SalesReportToConsignor")
	Or TypeOf(Source) = Type("DocumentObject.EmployeeCashAdvance")
	Or TypeOf(Source) = Type("DocumentObject.ProductionCostsAllocation")
	Or TypeOf(Source) = Type("DocumentObject.TimeSheet")
	Or TypeOf(Source) = Type("DocumentObject.Payroll")
	Or TypeOf(Source) = Type("DocumentObject.ForeignCurrencyRevaluation")
	Or TypeOf(Source) = Type("DocumentObject.RetailShipmentConfirmation")
	Or TypeOf(Source) = Type("DocumentObject.RetailGoodsReceipt");
	
	Return IsUsedNewFunctionality;
EndFunction

Procedure FillingCatalogsWithDefaultData(Source, FillingData, FillingText, StandardProcessing) Export
	Data = New Structure();

	FilterParameters = New Structure();
	FilterParameters.Insert("MetadataObject", Source.Metadata());
	UserSettings = UserSettingsServer.GetUserSettings(SessionParameters.CurrentUser, FilterParameters);

	Data = New Structure();
	
	For Each Row In UserSettings Do
		If Row.KindOfAttribute = Enums.KindsOfAttributes.Regular 
			Or Row.KindOfAttribute = Enums.KindsOfAttributes.Common Then
			Data.Insert(Row.AttributeName, Row.Value);
		EndIf;
	EndDo;
	
	For Each KeyValue In Data Do
		If CommonFunctionsClientServer.ObjectHasProperty(Source, KeyValue.Key) Then
			If TypeOf(Source[KeyValue.Key]) = Type("Boolean") And Not Source[KeyValue.Key] Then
				Source[KeyValue.Key] = KeyValue.Value;
			ElsIf Not ValueIsFilled(Source[KeyValue.Key]) Then
				Source[KeyValue.Key] = KeyValue.Value;
			EndIf;
		EndIf;
	EndDo;
EndProcedure

