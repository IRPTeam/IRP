&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.FormParametersInfo = Parameters.Info;
	ThisObject.FormType = Parameters.Info.Type;
	
	If ThisObject.FormType = "Offers_ForDocument" Then
		OffersTree = OffersServer.CreateOffersTree(Parameters.Info.Object,
				Parameters.Info.Object.ItemList,
				Parameters.Info.Object.SpecialOffers,
				Parameters.Info.ArrayOfOffers);
		
		For Each Row In Parameters.Info.Object.SpecialOffers Do
			SearchFilter = New Structure("Offer", Row.Offer);
			ArrayOfSearch = OffersTree.Rows.FindRows(SearchFilter, True);
			For Each ItemArrayOfSearch In ArrayOfSearch Do
				ItemArrayOfSearch.isSelect = True;
			EndDo;
		EndDo;
		
	ElsIf ThisObject.FormType = "Offers_ForRow" Then
		
		ThisObject.ItemListRowKey = Parameters.Info.ItemListRowKey;
		
		OffersTree = OffersServer.CreateOffersTree(Parameters.Info.Object,
				Parameters.Info.Object.ItemList,
				Parameters.Info.Object.SpecialOffers,
				Parameters.Info.ArrayOfOffers,
				ThisObject.ItemListRowKey);
	EndIf;
	
	// Rule status: 1 - Not success; 2 - success; 3 - all rules is success
	OffersTree.Columns.Add("RuleStatus");
	
	ArrayOfOffers = OffersServer.GetAllOffersInTreeAsArray(OffersTree, True);
	For Each ItemArrayOfOffers In ArrayOfOffers Do
		AllRuleIsOk = True;
		RowWithRules = False;
		For Each RowOfferRules In ItemArrayOfOffers.Offer.Rules Do
			RuleIsOk = False;
			If ThisObject.FormType = "Offers_ForDocument" Then
				RuleIsOk = OffersServer.CheckOfferRule_ForDocument(Parameters.Info.Object,
						ItemArrayOfOffers,
						RowOfferRules.Rule);
			ElsIf ThisObject.FormType = "Offers_ForRow" Then
				RuleIsOk = OffersServer.CheckOfferRule_ForRow(Parameters.Info.Object,
						ItemArrayOfOffers,
						RowOfferRules.Rule,
						ThisObject.ItemListRowKey);
			EndIf;
			If Not RuleIsOk Then
				AllRuleIsOk = False;
			EndIf;
			RowWithRules = True;
		EndDo;
		
		If AllRuleIsOk And RowWithRules Then
			ItemArrayOfOffers.RuleStatus = 3;
		EndIf;
		
	EndDo;
	FillOffersTreePresentation(OffersTree.Rows);
	ValueToFormAttribute(OffersTree, "Offers");
	
EndProcedure

&AtServerNoContext
Procedure FillOffersTreePresentation(OffersTreeRows)
	For Each Row In OffersTreeRows Do
		Row.Presentation = String(Row.Offer);
		If ValueIsFilled(Row.Rule) Then
			Row.Presentation = Row.Presentation + " " + String(Row.Rule);
		EndIf;
		FillOffersTreePresentation(Row.Rows);
	EndDo;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	Return;
EndProcedure

&AtClient
Procedure OnOpenWithDelay() Export
	CollapseTree(ThisObject.Offers, ThisObject.Offers.GetItems());
EndProcedure

&AtClient
Procedure CollapseTree(Tree, TreeRows)
	// Collapse by Rule level
	For Each ItemTreeRows In TreeRows Do
		Collapse = False;
		For Each i In ItemTreeRows.GetItems() Do
			If ValueIsFilled(i.Rule) Then
				Collapse = True;
				Break;
			EndIf;
		EndDo;
		If Collapse Then
			ThisObject.Items.Offers.Collapse(ItemTreeRows.GetID());
		EndIf;
		DependItems = ItemTreeRows.GetItems();
		If DependItems.Count() Then
			CollapseTree(Tree, DependItems);
		EndIf;
	EndDo;
EndProcedure

