#Region FormEvents

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	If Form.Parameters.Key.IsEmpty() Then
		DocumentsServer.FillItemList(Object, Form);
		SetGroupItemsList(Object, Form);
		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	EndIf;
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	DocumentsServer.FillItemList(Object, Form);
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	DocumentsServer.FillItemList(Object, Form);
	If Not Form.GroupItems.Count() Then
		SetGroupItemsList(Object, Form);
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
EndProcedure

Procedure StoreSenderOnChange(Object) Export
	Object.UseShipmentConfirmation = Object.StoreSender.UseShipmentConfirmation;
	CheckAndUpdateUseGR(Object);
EndProcedure

Procedure StoreReceiverOnChange(Object) Export
	Object.UseGoodsReceipt = Object.StoreReceiver.UseGoodsReceipt;
	CheckAndUpdateUseGR(Object);
EndProcedure

Procedure CheckAndUpdateUseGR(Object) Export
	If Object.UseShipmentConfirmation And Not Object.UseGoodsReceipt And Not Object.StoreSender.isEmpty()
		And Not Object.StoreReceiver.isEmpty() Then
		Object.UseGoodsReceipt = True;
		CommonFunctionsClientServer.ShowUsersMessage(R().InfoMessage_023, "Object.UseGoodsReceipt");
	EndIf;
EndProcedure

#EndRegion

#Region GroupTitle

Procedure SetGroupItemsList(Object, Form)
	AttributesArray = New Array();
	AttributesArray.Add("Company");
	AttributesArray.Add("StoreSender");
	AttributesArray.Add("StoreReceiver");
	AttributesArray.Add("StoreTransit");
	DocumentsServer.DeleteUnavailableTitleItemNames(AttributesArray);
	For Each Atr In AttributesArray Do
		Form.GroupItems.Add(Atr, ?(ValueIsFilled(Form.Items[Atr].Title), Form.Items[Atr].Title,
			Object.Ref.Metadata().Attributes[Atr].Synonym + ":" + Chars.NBSp));
	EndDo;
EndProcedure

#EndRegion

#Region ListFormEvents

Procedure OnCreateAtServerListForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerListForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

#Region ChoiceFormEvents

Procedure OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion