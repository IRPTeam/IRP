#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	CatalogsServer.OnCreateAtServerObject(ThisObject, Object, Cancel, StandardProcessing);
	If Object.Parent <> Catalogs.ConfigurationMetadata.Documents Then
		Items.ELedgerLongDescription.Visible = False;
		Items.ELedgerShortDescription.Visible = False;
	EndIf;
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	ReadPrintTemplates();
	ReadObjectAttributes();
EndProcedure

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)
	SavePrintTemplates(CurrentObject);
EndProcedure

&AtClient
Procedure BeforeWrite(Cancel, WriteParameters)
	SaveImportantAttributes();
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	
	For Each TreeItem In AttributesTree.GetItems() Do
		Items.AttributesTree.Expand(TreeItem.GetID());
	EndDo;

EndProcedure

#EndRegion

#Region COMMANDS

&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	ExternalCommandsClient.GeneratedFormCommandActionByName(Object, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name);
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName) Export
	ExternalCommandsServer.GeneratedFormCommandActionByName(Object, ThisObject, CommandName);
EndProcedure

&AtClient
Procedure InternalCommandAction(Command) Export
	InternalCommandsClient.RunCommandAction(Command, ThisObject, Object, Object.Ref);
EndProcedure

&AtClient
Procedure InternalCommandActionWithServerContext(Command) Export
	InternalCommandActionWithServerContextAtServer(Command.Name);
EndProcedure

&AtServer
Procedure InternalCommandActionWithServerContextAtServer(CommandName)
	InternalCommandsServer.RunCommandAction(CommandName, ThisObject, Object, Object.Ref);
EndProcedure

#EndRegion

#Region Other

&AtServer
Procedure ReadPrintTemplates()

	Query = New Query;
	Query.SetParameter("Ref", Object.Ref);
	Query.Text =
	"SELECT
	|	ObjectsPrintTemplates.PrintTemplate
	|FROM
	|	InformationRegister.ObjectsPrintTemplates AS ObjectsPrintTemplates
	|WHERE
	|	ObjectsPrintTemplates.Object = &Ref";
	
	PrintTemplates.Clear();
	QuerySelection = Query.Execute().Select();
	While QuerySelection.Next() Do
		PrintTemplates.Add(QuerySelection.PrintTemplate);
	EndDo;
	
EndProcedure

&AtServer
Procedure SavePrintTemplates(CurrentObject)
	
	ObjectRecords = InformationRegisters.ObjectsPrintTemplates.CreateRecordSet();
	ObjectRecords.Filter.Object.Set(CurrentObject.Ref, True);
	
	For Each PrintTemplateItem In PrintTemplates Do
		Record = ObjectRecords.Add();
		Record.Object = CurrentObject.Ref;
		Record.PrintTemplate = PrintTemplateItem.Value;
	EndDo;
	
	ObjectRecords.Write(True);
	
EndProcedure

&AtServer
Procedure ReadObjectAttributes()
	
	AttributesTree.GetItems().Clear();
	
	Try 
		MetaObject = Metadata.FindByFullName(Object.ObjectFullName); // MetadataObjectCatalog,  MetadataObjectDocument
	Except
		Return;
	EndTry;
	If TypeOf(MetaObject) <> Type("MetadataObject") Then
		Return;
	EndIf;
	
	For Each AttributItem In Metadata.CommonAttributes Do
		If Not CommonFunctionsServer.isCommonAttributeUseForMetadata(AttributItem.Name, MetaObject) Then
			Continue;
		EndIf;
		If Not CommonFunctionsServer.isMetadataAvailableByCurrentFunctionalOptions(AttributItem, True) Then
			Continue;
		EndIf;
		
		TreeBranch = AttributesTree.GetItems().Add();
		TreeBranch.AttributeName = AttributItem.Name;
		TreeBranch.Description = AttributItem.Synonym;
		CheckAttributesTreeMark(TreeBranch);
	EndDo;
	
	For Each AttributItem In MetaObject.Attributes Do
		If Not CommonFunctionsServer.isMetadataAvailableByCurrentFunctionalOptions(AttributItem, True) Then
			Continue;
		EndIf;
		
		TreeBranch = AttributesTree.GetItems().Add();
		TreeBranch.AttributeName = AttributItem.Name;
		TreeBranch.Description = AttributItem.Synonym;
		CheckAttributesTreeMark(TreeBranch);
	EndDo;
	
	For Each TabularItem In MetaObject.TabularSections Do
		
		TreeTableBranch = AttributesTree.GetItems().Add();
		TreeTableBranch.TabularName = TabularItem.Name;
		TreeTableBranch.Description = TabularItem.Synonym;
		TreeTableBranch.Important = False;
		
		For Each AttributItem In TabularItem.Attributes Do
			If Not CommonFunctionsServer.isMetadataAvailableByCurrentFunctionalOptions(AttributItem, True) Then
				Continue;
			EndIf;
			
			TreeBranch = TreeTableBranch.GetItems().Add();
			TreeBranch.AttributeName = AttributItem.Name;
			TreeBranch.TabularName = TabularItem.Name;
			TreeBranch.Description = AttributItem.Synonym;
			CheckAttributesTreeMark(TreeBranch);
		EndDo;
		
	EndDo;

