// @strict-types

#Region Events

#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)

	//@skip-check property-return-type
	ButtonsArray = Parameters.PayButtons; // Array of See POSClient.ButtonSettings
	CreateFormElement(ButtonsArray);
	
	//@skip-warning
	Items.BackToSelectGroup.Shortcut = New Shortcut(Key["Num0"]);
	
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	SetHotKey();
EndProcedure

&AtServer
Procedure CreateFormElement(ButtonsArray)

	PayButtonsParent = New Map; 
	
	For Each ButtonSettings In ButtonsArray Do 
		If ButtonSettings.PaymentType.Parent.IsEmpty() Then
			ButtonsList = New Array;
			ButtonsList.Add(ButtonSettings);
			PayButtonsParent.Insert(ButtonSettings.PaymentType, ButtonsList);
		ElsIf PayButtonsParent.Get(ButtonSettings.PaymentType.Parent) = Undefined Then
			ButtonsList = New Array;
			ButtonsList.Add(ButtonSettings);
			PayButtonsParent.Insert(ButtonSettings.PaymentType.Parent, ButtonsList);
		Else
			//@skip-check dynamic-access-method-not-found
			PayButtonsParent.Get(ButtonSettings.PaymentType.Parent).Add(ButtonSettings);
		EndIf;
	EndDo;

	MaxButtonPerPage = PayButtonsParent.Count();
	For Each PayGroup In PayButtonsParent Do
		
		PayButtonsIntoGroup = PayGroup.Value; // Array of See POSClient.ButtonSettings
		
		If PayButtonsIntoGroup.UBound() > MaxButtonPerPage Then
			MaxButtonPerPage = PayButtonsIntoGroup.UBound();
		EndIf;

	EndDo;

	GroupIndex = 0;

	For Each PayGroup In PayButtonsParent Do
		
		PayButtonsIntoGroup = PayGroup.Value; // Array of See POSClient.ButtonSettings
		PaymentTypeGroup = PayGroup.Key; // CatalogRef.PaymentTypes
		
		ButtonName = StrTemplate("Page_%1", GroupIndex);
		
		Description = "[" + String(GroupIndex + 1) + "] " + String(PaymentTypeGroup) 
		+ ?(PayButtonsIntoGroup.Count() > 1, " >", "");
		
		DrawButton(PaymentTypeGroup, ButtonName, Description, Items.PaymentGroup, "PayButtonGroup");
				
		NewPageItem = Items.Add("ButtonPage_" + GroupIndex, Type("FormGroup"), Items.PaymentPages);
		NewPageItem.Type = FormGroupType.Page;
		NewPageItem.Title = String(PaymentTypeGroup);
		NewPageItem.Visible = False;
		
		For Index = 0 To PayButtonsIntoGroup.UBound() Do
			ButtonSettings = PayButtonsIntoGroup[Index]; 
			ButtonName = StrTemplate("PayButton_%1_%2", GroupIndex, Index);

			NewPayment = LinkedPayButtons.Add();
			NewPayment.ButtonName = ButtonName;
			FillPropertyValues(NewPayment, ButtonSettings);
			
			Description = "[" + String(Index + 1) + "] " + String(ButtonSettings.PaymentType);
			
			DrawButton(PaymentTypeGroup, ButtonName, Description, NewPageItem, "PayButtonPress");
			
		EndDo;
		
		If Index > 1 Then
			For Index = PayButtonsIntoGroup.Count() To MaxButtonPerPage Do
				LabelName = StrTemplate("PayButton_%1_%2", GroupIndex, Index);
				DrawLabel(LabelName, NewPageItem);
			EndDo;
		EndIf;
		
		GroupIndex = GroupIndex + 1;
	EndDo;
	
	For Index = GroupIndex + 1 To MaxButtonPerPage - 1 Do
		LabelName = StrTemplate("Page_%1", Index);
		DrawLabel(LabelName, Items.PaymentGroup);
	EndDo;
	
	If GroupIndex = 1 Then
		Items.PaymentPages.CurrentPage = NewPageItem;
	EndIf;
	
EndProcedure

