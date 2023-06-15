Procedure PresentationFieldsGetProcessing(Fields, StandardProcessing)
	StandardProcessing = False;
	Fields.Add("Code");
EndProcedure

// Presentation get processing.
// 
// Parameters:
//  Data - Structure - Data:
//  * Code - CatalogRef.Stores
//  Presentation - String - Presentation
//  StandardProcessing - Boolean - Standard processing
Procedure PresentationGetProcessing(Data, Presentation, StandardProcessing)
	StandardProcessing = False;
	Presentation = Data.Code;
EndProcedure