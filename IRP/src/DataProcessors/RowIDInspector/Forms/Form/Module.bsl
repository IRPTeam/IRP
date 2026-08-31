
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Items.Dependent.ReadOnly = not ValueIsFilled(ThisObject.Basis);
	If Parameters.Property("Dependent") Then
		ThisObject.Dependent = Parameters.Dependent;
	EndIf;	
	If Parameters.Property("Basis") Then
		ThisObject.Basis = Parameters.Basis;
	EndIf;
	FillItemListTables();
EndProcedure

&AtClient
Procedure BasisOnChange(Item)
	If TypeOf(ThisObject.Basis) = Type("DocumentRef.SalesOrder") Then
		If TypeOf(ThisObject.Dependent) = Type("DocumentRef.SalesInvoice") Then
			ThisObject.Dependent = PredefinedValue("Document.SalesInvoice.EmptyRef");
		EndIf;
	ElsIf TypeOf(ThisObject.Basis) = Type("DocumentRef.PurchaseOrder") Then
		If TypeOf(ThisObject.Dependent) = Type("DocumentRef.PurchaseInvoice") Then
			ThisObject.Dependent = PredefinedValue("Document.PurchaseInvoice.EmptyRef");
		EndIf;
	Else
		Raise "Unsupported basis type";
	EndIf;       
	Items.Dependent.ReadOnly = not ValueIsFilled(ThisObject.Basis);
	FillItemListTables();
EndProcedure

&AtClient
Procedure DependentOnChange(Item)
	FillItemListTables();
EndProcedure

&AtClient
Procedure BasisItemListOnActivateRow(Item)
	ThisObject.Results.Clear();
	
	BasisCurrentRow = ThisObject.Items.BasisItemList.CurrentData;
	If BasisCurrentRow = Undefined Then
		Return;
	EndIf;
	
	DependentCurrentRow = ThisObject.Items.DependentItemList.CurrentData;
	If DependentCurrentRow = Undefined Then
		Return;
	EndIf;
	
	FillResultTable(BasisCurrentRow.Key, DependentCurrentRow.Key);
EndProcedure

&AtClient
Procedure DependentItemListOnActivateRow(Item)
	ThisObject.Results.Clear();
	
	BasisCurrentRow = ThisObject.Items.BasisItemList.CurrentData;
	If BasisCurrentRow = Undefined Then
		Return;
	EndIf;
	
	DependentCurrentRow = ThisObject.Items.DependentItemList.CurrentData;
	If DependentCurrentRow = Undefined Then
		Return;
	EndIf;
	
	FillResultTable(BasisCurrentRow.Key, DependentCurrentRow.Key);
EndProcedure

&AtServer
Procedure FillItemListTables()
	ThisObject.Results.Clear(); 
	
	ThisObject.BasisItemList.Clear();
	If ValueIsFilled(ThisObject.Basis) Then
		For Each Row In ThisObject.Basis.ItemList Do
			NewRow = ThisObject.BasisItemList.Add();
			NewRow.Key = Row.Key;
			NewRow.LineNumber = Row.LineNumber;
			NewRow.Item = Row.Item;
			NewRow.ItemKey = Row.ItemKey;
		EndDo;
	EndIf;
	
	ThisObject.DependentItemList.Clear();
	If ValueIsFilled(ThisObject.Dependent) Then
		For Each Row In ThisObject.Dependent.ItemList Do
			NewRow = ThisObject.DependentItemList.Add();
			NewRow.Key = Row.Key;
			NewRow.LineNumber = Row.LineNumber;
			NewRow.Item = Row.Item;
			NewRow.ItemKey = Row.ItemKey;
		EndDo;
	EndIf; 
EndProcedure

&AtServer
Procedure FillResultTable(BasisCurrentRow_Key, DependentCurrentRow_Key)
	BasisCurrentRow = ThisObject.Basis.ItemList.FindRows(New Structure("Key",BasisCurrentRow_Key))[0];
	DependentCurrentRow = ThisObject.Dependent.ItemList.FindRows(New Structure("Key",DependentCurrentRow_Key))[0];
		
	If TypeOf(ThisObject.Basis) = Type("DocumentRef.SalesOrder")
		Or TypeOf(ThisObject.Basis) = Type("DocumentRef.PurchaseOrder") Then 
			
			IsVariableStore = CommonFunctionsClientServer.ObjectHasProperty(BasisCurrentRow, "IsVariableStore")
				and BasisCurrentRow.IsVariableStore;
				
			IsVariableItemKey = CommonFunctionsClientServer.ObjectHasProperty(BasisCurrentRow, "IsVariableItemKey")
				and BasisCurrentRow.IsVariableItemKey;
			
			AddResultRow(BasisCurrentRow, DependentCurrentRow, "Object", "Date");
			AddResultRow(BasisCurrentRow, DependentCurrentRow, "Object", "Company");
			AddResultRow(BasisCurrentRow, DependentCurrentRow, "Object", "Branch");
			AddResultRow(BasisCurrentRow, DependentCurrentRow, "Object", "Partner");
			AddResultRow(BasisCurrentRow, DependentCurrentRow, "Object", "LegalName");
			AddResultRow(BasisCurrentRow, DependentCurrentRow, "Object", "Agreement");
			AddResultRow(BasisCurrentRow, DependentCurrentRow, "Object", "Currency");
			AddResultRow(BasisCurrentRow, DependentCurrentRow, "Object", "TransactionType");
			AddResultRow(BasisCurrentRow, DependentCurrentRow, "Object", "PriceIncludeTax");
			AddResultRow(BasisCurrentRow, DependentCurrentRow, "ItemList", "ItemKey", IsVariableItemKey);
			AddResultRow(BasisCurrentRow, DependentCurrentRow, "ItemList", "Store", IsVariableStore);
	EndIf;
EndProcedure

&AtServer
Procedure AddResultRow(BasisCurrentRow, DependentCurrentRow, Source, AttributeName, IsMatch = False)
	NewRow = ThisObject.Results.Add();
	If Source = "Object" Then
		NewRow.AttributeName = AttributeName;
		NewRow.BasisValue = ThisObject.Basis[AttributeName];
		NewRow.DependentValue = ThisObject.Dependent[AttributeName];
	Else
		NewRow.AttributeName = Source + "." + AttributeName;
		NewRow.BasisValue = BasisCurrentRow[AttributeName];
		NewRow.DependentValue = DependentCurrentRow[AttributeName];
	EndIf;
	If IsMatch Then
		NewRow.IsMatch = True;
	Else
		If AttributeName = "Date" Then
			NewRow.IsMatch = (NewRow.BasisValue < NewRow.DependentValue);
		Else
			NewRow.IsMatch = (NewRow.BasisValue = NewRow.DependentValue);
		EndIf;
	EndIf;
EndProcedure

&AtClient
Procedure Inspect(Command)
	ThisObject.Results.Clear();
	
	BasisCurrentRow = ThisObject.Items.BasisItemList.CurrentData;
	If BasisCurrentRow = Undefined Then
		Return;
	EndIf;
	
	DependentCurrentRow = ThisObject.Items.DependentItemList.CurrentData;
	If DependentCurrentRow = Undefined Then
		Return;
	EndIf;
	
	FillResultTable(BasisCurrentRow.Key, DependentCurrentRow.Key);
EndProcedure
