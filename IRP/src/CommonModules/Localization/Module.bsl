// @strict-types

// Strings.
// 
// Parameters:
//  Lang - String - Lang
// 
// Returns:
//  Structure -  Strings:
// * ACS_UnknownValueType - String - 
// * CERT_OnlyProdOrCert - String - 
// * CERT_CertAlreadyUsed - String - 
// * CERT_CannotBeSold - String - 
// * CERT_HasNotBeenUsed - String - 
// * EmailIsEmpty - String - 
// * Only1SymbolAtCanBeSet - String - 
// * InvalidLengthOfLocalPart - String - 
// * InvalidLengthOfDomainPart - String - 
// * LocalPartStartEndDot - String - 
// * LocalPartConsecutiveDots - String - 
// * DomainPartStartsWithDot - String - 
// * DomainPartConsecutiveDots - String - 
// * DomainPartMin1Dot - String - 
// * DomainIdentifierExceedsLength - String - 
// * InvalidCharacterInAddress - String - 
// * SMS_SendIsOk - String - 
// * SMS_SendIsError - String - 
// * SMS_WaitUntilNextSend - String - 
// * SMS_SMSCodeWrong - String - 
// * ATC_001 - String - 
// * ATC_ErrorTaxAmountInItemListNotEqualTaxAmountInTaxList - String - 
// * ATC_ErrorNetAmountGreaterTotalAmount - String - 
// * ATC_ErrorQuantityIsZero - String - 
// * ATC_ErrorQuantityInBaseUnitIsZero - String - 
// * ATC_ErrorOffersAmountInItemListNotEqualOffersAmountInOffersList - String - 
// * ATC_ErrorItemTypeIsNotService - String - 
// * ATC_ErrorItemTypeUseSerialNumbers - String - 
// * ATC_ErrorUseSerialButSerialNotSet - String - 
// * ATC_ErrorNotTheSameQuantityInSerialListTableAndInItemList - String - 
// * ATC_ErrorItemNotEqualItemInItemKey - String - 
// * ATC_ErrorTotalAmountMinusNetAmountNotEqualTaxAmount - String - 
// * ATC_ErrorQuantityInItemListNotEqualQuantityInRowID - String - 
// * ATC_ErrorQuantityNotEqualQuantityInBaseUnit - String - 
// * ATC_ErrorNotFilledQuantityInSourceOfOrigins - String - 
// * ATC_ErrorQuantityInSourceOfOriginsDiffQuantityInSerialLotNumber - String - 
// * ATC_ErrorQuantityInSourceOfOriginsDiffQuantityInItemList - String - 
// * ATC_ErrorNotFilledUnit - String - 
// * Eq_001 - String - 
// * Eq_002 - String - 
// * Eq_003 - String - 
// * Eq_004 - String - 
// * Eq_005 - String - 
// * Eq_006 - String - 
// * Eq_007 - String - 
// * Eq_008 - String - 
// * Eq_009 - String - 
// * Eq_010 - String - 
// * Eq_011 - String - 
// * Eq_012 - String - 
// * Eq_CanNotFindAPIModule - String - 
// * EqError_001 - String - 
// * EqError_002 - String - 
// * EqError_003 - String - 
// * EqError_004 - String - 
// * EqError_005 - String - 
// * EqFP_ShiftAlreadyOpened - String - 
// * EqFP_ShiftIsNotOpened - String - 
// * EqFP_ShiftAlreadyClosed - String - 
// * EqFP_DocumentAlreadyPrinted - String - 
// * EqFP_DocumentNotPrintedOnFiscal - String - 
// * EqFP_FiscalDeviceIsEmpty - String - 
// * EqAc_AlreadyhasTransaction - String - 
// * EqAc_LastSettlementHasError - String - 
// * EqAc_LastSettlementNotFound - String - 
// * EqAc_NotAllPaymentDone - String - 
// * EqFP_CanNotOpenSessionRegistrationKM - String - 
// * EqFP_CanNotRequestKM - String - 
// * EqFP_CanNotGetProcessingKMResult - String - 
// * EqFP_CanNotCloseSessionRegistrationKM - String - 
// * EqFP_GetWrongAnswerFromProcessingKM - String - 
// * EqFP_ScanedCodeStringAlreadyExists - String - 
// * EqFP_ProblemWhileCheckCodeString - String - 
// * EqFP_ErrorWhileConfirmCode - String - 
// * EqFP_CashierNameCanNotBeEmpty - String - 
// * POS_s1 - String - 
// * POS_s2 - String - 
// * POS_s3 - String - 
// * POS_s4 - String - 
// * POS_s5 - String - 
// * POS_s6 - String - 
// * POS_Error_ErrorOnClosePayment - String - 
// * POS_Error_ErrorOnPayment - String - 
// * POS_Error_CancelPayment - String - 
// * POS_Error_CancelPaymentProblem - String - 
// * POS_Error_ReturnAmountLess - String - 
// * POS_Error_CannotFindUser - String - 
// * POS_Error_ThisBarcodeFromAnotherItem - String - 
// * POS_Error_ThisIsNotControleStringBarcode - String - 
// * POS_Error_CheckFillingForAllCodes - String - 
// * S_002 - String - 
// * S_003 - String - 
// * S_004 - String - 
// * S_005 - String - 
// * S_006 - String - 
// * S_013 - String - 
// * S_014 - String - 
// * S_015 - String - 
// * S_016 - String - 
// * S_018 - String - 
// * S_019 - String - 
// * S_022 - String - 
// * S_023 - String - 
// * S_026 - String - 
// * S_027 - String - 
// * S_028 - String - 
// * S_029 - String - 
// * S_030 - String - 
// * S_031 - String - 
// * S_032 - String - 
// * Form_001 - String - 
// * Form_002 - String - 
// * Form_003 - String - 
// * Form_004 - String - 
// * Form_005 - String - 
// * Form_006 - String - 
// * Form_007 - String - 
// * Form_008 - String - 
// * Form_009 - String - 
// * Form_013 - String - 
// * Form_014 - String - 
// * Form_017 - String - 
// * Form_018 - String - 
// * Form_019 - String - 
// * Form_022 - String - 
// * Form_023 - String - 
// * Form_024 - String - 
// * Form_025 - String - 
// * Form_026 - String - 
// * Form_027 - String - 
// * Form_028 - String - 
// * Form_029 - String - 
// * Form_030 - String - 
// * Form_031 - String - 
// * Form_032 - String - 
// * Form_033 - String - 
// * Form_034 - String - 
// * Form_035 - String - 
// * Form_036 - String - 
// * Form_037 - String - 
// * Form_038 - String - 
// * Error_002 - String - 
// * Error_003 - String - 
// * Error_004 - String - 
// * Error_005 - String - 
// * Error_008 - String - 
// * Error_009 - String - 
// * Error_010 - String - 
// * Error_011 - String - 
// * Error_012 - String - 
// * Error_013 - String - 
// * Error_014 - String - 
// * Error_015 - String - 
// * Error_016 - String - 
// * Error_017 - String - 
// * Error_018 - String - 
// * Error_019 - String - 
// * Error_020 - String - 
// * Error_021 - String - 
// * Error_023 - String - 
// * Error_028 - String - 
// * Error_030 - String - 
// * Error_031 - String - 
// * Error_032 - String - 
// * Error_033 - String - 
// * Error_034 - String - 
// * Error_035 - String - 
// * Error_037 - String - 
// * Error_040 - String - 
// * Error_041 - String - 
// * Error_042 - String - 
// * Error_043 - String - 
// * Error_044 - String - 
// * Error_045 - String - 
// * Error_047 - String - 
// * Error_049 - String - 
// * Error_050 - String - 
// * Error_051 - String - 
// * Error_052 - String - 
// * Error_053 - String - 
// * Error_054 - String - 
// * Error_055 - String - 
// * Error_056 - String - 
// * Error_057 - String - 
// * Error_058 - String - 
// * Error_059 - String - 
// * Error_060 - String - 
// * Error_064 - String - 
// * Error_065 - String - 
// * Error_066 - String - 
// * Error_067 - String - 
// * Error_068 - String - 
// * Error_068_2 - String - 
// * Error_069 - String - 
// * Error_069_2 - String - 
// * Error_071 - String - 
// * Error_072 - String - 
// * Error_073 - String - 
// * Error_074 - String - 
// * Error_075 - String - 
// * Error_077 - String - 
// * Error_078 - String - 
// * Error_079 - String - 
// * Error_080 - String - 
// * Error_081 - String - 
// * Error_082 - String - 
// * Error_083 - String - 
// * Error_085 - String - 
// * Error_086 - String - 
// * Error_087 - String - 
// * Error_088 - String - 
// * Error_089 - String - 
// * Error_090 - String - 
// * Error_090_2 - String - 
// * Error_091 - String - 
// * Error_092 - String - 
// * Error_093 - String - 
// * Error_094 - String - 
// * Error_095 - String - 
// * Error_096 - String - 
// * Error_097 - String - 
// * Error_098 - String - 
// * Error_099 - String - 
// * Error_100 - String - 
// * Error_101 - String - 
// * Error_102 - String - 
// * Error_103 - String - 
// * Error_104 - String - 
// * Error_105 - String - 
// * Error_106 - String - 
// * Error_107 - String - 
// * Error_108 - String - 
// * Error_109 - String - 
// * Error_110 - String - 
// * Error_111 - String - 
// * Error_112 - String - 
// * Error_113 - String - 
// * Error_114 - String - 
// * Error_115 - String - 
// * Error_116 - String - 
// * Error_117 - String - 
// * Error_118 - String - 
// * Error_119 - String - 
// * Error_120 - String - 
// * Error_121 - String - 
// * Error_122 - String - 
// * Error_123 - String - 
// * Error_124 - String - 
// * Error_125 - String - 
// * Error_126 - String - 
// * Error_127 - String - 
// * Error_128 - String - 
// * Error_144 - String - 
// * Error_145 - String - 
// * Error_FillTotalAmount - String - 
// * MF_Error_001 - String - 
// * MF_Error_002 - String - 
// * MF_Error_003 - String - 
// * MF_Error_004 - String - 
// * MF_Error_005 - String - 
// * MF_Error_006 - String - 
// * MF_Error_007 - String - 
// * MF_Error_008 - String - 
// * MF_Error_009 - String - 
// * MF_Error_010 - String - 
// * Error_ChangeAttribute_RelatedDocsExist - String - 
// * Error_AttributeDontMatchValueFromBasisDoc - String - 
// * Error_AttributeDontMatchValueFromBasisDoc_Row - String - 
// * Error_Store_Company - String - 
// * Error_Store_Company_Row - String - 
// * Error_MaximumAccessKey - String - 
// * LC_Error_001 - String - 
// * LC_Error_002 - String - 
// * LC_Error_003 - String - 
// * InfoMessage_001 - String - 
// * InfoMessage_002 - String - 
// * InfoMessage_003 - String - 
// * InfoMessage_004 - String - 
// * InfoMessage_005 - String - 
// * InfoMessage_006 - String - 
// * InfoMessage_007 - String - 
// * InfoMessage_008 - String - 
// * InfoMessage_009 - String - 
// * InfoMessage_010 - String - 
// * InfoMessage_011 - String - 
// * InfoMessage_012 - String - 
// * InfoMessage_013 - String - 
// * InfoMessage_014 - String - 
// * InfoMessage_015 - String - 
// * InfoMessage_016 - String - 
// * InfoMessage_017 - String - 
// * InfoMessage_018 - String - 
// * InfoMessage_019 - String - 
// * InfoMessage_020 - String - 
// * InfoMessage_021 - String - 
// * InfoMessage_022 - String - 
// * InfoMessage_023 - String - 
// * InfoMessage_024 - String - 
// * InfoMessage_025 - String - 
// * InfoMessage_026 - String - 
// * InfoMessage_027 - String - 
// * InfoMessage_028 - String - 
// * InfoMessage_029 - String - 
// * InfoMessage_030 - String - 
// * InfoMessage_031 - String - 
// * InfoMessage_032 - String - 
// * InfoMessage_033 - String - 
// * InfoMessage_034 - String - 
// * InfoMessage_035 - String - 
// * InfoMessage_036 - String - 
// * InfoMessage_037 - String - 
// * InfoMessage_Payment - String - 
// * InfoMessage_PaymentReturn - String - 
// * InfoMessage_SessionIsClosed - String - 
// * InfoMessage_Sales - String - 
// * InfoMessage_Returns - String - 
// * InfoMessage_ReturnTitle - String - 
// * InfoMessage_POS_Title - String - 
// * InfoMessage_NotProperty - String - 
// * InfoMessage_DataUpdated - String - 
// * InfoMessage_DataSaved - String - 
// * InfoMessage_SettingsApplied - String - 
// * InfoMessage_ImportError - String - 
// * QuestionToUser_001 - String - 
// * QuestionToUser_002 - String - 
// * QuestionToUser_003 - String - 
// * QuestionToUser_004 - String - 
// * QuestionToUser_005 - String - 
// * QuestionToUser_006 - String - 
// * QuestionToUser_007 - String - 
// * QuestionToUser_008 - String - 
// * QuestionToUser_009 - String - 
// * QuestionToUser_011 - String - 
// * QuestionToUser_012 - String - 
// * QuestionToUser_013 - String - 
// * QuestionToUser_014 - String - 
// * QuestionToUser_015 - String - 
// * QuestionToUser_016 - String - 
// * QuestionToUser_017 - String - 
// * QuestionToUser_018 - String - 
// * QuestionToUser_019 - String - 
// * QuestionToUser_020 - String - 
// * QuestionToUser_021 - String - 
// * QuestionToUser_022 - String - 
// * QuestionToUser_023 - String - 
// * QuestionToUser_024 - String - 
// * QuestionToUser_025 - String - 
// * QuestionToUser_026 - String - 
// * SuggestionToUser_1 - String - 
// * SuggestionToUser_2 - String - 
// * SuggestionToUser_3 - String - 
// * SuggestionToUser_4 - String - 
// * UsersEvent_001 - String - 
// * UsersEvent_002 - String - 
// * I_1 - String - 
// * I_2 - String - 
// * I_3 - String - 
// * I_4 - String - 
// * I_5 - String - 
// * I_6 - String - 
// * I_7 - String - 
// * I_8 - String - 
// * Exc_001 - String - 
// * Exc_002 - String - 
// * Exc_003 - String - 
// * Exc_004 - String - 
// * Exc_005 - String - 
// * Exc_006 - String - 
// * Exc_007 - String - 
// * Exc_008 - String - 
// * Exc_009 - String - 
// * Exc_010 - String - 
// * Exc_011 - String - 
// * Exc_012 - String - 
// * Saas_001 - String - 
// * Saas_002 - String - 
// * Saas_003 - String - 
// * Saas_004 - String - 
// * Class_001 - String - 
// * Class_002 - String - 
// * Class_003 - String - 
// * Class_004 - String - 
// * Class_005 - String - 
// * Class_006 - String - 
// * Class_007 - String - 
// * Class_008 - String - 
// * Title_00100 - String - 
// * CLV_1 - String - 
// * CLV_2 - String - 
// * SOR_1 - String - 
// * R_001 - String - 
// * R_002 - String - 
// * R_003 - String - 
// * R_004 - String - 
// * Default_001 - String - 
// * Default_002 - String - 
// * Default_003 - String - 
// * Default_004 - String - 
// * Default_005 - String - 
// * Default_006 - String - 
// * Default_007 - String - 
// * Default_008 - String - 
// * Default_009 - String - 
// * Default_010 - String - 
// * Default_011 - String - 
// * Default_012 - String - 
// * Str_Catalog - String - 
// * Str_Catalogs - String - 
// * Str_Document - String - 
// * Str_Documents - String - 
// * Str_Code - String - 
// * Str_Description - String - 
// * Str_Parent - String - 
// * Str_Owner - String - 
// * Str_DeletionMark - String - 
// * Str_Number - String - 
// * Str_Date - String - 
// * Str_Posted - String - 
// * Str_InformationRegister - String - 
// * Str_InformationRegisters - String - 
// * Str_AccumulationRegister - String - 
// * Str_AccumulationRegisters - String - 
// * Add_Setiings_001 - String - 
// * Add_Setiings_002 - String - 
// * Add_Setiings_003 - String - 
// * Add_Setiings_004 - String - 
// * Add_Setiings_005 - String - 
// * Add_Setiings_006 - String - 
// * Add_Setiings_007 - String - 
// * Add_Setiings_008 - String - 
// * Mob_001 - String - 
// * CP_001 - String - 
// * CP_002 - String - 
// * CP_003 - String - 
// * CP_004 - String - 
// * CP_005 - String - 
// * CP_006 - String - 
// * LDT_Button_Title - String - 
// * LDT_Button_ToolTip - String - 
// * LDT_FailReading - String - 
// * LDT_ValueNotFound - String - 
// * LDT_TooMuchFound - String - 
// * OpenSLNTree_Button_Title - String - 
// * OpenSLNTree_Button_ToolTip - String - 
// * BgJ_Title_001 - String - 
// * BgJ_Title_002 - String - 
// * InternalCommands_SetNotActive - String -
// * InternalCommands_SetNotActive_Check - String -
// * InternalCommands_ShowNotActive - String -
// * InternalCommands_ShowNotActive_Check - String -
// * GPU_AnalizeFolder - String -
// * GPU_Load_SendToDrive - String -
// * GPU_Load_SaveInBase - String -
// * GPU_CheckingFilesExist - String -
Function Strings(Lang) Export

	Strings = New Structure();

