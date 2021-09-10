#Region Internal

Function RolesSet() Export
	Settings = New Map();

#Region HTTPService
	HTTPService = New Array();
	HTTPService.Add(Enums.Rights.Use);
#EndRegion
	Settings.Insert(Enums.MetadataTypes.HTTPService, HTTPService);

#Region WebService
	WebService = New Array();
	WebService.Add(Enums.Rights.Use);
#EndRegion
	Settings.Insert(Enums.MetadataTypes.WebService, WebService);

#Region BusinessProcess
	BusinessProcess = New Array();
	BusinessProcess.Add(Enums.Rights.Read);
	BusinessProcess.Add(Enums.Rights.Insert);
	BusinessProcess.Add(Enums.Rights.Update);
	BusinessProcess.Add(Enums.Rights.Delete);
	BusinessProcess.Add(Enums.Rights.View);
	BusinessProcess.Add(Enums.Rights.InteractiveInsert);
	BusinessProcess.Add(Enums.Rights.Edit);
	BusinessProcess.Add(Enums.Rights.InteractiveDelete);
	BusinessProcess.Add(Enums.Rights.InteractiveSetDeletionMark);
	BusinessProcess.Add(Enums.Rights.InteractiveClearDeletionMark);
	BusinessProcess.Add(Enums.Rights.InteractiveDeleteMarked);
	BusinessProcess.Add(Enums.Rights.InputByString);
	BusinessProcess.Add(Enums.Rights.InteractiveActivate);
	BusinessProcess.Add(Enums.Rights.Start);
	BusinessProcess.Add(Enums.Rights.InteractiveStart);
	BusinessProcess.Add(Enums.Rights.ReadDataHistory);
	BusinessProcess.Add(Enums.Rights.ReadDataHistoryOfMissingData);
	BusinessProcess.Add(Enums.Rights.UpdateDataHistory);
	BusinessProcess.Add(Enums.Rights.UpdateDataHistoryOfMissingData);
	BusinessProcess.Add(Enums.Rights.UpdateDataHistorySettings);
	BusinessProcess.Add(Enums.Rights.UpdateDataHistoryVersionComment);
	BusinessProcess.Add(Enums.Rights.ViewDataHistory);
	BusinessProcess.Add(Enums.Rights.EditDataHistoryVersionComment);
	BusinessProcess.Add(Enums.Rights.SwitchToDataHistoryVersion);
#EndRegion
	Settings.Insert(Enums.MetadataTypes.BusinessProcess, BusinessProcess);

#Region Catalog
	Catalog = New Array();
	Catalog.Add(Enums.Rights.Read);
	Catalog.Add(Enums.Rights.Insert);
	Catalog.Add(Enums.Rights.Update);
	Catalog.Add(Enums.Rights.Delete);
	Catalog.Add(Enums.Rights.View);
	Catalog.Add(Enums.Rights.InteractiveInsert);
	Catalog.Add(Enums.Rights.Edit);
	Catalog.Add(Enums.Rights.InteractiveDelete);
	Catalog.Add(Enums.Rights.InteractiveSetDeletionMark);
	Catalog.Add(Enums.Rights.InteractiveClearDeletionMark);
	Catalog.Add(Enums.Rights.InteractiveDeleteMarked);
	Catalog.Add(Enums.Rights.InputByString);
	Catalog.Add(Enums.Rights.InteractiveDeletePredefinedData);
	Catalog.Add(Enums.Rights.InteractiveSetDeletionMarkPredefinedData);
	Catalog.Add(Enums.Rights.InteractiveClearDeletionMarkPredefinedData);
	Catalog.Add(Enums.Rights.InteractiveDeleteMarkedPredefinedData);
	Catalog.Add(Enums.Rights.ReadDataHistory);
	Catalog.Add(Enums.Rights.ReadDataHistoryOfMissingData);
	Catalog.Add(Enums.Rights.UpdateDataHistory);
	Catalog.Add(Enums.Rights.UpdateDataHistoryOfMissingData);
	Catalog.Add(Enums.Rights.UpdateDataHistorySettings);
	Catalog.Add(Enums.Rights.UpdateDataHistoryVersionComment);
	Catalog.Add(Enums.Rights.ViewDataHistory);
	Catalog.Add(Enums.Rights.EditDataHistoryVersionComment);
	Catalog.Add(Enums.Rights.SwitchToDataHistoryVersion);
#EndRegion
	Settings.Insert(Enums.MetadataTypes.Catalog, Catalog);
#Region Document
	Document = New Array();
	Document.Add(Enums.Rights.Read);
	Document.Add(Enums.Rights.Insert);
	Document.Add(Enums.Rights.Update);
	Document.Add(Enums.Rights.Delete);
	Document.Add(Enums.Rights.Posting);
	Document.Add(Enums.Rights.UndoPosting);
	Document.Add(Enums.Rights.View);
	Document.Add(Enums.Rights.InteractiveInsert);
	Document.Add(Enums.Rights.Edit);
	Document.Add(Enums.Rights.InteractiveDelete);
	Document.Add(Enums.Rights.InteractiveSetDeletionMark);
	Document.Add(Enums.Rights.InteractiveClearDeletionMark);
	Document.Add(Enums.Rights.InteractiveDeleteMarked);
	Document.Add(Enums.Rights.InteractivePosting);
	Document.Add(Enums.Rights.InteractivePostingRegular);
	Document.Add(Enums.Rights.InteractiveUndoPosting);
	Document.Add(Enums.Rights.InteractiveChangeOfPosted);
	Document.Add(Enums.Rights.InputByString);
	Document.Add(Enums.Rights.ReadDataHistory);
	Document.Add(Enums.Rights.ReadDataHistoryOfMissingData);
	Document.Add(Enums.Rights.UpdateDataHistory);
	Document.Add(Enums.Rights.UpdateDataHistoryOfMissingData);
	Document.Add(Enums.Rights.UpdateDataHistorySettings);
	Document.Add(Enums.Rights.UpdateDataHistoryVersionComment);
	Document.Add(Enums.Rights.ViewDataHistory);
	Document.Add(Enums.Rights.EditDataHistoryVersionComment);
	Document.Add(Enums.Rights.SwitchToDataHistoryVersion);
#EndRegion
	Settings.Insert(Enums.MetadataTypes.Document, Document);

#Region DocumentJournal
	DocumentJournal = New Array();
	DocumentJournal.Add(Enums.Rights.Read);
	DocumentJournal.Add(Enums.Rights.View);
