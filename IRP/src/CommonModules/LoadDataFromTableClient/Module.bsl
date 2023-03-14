
// Open form for load data.
// 
// Parameters:
//  FormObject - ClientApplicationForm - Form
//  DocumentObject - FormDataStructure - Document object
Procedure OpenFormForLoadData(FormObject, DocumentObject) Export
	
	FormParameters = New Structure;
	FormParameters.Insert("FieldsForLoadData", FormObject["_FieldsForLoadData"]);
	
	AddInfo = New Structure;
	AddInfo.Insert("FormObject",     FormObject);
	AddInfo.Insert("DocumentObject", DocumentObject);
	
	OpenForm(
		"CommonForm.LoadDataFromTable", 
		FormParameters, 
		FormObject, , , , 
		New NotifyDescription("LoadDataFromTableEnd", ThisObject, AddInfo));
		
EndProcedure

// Load data from table end.
// 
// Parameters:
//  Result - See GetLoadDataDescription
//  AddInfo - Structure - Add info:
//	* FormObject - ClientApplicationForm - Form
//	* DocumentObject - DocumentObjectDocumentName - Document object
Procedure LoadDataFromTableEnd(Result, AddInfo) Export
	
	If Not Result = Undefined Then
		ViewClient_V2.ItemListLoad(
			AddInfo.DocumentObject, 
			AddInfo.FormObject, 
			Result.Address, 
			Result.GroupColumns, 
			Result.SumColumns);
	EndIf;
	
EndProcedure

// Get load data description.
// 
// Returns:
//  Structure - Get load data description:
// * Address - String -
// * GroupColumns - String -
// * SumColumns - String -
Function GetLoadDataDescription() Export
	
	Result = New Structure;
	Result.Insert("Address", "");
	Result.Insert("GroupColumns", "Item, ItemKey, Unit"); // See ControllerServer_V2.GetServerData
	Result.Insert("SumColumns", "Quantity");
	
	Return Result;
	
EndFunction