
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Items.SettingsStorageName.ChoiceList.Add("SystemSettingsStorage"           , R().SettingsStorage1);
	Items.SettingsStorageName.ChoiceList.Add("FormDataSettingsStorage"         , R().SettingsStorage2);
	Items.SettingsStorageName.ChoiceList.Add("ReportsVariantsStorage"          , R().SettingsStorage3);
	Items.SettingsStorageName.ChoiceList.Add("CommonSettingsStorage"           , R().SettingsStorage4);
	Items.SettingsStorageName.ChoiceList.Add("DynamicListsUserSettingsStorage" , R().SettingsStorage5);
	Items.SettingsStorageName.ChoiceList.Add("ReportsUserSettingsStorage"      , R().SettingsStorage6);
	
	ThisObject.SettingsStorageName = "SystemSettingsStorage";
	
	For Each User In InfoBaseUsers.GetUsers() Do
		Items.UserName.ChoiceList.Add(User.Name);
	EndDo;
	
	UpdateUserNameTable();
EndProcedure

&AtClient
Procedure SettingsBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure SettingsBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure UncheckAllUsers(Command)
	For Each Row In ThisObject.UserNameTable Do
		Row.Use = False;
	EndDo;
EndProcedure

&AtClient
Procedure CheckAllUsers(Command)
	For Each Row In ThisObject.UserNameTable Do
		Row.Use = True;
	EndDo;
EndProcedure

&AtClient
Procedure UserNameTableBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure UserNameTableBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure UserNameOnChange(Item)
	UpdateUserNameTable();
	UpdateSettingsAtServer();
EndProcedure

&AtClient
Procedure SettingsStorageNameOnChange(Item)
	UpdateSettingsAtServer();
EndProcedure

&AtClient
Procedure UpdateSettings(Command)
	If ThisObject.CheckFilling() Then
		UpdateSettingsAtServer();
	EndIf;
EndProcedure

&AtClient
Procedure CopySettings(Command)
	SelectedSettings = GetSelectedSettingsID();	
	CopySettingsAtServer(SelectedSettings);
EndProcedure

&AtClient
Function GetSelectedSettingsID()
	ArrayOfSelectedSettings = New Array();
	
	For Each RowId In Items.Settings.SelectedRows Do
		TreeRow = ThisObject.Settings.FindByID(RowId);
		If TreeRow.GetItems().Count() > 0 Then
			AddChildRows(ArrayOfSelectedSettings, TreeRow.GetItems());
		Else
			ArrayOfSelectedSettings.Add(RowId);
		EndIf;
	EndDo;
	Return ArrayOfSelectedSettings;
EndFunction

&AtClient
Function AddChildRows(ArrayOfSelectedSettings, TreeRows)
	For Each TreeRow In TreeRows Do
		If TreeRow.GetItems().Count() > 0 Then
			AddChildRows(ArrayOfSelectedSettings, TreeRow.GetItems());
		Else
			ArrayOfSelectedSettings.Add(TreeRow.GetID());
		EndIf;
	EndDo;
EndFunction

&AtServer
Procedure UpdateUserNameTable()
	ThisObject.UserNameTable.Clear();
	For Each User In InfoBaseUsers.GetUsers() Do
		If ValueIsFilled(ThisObject.UserName) And ThisObject.UserName = User.Name Then
			Continue;
		EndIf;
		ThisObject.UserNameTable.Add().User = User.Name;
	EndDo;
EndProcedure