#EndRegion
	Settings.Insert(Enums.MetadataTypes.DocumentJournal, DocumentJournal);

#Region Task
	Task = New Array();
	Task.Add(Enums.Rights.Read);
	Task.Add(Enums.Rights.Insert);
	Task.Add(Enums.Rights.Update);
	Task.Add(Enums.Rights.Delete);
	Task.Add(Enums.Rights.View);
	Task.Add(Enums.Rights.InteractiveInsert);
	Task.Add(Enums.Rights.Edit);
	Task.Add(Enums.Rights.InteractiveDelete);
	Task.Add(Enums.Rights.InteractiveSetDeletionMark);
	Task.Add(Enums.Rights.InteractiveClearDeletionMark);
	Task.Add(Enums.Rights.InteractiveDeleteMarked);
	Task.Add(Enums.Rights.InputByString);
	Task.Add(Enums.Rights.InteractiveActivate);
	Task.Add(Enums.Rights.Execute);
	Task.Add(Enums.Rights.InteractiveExecute);
	Task.Add(Enums.Rights.ReadDataHistory);
	Task.Add(Enums.Rights.ReadDataHistoryOfMissingData);
	Task.Add(Enums.Rights.UpdateDataHistory);
	Task.Add(Enums.Rights.UpdateDataHistoryOfMissingData);
	Task.Add(Enums.Rights.UpdateDataHistorySettings);
	Task.Add(Enums.Rights.UpdateDataHistoryVersionComment);
	Task.Add(Enums.Rights.ViewDataHistory);
	Task.Add(Enums.Rights.EditDataHistoryVersionComment);
	Task.Add(Enums.Rights.SwitchToDataHistoryVersion);
#EndRegion
	Settings.Insert(Enums.MetadataTypes.Task, Task);

#Region Constant
	Constant = New Array();
	Constant.Add(Enums.Rights.Read);
	Constant.Add(Enums.Rights.Update);
	Constant.Add(Enums.Rights.View);
	Constant.Add(Enums.Rights.Edit);
	Constant.Add(Enums.Rights.ReadDataHistory);
	Constant.Add(Enums.Rights.UpdateDataHistory);
	Constant.Add(Enums.Rights.UpdateDataHistorySettings);
	Constant.Add(Enums.Rights.UpdateDataHistoryVersionComment);
	Constant.Add(Enums.Rights.ViewDataHistory);
	Constant.Add(Enums.Rights.EditDataHistoryVersionComment);
	Constant.Add(Enums.Rights.SwitchToDataHistoryVersion);
#EndRegion
	Settings.Insert(Enums.MetadataTypes.Constant, Constant);

#Region FilterCriterion
	FilterCriterion = New Array();
	FilterCriterion.Add(Enums.Rights.View);
#EndRegion
	Settings.Insert(Enums.MetadataTypes.FilterCriterion, FilterCriterion);

#Region DataProcessor
	DataProcessor = New Array();
	DataProcessor.Add(Enums.Rights.Use);
	DataProcessor.Add(Enums.Rights.View);
#EndRegion
	Settings.Insert(Enums.MetadataTypes.DataProcessor, DataProcessor);

#Region CommonCommand
	CommonCommand = New Array();
	CommonCommand.Add(Enums.Rights.View);
#EndRegion
	Settings.Insert(Enums.MetadataTypes.CommonCommand, CommonCommand);

#Region CommonForm
	CommonForm = New Array();
	CommonForm.Add(Enums.Rights.View);
#EndRegion
	Settings.Insert(Enums.MetadataTypes.CommonForm, CommonForm);

#Region CommonAttribute
	CommonAttribute = New Array();
	CommonAttribute.Add(Enums.Rights.View);
	CommonAttribute.Add(Enums.Rights.Edit);
#EndRegion
	Settings.Insert(Enums.MetadataTypes.CommonAttribute, CommonAttribute);

#Region Report
	Report = New Array();
	Report.Add(Enums.Rights.Use);
	Report.Add(Enums.Rights.View);
#EndRegion
	Settings.Insert(Enums.MetadataTypes.Report, Report);

#Region SessionParameter
	SessionParameter = New Array();
	SessionParameter.Add(Enums.Rights.Get);
	SessionParameter.Add(Enums.Rights.Set);
#EndRegion
	Settings.Insert(Enums.MetadataTypes.SessionParameter, SessionParameter);

#Region ChartOfCalculationTypes
	ChartOfCalculationTypes = New Array();
	ChartOfCalculationTypes.Add(Enums.Rights.Read);
	ChartOfCalculationTypes.Add(Enums.Rights.Insert);
	ChartOfCalculationTypes.Add(Enums.Rights.Update);
	ChartOfCalculationTypes.Add(Enums.Rights.Delete);
	ChartOfCalculationTypes.Add(Enums.Rights.View);
	ChartOfCalculationTypes.Add(Enums.Rights.InteractiveInsert);
	ChartOfCalculationTypes.Add(Enums.Rights.Edit);
	ChartOfCalculationTypes.Add(Enums.Rights.InteractiveDelete);
	ChartOfCalculationTypes.Add(Enums.Rights.InteractiveSetDeletionMark);
	ChartOfCalculationTypes.Add(Enums.Rights.InteractiveClearDeletionMark);
	ChartOfCalculationTypes.Add(Enums.Rights.InteractiveDeleteMarked);
	ChartOfCalculationTypes.Add(Enums.Rights.InputByString);
	ChartOfCalculationTypes.Add(Enums.Rights.InteractiveDeletePredefinedData);
	ChartOfCalculationTypes.Add(Enums.Rights.InteractiveSetDeletionMarkPredefinedData);
	ChartOfCalculationTypes.Add(Enums.Rights.InteractiveClearDeletionMarkPredefinedData);
	ChartOfCalculationTypes.Add(Enums.Rights.InteractiveDeleteMarkedPredefinedData);
	ChartOfCalculationTypes.Add(Enums.Rights.ReadDataHistory);
	ChartOfCalculationTypes.Add(Enums.Rights.ReadDataHistoryOfMissingData);
	ChartOfCalculationTypes.Add(Enums.Rights.UpdateDataHistory);
	ChartOfCalculationTypes.Add(Enums.Rights.UpdateDataHistoryOfMissingData);
	ChartOfCalculationTypes.Add(Enums.Rights.UpdateDataHistorySettings);
	ChartOfCalculationTypes.Add(Enums.Rights.UpdateDataHistoryVersionComment);
	ChartOfCalculationTypes.Add(Enums.Rights.ViewDataHistory);
	ChartOfCalculationTypes.Add(Enums.Rights.EditDataHistoryVersionComment);
	ChartOfCalculationTypes.Add(Enums.Rights.SwitchToDataHistoryVersion);
