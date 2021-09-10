#Region EventHandlers

Procedure BeforeWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	AutoCreateItemKey(ThisObject);
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure OnCopy(CopiedObject)
	PackageUnit = Undefined;
EndProcedure

#EndRegion

#Region Private

Procedure AutoCreateItemKey(Object)
	UseItemKey = GetFunctionalOption("UseItemKey");
	If UseItemKey Then
		Return;
	EndIf;
	Query = New Query("SELECT TOP 1
					  |	Table.Ref
					  |FROM 
					  |	Catalog.ItemKeys AS Table
					  |WHERE
					  |	Table.Item = &Item");
	Query.SetParameter("Item", Object.Ref);
	If Query.Execute().IsEmpty() Then
		NewItem = Catalogs.ItemKeys.CreateItem();
		FillPropertyValues(NewItem, Object, , "Parent, Owner, Ref, Unit");
		NewItem.Item = Ref;
		NewItem.Write();
	EndIf;
EndProcedure

#EndRegion