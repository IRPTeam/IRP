&AtClient
Var CurrentDocument;

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Parameters.Property("DocumentRef") Then
		ThisObject.DocumentRef = Parameters.DocumentRef;
		Title = String(Parameters.DocumentRef);
	Else
		Cancel = True;
	EndIf;
	If Not Cancel Then
		GenerateTree();
	EndIf;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	ExpandDocumentsTree();
	SetVisibleToAllAttributesValueTable(False);
EndProcedure

&AtServer
Procedure GenerateTree()
	ThisObject.DocumentsTree.GetItems().Clear();
	ThisObject.Cache.Clear();
	ThisObject.CacheAttributes.Clear();
	DocumentTreeItems = ThisObject.DocumentsTree;
	OutputParentDocuments(ThisObject.DocumentRef, DocumentTreeItems);
	OutputChildrenDocuments(DocumentTreeItems);
EndProcedure

&AtServer
Procedure UpdateCommandAvailability()
	CurrentRow = Items.DocumentsTree.CurrentRow;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	CurrentData = ThisObject.DocumentsTree.FindByID(Items.DocumentsTree.CurrentRow);
	If CurrentData = Undefined Then
		Return;
	EndIf;

	If CurrentData.Ref = Undefined Then
		Items.DocumentsTreePost.Enabled = False;
		Items.DocumentsTreeUnpost.Enabled = False;
		Items.DocumentsTreeEdit.Enabled = False;
		Items.DocumentsTreeDelete.Enabled = False;
		Items.DocumentsTreeContextMenuPost.Enabled = False;
		Items.DocumentsTreeContextMenuUnpost.Enabled = False;
		Items.DocumentsTreeContextMenuEdit.Enabled = False;
		Items.DocumentsTreeContextMenuDelete.Enabled = False;
	Else
		CanPosting = CurrentData.Ref.Metadata().Posting = Metadata.ObjectProperties.Posting.Allow;
		Items.DocumentsTreePost.Enabled = CanPosting And Not CurrentData.DeletionMark;
		Items.DocumentsTreeUnpost.Enabled = CanPosting And Not CurrentData.DeletionMark;
		Items.DocumentsTreeContextMenuPost.Enabled = CanPosting And Not CurrentData.DeletionMark;
		Items.DocumentsTreeContextMenuUnpost.Enabled = CanPosting And Not CurrentData.DeletionMark;
	EndIf;

EndProcedure

&AtClient
Procedure ExpandDocumentsTree()
	For Each Row In ThisObject.DocumentsTree.GetItems() Do
		Items.DocumentsTree.Expand(Row.GetID(), True);
	EndDo;

	CurrentRow = Undefined;
	If CurrentDocument <> Undefined Then
		FindCurrentRow(ThisObject.DocumentsTree.GetItems(), CurrentRow);
		If CurrentRow <> Undefined Then
			Items.DocumentsTree.CurrentRow = CurrentRow;
		EndIf;
	EndIf;
EndProcedure

&AtClient
Procedure FindCurrentRow(TreeItems, CurrentRow)
	For Each Row In TreeItems Do
		If Row.Ref = CurrentDocument Then
			CurrentRow = Row.GetID();
			Break;
		EndIf;
		If CurrentRow = Undefined Then
			FindCurrentRow(Row.GetItems(), CurrentRow);
		EndIf
		;
	EndDo;
EndProcedure

&AtClient
Procedure OpenDocument()
	CurrentData = ThisObject.DocumentsTree.FindByID(Items.DocumentsTree.CurrentRow);
	If CurrentData = Undefined Then
		Return;
	EndIf;

	OpenForm(StrTemplate("Document.%1.ObjectForm", GetDocumentNameByRef(CurrentData.Ref)), New Structure("Key",
		CurrentData.Ref), ThisObject);
EndProcedure

&AtServerNoContext
Function GetDocumentNameByRef(DocumentRef)
	Return DocumentRef.Metadata().Name;
EndFunction

&AtClient
Procedure DocumentsTreeOnActivateRow(Item)
	UpdateCommandAvailability();
