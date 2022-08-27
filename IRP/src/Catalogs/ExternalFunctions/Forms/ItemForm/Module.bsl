
// @strict-types
&AtClient
Var PicturesStr Export; // See GetPicturesStr

&AtClient
Procedure OnOpen(Cancel)
	SetVisible();
	PicturesStr = GetPicturesStr();
EndProcedure

#Region EvalAndExecute

&AtClient
Procedure Run(Command)
	RunAtServer();
EndProcedure

&AtServer
Procedure RunAtServer()
	
	Params = CommonFunctionsServer.GetRecalculateExpressionParams();
	Params.Eval = Object.ExternalFunctionType = Enums.ExternalFunctionType.Eval;
	Params.SafeMode = Object.SafeModeIsOn;
	Params.Expression = Object.ExternalCode;
	
	ResultInfo = CommonFunctionsServer.RecalculateExpression(Params);
	
	Result = ResultInfo.Result;
	Items.Result.ToolTip = String(TypeOf(ResultInfo.Result));

	If ResultInfo.isError Then
		CommonFunctionsClientServer.ShowUsersMessage(ResultInfo.Description);
	EndIf;

	ResultJSON = CommonFunctionsServer.SerializeJSON(Result);
	
EndProcedure

#EndRegion

#Region RexExp

&AtClient
Procedure RunRegExp(Command)
	CheckRegExp();
EndProcedure

&AtClient
Async Procedure CheckRegExp(Text = Undefined)
	Facet = ?(Text = Undefined, Object.ExternalCode, Text);
	SetHTMLPictureRegExpStatus(PicturesStr.Wait);
	For Each TestRexExpString In Object.TestRexExpStrings Do
		TestRexExpString.RegExpFailed = Not Await CommonFunctionsClient.Regex(TestRexExpString.Row, Facet);
	EndDo;
	SetHTMLPictureRegExpStatus(PicturesStr.Done);
EndProcedure

&AtClient
Procedure RegExpEditTextChange(Item, Text, StandardProcessing)
	StandardProcessing = False;
	CheckRegExp(Text);
EndProcedure

#EndRegion

#Region FormHeaderItemsEventHandlers

&AtClient
Procedure ExternalFunctionTypeOnChange(Item)
	SetVisible();
EndProcedure

#EndRegion

#Region Service

&AtClient
Procedure SetHTMLPictureRegExpStatus(Image)
	HTMLPictureRegExpStatus = "<!DOCTYPE html><html><body style='box-sizing:border-box; margin:0;'><img style='display:block; width:80%;height:80%;' src='data:image/jpeg;base64," + Image + "'/></body></html>"
EndProcedure

&AtClient
Procedure SetVisible()
	If Object.ExternalFunctionType = PredefinedValue("Enum.ExternalFunctionType.RegExp") Then
		Items.PageCode.Visible = False;
		Items.PageResult.Visible = False;
		Items.PageRegExp.Visible = True;
	Else
		Items.PageCode.Visible = True;
		Items.PageResult.Visible = True;
		Items.PageRegExp.Visible = False;
	EndIf;
EndProcedure

// Get pictures str.
// 
// Returns:
//  Structure - Get pictures str:
// * Wait - String - Base64
// * Done - String - Base64
&AtServer
Function GetPicturesStr()
	PicturesStr = New Structure;
	PicturesStr.Insert("Wait", GetBase64StringFromBinaryData(PictureLib.Waiting.GetBinaryData()));
	PicturesStr.Insert("Done", GetBase64StringFromBinaryData(PictureLib.CheckSyntax.GetBinaryData()));
	Return PicturesStr;
EndFunction

#EndRegion