#EndRegion
	Settings.Insert(Enums.MetadataTypes.ChartOfCalculationTypes, ChartOfCalculationTypes);

#Region ChartOfCharacteristicTypes
	ChartOfCharacteristicTypes = New Array();
	ChartOfCharacteristicTypes.Add(Enums.Rights.Read);
	ChartOfCharacteristicTypes.Add(Enums.Rights.Insert);
	ChartOfCharacteristicTypes.Add(Enums.Rights.Update);
	ChartOfCharacteristicTypes.Add(Enums.Rights.Delete);
	ChartOfCharacteristicTypes.Add(Enums.Rights.View);
	ChartOfCharacteristicTypes.Add(Enums.Rights.InteractiveInsert);
	ChartOfCharacteristicTypes.Add(Enums.Rights.Edit);
	ChartOfCharacteristicTypes.Add(Enums.Rights.InteractiveDelete);
	ChartOfCharacteristicTypes.Add(Enums.Rights.InteractiveSetDeletionMark);
	ChartOfCharacteristicTypes.Add(Enums.Rights.InteractiveClearDeletionMark);
	ChartOfCharacteristicTypes.Add(Enums.Rights.InteractiveDeleteMarked);
	ChartOfCharacteristicTypes.Add(Enums.Rights.InputByString);
	ChartOfCharacteristicTypes.Add(Enums.Rights.InteractiveDeletePredefinedData);
	ChartOfCharacteristicTypes.Add(Enums.Rights.InteractiveSetDeletionMarkPredefinedData);
	ChartOfCharacteristicTypes.Add(Enums.Rights.InteractiveClearDeletionMarkPredefinedData);
	ChartOfCharacteristicTypes.Add(Enums.Rights.InteractiveDeleteMarkedPredefinedData);
	ChartOfCharacteristicTypes.Add(Enums.Rights.ReadDataHistory);
	ChartOfCharacteristicTypes.Add(Enums.Rights.ReadDataHistoryOfMissingData);
	ChartOfCharacteristicTypes.Add(Enums.Rights.UpdateDataHistory);
	ChartOfCharacteristicTypes.Add(Enums.Rights.UpdateDataHistoryOfMissingData);
	ChartOfCharacteristicTypes.Add(Enums.Rights.UpdateDataHistorySettings);
	ChartOfCharacteristicTypes.Add(Enums.Rights.UpdateDataHistoryVersionComment);
	ChartOfCharacteristicTypes.Add(Enums.Rights.ViewDataHistory);
	ChartOfCharacteristicTypes.Add(Enums.Rights.EditDataHistoryVersionComment);
	ChartOfCharacteristicTypes.Add(Enums.Rights.SwitchToDataHistoryVersion);
#EndRegion
	Settings.Insert(Enums.MetadataTypes.ChartOfCharacteristicTypes, ChartOfCharacteristicTypes);

#Region ExchangePlan
	ExchangePlan = New Array();
	ExchangePlan.Add(Enums.Rights.Read);
	ExchangePlan.Add(Enums.Rights.Insert);
	ExchangePlan.Add(Enums.Rights.Update);
	ExchangePlan.Add(Enums.Rights.Delete);
	ExchangePlan.Add(Enums.Rights.View);
	ExchangePlan.Add(Enums.Rights.InteractiveInsert);
	ExchangePlan.Add(Enums.Rights.Edit);
	ExchangePlan.Add(Enums.Rights.InteractiveDelete);
	ExchangePlan.Add(Enums.Rights.InteractiveSetDeletionMark);
	ExchangePlan.Add(Enums.Rights.InteractiveClearDeletionMark);
	ExchangePlan.Add(Enums.Rights.InteractiveDeleteMarked);
	ExchangePlan.Add(Enums.Rights.InputByString);
	ExchangePlan.Add(Enums.Rights.ReadDataHistory);
	ExchangePlan.Add(Enums.Rights.ReadDataHistoryOfMissingData);
	ExchangePlan.Add(Enums.Rights.UpdateDataHistory);
	ExchangePlan.Add(Enums.Rights.UpdateDataHistoryOfMissingData);
	ExchangePlan.Add(Enums.Rights.UpdateDataHistorySettings);
	ExchangePlan.Add(Enums.Rights.UpdateDataHistoryVersionComment);
	ExchangePlan.Add(Enums.Rights.ViewDataHistory);
	ExchangePlan.Add(Enums.Rights.EditDataHistoryVersionComment);
	ExchangePlan.Add(Enums.Rights.SwitchToDataHistoryVersion);
#EndRegion
	Settings.Insert(Enums.MetadataTypes.ExchangePlan, ExchangePlan);

#Region ChartOfAccounts
	ChartOfAccounts = New Array();
	ChartOfAccounts.Add(Enums.Rights.Read);
	ChartOfAccounts.Add(Enums.Rights.Insert);
	ChartOfAccounts.Add(Enums.Rights.Update);
	ChartOfAccounts.Add(Enums.Rights.Delete);
	ChartOfAccounts.Add(Enums.Rights.View);
	ChartOfAccounts.Add(Enums.Rights.InteractiveInsert);
	ChartOfAccounts.Add(Enums.Rights.Edit);
	ChartOfAccounts.Add(Enums.Rights.InteractiveDelete);
	ChartOfAccounts.Add(Enums.Rights.InteractiveSetDeletionMark);
	ChartOfAccounts.Add(Enums.Rights.InteractiveClearDeletionMark);
	ChartOfAccounts.Add(Enums.Rights.InteractiveDeleteMarked);
	ChartOfAccounts.Add(Enums.Rights.InputByString);
	ChartOfAccounts.Add(Enums.Rights.InteractiveDeletePredefinedData);
	ChartOfAccounts.Add(Enums.Rights.InteractiveSetDeletionMarkPredefinedData);
	ChartOfAccounts.Add(Enums.Rights.InteractiveClearDeletionMarkPredefinedData);
	ChartOfAccounts.Add(Enums.Rights.InteractiveDeleteMarkedPredefinedData);
	ChartOfAccounts.Add(Enums.Rights.ReadDataHistory);
	ChartOfAccounts.Add(Enums.Rights.ReadDataHistoryOfMissingData);
	ChartOfAccounts.Add(Enums.Rights.UpdateDataHistory);
	ChartOfAccounts.Add(Enums.Rights.UpdateDataHistoryOfMissingData);
	ChartOfAccounts.Add(Enums.Rights.UpdateDataHistorySettings);
	ChartOfAccounts.Add(Enums.Rights.UpdateDataHistoryVersionComment);
	ChartOfAccounts.Add(Enums.Rights.ViewDataHistory);
	ChartOfAccounts.Add(Enums.Rights.EditDataHistoryVersionComment);
	ChartOfAccounts.Add(Enums.Rights.SwitchToDataHistoryVersion);
