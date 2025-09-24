#Region AccessObject

// Get access key.
// See Role.TemplateAccumulationRegisters - Parameters orders has to be the same
// 
// Returns:
//  Structure - Get access key:
Function GetAccessKey() Export
	AccessKeyStructure = New Structure;
	Return AccessKeyStructure;
EndFunction

#EndRegion

Procedure AdditionalDataFilling(MovementsValueTable) Export
	Return;
EndProcedure

Function CheckBalance(Ref, ItemList_InDocument, Records_InDocument, Records_Exists, RecordType, Unposting, AddInfo = Undefined) Export
	If CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "UnitTest", False) Then
		Return True;
	EndIf;

	Return True;
EndFunction