
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.TableName  = Parameters.TableName;
	ThisObject.DocumentColumnName = Parameters.DocumentColumnName;
	ThisObject.QuantityColumnName = Parameters.QuantityColumnName;
	
	For Each Row0 In Parameters.Tree Do
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
			Filter.Insert(ThisObject.DocumentColumnName, Row1.Document);
			
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