#EndRegion
	Settings.Insert(Enums.MetadataTypes.ChartOfAccounts, ChartOfAccounts);

#Region Subsystem
	Subsystem = New Array();
	Subsystem.Add(Enums.Rights.View);
#EndRegion
	Settings.Insert(Enums.MetadataTypes.Subsystem, Subsystem);

#Region Sequence
	Sequence = New Array();
	Sequence.Add(Enums.Rights.Read);
	Sequence.Add(Enums.Rights.Update);
#EndRegion
	Settings.Insert(Enums.MetadataTypes.Sequence, Sequence);

#Region AccountingRegister
	AccountingRegister = New Array();
	AccountingRegister.Add(Enums.Rights.Read);
	AccountingRegister.Add(Enums.Rights.Update);
	AccountingRegister.Add(Enums.Rights.View);
	AccountingRegister.Add(Enums.Rights.Edit);
	AccountingRegister.Add(Enums.Rights.TotalsControl);
#EndRegion
	Settings.Insert(Enums.MetadataTypes.AccountingRegister, AccountingRegister);

#Region AccumulationRegister
	AccumulationRegister = New Array();
	AccumulationRegister.Add(Enums.Rights.Read);
	AccumulationRegister.Add(Enums.Rights.Update);
	AccumulationRegister.Add(Enums.Rights.View);
	AccumulationRegister.Add(Enums.Rights.Edit);
	AccumulationRegister.Add(Enums.Rights.TotalsControl);
#EndRegion
	Settings.Insert(Enums.MetadataTypes.AccumulationRegister, AccumulationRegister);

#Region CalculationRegister
	CalculationRegister = New Array();
	CalculationRegister.Add(Enums.Rights.Read);
	CalculationRegister.Add(Enums.Rights.Update);
	CalculationRegister.Add(Enums.Rights.View);
	CalculationRegister.Add(Enums.Rights.Edit);
#EndRegion
	Settings.Insert(Enums.MetadataTypes.CalculationRegister, CalculationRegister);

#Region InformationRegister
	InformationRegister = New Array();
	InformationRegister.Add(Enums.Rights.Read);
	InformationRegister.Add(Enums.Rights.Update);
	InformationRegister.Add(Enums.Rights.View);
	InformationRegister.Add(Enums.Rights.Edit);
	InformationRegister.Add(Enums.Rights.TotalsControl);
	InformationRegister.Add(Enums.Rights.ReadDataHistory);
	InformationRegister.Add(Enums.Rights.ReadDataHistoryOfMissingData);
	InformationRegister.Add(Enums.Rights.UpdateDataHistory);
	InformationRegister.Add(Enums.Rights.UpdateDataHistoryOfMissingData);
	InformationRegister.Add(Enums.Rights.UpdateDataHistorySettings);
	InformationRegister.Add(Enums.Rights.UpdateDataHistoryVersionComment);
	InformationRegister.Add(Enums.Rights.ViewDataHistory);
	InformationRegister.Add(Enums.Rights.EditDataHistoryVersionComment);
	InformationRegister.Add(Enums.Rights.SwitchToDataHistoryVersion);
#EndRegion
	Settings.Insert(Enums.MetadataTypes.InformationRegister, InformationRegister);

#Region Configuration
	Configuration = New Array();
	Configuration.Add(Enums.Rights.Administration);
	Configuration.Add(Enums.Rights.DataAdministration);
	Configuration.Add(Enums.Rights.UpdateDataBaseConfiguration);
	Configuration.Add(Enums.Rights.ExclusiveMode);
	Configuration.Add(Enums.Rights.ActiveUsers);
	Configuration.Add(Enums.Rights.EventLog);
	Configuration.Add(Enums.Rights.ThinClient);
	Configuration.Add(Enums.Rights.WebClient);
	Configuration.Add(Enums.Rights.MobileClient);
	Configuration.Add(Enums.Rights.ThickClient);
	Configuration.Add(Enums.Rights.ExternalConnection);
	Configuration.Add(Enums.Rights.Automation);
	Configuration.Add(Enums.Rights.TechnicalSpecialistMode);
	Configuration.Add(Enums.Rights.CollaborationSystemInfoBaseRegistration);
	Configuration.Add(Enums.Rights.MainWindowModeNormal);
	Configuration.Add(Enums.Rights.MainWindowModeWorkplace);
	Configuration.Add(Enums.Rights.MainWindowModeEmbeddedWorkplace);
	Configuration.Add(Enums.Rights.MainWindowModeFullscreenWorkplace);
	Configuration.Add(Enums.Rights.MainWindowModeKiosk);
	Configuration.Add(Enums.Rights.AnalyticsSystemClient);
	Configuration.Add(Enums.Rights.SaveUserData);
	Configuration.Add(Enums.Rights.ConfigurationExtensionsAdministration);
	Configuration.Add(Enums.Rights.InteractiveOpenExtDataProcessors);
	Configuration.Add(Enums.Rights.InteractiveOpenExtReports);
	Configuration.Add(Enums.Rights.Output);
#EndRegion

#Region IntegrationService
	IntegrationService = New Array();
	IntegrationService.Add(Enums.Rights.Use);
#EndRegion
	Settings.Insert(Enums.MetadataTypes.IntegrationService, IntegrationService);

	Return Settings;
EndFunction

