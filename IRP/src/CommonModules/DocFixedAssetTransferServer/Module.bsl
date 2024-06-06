#Region FORM

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	If Form.Parameters.Key.IsEmpty() Then
		SetGroupItemsList(Object, Form);
		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	EndIf;
	DocumentsServer.ShowUserMessageOnCreateAtServer(Form);
	ViewServer_V2.OnCreateAtServer(Object, Form, "");
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	AccountingServer.AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters);
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	If Not Form.GroupItems.Count() Then
		SetGroupItemsList(Object, Form);
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	LockDataModificationPrivileged.LockFormIfObjectIsLocked(Form, CurrentObject);
	AccountingServer.OnReadAtServer(Object, Form, CurrentObject);
EndProcedure

#EndRegion

#Region _TITLE

Procedure SetGroupItemsList(Object, Form)
	AttributesArray = New Array();
	AttributesArray.Add("Company");
	AttributesArray.Add("FixedAsset");	
	DocumentsServer.DeleteUnavailableTitleItemNames(AttributesArray);
	For Each Attr In AttributesArray Do
		Form.GroupItems.Add(Attr, ?(ValueIsFilled(Form.Items[Attr].Title), Form.Items[Attr].Title,
			Object.Ref.Metadata().Attributes[Attr].Synonym + ":" + Chars.NBSp));
	EndDo;
EndProcedure

#EndRegion

#Region LIST_FORM

Procedure OnCreateAtServerListForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerListForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

#Region CHOICE_FORM

Procedure OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

Function GetFixedAssetLocation(Date, Company, FixedAsset) Export
	Return ServerReuse.GetFixedAssetLocation(Date, Company, FixedAsset);
EndFunction

Function _GetFixedAssetLocation(Date, Company, FixedAsset) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	T8515S_FixedAssetsLocationSliceLast.ResponsiblePerson,
	|	T8515S_FixedAssetsLocationSliceLast.Branch,
	|	T8515S_FixedAssetsLocationSliceLast.ProfitLossCenter
	|FROM
	|	InformationRegister.T8515S_FixedAssetsLocation.SliceLast(&Date, Company = &Company
	|	AND FixedAsset = &FixedAsset) AS T8515S_FixedAssetsLocationSliceLast
	|WHERE
	|	T8515S_FixedAssetsLocationSliceLast.IsActive";
	Query.SetParameter("Date", Date);
	Query.SetParameter("Company", Company);
	Query.SetParameter("FixedAsset", FixedAsset);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	Result = New Structure("ResponsiblePerson, Branch, ProfitLossCenter");
	If QuerySelection.Next() Then
		Result.ResponsiblePerson = QuerySelection.ResponsiblePerson;
		Result.Branch            = QuerySelection.Branch;
		Result.ProfitLossCenter  = QuerySelection.ProfitLossCenter;
	EndIf;
	Return Result;
EndFunction

