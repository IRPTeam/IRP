Procedure BeforeWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;

	If Not IsNew() Then
		AdditionalProperties.Insert("OldUsersList", Ref.Users.UnloadColumn("User"));
	EndIf;

EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	If Cancel Then
		Return;
	EndIf;
	
	Query = New Query;
	Query.Text =
		"SELECT
		|	AccessProfilesRoles.Role
		|FROM
		|	Catalog.AccessProfiles.Roles AS AccessProfilesRoles
		|WHERE
		|	AccessProfilesRoles.Ref IN (&Ref)
		|GROUP BY
		|	AccessProfilesRoles.Role";
	
	Query.SetParameter("Ref", Profiles.UnloadColumn("Profile"));
	
	RoleList = Query.Execute().Unload().UnloadColumn("Role");

	RegRule = InformationRegisters.T9101A_ObjectAccessRegisters.CreateRecordSet();
	RegRule.Filter.AccessGroup.Set(ThisObject.Ref);
	RegRule.Write();

	If Not ThisObject.DeletionMark Then
		For Each RegInfo In Metadata.AccumulationRegisters Do
			FillRegistersAccessKeys(RegInfo, RoleList);
		EndDo;
		For Each RegInfo In Metadata.InformationRegisters Do
			FillRegistersAccessKeys(RegInfo, RoleList);
		EndDo;
	EndIf;
EndProcedure

Procedure FillRegistersAccessKeys(RegInfo, RoleList)
	
	Skip = True;
	For Each Role In RoleList Do
		If AccessRight("Read", RegInfo, Metadata.Roles[Role]) Then
			Skip = False;
		EndIf;
	EndDo;
	
	If Skip Then
		Return;
	EndIf;
	
	Module = MetadataInfo.GetManager(RegInfo.FullName()); // AccumulationRegistersManager
	Try
		AccessKeys = Module.GetAccessKey();
	Except
		// Object not connected to access subsystem
		Return;		
	EndTry;
	
	If AccessKeys.Count() = 0 Then
		// Object not using access keys
		Return;
	EndIf;
	
	KeyValueArray = New Array;
	For Each AccessKey In AccessKeys Do
		KeyValueArray.Add(ThisObject.ObjectAccess.Unload(New Structure("Key", AccessKey.Key)));
	EndDo;
	
	Query = New Query("SELECT * FROM InformationRegister.T9101A_ObjectAccessRegisters WHERE FALSE");
	ResultTable = Query.Execute().Unload();
	For i = 0 To KeyValueArray.UBound() Do
		TmpTable = ResultTable.Copy();
		ValueArray = KeyValueArray[i];
		If ValueArray.Count() = 0 Then
			Continue;
		EndIf;
		ResultTable.Clear();
		For Each Value In ValueArray Do
			If TmpTable.Count() > 0 Then
				For Each ResRow In TmpTable Do
					NewRow = ResultTable.Add();
					FillPropertyValues(NewRow, ResRow);
					NewRow["Value" + (i + 1)] = Value.ValueRef;
					NewRow["DoNotControl" + (i + 1)] = Value.DoNotControl;
				EndDo;
			Else
				NewRow = ResultTable.Add();
				NewRow["Value" + (i + 1)] = Value.ValueRef;
				NewRow["DoNotControl" + (i + 1)] = Value.DoNotControl;
			EndIf;
		EndDo;
	EndDo;
	
	For Each Row In ResultTable Do
		Reg = InformationRegisters.T9101A_ObjectAccessRegisters.CreateRecordManager();
		FillPropertyValues(Reg, Row);
		Reg.AccessGroup = ThisObject.Ref;
		Reg.TableName = RegInfo.FullName();
		Reg.UUID = String(New UUID);
		Reg.Write();
	EndDo;
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure