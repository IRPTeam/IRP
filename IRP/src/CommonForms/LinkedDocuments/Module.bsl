
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.TableName  = Parameters.TableName;
	ThisObject.DocumentColumnName = Parameters.DocumentColumnName;
	ThisObject.QuantityColumnName = Parameters.QuantityColumnName;
	ThisObject.ArrayOfRows_ItemList.LoadValues(Parameters.ArrayOfRows_ItemList);
	ThisObject.ArrayOfRows_Documents.LoadValues(Parameters.ArrayOfRows_Documents);
			
	For Each Row In ThisObject.ArrayOfRows_Documents Do
		Row.Value.Insert("DocumentName", Row.Value.Document.Metadata().Name);
		BasisDocumentRows = Row.Value.Document.ItemList.FindRows(New Structure("Key", Row.Value.BasisKey));
		If BasisDocumentRows.Count() Then
			Row.Value.Insert("LineNumber" , BasisDocumentRows[0].LineNumber);
		EndIf; 
	EndDo;
			
	ThisObject.SettingKey = Parameters.Ref.Metadata().Name;
	
	UseReverseTreeSetting = CommonSettingsStorage.Load("Documents.LinkedDocuments.Settings.UseReverseTree", ThisObject.SettingKey);
	If UseReverseTreeSetting = Undefined Then
		UseReverseTreeSetting = UserSettingsServer.LinkedDocumets_Settings_UseReverseTree();
	EndIf;
	
	ThisObject.UseReverseTree = UseReverseTreeSetting;
	UpdateTree();
EndProcedure

&AtServer
Procedure UpdateTree()
	ThisObject.Items.DocumentsTreeQuantityInInvoice.Visible = Not ThisObject.UseReverseTree;
	ThisObject.DocumentsTree.GetItems().Clear();
	If ThisObject.UseReverseTree Then
		Tree = GetTreeReverse();
		FillTreeReverse(Tree);
	Else
		Tree = GetTree();
		FillTree(Tree);
	EndIf;
EndProcedure

&AtServer
Procedure FillTree(Tree)
	For Each Row0 In Tree Do
		NewRow0 = ThisObject.DocumentsTree.GetItems().Add();
		FillPropertyValues(NewRow0, Row0);
		NewRow0.Icon = 0;
		NewRow0.Presentation = StrTemplate("%1 (%2)", String(NewRow0.Item), String(NewRow0.ItemKey));
		For Each Row1 In Row0.Rows Do
			NewRow1 = NewRow0.GetItems().Add();
			FillPropertyValues(NewRow1, Row1);
			NewRow1.Icon = 1;
			NewRow1.Presentation = String(NewRow1.Document);
		EndDo;
	EndDo;		
EndProcedure

&AtServer
Procedure FillTreeReverse(Tree)
	For Each Row0 In Tree Do
		NewRow0 = ThisObject.DocumentsTree.GetItems().Add();
		FillPropertyValues(NewRow0, Row0);
		NewRow0.Icon = 1;
		NewRow0.Presentation = String(NewRow0.Document);
		
		For Each Row1 In Row0.Rows Do
			NewRow1 = NewRow0.GetItems().Add();
			FillPropertyValues(NewRow1, Row1);
			NewRow1.Icon = 0;
			NewRow1.Presentation = StrTemplate("%1 (%2)", String(NewRow1.Item), String(NewRow1.ItemKey));
		EndDo;
	EndDo;		
EndProcedure

&AtServer
Function GetTree()
	_arrayOfRows_ItemList = ThisObject.ArrayOfRows_ItemList.UnloadValues();
	_arrayOfRows_Documents = ThisObject.ArrayOfRows_Documents.UnloadValues();
	Tree = New Array();
	For Each Row In _arrayOfRows_ItemList Do
		NewRow0 = New Structure();
		NewRow0.Insert("Level"             , 1);
		NewRow0.Insert("Key"               , Row.Key);
		NewRow0.Insert("Item"              , Row.Item);
		NewRow0.Insert("ItemKey"           , Row.ItemKey);
		
		NewRow0.Insert("QuantityInInvoice" , Row.QuantityInBaseUnit);
		NewRow0.Insert("Quantity"          , 0);
		NewRow0.Insert("QuantityInDocument", 0);
		
		NewRow0.Insert("Rows"              , New Array());

		ArrayOfDocuments = FindInArray(_arrayOfRows_Documents, Row.Key);
		
		For Each ItemOfArray In ArrayOfDocuments Do
			NewRow1 = New Structure();
			
			NewRow1.Insert("Level"           , 2);
			NewRow1.Insert("PictureEdit"     , True);
			
			NewRow1.Insert("Key"      , ItemOfArray.Key);
			NewRow1.Insert("BasisKey" , ItemOfArray.BasisKey);
			NewRow1.Insert("Document" , ItemOfArray.Document);
			
			NewRow1.Insert("Quantity"           , ItemOfArray.Quantity);
			NewRow1.Insert("QuantityInDocument" , ItemOfArray.QuantityInDocument);
			
			NewRow0.Quantity = NewRow0.Quantity + ItemOfArray.Quantity;
			NewRow0.QuantityInDocument = NewRow0.QuantityInDocument + ItemOfArray.QuantityInDocument;
			
			NewRow1.Insert("LineNumber", ItemOfArray.LineNumber);
			NewRow1.Insert("DocumentName", ItemOfArray.DocumentName);
			
			NewRow0.Rows.Add(NewRow1);
		EndDo;
		Tree.Add(NewRow0);
	EndDo;
	Return Tree;
EndFunction

&AtServer
Function GetTreeReverse()
	_arrayOfRows_ItemList = ThisObject.ArrayOfRows_ItemList.UnloadValues();
	_arrayOfRows_Documents = ThisObject.ArrayOfRows_Documents.UnloadValues();
	
	TableOfDocuments = New ValueTable();
	TableOfDocuments.Columns.Add("Document");
	TableOfDocuments.Columns.Add("Key");
	TableOfDocuments.Columns.Add("BasisKey");
	TableOfDocuments.Columns.Add("Quantity");
	TableOfDocuments.Columns.Add("QuantityInDocument");
	TableOfDocuments.Columns.Add("LineNumber");
	TableOfDocuments.Columns.Add("DocumentName");
	
	For Each Row In _arrayOfRows_Documents Do
		FillPropertyValues(TableOfDocuments.Add(), Row);
	EndDo;
	
	TableOfDocumentsCopy = TableOfDocuments.Copy();
	TableOfDocumentsCopy.GroupBy("Document");
	
	Tree = New Array();
	For Each RowCopy In TableOfDocumentsCopy Do
		NewRow0 = New Structure();
		NewRow0.Insert("Level"    , 1);
		NewRow0.Insert("Document" , RowCopy.Document);
		
		NewRow0.Insert("Rows" , New Array());
		
		For Each Row In TableOfDocuments.FindRows(New Structure("Document", RowCopy.Document)) Do
			
			ArrayOfItemList = FindInArray(_arrayOfRows_ItemList, Row.Key);
			For Each ItemOfArray In ArrayOfItemList Do
				NewRow1 = New Structure();
				NewRow1.Insert("Level"       , 2);
				NewRow1.Insert("PictureEdit" , True);
				
				NewRow1.Insert("Key"      , ItemOfArray.Key);
				NewRow1.Insert("BasisKey" , Row.BasisKey);
				NewRow1.Insert("Item"     , ItemOfArray.Item);
				NewRow1.Insert("ItemKey"  , ItemOfArray.ItemKey);
				NewRow1.Insert("Quantity" , Row.Quantity);
				NewRow1.Insert("QuantityInDocument" , Row.QuantityInDocument);
				NewRow1.Insert("LineNumber" , Row.LineNumber);
				NewRow1.Insert("DocumentName" , Row.DocumentName);
				NewRow0.Rows.Add(NewRow1);
			EndDo;
		
		EndDo;
		
		Tree.Add(NewRow0);
	EndDo;
	Return Tree;
EndFunction