EndProcedure

&AtClient
Procedure DocumentsTreeSelection(Item, RowSelected, Field, StandardProcessing)
	StandardProcessing = False;
	OpenDocument();
EndProcedure

&AtClient
Procedure Edit(Command)
	OpenDocument();
EndProcedure

&AtClient
Procedure Post(Command)
	SetCurrentDocument();
	PostAtServer();
	GenerateTree();
	ExpandDocumentsTree();
	Notify("LockLinkedRows", Undefined, Undefined);
EndProcedure

&AtServer
Procedure PostAtServer()
	CurrentData = ThisObject.DocumentsTree.FindByID(Items.DocumentsTree.CurrentRow);
	If CurrentData = Undefined Then
		Return;
	EndIf;

	DocumentObject = CurrentData.Ref.GetObject();
	If DocumentObject.CheckFilling() Then
		DocumentObject.Write(DocumentWriteMode.Posting);
	EndIf;
EndProcedure

&AtClient
Procedure Unpost(Command)
	SetCurrentDocument();
	UnpostAtServer();
	GenerateTree();
	ExpandDocumentsTree();
	Notify("LockLinkedRows", Undefined, Undefined);
EndProcedure

&AtServer
Procedure UnpostAtServer()
	CurrentData = ThisObject.DocumentsTree.FindByID(Items.DocumentsTree.CurrentRow);
	If CurrentData = Undefined Then
		Return;
	EndIf;

	DocumentObject = CurrentData.Ref.GetObject();
	DocumentObject.Write(DocumentWriteMode.UndoPosting);
EndProcedure

&AtClient
Procedure Delete(Command)
	SetCurrentDocument();
	DeleteAtServer();
	GenerateTree();
	ExpandDocumentsTree();
	Notify("LockLinkedRows", Undefined, Undefined);
EndProcedure

&AtServer
Procedure DeleteAtServer()
	CurrentData = ThisObject.DocumentsTree.FindByID(Items.DocumentsTree.CurrentRow);
	If CurrentData = Undefined Then
		Return;
	EndIf;

	DocumentObject = CurrentData.Ref.GetObject();
	DocumentObject.SetDeletionMark(Not CurrentData.Ref.DeletionMark);
EndProcedure

&AtClient
Procedure SetCurrentDocument()
	CurrentData = Items.DocumentsTree.CurrentData;
	If CurrentData = Undefined Then
		CurrentDocument = Undefined;
	Else
		CurrentDocument = CurrentData.Ref;
	EndIf;
EndProcedure

&AtClient
Procedure Refresh(Command)
	
	RefreshReport();
		
EndProcedure

&AtClient
Procedure RefreshReport()
	
	SetCurrentDocument();
	GenerateTree();
	ExpandDocumentsTree();
	
EndProcedure

&AtClient
Procedure GenerateForCurrent(Command)
	CurrentData = ThisObject.DocumentsTree.FindByID(Items.DocumentsTree.CurrentRow);
	If Not CurrentData = Undefined And ValueIsFilled(CurrentData.Ref) Then
		ThisObject.DocumentRef = CurrentData.Ref;
		Title = String(CurrentData.Ref);
		GenerateTree();
		ExpandDocumentsTree();
	EndIf;
EndProcedure

&AtServer
Procedure AddRowToAllAttributesValueTable(MetaAttribute)
	ArrayException = New Array;
	ArrayException.Add("DeletionMark");
	ArrayException.Add("DocumentStatus");
	ArrayException.Add("Ref");
	ArrayException.Add("Presentation");
	ArrayException.Add("Posted");
	ArrayException.Add("LimitationByParent");
	ArrayException.Add("IsCurrentDocument");
	
	If ArrayException.Find(MetaAttribute.Name) <> Undefined Then
		Return;
	EndIf;
	
	If AllAttributesValueTable.FindRows(New Structure("AttributeName", MetaAttribute.Name)).Count() = 0 Then
		NewRow = AllAttributesValueTable.Add();
		NewRow.AttributeName = MetaAttribute.Name;
		NewRow.AttributeSynonym = ?(ValueIsFilled(MetaAttribute.Synonym), MetaAttribute.Synonym, MetaAttribute.Name);
		NewRow.AttributeType = New TypeDescription(MetaAttribute.Type.Types());
	EndIf;
