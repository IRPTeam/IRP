Procedure FillingWithDefaultDataFilling(Source, FillingData, FillingText, StandardProcessing) Export
	Data = New Structure();
	
	Data.Insert("Author", SessionParameters.CurrentUser);
	FillPropertyValues(Source, Data);
	FilterParameters = New Structure();
	FilterParameters.Insert("MetadataObject", Source.Metadata());
	UserSettings = UserSettingsServer.GetUserSettings(SessionParameters.CurrentUser, FilterParameters);
	Data = New Structure();
	Data.Insert("ManagerSegment", SessionParameters.CurrentUserPartner);
	For Each Row In UserSettings Do
		If Row.KindOfAttribute = Enums.KindsOfAttributes.Regular
			Or Row.KindOfAttribute = Enums.KindsOfAttributes.Common Then
			Data.Insert(Row.AttributeName, Row.Value);
		EndIf;
	EndDo;
	
	For Each KeyValue In Data Do
		FillAtribute = ServiceSystemClientServer.ObjectHasAttribute(KeyValue.Key, Source);
		If FillAtribute Then		
			If TypeOf(Source[KeyValue.Key]) = Type("Boolean")
				And Not Source[KeyValue.Key] Then
				Source[KeyValue.Key] = KeyValue.Value;
			Else
				If Not ValueIsFilled(Source[KeyValue.Key]) Then
					Source[KeyValue.Key] = KeyValue.Value;
				EndIf;
			EndIf;
		EndIf;
	EndDo;	
	
	Attributes = Source.Metadata().Attributes;
	
	AgreementAttribute = Attributes.Find("Agreement");
	If AgreementAttribute <> Undefined And AgreementAttribute.Type = New TypeDescription("CatalogRef.Agreements") Then
	
		If Attributes.Find("Partner") <> Undefined And ValueIsFilled(Source.Partner) And ValueIsFilled(Source.Agreement) Then
			AgreementParameters = New Structure();
			AgreementParameters.Insert("Partner"		, Source.Partner);
			AgreementParameters.Insert("Agreement"		, Source.Agreement);
			AgreementParameters.Insert("CurrentDate"	, CurrentDate());
			AgreementParameters.Insert("ArrayOfFilters"	, New Array());
			AgreementParameters.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
			AgreementParameters.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Kind", 
															PredefinedValue("Enum.AgreementKinds.Standard"), ComparisonType.NotEqual));
			Source.Agreement = DocumentsServer.GetAgreementByPartner(AgreementParameters);
		EndIf;
	EndIf;
	
	StatusAttribute = Attributes.Find("Status");
	If StatusAttribute <> Undefined
		And Source.Metadata().Attributes.Find("Status").Type = New TypeDescription("CatalogRef.ObjectStatuses") Then
		Source.Status = ObjectStatusesServer.GetStatusByDefault(Source.Ref);
	EndIf;
EndProcedure

Procedure ClearDocumentBasisesOnCopy(Source, CopiedObject) Export
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
EndProcedure