#Region Access
	Strings.Insert("ACS_UnknownValueType", NStr("en='B2FD40A5-6AEB-720F-F57B-B5C7495847E3__________'", Lang));
#EndRegion

#Region Certificates
	
	Strings.Insert("CERT_OnlyProdOrCert", NStr("en='B23AEC17-DC42-3AE7-76EF-F74CE2DD0F01_______________________'", Lang));
	Strings.Insert("CERT_CertAlreadyUsed", NStr("en='7F831318-FA37-23EA-ABE2-26ED72964559_________________________________%1'", Lang));
	Strings.Insert("CERT_CannotBeSold", NStr("en='084A8C57-248A-E7E4-4DE4-4CAA5FAAEB4E__%1'", Lang));
	Strings.Insert("CERT_HasNotBeenUsed", NStr("en='FF5A2F03-D7D1-F4D3-3142-2193E0BC26B9____%1'", Lang));

#EndRegion

#Region Validation

	Strings.Insert("EmailIsEmpty", NStr("en='FC6A7415-2AA7-0FDD-D7A1-109058F2A6B6'", Lang));
	Strings.Insert("Only1SymbolAtCanBeSet", NStr("en='3734B0E2-96B7-52C3-3627-7A9BADA0E767'", Lang));
	Strings.Insert("InvalidLengthOfLocalPart", NStr("en='48D49EC6-1491-7427-72B8-8CB1F26E7219'", Lang));
	Strings.Insert("InvalidLengthOfDomainPart", NStr("en='25D6B8B0-AAF3-9639-9100-0E320B44B308'", Lang));
	Strings.Insert("LocalPartStartEndDot", NStr("en='CA19202D-5312-73E1-1F20-07FD0BE5DDB9______________'", Lang));
	Strings.Insert("LocalPartConsecutiveDots", NStr("en='02189676-4D20-A250-06CD-D56C2A45C425_'", Lang));
	Strings.Insert("DomainPartStartsWithDot", NStr("en='97C7F736-1D34-DD66-6FD5-5812B519A23C'", Lang));
	Strings.Insert("DomainPartConsecutiveDots", NStr("en='3A8D2C70-C1D5-4B90-0AF7-7690DCEDB1AB__'", Lang));
	Strings.Insert("DomainPartMin1Dot", NStr("en='F7B52324-4259-AFAC-C331-1F369E0F22D4______'", Lang));
	Strings.Insert("DomainIdentifierExceedsLength", NStr("en='75F3EAF3-EA2D-3291-125E-E75CADA882C1_________'", Lang));
	Strings.Insert("InvalidCharacterInAddress", NStr("en='BED10CF7-8B1F-B93C-C92D-D6CC4B75B1F4%1'", Lang));
	Strings.Insert("AddAttributeCannotUseWithProperty", NStr("en='4DB3A879-E19A-046C-C2C2-2FEF2D814EC9_________________________%1'", Lang));
	Strings.Insert("AddAttributeTagPathHasNotTwoPart", NStr("en='A26D5B9B-58AF-9F37-716C-CEB206E62C09___________________________________________________________________%1'", Lang));

#EndRegion

#Region SMS
	Strings.Insert("SMS_SendIsOk", NStr("en='DD77B758-A86A-0CAE-EE53-31CE699BB1D8'", Lang));
	Strings.Insert("SMS_SendIsError", NStr("en='1AA01DBD-B625-E81E-EE95-5E1E66F9CEC1'", Lang));
	Strings.Insert("SMS_WaitUntilNextSend", NStr("en='CB532443-C98B-A99A-A19D-DAACA093B226%1'", Lang));
	Strings.Insert("SMS_SMSCodeWrong", NStr("en='22332D2D-8E98-007C-C167-715E712928D7'", Lang));
#EndRegion

#Region AdditionalTableControl

	Strings.Insert("ATC_001", NStr("en='42FC6FF7-49DB-39C6-67BE-EBF72DE0ABD0%1'", Lang));
	Strings.Insert("ATC_NotSupported", NStr("en='584D5AE1-AC8F-4ABA-A111-16420ED2010F________________'", Lang));
	
	Strings.Insert("ATC_ErrorTaxAmountInItemListNotEqualTaxAmountInTaxList", NStr("en='FEEAFB9D-5E25-B767-7B8B-B93BDB23AC77___________________________________%1'", Lang));
	Strings.Insert("ATC_ErrorNetAmountGreaterTotalAmount", NStr("en='9D76B365-C68E-4E6D-DDD2-258CD0344415____________%1'", Lang));
	Strings.Insert("ATC_ErrorQuantityIsZero", NStr("en='9B407B95-9C8F-65EC-C301-184B63E55437%1'", Lang));
	Strings.Insert("ATC_ErrorQuantityInBaseUnitIsZero", NStr("en='057122C8-551B-C31B-BA38-8A5BB77060D1__%1'", Lang));
	Strings.Insert("ATC_ErrorOffersAmountInItemListNotEqualOffersAmountInOffersList", NStr("en='EAA5BDB8-EC60-64CB-BF74-4F6DF80DB319____________________________________________%1'", Lang));
	Strings.Insert("ATC_ErrorItemTypeIsNotService", NStr("en='8F1CB26A-9C56-54FE-EBE2-27E960BC1C21%1'", Lang));
	Strings.Insert("ATC_ErrorItemTypeUseSerialNumbers", NStr("en='0FBB3D76-E065-26F7-7A5D-D227478F4BAD__%1'", Lang));
	Strings.Insert("ATC_ErrorItemTypeNotUseSerialNumbers", NStr("en='A1FE476E-420B-A9AC-C2E1-1741754C5DC8__________%1'", Lang));
	Strings.Insert("ATC_ErrorUseSerialButSerialNotSet", NStr("en='856BA5AA-6D90-0B96-6A59-92F75DD4D876______%1'", Lang));
	Strings.Insert("ATC_ErrorNotTheSameQuantityInSerialListTableAndInItemList", NStr("en='9251745D-FF57-9F11-1B99-9A02E7868587___________________________________________%1'", Lang));
	Strings.Insert("ATC_ErrorItemNotEqualItemInItemKey", NStr("en='8A49E8E9-C099-30D5-5AD3-311629121D5F__________%1'", Lang));
	Strings.Insert("ATC_ErrorTotalAmountMinusNetAmountNotEqualTaxAmount", NStr("en='64650178-A40E-4401-1ED2-251D2C9D497D_____________________________%1'", Lang));
	Strings.Insert("ATC_ErrorQuantityInItemListNotEqualQuantityInRowID", NStr("en='17C7862D-B39C-ED92-2DCB-B9DFB39EFCDC_____________________________%1'", Lang));
	Strings.Insert("ATC_ErrorQuantityNotEqualQuantityInBaseUnit", NStr("en='C82EFA88-4123-3416-689E-E631D06A1B65________________________________________%1'", Lang));
	Strings.Insert("ATC_ErrorNotFilledQuantityInSourceOfOrigins", NStr("en='291B2810-BA90-1925-570B-BBE768F3C5EA_____________%1'", Lang));
	Strings.Insert("ATC_ErrorQuantityInSourceOfOriginsDiffQuantityInSerialLotNumber", NStr("en='055BED30-ED80-C1BA-A52B-B01C69029AD9_____________________________________%1'", Lang));
	Strings.Insert("ATC_ErrorQuantityInSourceOfOriginsDiffQuantityInItemList", NStr("en='B9322415-54A8-0AAD-D36D-DC7FA87D13A4_____________________________%1'", Lang));
	Strings.Insert("ATC_ErrorNotFilledUnit", NStr("en='275C8DBD-0BD7-9DB6-64F8-8D8FEDE50D1D%1'", Lang));
	Strings.Insert("ATC_ErrorNotFilledInventoryOrigin", NStr("en='A71D2A72-3793-DA94-474D-D05475E5D975%1'", Lang));
	Strings.Insert("ATC_ErrorPaymentsAmountIsZero", NStr("en='D84987A2-7BEA-88FB-B387-737EE5A9B21F%1'", Lang));
	
	Strings.Insert("ATC_ErrorNotFilledPaymentMethod", NStr("en='B068BDD0-9333-2ED3-3651-1463739FF167'", Lang));
	Strings.Insert("ATC_ErrorNotFilledPurchaseTransactionType", NStr("en='DDEF1085-5918-1EC1-16BE-E7561881954A___'", Lang));
	Strings.Insert("ATC_ErrorNotFilledSalesTransactionType", NStr("en='74AF0879-8F34-663B-B3B8-84565F5E7D58'", Lang));
	Strings.Insert("ATC_ErrorNotFilledSalesReturnTransactionType", NStr("en='CCD54348-ECCC-1EDC-CA08-800481426794______'", Lang));
	Strings.Insert("ATC_ErrorNotFilledPurchaseReturnTransactionType", NStr("en='54232D7F-E925-0F01-1408-8F75C192EE7C__________'", Lang));
	
	Strings.Insert("ATC_FIX_ErrorItemTypeUseSerialNumbers", NStr("en='FFD0B625-B7A1-C2B1-18D9-9D829EE85CBC_______________________'", Lang));
	Strings.Insert("ATC_FIX_ErrorItemTypeNotUseSerialNumbers", NStr("en='F9454638-E202-29F9-990A-A5689F8E2E74__________________________'", Lang));
	Strings.Insert("ATC_FIX_ErrorNotFilledQuantityInSourceOfOrigins", NStr("en='C0454772-AD58-3F15-58B5-5D2706D75395______________________________________________________________'", Lang));
	Strings.Insert("ATC_FIX_ErrorNotFilledInventoryOrigin", NStr("en='DA110687-7099-DBC6-6F23-319ED2FC6727______________'", Lang));
	Strings.Insert("ATC_FIX_ErrorNotFilledPaymentMethod", NStr("en='09A3D0B0-B15A-717C-C396-62819ACF56ED____________________'", Lang));
	Strings.Insert("ATC_FIX_ErrorNotFilledPurchaseTransactionType", NStr("en='6230A8A5-A04B-D7BF-FCDD-D0E2B2CB0F0C____________'", Lang));
	Strings.Insert("ATC_FIX_ErrorNotFilledSalesTransactionType", NStr("en='AD8B0153-8D6E-EBC1-19ED-D84481558AEA_________'", Lang));
	Strings.Insert("ATC_FIX_ErrorNotFilledSalesReturnTransactionType", NStr("en='5B5F9EC0-7C09-A634-4BC0-00B6687D86EF________________________'", Lang));
	Strings.Insert("ATC_FIX_ErrorNotFilledPurchaseReturnTransactionType", NStr("en='AA9B23AA-06AB-1241-193B-BFA73B1C1123____________________'", Lang));
	
#EndRegion

#Region Equipment
	Strings.Insert("Eq_001", NStr("en='2ACBE9CB-918E-5CA4-4B54-448D14B89456'", Lang));
	Strings.Insert("Eq_002", NStr("en='F1E13A8D-2ED8-ADC2-2374-402EFA2B3E5B'", Lang));
	Strings.Insert("Eq_003", NStr("en='08EDF311-D69B-6D9B-B217-7C92285099FC'", Lang));
	Strings.Insert("Eq_004", NStr("en='7D2B329C-8AA3-DF71-10D2-2CDA601B061B%1'", Lang));
	Strings.Insert("Eq_005", NStr("en='DD1E860D-7E1A-A7E9-9536-61058CFACAE9%1'", Lang));
	Strings.Insert("Eq_006", NStr("en='63274FFF-2508-818E-E2F8-8E41BB4B8192'", Lang));
	Strings.Insert("Eq_007", NStr("en='AFA3F338-0134-F0FA-AB5B-B0CEBC5F1D51%1'", Lang));
	Strings.Insert("Eq_008", NStr("en='C58D3B33-8154-F8E0-07CB-B9F825FF31AF%1'", Lang));
	Strings.Insert("Eq_009", NStr("en='D47C4F42-DA99-23D1-1623-3C059C2AF1A5%1'", Lang));
	Strings.Insert("Eq_010", NStr("en='C978511E-9B6A-4EB7-707F-F9861E96AE5A%1'", Lang));
	Strings.Insert("Eq_011", NStr("en='5A05005B-7B64-4B83-3EF8-823A97925AED'", Lang));
	Strings.Insert("Eq_012", NStr("en='E71553E5-C90C-E9BA-AD83-3367FA21DDF7'", Lang));
	Strings.Insert("Eq_013", NStr("en='2FA97482-F29D-1CB2-264C-C504F86545D0'", Lang));
	Strings.Insert("Eq_CanNotFindAPIModule", NStr("en='60CB1618-7F7F-2207-7FCF-FB65FC5A1B9F_____________________________'", Lang));
	
	Strings.Insert("EqError_001", NStr("en='12AF2C44-1C6C-67F9-9662-2B9957D8A02B______________________________________'", Lang));

	Strings.Insert("EqError_002", NStr("en='BDB6874B-4FED-EAC0-0FEA-A8A16F1FA39D______
		|_________________________________________________________________________'",
		Lang));

	Strings.Insert("EqError_003", NStr("en='7AB8D3F6-7A36-1C4A-A2A3-3C2F5B3F7F71___'", Lang));
	Strings.Insert("EqError_004", NStr("en='CC3865AA-6A99-BD43-3620-0D8FC532E98D________'", Lang));
	Strings.Insert("EqError_005", NStr("en='68BB357C-8B23-FC0F-F8CC-C6C098F55087______________%1,%2'", Lang));
	
	Strings.Insert("EqFP_ShiftAlreadyOpened", NStr("en='891A0E4B-4FDF-E739-9FE9-9ABB43F0D481'", Lang));
	Strings.Insert("EqFP_ShiftIsNotOpened", NStr("en='5D100E28-E77D-1279-9BC6-620D085AC49F'", Lang));
	Strings.Insert("EqFP_ShiftAlreadyClosed", NStr("en='4344A774-5C8F-CA35-544E-EFACF40F229B'", Lang));
	Strings.Insert("EqFP_DocumentAlreadyPrinted", NStr("en='82EFCC2F-01DE-66D9-91D2-2A7A3F0C7F03___________________________________________________________________'", Lang));
	Strings.Insert("EqFP_DocumentNotPrintedOnFiscal", NStr("en='B8A6E2A8-93E9-7C78-87D6-699FE0D07C27________'", Lang));
	Strings.Insert("EqFP_FiscalDeviceIsEmpty", NStr("en='8E60A7CE-9055-61E5-5EF4-480975323BD5'", Lang));
	Strings.Insert("EqFP_CannotPrintNotPosted", NStr("en='0D210B61-E849-22AD-DEA5-5E735458607B'", Lang));
	Strings.Insert("EqFP_CanPrintOnlyComplete", NStr("en='0F276C36-EA6A-B062-2F05-51212FB08DA5____________'", Lang));
	
	Strings.Insert("EqAc_AlreadyhasTransaction", NStr("en='38560148-B2BF-9ADE-E1B1-1C7D9D72310D____________________________________________________________'", Lang));
	Strings.Insert("EqAc_LastSettlementHasError", NStr("en='09F34BBD-9DC6-23F0-01A5-5B8618DEBCA8_______'", Lang));
	Strings.Insert("EqAc_LastSettlementNotFound", NStr("en='A1E6197E-4820-60B5-5165-5F692F0C6C8B____________________________________________'", Lang));
	Strings.Insert("EqAc_NotAllPaymentDone", NStr("en='024F2B24-693F-4DC8-8BD6-61E60FA2FF2C'", Lang));
	
	Strings.Insert("EqFP_CanNotOpenSessionRegistrationKM", NStr("en='B206D595-734F-D1B6-6145-5F27E106F976_'", Lang));
	Strings.Insert("EqFP_CanNotRequestKM", NStr("en='027006B3-A953-C48B-BEE2-2BF65EC764F5'", Lang));
	Strings.Insert("EqFP_CanNotGetProcessingKMResult", NStr("en='A5C3A5A5-7502-6DA7-753F-FF2E59D7B255'", Lang));
	Strings.Insert("EqFP_CanNotCloseSessionRegistrationKM", NStr("en='BD929E8D-9973-B59B-B3DA-AED780A0B6A6__'", Lang));
	Strings.Insert("EqFP_GetWrongAnswerFromProcessingKM", NStr("en='7FC06814-28BC-9EB9-9FF5-518ECB48946B'", Lang));
	Strings.Insert("EqFP_ScanedCodeStringAlreadyExists", NStr("en='7234659F-83E1-AF81-16B6-67AB99C51845____________%1'", Lang));

	Strings.Insert("EqFP_ProblemWhileCheckCodeString", NStr("en='E2FF06B6-B257-8BF4-46CA-AAB7AFCB9091%1'", Lang));

	Strings.Insert("EqFP_ErrorWhileConfirmCode", NStr("en='EAAAB44F-230B-4D24-420D-DDC32BD9D564___%1'", Lang));
	Strings.Insert("EqFP_CashierNameCanNotBeEmpty", NStr("en='B89593FE-869C-63B4-46C6-661BF6A279B7__________________________________'", Lang));
	Strings.Insert("EqFP_ReceivedWrongAnswerFromDevice", NStr("en='6656A149-807A-E65C-C0A6-643ECB4335B6_____________________'", Lang));