Function MetaDataObject() Export
	MetaDataObject = New Structure();

	AccumulationRegister = New Structure();
	AccumulationRegister.Insert("AccumulationRegisterRecord", "Record");
	AccumulationRegister.Insert("AccumulationRegisterManager", "Manager");
	AccumulationRegister.Insert("AccumulationRegisterSelection", "Selection");
	AccumulationRegister.Insert("AccumulationRegisterList", "List");
	AccumulationRegister.Insert("AccumulationRegisterRecordSet", "RecordSet");
	AccumulationRegister.Insert("AccumulationRegisterRecordKey", "RecordKey");
	MetaDataObject.Insert("AccumulationRegister", AccumulationRegister);

	AccountingRegister = New Structure();
	AccountingRegister.Insert("AccountingRegisterRecord", "Record");
	AccountingRegister.Insert("AccountingRegisterExtDimensions", "ExtDimensions");
	AccountingRegister.Insert("AccountingRegisterRecordSet", "RecordSet");
	AccountingRegister.Insert("AccountingRegisterRecordKey", "RecordKey");
	AccountingRegister.Insert("AccountingRegisterSelection", "Selection");
	AccountingRegister.Insert("AccountingRegisterList", "List");
	AccountingRegister.Insert("AccountingRegisterManager", "Manager");
	MetaDataObject.Insert("AccountingRegister", AccountingRegister);

	BusinessProcess = New Structure();
	BusinessProcess.Insert("BusinessProcessObject", "Object");
	BusinessProcess.Insert("BusinessProcessRef", "Ref");
	BusinessProcess.Insert("BusinessProcessSelection", "Selection");
	BusinessProcess.Insert("BusinessProcessList", "List");
	BusinessProcess.Insert("BusinessProcessManager", "Manager");
	BusinessProcess.Insert("BusinessProcessRoutePointRef", "RoutePointRef");
	MetaDataObject.Insert("BusinessProcess", BusinessProcess);

	CalculationRegister = New Structure();
	CalculationRegister.Insert("CalculationRegisterRecord", "Record");
	CalculationRegister.Insert("CalculationRegisterManager", "Manager");
	CalculationRegister.Insert("CalculationRegisterSelection", "Selection");
	CalculationRegister.Insert("CalculationRegisterList", "List");
	CalculationRegister.Insert("CalculationRegisterRecordSet", "RecordSet");
	CalculationRegister.Insert("CalculationRegisterRecordKey", "RecordKey");
	CalculationRegister.Insert("RecalculationsManager", "Recalcs");
	MetaDataObject.Insert("CalculationRegister", CalculationRegister);

	Catalog = New Structure();
	Catalog.Insert("CatalogObject", "Object");
	Catalog.Insert("CatalogRef", "Ref");
	Catalog.Insert("CatalogSelection", "Selection");
	Catalog.Insert("CatalogList", "List");
	Catalog.Insert("CatalogManager", "Manager");
	MetaDataObject.Insert("Catalog", Catalog);

	ChartOfAccounts = New Structure();
	ChartOfAccounts.Insert("ChartOfAccountsObject", "Object");
	ChartOfAccounts.Insert("ChartOfAccountsRef", "Ref");
	ChartOfAccounts.Insert("ChartOfAccountsSelection", "Selection");
	ChartOfAccounts.Insert("ChartOfAccountsList", "List");
	ChartOfAccounts.Insert("ChartOfAccountsManager", "Manager");
	ChartOfAccounts.Insert("ChartOfAccountsExtDimensionTypes", "ExtDimensionTypes");
	ChartOfAccounts.Insert("ChartOfAccountsExtDimensionTypesRow", "ExtDimensionTypesRow");
	MetaDataObject.Insert("ChartOfAccounts", ChartOfAccounts);

	ChartOfCalculationTypes = New Structure();
	ChartOfCalculationTypes.Insert("ChartOfCalculationTypesObject", "Object");
	ChartOfCalculationTypes.Insert("ChartOfCalculationTypesRef", "Ref");
	ChartOfCalculationTypes.Insert("ChartOfCalculationTypesSelection", "Selection");
	ChartOfCalculationTypes.Insert("ChartOfCalculationTypesList", "List");
	ChartOfCalculationTypes.Insert("ChartOfCalculationTypesManager", "Manager");
	ChartOfCalculationTypes.Insert("DisplacingCalculationTypes", "DisplacingCalculationTypes");
	ChartOfCalculationTypes.Insert("DisplacingCalculationTypesRow", "DisplacingCalculationTypesRow");
	ChartOfCalculationTypes.Insert("BaseCalculationTypes", "BaseCalculationTypes");
	ChartOfCalculationTypes.Insert("BaseCalculationTypesRow", "BaseCalculationTypesRow");
	ChartOfCalculationTypes.Insert("LeadingCalculationTypes", "LeadingCalculationTypes");
	ChartOfCalculationTypes.Insert("LeadingCalculationTypesRow", "LeadingCalculationTypesRow");
	MetaDataObject.Insert("ChartOfCalculationTypes", ChartOfCalculationTypes);

	ChartOfCharacteristicTypes = New Structure();
	ChartOfCharacteristicTypes.Insert("ChartOfCharacteristicTypesObject", "Object");
	ChartOfCharacteristicTypes.Insert("ChartOfCharacteristicTypesRef", "Ref");
	ChartOfCharacteristicTypes.Insert("ChartOfCharacteristicTypesSelection", "Selection");
	ChartOfCharacteristicTypes.Insert("ChartOfCharacteristicTypesList", "List");
	ChartOfCharacteristicTypes.Insert("Characteristic", "Characteristic");
	ChartOfCharacteristicTypes.Insert("ChartOfCharacteristicTypesManager", "Manager");
	MetaDataObject.Insert("ChartOfCharacteristicTypes", ChartOfCharacteristicTypes);

	CommandGroup = New Structure();
	MetaDataObject.Insert("CommandGroup", CommandGroup);

	CommonAttribute = New Structure();
	MetaDataObject.Insert("CommonAttribute", CommonAttribute);

	CommonCommand = New Structure();
	MetaDataObject.Insert("CommonCommand", CommonCommand);

	CommonForm = New Structure();
	MetaDataObject.Insert("CommonForm", CommonForm);

	CommonModule = New Structure();
	MetaDataObject.Insert("CommonModule", CommonModule);

	CommonPicture = New Structure();
	MetaDataObject.Insert("CommonPicture", CommonPicture);

	CommonTemplate = New Structure();
	MetaDataObject.Insert("CommonTemplate", CommonTemplate);

	Constant = New Structure();
	Constant.Insert("ConstantManager", "Manager");
	Constant.Insert("ConstantValueManager", "ValueManager");
	Constant.Insert("ConstantValueKey", "ValueKey");
	MetaDataObject.Insert("Constant", Constant);

	DataProcessor = New Structure();
	DataProcessor.Insert("DataProcessorObject", "Object");
	DataProcessor.Insert("DataProcessorManager", "Manager");
	MetaDataObject.Insert("DataProcessor", DataProcessor);

	DefinedType = New Structure();
	DefinedType.Insert("DefinedType", "DefinedType");
	MetaDataObject.Insert("DefinedType", DefinedType);

	DocumentJournal = New Structure();
	DocumentJournal.Insert("DocumentJournalSelection", "Selection");
	DocumentJournal.Insert("DocumentJournalList", "List");
	DocumentJournal.Insert("DocumentJournalManager", "Manager");
	MetaDataObject.Insert("DocumentJournal", DocumentJournal);

	DocumentNumerator = New Structure();
	MetaDataObject.Insert("DocumentNumerator", DocumentNumerator);

	Document = New Structure();
	Document.Insert("DocumentObject", "Object");
	Document.Insert("DocumentRef", "Ref");
	Document.Insert("DocumentSelection", "Selection");
	Document.Insert("DocumentList", "List");
	Document.Insert("DocumentManager", "Manager");
	MetaDataObject.Insert("Document", Document);

	Enum = New Structure();
	Enum.Insert("EnumRef", "Ref");
	Enum.Insert("EnumManager", "Manager");
	Enum.Insert("EnumList", "List");
	MetaDataObject.Insert("Enum", Enum);

	EventSubscription = New Structure();
	MetaDataObject.Insert("EventSubscription", EventSubscription);

	ExchangePlan = New Structure();
	ExchangePlan.Insert("ExchangePlanObject", "Object");
	ExchangePlan.Insert("ExchangePlanRef", "Ref");
	ExchangePlan.Insert("ExchangePlanSelection", "Selection");
	ExchangePlan.Insert("ExchangePlanList", "List");
	ExchangePlan.Insert("ExchangePlanManager", "Manager");
	MetaDataObject.Insert("ExchangePlan", ExchangePlan);

	ExternalDataSource = New Structure();
	ExternalDataSource.Insert("ExternalDataSourceManager", "Manager");
	ExternalDataSource.Insert("ExternalDataSourceTablesManager", "TablesManager");
	ExternalDataSource.Insert("ExternalDataSourceCubesManager", "CubesManager");
	MetaDataObject.Insert("ExternalDataSource", ExternalDataSource);

	FilterCriterion = New Structure();
	FilterCriterion.Insert("FilterCriterionManager", "Manager");
	FilterCriterion.Insert("FilterCriterionList", "List");
	MetaDataObject.Insert("FilterCriterion", FilterCriterion);

	FunctionalOption = New Structure();
	MetaDataObject.Insert("FunctionalOption", FunctionalOption);

	FunctionalOptionsParameter = New Structure();
	MetaDataObject.Insert("FunctionalOptionsParameter", FunctionalOptionsParameter);

	HTTPService = New Structure();
	MetaDataObject.Insert("HTTPService", HTTPService);

	InformationRegister = New Structure();
	InformationRegister.Insert("InformationRegisterRecord", "Record");
	InformationRegister.Insert("InformationRegisterManager", "Manager");
	InformationRegister.Insert("InformationRegisterSelection", "Selection");
	InformationRegister.Insert("InformationRegisterList", "List");
	InformationRegister.Insert("InformationRegisterRecordSet", "RecordSet");
	InformationRegister.Insert("InformationRegisterRecordKey", "RecordKey");
	InformationRegister.Insert("InformationRegisterRecordManager", "RecordManager");
	MetaDataObject.Insert("InformationRegister", InformationRegister);

	Language = New Structure();
	MetaDataObject.Insert("Language", Language);

	Report = New Structure();
	Report.Insert("ReportObject", "Object");
	Report.Insert("ReportManager", "Manager");
	MetaDataObject.Insert("Report", Report);

	Role = New Structure();
	MetaDataObject.Insert("Role", Role);

	ScheduledJob = New Structure();
	MetaDataObject.Insert("ScheduledJob", ScheduledJob);

	Sequence = New Structure();
	Sequence.Insert("SequenceRecord", "Record");
	Sequence.Insert("SequenceManager", "Manager");
	Sequence.Insert("SequenceRecordSet", "RecordSet");
	MetaDataObject.Insert("Sequence", Sequence);

	SessionParameter = New Structure();
	MetaDataObject.Insert("SessionParameter", SessionParameter);

	SettingsStorage = New Structure();
	SettingsStorage.Insert("SettingsStorageManager", "Manager");
	MetaDataObject.Insert("SettingsStorage", SettingsStorage);

	StyleItem = New Structure();
	MetaDataObject.Insert("StyleItem", StyleItem);

	Style = New Structure();
	MetaDataObject.Insert("Style", Style);

	Subsystem = New Structure();
	MetaDataObject.Insert("Subsystem", Subsystem);

	Task = New Structure();
	Task.Insert("TaskObject", "Object");
	Task.Insert("TaskRef", "Ref");
	Task.Insert("TaskSelection", "Selection");
	Task.Insert("TaskList", "List");
	Task.Insert("TaskManager", "Manager");
	MetaDataObject.Insert("Task", Task);

	WebService = New Structure();
	MetaDataObject.Insert("WebService", WebService);

	Configuration = New Structure();
	MetaDataObject.Insert("Configuration", Configuration);

	Interface = New Structure();
	MetaDataObject.Insert("Interface", Interface);

	CatalogTabularSection = New Structure();
	CatalogTabularSection.Insert("CatalogTabularSection", "TabularSection");
	CatalogTabularSection.Insert("CatalogTabularSectionRow", "TabularSectionRow");
	MetaDataObject.Insert("CatalogTabularSection", CatalogTabularSection);

	Return MetaDataObject;
