// @strict-types

// Presentation get processing.
// 
// Parameters:
//  Data - See CatalogRef.ExternalFunctions
//  Presentation - String - Presentation
//  StandardProcessing - Boolean - Standard processing
Procedure PresentationGetProcessing(Data, Presentation, StandardProcessing)
	
	If Not Data.UseForSetDescription = True Then
		Return;
	EndIf;
	
	StandardProcessing = False;

	Params = CommonFunctionsServer.GetRecalculateExpressionParams();
	Params.SafeMode = Data.SafeModeIsOn;
	Params.Expression = Data.ExternalCode;
	
	ResultInfo = CommonFunctionsServer.RecalculateExpression(Params);
	If ResultInfo.isError Then
		Presentation = R().Error_119;
	Else
		Presentation = String(ResultInfo.Result);
	EndIf;
	
EndProcedure

// Presentation fields get processing.
// 
// Parameters:
//  Fields - Array Of String -  Fields
//  StandardProcessing - Boolean -  Standard processing
Procedure PresentationFieldsGetProcessing(Fields, StandardProcessing)
	StandardProcessing = False;
	Fields.Add("ExternalFunctionType");
	Fields.Add("SafeModeIsOn");
	Fields.Add("ExternalCode");
	Fields.Add("UseForSetDescription");
	Fields.Add("Description");
EndProcedure
