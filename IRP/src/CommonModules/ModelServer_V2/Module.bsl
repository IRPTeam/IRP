
Procedure ServerEntryPoint(StepsEnablerName, Parameters) Export
	ModelClientServer_V2.ServerEntryPoint(StepsEnablerName, Parameters);
EndProcedure

Function ExtractDataItemKeyIsServiceServerImp(Itemkey) Export
	If Not ValueIsFilled(ItemKey) Then
		Return False;
	EndIf;
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ItemKeys.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service) AS IsService
	|FROM
	|	Catalog.ItemKeys AS ItemKeys
	|WHERE
	|	ItemKeys.Ref = &Ref";
	Query.SetParameter("Ref", ItemKey);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return QuerySelection.IsService;
	EndIf;
	Return False;
EndFunction

Function ExtractDataAgreementApArPostingDetailImp(Agreement) Export
	If Not ValueIsFilled(Agreement) Then
		Return Enums.ApArPostingDetail.EmptyRef();
	EndIf;
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Agreements.ApArPostingDetail
	|FROM
	|	Catalog.Agreements AS Agreements
	|WHERE
	|	Agreements.Ref = &Ref";
	Query.SetParameter("Ref", Agreement);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return QuerySelection.ApArPostingDetail;
	EndIf;
	Return Enums.ApArPostingDetail.EmptyRef();
EndFunction
	
Function ConvertQuantityToQuantityInBaseUnit(Bundle, Unit, Quantity) Export
	If TypeOf(Bundle) = Type("CatalogRef.ItemKeys") Then
		Return Catalogs.Units.ConvertQuantityToQuantityInBaseUnit(Bundle, Unit, Quantity).QuantityInBaseUnit;
	ElsIf TypeOf(Bundle) = Type("CatalogRef.Items") Then
		Return Catalogs.Units.Convert(Unit, Bundle.Unit, Quantity);
	EndIf;
EndFunction
	