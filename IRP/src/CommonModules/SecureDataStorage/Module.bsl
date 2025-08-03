// @strict-types

#Region Public

// Palce holder.
// 
// Returns:
//  String - Palce holder
Function PalceHolder() Export
	Return "Stored in secure storage";
EndFunction

// Set.
// 
// Parameters:
//  Owner - See InformationRegister.SecureDataStorage.Owner
//  Data - Structure - Data
Procedure Set(Owner, Data) Export
	If Not TypeOf(Data) = Type("Structure") Then
		//@skip-check property-return-type
		Raise R().SecureStorage_CanStoreOnlyStructure;		
	EndIf;
	SetData(Owner, Data);
EndProcedure

// Add.
// 
// Parameters:
//  Owner - See InformationRegister.SecureDataStorage.Owner
//  Key - String - Key
//  Value - Arbitrary - Value to store
Procedure Add(Owner, Key, Value) Export
	
	If Value = PalceHolder() Then
		Return;
	EndIf;
	
	CurrentData = GetData(Owner);
	If CurrentData = Undefined Then
		CurrentData = New Structure;
	EndIf;
	
	CurrentData.Insert(Key, Value);
	SetData(Owner, CurrentData);
EndProcedure

// Get.
// 
// Parameters:
//  Owner - See InformationRegister.SecureDataStorage.Owner
// 
// Returns:
//  Undefined, Structure - Get
Function Get(Owner) Export
	Return GetData(Owner);
EndFunction

// Get key.
// 
// Parameters:
//  Owner - See InformationRegister.SecureDataStorage.Owner
//  Key - String - Key to find
// 
// Returns:
//  Undefined, Arbitrary - Found value or Undefined if not found
Function GetKey(Owner, Key) Export
	CurrentData = GetData(Owner);
	If CurrentData = Undefined Then
		Return Undefined;
	EndIf;
	
	If CurrentData.Property(Key) Then
		Return CurrentData[Key];
	EndIf;
	
	Return Undefined;
EndFunction

// Delete.
// 
// Parameters:
//  Owner - See InformationRegister.SecureDataStorage.Owner
Procedure Delete(Owner) Export
	Record = InformationRegisters.SecureDataStorage.CreateRecordManager();
	Record.Owner = Owner;
	Record.Delete();
EndProcedure

// Delete key.
// 
// Parameters:
//  Owner - See InformationRegister.SecureDataStorage.Owner
//  Key - String - Key to delete
Procedure DeleteKey(Owner, Key) Export
	CurrentData = GetData(Owner);
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	If CurrentData.Property(Key) Then
		CurrentData.Delete(Key);
		SetData(Owner, CurrentData);
	EndIf;
EndProcedure

// Has key.
// 
// Parameters:
//  Owner - See InformationRegister.SecureDataStorage.Owner
//  Key - String - Key to check
// 
// Returns:
//  Boolean - True if key exists
Function HasKey(Owner, Key) Export
	CurrentData = GetData(Owner);
	If CurrentData = Undefined Then
		Return False;
	EndIf;
	
	Return CurrentData.Property(Key);
EndFunction

#EndRegion

#Region Service
// Set data.
// 
// Parameters:
//  Owner - See InformationRegister.SecureDataStorage.Owner
//  Data - Structure - Data
Procedure SetData(Owner, Data)
	Record = InformationRegisters.SecureDataStorage.CreateRecordManager();
	Record.Owner = Owner;
	Record.Data = New ValueStorage(Data);
	Record.Write();	
EndProcedure

// Get data.
// 
// Parameters:
//  Owner - See InformationRegister.SecureDataStorage.Owner
// 
// Returns:
//  Undefined, Structure - Get data
Function GetData(Owner)
	Query = New Query;
	Query.Text =
		"SELECT
		|	SecureDataStorage.Data AS Data
		|FROM
		|	InformationRegister.SecureDataStorage AS SecureDataStorage
		|WHERE
		|	SecureDataStorage.Owner = &Owner";
	
	Query.SetParameter("Owner", Owner);
	
	QueryResult = Query.Execute();
	
	SelectionDetailRecords = QueryResult.Select();
	
	While SelectionDetailRecords.Next() Do
		//@skip-check property-return-type, dynamic-access-method-not-found
		Return SelectionDetailRecords.Data.Get();
	EndDo;
	Return Undefined;
EndFunction

#EndRegion