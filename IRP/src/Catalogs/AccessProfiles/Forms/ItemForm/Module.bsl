&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
EndProcedure

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure UpdateRoles(Command)
	UpdateRolesAtServer();
EndProcedure

&AtServer
Procedure UpdateRolesAtServer()
	For Each Role In Metadata.Roles Do
		If Role = Metadata.Roles.FilterForUserSettings Then
			Continue;
		EndIf;
		
		If Saas.isSaasMode() And Role = Metadata.Roles.FullAccess Then
			Continue;
		EndIf;
		
		ExtRole = Role.ConfigurationExtension();
		NameExt = ?(ExtRole = Undefined, "IRP", ExtRole.Name);
		
		If ThisObject.Roles.FindRows(New Structure("Role, Configuration", Role.Name, NameExt)).Count() Then
			Continue;
		EndIf;
		
		StrRole = Roles.Add();
		StrRole.Role = Role.Name;
		StrRole.Presentation = Role.Presentation();
		
		StrRole.Configuration = NameExt;
		
		Filter = New Structure("Role, Configuration", StrRole.Role, StrRole.Configuration);
		StrRole.Use = Object.Roles.FindRows(Filter).Count() > 0;
	EndDo;
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	If CurrentObject.AdditionalProperties.Property("UsersEventOnWriteResult") Then
		For Each Row In CurrentObject.AdditionalProperties.UsersEventOnWriteResult.ArrayOfResults Do
			CommonFunctionsClientServer.ShowUsersMessage(Row.Message);
		EndDo;
	EndIf;
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	CurrentObject.Roles.Load(ThisObject.Roles.Unload(New Structure("Use", True)));
EndProcedure