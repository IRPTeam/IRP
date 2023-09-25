// @strict-types

// Save data package.
// 
// Parameters:
//  DataPackage - Array of AnyRef - Data package
Procedure SaveDataPackage(DataPackage) Export
	
	If DataPackage.Count() = 0 Then
		Return;
	EndIf;
	
	PackageID = New UUID();
	CreationDate = CurrentSessionDate();
	Author = SessionParameters.CurrentUser;
	
	For Each DataRef In DataPackage Do
		If Not ValueIsFilled(DataRef) Then
			Continue;
		EndIf;
		
		NewRecord = InformationRegisters.DataVersions.CreateRecordManager();
		NewRecord.DataRef = DataRef;
		NewRecord.PackageID = PackageID;
		NewRecord.Author = Author;
		NewRecord.Created = CreationDate;
		
		NewRecord.Data = New ValueStorage(getDataDescription(DataRef), New Deflation(9));
		NewRecord.Write();
	EndDo;
	
EndProcedure

// Get data description.
// 
// Parameters:
//  DataRef - AnyRef - Data ref
// 
// Returns:
//  Structure - data description:
// * Ref - AnyRef -
// * Content - String -
// * RegisterRecords - Array of Structure -:
// 	** Name - String -
// 	** Content - String -
Function getDataDescription(DataRef)
	
	Result = New Structure;
	Result.Insert("Ref", DataRef);
	Result.Insert("Content", "");
	
	RegisterRecords = New Array; // Array of Structure
	Result.Insert("RegisterRecords", RegisterRecords);
	
	DataObject = DataRef.GetObject();
	If Not DataObject = Undefined Then
		Result.Content = CommonFunctionsServer.SerializeXML(DataObject);
		DataMetadata = DataRef.Metadata();
		If Metadata.Documents.Contains(DataMetadata) Then
			For Each RegisterRecord In DataObject.RegisterRecords Do
				RegisterRecord.Read();
				If RegisterRecord.Count() > 0 Then
					RegisterData = New Structure;
					RegisterData.Insert("Name", RegisterRecord.Metadata().Name);
					RegisterData.Insert("Content", CommonFunctionsServer.SerializeXML(RegisterRecord));
					Result.RegisterRecords.Add(RegisterData);
				EndIf;
			EndDo;
		EndIf;
	EndIf;
	
	Return Result;
	
EndFunction