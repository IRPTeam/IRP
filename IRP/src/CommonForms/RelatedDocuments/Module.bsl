&AtClient
Var CurrentDocument;

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Parameters.Property("DocumentRef") Then
		ThisObject.DocumentRef = Parameters.DocumentRef;
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
EndProcedure

&AtServer
Procedure PostAtServer()
	CurrentData = ThisObject.DocumentsTree.FindByID(Items.DocumentsTree.CurrentRow);
	If CurrentData = Undefined Then
		Return;
	EndIf;

	DocumentObject = CurrentData.Ref.GetObject();
	DocumentObject.Write(DocumentWriteMode.Posting);
EndProcedure

&AtClient
Procedure Unpost(Command)
	SetCurrentDocument();
	UnpostAtServer();
	GenerateTree();
	ExpandDocumentsTree();
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
	SetCurrentDocument();
	GenerateTree();
	ExpandDocumentsTree();
EndProcedure

&AtClient
Procedure GenerateForCurrent(Command)
	CurrentData = ThisObject.DocumentsTree.FindByID(Items.DocumentsTree.CurrentRow);
	If Not CurrentData = Undefined And ValueIsFilled(CurrentData.Ref) Then
		ThisObject.DocumentRef = CurrentData.Ref;
		GenerateTree();
		ExpandDocumentsTree();
	EndIf;
EndProcedure

&AtServer
Procedure OutputParentDocuments(DocumentRef, CurrentBranch)
	DocumentMetadata = DocumentRef.Metadata();
	ListOfAttributes = New ValueList();

	For Each Attribute In DocumentMetadata.Attributes Do
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

	Table = GetRelatedDocuments(CurrentDocument);

	CacheByDocumentTypes = New Map();

	For Each Row In Table Do
		DocumentMetadata = Row.Ref.Metadata();

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
		DocumentTypeInfo.ArrayOfRefs.Add(Row.Ref);

	EndDo;

	If CacheByDocumentTypes.Count() = 0 Then
		Return;
	EndIf;

	Query = New Query();
	For Each KeyValue In CacheByDocumentTypes Do

		Query.Text = Query.Text + ?(Query.Text = "", "
													 |SELECT ALLOWED", "
																	   |UNION ALL
																	   |SELECT") + "
																				   |Ref, Presentation, Posted, DeletionMark, 
																				   |" + ?(GetFromCache(KeyValue.Key,
			"Attributes")["DocumentAmount"], "DocumentAmount", 0) + " AS Amount				
																	|FROM Document." + KeyValue.Key + "
																									  |WHERE Ref In (&"
			+ KeyValue.Key + ")";

		Query.SetParameter(KeyValue.Key, KeyValue.Value.ArrayOfRefs);
	EndDo;

	QuerySelection = Query.Execute().Select();

	While QuerySelection.Next() Do
		If GetFromCache(QuerySelection.Ref) = Undefined Then

			NewRow = TreeRow.GetItems().Add();
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
Function GetQueryForDocumentProperties(DocumentRef)
	DocumentMetadata = DocumentRef.Metadata();
	Query = New Query("SELECT ALLOWED Ref, Posted, DeletionMark, %1, Presentation, ""%2"" AS DocumentName
					  |FROM Document.%2 WHERE Ref = &Ref");

	If DocumentHaveAmount(DocumentMetadata) Then
		Query.Text = StrTemplate(Query.Text, "DocumentAmount AS Amount", DocumentMetadata.Name);
	Else
		Query.Text = StrTemplate(Query.Text, "NULL AS Amount", DocumentMetadata.Name);
	EndIf;

	Query.SetParameter("Ref", DocumentRef);
	Return Query;
EndFunction

&AtServer
Function GetRelatedDocuments(DocumentRef)
	Query = New Query();
	Query.Text =
	"SELECT
	|	Ref
	|FROM
	|	FilterCriterion.RelatedDocuments(&DocumentRef)";
	Query.SetParameter("DocumentRef", DocumentRef);
	Return Query.Execute().Unload();
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