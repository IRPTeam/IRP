&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.Ref = Parameters.Ref;
	
	AddAttributeAndPropertySet = AddAttributesAndPropertiesServer.AddAttributeAndPropertySetRef(Ref);
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	AddAttributeAndPropertySetsProperties.Property
		|INTO Properties
		|FROM
		|	Catalog.AddAttributeAndPropertySets.Properties AS AddAttributeAndPropertySetsProperties
		|WHERE
		|	AddAttributeAndPropertySetsProperties.Ref = &AddAttributeAndPropertySets
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	AddProperties.Value,
		|	Properties.Property
		|FROM
		|	Properties AS Properties
		|		LEFT JOIN InformationRegister.AddProperties AS AddProperties
		|		ON Properties.Property = AddProperties.Property
		|		AND AddProperties.Object = &Object";
	Query.SetParameter("Object", ThisObject.Ref);
	Query.SetParameter("AddAttributeAndPropertySets", AddAttributeAndPropertySet);
	Query.SetParameter("Properties", ThisObject.Properties.Unload());
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	ThisObject.Properties.Load(QueryTable);
	
	For Each Row In ThisObject.Properties Do
		AttributeStructure = New Structure("Attribute, InterfaceGroup", Row.Property, Undefined);
		PropertyInfo = AddAttributesAndPropertiesServer.AttributeAndPropertyInfo(AttributeStructure);
		Row.TypeDef = PropertyInfo.Type;
	EndDo;
	
EndProcedure

&AtClient
Procedure PropertiesBeforeRowChange(Item, Cancel)
	CurrentData = ThisObject.Items.Properties.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	ArrayOfSelectionArgs = New Array();
	If CurrentData.TypeDef.ContainsType(Type("CatalogRef.AddAttributeAndPropertyValues")) Then
		ArrayOfSelectionArgs.Add(New ChoiceParameter("Filter.Owner", CurrentData.Property));
	EndIf;
	ThisObject.Items.PropertiesValue.ChoiceParameters = New FixedArray(ArrayOfSelectionArgs);
EndProcedure

&AtClient
Procedure PropertiesOnStartEdit(Item, NewRow, Clone)
	If Item.CurrentData.Value = Undefined Then
		Item.ChildItems.PropertiesValue.TypeRestriction = Item.CurrentData.TypeDef;
	EndIf;
EndProcedure

&AtClient
Procedure Save(Command)
	SaveAtServer();
EndProcedure

&AtClient
Procedure SaveAndClose(Command)
	SaveAtServer();
	ThisObject.Close();
EndProcedure

&AtServer
Procedure SaveAtServer()
	RecordSet = InformationRegisters.AddProperties.CreateRecordSet();
	RecordSet.Filter.Object.Set(ThisObject.Ref);
	ValueTable = ThisObject.Properties.Unload();
	ValueTable.Columns.Add("Object");
	ValueTable.FillValues(ThisObject.Ref, "Object");
	
	ArrayForDelete = New Array();
	For Each Row In ValueTable Do
		If Not ValueIsFilled(Row.Value) Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;
	For Each Item In ArrayForDelete Do
		ValueTable.Delete(Item);
	EndDo;
	
	RecordSet.Load(ValueTable);
	RecordSet.Write();
EndProcedure

&AtClient
Procedure PropertiesBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure PropertiesBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