#EndRegion

#Region POS

	Strings.Insert("POS_s1", NStr("en='C15B90DE-68AD-3EBA-AD98-8EEF3FDC0321___________'", Lang));
	Strings.Insert("POS_s2", NStr("en='F4F3AE64-CE81-7FC0-07DF-F7A5695AFDCE______________'", Lang));
	Strings.Insert("POS_s3", NStr("en='32F2458A-3533-19C4-48E8-820C070706BD________________________________'", Lang));
	Strings.Insert("POS_s4", NStr("en='C651CCA6-C776-2F3C-C2A9-9147EC84C906'", Lang));
	Strings.Insert("POS_s5", NStr("en='3456913C-3209-3E35-5C58-8C389AEE8FB6'", Lang));
	Strings.Insert("POS_s6", NStr("en='1498905F-EFE2-6C8B-B73E-E883AF4C4525'", Lang));
	
	Strings.Insert("POS_Error_ErrorOnClosePayment", NStr("en='4AEC73EC-A4B9-B492-25E5-59452547AB6B_'", Lang));
	Strings.Insert("POS_Error_ErrorOnPayment", NStr("en='AFE803CB-310F-9F66-6073-3091D38C057C____________%1'", Lang));
	Strings.Insert("POS_Error_CancelPayment", NStr("en='DBF8FB3F-6DDB-2E8A-A018-811C38772443_____________%1,%2'", Lang));
	Strings.Insert("POS_Error_CancelPaymentProblem", NStr("en='77C877D0-A442-FF36-63CD-DA5F6314BE56__________________%1,%2
		|________________________________________'", Lang));
	Strings.Insert("POS_Error_ReturnAmountLess", NStr("en='11272D29-D8D2-F144-4610-0FC7DEEEC414___________________________________________________%2,%1,%3,%4'", Lang));
	Strings.Insert("POS_Error_CannotFindUser", NStr("en='61A8FB34-BE88-965E-E5A3-3147D3A8FC30%1'", Lang));
	
	Strings.Insert("POS_Error_ThisBarcodeFromAnotherItem", NStr("en='2AA78212-76C8-B1A1-13FA-ABEDBAD23A79%1'", Lang));
	Strings.Insert("POS_Error_ThisIsNotControleStringBarcode", NStr("en='BF0B05F4-FC60-A8CB-B35E-EFF2C618CF96_________%1'", Lang));
	Strings.Insert("POS_Error_CheckFillingForAllCodes", NStr("en='214E414C-5AFF-ED94-462F-F04DE41C7080'", Lang));
	
	Strings.Insert("POS_ClearAllItems", NStr("en='C96C7BE6-0EA9-6F5F-F4C6-6B62CC38B44C'", Lang));
	Strings.Insert("POS_CancelPostponed", NStr("en='25ED6CCC-3DDF-C986-64C7-7546AE0052D9%1'", Lang));
	
	Strings.Insert("POS_ERROR_NoDeletingPrintedReceipt", NStr("en='93FE8992-26A0-BAD9-9CDF-FFA07EF3C44C_%1'", Lang));
	
	Strings.Insert("POS_Warning_Revert", NStr("en='A7D69DF5-150D-E6CA-AE55-5C52E193FA34___________________________
		|____________________________________________'", Lang));
	
	Strings.Insert("POS_Warning_ReturnInDay", NStr("en='5C1208F3-C9B4-E212-2400-09FA01D92061______________
		|____________________________________________'", Lang));
	
#EndRegion

#Region Service
	
	// %1 - localhost
	// %2 - 8080 
	// %3 - There is no internet connection
	Strings.Insert("S_002", NStr("en='98C73CFE-FE0F-F69C-C6F7-727C78259421%1,%2,%3'", Lang));
	
	// %1 - localhost
	// %2 - 8080
	Strings.Insert("S_003", NStr("en='79F8EFE1-7E8F-2C76-6A1D-D8000BA60160%1,%2'", Lang));
	Strings.Insert("S_004", NStr("en='8C65C9E2-3A01-7928-8AE1-1E2BD440332C'", Lang));
	
	// %1 - connection_to_other_system
	Strings.Insert("S_005", NStr("en='8A7F3B77-DE4D-114C-CCE0-02FBBCB31116__________%1'", Lang));
	Strings.Insert("S_006", NStr("en='F61A10D4-15D3-5E52-2CB0-093C51FEC9E0__'", Lang));
	
	// Special offers
	Strings.Insert("S_013", NStr("en='EB919343-C448-AB04-4CA5-59170E2D70E9%1'", Lang));
	
	// FileTransfer
	Strings.Insert("S_014", NStr("en='1A9E4676-663D-3ABD-D03C-C301085DBAD0'", Lang));
	Strings.Insert("S_015", NStr("en='2EBC3422-D630-9AF9-9DB8-8C57217ED72D'", Lang));
	
	// Test connection
	// %1 - Method unsupported on web client
	// %2 - 404
	// %3 - Text frim site
	Strings.Insert("S_016", NStr("en='8A6925D9-C33E-111C-CCE0-03D2919B3B22%1,%2,%3'", Lang));
	
	//	scan barcode
	Strings.Insert("S_018", NStr("en='A5E55F5C-E6A5-4CD2-2BD6-6B85CA908DD0'", Lang)); 
	
	// %1 - 123123123123
	Strings.Insert("S_019", NStr("en='FF8DA589-E0EE-573A-A632-26DD7254335D%1'", Lang));
	Strings.Insert("S_022", NStr("en='231A83D3-BA44-3BC2-2BD1-1D36072D6BC4________'", Lang));
	Strings.Insert("S_023", NStr("en='5C861201-7421-FC59-95BA-A53F5DBFCF5D'", Lang));

	Strings.Insert("S_026", NStr("en='73DE04EC-9D4E-577F-F131-11E80A3FCB02______'", Lang));

	// presentation of empty value for query result
	Strings.Insert("S_027", NStr("en='93B84AB4-8908-FB5E-E6FE-EF29DC51B661'", Lang));
	// operation is Success
	Strings.Insert("S_028", NStr("en='05DFDF96-ED3A-86C2-2113-308BD08F51E2'", Lang));
	Strings.Insert("S_029", NStr("en='D7B37F17-CC11-34E9-950A-A3CC7889BF78'", Lang));
	Strings.Insert("S_030", NStr("en='3C022A3A-8B10-D4FF-F9A6-6F1B2CA8F08C'", Lang));
	Strings.Insert("S_031", NStr("en='6D47E737-CB85-FD15-5757-7EA5E6D5C177'", Lang));
	Strings.Insert("S_032", NStr("en='93977B36-BF8B-E095-5A55-52EC29274861_______________________'", Lang));
#EndRegion

#Region Service
	Strings.Insert("Form_001", NStr("en='227B2DD1-03AA-8EA0-0130-07913DEAA02F'", Lang));
	Strings.Insert("Form_002", NStr("en='84ADEDC7-D2D9-875F-FB00-081005992A16'", Lang));
	Strings.Insert("Form_003", NStr("en='51E1E7E3-9C72-BEB1-1C62-233C85FF58E4'", Lang));
	Strings.Insert("Form_004", NStr("en='C9ACF1DE-33F5-B49A-A261-1A9CBD1A850D'", Lang));
	Strings.Insert("Form_005", NStr("en='9394DC76-A7E8-AA35-5FC6-6517717CEECF'", Lang));
	Strings.Insert("Form_006", NStr("en='B0A85FF6-4C94-A282-28AD-D851313053EA'", Lang));
	Strings.Insert("Form_007", NStr("en='CB24FD49-510A-71E3-3C26-6B092CEE53EA'", Lang));
	Strings.Insert("Form_008", NStr("en='76C447B0-C7AF-4EE9-9529-9D625A59668E'", Lang));
	Strings.Insert("Form_009", NStr("en='3C31AAC3-37C3-4A7F-FC55-5277B640ED15'", Lang));
	Strings.Insert("Form_013", NStr("en='3D008872-6735-3A1E-E347-7972676B69B3'", Lang));
	Strings.Insert("Form_014", NStr("en='DE5C20EC-29F2-7402-284B-BF659223D0EC'", Lang));
	
	// change icon
	Strings.Insert("Form_017", NStr("en='74E5F6E1-D312-680E-EFD2-2CD9FE8D3E87'", Lang));
	
	// clear icon
	Strings.Insert("Form_018", NStr("en='01A3C395-0082-6352-2C6D-DE29579D0ED6'", Lang));
	
	// cancel answer on question
	Strings.Insert("Form_019", NStr("en='DDD7EF50-72B0-BFA5-5330-0591CFF31B84'", Lang));
	
	// PriceInfo report 
	Strings.Insert("Form_022", NStr("en='5165ACC2-B401-935D-D480-00C1904631D1'", Lang));
	Strings.Insert("Form_023", NStr("en='DAA047BB-B2DE-61DC-C271-1FC693A09820'", Lang));
	Strings.Insert("Form_024", NStr("en='D6FA468B-E15B-393A-AB44-4E88EA28492D'", Lang));

	Strings.Insert("Form_025", NStr("en='AC4FAC5D-1C6A-FF08-8762-2C4DE1F2F498'", Lang));

	Strings.Insert("Form_026", NStr("en='E0AC9FCC-9D45-D0DC-C9C7-7D6C190CAF86'", Lang));
	Strings.Insert("Form_027", NStr("en='E11A9633-AAB7-9E79-9E1F-F2F41A079399'", Lang));
	Strings.Insert("Form_028", NStr("en='BD0CF784-FA96-07CD-DF4C-C8E40971F21D'", Lang));
	Strings.Insert("Form_029", NStr("en='D77E20E9-9717-F4C1-1730-0C0927F7C2F3'", Lang));
	Strings.Insert("Form_030", NStr("en='89F2DDF5-67A1-438C-CE0D-D3DA5F4FD3E7'", Lang));
	Strings.Insert("Form_031", NStr("en='BFEEFF52-20AD-AF77-7C32-23C3B5F10C45'", Lang));
	Strings.Insert("Form_032", NStr("en='E87BDF37-8430-6F7D-D38B-BF761F0A337D'", Lang));
	Strings.Insert("Form_033", NStr("en='0A9FBC58-63EA-C372-2C5E-E515D470C4D3'", Lang));
	Strings.Insert("Form_034", NStr("en='052F0577-20BB-3E49-9994-4CC5AD196A54'", Lang));
	Strings.Insert("Form_035", NStr("en='A0FC3957-8964-4C1C-CD12-2F3677D7515A'", Lang));
	Strings.Insert("Form_036", NStr("en='8AAE363D-12B2-6A31-1F7D-DDFDFDA7C195'", Lang));
	Strings.Insert("Form_037", NStr("en='001DE2EF-D30A-B295-5EC5-5095B02C988B'", Lang));
	Strings.Insert("Form_038", NStr("en='773327A1-6E49-DCE9-9CF7-73DC06D9F09F'", Lang));
	Strings.Insert("Form_039", NStr("en='8D0A7925-2616-7BA2-294A-A79D10138249__________________________________________________%1'", Lang));
#EndRegion

#Region ErrorMessages

	// %1 - en
	Strings.Insert("Error_002", NStr("en='0113D0EB-C466-2577-7BC4-44B6F56FDFF1%1'", Lang));
	Strings.Insert("Error_003", NStr("en='BA266C05-3421-D0EE-EE7A-A406CBA08DEB'", Lang));
	Strings.Insert("Error_004", NStr("en='0AC17093-CA57-8467-757E-ECD5B5FE0A5F'", Lang));
	
	// %1 - en
	Strings.Insert("Error_005", NStr("en='ED4444FA-3815-FC1A-A954-4F173D88D88F_______________%1'", Lang));
	Strings.Insert("Error_008", NStr("en='D0827563-58BE-1583-37C8-826C2C629735___'", Lang));
	
	// %1 - Number 111 is not unique
	Strings.Insert("Error_009", NStr("en='EA95834D-E092-EEEF-FA52-2933AB601FE8%1'", Lang));
	
	// %1 - Number
	Strings.Insert("Error_010", NStr("en='426FD697-FBB8-3173-315D-D2CF4EB3C542%1'", Lang));
	Strings.Insert("Error_011", NStr("en='E524A3AE-2C0F-106A-A841-1B595B2191D6'", Lang));
	Strings.Insert("Error_012", NStr("en='6FE6133A-B423-683F-F705-58E5954B0C8F_________'", Lang));
	Strings.Insert("Error_013", NStr("en='660E5F0E-F220-AFD0-09B3-371796A45A18'", Lang));
	Strings.Insert("Error_014", NStr("en='0DCD9C17-D710-8DB4-42B1-120B1053E5F4____________'", Lang));
	Strings.Insert("Error_015", NStr("en='09515EA0-360A-AD0B-B77D-D1F7D588E4DD'", Lang));

	// %1 - Sales order
	Strings.Insert("Error_016", NStr("en='BFAD82ED-0F41-C433-3DE6-67E2994069BE_______________________________________________%1'", Lang));
	
	// %1 - Goods receipt
	// %2 - Purchase invoice
	Strings.Insert("Error_017", NStr("en='5B76BA8D-C9B6-A3D1-1AFD-DE27FFD6061C___________________________________________________%1,%1,%2'", Lang));

	// %1 - Shipment confirmation
	// %1 - Sales invoice
	Strings.Insert("Error_018", NStr("en='5B76BA8D-C9B6-A3D1-1AFD-DE27FFD6061C___________________________________________________%1,%1,%2'", Lang));
	
	// %1 - Goods receipt
	// %2 - Purchase invoice
	Strings.Insert("Error_019", NStr("en='685ECF3B-3B2E-5094-4D7F-F4EF6469DD03_________________________________________________%1,%2'", Lang));

	// %1 - 12
	Strings.Insert("Error_020", NStr("en='B37C787D-20E4-3A0B-BB9B-BC029F565C96%1'", Lang));

	// %1 - Purchase invoice
	Strings.Insert("Error_021", NStr("en='2897AB70-DADB-B465-5BE8-89288A1D7BDD____________________________________________________%1'", Lang));

	// %1 - Internal supply request
	Strings.Insert("Error_023", NStr("en='BFAD82ED-0F41-C433-3DE6-67E2994069BE_______________________________________________%1'", Lang));
	
	// %1 - Goods receipt
	// %2 - Purchase invoice
	Strings.Insert("Error_028", NStr("en='62F69A0E-BD98-8E96-6C78-869CEC550794___________________%1,%2'", Lang));
	
	// %1 - Cash account
	// %2 - 12
	// %3 - Cheque bonds
	Strings.Insert("Error_030", NStr("en='CEECB2D4-E76F-BF9C-C846-6AA80E30C6D6%1,%2,%3'", Lang));

	Strings.Insert("Error_031", NStr("en='85C069F4-A2F1-FCF2-2C65-521182900709__________________________________________'", Lang));
	Strings.Insert("Error_032", NStr("en='D7AF204D-B470-1AA4-4396-631F642F8D64'", Lang));
	Strings.Insert("Error_033", NStr("en='78FCD961-C2C4-65D2-2F5D-D72E820DB4A4'", Lang));
	// %1 - Google drive
	Strings.Insert("Error_034", NStr("en='221A5633-F1E0-FA3C-C825-5CD1D7327A8F%1'", Lang));
	Strings.Insert("Error_035", NStr("en='75433875-3AEE-131C-C081-14134780F698'", Lang));
	Strings.Insert("Error_037", NStr("en='FBAA655F-62A0-9C36-6DE4-4E581E7F8479____________'", Lang));
	Strings.Insert("Error_040", NStr("en='6492349E-23E0-C216-62AC-C12DAB5F732F'", Lang));
	Strings.Insert("Error_041", NStr("en='4DC7D4A3-FA69-DD32-23A6-6D1C8F65C7A2___________________%1,%2'", Lang));
	// %1 - Name
	Strings.Insert("Error_042", NStr("en='F06C605D-FBE4-8036-6AE0-03F9C7B2CA1A_%1'", Lang));
	Strings.Insert("Error_043", NStr("en='E698AD41-9633-95B1-1D8A-A0B4BEC55E57'", Lang));
	Strings.Insert("Error_044", NStr("en='9C25EA1F-74B2-D733-38AD-D09AC2A82F79'", Lang));
	Strings.Insert("Error_045", NStr("en='D287FB4A-BE14-8C4A-AC64-46267916F2CA'", Lang));
	// %1 - Currency
	Strings.Insert("Error_047", NStr("en='62D03E8E-7153-150C-CEFB-B19B92466273%1'", Lang));
	Strings.Insert("Error_049", NStr("en='62B7B9E4-7030-AF40-0A01-15ED9C977D9E______'", Lang));
	Strings.Insert("Error_050", NStr("en='6FCA17B9-D80A-FB7C-C09C-C0B006FA5097____________________________________________________________'",
		Lang));
	// %1 - Bank payment
	Strings.Insert("Error_051", NStr("en='5C064016-A587-32EE-EE32-243636898AD0___________________________________________________________________%1,%1'",
		Lang));
	// %1 - Main store
	// %2 - Use shipment confirmation
	// %3 - Shipment confirmations
	Strings.Insert("Error_052", NStr("en='AA54EC0E-91B6-F64A-AC84-452B19083EBA%2,%3,%1
		|_________________________________________________'", Lang));
	
	// %1 - Main store
	// %2 - Use goods receipt
	// %3 - Goods receipts
	Strings.Insert("Error_053", NStr("en='169F34CA-EC97-C3B6-6CB1-1978E41FBC37_______________________________________________%2,%3,%1'", Lang));
	
	// %1 - sales order
	Strings.Insert("Error_054", NStr("en='CF54FBB4-F580-1E54-439C-CFF317E3F114______________________%1'", Lang));

	Strings.Insert("Error_055", NStr("en='B39F867D-8289-A9EF-F9F2-2D1A791FDE8F_________________'", Lang));

	// %1 - sales order
	// %2 - purchase order
	Strings.Insert("Error_056", NStr("en='EF671ACB-DE09-7407-740B-B7952CB05E4E__________________________________________%1,%2'", Lang));
	
	// %1 - Bank receipt
	// %2 - Cash transfer order
	Strings.Insert("Error_057", NStr("en='E81EDDF1-3A75-365B-B5F7-702C41D776E9________________________________________%1,%2'", Lang));
	
	// %1 - Bank receipt
	// %2 - Cash transfer order
	Strings.Insert("Error_058", NStr("en='C90EA75D-D03B-0AB7-7AE3-3E4D5BEC24B0__________________________________________________________%2,%1'",
		Lang));
	
	// %1 - Bank receipt
	// %2 - Cash transfer order
	Strings.Insert("Error_059", NStr("en='D4900E23-9ED2-96F1-1044-4843DB60D1B3________________________________________________%2,%1,%1
		|______________________________________________'", Lang));
	
	// %1 - Bank receipt
	// %2 - Cash transfer order
	Strings.Insert("Error_060", NStr("en='EF70A607-8DE8-1437-74EA-A835F2D1E999______________________________________________________________%2,%1'",
		Lang));
	
	// %1 - Main store
	// %2 - Shipment confirmation
	// %3 - Sales order
	Strings.Insert("Error_064", NStr("en='99D8460D-37CE-73BC-C5F3-3FD860DF3695________________________________________________________________________%2,%1,%3'",
		Lang));

	Strings.Insert("Error_065", NStr("en='A22626EC-2501-45E7-725B-BD5122E7B488'", Lang));
	Strings.Insert("Error_066", NStr("en='39549BA4-46F3-8465-58D7-769D778D1770'", Lang));
	Strings.Insert("Error_067", NStr("en='3602983B-E5E0-4DB4-4328-8B8FBEC87B98'", Lang));

	// %1 - 12
	// %2 - Boots
	// %3 - Red XL
	// %4 - ordered
	// %5 - 11
	// %6 - 15
	// %7 - 4
	// %8 - pcs
	Strings.Insert("Error_068", NStr("en='89E56E12-B988-990F-F809-9AE241FE5927_______________________________________%1,%2,%3,%4,%5,%8,%6,%8,%7,%8'", Lang));

	// %1 - 12
	// %2 - Boots
	// %3 - Red XL
	// %4 - 00001
	// %5 - ordered
	// %6 - 11
	// %7 - 15
	// %8 - 4
	// %9 - pcs
	Strings.Insert("Error_068_2", NStr("en='F50EDAFE-3F0E-889B-B3CA-A0F5D9AAD8B9______________________________________________________________%1,%2,%3,%4,%5,%6,%9,%7,%9,%8,%9'", Lang));

	// %1 - Store 1
	// %2 - Boots
	// %3 - Red XL
	// %4 - 4
	// %5 - pcs
	Strings.Insert("Error_069", NStr("en='16D993DE-31C2-5E20-0C1F-FAD93DB6A9D8%1,%2,%3,%4,%5'", Lang));

	// %1 - Store 1
	// %2 - Boots
	// %3 - Red XL
	// %4 - 00001
	// %5 - 4
	// %6 - pcs
	Strings.Insert("Error_069_2", NStr("en='175A32B5-22CA-3BE9-97DD-D0819FC34611_____________________%1,%2,%3,%4,%5,%6'", Lang));

	// %1 - some extention name
	Strings.Insert("Error_071", NStr("en='0C44E77F-1114-B0A6-67EA-A574ED3CF2D0%1'", Lang));
	
	// %1 - 12
	Strings.Insert("Error_072", NStr("en='19ADB838-653D-FC1F-F1C7-7A42F37E2B84%1'", Lang));

	// %1 - Sales order
	// %2 - Goods receipt
	Strings.Insert("Error_073", NStr("en='689661E2-280E-50A4-4ABF-FEE0701B3EB3______________________________________________%1,%2'", Lang));
	Strings.Insert("Error_074", NStr("en='25155807-E759-A7A0-0F4B-BDC01355603A_______________________'", Lang));

	// %1 - Physical count by location
	Strings.Insert("Error_075", NStr("en='8CA034FB-FA39-6087-768D-D79F93988CE7_________%1'", Lang));
	
	// %1 - 12
	Strings.Insert("Error_077", NStr("en='C59C12B6-13A5-3E7B-B48A-A0425358ACF9%1'", Lang));
	
	// %1 - 1 %2 - 2
	Strings.Insert("Error_078", NStr("en='0654D34F-29A1-F79B-B728-80803A689DF1________________________________%1,%2'",
		Lang));
	
	// %1 - 100.00 
	// %2 - 120.00
	Strings.Insert("Error_079", NStr("en='6DEE7EA6-AC39-4E5A-ABF6-605951A834EB________________%1,%2'", Lang));
	
	// %1 - 1 
	// %2 - Goods receipt 
	// %3 - 10 
	// %4 - 8
	Strings.Insert("Error_080", NStr("en='9D0AB0BD-0953-A023-39F3-3AB8F3C93191________%1,%2,%3,%4'", Lang));
	
	// %1 - 1 
	// %2 - Dress 
	// %3 - Red/38 
	// %4 - 8 
	// %5 - 10
	Strings.Insert("Error_081", NStr("en='5424D8B7-CCD3-EBE7-7505-538EAC1BB89C_________________%1,%2,%3,%4,%5'",
		Lang));
	
	// %1 - 1 
	// %2 - Dress 
	// %3 - Red/38 
	// %4 - 10 
	// %5 - 8
	Strings.Insert("Error_082", NStr("en='5424D8B7-CCD3-EBE7-7505-538EAC1BB89C_________________%1,%2,%3,%4,%5'",
		Lang));
	
	// %1 - 12 
	Strings.Insert("Error_083", NStr("en='CC4350DA-2E1F-070E-E22B-BF252BA831BD%1'", Lang));
	
	// %1 - 1000
	// %2 - 300
	// %3 - 350
	// %4 - 50
	// %5 - USD
	Strings.Insert("Error_085", NStr("en='CB15E49E-A257-013C-C0B6-6C73739E5CD1_____________________________________________%1,%2,%3,%4,%5'", Lang));
	
	// %1 - 10
	// %2 - 20	
	Strings.Insert("Error_086", NStr("en='01D919AA-D46D-B211-161E-E040C3A2BD6E_________%1,%2'", Lang));

	Strings.Insert("Error_087", NStr("en='FEA8078F-3330-6DC8-8DB1-15FDBBF7F2A6'", Lang));
	Strings.Insert("Error_088", NStr("en='F6E12406-C2AB-7DF4-443B-BC6672A2C932_____________'", Lang));

	Strings.Insert("Error_089", NStr("en='8BD39D29-9CF1-2B40-01C1-1F3C0500D1FC_%1,%2'", Lang));
	
	// %1 - Boots
	// %2 - Red XL
	// %3 - ordered
	// %4 - 11
	// %5 - 15
	// %6 - 4
	// %7 - pcs
	Strings.Insert("Error_090", NStr("en='4504BC02-6927-6C01-1940-0295B36AA5AA_________________________%1,%2,%3,%4,%7,%5,%7,%6,%7'", Lang));

	// %1 - Boots
	// %2 - Red XL
	// %3 - 0001
	// %3 - ordered
	// %4 - 11
	// %5 - 15
	// %6 - 4
	// %7 - pcs
	Strings.Insert("Error_090_2", NStr("en='0535752A-789F-3CDE-EDB4-46B3A0DFA449________________________________________________%1,%2,%3,%4,%5,%6,%6,%8,%7,%8'", Lang));

	Strings.Insert("Error_091", NStr("en='1DC46B3F-55F4-0A71-163D-D283EA1C8CFC'", Lang));

	Strings.Insert("Error_092", NStr("en='66160944-996A-61EB-B113-372A5BFD863B%1'", Lang));
	Strings.Insert("Error_093", NStr("en='4DC4DD14-4A21-E402-2A48-85D093815400_________________'", Lang));
	Strings.Insert("Error_094", NStr("en='C171E61B-DD64-88F2-2166-6DC9652B6419______________________'", Lang));
	
	// %1 - 100.00 
	// %2 - 120.00
	Strings.Insert("Error_095", NStr("en='58DBC9E1-19E2-7A65-57B6-6F6ABEAA44BC_______________%1,%2'", Lang));
	
	// %1 - 1
	// %2 - Boots
	// %3 - Red XL
	Strings.Insert("Error_096", NStr("en='215383D0-BF8D-1D2C-CFA1-1E61785F36FC____%1,%2,%3'", Lang));

	// %1 - 1
	// %2 - Boots
	// %3 - Red XL
	Strings.Insert("Error_097", NStr("en='60C7AC27-4907-043D-DB32-24ED9C0E26CA%1,%2,%3'", Lang));
	
	// %1 - 1
	// %2 - Store
	// %3 - Store 01
	// %4 - Store 02
	Strings.Insert("Error_098", NStr("en='D5E5772B-160B-4C2F-F101-158318FFC886__________________________________%1,%2,%3,%4'", Lang));
	
	// %1 - Partner
	// %2 - Partner 01
	// %3 - Partner 02
	Strings.Insert("Error_099", NStr("en='CC8C1B36-BC05-6D37-762D-DF5164D95915___________________%1,%2,%3'", Lang));
	
	// %1 - Value 01
	// %2 - Value 02
	Strings.Insert("Error_100", NStr("en='9E7FBA0D-1E6F-9DC1-1539-9E37F09B08B5_______________%1,%2'", Lang));
	
	Strings.Insert("Error_101", NStr("en='4F9381BA-F2DA-2359-924D-D1D79D8E74D7'", Lang));
	Strings.Insert("Error_102", NStr("en='4984BC1A-8650-B262-2BF4-45A8387B5E75___'", Lang));
	Strings.Insert("Error_103", NStr("en='D815617C-4C65-369D-D068-882877F95002%1'", Lang));
	Strings.Insert("Error_104", NStr("en='86FF9451-BABB-A71B-B71A-A4E760C8449F_____%1'", Lang));
	Strings.Insert("Error_105", NStr("en='CDE2E0F5-22FB-4F46-6943-3C2B60F2E202________%1'", Lang));
	Strings.Insert("Error_106", NStr("en='EC9C7860-3423-A6AF-FBEA-A6B64A0673B9'", Lang));
	Strings.Insert("Error_107", NStr("en='0357E942-1C2F-E45A-A966-6CDB8736DE90%1'", Lang));
	Strings.Insert("Error_108", NStr("en='C08AAE36-640B-6059-9F88-87706A0E66F6____'", Lang));
	Strings.Insert("Error_109", NStr("en='50297B54-ECF7-9914-4826-6EC1B7190DEC___________________%1,%2'", Lang) + Chars.LF);
	Strings.Insert("Error_110", NStr("en='8F075F91-D9A3-3F19-9752-2F1FCB9B0880___________________________________________________'", Lang) + Chars.LF);
	Strings.Insert("Error_111", NStr("en='7C3E2B86-C801-C553-36F5-5C0874B667FE%1,%2'", Lang) + Chars.LF);
	Strings.Insert("Error_112", NStr("en='A2FFF192-4449-CDC8-8FE1-1AB86D66EF68%1'", Lang));
	Strings.Insert("Error_113", NStr("en='10438675-E1E3-2595-53DD-D66EEE1C8D61_____________________%1'", Lang) + Chars.LF);
	Strings.Insert("Error_114", NStr("en='D0535E82-0359-EAB3-3ACB-B8043B49ADDC'", Lang) + Chars.LF);
	Strings.Insert("Error_115", NStr("en='D96780DE-FDFC-3F10-00E0-077875AC62FB'", Lang) + Chars.LF);
	Strings.Insert("Error_116", NStr("en='66C45146-A2BE-0C41-17EB-B10CEBC4A3EA_______%1'", Lang) + Chars.LF);
	Strings.Insert("Error_117", NStr("en='33F068CC-2596-431E-EE52-2B8BACA979CB__________________'", Lang) + Chars.LF);
	Strings.Insert("Error_118", NStr("en='D30EE97D-7E8E-E6B8-807C-C4C6D55D5009__________________%1'", Lang) + Chars.LF);
	Strings.Insert("Error_119", NStr("en='C17F4E05-426E-2951-16FD-DF936C1F3792'", Lang) + Chars.LF);
	Strings.Insert("Error_120", NStr("en='0F97EB4F-6714-0C25-54EC-C990B16B9C76____________________________________________%1,%2,%3,%4,%5'", Lang) + Chars.LF);
	Strings.Insert("Error_121", NStr("en='65C38AD4-E22C-E525-5996-6480BD666CE0__________________________'", Lang) + Chars.LF);
	Strings.Insert("Error_122", NStr("en='CFA714EF-526E-EE4B-B6C7-7444CA835AE8_________________%1'", Lang) + Chars.LF);
	Strings.Insert("Error_123", NStr("en='2E64B810-7D19-1039-9731-1CFFC36E8FF5'", Lang) + Chars.LF);
	Strings.Insert("Error_124", NStr("en='8736E939-04CD-2012-2E59-91322A67E628_________________________________%1,%2,%3'", Lang));
	Strings.Insert("Error_125", NStr("en='262758F2-39E3-E79E-E0D5-542AA38171CE%1'", Lang));
	Strings.Insert("Error_126", NStr("en='995E666A-9C31-443B-B672-2CC98CB89A90____'", Lang));
	Strings.Insert("Error_127", NStr("en='AC701768-B0EA-8F37-7C95-5A07D07B5879'", Lang));
	Strings.Insert("Error_128", NStr("en='0D816E9A-93A8-C961-1CAE-EA0FEA3635CD'", Lang));
	Strings.Insert("Error_129", NStr("en='07B40E21-C8F5-2816-68FF-F9B54E56EE79___________________________________________%1,%2,%3,%4'", Lang));
	Strings.Insert("Error_130", NStr("en='26493AC3-607C-9AB0-0B6B-B080E0735D0F________________________________________________%1,%2,%3'", Lang));
	Strings.Insert("Error_131", NStr("en='9A790E55-39FC-9AEA-A535-53476F4B03D0________________________________%1,%2,%3'", Lang));	
	Strings.Insert("Error_132", NStr("en='8498B73D-A259-49C2-29B0-060F6AD8D9F6___%1'", Lang));	
	Strings.Insert("Error_133", NStr("en='32262A2B-8BBB-C171-1349-92A3B1D6F30E_____________________________________________________________%1,%2,%3'", Lang));
	Strings.Insert("Error_134", NStr("en='66C2B773-43D3-0243-3C39-96F24BE46BE6____________________________________________________________________%1,%2'", Lang));
	Strings.Insert("Error_135", NStr("en='9A790E55-39FC-9AEA-A535-53476F4B03D0________________________________%1,%2,%3'", Lang));	
	Strings.Insert("Error_136", NStr("en='6D3EF491-3F25-B523-3C52-228FB101E89C_________________%1'", Lang));	
	Strings.Insert("Error_137", NStr("en='5FBDF7C2-CDE6-613C-C010-09FE72B9E0DC____________________[Key],%1,%2'", Lang));	
	Strings.Insert("Error_138", NStr("en='AE919687-D5E5-C8B7-72D0-05939CAE3A28___________________________%1,%2,%3'", Lang));	
	Strings.Insert("Error_139", NStr("en='B41318A8-8B5D-84CC-CCEF-F5251D0DA821%1'", Lang));	
	Strings.Insert("Error_140", NStr("en='053E3DA7-0112-EA64-45AE-EFEA79717738'", Lang));	
	Strings.Insert("Error_141", NStr("en='58C8999C-94E6-824C-C33E-E9D55B2FB9D9________%1'", Lang));	
	Strings.Insert("Error_142", NStr("en='C6B8586A-A0FE-9DEF-FAF1-1BF3E1E15A58___________'", Lang));	
	Strings.Insert("Error_143", NStr("en='F29A27AA-E1C5-55DE-E681-1A0B7CF0A232_________________'", Lang));	
	Strings.Insert("Error_EmptyCurrency", NStr("en='873BA3B5-4FE2-05A4-475A-A9DA2D37777C'", Lang));
	Strings.Insert("Error_EmptyTransactionType", NStr("en='D24795CB-D16A-F8B5-5FD3-38287AB121EC'", Lang));
	Strings.Insert("Error_144", NStr("en='FDC0F2F8-5242-F88A-ACFD-D616C484EBE3____________________________________________________________________________'", Lang));
	Strings.Insert("Error_PartnerBalanceCheckfailed", NStr("en='7BBA4501-417F-F330-0F72-2530F5485BB2____________'", Lang));
	
	// %1 - Register name
	Strings.Insert("Error_145", NStr("en='BFD67D3A-90F6-EDE7-7F5E-E54CA4B0311A_____________________________________________________________________________%1'", Lang));
	
	Strings.Insert("Error_146", NStr("en='0D210B61-E849-22AD-DEA5-5E735458607B'", Lang));
	Strings.insert("Error_147", NStr("en='0BFD3CA7-AEEE-BC87-7F0E-E17228A189CE___________________'", Lang));
	
	Strings.Insert("Error_FillTotalAmount", NStr("en='E76C9AA7-C27F-D236-698A-A1ACB6BB42B1%1'", Lang));
	
	// manufacturing errors
	Strings.Insert("MF_Error_001", NStr("en='44E3826B-EB30-78FB-BD72-28BF991D58A7%1'", Lang));
	Strings.Insert("MF_Error_002", NStr("en='E8244BD1-F875-0A61-1044-458E61075D6E%1'", Lang));
	Strings.Insert("MF_Error_003", NStr("en='471B5968-5722-3311-18A8-85C0C56F5C58____%1,%2,%3'", Lang));
	Strings.Insert("MF_Error_004", NStr("en='07200F5E-B706-24D8-8F39-9138F78C7A43___________%1,%2'", Lang));
	Strings.Insert("MF_Error_005", NStr("en='0944670B-1FA3-61DE-E044-4B33C3F34B50___________________________%1,%2'", Lang));
	Strings.Insert("MF_Error_006", NStr("en='FA5FE583-AF24-57D1-1F59-99A24908F712______%1,%2'", Lang));
	Strings.Insert("MF_Error_007", NStr("en='0AC84C4E-7BE5-DC31-1E73-39209A9F7DF8_%1,%2'", Lang));
	Strings.Insert("MF_Error_008", NStr("en='B7EBC8FF-9D5A-9589-96EC-CDB8670B7824%1,%2'", Lang));
	Strings.Insert("MF_Error_009", NStr("en='0CF650C8-E82B-45A6-6862-2F726D0B33D1____________%1,%2,%3'", Lang));
	Strings.Insert("MF_Error_010", NStr("en='250962D8-AC20-59CB-B28E-E6E2B1D07324'", Lang));
	
	// Errors matching attributes of basis and related documents
	Strings.Insert("Error_ChangeAttribute_RelatedDocsExist", NStr("en='95DED6FD-B4A5-4F85-5388-8DA0D53AD217_______%1'", Lang));
	Strings.Insert("Error_AttributeDontMatchValueFromBasisDoc", NStr("en='6941CF7D-E952-86E3-3178-826DE2A11DE0%1,%2,%3'", Lang));
	Strings.Insert("Error_AttributeDontMatchValueFromBasisDoc_Row", NStr("en='E6E9E7BB-2D31-BF38-8845-5048B2F4799B_________%1,%2,%3,%4'", Lang));
	
	// Store does not match company
	Strings.Insert("Error_Store_Company", NStr("en='821A83D3-FDC1-0316-6FDC-C962DE7C23BF__%1,%2'", Lang));
	Strings.Insert("Error_Store_Company_Row", NStr("en='AEB3EC05-DFD2-AB7A-ABBD-DEC073E326F4______________%1,%3,%2'", Lang));
	
	Strings.Insert("Error_MaximumAccessKey", NStr("en='7B23D33B-76A6-DA86-6375-59FD3FEFA938_________________________________________________[ValueRef],[ObjectAccessKeys]'", Lang));
#EndRegion

#Region LandedCost

	Strings.Insert("LC_Error_001", NStr("en='C78F2BE0-37C0-D7A8-8EB3-353BCFA061B5__________________________________%1,%2,%3'", Lang) + Chars.LF);
	Strings.Insert("LC_Error_002", NStr("en='5042D1C9-C223-5581-1DF7-715CA5D55E7E__________________%1,%2,%3'", Lang) + Chars.LF);
	Strings.Insert("LC_Error_003", NStr("en='265E354E-9790-DA0F-F3F8-8AA62D9BE09D__________________%1,%2,%3'", Lang) + Chars.LF);
#EndRegion

#Region InfoMessages
	// %1 - Purchase invoice
	// %2 - Purchase order
	Strings.Insert("InfoMessage_001", NStr("en='FFC804AB-4AE0-6E2C-C1F0-0A2295C6F202_____________________________%1,%2,%1,%2
		|________________________________________________________________________________'",
		Lang));
	// %1 - Boots
	Strings.Insert("InfoMessage_002", NStr("en='B0701656-DF69-8DAB-B913-3D7486267528%1'", Lang));
	Strings.Insert("InfoMessage_003", NStr("en='9AE27686-C33D-E8C9-9F98-84B1433D8EF6'", Lang));
	Strings.Insert("InfoMessage_004", NStr("en='8BBA90B8-E049-1EDA-A975-576A423FAF11'", Lang));
	Strings.Insert("InfoMessage_005", NStr("en='807FB5AE-34C6-44DE-EA92-24F5987DFE40'", Lang));
	
	// %1 - Physical count by location
	Strings.Insert("InfoMessage_006", NStr("en='EA9DDDB9-C870-7B2A-ABC3-3DCB122E0286______________________________%1'", Lang));

	Strings.Insert("InfoMessage_007", NStr("en='69B878AE-601E-EE40-0978-8F8AC2CCB78A%1,%2'", Lang));
	// %1 - 12
	// %2 - 20.02.2020
	Strings.Insert("InfoMessage_008", NStr("en='69B878AE-601E-EE40-0978-8F8AC2CCB78A%1,%2'", Lang));

	Strings.Insert("InfoMessage_009", NStr("en='814171D6-98E9-E3AD-D26F-F053E0883C60___________________________________________'", Lang));
	Strings.Insert("InfoMessage_010", NStr("en='D429D4BF-C7AA-341A-A330-0ECB099A86ED______________________________________________________'", Lang));
	Strings.Insert("InfoMessage_011", NStr("en='B0B00E1E-120C-A9CE-E28D-D6EE7982275A______________________'", Lang));
	
	// %1 - 12
	// %2 - Vasiya Pupkin
	Strings.Insert("InfoMessage_012", NStr("en='676D356D-A381-935C-CAF0-0B9A9392CABE______________________%1,%2'", Lang));
	
	// %1 - 12
	Strings.Insert("InfoMessage_013", NStr("en='76186C2D-0ACA-88A3-39E9-99721B565458____________________________________________%1'", Lang));
	
	// %1 - 12
	Strings.Insert("InfoMessage_014", NStr("en='FC8EDAC2-45F6-5A6B-BB68-88E10461AD8A__________________________________________%1'", Lang));
	
	// %1 - 123456
	Strings.Insert("InfoMessage_015", NStr("en='D64BCB30-B45B-5141-171B-B623CBD815AF____%1'", Lang));

	// %1 - 123456
	// %2 - Some item
	Strings.Insert("InfoMessage_016", NStr("en='2A8AB474-72F0-FFEA-A775-5B506C9C4940____________%1,%2'", Lang));
	
	// %1 - 123456
	Strings.Insert("InfoMessage_017", NStr("en='7E590F4D-F249-7B01-1874-4171E8F5DCCF__________________%1'", Lang));
	Strings.Insert("InfoMessage_018", NStr("en='3D8F680C-F2D3-0D04-4A51-197C02E19800'", Lang));

	Strings.Insert("InfoMessage_019", NStr("en='FBEC7A8C-D8E6-ABCC-C161-1BB773D5C2DF'", Lang));

	Strings.Insert("InfoMessage_020", NStr("en='5CC35B61-5B4D-D65C-C44B-BF05879F7AD6%1'", Lang));
  
  	// %1 - 42
	Strings.Insert("InfoMessage_021", NStr("en='3B58AABB-DC28-0521-196A-A414033C0487__________________________%1'",
		Lang));
  	// %1 - 
	Strings.Insert("InfoMessage_022", NStr("en='894C97CF-D822-FB2B-B50D-D6A0D3240864%1'", Lang));
	Strings.Insert("InfoMessage_023", NStr("en='6780AB0D-BB90-05FF-FB8C-CD8E7E4BA5C2__________________________________________________________'", Lang));
	Strings.Insert("InfoMessage_024", NStr("en='02BA8FCE-3BA8-F96E-E866-6F001B7BA172'", Lang));
	Strings.Insert("InfoMessage_025", NStr("en='ED9B6C54-E3A9-5038-81AE-E1C05428AA15__'", Lang));
	Strings.Insert("InfoMessage_026", NStr("en='F9EFD155-BDC5-9BDA-AB21-1E6D78511505%1'", Lang));
	// %1 - 123123123
	// %2 - Item name
	// %3 - Item key
	// %4 - Serial lot number
	Strings.Insert("InfoMessage_027", NStr("en='07AE0505-29D8-F0AC-C18B-B42E0D95D737_______%1,%2,%3,%4'", Lang));
	Strings.Insert("InfoMessage_028", NStr("en='94A21A2D-9FA7-6CC9-91E9-9BC38FDE6D6A_________%1,%2'", Lang));
	Strings.Insert("InfoMessage_029", NStr("en='60A9A696-6344-D007-746D-D8E2C84BFD6E________________________'", Lang));
	Strings.Insert("InfoMessage_030", NStr("en='490E480D-7798-BED8-858C-C6D639E71DFE________'", Lang));
	Strings.Insert("InfoMessage_031", NStr("en='D423BB64-F19F-D081-1286-6D97280B357D'", Lang));
	Strings.Insert("InfoMessage_032", NStr("en='9EEA4625-3ACD-95E3-35E6-6A6853EF09F0'", Lang));
	Strings.Insert("InfoMessage_033", NStr("en='8683584B-F5E0-0497-7192-25D7E7EC364D'", Lang));
	
	Strings.Insert("InfoMessage_034", NStr("en='545C9E2A-91C0-0073-32BA-AF97DF8C44F7'", Lang));
	Strings.Insert("InfoMessage_035", NStr("en='384DA243-1523-D17D-DDD1-147614CEA196%1'", Lang));
	Strings.Insert("InfoMessage_036", NStr("en='3428361F-AE28-E594-48D2-2BCD86BEF2DE%1,%2'", Lang));
	Strings.Insert("InfoMessage_037", NStr("en='CBF9C85A-B0EC-4772-29C0-015E09E84E14'", Lang));
	Strings.Insert("InfoMessage_AttachFile_NonSelectDocType", NStr("en='F889FE64-C2BF-71A2-2A58-8C6E87C7C5E5'", Lang));
	Strings.Insert("InfoMessage_AttachFile_SelectDocType", NStr("en='F6853798-DCF1-4328-8761-19463EBE69CB'", Lang) + Chars.LF + "%1");
	Strings.Insert("InfoMessage_AttachFile_MaxFileSize", NStr("en='4ED58E60-FD47-A00D-D6AE-EE106E5BCE7D__________________________________%1,%2,%3'", Lang) + Chars.LF + "%1");
	Strings.Insert("InfoMessage_038", NStr("en='62B4FE33-28D5-0B14-4389-95507838FF47_______________________________________________________________________________________________________'", Lang));
	Strings.Insert("InfoMessage_039", NStr("en='0847EC02-3E83-9ADB-B486-668861C8D2AA'", Lang));
	
	Strings.Insert("InfoMessage_WriteObject", NStr("en='2928233E-7EA0-DD38-830F-F339347701A0'", Lang));
	Strings.Insert("InfoMessage_Payment", NStr("en='FC6DE927-8CF3-CA10-00D4-4E9938551163'", Lang));
	Strings.Insert("InfoMessage_PaymentReturn", NStr("en='3D2C3CCC-09EE-9DDC-CE2C-C4CD508625B3'", Lang));
	Strings.Insert("InfoMessage_SessionIsClosed", NStr("en='2CF4ABE9-AA01-7514-49D7-7204273080AE'", Lang));
	Strings.Insert("InfoMessage_Sales", NStr("en='75E38679-AD3C-44CA-AA6A-ACA40EE5389C'", Lang));
	Strings.Insert("InfoMessage_Returns", NStr("en='9E07A203-B7B2-827F-F078-8A7FAB816EEB'", Lang));
	Strings.Insert("InfoMessage_ReturnTitle", NStr("en='9A3436E4-BEC9-8944-41BA-AF4A31AD12EF'", Lang));
	Strings.Insert("InfoMessage_POS_Title", NStr("en='31813FBC-D80C-9225-5D36-6956EFD760B5'", Lang));
	Strings.Insert("InfoMessage_CanOpenOnlyNewStatus", NStr("en='284C1380-831C-5E60-08A6-6EE2B550AD21_______________________________'", Lang));
	Strings.Insert("InfoMessage_CanCloseOnlyOpenStatus", NStr("en='ABFD9C56-3324-8ADE-EE4C-C3A85D6A707C________________________________'", Lang));
	
	Strings.Insert("InfoMessage_NotProperty", NStr("en='02C79FF5-9CFD-9F6B-BE86-6F2F0AA88437____'", Lang));
	Strings.Insert("InfoMessage_DataUpdated", NStr("en='E5AE080C-6497-AF5F-F5FD-D47610F02C4C'", Lang));
	Strings.Insert("InfoMessage_DataSaved", NStr("en='856BDF35-4BD7-A4A2-2570-0454B37F2431'", Lang));
	Strings.Insert("InfoMessage_SettingsApplied", NStr("en='F464A6E0-3D5E-0B33-3168-8A1B24308C00'", Lang));
	Strings.Insert("InfoMessage_ImportError", NStr("en='182157D2-8568-9AE7-7ABE-E3C490D89032__________________________'", Lang));
	
#EndRegion

#Region QuestionToUser
	Strings.Insert("QuestionToUser_001", NStr("en='A9E96B84-50BF-39F8-8912-294ABA32F584___'", Lang));
	Strings.Insert("QuestionToUser_002", NStr("en='84F9EDB0-7FE7-BB53-3DFF-FEDC60A73F53'", Lang));
	Strings.Insert("QuestionToUser_003", NStr("en='D20C8C9D-71C4-2AF6-6B4A-AF80E1EE3BC9_______________________________________________%1'", Lang));
	Strings.Insert("QuestionToUser_004", NStr("en='42913706-A1D1-9035-54E7-78FFD2D603A0__________________________'",
		Lang));
	Strings.Insert("QuestionToUser_005", NStr("en='79090F78-B86C-8CA9-9EC7-7121335DC155'", Lang));
	Strings.Insert("QuestionToUser_006", NStr("en='84DA2153-50FD-514A-A75A-A6C873B298CD__'", Lang));
	Strings.Insert("QuestionToUser_007", NStr("en='B6FF0C07-C95C-AE7B-B49B-BDED479A01C0________'", Lang));
	Strings.Insert("QuestionToUser_008", NStr("en='1F6CF3E5-261C-8567-7E7F-F298C5ED4457_____________________________________________'", Lang));
	Strings.Insert("QuestionToUser_009", NStr("en='5D0A9502-D09D-EE19-92BB-BF2C3A688AB2_______________%1'", Lang));
	Strings.Insert("QuestionToUser_011", NStr("en='3ED3D8EC-4717-EB96-6E92-2862D69EC297_________________________%1'",
		Lang));
	Strings.Insert("QuestionToUser_012", NStr("en='584DFA8C-67CE-A827-7591-11A73CA166A1'", Lang));
	Strings.Insert("QuestionToUser_013", NStr("en='EC5E82AF-314A-FC2C-CBC5-58E3F19865B6'", Lang));
	Strings.Insert("QuestionToUser_014", NStr("en='EF54791F-6E5C-3357-70BF-F35441FE3636___________________________'",
		Lang));
	Strings.Insert("QuestionToUser_015", NStr("en='566C8F1D-37C4-4F01-1E27-7C34EFE6EE8E__'", Lang));
	Strings.Insert("QuestionToUser_016", NStr("en='462DDA43-7262-0C57-7236-6DEEF7A29A8D____'", Lang));
	Strings.Insert("QuestionToUser_017", NStr("en='500EB9FD-0360-1554-41AF-F9E4A54F9817'", Lang));
	Strings.Insert("QuestionToUser_018", NStr("en='2584DE9A-9DA7-4DB1-18E6-66D706013F7A'", Lang));
	Strings.Insert("QuestionToUser_019", NStr("en='DF7B3259-79B0-DEF6-6E57-7D9A1BD8315C'", Lang));
	Strings.Insert("QuestionToUser_020", NStr("en='C3694019-9A38-4FF9-93A3-3746C62EAE65__'", Lang));
	Strings.Insert("QuestionToUser_021", NStr("en='3CF7325D-B570-FF56-6785-531A3A1238E0_____________________'", Lang));
	Strings.Insert("QuestionToUser_022", NStr("en='87A22B00-E444-2CE1-127B-BAEBBF815A63'", Lang) + ": " + Chars.LF + "%1");
	Strings.Insert("QuestionToUser_023", NStr("en='C9022A5E-7435-BB46-626E-EE13082A14B8_________________'", Lang));
	Strings.Insert("QuestionToUser_024", NStr("en='A1F40F0A-25D7-98FA-A0DB-B7894066759C'", Lang));
	Strings.Insert("QuestionToUser_025", NStr("en='515F34B7-5162-4856-68E3-3B524240914E___'", Lang));
	Strings.Insert("QuestionToUser_026", NStr("en='07F191BC-9351-881F-F44F-F68BAB5C5EA3'", Lang));
	Strings.Insert("QuestionToUser_027", NStr("en='97D4DED5-D07E-B7D4-497B-B4CE8B1691CC___________________%1'", Lang));
	Strings.Insert("QuestionToUser_028", NStr("en='8C422C34-EA75-8D7E-E296-6F68D69E5DDB'", Lang));
	Strings.Insert("QuestionToUser_029", NStr("en='702B3291-6073-39F0-0844-41430CDE4DAE_________________________________________________________________________________________________________________'", Lang));
	Strings.Insert("QuestionToUser_030", NStr("en='044A4D5D-DFC6-D6F1-19B9-903B50609F32________'", Lang));
#EndRegion

#Region SuggestionToUser
	Strings.Insert("SuggestionToUser_1", NStr("en='959143D6-AEDC-7727-7F74-4AC4E38771F0'", Lang));
	Strings.Insert("SuggestionToUser_2", NStr("en='9A13DD97-963E-1BC4-427D-DCC49DAF6A86'", Lang));
	Strings.Insert("SuggestionToUser_3", NStr("en='B6C062DB-F7F2-6A70-0283-3DA0593F6509'", Lang));
	Strings.Insert("SuggestionToUser_4", NStr("en='C1EA5B18-606D-9845-5FFB-BE95CCE2E9AD'", Lang));
#EndRegion

#Region UsersEvent
	Strings.Insert("UsersEvent_001", NStr("en='0561B68D-7DE2-D9CB-B279-958454D654EC__%1,%2'", Lang));
	Strings.Insert("UsersEvent_002", NStr("en='A4FE5236-C977-BFD7-7393-3CF3845B0F6A%1,%2'", Lang));
	Strings.Insert("UsersEvent_003", NStr("en='61591E4B-0998-E989-92CA-A5A6DA39D24D_______'", Lang));
	Strings.Insert("UsersEvent_004", NStr("en='1DDC0FE0-9892-786C-CB13-38C8E70D5449'", Lang));
	Strings.Insert("UsersEvent_005", NStr("en='63B8B094-B150-D3B4-4FCB-B5A904CB4FC3_____________________'", Lang));
#EndRegion

#Region Items
	
	// Interface
	Strings.Insert("I_1", NStr("en='CF633766-69D6-AC22-2FA2-21DF61CB554C'", Lang));
	Strings.Insert("I_2", NStr("en='32E494B2-65BC-82E2-2C9A-AD050D13A222'", Lang));
	Strings.Insert("I_3", NStr("en='30ED1AA4-EE80-2D37-761C-C9A1182FF786'", Lang));
	Strings.Insert("I_4", NStr("en='F2138751-DA6B-23D8-82FC-C37ECA25E82A%1,%2'", Lang));
	Strings.Insert("I_5", NStr("en='A7E7DC5A-9A28-D58F-F9DB-BC040736D241'", Lang));
	Strings.Insert("I_6", NStr("en='8D7BF2D6-40CA-54B9-9902-2A1A50E618EB'", Lang));
	Strings.Insert("I_7", NStr("en='32BF802D-7A2E-0B5A-A55C-CB0F6B803813'", Lang));
	Strings.Insert("I_8", NStr("en='10D00172-B133-A52E-E4EC-C813A08901CF'", Lang));

#EndRegion

#Region Exceptions
	Strings.Insert("Exc_001", NStr("en='ED473741-2816-8D61-1759-9A23648A446A'", Lang));
	Strings.Insert("Exc_002", NStr("en='FB8F183A-146C-7563-3CED-DA024E0C096C'", Lang));
	Strings.Insert("Exc_003", NStr("en='9FCB2D44-93CE-0C6F-F1F2-218EF8A5B8AA%1'", Lang));
	Strings.Insert("Exc_004", NStr("en='C92F5C9D-DC5B-A472-2C20-0691AA1F9BAE____'", Lang));
	Strings.Insert("Exc_005", NStr("en='F3624115-6397-0461-1E34-4683C18F5999'", Lang));
	Strings.Insert("Exc_006", NStr("en='7BF9C2B5-6EC8-8B12-2354-4754CCACE8E8____'", Lang));
	Strings.Insert("Exc_007", NStr("en='D3DA9ECB-25AB-ECDB-B8EB-B8ACF0294F7A__%1'", Lang));
	Strings.Insert("Exc_008", NStr("en='5704C566-1EE3-0F55-5988-86D9EF107C79'", Lang));
	Strings.Insert("Exc_009", NStr("en='12A174BD-4463-6BE7-7E7A-AB27FB0CAF50%1'", Lang));
	Strings.Insert("Exc_010", NStr("en='CF406191-1D5B-480F-F65F-F99D235C65C4%1'", Lang));
	Strings.Insert("Exc_011", NStr("en='E00F369B-430D-5BFB-B353-31C87EE8CF5F%1'", Lang));
	Strings.Insert("Exc_012", NStr("en='24DF48BC-51FB-7CF3-308C-C54BAD250E26_____________________%1,%2'", Lang));
#EndRegion

#Region Saas
	// %1 - 12
	Strings.Insert("Saas_001", NStr("en='2F405459-6649-0EB0-0733-30635AF2054E%1'", Lang));
	
	// %1 - closed
	Strings.Insert("Saas_002", NStr("en='ACECB33F-8161-5912-22EC-CB10F5A9E443%1'", Lang));
	
	// %1 - en
	Strings.Insert("Saas_003", NStr("en='4BB22BA6-4B72-4624-488D-DA3D974083CF____________%1'", Lang));

	Strings.Insert("Saas_004", NStr("en='536C7FB7-6FB9-B20F-F41E-E78B94AC7029'", Lang));
#EndRegion

#Region FillingFromClassifiers
    // Do not modify "en" strings
	Strings.Insert("Class_001", NStr("en='383F84AA-6C94-9CF2-282E-ECBAABFE25C4'", Lang));
	Strings.Insert("Class_002", NStr("en='9048D720-30FF-481F-FC3C-C69763E3108A'", Lang));
	Strings.Insert("Class_003", NStr("en='B9E76F2E-CEEC-C606-659F-F85495D82DFD'", Lang));
	Strings.Insert("Class_004", NStr("en='4765EBF3-4BD5-C7D2-2F1A-A12A24B44756'", Lang));
	Strings.Insert("Class_005", NStr("en='C8EB8E41-4CB5-CC12-24BB-BC19A061172B'", Lang));
	Strings.Insert("Class_006", NStr("en='78C6CA81-3F7B-1050-0EA7-70628D95C5FA'", Lang));
	Strings.Insert("Class_007", NStr("en='3E4C4E38-16F1-5382-2B30-0D2F4B0EB586'", Lang));
	Strings.Insert("Class_008", NStr("en='5073B496-F747-0E7F-FE83-33CF32FDCCE0'", Lang));
#EndRegion

#Region Titles
	// %1 - Cheque bond transaction
	Strings.Insert("Title_00100", NStr("en='AEE4D090-D941-7C7F-F863-38D420349377_______%1'", Lang));	// Form PickUpDocuments
#EndRegion

#Region ChoiceListValues
	Strings.Insert("CLV_1", NStr("en='43FD3975-BF22-AC9B-BFAE-E4E7C6F06735'", Lang));
	Strings.Insert("CLV_2", NStr("en='770D4154-3E22-B8CE-EF5C-C81988E02B67'", Lang));
#EndRegion

#Region SalesOrderStatusReport
	Strings.Insert("SOR_1", NStr("en='1CECCA8B-87DF-341E-EB6A-A071CE31293A'", Lang));
#EndRegion

#Region Report
	Strings.Insert("R_001", NStr("en='E62C3083-B853-4D48-8DBF-FCEC1D45BEDC'", Lang) + " = ");
	Strings.Insert("R_002", NStr("en='06757165-B424-5995-5B8E-E8CF53B11763'", Lang) + " = ");
	Strings.Insert("R_003", NStr("en='E11A9633-AAB7-9E79-9E1F-F2F41A079399'", Lang) + " = ");
	Strings.Insert("R_004", NStr("en='370EC6F3-12C6-8790-0827-791D63FE1D60'", Lang) + " = ");
#EndRegion

#Region Defaults
	Strings.Insert("Default_001", NStr("en='5073B496-F747-0E7F-FE83-33CF32FDCCE0'", Lang));
	Strings.Insert("Default_002", NStr("en='43814F6A-B5B3-94E3-3911-1B8F0DEF67C2'", Lang));
	Strings.Insert("Default_003", NStr("en='443D581B-5AA7-0125-5C42-29C100671374'", Lang));
	Strings.Insert("Default_004", NStr("en='CD19DDFD-5943-13BA-A685-58FED354A35F'", Lang));
	Strings.Insert("Default_005", NStr("en='D1C57971-9A33-6B3F-FB4B-BF0B0D942DC4'", Lang));
	Strings.Insert("Default_006", NStr("en='002BEA64-3D2F-A4BE-E840-00DAD4A2CB46'", Lang));
	Strings.Insert("Default_007", NStr("en='4C870B49-28A3-B7D5-54B3-36CD473DBDB4'", Lang));
	Strings.Insert("Default_008", NStr("en='905E774F-B7D7-8E57-73EC-C6C66E278893'", Lang));
	Strings.Insert("Default_009", NStr("en='D29D968C-4503-682C-CD32-2883776A36CA'", Lang));
	Strings.Insert("Default_010", NStr("en='AA861704-7450-FCD6-649A-A917119D2649'", Lang));
	Strings.Insert("Default_011", NStr("en='66665127-264A-292F-F302-269C75E8632E'", Lang));
	Strings.Insert("Default_012", NStr("en='8B9E2143-7C34-7302-2379-9631F5E2D732'", Lang));
#EndRegion

#Region MetadataString
	Strings.Insert("Str_Catalog", NStr("en='84EA5A5C-2A97-B5A2-2FB2-221CED2FA793'", Lang));
	Strings.Insert("Str_Catalogs", NStr("en='4E4F5F66-B05D-A74E-E326-6914AAF23566'", Lang));
	Strings.Insert("Str_Document", NStr("en='00F25807-3FF5-B97A-A0BB-B2B2B755479B'", Lang));
	Strings.Insert("Str_Documents", NStr("en='2349B062-39B3-F670-0FF7-7D1A8B91C2D5'", Lang));
	Strings.Insert("Str_Code", NStr("en='DC8AF8BA-BC8F-CF4F-FB1A-A05215E78098'", Lang));
	Strings.Insert("Str_Description", NStr("en='C11CA7CC-D015-4536-60B2-2D6C7BCC9E43'", Lang));
	Strings.Insert("Str_Parent", NStr("en='7D72BED3-411E-6A53-383F-FC0128F65BFD'", Lang));
	Strings.Insert("Str_Owner", NStr("en='12619392-AC2C-DA10-05A2-2854B0FE271C'", Lang));
	Strings.Insert("Str_DeletionMark", NStr("en='AC006B8B-E32E-023C-C75D-D58FBC6EAE9B'", Lang));
	Strings.Insert("Str_Number", NStr("en='DE5C20EC-29F2-7402-284B-BF659223D0EC'", Lang));
	Strings.Insert("Str_Date", NStr("en='3D008872-6735-3A1E-E347-7972676B69B3'", Lang));
	Strings.Insert("Str_Posted", NStr("en='0C99C226-2477-1379-9218-808A449878E1'", Lang));
	Strings.Insert("Str_InformationRegister", NStr("en='9164AB4D-8548-7975-5D86-6E6AD089709E'", Lang));
	Strings.Insert("Str_InformationRegisters", NStr("en='062DA272-6596-F8C2-2A72-299D85F26818'", Lang));
	Strings.Insert("Str_AccumulationRegister", NStr("en='7B261BDD-8302-1FF0-0E66-6055AEC23D97'", Lang));
	Strings.Insert("Str_AccumulationRegisters", NStr("en='BD0454BC-7075-603C-C50E-E52101C306B8'", Lang));
#EndRegion

#Region AdditionalSettings
	Strings.Insert("Add_Setiings_001", NStr("en='1D1CD7D8-0EEC-1562-24C6-6F53B74299B8'", Lang));
	Strings.Insert("Add_Setiings_002", NStr("en='58778F23-6B02-42AB-B76B-B5E29277F72A'", Lang));
	Strings.Insert("Add_Setiings_003", NStr("en='E21473EF-7572-25A3-3D52-271FE108516F'", Lang));
	Strings.Insert("Add_Setiings_004", NStr("en='1D9ED810-53A8-908E-EA5E-EC2B25BA399A'", Lang));
	Strings.Insert("Add_Setiings_005", NStr("en='2349B062-39B3-F670-0FF7-7D1A8B91C2D5'", Lang));
	Strings.Insert("Add_Setiings_006", NStr("en='21993D20-8899-503E-E997-709C278E0796'", Lang));
	Strings.Insert("Add_Setiings_007", NStr("en='D20D3D2C-C5E8-0F7E-E080-05099D117F4C'", Lang));
	Strings.Insert("Add_Setiings_008", NStr("en='3CE4F70E-4D4A-BF70-074D-DE97C17395D9_'", Lang));
	Strings.Insert("Add_Setiings_009", NStr("en='6FC03045-30DF-F685-5833-326367964C34'", Lang));
	Strings.Insert("Add_Setiings_010", NStr("en='03609E0B-20FF-8D62-2FDC-C7E84A918326'", Lang));
	Strings.Insert("Add_Setiings_011", NStr("en='C00C15D1-B130-7112-2A1B-BF2BCC576DD1'", Lang));
	Strings.Insert("Add_Setiings_012", NStr("en='D20056CC-CBC8-E086-6E33-36F57FCBDD52'", Lang));
#EndRegion

#Region Mobile
	// %1 - Some item key
	// %2 - Other item key
	Strings.Insert("Mob_001", NStr("en='E35C43E4-7A03-BC8A-A5C2-22AFC13864B4%1,%2
		|_________________________'", Lang));
#EndRegion
	
#Region CopyPaste
	Strings.Insert("CP_001", NStr("en='F1611FFF-015E-7377-7199-9C2EC2F80D5D'", Lang));
	Strings.Insert("CP_002", NStr("en='1331309A-4F59-8EBA-A78C-C6B7F83000C7'", Lang));
	Strings.Insert("CP_003", NStr("en='7B5E2FF2-E007-9BE1-1925-5103322DAE63%1'", Lang));
	Strings.Insert("CP_004", NStr("en='E93C22BC-9F8B-C682-2B7B-BE3F47795385'", Lang));
	Strings.Insert("CP_005", NStr("en='CFB4356F-62DB-F7D4-483E-E96C458C1092'", Lang));
	Strings.Insert("CP_006", NStr("en='BBC0084A-4931-982D-D1F0-0CDBE6887303%1'", Lang));
#EndRegion	
	
#Region LoadDataFromTable
	Strings.Insert("LDT_Button_Title",   NStr("en='2C56766B-874D-8F20-05B6-68339C31E899'", Lang));
	Strings.Insert("LDT_Button_ToolTip", NStr("en='2C56766B-874D-8F20-05B6-68339C31E899'", Lang));
	Strings.Insert("LDT_FailReading", NStr("en='E5DF2A41-E695-2DD6-6D85-5E219126FCDE%1'", Lang));
	Strings.Insert("LDT_ValueNotFound", NStr("en='3257ADF4-9AAC-C999-96D5-57D0BA45CD4C%1'", Lang));
	Strings.Insert("LDT_TooMuchFound", NStr("en='584444C6-B53F-2CC0-0D63-35E98D2EED42%1'", Lang));
#EndRegion	

#Region OpenSerialLotNumberTree
	Strings.Insert("OpenSLNTree_Button_Title",   NStr("en='F319F521-30A3-C3CE-E818-830F533DAFF9'", Lang));
	Strings.Insert("OpenSLNTree_Button_ToolTip", NStr("en='F319F521-30A3-C3CE-E818-830F533DAFF9'", Lang));
#EndRegion	
	
#Region BackgroundJobs
	Strings.Insert("BgJ_Title_001",   NStr("en='F7529FA0-4E93-3951-1238-86DF00FE05FF'", Lang));
	Strings.Insert("BgJ_Title_002",   NStr("en='FF252B8B-BF08-D4DB-B491-16B1605FEA9D'", Lang));
#EndRegion	
	
#Region Salary
	Strings.Insert("Salary_Err_001",   NStr("en='D3F42266-FB98-A3CA-AE19-95F83790D41B'", Lang));
	Strings.Insert("Salary_Err_002",   NStr("en='EA8FB05A-DB89-F208-8E49-99040656C608'", Lang));
	Strings.Insert("Salary_Err_003",   NStr("en='3FDF5E4E-BD13-0EB1-1508-8D06D7A5DF3F'", Lang));
	
	Strings.Insert("Salary_WeekDays_1",   NStr("en='26C67A4E-C1B5-27AB-B64A-AB368A757DEA'", Lang));
	Strings.Insert("Salary_WeekDays_2",   NStr("en='587A862B-2CE0-319F-F3A6-65DAE2C4ED24'", Lang));
	Strings.Insert("Salary_WeekDays_3",   NStr("en='E91BFFC1-2CD7-49E8-8EE7-7486D67FB795'", Lang));
	Strings.Insert("Salary_WeekDays_4",   NStr("en='382960F4-13ED-2B92-258D-D62623508371'", Lang));
	Strings.Insert("Salary_WeekDays_5",   NStr("en='51F25496-5983-4675-53DB-BE10C7686DFE'", Lang));
	Strings.Insert("Salary_WeekDays_6",   NStr("en='FF499A26-EA87-2ABD-D01D-D3536571B965'", Lang));
	Strings.Insert("Salary_WeekDays_7",   NStr("en='2CB1250A-B18E-E9EC-C89E-EF0B613FC13A'", Lang));
#EndRegion

#Region Accounting

Strings.Insert("AccountingError_01", NStr("en='A66CEA04-DF75-40BF-FC97-79BF9696C13C%1'", Lang));
Strings.Insert("AccountingError_02", NStr("en='DBB7C8F5-F0EA-8EE5-53CF-F882C03E75DA'", Lang));
Strings.Insert("AccountingError_03", NStr("en='FE697020-AB71-9DA8-84BD-DACF7ECAD5F7'", Lang));
Strings.Insert("AccountingError_04", NStr("en='A488C83F-F43D-2692-20DE-EA24847DEF71'", Lang));
Strings.Insert("AccountingError_05", NStr("en='2F9243AB-2436-8A54-4EF4-4D598B22669A'", Lang));

Strings.Insert("AccountingQuestion_01", NStr("en='5E7890FE-4E81-0BCB-B31B-B2CC83F247E3[Quantity]'", Lang));
Strings.Insert("AccountingQuestion_02", NStr("en='90F59EC5-D33A-7504-42D2-27EC8ED87F6E[Currency]'", Lang));

Strings.Insert("AccountingInfo_01", NStr("en='2DE35D08-C922-4A3E-ED85-5CA8D65195BC'", Lang));
Strings.Insert("AccountingInfo_02", NStr("en='9746781D-2DA9-3D23-3500-09644A90C3E9'", Lang));
Strings.Insert("AccountingInfo_03", NStr("en='F4D432FE-8E38-A74D-D74F-F7B73E1F4B07'", Lang));
Strings.Insert("AccountingInfo_04", NStr("en='6E7CAF0B-7DD9-AF78-8DFC-C2D48329EDB0'", Lang));
Strings.Insert("AccountingInfo_05", NStr("en='9BC04F79-2A42-F076-60B3-324B13ACFAF4'", Lang));
Strings.Insert("AccountingInfo_06", NStr("en='773327A1-6E49-DCE9-9CF7-73DC06D9F09F'", Lang));

Strings.Insert("AccountingJE_prefix_01", NStr("en='54372627-A6E3-2FBF-FF01-1E8F32DD9303'", Lang));

Strings.Insert("BankPayment_DR_R1020B_AdvancesToVendors_R1021B_VendorsTransactions_CR_R3010B_CashOnHand", 
	NStr("en='32CB61CA-D13F-8BB3-3C39-9B68A048767E_______________________________________________________'", Lang)); 

Strings.Insert("BankPayment_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors",
	NStr("en='F8FAE334-BD4D-C0B3-3217-76B6E9EB6416_____________________________________'", Lang));

Strings.Insert("BankReceipt_DR_R3010B_CashOnHand_CR_R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions",
	NStr("en='630C6D0F-2D7D-6DB2-2A07-71F00091BF6B_____________________________________________________________'", Lang));

Strings.Insert("PurchaseInvoice_DR_R4050B_StockInventory_R5022T_Expenses_CR_R1021B_VendorsTransactions",
	NStr("en='80A9BEAD-A37F-C5BC-CA79-9770CD21F697______________________________________________________'", Lang));

Strings.Insert("PurchaseInvoice_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors",
	NStr("en='0FC25167-AECC-2676-6B78-85E9E0F2EAF3_________________________________________'", Lang));

Strings.Insert("PurchaseInvoice_DR_R1040B_TaxesOutgoing_CR_R1021B_VendorsTransactions",
	NStr("en='C97FBF79-B362-2984-4027-7F86B0AF2B1C_____________________________________'", Lang));

Strings.Insert("RetailSalesReceipt_DR_R5022T_Expenses_CR_R4050B_StockInventory",
	NStr("en='9CAEB40A-2AF8-BA3A-A09E-E51A0B8DF5F1______________________________'", Lang));

Strings.Insert("SalesInvoice_DR_R5022T_Expenses_CR_R4050B_StockInventory",
	NStr("en='E447FC6C-23A0-B01E-E2AF-FE3833416A9E________________________'", Lang));

Strings.Insert("SalesInvoice_DR_R2021B_CustomersTransactions_CR_R5021T_Revenues",
	NStr("en='2C155001-43FE-A352-27BB-BA17F7CC292B_______________________________'", Lang));

Strings.Insert("SalesInvoice_DR_R5021T_Revenues_CR_R2040B_TaxesIncoming",
	NStr("en='6DFC3C24-05A6-F827-7BE9-947557D5D9D0_______________________'", Lang));

Strings.Insert("SalesInvoice_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions",
	NStr("en='BBFB3A13-2AF2-B3BB-BE25-514241D84871____________________________________________'", Lang));

Strings.Insert("PurchaseInvoice_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors_CurrencyRevaluation",
	NStr("en='2E313181-7C04-1970-016F-FB1B2A5819B5_____________________________________________________________'", Lang));

Strings.Insert("ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R2020B_AdvancesFromCustomers",
	NStr("en='5F8FC0F1-C63E-DDA6-6F29-911B5AFE3C62_____________________________________________'", Lang));

Strings.Insert("SalesInvoice_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions_CurrencyRevaluation",
	NStr("en='A9E0760A-C0CE-DE61-17CD-DB5E4252FDC4________________________________________________________________'", Lang));

Strings.Insert("SalesInvoice_DR_R2021B_CustomersTransactions_CR_R5021T_Revenues_CurrencyRevaluation",
	NStr("en='3D8578DD-CC10-20DE-EA4C-C63B263177C1___________________________________________________'", Lang));

Strings.Insert("PurchaseInvoice_DR_R4050B_StockInventory_R5022T_Expenses_CR_R1021B_VendorsTransactions_CurrencyRevaluation",
	NStr("en='98CA4712-F25A-1F0C-C775-5454F762EAA0__________________________________________________________________________'", Lang));

Strings.Insert("ForeignCurrencyRevaluation_DR_R2020B_AdvancesFromCustomers_CR_R5021T_Revenues",
	NStr("en='FC31E6D4-F0C8-2514-452A-A52C740E238C_____________________________________________'", Lang));

Strings.Insert("ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R3010B_CashOnHand",
	NStr("en='ADB63049-3EEB-53D2-2261-18E86F804814__________________________________'", Lang));
	
Strings.Insert("ForeignCurrencyRevaluation_DR_R3010B_CashOnHand_CR_R5021T_Revenues",
	NStr("en='26D6E9B9-F3A6-0ED2-2102-21DC617B3277__________________________________'", Lang));

Strings.Insert("ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R1021B_VendorsTransactions",
	NStr("en='565365A5-8F9D-01D1-1C4E-EB7BB8CA3EA2___________________________________________'", Lang));
	
Strings.Insert("ForeignCurrencyRevaluation_DR_R1021B_VendorsTransactions_CR_R5021T_Revenues",
	NStr("en='252C0AA0-80CA-84FB-B852-2AE8E88813E7___________________________________________'", Lang));
	
Strings.Insert("ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R9510B_SalaryPayment",
	NStr("en='59593238-6565-259E-E04D-D7412E8FEEB1_____________________________________'", Lang));
	
Strings.Insert("ForeignCurrencyRevaluation_DR_R9510B_SalaryPayment_CR_R5021T_Revenues",
	NStr("en='C789175E-35C9-AB3E-E931-177003C19328_____________________________________'", Lang));
	
Strings.Insert("ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R1020B_AdvancesToVendors",
	NStr("en='3F30CAF3-0A76-7AD9-9F55-51451A3A1641_________________________________________'", Lang));
	
Strings.Insert("ForeignCurrencyRevaluation_DR_R1020B_AdvancesToVendors_CR_R5021T_Revenues",
	NStr("en='C0B821E2-CB5E-7511-1864-4F3C7C3100E6________________________________________'", Lang));
	
Strings.Insert("ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R2021B_CustomersTransactions",
	NStr("en='F7054A61-9598-954C-CF32-2DF2540B8DE7_____________________________________________'", Lang));
	
Strings.Insert("ForeignCurrencyRevaluation_DR_R2021B_CustomersTransactions_CR_R5021T_Revenues",
	NStr("en='1E7211C5-D690-35B3-3E7B-B81A4865FB18_____________________________________________'", Lang));
	
Strings.Insert("ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R3015B_CashAdvance",
	NStr("en='E15BA479-D02A-ADA3-3F81-19F1013F8DA8___________________________________'", Lang));
	
Strings.Insert("ForeignCurrencyRevaluation_DR_R3015B_CashAdvance_CR_R5021T_Revenues",
	NStr("en='960A7364-BEEA-010C-CD1A-A292B512D874___________________________________'", Lang));
	
Strings.Insert("ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R3027B_EmployeeCashAdvance",
	NStr("en='414A1A12-0777-E0A6-6794-44E3706BE9DE___________________________________________'", Lang));
	
Strings.Insert("ForeignCurrencyRevaluation_DR_R3027B_EmployeeCashAdvance_CR_R5021T_Revenues",
	NStr("en='40E97E80-CE1F-72F8-86A1-1F7C7F284A01___________________________________________'", Lang));
	
Strings.Insert("ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R5015B_OtherPartnersTransactions",
	NStr("en='6895D844-7BE2-A319-9828-8A327A4DF4A2_________________________________________________'", Lang));
	
Strings.Insert("ForeignCurrencyRevaluation_DR_R5015B_OtherPartnersTransactions_CR_R5021T_Revenues",
	NStr("en='B5097FB9-20CA-AE24-4149-9792F8867FB0_________________________________________________'", Lang));
	
Strings.Insert("ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R8510B_BookValueOfFixedAsset",
	NStr("en='3CCAC90A-4D19-E043-392E-EE9DC5C9AA42_____________________________________________'", Lang));
	
Strings.Insert("ForeignCurrencyRevaluation_DR_R8510B_BookValueOfFixedAsset_CR_R5021T_Revenues",
	NStr("en='4A006432-EDA4-F980-092E-E41BDEBD7D33_____________________________________________'", Lang));

Strings.Insert("BankReceipt_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions",
	NStr("en='9DFD9B3C-9871-1976-6FB6-625B1760E998___________________________________________'", Lang));

Strings.Insert("CashPayment_DR_R1020B_AdvancesToVendors_R1021B_VendorsTransactions_CR_R3010B_CashOnHand",
	NStr("en='99AA294E-3414-EEBF-F836-61263FDE8B77_______________________________________________________'", Lang));

Strings.Insert("CashPayment_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors",
	NStr("en='0D47E21F-D6CF-5EBA-A512-20C69512CF30_____________________________________'", Lang));
	
Strings.Insert("CashReceipt_DR_R3010B_CashOnHand_CR_R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions",
	NStr("en='0B272409-76F8-A3F3-38F2-2A957C8C1B12_____________________________________________________________'", Lang)); 
	
Strings.Insert("CashReceipt_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions",
	NStr("en='B4E703C9-2E5B-92EC-C027-71216ABE35B4___________________________________________'", Lang));
	
Strings.Insert("CashExpense_DR_R5022T_Expenses_CR_R3010B_CashOnHand",
	NStr("en='74230ED3-D310-3E79-919A-A427ABA738A5___________________'", Lang));
	
Strings.Insert("CashRevenue_DR_R3010B_CashOnHand_CR_R5021_Revenues",
	NStr("en='A4D5D19F-CF03-EAAD-D2B8-8DD3FC192DB0__________________'", Lang));
	
Strings.Insert("DebitNote_DR_R1021B_VendorsTransactions_CR_R5021_Revenues",
	NStr("en='E1967B71-4C50-F893-3247-7BC94A377C7E_________________________'", Lang));

Strings.Insert("DebitNote_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors",
	NStr("en='7B249F9C-AEBD-0E70-0C1B-B0938BD966B5___________________________________'", Lang));

Strings.Insert("DebitNote_DR_R2021B_CustomersTransactions_CR_R5021_Revenues",
	NStr("en='56C6639E-C648-903B-BD2B-B8EA0A5C51B0___________________________'", Lang));

Strings.Insert("DebitNote_DR_R5015B_OtherPartnersTransactions_CR_R5021_Revenues",
	NStr("en='812FA080-6E20-7502-26EC-CBB48E33B2CE_______________________________'", Lang));
	
Strings.Insert("CreditNote_DR_R5022T_Expenses_CR_R2021B_CustomersTransactions",
	NStr("en='0BCBB721-D920-06C3-3AC6-6103B6E48E86_____________________________'", Lang));
	
Strings.Insert("CreditNote_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions",
	NStr("en='1E25517D-6D4E-FD52-230C-C7F58D664F24__________________________________________'", Lang));

Strings.Insert("CreditNote_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors",
	NStr("en='9ACC873B-F4E8-6E13-3D8F-FBB21E8163F6____________________________________'", Lang));
	
Strings.Insert("CreditNote_DR_R5022T_Expenses_CR_R1021B_VendorsTransactions",
	NStr("en='E2E6E93F-9B7B-72C7-7A7A-A30743868957___________________________'", Lang));

Strings.Insert("CreditNote_DR_R5022T_Expenses_CR_R5015B_OtherPartnersTransactions",
	NStr("en='ED805170-0FB4-0046-64E5-5BE41E7D5EF7_________________________________'", Lang));

Strings.Insert("MoneyTransfer_DR_R3010B_CashOnHand_CR_R3010B_CashOnHand",
	NStr("en='FEDF768B-1C91-739D-DAF4-4FC043271593_______________________'", Lang));
	
Strings.Insert("MoneyTransfer_DR_R3010B_CashOnHand_CR_R3021B_CashInTransit",
	NStr("en='DE554D0F-8572-E91F-F20D-DA709FCB708E__________________________'", Lang));

Strings.Insert("MoneyTransfer_DR_R3021B_CashInTransit_CR_R3010B_CashOnHand",
	NStr("en='3B8EEC66-D5C1-6B3C-CD46-6997B4362CA1__________________________'", Lang));

Strings.Insert("MoneyTransfer_DR_R3021B_CashInTransit_CR_R5021T_Revenues",
	NStr("en='0A57FDDE-E62A-2F1D-DA9A-AA9EDA743F97________________________'", Lang));

Strings.Insert("MoneyTransfer_DR_R5022T_Expenses_CR_R3021B_CashInTransit",
	NStr("en='8495BAE7-9615-10F0-0859-9D620CBBC2A0________________________'", Lang));

Strings.Insert("CommissioningOfFixedAsset_DR_R8510B_BookValueOfFixedAsset_CR_R4050B_StockInventory",
	NStr("en='2BD545A4-9F79-F187-72F0-057023D0938C__________________________________________________'", Lang));

Strings.Insert("DecommissioningOfFixedAsset_DR_R4050B_StockInventory_CR_R8510B_BookValueOfFixedAsset",
	NStr("en='7BF5B39A-F7A0-A245-53F4-443BE74CFD79____________________________________________________'", Lang));

Strings.Insert("ModernizationOfFixedAsset_DR_R8510B_BookValueOfFixedAsset_CR_R4050B_StockInventory",
	NStr("en='82DE6302-7930-03E8-8965-57116623E1AD__________________________________________________'", Lang));

Strings.Insert("ModernizationOfFixedAsset_DR_R4050B_StockInventory_CR_R8510B_BookValueOfFixedAsset",
	NStr("en='E70079FB-CEC0-9BDA-A246-65CB2F8A27C9__________________________________________________'", Lang));

Strings.Insert("FixedAssetTransfer_DR_R8510B_BookValueOfFixedAsset_CR_R8510B_BookValueOfFixedAsset",
	NStr("en='BBC85647-ACB3-6578-8844-40119ACCF2BA__________________________________________________'", Lang));

Strings.Insert("DepreciationCalculation_DR_R5022T_Expenses_CR_DepreciationFixedAsset",
	NStr("en='52965161-2F53-FC15-55BB-B3232A5C541F____________________________________'", Lang));

Strings.Insert("BankPayment_DR_R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions_CR_R3010B_CashOnHand",
	NStr("en='501A058B-BDE4-EC26-6A3D-D033F1287EC6_____________________________________________________________'", Lang));

Strings.Insert("BankPayment_DR_R2021B_CustomersTransactions_CR_R2020B_AdvancesFromCustomers",
	NStr("en='B918D93C-C4AF-CCC6-656C-C537196747C9___________________________________________'", Lang));

Strings.Insert("BankPayment_DR_R5015B_OtherPartnersTransactions_CR_R3010B_CashOnHand",
	NStr("en='D4CCEEFB-C9C3-0299-9F91-1A42A9BD2206____________________________________'", Lang));

Strings.Insert("CashPayment_DR_R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions_CR_R3010B_CashOnHand",
	NStr("en='94D3BD77-FCDC-714A-A9AF-F3F0162CD5AD_____________________________________________________________'", Lang));

Strings.Insert("CashPayment_DR_R2021B_CustomersTransactions_CR_R2020B_AdvancesFromCustomers",
	NStr("en='5F252199-4C61-F587-7548-822329A9C06B___________________________________________'", Lang));

Strings.Insert("CashPayment_DR_R9510B_SalaryPayment_CR_R3010B_CashOnHand",
	NStr("en='1C9B649B-4A37-9CF9-9B8D-D58514CF4249________________________'", Lang));

Strings.Insert("CashPayment_DR_R3027B_EmployeeCashAdvance_CR_R3010B_CashOnHand",
	NStr("en='B1A4363C-2E41-E766-6B4E-EC2FFCD99C71______________________________'", Lang));

Strings.Insert("BankReceipt_DR_R3010B_CashOnHand_CR_R1020B_AdvancesToVendors_R1021B_VendorsTransactions",
	NStr("en='09FF34D2-23F4-48F1-1F14-4491FA4FA83C_______________________________________________________'", Lang));

Strings.Insert("BankReceipt_DR_R1020B_AdvancesToVendors_CR_R1021B_VendorsTransactions",
	NStr("en='96891E31-75C7-CC10-0C10-051182E55003_____________________________________'", Lang));

Strings.Insert("CashReceipt_DR_R3010B_CashOnHand_CR_R1020B_AdvancesToVendors_R1021B_VendorsTransactions",
	NStr("en='2A789CE5-9A3B-3A4D-D00D-D707B6B28B15_______________________________________________________'", Lang));

Strings.Insert("CashReceipt_DR_R1020B_AdvancesToVendors_CR_R1021B_VendorsTransactions",
	NStr("en='2747B301-676E-05B3-36B5-54CBBA413316_____________________________________'", Lang));

Strings.Insert("BankPayment_DR_R3021B_CashInTransitIncoming_CR_R3010B_CashOnHand_CashTransferOrder",
	NStr("en='37DC2E19-EBD6-C4F6-6FB9-95F7F5D0E0C4________________________________________________'", Lang));

Strings.Insert("BankPayment_DR_R3021B_CashInTransitIncoming_CR_R3010B_CashOnHand_CurrencyExchange",
	NStr("en='37164626-9262-6A38-8161-1A625548ABA1____________________________________________________'", Lang));

Strings.Insert("BankPayment_DR_R5022T_Expenses_CR_R3010B_CashOnHand",
	NStr("en='31EF64B5-4C81-E08B-BBE9-97A8256BF936___________________'", Lang));

Strings.Insert("BankPayment_DR_R9510B_SalaryPayment_CR_R3010B_CashOnHand",
	NStr("en='9F137865-8AAE-49A3-30C1-19F0C01DE3E8________________________'", Lang));

Strings.Insert("BankPayment_DR_R3027B_EmployeeCashAdvance_CR_R3010B_CashOnHand",
	NStr("en='B941D19F-B05A-97C1-10A6-668E389B8166______________________________'", Lang));

Strings.Insert("CashPayment_DR_R3021B_CashInTransitIncoming_CR_R3010B_CashOnHand_CashTransferOrder",
	NStr("en='80020829-B528-3E71-17A3-3EA4AD559314________________________________________________'", Lang));

Strings.Insert("CashPayment_DR_R5015B_OtherPartnersTransactions_CR_R3010B_CashOnHand",
	NStr("en='139DC35D-652C-3C9D-D49A-A71683431FA7____________________________________'", Lang));

Strings.Insert("BankReceipt_DR_R3010B_CashOnHand_CR_R3021B_CashInTransitIncoming_CashTransferOrder",
	NStr("en='E1D06307-7E8D-DE23-3B5D-D44B00F132E6________________________________________________'", Lang));

Strings.Insert("BankReceipt_DR_R3010B_CashOnHand_CR_R3021B_CashInTransitIncoming_CurrencyExchange",
	NStr("en='C6CAD88F-E620-631E-ECE2-2307960C8A84____________________________________________________'", Lang));

Strings.Insert("BankReceipt_DR_R3021B_CashInTransit_CR_R5021T_Revenues",
	NStr("en='96B4A7E0-15FC-C1BD-D13B-B0D03958574A______________________'", Lang));

Strings.Insert("BankReceipt_DR_R5022T_Expenses_CR_R3021B_CashInTransit",
	NStr("en='AF468973-372A-4FA1-1760-0BC6FA978A2E______________________'", Lang));

Strings.Insert("BankReceipt_DR_R3010B_CashOnHand_CR_R5015B_OtherPartnersTransactions",
	NStr("en='3C1685D1-EDEE-0619-9887-7ADEEF8069E7____________________________________'", Lang));

Strings.Insert("BankReceipt_DR_R3010B_CashOnHand_CR_R5021_Revenues",
	NStr("en='035344C9-DC6D-F602-2C21-17D5685317C8__________________'", Lang));

Strings.Insert("CashReceipt_DR_R3010B_CashOnHand_CR_R3021B_CashInTransitIncoming_CashTransferOrder",
	NStr("en='D7F13B54-C0C8-D2AF-F132-258C22D9B903________________________________________________'", Lang));

Strings.Insert("CashReceipt_DR_R3010B_CashOnHand_CR_R5015B_OtherPartnersTransactions",
	NStr("en='EE0DB7A7-5EAD-CF1E-E060-0374F72B6851____________________________________'", Lang));

Strings.Insert("Payroll_DR_R5022T_Expenses_CR_R9510B_SalaryPayment_Accrual",
	NStr("en='EB2600C7-2FE0-1D70-0AD6-629FF963E555____________________________'", Lang));
	
Strings.Insert("Payroll_DR_R9510B_SalaryPayment_CR_R5015B_OtherPartnersTransactions_Taxes",
	NStr("en='6D16A8AF-CEE0-83F2-286D-D010DC5EB3AB___________________________________________'", Lang));

Strings.Insert("Payroll_DR_R5022T_Expenses_CR_R5015B_OtherPartnersTransactions_Taxes",
	NStr("en='D7DAA285-1EB0-5B53-3E75-5496CBEBF3BE______________________________________'", Lang));
	
Strings.Insert("Payroll_DR_R9510B_SalaryPayment_CR_R5021T_Revenues_Deduction_IsRevenue",
	NStr("en='9B559F7F-E68D-1173-3075-5C0E0E002521_________________________________________'", Lang));
	
Strings.Insert("Payroll_DR_R5022T_Expenses_CR_R9510B_SalaryPayment_Deduction_IsNotRevenue",
	NStr("en='3C754268-175B-C567-7DD7-719FB2B4D99D_____________________________________________'", Lang));
	
Strings.Insert("Payroll_DR_R9510B_SalaryPayment_CR_R3027B_EmployeeCashAdvance",
	NStr("en='A10C8AEC-53E2-D045-5BD6-6029F48259C3_____________________________'", Lang));

Strings.Insert("DebitCreditNote_R5020B_PartnersBalance",
	NStr("en='22B66A4B-8FFC-4389-97FC-C2A1DE9CF08D____'", Lang));

Strings.Insert("DebitCreditNote_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions_Offset",
	NStr("en='92CD2A6F-9E9A-46FE-E412-2EA2A4B77948________________________________________________________'", Lang));

Strings.Insert("DebitCreditNote_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors_Offset",
	NStr("en='D4E8D5BE-F9A8-176A-A2DB-B66B14756714__________________________________________________'", Lang));

Strings.Insert("ExpenseAccruals_DR_R5022T_Expenses_CR_R6070T_OtherPeriodsExpenses",
	NStr("en='FCA4D443-ABC6-7884-4EF1-17BC73E36083_________________________________'", Lang));

Strings.Insert("RevenueAccruals_DR_R6080T_OtherPeriodsRevenues_CR_R5021T_Revenues",
	NStr("en='077D0A3A-00C8-00DC-C445-5BA0114262DA_________________________________'", Lang));

Strings.Insert("ExpenseAccruals_DR_R6070T_OtherPeriodsExpenses_CR_R5022T_Expenses",
	NStr("en='6686EE96-3E6F-F0E1-1401-1EDCE5D16053_________________________________'", Lang));
	
Strings.Insert("RevenueAccruals_DR_R5021T_Revenues_CR_R6080T_OtherPeriodsRevenues",
	NStr("en='98D3E7DD-F64D-5454-40F5-5E32CE0798B8_________________________________'", Lang));
	
Strings.Insert("EmployeeCashAdvance_DR_R5022T_Expenses_CR_R3027B_EmployeeCashAdvance",
	NStr("en='D1FB5BA8-4E2E-0807-72CA-A5A43AA410F1____________________________________'", Lang));
	
Strings.Insert("EmployeeCashAdvance_DR_R1021B_VendorsTransactions_CR_R3027B_EmployeeCashAdvance",
	NStr("en='D1D1FC81-D741-FC4E-E5AE-E1017688ECE3_______________________________________________'", Lang));

#EndRegion

#Region InternalCommands
	Strings.Insert("InternalCommands_SetNotActive", NStr("en='657545D3-D162-833D-D1DE-E28CB2E44290'", Lang));
	Strings.Insert("InternalCommands_SetNotActive_Check", NStr("en='D465012D-432D-EDAD-D922-2CB12214E7C7'", Lang));
	Strings.Insert("InternalCommands_ShowNotActive", NStr("en='5794DDBB-45DF-68A1-1B12-2081E43B6E15'", Lang));
	Strings.Insert("InternalCommands_ShowNotActive_Check", NStr("en='412150AF-E4DF-AE64-404F-FB8725BBA403'", Lang));
#EndRegion
	
#Region FormulaEditor
	Strings.Insert("FormulaEditor_Delimiters", NStr("en='2EDC6CDD-23DE-AED6-6124-4EAC45AA2400'", Lang));
	
	Strings.Insert("FormulaEditor_Space", NStr("en='859FB859-0DFF-4683-383E-EFEC670F7ED0'", Lang));
	Strings.Insert("FormulaEditor_Operators", NStr("en='5B768A89-F056-0EB7-7193-367FB8831D7D'", Lang));
	
	Strings.Insert("FormulaEditor_LogicalOperatorsAndConstants", NStr("en='BDF9683D-068F-21A1-1D94-4FC8BEA35F9C'", Lang));
	
	Strings.Insert("FormulaEditor_AND", NStr("en='572A41CC-F34D-3C1C-C2CD-DBA0A8295AA0'", Lang));
	Strings.Insert("FormulaEditor_OR", NStr("en='56D43312-F637-D666-6708-83604ECC4FAA'", Lang));
	Strings.Insert("FormulaEditor_NOT", NStr("en='51EA6C8A-B57D-8A98-855A-AE1937561E45'", Lang));
	Strings.Insert("FormulaEditor_TRUE", NStr("en='35B5FE3F-54FC-AF67-7E52-263E08FAA6F2'", Lang));
	Strings.Insert("FormulaEditor_FALSE", NStr("en='D2A2323A-EE8C-5EC0-0E28-8BAA7661597D'", Lang));
	
	Strings.Insert("FormulaEditor_NumericFunctions", NStr("en='A0BB573C-CB58-E0FC-C5C4-4DABE7446D42'", Lang));
	
	Strings.Insert("FormulaEditor_Max", NStr("en='9A1CADB0-0255-7A84-47EE-E5B464517541'", Lang));
	Strings.Insert("FormulaEditor_Min", NStr("en='C25B0A8E-0574-88C2-26F6-6D8DC7EF6B35'", Lang));
	Strings.Insert("FormulaEditor_Round", NStr("en='6BFE2716-74CD-AF22-247D-D507D30DC745'", Lang));
	Strings.Insert("FormulaEditor_Int", NStr("en='1A351979-0C36-64D2-25C0-009DF1DC0C38'", Lang));
	
	Strings.Insert("FormulaEditor_StringFunctions", NStr("en='88ED036F-0F32-0A51-1AA3-31134E305E95'", Lang));
	
	Strings.Insert("FormulaEditor_String", NStr("en='B0209BAD-DAAC-872F-F4B8-849A756DA033'", Lang));
	Strings.Insert("FormulaEditor_Upper", NStr("en='B04DF94E-9076-4969-9D32-2F26FD80C2E3'", Lang));
	Strings.Insert("FormulaEditor_Left", NStr("en='EA980BD3-456F-234F-FEAF-F6E1E2B4FC95'", Lang));
	Strings.Insert("FormulaEditor_Lower", NStr("en='2E4B8288-BD31-578E-E2C6-6FAA28197E13'", Lang));
	Strings.Insert("FormulaEditor_Right", NStr("en='953EF82B-3332-AD23-39CF-FAD09D67398B'", Lang));
	Strings.Insert("FormulaEditor_TrimL", NStr("en='44C5DC25-2F57-4708-863A-AAC1FD99F83D'", Lang));
	Strings.Insert("FormulaEditor_TrimAll", NStr("en='B8CD1200-971C-6BEF-F3E8-8F5B472E82C7'", Lang));
	Strings.Insert("FormulaEditor_TrimR", NStr("en='2347E8D7-DD66-CC8B-B3B5-580CEF469608'", Lang));
	Strings.Insert("FormulaEditor_Title", NStr("en='0AE09763-68F9-E86D-D541-101FD52E766C'", Lang));
	Strings.Insert("FormulaEditor_StrReplace", NStr("en='D3590594-87F9-1466-66C3-34D7C858E3FF'", Lang));
	Strings.Insert("FormulaEditor_StrLen", NStr("en='B834FACE-52DA-C86D-D799-9A0375ABD46C'", Lang));
	
	Strings.Insert("FormulaEditor_OtherFunctions", NStr("en='D886B704-9CA0-A2DD-D59F-F0C6A6FC75C6'", Lang));
	
	Strings.Insert("FormulaEditor_Condition", NStr("en='4B5E0C5B-EF87-CD8E-ED43-36ABB6936AF8'", Lang));
	Strings.Insert("FormulaEditor_PredefinedValue", NStr("en='6AC3A806-8DBB-7E94-4156-6A9FEB40CA80'", Lang));
	Strings.Insert("FormulaEditor_ValueIsFilled", NStr("en='DCE2F48C-86FE-3624-4938-86711D71EE9B'", Lang));
	Strings.Insert("FormulaEditor_Format", NStr("en='89896050-61AA-6764-4EE8-83F47A9A614D'", Lang));
	
	Strings.Insert("FormulaEditor_Error01", NStr("en='BC891174-5DB7-B9B1-14FD-D6B5499A8DE6_________________'", Lang));
	Strings.Insert("FormulaEditor_Error02", NStr("en='7D02F3F2-16E5-5CB5-5A49-9089BAC32DED'", Lang));
	Strings.Insert("FormulaEditor_Error03", NStr("en='0EDD8B61-6A82-FBC0-00F3-36F5EECD3379_________________________________'", Lang));
	Strings.Insert("FormulaEditor_Error04", NStr("en='2E3AE3F7-7C54-E65E-E126-6F0395789E6B'", Lang));
	Strings.Insert("FormulaEditor_Error05", NStr("en='2E77525A-E535-4109-9EE3-3F480130A740'", Lang));
	Strings.Insert("FormulaEditor_Msg01", NStr("en='EAFA7807-E83C-8289-9871-1A5CFA1EED49'", Lang));
	
#EndRegion

#Region GroupPhotoUploading
	Strings.Insert("GPU_AnalizeFolder", NStr("en='542130DE-DC2A-B97A-A839-9210F8B09179'", Lang));
	Strings.Insert("GPU_Load_SendToDrive", NStr("en='F491470B-F506-C4ED-D759-971C0ECF9609'", Lang));
	Strings.Insert("GPU_Load_SaveInBase", NStr("en='0E9AD496-74E5-A52C-CFF6-60C9B093546F'", Lang));
	Strings.Insert("GPU_CheckingFilesExist", NStr("en='1C75FCA3-5230-4878-8BB2-258AB13F0E80'", Lang));
#EndRegion

#Region AuditLock
	Strings.Insert("AuditLock_001", NStr("en='D0ABA263-DF8D-8B06-62C9-9038F500C8D8'", Lang));
	Strings.Insert("AuditLock_002", NStr("en='6EAB906A-10B9-47CF-FB62-23DA35E19083'", Lang));
	Strings.Insert("AuditLock_003", NStr("en='079F1273-6160-5A8C-C336-6F5D3412D7C7'", Lang));
	Strings.Insert("AuditLock_004", NStr("en='22D666F3-E53D-AB3A-A816-62B3A4374F5D'", Lang));	
#EndRegion
	
	Return Strings;
EndFunction
