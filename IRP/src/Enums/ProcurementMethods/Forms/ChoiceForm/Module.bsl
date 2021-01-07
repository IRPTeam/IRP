&AtClient
Procedure StockOnChange(Item)
	
	If Stock Then
		Purchase = False;
		NoReserve = False;
	EndIf;
	
	PickParameters = New Structure();
	PickParameters.Insert("ItemName", Item.Name);
	PickParameters.Insert("ItemValue", Stock);
	
	PickedProcurementMethodsRefresh(PickParameters);
	
EndProcedure

&AtClient
Procedure PurchaseOnChange(Item)
	
	If Purchase Then
		NoReserve = False;
		Stock = False;
	EndIf;
	
	PickParameters = New Structure();
	PickParameters.Insert("ItemName", Item.Name);
	PickParameters.Insert("ItemValue", Purchase);
	
	PickedProcurementMethodsRefresh(PickParameters);
	
EndProcedure

&AtClient
Procedure NoReserveOnChange(Item)
	
	If NoReserve Then
		Purchase = False;
		Stock = False;
	EndIf;
	
	PickParameters = New Structure();
	PickParameters.Insert("ItemName", Item.Name);
	PickParameters.Insert("ItemValue", NoReserve);
	
	PickedProcurementMethodsRefresh(PickParameters);
	
EndProcedure

&AtClient
Procedure PickedProcurementMethodsRefresh(PickParameters)
	
	If PickParameters.ItemValue Then
		
		PickedProcurementMethods.Add(PickParameters.ItemName);
		
	Else
		
		PickedProcurementMethods.Delete(PickedProcurementMethods.FindByValue(PickParameters.ItemName));
		
	EndIf;
	
EndProcedure

&AtClient
Procedure OK(Command)
	
	If PickedProcurementMethods.Count() = 0 Then
		ThisObject.Close();
		Return;
	EndIf;
	
	ProcurementMethodsArray = New Array();
	
	For Each PickedMethod In PickedProcurementMethods Do
		
		ProcurementMethodsArray.Add(PredefinedValue("Enum.ProcurementMethods." + PickedMethod.Value));
		
	EndDo;
	
	ResultStructure = New Structure();
	ResultStructure.Insert("ProcurementMethods", ProcurementMethodsArray);
	
	ThisObject.Close(ResultStructure);
	
EndProcedure

