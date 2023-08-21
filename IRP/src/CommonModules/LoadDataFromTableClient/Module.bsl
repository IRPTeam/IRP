
// Open form for load data.
// 
// Parameters:
//  FormObject - ClientApplicationForm - Form
//  DocumentObject - FormDataStructure - Document object
Procedure OpenFormForLoadData(FormObject, DocumentObject, AddInfo = Undefined) Export
	
	Var EndNotify;
	Var TargetField;
	Var FieldsForLoadData;
	
	If TypeOf(AddInfo) = Type("Structure") Then
		AddInfo.Property("FieldsForLoadData", FieldsForLoadData);
		AddInfo.Property("TargetField", TargetField);
		AddInfo.Property("EndNotify", EndNotify);
	EndIf;
	
	If FieldsForLoadData = Undefined Then
		//@skip-check wrong-string-literal-content
		FieldsForLoadData = FormObject["_FieldsForLoadData"];
	EndIf;
	If EndNotify = Undefined Then
		AddInfoNotify = New Structure;
		AddInfoNotify.Insert("FormObject",     FormObject);
		AddInfoNotify.Insert("DocumentObject", DocumentObject);
		EndNotify = New NotifyDescription("LoadDataFromTableEnd", ThisObject, AddInfoNotify);
	EndIf;
	
	FormParameters = New Structure;
	FormParameters.Insert("FieldsForLoadData", FieldsForLoadData);
	If TargetField <> Undefined Then
		FormParameters.Insert("TargetField", TargetField);
	EndIf;
	
	OpenForm("CommonForm.LoadDataFromTable", FormParameters, FormObject, , , , EndNotify);
		
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