EndFunction

Function MetaDataObjectNames() Export
	Structure = New Map();
	Structure.Insert(Enums.MetadataTypes.AccountingRegister, "AccountingRegisters");
	Structure.Insert(Enums.MetadataTypes.AccumulationRegister, "AccumulationRegisters");
	Structure.Insert(Enums.MetadataTypes.BusinessProcess, "BusinessProcesses");
	Structure.Insert(Enums.MetadataTypes.CalculationRegister, "CalculationRegisters");
	Structure.Insert(Enums.MetadataTypes.Catalog, "Catalogs");
	Structure.Insert(Enums.MetadataTypes.ChartOfAccounts, "ChartsOfAccounts");
	Structure.Insert(Enums.MetadataTypes.ChartOfCalculationTypes, "ChartsOfCalculationTypes");
	Structure.Insert(Enums.MetadataTypes.ChartOfCharacteristicTypes, "ChartsOfCharacteristicTypes");
	Structure.Insert(Enums.MetadataTypes.CommonAttribute, "CommonAttributes");
	Structure.Insert(Enums.MetadataTypes.CommonCommand, "CommonCommands");
	Structure.Insert(Enums.MetadataTypes.CommonForm, "CommonForms");
	Structure.Insert(Enums.MetadataTypes.Constant, "Constants");
	Structure.Insert(Enums.MetadataTypes.DataProcessor, "DataProcessors");
	Structure.Insert(Enums.MetadataTypes.DocumentJournal, "DocumentJournals");
	Structure.Insert(Enums.MetadataTypes.Document, "Documents");
	Structure.Insert(Enums.MetadataTypes.ExchangePlan, "ExchangePlans");
	Structure.Insert(Enums.MetadataTypes.FilterCriterion, "FilterCriteria");
	Structure.Insert(Enums.MetadataTypes.HTTPService, "HTTPServices");
	Structure.Insert(Enums.MetadataTypes.InformationRegister, "InformationRegisters");
	Structure.Insert(Enums.MetadataTypes.Report, "Reports");
	Structure.Insert(Enums.MetadataTypes.Sequence, "Sequences");
	Structure.Insert(Enums.MetadataTypes.SessionParameter, "SessionParameters");
	Structure.Insert(Enums.MetadataTypes.Subsystem, "Subsystems");
	Structure.Insert(Enums.MetadataTypes.Task, "Tasks");
	Structure.Insert(Enums.MetadataTypes.WebService, "WebServices");
	Structure.Insert(Enums.MetadataTypes.Role, "Roles");
	Structure.Insert(Enums.MetadataTypes.ExternalDataSource, "ExternalDataSources");
	Structure.Insert(Enums.MetadataTypes.Enum, "Enums");
	Structure.Insert(Enums.MetadataTypes.Interface, "Interfaces");
	Structure.Insert(Enums.MetadataTypes.Language, "Languages");

	Return Structure;