&AtClientAtServerNoContext
Function FindInArray(Array, RowKey)
	Result = New Array();
	For Each Row In Array Do
		If Row.Key = RowKey Then
			Result.Add(Row);
		EndIf;
	EndDo;
	Return Result;
EndFunction

&AtClient
Procedure UseReverseTreeOnChange(Item)
	SaveUserSettingAtServer();
	UpdateTree();
	AttachIdleHandler("ExpandAllTrees", 1, True);
EndProcedure

&AtServer
Procedure SaveUserSettingAtServer()
	CommonSettingsStorage.Save("Documents.LinkedDocuments.Settings.UseReverseTree", ThisObject.SettingKey, ThisObject.UseReverseTree);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	AttachIdleHandler("ExpandAllTrees", 1, True);
EndProcedure

&AtClient
Procedure ExpandAllTrees() Export
	RowIDInfoClient.ExpandTree(Items.DocumentsTree, ThisObject.DocumentsTree.GetItems());
EndProcedure

&AtClient
Procedure DocumentsTreeBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure DocumentsTreeBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure DocumentsTreeQuantityOnChange(Item)
	If ThisObject.UseReverseTree Then
		Return;
	ENdIf;
	
	CurrentRow = Items.DocumentsTree.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	RowParent = CurrentRow.GetParent();
	TotalQuantity = 0;
	For Each Row In RowParent.GetItems() Do
		TotalQuantity = TotalQuantity + Row.Quantity;
	EndDo;
	RowParent.Quantity = TotalQuantity;
EndProcedure

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure

&AtClient
Procedure Ok(Command)
	Result = New Array();
	For Each Row0 In ThisObject.DocumentsTree.GetItems() Do
		For Each Row1 In Row0.GetItems() Do
			TreeRow = New Structure();
			
			Filter = New Structure();
			Filter.Insert("Key"      , Row1.Key);
			Filter.Insert("BasisKey" , Row1.BasisKey);
			If ThisObject.UseReverseTree Then
				Filter.Insert(ThisObject.DocumentColumnName, Row0.Document);
			Else
				Filter.Insert(ThisObject.DocumentColumnName, Row1.Document);
			EndIf;
			TreeRow.Insert("Filter"   , Filter);
			TreeRow.Insert("Quantity" , Row1.Quantity);
			Result.Add(TreeRow);
		EndDo;
	EndDo;
	
	Close(Result);
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close(Undefined);
EndProcedure

&AtClient
Procedure DocumentsTreeOnActivateRow(Item)
	CurrentData = Items.DocumentsTree.CurrentData;
	If CurrentData = Undefined Then
		Items.OpenBasisDocument.Enabled = False;
		Return;
	EndIf;	
	Items.OpenBasisDocument.Enabled = ValueIsFilled(CurrentData.LineNumber);
EndProcedure

&AtClient
Procedure OpenBasisDocument(Command)
	_OpenBasisDocument();
EndProcedure

&AtClient
Procedure DocumentsTreeSelection(Item, RowSelected, Field, StandardProcessing)
	StandardProcessing = False;
	_OpenBasisDocument();
EndProcedure

&AtClient
Procedure _OpenBasisDocument()
	CurrentData = Items.DocumentsTree.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;	
	
	If Not ValueIsFilled(CurrentData.LineNumber) Then
		Return;
	EndIf;
	
	FormParameters = New Structure();
	If ThisObject.UseReverseTree Then
		FormParameters.Insert("Key", CurrentData.GetParent().Document);
	Else
		FormParameters.Insert("Key", CurrentData.Document);
	EndIf;
	
	DocForm = OpenForm("Document."+ CurrentData.DocumentName +".Form.DocumentForm", FormParameters, , FormParameters.Key);
	CurrentRow = Undefined;
	Rows = DocForm.Object.ItemList.FindRows(New Structure("Key", CurrentData.BasisKey));
	If Rows.Count() Then
		CurrentRow = Rows[0].GetID();
	EndIf;
	If CurrentRow <> Undefined Then
		DocForm.Items.ItemList.CurrentRow = CurrentRow;
	EndIf;
EndProcedure
