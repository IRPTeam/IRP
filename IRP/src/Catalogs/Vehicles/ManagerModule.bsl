
// Load trailer list on form.
// 
// Parameters:
//  Form - ClientApplicationForm - Form
//  Object - DocumentObject.InventoryTransfer, DocumentObject.ShipmentConfirmation - Object
Procedure LoadTrailerListOnForm(Form, Object) Export
	
	Form.Trailers.Clear();
	Form.Trailers.LoadValues(Object.TrailerList.UnloadColumn("Trailer"));
	
EndProcedure

// Save trailer list to object.
// 
// Parameters:
//  Form - ClientApplicationForm - Form
//  Object - DocumentObject.InventoryTransfer, DocumentObject.ShipmentConfirmation - Object
Procedure SaveTrailerListToObject(Form, Object) Export
	
	Object.TrailerList.Clear();
	For Each TrailerItem In Form.Trailers Do
		Object.TrailerList.Add().Trailer = TrailerItem.Value; 
	EndDo;
	
EndProcedure