EndFunction

Function MetadataInfo() Export

	Structure = MetaDataObjectNames();
	MetaStructure = New Map();
	For Each Row In Structure Do
		ValueList = New ValueList();
		For Each Data In Metadata[Row.Value] Do
			ValueList.Add(Data.Name, Data.Synonym);
		EndDo;
		MetaStructure.Insert(Row.Key, ValueList);
	EndDo;
	Return MetaStructure;
EndFunction

Function hasAttributes(MetaName) Export
	Array = New Array();
	Array.Add(Enums.MetadataTypes.Catalog);
	Array.Add(Enums.MetadataTypes.Document);
	Array.Add(Enums.MetadataTypes.Task);
	Array.Add(Enums.MetadataTypes.DataProcessor);
	Array.Add(Enums.MetadataTypes.Report);
	Array.Add(Enums.MetadataTypes.ChartOfCalculationTypes);
	Array.Add(Enums.MetadataTypes.ChartOfCharacteristicTypes);
	Array.Add(Enums.MetadataTypes.ExchangePlan);
	Array.Add(Enums.MetadataTypes.ChartOfAccounts);
	Array.Add(Enums.MetadataTypes.AccountingRegister);
	Array.Add(Enums.MetadataTypes.AccumulationRegister);
	Array.Add(Enums.MetadataTypes.CalculationRegister);
	Array.Add(Enums.MetadataTypes.InformationRegister);
	Array.Add(Enums.MetadataTypes.BusinessProcess);

	Return Not Array.Find(MetaName) = Undefined;
EndFunction

Function hasCommands(MetaName) Export
	Array = New Array();
	Array.Add(Enums.MetadataTypes.BusinessProcess);
	Array.Add(Enums.MetadataTypes.Catalog);
	Array.Add(Enums.MetadataTypes.Document);
	Array.Add(Enums.MetadataTypes.DocumentJournal);
	Array.Add(Enums.MetadataTypes.Task);
	Array.Add(Enums.MetadataTypes.FilterCriterion);
	Array.Add(Enums.MetadataTypes.DataProcessor);
	Array.Add(Enums.MetadataTypes.Report);
	Array.Add(Enums.MetadataTypes.ChartOfCalculationTypes);
	Array.Add(Enums.MetadataTypes.ChartOfCharacteristicTypes);
	Array.Add(Enums.MetadataTypes.ExchangePlan);
	Array.Add(Enums.MetadataTypes.ChartOfAccounts);
	Array.Add(Enums.MetadataTypes.AccountingRegister);
	Array.Add(Enums.MetadataTypes.AccumulationRegister);
	Array.Add(Enums.MetadataTypes.CalculationRegister);
	Array.Add(Enums.MetadataTypes.InformationRegister);
	Array.Add(Enums.MetadataSubtype.Table);
	Array.Add(Enums.MetadataSubtype.DimensionTable);
	Array.Add(Enums.MetadataSubtype.Cube);
	Return Not Array.Find(MetaName) = Undefined;
EndFunction

Function hasDimensions(MetaName) Export
	Array = New Array();
	Array.Add(Enums.MetadataTypes.AccountingRegister);
	Array.Add(Enums.MetadataTypes.AccumulationRegister);
	Array.Add(Enums.MetadataTypes.CalculationRegister);
	Array.Add(Enums.MetadataTypes.InformationRegister);
	Array.Add(Enums.MetadataTypes.Sequence);
	Array.Add(Enums.MetadataSubtype.Cube);

	Return Not Array.Find(MetaName) = Undefined;
EndFunction

Function hasResources(MetaName) Export
	Array = New Array();
	Array.Add(Enums.MetadataTypes.AccumulationRegister);
	Array.Add(Enums.MetadataTypes.CalculationRegister);
	Array.Add(Enums.MetadataTypes.InformationRegister);
	Array.Add(Enums.MetadataTypes.AccountingRegister);
	Array.Add(Enums.MetadataSubtype.Cube);

	Return Not Array.Find(MetaName) = Undefined;
EndFunction

