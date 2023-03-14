#Region FormEvents

Procedure ListBeforeAddRow(Form, Item, Cancel, Clone, Parent, IsFolder, Parameter) Export
	CommonFormActions.DynamicListBeforeAddRow(
				Form, Item, Cancel, Clone, Parent, IsFolder, Parameter, "Catalog.Companies.ObjectForm");
EndProcedure

#EndRegion

Function GetCompanyValueList(Company) Export
	List = New ValueList();
	List.Add(Company);
	List.Add(PredefinedValue("Catalog.Companies.EmptyRef"));
	Return List;
EndFunction