&AtServer
Procedure DrawButton(PaymentTypeGroup, ButtonName, Description, Page, Action)

	NewAttributeArray = New Array;
	NewAttributeArray.Add(New FormAttribute(ButtonName, New TypeDescription("String")));
	ChangeAttributes(NewAttributeArray);	
	
	NewDecoration = Items.Add(ButtonName, Type("FormField"), Page);
	NewDecoration.Type = FormFieldType.PictureField;
	NewDecoration.DataPath = ButtonName;
	NewDecoration.SetAction("Click", Action);
	NewDecoration.Hyperlink = True;
	NewDecoration.TitleLocation = FormItemTitleLocation.None;
	NewDecoration.Height = 2;
	NewDecoration.VerticalStretch = False;
	NewDecoration.NonselectedPictureText = Description;
	NewDecoration.ToolTip = Description;
	
	//@skip-check invocation-parameter-type-intersect
	ThisObject[ButtonName] = GetURL(PaymentTypeGroup, "Icon");
EndProcedure

&AtServer
Procedure DrawLabel(LabelName, Page)
	NewAttributeArray = New Array;
	NewAttributeArray.Add(New FormAttribute(LabelName, New TypeDescription("String")));
	ChangeAttributes(NewAttributeArray);

	NewDecoration = Items.Add(LabelName, Type("FormField"), Page);
	NewDecoration.Type = FormFieldType.PictureField;
	NewDecoration.DataPath = LabelName;
	NewDecoration.TitleLocation = FormItemTitleLocation.None;
	NewDecoration.Height = 2;
	NewDecoration.VerticalStretch = False;
	NewDecoration.BorderColor = StyleColors.FormBackColor;

EndProcedure

#EndRegion

#Region Commands

// Pay button press.
// 
// Parameters:
//  Item - FormCommand - Item
//  StandardProcessing - Boolean - Standard processing
&AtClient
Procedure PayButtonPress(Item, StandardProcessing)
	
	StandardProcessing = False;
	ReturnValueAndCloseForm(Item.Name);
	
EndProcedure

&AtClient
Procedure ReturnValueAndCloseForm(Val CommandName)

	FindPaymentType = LinkedPayButtons.FindRows(New Structure("ButtonName", CommandName));
	Result = POSClient.ButtonSettings();
	FillPropertyValues(Result, FindPaymentType[0]);

	Close(Result);
EndProcedure

// Pay button group.
// 
// Parameters:
//  Item - FormCommand - Item
//  StandardProcessing - Boolean - Standard processing
&AtClient
Procedure PayButtonGroup(Item, StandardProcessing)
	StandardProcessing = False;
	
	ButtonPage = Items.Find("Button" + Item.Name);
	If ButtonPage.ChildItems.Count() = 1 Then
		ReturnValueAndCloseForm(ButtonPage.ChildItems[0].Name)
	Else
		Items.PaymentPages.CurrentPage = Items.Find("Button" + Item.Name);
		SetHotKey();
	EndIf;
	
EndProcedure

&AtClient
Procedure BackToSelectGroup(Command)
	
	Items.PaymentPages.CurrentPage = Items.PaymentGroup;
	SetHotKey();
	
EndProcedure

&AtClient
Procedure CloseButton(Command)
	
	Close();
	
EndProcedure

&AtClient
Procedure SetHotKey()
	
	For Each Page In Items.PaymentPages.ChildItems Do
		For Each Item In Page.ChildItems Do
			
			Item.Shortcut = New Shortcut(Key.None);
			
		EndDo;
		Page.Visible = Page = Items.PaymentPages.CurrentPage;
	EndDo;
	
	For Each Item In Items.PaymentPages.CurrentPage.ChildItems Do
		
		Array = StrSplit(Item.Name, "_");
		Num = Number(Array[Array.UBound()]) + 1;
		MaxNumKey = 10;
		If Num < MaxNumKey Then
			Item.Shortcut = New Shortcut(Key["Num" + Num]);
		EndIf;
		
	EndDo;
	
EndProcedure

#EndRegion

#EndRegion

#Region Internal

#EndRegion