EndProcedure

&AtServer
Procedure OutputParentDocuments(DocumentRef, CurrentBranch)
	DocumentMetadata = DocumentRef.Metadata();
	ListOfAttributes = New ValueList();

	For Each Attribute In DocumentMetadata.Attributes Do
		AddRowToAllAttributesValueTable(Attribute);
		ArrayOfTypes = Attribute.Type.Types();
		For Each CurrentType In ArrayOfTypes Do
			AttributeMetadata = Metadata.FindByType(CurrentType);

			If AttributeMetadata <> Undefined And Metadata.Documents.Contains(AttributeMetadata) And AccessRight(
				"Read", AttributeMetadata) Then

				AttributeValue = DocumentRef[Attribute.Name];

				If GetFromCache(AttributeValue) = Undefined And ValueIsFilled(AttributeValue)
					And ListOfAttributes.FindByValue(DocumentRef[Attribute.Name]) = Undefined Then

					ListOfAttributes.Add(AttributeValue, Format(AttributeValue.Date, "DF=yyyyMMddHHMMss;"));
				EndIf;
			EndIf;
		EndDo;
	EndDo;

	For Each TabularSection In DocumentMetadata.TabularSections Do
		AttributeNames = "";

		For Each Attribute In TabularSection.Attributes Do
			ArrayOfTypes = Attribute.Type.Types();
			For Each CurrentType In ArrayOfTypes Do
				AttributeMetadata = Metadata.FindByType(CurrentType);
				If AttributeMetadata <> Undefined And Metadata.Documents.Contains(AttributeMetadata) And AccessRight(
					"Read", AttributeMetadata) Then
					AttributeNames = AttributeNames + ?(AttributeNames = "", "", ", ") + Attribute.Name;
					Break;
				EndIf;
			EndDo;
		EndDo;

		Table = DocumentRef[TabularSection.Name].Unload();

		Table.GroupBy(AttributeNames);
		For Each Column In Table.Columns Do
			For Each Row In Table Do
				AttributeValue = Row[Column.Name];
				ValueMetadata = Metadata.FindByType(TypeOf(AttributeValue));
				If ValueMetadata = Undefined Then
					Continue;
				EndIf;

				If Metadata.Documents.Contains(ValueMetadata) And GetFromCache(AttributeValue) = Undefined
					And ValueIsFilled(AttributeValue) And ListOfAttributes.FindByValue(AttributeValue) = Undefined Then
					ListOfAttributes.Add(AttributeValue, Format(AttributeValue.Date, "DF=yyyyMMddHHMMss;"));
				EndIf;
			EndDo;
		EndDo;
	EndDo;

	ListOfAttributes.SortByPresentation();

	PutToCache(DocumentRef, True);

	If ListOfAttributes.Count() = 1 Then
		OutputParentDocuments(ListOfAttributes[0].Value, CurrentBranch);
	ElsIf ListOfAttributes.Count() > 1 Then
		OutputWithOutParents(ListOfAttributes, CurrentBranch);
	EndIf;

	Query = GetQueryForDocumentProperties(DocumentRef);

	NewRow = CurrentBranch.GetItems().Add();
	QuerySelection = Query.Execute().Select();
	If QuerySelection.Next() Then
		
		FillPropertyValues(NewRow, QuerySelection);
		
		NewRow.Ref = QuerySelection.Ref;
		NewRow.Posted = QuerySelection.Posted;
		NewRow.DeletionMark = QuerySelection.DeletionMark;
		NewRow.Presentation = QuerySelection.Presentation;
		NewRow.Name = QuerySelection.DocumentName;
		NewRow.Amount = QuerySelection.Amount;
		NewRow.IsCurrentDocument = QuerySelection.Ref = ThisObject.DocumentRef;

		SetDocumentStatus(NewRow);
	EndIf;

	CurrentBranch = NewRow;