&AtServer
Procedure UpdateSettingsAtServer()
	TreeItems = ThisObject.Settings.GetItems();
	TreeItems.Clear();
	
	If Not ValueIsFilled(ThisObject.SettingsStorageName) Or Not ValueIsFilled(ThisObject.UserName) Then
		Return;
	EndIf;
	
	SettingsStorage = GetSettingsStorage(ThisObject.SettingsStorageName);	
	SettingsSelection = SettingsStorage.Select(New Structure("User", ThisObject.UserName)); 
		
	ValueTable = New ValueTable();
	ValueTable.Columns.Add("ObjectKey");
	ValueTable.Columns.Add("SettingsKey");
	ValueTable.Columns.Add("User");
	ValueTable.Columns.Add("Presentation");
	
	While SettingsSelection.Next() Do
		NewRow = ValueTable.Add();
		NewRow.ObjectKey    = SettingsSelection.ObjectKey;
		NewRow.SettingsKey  = SettingsSelection.SettingsKey;
		NewRow.User         = SettingsSelection.User;
		NewRow.Presentation = SettingsSelection.Presentation;
	EndDo;
	
	ValueTable.Sort("ObjectKey, SettingsKey, User");
	
	ArrayOfParent = New Array; 
	ParentCount = 0;
	
	For Each TableRow In ValueTable Do
		ObjectKey = TableRow.ObjectKey;
		
		CurrentParentKey = "";
		ParentKeyLenght = 0;
	
		CurrentRows = TreeItems;
		Index=0;
		While Index < ParentCount Do	
			Parent=ArrayOfParent[Index];
			LastKeySymbol = Mid(ObjectKey, Parent.KeyLenght, 1);
			
			If StrCompare(Left(ObjectKey, Parent.KeyLenght),Parent.ObjectKey) <> 0 
				Or (LastKeySymbol <> "\" And LastKeySymbol <> "." And LastKeySymbol <> "/") Then   
				Break;
			EndIf; 
			
			CurrentParentKey = Parent.ObjectKey;
			ParentKeyLenght  = Parent.KeyLenght;
			CurrentRows      = Parent.Rows;
			Index = Index + 1;
		EndDo; 
		
		ParentCount = Index;
		
		While True Do
			
			_ObjectKey = Mid(ObjectKey, ParentKeyLenght + 1);
			
			Position = 999999999;
			PositionTmp = StrFind(_ObjectKey, ".", SearchDirection.FromBegin);
			
			Position = ?(PositionTmp=0, Position, Min(Position, PositionTmp));
			PositionTmp = StrFind(_ObjectKey, "\", SearchDirection.FromBegin);
			
			Position = ?(PositionTmp=0, Position, Min(Position, PositionTmp));
			PositionTmp = StrFind(_ObjectKey, "/", SearchDirection.FromBegin);
			
			Position=?(PositionTmp=0, Position, Min(Position, PositionTmp));
		
			If Position=999999999 Then   
				TreeRow = CurrentRows.Add();
				FillPropertyValues(TreeRow, TableRow); 
				TreeRow.Object    = _ObjectKey;
				TreeRow.ObjectKey = Left(ObjectKey, ParentKeyLenght) + _ObjectKey;
				Break;
			Else
				ParentKey        = Left(_ObjectKey, Position);
				CurrentParentKey = CurrentParentKey + ParentKey;
				ParentKeyLenght  = ParentKeyLenght + Position;
				
				TreeRow=CurrentRows.Add();
				TreeRow.Object    = ParentKey;
				TreeRow.ObjectKey = Left(ObjectKey, ParentKeyLenght);
				
				CurrentRows=TreeRow.GetItems();
				
				ArrayOfParent.Insert(ParentCount,
					New Structure("ObjectKey, KeyLenght, Rows", CurrentParentKey, ParentKeyLenght, CurrentRows));
				ParentCount=ParentCount+1;
			EndIf; 
		EndDo; 
	EndDo; 
EndProcedure 

&AtServer
Procedure CopySettingsAtServer(SelectedSettings)
	Storage = GetSettingsStorage(ThisObject.SettingsStorageName);
	
	For Each TreeRowID In SelectedSettings Do
		SettingsRow = ThisObject.Settings.FindByID(TreeRowID);
		SettingsValue = Storage.Load(SettingsRow.ObjectKey, SettingsRow.SettingsKey, ,SettingsRow.User);
		
		For Each UserTableRow In ThisObject.UserNameTable Do
			If UserTableRow.Use Then
				Storage.Save(SettingsRow.ObjectKey, SettingsRow.SettingsKey, SettingsValue, ,UserTableRow.User);
			EndIf;
		EndDo;
	EndDo;
EndProcedure

&AtServerNoContext
Function GetSettingsStorage(StorageName)
	If StorageName = "FormDataSettingsStorage" Then
		Return FormDataSettingsStorage;
	ElsIf StorageName = "ReportsVariantsStorage" Then
		Return ReportsVariantsStorage;
	ElsIf StorageName = "CommonSettingsStorage" Then
		Return CommonSettingsStorage;
	ElsIf StorageName = "DynamicListsUserSettingsStorage" Then
		Return DynamicListsUserSettingsStorage
	ElsIf StorageName = "ReportsUserSettingsStorage" Then
		Return ReportsUserSettingsStorage;
	ElsIf StorageName = "SystemSettingsStorage" Then
		Return SystemSettingsStorage;
	Else
		Raise StrTemplate("Unsupported setting storage name [%1]", StorageName);
	EndIf;
EndFunction