Function hasStandardAttributes(MetaName) Export
	Array = New Array();
	Array.Add(Enums.MetadataTypes.Catalog);
	Array.Add(Enums.MetadataTypes.Document);
	Array.Add(Enums.MetadataTypes.DocumentJournal);
	Array.Add(Enums.MetadataTypes.Task);
	Array.Add(Enums.MetadataTypes.ChartOfCalculationTypes);
	Array.Add(Enums.MetadataTypes.ChartOfCharacteristicTypes);
	Array.Add(Enums.MetadataTypes.ExchangePlan);
	Array.Add(Enums.MetadataTypes.ChartOfAccounts);
	Array.Add(Enums.MetadataTypes.AccountingRegister);
	Array.Add(Enums.MetadataTypes.AccumulationRegister);
	Array.Add(Enums.MetadataTypes.CalculationRegister);
	Array.Add(Enums.MetadataTypes.InformationRegister);
	Array.Add(Enums.MetadataTypes.BusinessProcess);
	Return Not Array.Find(MetaName) = Undefined;
EndFunction

Function hasTabularSections(MetaName) Export
	Array = New Array();
	Array.Add(Enums.MetadataTypes.Catalog);
	Array.Add(Enums.MetadataTypes.Document);
	Array.Add(Enums.MetadataTypes.Task);
	Array.Add(Enums.MetadataTypes.DataProcessor);
	Array.Add(Enums.MetadataTypes.Report);
	Array.Add(Enums.MetadataTypes.ChartOfCalculationTypes);
	Array.Add(Enums.MetadataTypes.ChartOfCharacteristicTypes);
	Array.Add(Enums.MetadataTypes.ExchangePlan);
	Array.Add(Enums.MetadataTypes.ChartOfAccounts);
	Array.Add(Enums.MetadataTypes.BusinessProcess);
	Return Not Array.Find(MetaName) = Undefined;
EndFunction

Function hasRecalculations(MetaName) Export
	Array = New Array();
	Array.Add(Enums.MetadataTypes.CalculationRegister);
	Return Not Array.Find(MetaName) = Undefined;
EndFunction

Function hasAccountingFlags(MetaName) Export
	Array = New Array();
	Array.Add(Enums.MetadataTypes.ChartOfAccounts);
	Return Not Array.Find(MetaName) = Undefined;
EndFunction

Function hasExtDimensionAccountingFlags(MetaName) Export
	Array = New Array();
	Array.Add(Enums.MetadataTypes.ChartOfAccounts);
	Return Not Array.Find(MetaName) = Undefined;
EndFunction

Function hasStandardTabularSections(MetaName) Export
	Array = New Array();
	Array.Add(Enums.MetadataTypes.ChartOfCalculationTypes);
	Return Not Array.Find(MetaName) = Undefined;
EndFunction

Function hasAddressingAttributes(MetaName) Export
	Array = New Array();
	Array.Add(Enums.MetadataTypes.Task);
	Return Not Array.Find(MetaName) = Undefined;
EndFunction

Function hasURLTemplates(MetaName) Export
	Array = New Array();
	Array.Add(Enums.MetadataTypes.HTTPService);
	Return Not Array.Find(MetaName) = Undefined;
EndFunction

Function hasCubes(MetaName) Export
	Array = New Array();
	Array.Add(Enums.MetadataTypes.ExternalDataSource);
	Return Not Array.Find(MetaName) = Undefined;
EndFunction

Function hasTables(MetaName) Export
	Array = New Array();
	Array.Add(Enums.MetadataTypes.ExternalDataSource);
	Return Not Array.Find(MetaName) = Undefined;
EndFunction

Function hasFields(MetaName) Export
	Array = New Array();
	Array.Add(Enums.MetadataSubtype.Table);
	Array.Add(Enums.MetadataSubtype.DimensionTable);
	Return Not Array.Find(MetaName) = Undefined;
EndFunction

Function hasDimensionTables(MetaName) Export
	Array = New Array();
	Array.Add(Enums.MetadataSubtype.Cube);
	Return Not Array.Find(MetaName) = Undefined;
EndFunction

Function hasFunctions(MetaName) Export
	Array = New Array();
	Array.Add(Enums.MetadataTypes.ExternalDataSource);
	Return Not Array.Find(MetaName) = Undefined;
EndFunction

Function hasOperations(MetaName) Export
	Array = New Array();
	Array.Add(Enums.MetadataTypes.WebService);
	Return Not Array.Find(MetaName) = Undefined;
EndFunction

Function isSubsystem(MetaName) Export
	Array = New Array();
	Array.Add(Enums.MetadataTypes.Subsystem);
	Return Not Array.Find(MetaName) = Undefined;
EndFunction

Function hasOnlyProperties(RefData) Export
	Array = New Array();
	Array.Add(Enums.MetadataSubtype.Attribute);
	Array.Add(Enums.MetadataSubtype.Dimension);
	Array.Add(Enums.MetadataSubtype.Resource);
	Array.Add(Enums.MetadataSubtype.Command);
	Array.Add(Enums.MetadataSubtype.AccountingFlag);
	Array.Add(Enums.MetadataSubtype.ExtDimensionAccountingFlag);
	Array.Add(Enums.MetadataSubtype.AddressingAttribute);

	Return Not Array.Find(RefData) = Undefined;
EndFunction

Function hasNoChildObjects(RefData) Export
	Array = New Array();
	Array.Add(Enums.MetadataTypes.SessionParameter);
	Array.Add(Enums.MetadataTypes.CommonCommand);
	Array.Add(Enums.MetadataTypes.CommonAttribute);
	Array.Add(Enums.MetadataTypes.CommonForm);
	Array.Add(Enums.MetadataTypes.Constant);
	Array.Add(Enums.MetadataTypes.Language);
	Array.Add(Enums.MetadataTypes.Interface);
	Return Not Array.Find(RefData) = Undefined;
EndFunction

Function hasNoInternalInfo(RefData) Export
	Array = New Array();
	Array.Add(Enums.MetadataTypes.CommonCommand);
	Array.Add(Enums.MetadataTypes.Subsystem);
	Array.Add(Enums.MetadataTypes.SessionParameter);
	Array.Add(Enums.MetadataTypes.CommonAttribute);
	Array.Add(Enums.MetadataTypes.CommonForm);
	Array.Add(Enums.MetadataTypes.Language);
	Return Not Array.Find(RefData) = Undefined;
EndFunction

Function EnumNameByRef(RefData) Export
	RefNameType = RefData.Metadata().Name;
	ValueIndex = Enums[RefNameType].IndexOf(RefData);
	Return Metadata.Enums[RefNameType].EnumValues[ValueIndex].Name;
EndFunction

#EndRegion