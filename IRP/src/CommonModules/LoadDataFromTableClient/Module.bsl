
// Open form for load data.
// 
// Parameters:
//  FormObject - ClientApplicationForm - Form
//  DocumentObject - FormDataStructure - Document object
Procedure OpenFormForLoadData(FormObject, DocumentObject) Export
	
	AddInfo = New Structure;
	AddInfo.Insert("FormObject",     FormObject);
	AddInfo.Insert("DocumentObject", DocumentObject);
	
	OpenForm(
		"CommonForm.LoadDataFromTable", , 
		FormObject, , , , 
		New NotifyDescription("LoadDataFromTableEnd", ThisObject, AddInfo));
		
EndProcedure

// Load data from table end.
// 
// Parameters:
//  Result - String - Address for result
//  AddInfo - Structure - Add info:
//	* FormObject - ClientApplicationForm - Form
//	* DocumentObject - DocumentObjectDocumentName - Document object
Procedure LoadDataFromTableEnd(Result, AddInfo) Export
	
	If Not Result = Undefined And Not IsBlankString(Result) Then
		ViewClient_V2.ItemListLoad(AddInfo.DocumentObject, AddInfo.FormObject, Result);
	EndIf;
	
EndProcedure