EndProcedure

&AtServer
Procedure OutputWithOutParents(ListOfDocuments, CurrentBranch)
	NewRow = Undefined;
	For Each Row In ListOfDocuments Do

		Query = GetQueryForDocumentProperties(Row.Value);

		QuerySelection = Query.Execute().Select();
		If QuerySelection.Next() Then
			If GetFromCache(QuerySelection.Ref) = Undefined Then
				NewRow = CurrentBranch.GetItems().Add();
				FillPropertyValues(NewRow, QuerySelection);
				
				NewRow.Ref = QuerySelection.Ref;
				NewRow.Posted = QuerySelection.Posted;
				NewRow.DeletionMark = QuerySelection.DeletionMark;
				NewRow.Presentation = QuerySelection.Presentation;
				NewRow.Name = QuerySelection.DocumentName;
				NewRow.Amount = QuerySelection.Amount;
				NewRow.LimitationByParent = True;
				NewRow.IsCurrentDocument = QuerySelection.Ref = ThisObject.DocumentRef;

				SetDocumentStatus(NewRow);

				PutToCache(QuerySelection.Ref, True);

			EndIf;
		EndIf;
	EndDo;

	If NewRow <> Undefined Then
		CurrentBranch = NewRow;
	EndIf;
EndProcedure

