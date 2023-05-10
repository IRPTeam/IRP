// @strict-types

// Clear all by row.
// 
// Parameters:
//  Object - See DataProcessor.PointOfSale.Form.Form.Object
//  Rows - Array Of Structure:
//  * Key - String -
Procedure ClearAllByRow(Object, Rows) Export
	For Each Row In Rows Do
		CodeRows = Object.ControlCodeStrings.FindRows(New Structure("Key", Row.Key));
		For Each CodeRow In CodeRows Do
			Object.ControlCodeStrings.Delete(CodeRow);
		EndDo;
	EndDo;
EndProcedure

// Update state
// 
// Parameters:
//  Object - See DataProcessor.PointOfSale.Form.Form.Object
Procedure UpdateState(Object) Export
	For Each Row In Object.ItemList Do
		If Not Row.isControlCodeString Then
			Row.ControlCodeStringState = 0;
			Continue;
		EndIf;
		
		Row.ControlCodeStringState = 1;
		
		CodeRows = Object.ControlCodeStrings.FindRows(New Structure("Key", Row.Key));
		If CodeRows.Count() > 1 Then
			Row.ControlCodeStringState = 2;		
		EndIf;
		
		If CodeRows.Count() = Row.Quantity Then
			Row.ControlCodeStringState = 3;		
		EndIf;
		
	EndDo;
EndProcedure