EndProcedure

&AtServer
Procedure CheckAttributesTreeMark(TreeBranch)
	
	Rows = Object.ImportantAttributes.FindRows(
		New Structure("TabularName,AttributeName", TreeBranch.TabularName, TreeBranch.AttributeName));
		
	TreeBranch.Important = Rows.Count();

	Rows = Object.NotAuditAttributes.FindRows(
		New Structure("TabularName,AttributeName", TreeBranch.TabularName, TreeBranch.AttributeName));
		
	TreeBranch.NotAudit = Rows.Count();

	Rows = Object.ReadOnlyAttributes.FindRows(
		New Structure("TabularName,AttributeName", TreeBranch.TabularName, TreeBranch.AttributeName));
		
	TreeBranch.ReadOnly = Rows.Count();

	Rows = Object.HiddenAttributes.FindRows(
		New Structure("TabularName,AttributeName", TreeBranch.TabularName, TreeBranch.AttributeName));
		
	TreeBranch.Hidden = Rows.Count();

EndProcedure

&AtClient
Procedure SaveImportantAttributes()
	
	Object.ImportantAttributes.Clear();
	Object.NotAuditAttributes.Clear();
	Object.ReadOnlyAttributes.Clear();
	Object.HiddenAttributes.Clear();
	
	For Each TreeBranch In AttributesTree.GetItems() Do
		If Not IsBlankString(TreeBranch.TabularName) Then
			For Each TableBranch In TreeBranch.GetItems() Do
				If TableBranch.Important Then
					NewRow = Object.ImportantAttributes.Add();
					NewRow.TabularName = TableBranch.TabularName;
					NewRow.AttributeName = TableBranch.AttributeName;
				EndIf;
				If TableBranch.NotAudit Then
					NewRow = Object.NotAuditAttributes.Add();
					NewRow.TabularName = TableBranch.TabularName;
					NewRow.AttributeName = TableBranch.AttributeName;
				EndIf;
				If TableBranch.ReadOnly Then
					NewRow = Object.ReadOnlyAttributes.Add();
					NewRow.TabularName = TableBranch.TabularName;
					NewRow.AttributeName = TableBranch.AttributeName;
				EndIf;
				If TableBranch.Hidden Then
					NewRow = Object.HiddenAttributes.Add();
					NewRow.TabularName = TableBranch.TabularName;
					NewRow.AttributeName = TableBranch.AttributeName;
				EndIf;
			EndDo;
		Else
			If TreeBranch.Important Then
				NewRow = Object.ImportantAttributes.Add();
				NewRow.AttributeName = TreeBranch.AttributeName;
			EndIf;			
			If TreeBranch.NotAudit Then
				NewRow = Object.NotAuditAttributes.Add();
				NewRow.AttributeName = TreeBranch.AttributeName;
			EndIf;			
			If TreeBranch.ReadOnly Then
				NewRow = Object.ReadOnlyAttributes.Add();
				NewRow.AttributeName = TreeBranch.AttributeName;
			EndIf;			
			If TreeBranch.Hidden Then
				NewRow = Object.HiddenAttributes.Add();
				NewRow.AttributeName = TreeBranch.AttributeName;
			EndIf;			
		EndIf;
	EndDo;

EndProcedure

#EndRegion

