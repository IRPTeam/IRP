
Procedure SetVisible(Object, Form) Export
	IsStandard = Object.Kind = PredefinedValue("Enum.AgreementKinds.Standard");
	IsRegular  = Object.Kind = PredefinedValue("Enum.AgreementKinds.Regular");
	ApArByStandardAgreements = Object.ApArPostingDetail = PredefinedValue("Enum.ApArPostingDetail.ByStandardAgreement");
	ApArByDocuments          = Object.ApArPostingDetail = PredefinedValue("Enum.ApArPostingDetail.ByDocuments");
	
	IsCustomer = Object.Type = PredefinedValue("Enum.AgreementTypes.Customer");
	
	Form.Items.ItemSegment.Visible = IsCustomer;	
	
	Form.Items.StandardAgreement.Visible = ApArByStandardAgreements;
	
	Form.Items.ApArPostingDetail.ReadOnly       = IsStandard;
	Form.Items.PriceType.Visible                = IsRegular;
	Form.Items.PriceIncludeTax.Visible          = IsRegular;
	Form.Items.NumberDaysBeforeShipment.Visible = IsRegular;
	Form.Items.Store.Visible                    = IsRegular;
	Form.Items.Type.Visible                     = IsRegular;
	Form.Items.UseCreditLimit.ReadOnly = Not IsCustomer;
	Form.Items.CreditLimitAmount.Visible            = Object.UseCreditLimit And IsCustomer;
	Form.Items.CurrencyMovementTypeCurrency.Visible = Object.UseCreditLimit And IsCustomer;
	Form.Items.PaymentTerm.Visible = ApArByDocuments And IsCustomer;
EndProcedure