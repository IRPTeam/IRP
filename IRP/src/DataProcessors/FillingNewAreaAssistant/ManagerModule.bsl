
Procedure CreateDefaultObjects() Export	
	KeyAttribute = "Description_en";
	LangCodeEn   = "en";     
	
	// Default Price types
	FillingFromClassifiers.CreateCatalogItemFromClassifier("Catalog.PriceTypes", 
							KeyAttribute, 
							R(LangCodeEn).Class_001);
	FillingFromClassifiers.CreateCatalogItemFromClassifier("Catalog.PriceTypes", 
							KeyAttribute, 
							R(LangCodeEn).Class_002);
	FillingFromClassifiers.CreateCatalogItemFromClassifier("Catalog.PriceTypes", 
							KeyAttribute, 
							R(LangCodeEn).Class_003);
		
	// Item types
	FillingFromClassifiers.CreateCatalogItemFromClassifier("Catalog.ItemTypes", 
							KeyAttribute, 
							R(LangCodeEn).Class_004);
	FillingFromClassifiers.CreateCatalogItemFromClassifier("Catalog.ItemTypes", 
							KeyAttribute, 
							R(LangCodeEn).Class_005);
		
	// Main store
	MainStore = FillingFromClassifiers.CreateCatalogItemFromClassifier("Catalog.Stores", 
							KeyAttribute, 
							R(LangCodeEn).Class_006);
		
	// Main Manager
	FillingFromClassifiers.CreateCatalogItemFromClassifier("Catalog.PartnerSegments", 
							KeyAttribute, 
							R(LangCodeEn).Class_007);
							
	// Default Unit pcs
	FillingFromClassifiers.CreateCatalogItemFromClassifier("Catalog.Units", 
							KeyAttribute, 
							R(LangCodeEn).Class_008);
							
	// Object statuses
	CreateDefaultObjectStatuses();	
	
	
	// User settings
	FillDefaultUserSettings(New Structure("Store", MainStore));
	
EndProcedure

Procedure CreateAdminAccessGroup(AdminUser) Export	
	
	// Profile
	ProfileObject = Catalogs.AccessProfiles.CreateItem();
	DescriptionStructure = FillingFromClassifiers.DescriptionStructure("Admin");
	FillPropertyValues(ProfileObject, DescriptionStructure);
	NewRow = ProfileObject.Roles.Add();
	NewRow.Role          = "FullAccess";
	NewRow.Configuration = "IRP";
	NewRow = ProfileObject.Roles.Add();
	NewRow.Role          = "RunWebClient";
	NewRow.Configuration = "IRP";
	ProfileObject.Write();
	
	// Access group
	AccessGroupObject = Catalogs.AccessGroups.CreateItem();
	DescriptionStructure = FillingFromClassifiers.DescriptionStructure("Admin");
	FillPropertyValues(AccessGroupObject, DescriptionStructure);
	
	AccessGroupObject.Profiles.Add().Profile = ProfileObject.Ref;
	
	AccessGroupObject.Users.Add().User = AdminUser;
	AccessGroupObject.Write();
	
EndProcedure

Procedure CreateDefaultObjectStatuses()
	// Object statuses
	ParentsArray = New Array;
	ParentsArray.Add(Catalogs.ObjectStatuses.InventoryTransferOrder);
	ParentsArray.Add(Catalogs.ObjectStatuses.OutgoingPaymentOrder);
	ParentsArray.Add(Catalogs.ObjectStatuses.PurchaseOrder);
	ParentsArray.Add(Catalogs.ObjectStatuses.PurchaseReturnOrder);
	ParentsArray.Add(Catalogs.ObjectStatuses.ReconciliationStatement);
	ParentsArray.Add(Catalogs.ObjectStatuses.SalesOrder);
	ParentsArray.Add(Catalogs.ObjectStatuses.SalesReturnOrder);
	
	// Status Draft
	ClassifierElementDraft = FillingFromClassifiers.GetElementFromClassifier("Catalog.ObjectStatuses", 
							"Description_en", "Draft");
	If ClassifierElementDraft <> Undefined Then
		For Each StatusParent In ParentsArray Do
			ClassifierElementDraft.Insert("Parent", StatusParent);
			FillingFromClassifiers.CreateCatalogItemFromClassifierElement(
										"Catalog.ObjectStatuses", ClassifierElementDraft);	
		EndDo;
	EndIf;
	
	// Status Approved 
	ClassifierElementApproved = FillingFromClassifiers.GetElementFromClassifier("Catalog.ObjectStatuses", 
							"Description_en", "Approved");
	If ClassifierElementApproved <> Undefined Then
		For Each StatusParent In ParentsArray Do
			ClassifierElementApproved.Insert("Parent", StatusParent);
			FillingFromClassifiers.CreateCatalogItemFromClassifierElement(
										"Catalog.ObjectStatuses", ClassifierElementApproved);	
		EndDo;
	EndIf;
EndProcedure

Procedure FillDefaultUserSettings(DefaultValues) Export
	InfoRegMetadata = Metadata.InformationRegisters.UserSettings;
	TableOfSettings = New ValueTable();
	TableOfSettings.Columns.Add("MetadataObject", InfoRegMetadata.Dimensions.MetadataObject.Type);
	TableOfSettings.Columns.Add("AttributeName", InfoRegMetadata.Dimensions.AttributeName.Type);
	TableOfSettings.Columns.Add("Value", InfoRegMetadata.Resources.Value.Type);
	TableOfSettings.Columns.Add("KindOfAttribute", InfoRegMetadata.Resources.KindOfAttribute.Type);
	
	For Each MetadataObject In Metadata.Documents Do
		For Each Attribute In MetadataObject.Attributes Do
			If Not DefaultValues.Property(Attribute.Name)
					OR  Not AccessRight("View", Attribute, Metadata.Roles.FilterForUserSettings) Then
				Continue;
			EndIf;
			
			NewRow = TableOfSettings.Add();
			NewRow.MetadataObject  = MetadataObject.FullName();
			NewRow.AttributeName   = Attribute.Name;
			NewRow.Value           = DefaultValues[Attribute.Name];
			NewRow.KindOfAttribute = Enums.KindsOfAttributes.Regular;
		EndDo;
	EndDo;
	
	Query = New Query(
	"SELECT
	|	Table.MetadataObject,
	|	Table.AttributeName,
	|	Table.Value,
	|	Table.KindOfAttribute
	|into tmp
	|FROM
	|	&TableOfSettings AS Table
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	UserGroups.Ref AS UserOrGroup,
	|	tmp.MetadataObject,
	|	tmp.AttributeName,
	|	tmp.Value,
	|	tmp.KindOfAttribute
	|FROM
	|	Catalog.UserGroups AS UserGroups,
	|	tmp AS tmp
	|WHERE
	|	NOT UserGroups.DeletionMark");
	Query.SetParameter("TableOfSettings", TableOfSettings);
	Selection = Query.Execute().Select();
	While Selection.Next() Do
		RecordManager = InformationRegisters.UserSettings.CreateRecordManager();
		FillPropertyValues(RecordManager, Selection);
		RecordManager.Write();
	EndDo;
	
EndProcedure