&AtServer
Procedure OutputChildrenDocuments(TreeRow)

	CurrentDocument = TreeRow.Ref;

	RefArray = CommonFunctionsServer.GetRelatedDocuments(CurrentDocument);

	CacheByDocumentTypes = New Map();

	For Each RefItem In RefArray Do
		DocumentMetadata = RefItem.Metadata();

		If Not AccessRight("Read", DocumentMetadata) Then
			Continue;
		EndIf;

		DocumentName = DocumentMetadata.Name;
		DocumentSynonym = DocumentMetadata.Synonym;

		AddToMetadataCache(DocumentMetadata, DocumentName);

		DocumentTypeInfo = CacheByDocumentTypes[DocumentName];
		If DocumentTypeInfo = Undefined Then
			DocumentTypeInfo = New Structure("Synonym, ArrayOfRefs", DocumentSynonym, New Array());
			CacheByDocumentTypes.Insert(DocumentName, DocumentTypeInfo);
		EndIf;
		DocumentTypeInfo.ArrayOfRefs.Add(RefItem);

	EndDo;

	If CacheByDocumentTypes.Count() = 0 Then
		Return;
	EndIf;

	Query = New Query();
	For Each KeyValue In CacheByDocumentTypes Do
		
		DocMeta = Metadata.Documents[KeyValue.Key];
		
		AllAttributes = GetAllAttributesForDocument(DocMeta);
		For Each DocsAttribute In AllAttributes Do
			AddRowToAllAttributesValueTable(DocsAttribute);
		EndDo;
		AllAttributesValueTable.Sort("AttributeName");
		
		SelectedAttributeString = GetSelectedAttributesForDocument(DocMeta);
		
		Query.Text = Query.Text + ?(Query.Text = "", 
		"
		|SELECT ALLOWED", "
		|UNION ALL
		|SELECT") + "
		|Ref, Date, Presentation, Posted, DeletionMark,
		|" 
		+ ?(GetFromCache(KeyValue.Key, "Attributes")["DocumentAmount"], "DocumentAmount", 0) + " AS Amount				
		|%1
		|FROM Document." + KeyValue.Key + "
		|WHERE Ref In (&" + KeyValue.Key + ")";
		
		Query.Text = StrTemplate(Query.Text, SelectedAttributeString);

		Query.SetParameter(KeyValue.Key, KeyValue.Value.ArrayOfRefs);
	EndDo;
	Query.Text = Query.Text + " ORDER BY Date";
	
	QuerySelection = Query.Execute().Select();

	While QuerySelection.Next() Do
		If GetFromCache(QuerySelection.Ref) = Undefined Then
			
			NewRow = TreeRow.GetItems().Add();
			FillPropertyValues(NewRow, QuerySelection);
			NewRow.Ref = QuerySelection.Ref;
			NewRow.Presentation = QuerySelection.Presentation;
			NewRow.Amount = QuerySelection.Amount;
			NewRow.Posted = QuerySelection.Posted;
			NewRow.DeletionMark = QuerySelection.DeletionMark;
			NewRow.IsCurrentDocument = QuerySelection.Ref = ThisObject.DocumentRef;

			SetDocumentStatus(NewRow);

			PutToCache(QuerySelection.Ref, True);

			OutputChildrenDocuments(NewRow);
		EndIf;
	EndDo;
EndProcedure

&AtServer
Procedure SetDocumentStatus(Row)
	If Row.Posted Then
		Row.DocumentStatus = 0;
	ElsIf Row.DeletionMark Then
		Row.DocumentStatus = 1;
	Else
		Row.DocumentStatus = 2;
	EndIf;
EndProcedure

&AtServer
Procedure AddToMetadataCache(DocumentMetadata, DocumentName)
	AttributesInfo = GetFromCache(DocumentName, "Attributes");
	If AttributesInfo = Undefined Then
		AttributesInfo = New Structure("DocumentAmount", DocumentHaveAmount(DocumentMetadata));
		PutToCache(DocumentName, AttributesInfo, "Attributes");
	EndIf;
EndProcedure

&AtServer
Function DocumentHaveAmount(DocumentMetadata)
	CommonAttribute = Metadata.CommonAttributes.DocumentAmount;
	CommonAttributeUsed = False;
	Content = CommonAttribute.Content.Find(DocumentMetadata);
	If Content <> Undefined Then
		If Content.Use = Metadata.ObjectProperties.CommonAttributeUse.Use Or (Content.Use
			= Metadata.ObjectProperties.CommonAttributeUse.Auto And CommonAttribute.AutoUse
			= Metadata.ObjectProperties.CommonAttributeAutoUse.Use) Then
			CommonAttributeUsed = True;
		EndIf;
	EndIf;
	Return CommonAttributeUsed;
EndFunction

&AtServer
Function GetAllAttributesForDocument(DocumentMetadata)
	AllAttributes = New Array;
	For Each Attribute In DocumentMetadata.Attributes Do
		AllAttributes.Add(Attribute);
	EndDo;
	For Each Attribute In DocumentMetadata.StandardAttributes Do
		AllAttributes.Add(Attribute);
	EndDo;
	Return AllAttributes;
EndFunction

&AtServer
Function GetSelectedAttributesForDocument(DocumentMetadata)
	
	AllAttributes = GetAllAttributesForDocument(DocumentMetadata);
	AllAttributesStrings = New Array;
	For Each AttributeInArray In AllAttributes Do
		AllAttributesStrings.Add(AttributeInArray.Name);
	EndDo;
	
	SelectedAttributes = AllAttributesValueTable.FindRows(New Structure("Check", True));
	
	AttributeString = "";
	For Each RowAttribute In SelectedAttributes Do
		If AllAttributesStrings.Find(RowAttribute.AttributeName) = Undefined Then
			AttributeString = AttributeString + ", " + "Null";
			Continue;
		EndIf;
		AttributeString = AttributeString + ", " + RowAttribute.AttributeName;
	EndDo;
		
	Return AttributeString;
EndFunction

&AtServer
Function GetQueryForDocumentProperties(DocumentRef)
	DocumentMetadata = DocumentRef.Metadata();
	
	SelectedAttributeString = GetSelectedAttributesForDocument(DocumentMetadata);
	
	Query = New Query("SELECT ALLOWED Ref, Posted, DeletionMark, %1, Presentation, ""%2"" AS DocumentName %3
					  |FROM Document.%2 WHERE Ref = &Ref");

	If DocumentHaveAmount(DocumentMetadata) Then
		Query.Text = StrTemplate(Query.Text, "DocumentAmount AS Amount", DocumentMetadata.Name, SelectedAttributeString);
	Else
		Query.Text = StrTemplate(Query.Text, "NULL AS Amount", DocumentMetadata.Name, SelectedAttributeString);
	EndIf;
	
	Query.SetParameter("Ref", DocumentRef);
	Return Query;
EndFunction

&AtServer
Function GetFromCache(Key, CacheType = "Main")
	ArrayOfResults = ThisObject[GetCacheByType(CacheType)].FindRows(New Structure("Key", Key));
	If ArrayOfResults.Count() Then
		Return ArrayOfResults[0].Value;
	Else
		Return Undefined;
	EndIf;
EndFunction

&AtServer
Procedure PutToCache(Key, Value, CacheType = "Main")
	ArrayOfResults = ThisObject[GetCacheByType(CacheType)].FindRows(New Structure("Key", Key));
	If ArrayOfResults.Count() Then
		ArrayOfResults[0].Value = Value;
	Else
		NewRow = ThisObject[GetCacheByType(CacheType)].Add();
		NewRow.Key = Key;
		NewRow.Value = Value;
	EndIf;
EndProcedure

&AtServer
Function GetCacheByType(CacheType)
	CacheTypeMap = New Map();
	CacheTypeMap.Insert("Main", "Cache");
	CacheTypeMap.Insert("Attributes", "CacheAttributes");
	Return CacheTypeMap.Get(CacheType);
EndFunction

&AtClient
Procedure DocumentsTreeBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure DocumentsTreeBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtServer
Procedure CreateColumnsAtServer()
	AttributesArray = GetAttributes("DocumentsTree");
	AttributesNamesArray = New Array;
	For Each AttributeInArray In AttributesArray Do
		AttributesNamesArray.Add(AttributeInArray.Name);
	EndDo;
	
	AttributesToDelete = New Array;
	AttributesToAdd = New Array;
	
	For Each Row In AllAttributesValueTable Do
		
		AttributeExist =  AttributesNamesArray.Find(Row.AttributeName) <> Undefined;
		If AttributeExist And Row.Check Then
			Continue;
		ElsIf AttributeExist And Not Row.Check Then
			AttributesToDelete.Add("DocumentsTree." + Row.AttributeName);
		ElsIf Not AttributeExist And Not Row.Check Then
			Continue;
		ElsIf Not AttributeExist And Row.Check Then
			AttributesToAdd.Add(Row);
		EndIf;
	EndDo;
	
	AttributesArray = New Array;
	For Each ArrayItem In AttributesToAdd Do
		NewAttribute = New FormAttribute(
			ArrayItem.AttributeName,
			ArrayItem.AttributeType,
			"DocumentsTree",
			ArrayItem.AttributeSynonym);
		AttributesArray.Add(NewAttribute);
	EndDo;
	If AttributesArray.Count() > 0 Or AttributesToDelete.Count() > 0 Then 
		ChangeAttributes(AttributesArray, AttributesToDelete);
	EndIf;
	
	For Each ArrayItem In AttributesToAdd Do
		NewColumn = Items.Add(
			ArrayItem.AttributeName + "DocumentsTree", 
			Type("FormField"),
			Items.DocumentsTree);
		NewColumn.DataPath = "DocumentsTree." + ArrayItem.AttributeName;
		NewColumn.Title = ArrayItem.AttributeSynonym;
		NewColumn.Type = FormFieldType.InputField;
	EndDo;
	
EndProcedure

&AtClient
Procedure AllAttributesValueTableOnChange(Item)
	CreateColumnsAtServer();
	RefreshReport();
EndProcedure

&AtClient
Procedure ShowColumns(Command)
	Items.DocumentsTreeShowSettings.Check = Not Items.DocumentsTreeShowSettings.Check;
	
	SetVisibleToAllAttributesValueTable(Items.DocumentsTreeShowSettings.Check);
EndProcedure

&AtClient
Procedure SetVisibleToAllAttributesValueTable(Visible)
	Items.AllAttributesValueTable.Visible = Visible;
EndProcedure