&AtClient
Procedure OffersSelection(Item, SelectedRow, Field, StandardProcessing)
	StandardProcessing = False;
	ThisObject.SelectedOffersRow = SelectedRow;
	
	thisString = Offers.FindByID(SelectedRow);
	
	If Not ValueIsFilled(thisString.Offer) Then
		Return;
	EndIf;
	
	If Field.Name <> "OffersSelect"
		And OfferHaveManualInputValue(thisString.Offer)
		And ThisObject.FormType = "Offers_ForRow" Then
		
		Info = AddDataProcServer.AddDataProcInfo(GetExternalDataProcessorByOffer(thisString.Offer));
		Info.Insert("Settings", GetSettingsForOffer(thisString.Offer));
		Info.Insert("TotalAmount", thisString.TotalAmount);
		Info.Insert("TotalPercent", thisString.TotalPercent);
		Info.Insert("ItemListRowKey", ThisObject.ItemListRowKey);
		Info.Insert("FormParametersInfo", ThisObject.FormParametersInfo);
		Info.Insert("SelectedRow", SelectedRow);
		
		CallMethodAddDataProc(Info);
		
		NotifyDescription = New NotifyDescription("InputManualValueForOfferEnd", ThisObject);
		
		AddDataProcClient.OpenFormAddDataProc(Info, NotifyDescription, "InputManualValue");
	EndIf;
	
	If Field.Name <> "OffersSelect"
		And OfferHaveManualInputValue(thisString.Offer)
		And ThisObject.FormType = "Offers_ForDocument" Then
		
		Info = AddDataProcServer.AddDataProcInfo(GetExternalDataProcessorByOffer(thisString.Offer));
		Info.Insert("Settings", GetSettingsForOffer(thisString.Offer));
		Info.Insert("TotalAmount", thisString.TotalAmount);
		Info.Insert("TotalPercent", thisString.TotalPercent);
		Info.Insert("FormParametersInfo", ThisObject.FormParametersInfo);
		Info.Insert("SelectedRow", SelectedRow);
		
		CallMethodAddDataProc(Info);
		
		NotifyDescription = New NotifyDescription("InputManualValueForOfferEnd", ThisObject);
		
		AddDataProcClient.OpenFormAddDataProc(Info, NotifyDescription, "InputManualValue");
		
	EndIf;
	
	If thisString.isFolder Then
		If Items.Offers.Expanded(SelectedRow) Then
			Items.Offers.Collapse(SelectedRow);
		Else
			Items.Offers.Expand(SelectedRow);
		EndIf;
	Else
		If NOT thisString.Auto Then
			thisString.isSelect = NOT thisString.isSelect;
			If NOT thisString.isSelect Then
				thisString.TotalPercent = 0;
				thisString.TotalAmount = 0;
			EndIf;
		EndIf;
	EndIf;
EndProcedure

&AtServerNoContext
Procedure CallMethodAddDataProc(Info)
	AddDataProcServer.CallMethodAddDataProc(Info);
EndProcedure

&AtClient
Procedure InputManualValueForOfferEnd(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	If AdditionalParameters <> Undefined And AdditionalParameters.Property("SelectedRow") Then
		SelectedRow = AdditionalParameters.SelectedRow;
	EndIf;
	If Result.Property("SelectedRow") Then
		SelectedRow = Result.SelectedRow;
	EndIf;
	
	thisString = Offers.FindByID(SelectedRow);
	
	If Result.Property("Amount") Then
		thisString.TotalAmount = Result.Amount;
	EndIf;
	
	If Result.Property("Percent") Then
		thisString.TotalPercent = Result.Percent;
	EndIf;
	
	If ValueIsFilled(thisString.TotalPercent) Or ValueIsFilled(thisString.TotalAmount) Then
		thisString.isSelect = True;
	EndIf;
EndProcedure

&AtServerNoContext
Function GetExternalDataProcessorByOffer(OfferRef)
	Return OfferRef.SpecialOfferType.ExternalDataProc;
EndFunction

&AtServer
Function GetSettingsForOffer(OfferRef)
	Return PutToTempStorage(OfferRef.SpecialOfferType.Settings.Get(), ThisObject.UUID);
EndFunction

&AtServerNoContext
Function OfferHaveManualInputValue(OfferRef)
	Return OffersServer.OfferHaveManualInputValue(OfferRef);
EndFunction

&AtClient
Procedure Cancel(Command)
	Items.GroupMainPages.CurrentPage = Items.GroupOffersTree;
	
	thisString = Offers.FindByID(ThisObject.SelectedOffersRow);
	thisString.TotalPercent = 0;
	thisString.TotalAmount = 0;
	Result = PutOffersTreeToTempStorage();
	Close(Result);
EndProcedure

&AtClient
Procedure OK(Command)
	Result = PutOffersTreeToTempStorageOnClient();
	Close(Result);
EndProcedure

&AtClient
Function PutOffersTreeToTempStorageOnClient() Export
	Result = PutOffersTreeToTempStorage();
	Return Result;
EndFunction

&AtServer
Function PutOffersTreeToTempStorage()
	Result = New Structure();
	Result.Insert("OffersAddress", PutToTempStorage(FormAttributeToValue("Offers"), ThisObject.UUID));
	If ValueIsFilled(ThisObject.ItemListRowKey) Then
		Result.Insert("ItemListRowKey", ThisObject.ItemListRowKey);
	EndIf;
	Return Result;
EndFunction