
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.Items.RecordType.ChoiceList.Add("All"      , R().CLV_1);
	ThisObject.Items.RecordType.ChoiceList.Add("FixedAsset" , Metadata.Catalogs.FixedAssets.ObjectPresentation);
	ThisObject.Items.RecordType.ChoiceList.Add("Type"       , Metadata.Enums.FixedAssetTypes.Synonym);
	
	If ValueIsFilled(Record.FixedAsset) Then
		ThisObject.RecordType = "FixedAsset";
	ElsIf ValueIsFilled(Record.Type) Then
		ThisObject.RecordType = "Type";
	Else
		ThisObject.RecordType = "All";
	EndIf;
	SetVisible();
EndProcedure

&AtClient
Procedure RecordTypeOnChange(Item)
	SetVisible();
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	If ThisObject.RecordType <> "FixedAsset" Then
		CurrentObject.FixedAsset = Undefined;
	EndIf;
	
	If ThisObject.RecordType <> "Type" Then
		CurrentObject.Type = Undefined;
	EndIf;	
EndProcedure

&AtServer
Procedure SetVisible()
	Items.FixedAsset.Visible = ThisObject.RecordType = "FixedAsset";
	Items.Type.Visible = ThisObject.RecordType = "Type";
EndProcedure
