// @strict-types

&AtClient
Var isLogoSet, isSealSet Export; //Boolean 

&AtServer
Procedure OnReadAtServer(CurrentObject)
	Logo = PutToTempStorage(CurrentObject.Logo.Get(), UUID);
	Seal = PutToTempStorage(CurrentObject.Seal.Get(), UUID);
	If Not IsBlankString(CurrentObject.DefaultColor) Then
		//@skip-check statement-type-change
		DefaultColor = CommonFunctionsServer.DeserializeJSONUseXDTO(CurrentObject.DefaultColor);
	EndIf; 
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	If Not IsBlankString(Logo) Then
		CurrentObject.Logo = New ValueStorage(GetFromTempStorage(Logo), New Deflation(9));
	EndIf;
	If Not IsBlankString(Seal) Then
		CurrentObject.Seal = New ValueStorage(GetFromTempStorage(Seal), New Deflation(9));
	EndIf;
	CurrentObject.DefaultColor = CommonFunctionsServer.SerializeJSONUseXDTO(DefaultColor); 
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	isLogoSet = Object.isLogoSet;
	isSealSet = Object.isSealSet;
EndProcedure

&AtClient
Procedure LogoClick(Item, StandardProcessing)
	StandardProcessing = False;
	DoChangeLogo();
EndProcedure

&AtClient
Async Procedure DoChangeLogo()
	//@skip-check invocation-parameter-type-intersect
	NewLogo = Await DoChangeIconAction(isLogoSet);
	isLogoSet = Not NewLogo = Undefined;
	If isLogoSet Then
		//@skip-check statement-type-change
		Logo = NewLogo;
	Else
		Logo = PutToTempStorage(Undefined, UUID);
	EndIf;
EndProcedure

&AtClient
Procedure SealClick(Item, StandardProcessing)
	StandardProcessing = False;
	DoChangeSeal();
EndProcedure

&AtClient
Async Procedure DoChangeSeal()
	//@skip-check invocation-parameter-type-intersect
	NewSeal = Await DoChangeIconAction(isSealSet);
	isSealSet = Not NewSeal = Undefined;
	//@skip-check statement-type-change
	Seal = NewSeal;
	If isSealSet Then
		//@skip-check statement-type-change
		Seal = NewSeal;
	Else
		Seal = PutToTempStorage(Undefined, UUID);
	EndIf;
EndProcedure

&AtClient
Async Function DoChangeIconAction(Val isIconSet)
	If isIconSet Then
		QueryText = R().QuestionToUser_016;
		QueryButtons = New ValueList();
		QueryButtons.Add("Change", R().Form_017);
		QueryButtons.Add("Clear", R().Form_018);
		QueryButtons.Add("Cancel", R().Form_019);
		Result = Await DoQueryBoxAsync(QueryText, QueryButtons); // String
		If Result = "Cancel" Then
			Return Undefined;
		ElsIf Result = "Change" Then
			Return Await AskForChangeIcon();
		Else
			Return Undefined;
		EndIf;
	Else
		Return Await AskForChangeIcon();
	EndIf;
EndFunction

&AtClient
Async Function AskForChangeIcon()
	DialogParameters = New PutFilesDialogParameters(R().S_026, False, PictureViewerClientServer.FilterForPicturesDialog());
	StoredFileDescription = Await PutFileToServerAsync(, , , DialogParameters, UUID); // StoredFileDescription
	If StoredFileDescription = Undefined OR StoredFileDescription.PutFileCanceled Then
		Return Undefined;
	EndIf;
	Return StoredFileDescription.Address;
EndFunction
